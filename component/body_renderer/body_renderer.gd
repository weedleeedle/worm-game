## Takes a tree of body segments and renders them!
class_name BodyRenderer
extends Node2D

class RenderTarget:
	var body: BodySegment
	var accessories: Array[Accessory]
	var render_set: RenderSet
	var z_index: int 
	
	func _init(p_body: BodySegment, p_accessories: Array[Accessory], p_render_set: RenderSet, p_z_index: int) -> void:
		body = p_body
		accessories = p_accessories
		render_set = p_render_set
		z_index = p_z_index

## How many points to put on the head and tail. This number is doubled for raisins.
static var END_RESOLUTION: int = 16
static var ANGLE_INCREMENT: float = deg_to_rad(180.0/END_RESOLUTION)

var render_targets: Array[RenderTarget]

func _ready() -> void:
	RenderService.add_renderer(self)

func _process(_delta: float) -> void:
	# We could prooobably have body segments emit signals when they move so we know to redraw...
	queue_redraw()

func add_render_target(body: BodySegment, accessories: Array[Accessory], render_set: RenderSet, z_index := 0) -> void:
	# This is famously a very good way of inserting a value into a sorted array.
	render_targets.push_back(RenderTarget.new(body, accessories, render_set, z_index))
	render_targets.sort_custom(func (a, b): return a.z_index < b.z_index)

func _draw() -> void:
	for target in render_targets:
		_render(target.body, target.accessories, target.render_set)

func _render(segment: BodySegment, accessories: Array[Accessory], render_set: RenderSet) -> void:
	draw_segment_head(segment, render_set)
	for accessory in accessories:
		accessory.draw_accessory_model()

func draw_segment_head(segment: BodySegment, render_set: RenderSet) -> void:
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
	for outline in render_set.outlines:
		for i in END_RESOLUTION+1:
			var point = head_vector.rotated(deg_to_rad(90) + ANGLE_INCREMENT * i) * (segment.radius + outline.outline_width) + segment.global_position
			point_set.push_back(point) 
		draw_colored_polygon(point_set, outline.outline_color)
		point_set.clear()

	# Now we draw the rest of the fucking owl
	# We actually want to redraw this segment as a regular segment, not just a head segment.
	draw_segment(segment, render_set)

func draw_segment(segment: BodySegment, render_set: RenderSet) -> void:
	if segment.child_segment == null:
		# Switch to base/end case and render tail if this segment doesn't have a child.
		draw_segment_tail(segment, render_set)
		return

	var next_segment := segment.child_segment
	# Render each outline (and the fill color)
	for outline in render_set.outlines:
		var point_set: PackedVector2Array = _get_perpendicular_points(segment, segment.radius + outline.outline_width)
		point_set.append_array(_get_perpendicular_points(next_segment, next_segment.radius + outline.outline_width))
		draw_colored_polygon(Geometry2D.convex_hull(point_set), outline.outline_color)

	draw_segment(next_segment, render_set)

func draw_segment_tail(segment: BodySegment, render_set: RenderSet) -> void:
	var tail_vector: Vector2
	# If we ever have a one-segment body, we gotta do things a lil differently
	if segment.parent_segment == null:
		# We can just point it straight up for RAISINS
		tail_vector = Vector2.DOWN
	else:
		# Head vector points in opposite direction of the tail.
		tail_vector = segment.head_vector().normalized()

	var point_set: PackedVector2Array = []
	for outline in render_set.outlines:
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
