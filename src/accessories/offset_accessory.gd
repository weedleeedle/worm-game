## Positions another accessory at an offset from this one.
##
## Fuck it why not do a full goddamn transform
class_name OffsetAccessory
extends Accessory

@export var sub_accessory: Accessory

@export var offset: Vector2 = Vector2.ZERO

@export_range(0, 360, 0.1, "radians_as_degrees") var rotation: float = 0.0

@export var scale: Vector2 = Vector2.ONE

@export var skew: float = 0.0

func _init(
	p_sub_accessory: Accessory = null,
	p_offset := Vector2.ZERO,
	p_rotation := 0.0,
	p_scale := Vector2.ONE,
	p_skew = 0.0
	) -> void:
		sub_accessory = p_sub_accessory
		offset = p_offset
		rotation = p_rotation
		scale = p_scale
		skew = p_skew

func init_accessory_model() -> AccessoryModel:
	var sub_accessory_model = sub_accessory.init_accessory_model()
	var accessory_model = accessory_model_scene.instantiate()
	accessory_model.add_child(sub_accessory_model)
	accessory_model.transform = Transform2D(rotation, scale, skew, offset)
	return accessory_model
