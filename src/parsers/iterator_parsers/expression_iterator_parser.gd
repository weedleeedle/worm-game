class_name ExpressionIteratorParser
extends IteratorParser

func parse_json(json_obj: Dictionary) -> Iterator:
	var expression: String = json_obj.get("expression")
	if expression == null:
		push_error("Expected 'expression' field")
		return null

	var start: float = json_obj.get("start")
	if start == null:
		push_error("Expected 'start' field")
		return null

	var end: float = json_obj.get("end")
	if end == null:
		push_error("Expected 'end' field")
		return null
	

	var steps: int = json_obj.get("steps")
	if steps == null:
		push_error("Expected 'steps' field")
		return null

	return ExpressionIterator.new(expression, start, end, steps)
