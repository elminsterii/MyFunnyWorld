# event_node.gd
@tool
extends Area2D
class_name EventNode

signal force_released(force_vector: Vector2)

#@onready var anim = $AnimationPlayer	
@onready var sprite = $Image
@export var event_data: EventData

var drag_start_pos: Vector2
var is_dragging: bool = false
@export var max_drag_distance: float = 200.0 # 限制最大拉動距離

func _ready():
	if event_data.event_image:
		sprite.texture = event_data.event_image

func get_event_data():
	return event_data

# 這裡寫所有事件共用的邏輯 (例如：被 Joe 撞到後消失)
func _on_body_entered(body):
	if body is RigidBody2D: # 假設 Joe 是 RigidBody2D
		_on_triggered(body)

func _on_triggered(_target):
	queue_free()

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
			var final_force = drag_vector * event_data.power_multiplier
			
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
