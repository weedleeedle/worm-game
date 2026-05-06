class_name FollowMouseConstraint
extends SegmentConstraint

# How "quickly" we begin to slow down when nearing a target position
@export var distance_scaling: float = 1.0 / 75.0

## The max move speed for the head
@export var max_velocity: float = 350.0

func apply(on: BodySegment, delta: float) -> void:
	# Don't do anything if this isn't the head.
	if !on.is_head():
		return

	# If this is the head, target and move towards the mouse cursor.
	var direction := on.get_global_mouse_position() - on.global_position
	var distance := direction.length()
	# We approach zero as we near the target
	#var weight := (DISTANCE_SCALING * distance) / sqrt(1 + pow(DISTANCE_SCALING * distance, 2.0))
	var weight := sqrt(distance_scaling * distance)
	# We probably want to do some kind of easing once we get close to the mouse. We'll see.
	var velocity := lerpf(0, max_velocity, weight)
	var movement_vector := direction.normalized() * velocity
	on.global_position += movement_vector * delta
