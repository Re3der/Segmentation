class_name Player
extends Node2D

export (float) var min_zoom=.5
export (float) var max_zoom=2
export (float) var sensitivity=.5

var group:="player"

onready var cam=$cam
onready var cam_smoother=$cam/smoother

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index==BUTTON_WHEEL_DOWN:
			smooth_zoom(cam.zoom.x+sensitivity)
		if event.button_index==BUTTON_WHEEL_UP:
			smooth_zoom(cam.zoom.x-sensitivity)

func smooth_zoom(step:float)->void:
	step=clamp(step,min_zoom,max_zoom)
	cam_smoother.interpolate_property(cam,"zoom",cam.zoom,Vector2(step,step),.2,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	cam_smoother.start()
