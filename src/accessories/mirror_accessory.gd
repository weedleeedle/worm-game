## Mirrors another accessory.
class_name MirrorAccessory
extends Accessory

@export var mirror_x: bool

@export var mirror_y: bool

@export var sub_accessory: Accessory

func init_accessory_model() -> AccessoryModel:
	var mirror_accessory_root = accessory_model_scene.instantiate()
	var mirror_accessory_normal = accessory_model_scene.instantiate()
	var mirror_accessory_mirrored = accessory_model_scene.instantiate()
	mirror_accessory_mirrored.scale.x = -1 if mirror_x else 1
	mirror_accessory_mirrored.scale.y = -1 if mirror_y else 1
	var sub_accessory_model = sub_accessory.init_accessory_model()
	var sub_accessory_model_2 = sub_accessory.init_accessory_model()
	mirror_accessory_normal.add_child(sub_accessory_model)
	mirror_accessory_mirrored.add_child(sub_accessory_model_2)
	mirror_accessory_root.add_child(mirror_accessory_normal)
	mirror_accessory_root.add_child(mirror_accessory_mirrored)
	return mirror_accessory_root
