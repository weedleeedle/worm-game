class_name IteratorConstraintParser
extends ConstraintParser

func parse_json(json_obj: Dictionary) -> SegmentConstraint:
	var x_iterator_json = json_obj.get("x_iterator")
	if x_iterator_json == null:
		push_error("Expected 'x_iterator' field")
		return null

	var y_iterator_json = json_obj.get("y_iterator")
	if y_iterator_json == null:
		push_error("Expected 'y_iterator' field")
		return null

	var max_distance = json_obj.get("max_distance")
	if max_distance == null:
		push_error("Expected 'max_distance' field")
		return null

	var iterator_parser := IteratorParser.new()
	var x_iterator = iterator_parser.parse_json(x_iterator_json)
	var y_iterator = iterator_parser.parse_json(y_iterator_json)

	return IteratorConstraint.new(x_iterator, y_iterator)

func serialize(constraint: SegmentConstraint) -> Dictionary:
	var iterator_constraint: IteratorConstraint = constraint as IteratorConstraint

	var iterator_parser := IteratorParser.new()

	return {
		"x_iterator": iterator_parser.serialize(iterator_constraint.x_iterator),
		"y_iterator": iterator_parser.serialize(iterator_constraint.y_iterator),
		"max_distance": iterator_constraint.max_distance
	}
