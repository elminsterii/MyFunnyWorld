# character.gd
extends RigidBody2D

@onready var anim = $AnimationPlayer
@onready var sprite = $Image
@export var char_data: CharacterData

func get_char_data():
	return char_data

func _ready():
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

# --- 公開接口 (Public Interface) ---
func apply_launch_force(force: Vector2):
	print("收到指令，準備執行力道：", force)
	
	# 決定怎麼「演出」這個受力過程
	if has_node("AnimationPlayer"):
		anim.play("attack") # 播放動畫，動畫會在適當時機呼叫 execute_physics
	else:
		_execute_physics(force) # 沒有動畫就直接飛

func _execute_physics(force: Vector2):
	freeze = false
	apply_central_impulse(force)
