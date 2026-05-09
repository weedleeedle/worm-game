## Brain/controller for a procedurally generated body
class_name Body
extends Node2D

static var END_RESOLUTION: int = 16
static var ANGLE_INCREMENT: float = PI / END_RESOLUTION

@export var accessories: Array[Accessory]

@export var render_set: RenderSet

var body_segments: Array[BodySegment]
var body_head: BodySegment

func _process(delta: float) -> void:
	queue_redraw()

func get_head() -> BodySegment:
	return body_head

## Takes control of the body segment, adds it as a child.
## 
## The first body segment added will be the head, positioned at the origin.
func add_body_segment(body_segment: BodySegment) -> void:
	add_child(body_segment)
	body_segment.owning_body = self
	var prev_segment: BodySegment
	if !body_segments.is_empty():
		prev_segment = body_segments.back()

	body_segments.push_back(body_segment)
	if body_head == null:
		body_head = body_segment

	# Connect the new segment to the old one (maybe make this optional if they're like... pre-connected...?
	if prev_segment == null:
		return

	prev_segment.connect_child_segment(body_segment)

## Body drawing functions
func _draw() -> void:
	_render(body_head, accessories, render_set)

func _render(segment: BodySegment, p_accessories: Array[Accessory], p_render_set: RenderSet) -> void:
	draw_segment_head(segment, p_render_set)
	for accessory in p_accessories:
		accessory.draw_accessory_model()

func draw_segment_head(segment: BodySegment, p_render_set: RenderSet) -> void:
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
	for outline in p_render_set.outlines:
		for i in END_RESOLUTION+1:
			var point = head_vector.rotated(deg_to_rad(90) + ANGLE_INCREMENT * i) * (segment.radius + outline.outline_width) + segment.position
			point_set.push_back(point) 
		draw_colored_polygon(point_set, outline.outline_color)
		point_set.clear()

	# Now we draw the rest of the fucking owl
	# We actually want to redraw this segment as a regular segment, not just a head segment.
	draw_segment(segment, p_render_set)

func draw_segment(segment: BodySegment, p_render_set: RenderSet) -> void:
	if segment.child_segment == null:
		# Switch to base/end case and render tail if this segment doesn't have a child.
		draw_segment_tail(segment, p_render_set)
		return

	var next_segment := segment.child_segment
	# Render each outline (and the fill color)
	for outline in p_render_set.outlines:
		var point_set: PackedVector2Array = _get_perpendicular_points(segment, segment.radius + outline.outline_width)
		point_set.append_array(_get_perpendicular_points(next_segment, next_segment.radius + outline.outline_width))
		draw_colored_polygon(Geometry2D.convex_hull(point_set), outline.outline_color)

	draw_segment(next_segment, p_render_set)

func draw_segment_tail(segment: BodySegment, p_render_set: RenderSet) -> void:
	var tail_vector: Vector2
	# If we ever have a one-segment body, we gotta do things a lil differently
	if segment.parent_segment == null:
		# We can just point it straight up for RAISINS
		tail_vector = Vector2.DOWN
	else:
		# Head vector points in opposite direction of the tail.
		tail_vector = segment.head_vector().normalized()

	var point_set: PackedVector2Array = []
	for outline in p_render_set.outlines:
		for i in END_RESOLUTION+1:
			var point = tail_vector.rotated(deg_to_rad(90) + ANGLE_INCREMENT * i) * (segment.radius + outline.outline_width) + segment.position
			point_set.push_back(point) 
		draw_colored_polygon(point_set, outline.outline_color)
		point_set.clear()

# Returns an array of ONLY TWO VECTORS!!!!!!!
func _get_perpendicular_points(segment: BodySegment, distance: float) -> PackedVector2Array:
	if segment.parent_segment != null:
		return [segment.head_vector().rotated(deg_to_rad(-90)).normalized() * distance + segment.position, segment.head_vector().rotated(deg_to_rad(90)).normalized() * distance + segment.position]
	elif segment.child_segment != null:
		return [segment.tail_vector().rotated(deg_to_rad(-90)).normalized() * distance + segment.position, segment.tail_vector().rotated(deg_to_rad(90)).normalized() * distance + segment.position]
	else:
		push_error("Body part had neither a head vector nor a tail vector to render against!")
		return []
