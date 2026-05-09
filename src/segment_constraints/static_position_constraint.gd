## Tries to keep body segments (other than the head) in their current position, regardless of the position of the parent... basically recreates the normal behavior when everything was global position/top level
class_name StaticPositionConstraint
extends SegmentConstraint

func apply(on: BodySegment, _delta: float) -> void:
	## Head does not get global position applied
	if on.is_head():
		return

	# I think we can literally just do this. 
	# We should probably make a setup/init stage for these...
	# This might fuck with our transformation matricies though... HMMM.
	on.top_level = true
