## Accessory that creates another body to use as the "accessory" on top of another model.
class_name SubBodyAccessory
extends Accessory

## Gets the size of each body part.
@export var body_iterator: Iterator

## The constraint to apply to the body.
@export var constraint: SegmentConstraint

## Instructions for rendering the body part.
@export var render_set: RenderSet

func init_accessory_model() -> AccessoryModel:
	pass

func draw_accessory_model() -> void:
	pass


