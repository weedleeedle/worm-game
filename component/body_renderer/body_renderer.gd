## Takes a tree of body segments and renders them!
class_name BodyRenderer
extends Node2D

## How many points to put on the head and tail. This number is doubled for raisins.
static var END_RESOLUTION: int = 3

@export var outline_color: Color
@export var fill_color: Color
@export var outline_width: float

@export var body: BodySegment 

#@onready var fill_shape: Polygon2D = $FillShape
#@onready var outline_shape: Polygon2D = $OutlineShape

var fill_points: PackedVector2Array
var outline_points: PackedVector2Array

func _ready() -> void:
	pass
	#fill_shape.color = fill_color
	#outline_shape.color = outline_color

func _process(_delta: float) -> void:
	if body == null:
		return

	fill_points = add_segment_points_head(body, 0)
	outline_points = add_segment_points_head(body, outline_width)
	queue_redraw()

func _draw() -> void:
	if !outline_points.is_empty():
		draw_colored_polygon(outline_points, outline_color)

	if !fill_points.is_empty():
		draw_colored_polygon(fill_points, fill_color)

static func add_segment_points_recursive(segment: BodySegment, radius_offset: float, starting_points: PackedVector2Array, ending_points: PackedVector2Array) -> void:

	# If this is the tail, switch to handling the end case
	if segment.child_segment == null:
		add_segment_points_tail(segment, radius_offset, starting_points, ending_points)
		return
	# Otherwise we recurse!

	var offset_vector := (segment.head_vector().normalized() * (segment.radius + radius_offset)).rotated(deg_to_rad(90))
	var anti_offset_vector := (segment.head_vector().normalized() * (segment.radius + radius_offset)).rotated(deg_to_rad(-90))
	var point := segment.global_position + offset_vector
	var anti_point := segment.global_position + anti_offset_vector
	starting_points.push_back(point)
	ending_points.push_back(anti_point)

	add_segment_points_recursive(segment.child_segment, radius_offset, starting_points, ending_points)

static func add_segment_points_head(segment: BodySegment, radius_offset: float) -> PackedVector2Array:
	# Create the new points arrays!
	var starting_points: PackedVector2Array = []
	var ending_points: PackedVector2Array = [] 
	# Put points on either "side" of the head.

	var angle := deg_to_rad(90) / END_RESOLUTION
	
	for i in END_RESOLUTION:
		var offset_vector := (segment.tail_vector().normalized().rotated(deg_to_rad(180)) * (segment.radius + radius_offset)).rotated(angle * i + angle/2)
		var point := segment.global_position + offset_vector
		starting_points.push_back(point)

		var anti_offset_vector := (segment.tail_vector().normalized().rotated(deg_to_rad(180)) * (segment.radius + radius_offset)).rotated(-angle * i - angle/2)
		var anti_point := segment.global_position + anti_offset_vector
		ending_points.push_back(anti_point)

	# Okay now we recurse through all the body points.
	if segment.child_segment:
		add_segment_points_recursive(segment.child_segment, radius_offset, starting_points, ending_points)
	# Unless for some reason we have a body with one node. That's fine we can work with this...
	else:
		add_segment_points_tail(segment, radius_offset, starting_points, ending_points)

	# Now we aggregate all the points.
	ending_points.reverse()
	starting_points.append_array(ending_points)
	return starting_points

static func add_segment_points_tail(segment: BodySegment, radius_offset: float, starting_points: PackedVector2Array, ending_points: PackedVector2Array) -> void:
	var angle := deg_to_rad(90) / END_RESOLUTION
	
	for i in END_RESOLUTION:
		var offset_vector := (segment.head_vector().normalized().rotated(deg_to_rad(180)) * (segment.radius + radius_offset)).rotated(angle * i + angle/2)
		var point := segment.global_position + offset_vector
		starting_points.push_back(point)

		var anti_offset_vector := (segment.head_vector().normalized().rotated(deg_to_rad(180)) * (segment.radius + radius_offset)).rotated(-angle * i - angle/2)
		var anti_point := segment.global_position + anti_offset_vector
		ending_points.push_back(anti_point)
