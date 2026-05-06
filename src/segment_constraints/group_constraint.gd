## Holds a group of sub-constraints and applies each of them in turn.
class_name GroupConstraint
extends SegmentConstraint

@export var sub_constraints: Array[SegmentConstraint]:
	get:
		return sub_constraints
	set(value):
		if sub_constraints != value:
			sub_constraints = value
			for constraint in sub_constraints:
				constraint.changed.connect(emit_changed)
			emit_changed()

func apply(on: BodySegment, delta: float) -> void:
	for constraint in sub_constraints:
		constraint.apply(on, delta)
