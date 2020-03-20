class_name EndSegment
extends Segment


func _ready() -> void:
	$shape.shape=null
	if parent.seg_count==1:
		joint.hide()
		return
	img.rotation=PI
	end=true
		

