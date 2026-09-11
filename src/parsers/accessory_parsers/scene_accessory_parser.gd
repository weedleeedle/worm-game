class_name SceneAccessoryParser
extends AccessoryParser

# We don't want to serialize or deserialize full path names,
# so instead we convert to and from a specific set of models
var SCENES = {
	"eyes": "res://component/accessory_model/accessory_models/eyes_accessory_model.tscn"
}

func parse_json(json_obj: Dictionary) -> Accessory:
	if !json_obj.has("scene"):
		push_error("Expected 'scene' field")
		return null

	var full_scene_path := find_full_scene_name(json_obj.get("scene"))
	return SceneAccessory.new(full_scene_path)

func find_full_scene_name(key: String) -> String:
	var full_path = SCENES.get(key)
	if full_path == null:
		push_error("Unable to find a scene for key ", key)
		return full_path

	return full_path



