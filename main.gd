extends Node2D

# 增加 accel 參數
signal stats_updated(dist: float, height: float, speed: float, accel: float)

@onready var character = $Character
@onready var hud = $HUD

var start_pos: Vector2
var last_velocity: Vector2 = Vector2.ZERO # 用來存上一影格的速度

func _ready() -> void:
	if character and hud:
		start_pos = character.global_position
		# 連接信號到 HUD 的接收端
		self.stats_updated.connect(hud._on_stats_updated)

func _physics_process(delta: float) -> void:
	if not character: return
	
	# 1. 計算基本數值
	var dist = (character.global_position.x - start_pos.x) / 10.0
	var height = (start_pos.y - character.global_position.y) / 10.0
	
	# 2. 計算速度 (linear_velocity 是 Vector2)
	var current_velocity = character.linear_velocity
	var speed = current_velocity.length() / 5.0
	
	# 3. 計算加速度 (速度變化量 / 時間差)
	# 我們取向量差的長度，代表整體的加速度大小
	var velocity_change = current_velocity - last_velocity
	var accel = (velocity_change.length() / delta) / 10.0
	
	# 如果速度幾乎沒變，強制歸零避免浮點數抖動
	if velocity_change.length() < 0.1:
		accel = 0.0
		
	# 4. 發送信號
	stats_updated.emit(dist, height, speed, accel)
	
	# 5. 紀錄當前速度，供下一影格使用
	last_velocity = current_velocity
