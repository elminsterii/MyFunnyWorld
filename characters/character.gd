extends RigidBody2D

@export var char_data: CharacterData
@export var launch_speed: float = 2.0
var is_dragging: bool = false
var drag_start_pos: Vector2

func get_char_data():
	return char_data

func _ready():
	if char_data:
		mass = char_data.mass
		physics_material_override = PhysicsMaterial.new()
		physics_material_override.friction = char_data.friction
		physics_material_override.bounce = char_data.bounce

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				# 開始拉動
				is_dragging = true
				drag_start_pos = get_global_mouse_position()
			else:
				# 放開彈射
				is_dragging = false
				var drag_end_pos = get_global_mouse_position()
				var launch_vector = (drag_start_pos - drag_end_pos) * launch_speed
				
				# 施加一個瞬間的力
				apply_central_impulse(launch_vector)

#func _integrate_forces(state):
	## 如果你想限制最大速度，可以在這裡寫
	#if state.linear_velocity.length() > 1500:
		#state.linear_velocity = state.linear_velocity.normalized() * 1500
