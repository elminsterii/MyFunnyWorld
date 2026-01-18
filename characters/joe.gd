extends RigidBody2D

signal force_released(force_vector: Vector2)

@onready var sprite = $Image
@export var char_data: CharacterData

# 拖拽相關變數
var drag_start_pos: Vector2
var is_dragging: bool = false
@export var power_multiplier: float = 10.0
@export var max_drag_distance: float = 200.0 # 限制最大拉動距離

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

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			is_dragging = true
			drag_start_pos = get_global_mouse_position()
			#emit_signal("aim_started")
			
		elif is_dragging: # 放開滑鼠
			is_dragging = false
			var drag_end_pos = get_global_mouse_position()
			
			# 1. 計算向量
			var drag_vector = drag_start_pos - drag_end_pos
			
			# 2. 限制最大拉動距離 (Clamp)
			if drag_vector.length() > max_drag_distance:
				drag_vector = drag_vector.normalized() * max_drag_distance
			
			# 3. 算出最終力道
			var final_force = drag_vector * power_multiplier
			
			# 4. 發射訊號！(把炸彈丟出去，誰接都不關我的事)
			emit_signal("force_released", final_force)
			
			# 清除畫線 (如果有做視覺效果)
			queue_redraw()

func _process(_delta):
	if is_dragging:
		queue_redraw() # 讓 _draw() 每幀更新

# 視覺化：畫出拖曳線 (這是施力者的責任)
func _draw():
	if is_dragging:
		var current_pos = get_global_mouse_position()
		# 畫一條從起點到滑鼠位置的線
		draw_line(to_local(drag_start_pos), to_local(current_pos), Color.WHITE, 2.0)

#func _on_body_entered(body: Node):
	## 這裡改為：如果我在高速移動中撞到別人，就給對方一個額外的力
	#if body is RigidBody2D:
		## 獲取我目前衝刺的方向（利用線性速度向量）
		#var strike_direction = linear_velocity.normalized()
		#
		## 如果我幾乎沒在動，就不觸發強力擊打
		#if linear_velocity.length() > 50:
			## 給予目標一個更強的衝擊
			#body.apply_central_impulse(strike_direction * hit_force)
			#print("Joe 成功擊打目標：", body.name, ", Force:", strike_direction * hit_force)
			#
			## (可選) 擊中時稍微減慢自己的速度，模擬反作用力
			#linear_velocity *= 0.8
