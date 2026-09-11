## Contains all information and data needed to construct a body.
class_name BodyBlueprint
extends Resource

@export var body_iterator: Iterator

@export var constraint: SegmentConstraint

@export var accessories: Array[Accessory]

@export var render_set: RenderSet

func _init(
	p_body_iterator: Iterator = null,
	p_constraint: SegmentConstraint = null,
	p_accessories: Array[Accessory] = [],
	p_render_set: RenderSet = null
	) -> void:
		body_iterator = p_body_iterator
		constraint = p_constraint
		accessories = p_accessories
		render_set = p_render_set

func build_body() -> Body:
	# I hate this!
	var body := BodyFactory.create_body(body_iterator, constraint, accessories)
	body.render_set = render_set
	return body
