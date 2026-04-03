## Defines and controls a body segment based on constraints or w/e
class_name BodySegment
extends Node2D

## The size of this segment
@export var radius: float = 50.0

## The max move speed for the head
@export var velocity: float = 300.0

@export var constraints: Array[SegmentConstraint]

@export var parent_segment: BodySegment
@export var child_segment: BodySegment

# Debug/test stuff
@onready var polygon: Polygon2D = $TestPolygon

func _ready() -> void:
	_generate_circle()

func _process(delta: float) -> void:
	if is_head():
		# If this is the head, target and move towards the mouse cursor.
		var direction := get_global_mouse_position() - global_position
		# We probably want to do some kind of easing once we get close to the mouse. We'll see.
		var movement_vector := direction.normalized() * velocity
		global_position += movement_vector * delta

	# Handle constraints
	for constraint in constraints:
		constraint.apply(self)

func is_head() -> bool:
	return parent_segment == null

## Connects a child segment to this segment
func connect_child_segment(segment: BodySegment) -> void:
	child_segment = segment
	segment.parent_segment = self
	# Move the segment here?
	if segment.get_parent():
		segment.get_parent().remove_child(segment)
	add_child(segment)

func _generate_circle() -> void:
	const NUM_POINTS := 30
	const ANGLE_INC := 2.0 * PI / NUM_POINTS 
	
	var points: PackedVector2Array = []

	for i in NUM_POINTS:
		var x := radius * cos(ANGLE_INC * i)
		var y := radius * sin(ANGLE_INC * i)
		points.push_back(Vector2(x,y))

	polygon.polygon = points
