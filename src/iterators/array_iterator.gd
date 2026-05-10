## Iterates over an array of floats.
class_name ArrayIterator
extends Iterator

class ArrayIteratorInstance extends IteratorInstance:
	var array: Array[float]
	var index: int = 0

	func next() -> IteratorReturn:
		if index >= array.size():
			return Iterator.HALT_RETURN

		var value = array[index]
		index += 1
		return IteratorReturn.new(value)

	func reset() -> void:
		index = 0

	func _init(p_array: Array[float] = []) -> void:
		array = p_array

@export var array: Array[float]:
	get:
		return array
	set(value):
		array = value

func create_iterator() -> IteratorInstance:
	return ArrayIteratorInstance.new(array)
