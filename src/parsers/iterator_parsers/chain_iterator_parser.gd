class_name ChainIteratorParser
extends IteratorParser

func parse_json(json_obj: Dictionary) -> Iterator:
	var iterator_json_array: Array = json_obj.get("iterators")
	if iterator_json_array == null:
		push_error("Expected 'iterators' field")
		return null

	var iterators: Array[Iterator] = []
	var iterator_parser := IteratorParser.new()

	for iterator_json in iterator_json_array:
		var iterator = iterator_parser.parse_json(iterator_json)
		iterators.push_back(iterator)
	
	return ChainIterator.new(iterators)
