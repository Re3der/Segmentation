class_name Drop
extends Area2D

var value:=1

onready var tween=Global.general_purpose_tween

func _ready() -> void:
	pass


func _on_drop_area_entered(area: Area2D) -> void:
	if not area.is_in_group("player"):return
	pick_up()
	$shape.shape=null

func pick_up()->void:
	tween.interpolate_property(self,"modulate",modulate,Color.transparent,.5,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.interpolate_property(self,"scale",scale,scale*2,.5,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	yield(get_tree().create_timer(.5),"timeout")
	queue_free()

func spawn(pos:Vector2)->void:
	position=pos
