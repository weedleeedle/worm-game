## Iterates over an array of floats.
class_name ArrayIterator
extends Iterator

@export var array: Array[float]:
	get:
		return array
	set(value):
		if array != value:
			array = value
			reset()
			emit_changed()

var index: int = 0

func next() -> IteratorReturn:
	if index >= array.size():
		return Iterator.HALT_RETURN

	var value = array[index]
	index += 1
	return IteratorReturn.new(value)

func reset() -> void:
	index = 0
