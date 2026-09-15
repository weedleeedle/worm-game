class_name AngleConstraintParser
extends ConstraintParser

func parse_json(json_obj: Dictionary) -> SegmentConstraint:
	var min_angle: float = json_obj.get("min_angle")
	if min_angle == null:
		push_error("Expected 'min_angle' field")
		return null

	return AngleConstraint.new(min_angle)

func serialize(constraint: SegmentConstraint) -> Dictionary:
	var angle_constraint: AngleConstraint = constraint as AngleConstraint

	return {
		"min_angle": angle_constraint.min_angle
	}
