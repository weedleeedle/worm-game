## Factory for creating worms!
extends Node

@export_file("*.tscn") var body_segment_file: String
@onready var body_segment_scene: PackedScene = load(body_segment_file)

func create_worm(segments: int, constraints: Array[SegmentConstraint]) -> BodySegment:
	# Create the head
	var head: BodySegment = body_segment_scene.instantiate()
	head.constraints = constraints

	var current_segment := head

	for segment in segments - 1:
		var new_segment: BodySegment = body_segment_scene.instantiate()
		new_segment.constraints = constraints
		current_segment.connect_child_segment(new_segment)
		current_segment = new_segment

	return head
