## Factory for creating worms!
extends Node

@export_file("*.tscn") var body_segment_file: String
@onready var body_segment_scene: PackedScene = load(body_segment_file)

func create_worm(body_iterator: Iterator, constraints: Array[SegmentConstraint], accessories: Array[Accessory]) -> BodySegment:
	# Create the head
	var head: BodySegment = body_segment_scene.instantiate()
	var iter_result := body_iterator.next()
	if iter_result.is_halt():
		push_error("Received a HALT from the body_iterator, expected at least one non-halt iterator")
		
	head.constraints = constraints
	head.radius = iter_result.get_value()

	var current_segment := head
	iter_result = body_iterator.next()
	while !iter_result.is_halt():
		var new_segment: BodySegment = body_segment_scene.instantiate()
		new_segment.constraints = constraints
		new_segment.radius = iter_result.get_value()
		current_segment.connect_child_segment(new_segment)
		current_segment = new_segment
		iter_result = body_iterator.next()

	_init_accessories(head, accessories)
	return head

func _init_accessories(body_root: BodySegment, accessories: Array[Accessory]) -> void:
	# Get the maximum body length for scaling porpoises.
	var real_length := body_root.get_real_length()
	for accessory in accessories:
		var accessory_model := accessory.init_accessory_model()
		var segment := _get_closest_body_segment(body_root, real_length, accessory.placement)
		segment.attach_accessory(accessory_model)

## Gets the closest body part to a given weight from 0.0 to 1.0
func _get_closest_body_segment(body_root: BodySegment, real_length: float, weight: float) -> BodySegment:
	# How "much" of the body does this given segment take up?
	var diameter := body_root.radius * 2.0
	var max_weight := diameter / real_length
	# If the provided weight falls within this range, we return this segment.
	if weight <= max_weight:
		return body_root
	# Otherwise we recurse and reduce the bounds of our search. We shouldn't have to check for a child segment since we know we aren't at the end of the body yet??
	if body_root.child_segment == null:
		push_error("Expected a child segment on this body, got null!")
		return body_root

	# Reduce the remaining length and the remaining weight.
	return _get_closest_body_segment(body_root.child_segment, real_length - diameter, weight)

