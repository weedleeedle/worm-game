## Caches the results of an iterator and allows for various operations over/with the entire set.
class_name IteratorCollector
# My impression of RefCounted is that if you ever have a resource that doesn't need to be tracked 
# in the editor, this is what you want to reach for.
extends RefCounted

# Iterators return floats
var iterator_results: Array[float]

func _init(iterator: Iterator) -> void:
	iterator_results = Array([], TYPE_FLOAT, "", null)
	var val := iterator.next()
	while !val.is_halt():
		iterator_results.push_back(val.get_value())
		val = iterator.next()

	iterator.reset()

func size() -> int:
	return iterator_results.size()

func get_val(idx: int) -> float:
	return iterator_results[idx]

# Same as get_val but you can get "between" two values
func interpolate(idx: float) -> float:
	var first_idx := floori(idx)
	var second_idx := ceili(idx)
	var remainder_idx := idx - first_idx

	# What happens if any of these go outside of the range? Idk man.
	var first_val := get_val(first_idx)
	var second_val := get_val(second_idx)

	# Interpolate between the two values.
	return first_val * (1.0 - remainder_idx) + second_val * remainder_idx
