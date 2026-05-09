## Mirrors another accessory.
class_name MirrorAccessory
extends Accessory

@export var mirror_x: bool

@export var mirror_y: bool

@export var sub_accessory: Accessory

func init_accessory_model() -> AccessoryModel:
	var sub_accessory_1: Accessory = sub_accessory.duplicate_deep()
	var sub_accessory_2: Accessory = sub_accessory.duplicate_deep()
	var sub_accessory_model = sub_accessory_1.init_accessory_model()
	var sub_accessory_model_2 = sub_accessory_2.init_accessory_model()
	sub_accessory_model_2.scale.x = -1 if mirror_x else 1
	sub_accessory_model_2.scale.y = -1 if mirror_y else 1
	var accessory_model = accessory_model_scene.instantiate()
	current_accessory_model = accessory_model
	current_accessory_model.add_child(sub_accessory_model)
	current_accessory_model.add_child(sub_accessory_model_2)
	return current_accessory_model

func draw_accessory_model() -> void:
	pass
