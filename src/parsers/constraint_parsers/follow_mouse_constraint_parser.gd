class_name FollowMouseConstraintParser
extends ConstraintParser

func parse_json(json_obj: Dictionary) -> SegmentConstraint:
	var distance_scaling: float = json_obj.get("distance_scaling")
	if distance_scaling == null:
		push_error("Expected 'distance_scaling' field")
		return null

	var max_velocity: float = json_obj.get("max_velocity")
	if max_velocity == null:
		push_error("Expected 'max_velocity' field")
		return null

	return FollowMouseConstraint.new(distance_scaling, max_velocity)

func serialize(constraint: SegmentConstraint) -> Dictionary:
	var follow_mouse_constraint: FollowMouseConstraint = constraint as FollowMouseConstraint

	return {
		"distance_scaling": follow_mouse_constraint.distance_scaling,
		"max_velocity": follow_mouse_constraint.max_velocity
	}
