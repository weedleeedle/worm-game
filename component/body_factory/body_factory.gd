## Factory for creating worms!
extends Node

@export_file("*.tscn") var body_segment_file: String
@onready var body_segment_scene: PackedScene = load(body_segment_file)

func create_worm(body_iterator: Iterator, constraints: Array[SegmentConstraint]) -> BodySegment:
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

	return head
