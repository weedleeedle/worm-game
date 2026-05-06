## Accessory that creates another body to use as the "accessory" on top of another model.
class_name SubBodyAccessory
extends Accessory

## Gets the size of each body part.
@export var body_iterator: Iterator

## The constraint to apply to the body.
@export var constraint: SegmentConstraint

## Instructions for rendering the body part.
@export var render_set: RenderSet

@export var z_index: int = 0

func init_accessory_model() -> AccessoryModel:
	var accessory_model: AccessoryModel = accessory_model_scene.instantiate()
	current_accessory_model = accessory_model
	var body = BodyFactory.create_body(body_iterator, constraint, [])
	# Experiment: Disable global positioning only for this node.
	body.top_level = false
	current_accessory_model.add_child(body)
	RenderService.add_render_target(body, [], render_set, z_index)
	return current_accessory_model

func draw_accessory_model() -> void:
	# I guess we don't need this function after all lol
	pass
