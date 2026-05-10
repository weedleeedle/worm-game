## Accessory that creates another body to use as the "accessory" on top of another model.
class_name SubBodyAccessory
extends Accessory

## Gets the size of each body part.
@export var body_iterator: Iterator

## The constraint to apply to the body.
@export var constraint: SegmentConstraint

## Instructions for rendering the body part.
@export var render_set: RenderSet

@export var accessories: Array[Accessory]

@export var z_index: int = 0

func init_accessory_model() -> AccessoryModel:
	var accessory_model: AccessoryModel = accessory_model_scene.instantiate()
	var body: Body = BodyFactory.create_body(body_iterator, constraint, accessories)
	body.render_set = render_set
	accessory_model.add_child(body)
	return accessory_model
