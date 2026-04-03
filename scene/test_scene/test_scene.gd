extends Node

@export var constraints: Array[SegmentConstraint]

func _ready() -> void:
	# Create a worm!!	
	var worm := BodyFactory.create_worm(10, constraints)
	add_child(worm)
