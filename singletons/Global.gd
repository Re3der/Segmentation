extends Node


onready var general_purpose_tween:=Tween.new()

func _ready() -> void:
	add_child(general_purpose_tween)

func create_drop(scene:Resource,pos:Vector2)->void:
	var s=scene.instance()
	s.spawn(pos)
	call_deferred("add_child",s)


