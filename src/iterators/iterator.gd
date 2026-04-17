## Base classes for iterators that are used to generate body segment sizes.
@abstract
class_name Iterator
extends Resource

static var HALT_RETURN := IteratorReturn.new(0, true)

## Returned class from an iterator, which can either be a value or a halt. 
## This particular IteratorReturn type returns floats.
class IteratorReturn:
	var value: float = 0
	var halt: bool = false

	func _init(p_value: float, p_halt: bool = false) -> void:
		value = p_value
		halt = p_halt

	## Returns the value of the iterator, if this is not type Halt.
	## 
	## We can't actually stop from returning a halt, lmao, but we'll just return a 0.
	func get_value() -> float:
		if halt:
			push_error("Attempted to get value of a halt IteratorReturn")

		return value

	## Returns whether or not this is a halt or not
	func is_halt() -> bool:
		return halt

## Next function returns either a value, or a HALT_RETURN.
@abstract
func next() -> IteratorReturn

## Resets the state of the iterator.
@abstract
func reset() -> void
