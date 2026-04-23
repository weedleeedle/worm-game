## Holds a group of sub-constraints and applies each of them in turn.
class_name GroupConstraint
extends SegmentConstraint

@export var sub_constraints: Array[SegmentConstraint]

func apply(on: BodySegment) -> void:
	for constraint in sub_constraints:
		constraint.apply(on)
