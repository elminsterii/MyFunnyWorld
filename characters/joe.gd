extends RigidBody2D

@onready var sprite = $Image
@export var char_data: CharacterData

# 拖拽相關變數
var drag_start_pos: Vector2
var is_dragging: bool = false
@export var launch_speed: float = 10.0  # 彈射速度系數
@export var hit_force: float = 800.0    # 擊打目標的力量

func _ready():
	# 初始化物理材質與圖片 (維持你原本的邏輯)
	if char_data:
		mass = char_data.mass
		physics_material_override = PhysicsMaterial.new()
		physics_material_override.friction = char_data.friction
		physics_material_override.bounce = char_data.bounce
		lock_rotation = char_data.lock_rotation
		if char_data.freeze_position:
			freeze = true
			
		if char_data.character_image:
			sprite.texture = char_data.character_image
	
	# 確保開啟碰撞監測
	contact_monitor = true
	max_contacts_reported = 5
	body_entered.connect(_on_body_entered)

#func _input(event):
	#if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		#if event.pressed:
			#is_dragging = true
			#drag_start_pos = get_global_mouse_position()
			## 播放「準備揮棒」動畫
			#if has_node("AnimationPlayer"):
				#$AnimationPlayer.play("prepare_attack") 
		#else:
			#if is_dragging:
				#is_dragging = false
				#var drag_end_pos = get_global_mouse_position()
				## 計算彈射向量：(起點 - 終點) = 拉越長噴越遠
				#var launch_vector = (drag_start_pos - drag_end_pos) * launch_speed
				#
				## 執行彈射
				#apply_central_impulse(launch_vector)
				#
				## 播放「揮棒」動畫
				#if has_node("AnimationPlayer"):
					#$AnimationPlayer.play("attack")

func _on_body_entered(body: Node):
	# 這裡改為：如果我在高速移動中撞到別人，就給對方一個額外的力
	if body is RigidBody2D:
		# 獲取我目前衝刺的方向（利用線性速度向量）
		var strike_direction = linear_velocity.normalized()
		
		# 如果我幾乎沒在動，就不觸發強力擊打
		if linear_velocity.length() > 50:
			# 給予目標一個更強的衝擊
			body.apply_central_impulse(strike_direction * hit_force)
			print("Joe 成功擊打目標：", body.name, ", Force:", strike_direction * hit_force)
			
			# (可選) 擊中時稍微減慢自己的速度，模擬反作用力
			linear_velocity *= 0.8
