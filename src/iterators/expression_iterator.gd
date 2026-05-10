## Iterator that uses a math expression to generate its return values.
class_name ExpressionIterator
extends Iterator

class ExpressionIteratorInstance extends IteratorInstance:
	var expression: Expression
	var start: float
	var end: float
	var steps: int
	var i: float
	
	func _init(p_expression: Expression, p_start := 0.0, p_end := 0.0, p_steps := 1):
		expression = p_expression
		start = p_start
		end = p_end
		steps =	p_steps

	func next() -> IteratorReturn:
		if i > steps:
			return Iterator.HALT_RETURN

		var width = end - start
		var index = start + width * i / steps
		var result = expression.execute([index])
		if expression.has_execute_failed():
			return Iterator.HALT_RETURN

		i += 1
		return IteratorReturn.new(result)

	func reset() -> void:
		i = 0

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
			_expression_dirty = true
			expression = value

## Where to start the evaluation
@export var start_range: float:
	get:
		return start_range
	set(value):
		if start_range != value:
			start_range = value

## Where to end the range.
@export var end_range: float:
	get:
		return end_range
	set(value):
		if end_range != value:
			end_range = value

## How many numbers to evaluate the expression for.
@export var steps: int:
	get:
		return steps
	set(value):
		if steps != value:
			steps = value

var _expression_dirty: bool
var _expression: Expression = Expression.new()

func _init(p_expression := "", p_start_range := 0.0, p_end_range := 0.0, p_steps = 1) -> void:
	expression = p_expression
	start_range = p_start_range
	end_range = p_end_range
	steps = p_steps

func create_iterator() -> ExpressionIteratorInstance:
	if _expression_dirty:
		_expression.parse(expression, ["i"])
	
	return ExpressionIteratorInstance.new(_expression, start_range, end_range, steps)
