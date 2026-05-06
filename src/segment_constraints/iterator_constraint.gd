## An IteratorConstraint restricts the position of each segment based on the iterator results.
class_name IteratorConstraint
extends SegmentConstraint

@export var x_iterator: Iterator:
	get: 
		return x_iterator
	set(value):
		x_iterator = value
		x_iterator_result = IteratorCollector.new(x_iterator)

@export var y_iterator: Iterator:
	get:
		return y_iterator
	set(value):
		y_iterator = value
		y_iterator_result = IteratorCollector.new(y_iterator)
		print(y_iterator)
		print(y_iterator_result)

@export var max_distance: float

var x_iterator_result: IteratorCollector
var y_iterator_result: IteratorCollector

func apply(on: BodySegment, _delta: float) -> void:
	# This is such a huge waste of performance lol. We should figure out how to cache this (probably in the body segment itself)
	var total_length: int = on.get_length()
	var idx: int = on.get_distance_to_head()

	# Now we scale this to the length of the iterator
	var x_iterator_idx: float = float(idx) / float(total_length) * (x_iterator_result.size() - 1)
	var y_iterator_idx: float = float(idx) / float(total_length) * (y_iterator_result.size() - 1)

	# These coordinates should be RELATIVE to the position of the head.
	var x_val: float = x_iterator_result.interpolate(x_iterator_idx)
	var y_val: float = y_iterator_result.interpolate(y_iterator_idx)
	
	# I think I'd like to be able to apply a relative transform to this somehow...
	var vec := Vector2(x_val, y_val)
	var target_pos := on.get_head_transform() * vec
	var direction_vec := on.global_position - target_pos
	var limit_vec := direction_vec.limit_length(max_distance)
	on.global_position = target_pos + limit_vec
