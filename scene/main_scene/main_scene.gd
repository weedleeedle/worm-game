extends Node2D

@onready var property_manager: PropertyManager = $PropertyManager

var current_body: BodySegment

func _ready() -> void:
	current_body = generate_body(property_manager.iterator, property_manager.constraint, property_manager.accessories)
	RenderService.add_render_target(current_body, property_manager.accessories, property_manager.render_set)

func generate_body(iterator: Iterator, constraint: SegmentConstraint, accessories: Array[Accessory]) -> BodySegment:
	# Create a worm!!	
	var body := BodyFactory.create_body(iterator, constraint, accessories)
	add_child(body)
	return body

# We need to completely regenerate the body anytime the iterator or accessories change.
# We do NOT need to regenerate the body anytime the constraints change or the render set, 
# since these are used every frame.
#
# (Realistically we probably don't have to regenerate the entire worm when accessories change,
# But since they straddle the "generation" vs "rendering" stages, it's probably best to just regenerate)

func _on_property_manager_iterator_changed() -> void:
	current_body.queue_free()
	current_body = generate_body(property_manager.iterator, property_manager.constraint, property_manager.accessories)

func _on_property_manager_accessories_changed() -> void:
	current_body.queue_free()
	current_body = generate_body(property_manager.iterator, property_manager.constraint, property_manager.accessories)
