extends Node

@export var constraints: Array[SegmentConstraint]

@onready var body_renderer: BodyRenderer = $BodyRenderer

func _ready() -> void:
	# Create a worm!!	
	var worm := BodyFactory.create_worm(6, constraints)
	add_child(worm)
	body_renderer.body = worm
