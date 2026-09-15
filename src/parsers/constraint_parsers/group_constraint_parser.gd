class_name GroupConstraintParser
extends ConstraintParser

func parse_json(json_obj: Dictionary) -> SegmentConstraint:
	var sub_constraints: Array = json_obj.get("sub_constraints")
	if sub_constraints == null:
		push_error("Expected 'sub_constraints' field")
		return null

	var base_parser: ConstraintParser = ConstraintParser.new()

	var sub_constraint_objects: Array[SegmentConstraint] = []
	for sub_constraint in sub_constraints:
		sub_constraint_objects.push_back(base_parser.parse_json(sub_constraint))

	return GroupConstraint.new(sub_constraint_objects)

func serialize(constraint: SegmentConstraint) -> Dictionary:
	var group_constraint: GroupConstraint = constraint as GroupConstraint

	var sub_constraints_dict: Array[Dict] = []

	var constraint_parser := ConstraintParser.new()

	for sub_constraint in group_constraint.sub_constraints:
		sub_constraints_dict.push_back(constraint_parser.serialize(sub_constraint))

	return {
		"sub_constraints": sub_constraints_dict
	}
