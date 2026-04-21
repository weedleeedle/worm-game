## Defines and controls a body segment based on constraints or w/e
class_name BodySegment
extends Node2D

# How "quickly" we begin to slow down when nearing a target position
const DISTANCE_SCALING: float = 1.0 / 50.0

## The size of this segment
@export var radius: float = 50.0

## The max move speed for the head
@export var max_velocity: float = 300.0

@export var constraints: Array[SegmentConstraint]

@export var parent_segment: BodySegment
@export var child_segment: BodySegment

# Debug/test stuff
@onready var polygon: Polygon2D = $TestPolygon

func _ready() -> void:
	pass
	#_generate_circle()

func _process(delta: float) -> void:
	if is_head():
		# If this is the head, target and move towards the mouse cursor.
		var direction := get_global_mouse_position() - global_position
		var distance := direction.length()
		# We approach zero as we near the target
		var weight := (DISTANCE_SCALING * distance) / sqrt(1 + pow(DISTANCE_SCALING * distance, 2.0))
		# We probably want to do some kind of easing once we get close to the mouse. We'll see.
		var velocity := lerpf(0, max_velocity, weight)
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

## Returns the direction of the head
func head_vector() -> Vector2:
	if !parent_segment:
		push_error("Attempted to get parent_segment of head body segment")
		return Vector2.ZERO

	return parent_segment.global_position - global_position

## Returns the direction of the tail
func tail_vector() -> Vector2:
	if !child_segment:
		push_error("Attempted to get child_segment of tail body segment")
		return Vector2.ZERO

	return child_segment.global_position - global_position

func _generate_circle() -> void:
	const NUM_POINTS := 30
	const ANGLE_INC := 2.0 * PI / NUM_POINTS 
	
	var points: PackedVector2Array = []

	for i in NUM_POINTS:
		var x := radius * cos(ANGLE_INC * i)
		var y := radius * sin(ANGLE_INC * i)
		points.push_back(Vector2(x,y))

	polygon.polygon = points
