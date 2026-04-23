## This class keeps track of all our variables and calls on the main class to update the body whenever we change stuff.
class_name PropertyManager
extends Node

signal iterator_changed()
signal constraint_changed()
signal accessories_changed()
signal render_set_changed()

@export var iterator: Iterator:
	get:
		return iterator
	set(value):
		if iterator != value:
			iterator = value
			iterator.changed.connect(iterator_changed.emit)
			iterator_changed.emit()

@export var constraint: SegmentConstraint:
	get:
		return constraint
	set(value):
		if constraint != value:
			constraint = value
			constraint.changed.connect(constraint_changed.emit)
			constraint_changed.emit()
	
@export var accessories: Array[Accessory]:
	get:
		return accessories
	set(value):
		if accessories != value:
			# This doesn't work when we change the array itself
			# Which may cause problems later...
			accessories = value
			accessories_changed.emit()

@export var render_set: RenderSet:
	get:
		return render_set
	set(value):
		if render_set != value:
			render_set = value
			render_set_changed.emit()
