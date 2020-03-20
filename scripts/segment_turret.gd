class_name TurretSegment
extends DeployableSegment

export (PackedScene) var bullet_scene
export (float) var reload_speed=1
export (float) var turret_speed=3
export (float) var bullet_livetime=1
export (float) var bullet_anim_time=.2
export (float) var accuracy=.1
export (int) var bullet_speed=100
export (int) var shot=1
export (int) var bullet_demige=1

var loadet:=true

onready var view:=$view
onready var turret:=$turret
onready var view_shape=$view/shape
onready var muzzle:=$turret/muzzle
onready var reload_timer:=$reload_timer
onready var muzzle_exp:=$turret/muzzle_exp

onready var pool_size:int=shot*ceil((bullet_livetime+bullet_anim_time+.1)/reload_speed)
onready var view_radius=bullet_speed*bullet_livetime+turret.offset.x+muzzle.position.x

func _ready() -> void:
	view.monitoring=group=="enemyes"
	parent.connect("fire",self,"shoot")
	view_shape.shape.radius=view_radius
	create_pool(pool_size)

func _process(delta: float) -> void:
	if not deployed and not group=="enemyes":
		turn_to(get_global_mouse_position(),delta)
	else:
		var target=get_target()
		if target:
			turn_to(aim(target),delta)
			if Vector2(1,0).rotated(turret.global_rotation).angle_to(target.position-position)<.5:
				shoot()

func turn_to(pos:Vector2,delta:float)->void:
	turret.global_rotation=lerp_angle(turret.global_rotation,(pos-position).angle(),turret_speed*delta)

func aim(target:Area2D)->Vector2:
	var t=(target.position-position).length()/bullet_speed*1.2
	return target.position+target.velocity*t

func get_target()->Area2D:
	var dist=view_radius
	var res:Area2D
	for a in view.get_overlapping_areas():
		if a.is_in_group(group):continue
		var d=position.distance_to(a.position)
		if d<dist:
			res=a
			dist=d
	return res

func shoot(from_signal:=false)->void:
	if not loadet or (deployed and from_signal):return
	var b=get_object_from_pool()
	if not deployed:
		turret.global_rotation+=rand_range(-accuracy,+accuracy)
	b.use(muzzle.global_position,turret.global_rotation,deployed)
	loadet=false
	reload_timer.start(reload_speed)
	shoot_animation()

func create_pool(size:int)->void:
	for i in range(size):
		var b=bullet_scene.instance()
		b.livetime=bullet_livetime
		b.speed=bullet_speed
		b.anim_time=bullet_anim_time
		b.demige=bullet_demige
		b.group=group
		reload_timer.add_child(b)

func get_object_from_pool()->Node:
	var pulled_obj:=reload_timer.get_child(0)
	reload_timer.move_child(pulled_obj,pool_size)
	return pulled_obj

func _on_reload_timer_timeout() -> void:
	loadet=true

func shoot_animation():
	tween.interpolate_property(turret,"offset",Vector2(4,0),turret.offset,reload_speed,Tween.TRANS_CUBIC,Tween.EASE_IN)
	muzzle_exp.show()
	tween.start()
	yield(get_tree().create_timer(.05),"timeout")
	muzzle_exp.hide()


func deploy()->void:
	.deploy()
	view.monitoring=true

func pick_up()->void:
	.pick_up()
	view.monitoring=false

