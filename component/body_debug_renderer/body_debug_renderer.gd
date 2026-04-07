## Renders a renderers points :)
class_name BodyDebugRenderer
extends Node2D

@export_file("*.tscn") var body_point_file: String
@onready var body_point_scene: PackedScene = load(body_point_file)

@export var body_renderer: BodyRenderer

var point_sprites: Array[Node2D]
var num_points := -1

func _process(delta: float) -> void:
	if body_renderer == null:
		return

	var points := body_renderer.fill_points
	# Figure out how many points we have and generate our points if we haven't yet
	if num_points == -1:
		num_points = points.size()
		for i in num_points:
			var new_point: Node2D = body_point_scene.instantiate()
			new_point.modulate.r = 1.0 - (i as float / num_points)
			add_child(new_point)
			point_sprites.push_back(new_point)

	# Now we can position the sprites :]

	for i in num_points:
		point_sprites[i].global_position = points[i]
		print(points[i])
