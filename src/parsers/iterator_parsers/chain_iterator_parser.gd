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

func serialize(iterator: Iterator) -> Dictionary:
	var chain_iterator: ChainIterator = iterator as ChainIterator

	var sub_iterators: Array[Dictionary] = []
	var iterator_serializer = IteratorParser.new()

	for iterator in chain_iterator.iterators:
		sub_iterators.push_back(iterator_serializer.serialize(iterator))

	return {
		"iterators": sub_iterators
	}
