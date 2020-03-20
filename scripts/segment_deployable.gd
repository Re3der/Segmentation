class_name DeployableSegment
extends Segment

export (float) var trans_time=1
signal in_dest

var selected:bool
var placed:bool
var placemant:Vector2

onready var path:=$trans_tween/path
onready var trans_tween:=$trans_tween

func _ready() -> void:
	set_physics_process(false)

func _input_event(viewport: Object, event: InputEvent, shape_idx: int) -> void:
	if not event is InputEventMouseButton or shape_idx!=0:return
	if event.pressed:
		if  event.button_index==BUTTON_LEFT:
			pick_up()
		elif event.button_index==BUTTON_RIGHT:
			selected=true

func _input(event: InputEvent) -> void:
	if not selected:return
	if event is InputEventMouseButton and event.button_index==BUTTON_RIGHT:
		selected=false
		placemant=get_global_mouse_position()
		deploy()

func _physics_process(delta: float) -> void:
	move(Vector2(),placemant,true,delta)
	draw_path(placemant)
	if j1.distance_to(placemant)<4:
		emit_signal("in_dest")
		set_physics_process(false)
		draw_path(position)

func _process(delta: float) -> void:
	if selected:
		draw_path(get_global_mouse_position())

func draw_path(destination:Vector2)->void:
	path.points=[position,destination]

func deploy()->void:
	parent.segment_moved(self)
	set_process(false)
	if deployed and placed:
		to_segment()
		yield(trans_tween,"tween_all_completed")
		set_pos(position)
	set_physics_process(true)
	deployed=true
	yield(self,"in_dest")
	set_pos(placemant)
	to_turret()
	yield(trans_tween,"tween_all_completed")
	set_process(true)

func pick_up()->void:
	parent.segment_moved(self)
	if not deployed or is_physics_processing():return
	to_segment()
	set_process(false)
	yield(trans_tween,"tween_all_completed")
	deployed=false
	set_pos(position)
	set_process(true)

func to_turret()->void:
	trans_tween.interpolate_property(joint,"position",joint.position,Vector2(),trans_time,Tween.TRANS_LINEAR,Tween.EASE_IN)
	trans_tween.interpolate_property(self,"position",position,placemant,trans_time,Tween.TRANS_LINEAR,Tween.EASE_IN)
	trans_tween.start()
	placed=true

func to_segment()->void:
	trans_tween.interpolate_property(self,"position",position,j2,trans_time,Tween.TRANS_LINEAR,Tween.EASE_IN)
	trans_tween.interpolate_property(joint,"position",joint.position,Vector2(base/2,0),trans_time,Tween.TRANS_LINEAR,Tween.EASE_IN)
	trans_tween.start()
	placed=false

func _on_segment_mouse_entered() -> void:
	parent.selected+=1
	show_bar()

func _on_segment_mouse_exited() -> void:
	parent.selected-=1



