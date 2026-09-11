## Accessory that creates another body to use as the "accessory" on top of another model.
class_name SubBodyAccessory
extends Accessory

@export var body_blueprint: BodyBlueprint

@export var z_index: int = 0

func _init(p_body_blueprint: BodyBlueprint):
	body_blueprint = p_body_blueprint

func init_accessory_model() -> AccessoryModel:
	var accessory_model: AccessoryModel = accessory_model_scene.instantiate()
	var body: Body = body_blueprint.build_body()
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
