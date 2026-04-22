extends Node

@export var iterator: Iterator

@export var constraints: Array[SegmentConstraint]
@export var accessories: Array[Accessory]

@onready var body_renderer: BodyRenderer = $BodyRenderer

func _ready() -> void:
	# Create a worm!!	
	var worm := BodyFactory.create_worm(iterator, constraints, accessories)
	add_child(worm)
	body_renderer.body = worm
	body_renderer.accessories = accessories
