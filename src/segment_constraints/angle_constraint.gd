## Restricts how tight of an angle a segment can have following two preceding segments
class_name AngleConstraint
extends SegmentConstraint

@export var min_angle: float:
	get:
		return min_angle
	set(value):
		if min_angle != value:
			min_angle = value
			emit_changed()

func apply(on: BodySegment, _delta: float) -> void:
	# Head doesn't get any constraints
	if on.is_head():
		return

	# Second node doesn't get any constraints
	if on.parent_segment.is_head():
		return

	# Prior node is node B. Node prior to THAT is node A.
	# We are on node C.
	var node_pos_A := on.parent_segment.parent_segment.global_position
	var node_pos_B := on.parent_segment.global_position
	var node_pos_C := on.global_position

	var vec_B_to_A := node_pos_A - node_pos_B
	var vec_B_to_C := node_pos_C - node_pos_B

	var angle_BA_BC := vec_B_to_A.angle_to(vec_B_to_C)
	if absf(angle_BA_BC) < deg_to_rad(min_angle):
		# Clamp the angle
		var new_vec_B_to_C := vec_B_to_A.rotated(deg_to_rad(signf(angle_BA_BC)*min_angle)).normalized() * vec_B_to_C.length()
		on.global_position = node_pos_B + new_vec_B_to_C
