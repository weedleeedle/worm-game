class_name BodyBlueprintParser
extends RefCounted

func parse_json(json_obj: Dictionary) -> BodyBlueprint:
	var iterator_json: Dictionary = get_field(json_obj, "iterator")
	var constraint_json: Dictionary = get_field(json_obj, "constraint")
	var accessories_json: Array[Dictionary] = get_field(json_obj, "accessories")
	var render_set_json: Dictionary = get_field(json_obj, "render_set")

	var iterator := IteratorParser.new().parse_json(iterator_json)
	var constraint := ConstraintParser.new().parse_json(constraint_json)
	var accessories: Array[Accessory] = []
	var render_set = RenderSetParser().new().parse_json(render_set_json)

	var accessory_parser = AccessoryParser.new()

	for accessory_json in accessories_json:
		accessories.push_back(accessory_parser.parse_json(accessory_json))

	return BodyBlueprint.new(
		iterator,
		constraint,
		accessories,
		render_set)

func serialize(body: BodyBlueprint) -> Dictionary:

	var accessories: Array[Dictionary] = []
	var accessory_parser: AccessoryParser = AccessoryParser.new()

	for accessory in body.accessories:
		accessories.push_back(accessory_parser.serialize(accessory))

	return {
		"iterator": IteratorParser.new().serialize(body.body_iterator),
		"constraint": ConstraintParser.new().serialize(body.constraint),
		"accessories": accessories,
		"render_set": RenderSetParser.new().serialize(body.render_set)
	}

func get_field(json_obj: Dictionary, key: String) -> Variant:
	if !json_obj.has(key):
		push_error("Expected '", key, "' field")
		return null

	return json_obj.get(key)
