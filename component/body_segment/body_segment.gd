## Defines and controls a body segment based on constraints or w/e
class_name BodySegment
extends Node2D

# How "quickly" we begin to slow down when nearing a target position
const DISTANCE_SCALING: float = 1.0 / 75.0

## The size of this segment
@export var radius: float = 50.0

## The max move speed for the head
@export var max_velocity: float = 350.0

@export var constraint: SegmentConstraint

@export var parent_segment: BodySegment
@export var child_segment: BodySegment

var accessories: Array[AccessoryModel]

func _ready() -> void:
	pass
	#_generate_circle()

func _process(delta: float) -> void:
	if is_head():
		# If this is the head, target and move towards the mouse cursor.
		var direction := get_global_mouse_position() - global_position
		var distance := direction.length()
		# We approach zero as we near the target
		#var weight := (DISTANCE_SCALING * distance) / sqrt(1 + pow(DISTANCE_SCALING * distance, 2.0))
		var weight := sqrt(DISTANCE_SCALING * distance)
		# We probably want to do some kind of easing once we get close to the mouse. We'll see.
		var velocity := lerpf(0, max_velocity, weight)
		var movement_vector := direction.normalized() * velocity
		global_position += movement_vector * delta

	# Handle constraints
	constraint.apply(self)

	# Make sure the accessories are pointing the right way
	for accessory in accessories:
		var head_vector: Vector2
		if is_head():
			# If this is the head, we define the head vector by the tail vector rotated 180°.
			head_vector = tail_vector().rotated(deg_to_rad(180))
		else:
			head_vector = head_vector()

		accessory.rotation = head_vector.angle()

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

func attach_accessory(accessory_model: AccessoryModel) -> void:
	add_child(accessory_model)
	accessories.push_back(accessory_model)

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

# TODO: Cache all of these results so they don't need to be recalculated each time.

## Get the total number of body segments from here to the tail.
## This is an expensive operation, it has to recurse across the entire sub-body to the tail.
##
## The minimum body distance is 0. If you want the length, just add one to this result.
func get_distance_to_tail() -> int:
	if child_segment == null:
		return 0
	else:
		return child_segment.get_length() + 1

## Gets the total sum of all the body segments radiuses from here to the tail.
##
## This function assumes that each segment is tangential to each of the two adjacent ones.
## In reality, these segments are often overlapping each other due to the constrains applied to the body, but that SHOULD be fine for what we're using this for. Just realize this is basically a "stretched out" length.
func get_real_distance_to_tail() -> float:
	if child_segment == null:
		# Diameter, not radius
		return radius * 2.0
	else:
		return child_segment.get_real_length() + (radius* 2.0)

## Gets the distance from the head (0 is the head itself, 1 is the child, etc.)
func get_distance_to_head() -> int:
	if is_head():
		return 0

	return parent_segment.get_distance_to_head() + 1

func get_real_distance_to_head() -> float:
	if is_head():
		return radius * 2.0
	else:
		return parent_segment.get_real_distance_to_head() + (radius * 2.0)

## Get the total length of the body.
## 
## Note that unlike get_distance_to_X this does count the current segment as 1.
func get_length() -> int:
	if is_head():
		return get_distance_to_tail() + 1
	elif child_segment == null:
		return get_distance_to_head() + 1
	else:
		# We have to add 3 to get the total length of the body, since the head and tail each return 0
		# and we have to add one more for this segment.
		return get_distance_to_head() + get_distance_to_tail() + 3

## Get the real length from this segment to the head and the tail.
func get_real_length() -> float:
	if is_head():
		# Just go to the tail
		return get_real_distance_to_tail()
	elif child_segment == null:
		return get_real_distance_to_head()
	else:
		return parent_segment.get_real_distance_to_head() + child_segment.get_real_distance_to_tail() + (radius * 2.0)

## Gets the nth grandchild. 0 is the current node, 1 is the child, 2 is the grandchild, etc.
##
## If n exceeds the length of the body, the tail segment is returned.
func get_nth_child(n: int) -> BodySegment:
	if n == 0:
		return self
	if child_segment == null:
		return self

	return child_segment.get_nth_child(n - 1)

## Gets the transform of the head of the worm
func get_head_transform() -> Transform2D:
	if is_head():
		return Transform2D(tail_vector().angle() + PI, global_position)
	
	return parent_segment.get_head_transform()
