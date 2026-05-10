# Makes a body "top level" so that it does not move with it's parent, but enables the head/root body part to be positioned to some other target.
class_name StaticPositionConstraint
extends SegmentConstraint

func apply(_on: BodySegment, _delta: float) -> void:
	pass

func setup(on: BodySegment) -> void:
	on.owning_body.top_level = true
