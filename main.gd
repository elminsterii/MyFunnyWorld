extends Node2D

# 增加 accel 參數
signal stats_updated(dist: float, height: float, speed: float, accel: float)

@onready var joe = $Event_Joe
@onready var character = $Character
@onready var ground_node = $Ground/PhysicalGround
@onready var hud = $HUD

var start_pos: Vector2
var last_velocity: Vector2 = Vector2.ZERO # 用來存上一影格的速度
var char_height_offset: int

func _ready() -> void:
	if character.get_char_data():
		var char_data = character.get_char_data()
		char_height_offset = char_data.body_height / 2.0
		
	# 1. 取得節點
	var camera = $Character/Camera2D
	
	# 2. 自動設定 Limit
	# global_position.y 就是地板在世界中的絕對高度
	camera.limit_bottom = ground_node.global_position.y
	
	# 3. 額外保險：讓攝影機不要拍到太左邊（起點）
	camera.limit_left = 0
	
	if character and hud:
		start_pos = character.global_position
		# 連接信號到 HUD 的接收端
		self.stats_updated.connect(hud._on_stats_updated)
		
	setup_connection()

func setup_connection():
	if is_instance_valid(character) and is_instance_valid(joe):
		# 直接把施力者的訊號「插」進受力者的函式裡
		# 這樣當 force_released 發出時，會直接帶著 Vector2 參數去跑 apply_launch_force
		joe.force_released.connect(character.apply_launch_force)
		#force_controller.aim_started.connect(character.prepare_attack)
		print("物理連線已建立：", joe.name, " -> ", character.name)

func _physics_process(_delta: float) -> void:
	if not character: return
	
	# 1. 計算基本數值
	var dist = (character.global_position.x - start_pos.x) / 10.0
	var current_feet_y = character.global_position.y + char_height_offset
	var height = ground_node.global_position.y - current_feet_y
	
	# 2. 計算速度 (linear_velocity 是 Vector2)
	var current_velocity = character.linear_velocity
	var speed = current_velocity.length() / 5.0
	
	# 3. 計算加速度 (速度變化量 / 時間差)
	# 我們取向量差的長度，代表整體的加速度大小
	#var velocity_change = current_velocity - last_velocity
	#var accel = (velocity_change.length() / delta) / 10.0
	
	# 如果速度幾乎沒變，強制歸零避免浮點數抖動
	#if velocity_change.length() < 0.1:
		#accel = 0.0
		
	# 4. 發送信號
	stats_updated.emit(dist, height, speed)
	
	# 5. 紀錄當前速度，供下一影格使用
	last_velocity = current_velocity
