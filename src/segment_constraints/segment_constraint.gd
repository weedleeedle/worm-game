## A SegmentConstraint defines how segments can move related to one another.
@abstract 
class_name SegmentConstraint
extends Resource

## Moves the nodes or whatever.
@abstract func apply(on: BodySegment) -> void

# Note, we might have to do some additional steps if we have multiple constraints that apply different transformations? 
# Or maybe we don't care?
# If we have a MaxDistanceConstraint first and then an AngleConstraint, what happens if the angle contraint moves two nodes to be too far away again?
# If that can even happen???
