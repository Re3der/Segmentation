class_name EnemyBody
extends Body

export (PackedScene) var drop_scene=preload("res://scenes/drop/drop.tscn")
export (int) var comf_dist
var target:Area2D
var charge:bool
var charge_dist:=50
func control(delta:float)->Vector2:
	if not target:
		return Vector2()
	var vec:Vector2=target.position-head.position
	var dist=vec.length()
	if dist<charge_dist and target.velocity.length()<charge_dist:
		charge=true
	if dist<comf_dist:
		vec=vec.rotated(PI/2.5)
	elif dist>500:
		charge=false
	if not charge:
		dir=lerp_angle(dir,vec.angle(),steer_speed*delta)
	vel+=movement-vel*.1
	return Vector2(vel,0).rotated(dir)*delta

func on_segment_died(s:Segment)->void:
	Global.create_drop(drop_scene,s.position)
	.on_segment_died(s)


