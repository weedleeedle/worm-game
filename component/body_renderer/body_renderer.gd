## Takes a tree of body segments and renders them!
class_name BodyRenderer
extends Node2D

## How many points to put on the head and tail. This number is doubled for raisins.
static var END_RESOLUTION: int = 3
static var ANGLE_INCREMENT: float = deg_to_rad(180.0/END_RESOLUTION)

@export var outline_color: Color
@export var fill_color: Color
@export var outline_width: float

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
		# Head vector points in opposite direction of the tail.
		head_vector = segment.tail_vector().rotated(deg_to_rad(180)).normalized()
	
	# Generate points!
	var points: PackedVector2Array = []
	var outline_points: PackedVector2Array = []
	for i in END_RESOLUTION:
		var point = head_vector.rotated(deg_to_rad(90) + ANGLE_INCREMENT * i) * segment.radius
		var outline_point = head_vector.rotated(deg_to_rad(90) + ANGLE_INCREMENT * i) * (segment.radius + outline_width)
		points.push_back(point) 
		outline_points.push_back(outline_point)

	draw_colored_polygon(points, fill_color)
	draw_colored_polygon(outline_points, outline_color)

	# Now we draw the rest of the fucking owl
	draw_segment(segment.child_segment)

func draw_segment(segment: BodySegment) -> void:
	if segment.child_segment == null:
		# Switch to base/end case and render tail if this segment doesn't have a child.
		draw_segment_tail(segment)
		return

	var next_segment := segment.child_segment
	var self_points := _get_perpendicular_points(segment, segment.radius)
	var self_points_outline := _get_perpendicular_points(segment, segment.radius + outline_width)
	var next_points := _get_perpendicular_points(next_segment, next_segment.radius)
	var next_points_outline := _get_perpendicular_points(next_segment, next_segment.radius + outline_width)
	self_points.append_array(next_points)
	self_points_outline.append_array(next_points_outline)
	if self_points.is_empty():
		print("BUH??")
		print(segment)
	draw_colored_polygon(self_points, fill_color)
	draw_colored_polygon(self_points_outline, outline_color)

	draw_segment(next_segment)

func draw_segment_tail(segment: BodySegment) -> void:
	var tail_vector: Vector2
	# If we ever have a one-segment body, we gotta do things a lil differently
	if segment.parent_segment == null:
		# We can just point it straight up for RAISINS
		tail_vector = Vector2.DOWN
	else:
		# Head vector points in opposite direction of the tail.
		tail_vector = segment.head_vector().rotated(deg_to_rad(180)).normalized()

	var points: PackedVector2Array = []
	var outline_points: PackedVector2Array = []
	for i in END_RESOLUTION:
		var point = tail_vector.rotated(deg_to_rad(90) + ANGLE_INCREMENT * i) * segment.radius
		var outline_point = tail_vector.rotated(deg_to_rad(90) + ANGLE_INCREMENT * i) * (segment.radius + outline_width)
		points.push_back(point) 
		outline_points.push_back(outline_point)

	draw_colored_polygon(points, fill_color)
	draw_colored_polygon(outline_points, outline_color)

# Returns an array of ONLY TWO VECTORS!!!!!!!
func _get_perpendicular_points(segment: BodySegment, distance: float) -> PackedVector2Array:
	if segment.parent_segment == null:
		push_error("Attempted to get perpendicular points for body segment without a head vector")
		return []

	return [segment.head_vector().rotated(deg_to_rad(-90)).normalized() * distance, segment.head_vector().rotated(deg_to_rad(90)).normalized() * distance]
