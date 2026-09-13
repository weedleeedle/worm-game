class_name AccessoryParser
extends RefCounted

var PARSERS = {
	"scene": SceneAccessoryParser.new(),
	"offset": OffsetAccessoryParser.new(),
	"mirror": MirrorAccesoryParser.new(),
	"subbody": SubBodyAccessoryParser.new(),
}

var TYPE_NAMES = {
	"SceneAccessory": "scene",
	"OffsetAccessory": "offset",
	"MirrorAccessory": "mirror",
	"SubBodyAccessory": "subbody",
}

func parse_json(json_obj: Dictionary) -> Accessory:
	var accessory_id = json_obj.get("accessory_type")
	if accessory_id == null:
		push_error("Expected 'accessory_type' field")
		return null

	var parser: AccessoryParser	= PARSERS.get(accessory_id)
	if parser == null:
		push_error("No parser found for accessory_type ", accessory_id)
		return null

	var data = json_obj.get("data")
	if data == null:
		push_error("Expected 'data' field")
		return null

	var placement: float = json_obj.get("placement")
	if placement == null:
		# We COULD return this as an error or just. Assume a default of 0 maybe?
		push_warning("Expected 'placement' field. Proceeding with default of 0.0")
		placement = 0.0 

	var accessory := parser.parse_json(data)
	accessory.placement = placement
	return accessory

func serialize(accessory: Accessory) -> Dictionary:
	var accessory_class_name = accessory.get_script().get_global_name()

	var type_name = TYPE_NAMES.get(accessory_class_name)
	var serializer = PARSERS.get(type_name)

	return {
		"accessory_type": type_name,
		"data": serializer.serialize(accessory)
	}


