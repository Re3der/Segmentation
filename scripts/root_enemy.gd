extends Node2D

export (int) var wiew_range

var group:="enemyes"

onready var shape=$wiew/shape

func _ready() -> void:
	add_to_group(group)
	shape.shape.radius=wiew_range

func _process(delta: float) -> void:
	for a in $wiew.get_overlapping_areas():
		if a.is_in_group(group) or not a.has_method("hit"):continue
		$body.target=a
		return
	$body.target=null

