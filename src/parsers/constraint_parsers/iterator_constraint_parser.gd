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

	var iterator_parser := IteratorParser.new()
	var x_iterator = iterator_parser.parse_json(x_iterator_json)
	var y_iterator = iterator_parser.parse_json(y_iterator_json)

	return IteratorConstraint.new(x_iterator, y_iterator)
