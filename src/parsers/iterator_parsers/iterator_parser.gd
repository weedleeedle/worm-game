class_name IteratorParser
extends RefCounted

var PARSERS = {
	"array": ArrayIteratorParser.new(),
	"expression": ExpressionIteratorParser.new(),
	"chain": ChainIteratorParser.new(),
}

func parse_json(json_obj: Dictionary) -> Iterator:
	var iterator_id = json_obj.get("iterator_type")
	if iterator_id == null:
		push_error("Expected 'iterator_type' field")
		return null

	var parser: IteratorParser = PARSERS.get(iterator_id)
	if parser == null:
		push_error("No parser found for iterator_type ", iterator_id)
		return null

	var data = json_obj.get("data")
	if data == null:
		push_error("Expected 'data' field")
		return null

	return parser.parse_json(data)
