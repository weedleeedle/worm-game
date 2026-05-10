## Restricts how far two body segments can be from each other
class_name DistanceConstraint
extends SegmentConstraint

@export var max_distance: float:
	get:
		return max_distance
	set(value):
		if max_distance != value:
			max_distance = value
			emit_changed()

func apply(on: BodySegment, _delta: float) -> void:
	# Head doesn't get any constraints
	if on.is_head():
		return

	var parent_to_child_vec := (on.position - on.parent_segment.position)
	var limit_vec := parent_to_child_vec.limit_length(max_distance)
	# Position the child based on the parent's position?
	on.position = on.parent_segment.position + limit_vec

func setup(on: BodySegment) -> void:
	pass
