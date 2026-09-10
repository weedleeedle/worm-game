class_name ArrayIteratorParser
extends IteratorParser

func parse_json(json_obj: Dictionary) -> Iterator:
	var array: Array[float] = json_obj.get("array")
	if array == null:
		push_error("Expected 'array' field")
		return null

	return ArrayIterator.new(array)
