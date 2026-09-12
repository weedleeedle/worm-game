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

func serialize(iterator: Iterator) -> Dictionary:
	# We know that this is already an ExpressionIterator bc of IteratorParser.
	var expr_iterator: ExpressionIterator = iterator as ExpressionIterator

	return {
		"expression": expr_iterator.expression,
		"start": expr_iterator.start_range,
		"end": expr_iterator.end_range,
		"steps": expr_iterator.steps
	}
