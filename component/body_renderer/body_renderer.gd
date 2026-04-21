## Takes a tree of body segments and renders them!
class_name BodyRenderer
extends Node2D

## How many points to put on the head and tail. This number is doubled for raisins.
static var END_RESOLUTION: int = 16
static var ANGLE_INCREMENT: float = deg_to_rad(180.0/END_RESOLUTION)

@export var render_properties: RenderSet

@export var body: BodySegment 

#@onready var fill_shape: Polygon2D = $FillShape
#@onready var outline_shape: Polygon2D = $OutlineShape

func _ready() -> void:
	pass
	#fill_shape.color = fill_color
	#outline_shape.color = outline_color

func _process(_delta: float) -> void:
	if body == null:
		return

	#fill_points = add_segment_points_head(body, 0)
	#outline_points = add_segment_points_head(body, outline_width)
	queue_redraw()

func _draw() -> void:
	draw_segment_head(body)

func draw_segment_head(segment: BodySegment) -> void:
	var head_vector: Vector2
	# If we ever have a one-segment body, we gotta do things a lil differently
	if segment.child_segment == null:
		# We can just point it straight up for RAISINS
		head_vector = Vector2.UP
	else:
		head_vector = segment.tail_vector().normalized()
	
	# Generate points!

	# Render a shape for each outline. These should already be in order from largest to smallest.
	# The fill color is actually just an outline with 0 width (it's on top so it will already be filled in.)
	var point_set: PackedVector2Array = []
	for outline in render_properties.outlines:
		for i in END_RESOLUTION+1:
			var point = head_vector.rotated(deg_to_rad(90) + ANGLE_INCREMENT * i) * (segment.radius + outline.outline_width) + segment.global_position
			point_set.push_back(point) 
		draw_colored_polygon(point_set, outline.outline_color)
		point_set.clear()

	# Now we draw the rest of the fucking owl
	# We actually want to redraw this segment as a regular segment, not just a head segment.
	draw_segment(segment)

func draw_segment(segment: BodySegment) -> void:
	if segment.child_segment == null:
		# Switch to base/end case and render tail if this segment doesn't have a child.
		draw_segment_tail(segment)
		return

	var next_segment := segment.child_segment
	# Render each outline (and the fill color)
	for outline in render_properties.outlines:
		var point_set: PackedVector2Array = _get_perpendicular_points(segment, segment.radius + outline.outline_width)
		point_set.append_array(_get_perpendicular_points(next_segment, next_segment.radius + outline.outline_width))
		draw_colored_polygon(Geometry2D.convex_hull(point_set), outline.outline_color)

	draw_segment(next_segment)

func draw_segment_tail(segment: BodySegment) -> void:
	var tail_vector: Vector2
	# If we ever have a one-segment body, we gotta do things a lil differently
	if segment.parent_segment == null:
		# We can just point it straight up for RAISINS
		tail_vector = Vector2.DOWN
	else:
		# Head vector points in opposite direction of the tail.
		tail_vector = segment.head_vector().normalized()

	var point_set: PackedVector2Array = []
	for outline in render_properties.outlines:
		for i in END_RESOLUTION+1:
			var point = tail_vector.rotated(deg_to_rad(90) + ANGLE_INCREMENT * i) * (segment.radius + outline.outline_width) + segment.global_position
			point_set.push_back(point) 
		draw_colored_polygon(point_set, outline.outline_color)
		point_set.clear()

# Returns an array of ONLY TWO VECTORS!!!!!!!
func _get_perpendicular_points(segment: BodySegment, distance: float) -> PackedVector2Array:
	if segment.parent_segment != null:
		return [segment.head_vector().rotated(deg_to_rad(-90)).normalized() * distance + segment.global_position, segment.head_vector().rotated(deg_to_rad(90)).normalized() * distance + segment.global_position]
	elif segment.child_segment != null:
		return [segment.tail_vector().rotated(deg_to_rad(-90)).normalized() * distance + segment.global_position, segment.tail_vector().rotated(deg_to_rad(90)).normalized() * distance + segment.global_position]
	else:
		push_error("Body part had neither a head vector nor a tail vector to render against!")
		return []
