class_name PlayerBody
extends Body


func _ready() -> void:
	for i in get_children():
		i.is_player=true

func control(delta)->Vector2:
	if Input.is_action_pressed("m_left") and not selected:
		emit_signal("fire",true)
	if Input.is_action_pressed("ui_left"):
		dir-=steer_speed*delta
	if Input.is_action_pressed("ui_right"):
		dir+=steer_speed*delta
	if Input.is_action_pressed("ui_up"):
		vel+=movement
	vel-=vel*.1
	return Vector2(vel,0).rotated(dir)*delta
