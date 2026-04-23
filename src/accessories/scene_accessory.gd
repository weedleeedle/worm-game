## Initializes a custom scene with an AccessoryModel root. Does nothing else.
class_name SceneAccessory
extends Accessory

@export_file("*.tscn") var custom_model_scene: String

func init_accessory_model() -> AccessoryModel:
	var custom_model: AccessoryModel = load(custom_model_scene).instantiate()
	if custom_model == null:
		push_error("Expected an AccessoryModel scene!")

	current_accessory_model = custom_model
	return current_accessory_model

func draw_accessory_model() -> void:
	# We don't draw anything :3
	pass
