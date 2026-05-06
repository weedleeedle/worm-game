## Positions another accessory at an offset from this one.
##
## Fuck it why not do a full goddamn transform
class_name OffsetAccessory
extends Accessory

@export var sub_accessory: Accessory

@export var offset: Vector2

@export var rotation: float

@export var scale: Vector2

@export var skew: float

func init_accessory_model() -> AccessoryModel:
	var sub_accessory_model = sub_accessory.init_accessory_model()
	var accessory_model = accessory_model_scene.instantiate()
	current_accessory_model = accessory_model
	current_accessory_model.add_child(sub_accessory_model)
	sub_accessory_model.transform = Transform2D(rotation, scale, skew, offset)
	return accessory_model

func draw_accessory_model() -> void:
	pass
