class_name Body
extends Node

export (PackedScene) var default_segment=preload("res://scenes/worm/segments/segment.tscn")
export (PackedScene) var end=preload("res://scenes/worm/segments/end.tscn")

export (int) var base=70
export (int) var length=4
export (int) var movement=50
export (float) var steer_speed=3
export (int) var demige=1

signal fire()

var vel:float
var dir:float
var seg_count:int
var selected:int
var head:Segment

onready var parent=get_parent()
onready var start_pos:Vector2=parent.position
onready var group:String=parent.group

func _ready()->void:
	add_to_group(group)
	set_process(false)
	add_segment(end,start_pos,base,0)
	for i in range(1,length+1):
		add_segment(default_segment,start_pos,base,i)
		yield(get_tree().create_timer(.05),"timeout")
	add_segment(end,start_pos,base,length+1)
	fix_Z_index()
	head=get_child(0)
	set_process(true)

func _process(delta:float)->void:
	process(delta)

func control(delta)->Vector2:
	return Vector2()

func process(delta:float)->void:
		var vel_:=control(delta)
		var pj2:Vector2
		var count:=get_child_count()
		parent.position=head.position
		for i in count:
			var s:=get_child(i)
			if s.deployed:continue
			if pj2 and get_child(i-1).deployed:
				move_child(s,i-1)
				fix_Z_index()
			if s.end and i<count-1 and not get_child(i+1).deployed:
				move_child(s,i+1)
				fix_Z_index()
			vel_=vel_.rotated((s.j1-s.j2).angle_to(Vector2(1,0)))
			vel_=s.move(vel_,pj2,true,delta)
			pj2=s.j2

func add_segment(scene:Resource,pos:Vector2,base:int,rot:int)->void:
	var s=scene.instance()
	s.connect("area_entered",self,"on_segment_area_entered")
	seg_count+=1
	s.build(pos,base,rot)
	s.name=str(seg_count)
	s.group=group
	s.add_to_group(group)
	add_child(s)

func fix_Z_index()->void:
	for s in get_children():
			s.z_index=-s.get_index()

func unchack()->void:
	for s in get_children():
		s.chacked=false

func segment_moved(s:Segment)->void:
	move_child(s,get_child_count())
	fix_Z_index()

func on_segment_died(s:Segment)->void:
	if get_child_count()==3:
		parent.queue_free()
	move_child(s,get_child_count())
	s.queue_free()

func on_segment_area_entered(area:Area2D)->void:
	if area.is_in_group(group) or not area.has_method("hit"):return
	area.hit(demige)
