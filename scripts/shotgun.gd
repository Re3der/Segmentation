class_name Shotgun
extends TurretSegment

export (float) var spread=0

func _ready() -> void:
	pass # Replace with function body.

func shoot(from_signal:=false)->void:
	if not loadet or (deployed and from_signal):return
	turret.global_rotation+=rand_range(-accuracy,+accuracy)
	for i in shot:
		var b=get_object_from_pool()
		b.use(muzzle.global_position,turret.global_rotation+rand_range(-spread,spread))
	loadet=false
	reload_timer.start(reload_speed)
	shoot_animation()
