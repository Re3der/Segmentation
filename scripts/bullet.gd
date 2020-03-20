class_name Bullet
extends Area2D

var livetime:float
var anim_time:float
var demige:int
var group:String
var speed:int
var vel:Vector2
var hit:bool

onready var live_timer:=$live_timer
onready var anim_timer:=$anim_timer

func _ready() -> void:
	hide()
	monitoring=false
	set_process(false)

func use(pos:Vector2,rot:float,deployd:bool)->void:
	show()
	hit=false
	monitoring=true
	$img.frame=0
	position=pos
	rotation=rot
	vel=Vector2(speed+(0.0 if deployd else rand_range(0,speed/5.0)),0).rotated(rot)
	live_timer.start(livetime)
	set_process(true)

func _process(delta: float) -> void:
	position+=vel*delta

func _on_live_timer_timeout() -> void:
	set_process(false)
	explode(anim_time)

func explode(time):
	var frames=$img.hframes
	for i in frames:
		$img.frame=i
		anim_timer.start(time/frames)
		yield(anim_timer,"timeout")
	_ready()


func _on_bullet_area_entered(area: Area2D) -> void:
	if hit or area.is_in_group(group) or not area.has_method("hit"):return
	hit=true
	live_timer.stop()
	_on_live_timer_timeout()
	area.hit(demige)
