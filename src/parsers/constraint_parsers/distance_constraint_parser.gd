class_name DistanceConstraintParser
extends ConstraintParser

func parse_json(json_obj: Dictionary) -> SegmentConstraint:
	# DistanceConstraintParser expects one field, "max_distance"
	var max_distance: float = json_obj.get("max_distance")
	if max_distance == null:
		push_error("Expected 'max_distance' field")
		return null

	return DistanceConstraint.new(max_distance)

func serialize(constraint: SegmentConstraint) -> Dictionary:
	var distance_constraint: DistanceConstraint = constraint as DistanceConstraint

	return {
		"max_distance": distance_constraint.max_distance
	}



