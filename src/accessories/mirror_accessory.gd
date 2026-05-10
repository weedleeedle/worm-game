## Mirrors another accessory.
class_name MirrorAccessory
extends Accessory

@export var mirror_x: bool

@export var mirror_y: bool

@export var sub_accessory: Accessory

func init_accessory_model() -> AccessoryModel:
	var sub_accessory_model = sub_accessory.init_accessory_model()
	var sub_accessory_model_2 = sub_accessory.init_accessory_model()
	sub_accessory_model_2.scale.x = -1 if mirror_x else 1
	sub_accessory_model_2.scale.y = -1 if mirror_y else 1
	var accessory_model = accessory_model_scene.instantiate()
	accessory_model.add_child(sub_accessory_model)
	accessory_model.add_child(sub_accessory_model_2)
	return accessory_model
