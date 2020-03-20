class_name Segment
extends Area2D

export (int) var max_health:=100

var group:String
var end:bool
var deployed:bool
var chacked:bool
var is_player:bool
var f_speed:=200
var base:float
var j1:Vector2
var j2:Vector2
var velocity:Vector2


signal death(s)


onready var health:int=max_health setget set_health
onready var parent:=get_parent()
onready var img:=$img
onready var joint:=$joint
onready var bar_pivot:=$img/pivot
onready var bar:=$img/pivot/bar
onready var bar_timer:=$img/pivot/timer
onready var tween:=Global.general_purpose_tween

func set_health(value:int)->void:
	health=value
	bar.value=health

func _ready()->void:
		
	bar.max_value=max_health
	connect("death",parent,"on_segment_died")
	$shape.shape=RectangleShape2D.new()
	$shape.shape.extents=img.get_rect().size/2.2*scale

func _process(delta: float) -> void:
	bar_pivot.global_rotation=0
func _physics_process(delta: float) -> void:
	bar_pivot.global_rotation=0

func hit(demige:=1)->void:
	set_health(health-demige)
	show_bar()
	tween.interpolate_property(self,"modulate",Color.red,Color.white,.3,Tween.TRANS_CUBIC,Tween.EASE_OUT)
	tween.start()
	if health<1:
		emit_signal("death",self)

func show_bar()->void:
	tween.interpolate_property(bar,"modulate",bar.modulate,Color.white,.2,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	bar_timer.start(3)
	yield(bar_timer,"timeout")
	tween.interpolate_property(bar,"modulate",Color.white,Color.transparent,.2,Tween.TRANS_LINEAR,Tween.EASE_IN)
	tween.start()
	
func build(pos:Vector2,base:int,rot:int)->void:
	j1=pos
	self.base=base
	j2=pos-Vector2(base,0).rotated(rot)
	position=j1+(j2-j1)/2
	rotation=(j1-j2).angle()
	$joint.position.x=base/2

func move(vel:Vector2,front:Vector2,egen:bool,delta:float)->Vector2:
	var rot:=(j1-j2).angle()
	velocity=vel.rotated(rot)/delta
	position=j1+(j2-j1)/2
	rotation=rot
	j1+=vel.rotated(rot)
	vel=Vector2(vel.x+base-sqrt(base*base-vel.y*vel.y),0).rotated(rot)
	j2+=vel
	if not egen:
		return vel
	if front and front.distance_to(j1)>f_speed/100:
		var home_vel:=Vector2(f_speed,0).rotated((j1-j2).angle_to(front-j1))*delta
		return vel+move(home_vel,front,false,delta)
	return vel

func set_pos(pos:Vector2)->void:
	var vec:=Vector2(base/2,0).rotated(rotation)
	j1=pos+vec
	j2=pos-vec

func push(force:Vector2)->void:
	j1+=force
	j2+=force




func _on_segment_area_shape_entered(area_id: int, area: Area2D, area_shape: int, self_shape: int) -> void:
	pass # Replace with function body.
