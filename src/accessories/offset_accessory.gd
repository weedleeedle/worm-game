## Positions another accessory at an offset from this one.
class_name OffsetAccessory
extends Accessory

@export var sub_accessory: Accessory

@export var offset: Vector2

func init_accessory_model() -> AccessoryModel:
	var sub_accessory_model = sub_accessory.init_accessory_model()
	var accessory_model = accessory_model_scene.instantiate()
	current_accessory_model = accessory_model
	current_accessory_model.add_child(sub_accessory_model)
	sub_accessory_model.position = offset
	return accessory_model

func draw_accessory_model() -> void:
	pass
