## Iterator that uses a math expression to generate its return values.
class_name ExpressionIterator
extends Iterator

## The expression to use to generate the values.
## 
## The expression should have one variable, `i`, which represents the index 
## of the body segment this is, with `i=0` being the head or first segment, 
## `i=1` being the next segment, and so on and so forth.
@export var expression: String:
	get:
		return expression
	set(value):
		if value != expression:
			expression = value
			_run_after_exports_initialized()
			reset()
			emit_changed()

## Where to start the evaluation
@export var start_range: float:
	get:
		return start_range
	set(value):
		if start_range != value:
			start_range = value
			reset()
			emit_changed()


## Where to end the range.
@export var end_range: float:
	get:
		return end_range
	set(value):
		if end_range != value:
			end_range = value
			reset()
			emit_changed()

## How many numbers to evaluate the expression for.
@export var steps: int:
	get:
		return steps
	set(value):
		if steps != value:
			steps = value
			reset()
			emit_changed()

var i: int = 0
var expression_parsed: Expression

func _run_after_exports_initialized():
	expression_parsed = Expression.new()
	# Use i as the variable for the expression
	expression_parsed.parse(expression, ["i"])

func next() -> IteratorReturn:
	if expression_parsed == null:
		_run_after_exports_initialized()
		
	if i > steps:
		return Iterator.HALT_RETURN

	var width = end_range - start_range
	var index = start_range + width * i / steps
	var result = expression_parsed.execute([index])
	if expression_parsed.has_execute_failed():
		return Iterator.HALT_RETURN

	i += 1
	return IteratorReturn.new(result)

func reset() -> void:
	i = 0
