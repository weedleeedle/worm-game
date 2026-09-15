class_name MirrorAccesoryParser
extends AccessoryParser

func parse_json(json_obj: Dictionary) -> Accessory:
	var sub_accessory_json: Dictionary = json_obj.get("sub_accessory")
	if sub_accessory_json == null:
		push_error("Expected 'sub_accessory' field")
		return null

	var mirror_x: bool = json_obj.get("mirror_x")
	if mirror_x == null:
		push_error("Expected 'mirror_x' field")
		return null

	var mirror_y: bool = json_obj.get("mirror_y")
	if mirror_y == null:
		push_error("Expected 'mirror_y' field")
		return null

	var sub_accessory := AccessoryParser.new().parse_json(sub_accessory_json)
	return MirrorAccessory.new(sub_accessory, mirror_x, mirror_y)

func serialize(accessory: Accessory) -> Dictionary:
	var mirror_accessory: MirrorAccessory = accessory as MirrorAccessory

	return {
		"sub_accessory": AccessoryParser.new().serialize(mirror_accessory.sub_accessory),
		"mirror_x": mirror_accessory.mirror_x,
		"mirror_y": mirror_accessory.mirror_y,
	}

