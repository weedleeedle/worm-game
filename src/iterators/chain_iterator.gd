## Chains multiple sub-iterators, one after another.
class_name ChainIterator
extends Iterator

class ChainIteratorInstance extends IteratorInstance:
	var iterators: Array[IteratorInstance]
	var current_iterator := 0

	func next() -> IteratorReturn:
		if current_iterator >= iterators.size():
			return Iterator.HALT_RETURN

		var next_val = iterators[current_iterator].next()
		while next_val.is_halt():
			current_iterator += 1
			if current_iterator >= iterators.size():
				return Iterator.HALT_RETURN

			next_val = iterators[current_iterator].next()

		return next_val

	func reset() -> void:
		# Reset all sub-iterators
		for iterator in iterators:
			iterator.reset()

		current_iterator = 0

	func _init(p_iterators: Array[Iterator]) -> void:
		iterators = p_iterators.map(func (iter): return iter.create_iterator())

@export var iterators: Array[Iterator]:
	get:
		return iterators
	set(value):
		if iterators != value:
			iterators = value
			for iterator in iterators:
				iterator.changed.connect(emit_changed)

func create_iterator() -> IteratorInstance:
	return ChainIteratorInstance.new(iterators)
