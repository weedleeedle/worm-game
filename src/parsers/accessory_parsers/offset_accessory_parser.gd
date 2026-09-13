class_name OffsetAccessoryParser
extends AccessoryParser

func parse_json(json_obj: Dictionary) -> Accessory:
	var sub_accessory_json: Dictionary = get_field(json_obj, "sub_accessory")
	var offset: Vector2 = to_vec2(get_field(json_obj, "offset"))
	var rotation: float = get_field(json_obj, "rotation")
	var scale: Vector2 = to_vec2(get_field(json_obj, "scale"))
	var skew: float = get_field(json_obj, "skew")

	var sub_accessory = AccessoryParser.new().parse_json(sub_accessory_json)

	return OffsetAccessory.new(sub_accessory, offset, rotation, scale, skew)

func serialize(accessory: Accessory) -> Dictionary:
	var offset_accessory: OffsetAccessory = accessory as OffsetAccessory

	return {
		"sub_accesory": AccessoryParser.new().serialize(offset_accessory.sub_accessory),
		"offset": to_dict(offset_accessory.offset),
		"rotation": offset_accessory.rotation,
		"scale": to_dict(offset_accessory.scale),
		"skew": offset_accessory.skew,
	}
	
func to_vec2(dict: Dictionary) -> Vector2:
	var x: float = dict.get("x")
	if x == null:
		push_error("Expected 'x' field")

	var y: float = dict.get("y")
	if y == null:
		push_error("Expected 'y' field")

	return Vector2(x, y)

# This might be built in but idk, better safe than sorry
func to_dict(vector: Vector2) -> Dictionary:
	return {
		"x": vector.x,
		"y": vector.y,
	}

func get_field(json_obj: Dictionary, key: String) -> Variant:
	if !json_obj.has(key):
		push_error("Expected '", key, "' field")
		return null

	return json_obj.get(key)
