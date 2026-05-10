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
	# As a precaution, force the head to adopt the transform of the main body segment it's attached to.
	# I'm actually shocked this worked lmao
	var remote_transform: RemoteTransform2D = RemoteTransform2D.new()
	accessory_model.add_child(remote_transform)
	# Attach the remote transform to the path when the body gets added to the scene
	body.get_head().tree_entered.connect(func ():
		remote_transform.remote_path = body.get_head().get_path()
	)
	return accessory_model
