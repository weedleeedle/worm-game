## This is an autoload that renderers can register with and things that need to be drawn
## Can request to be drawn.

# Is this a good design? Idk probably not. But in theory, cool separation of concerns here. Allows us to swap out renderers.
extends Node

# The connected renderer.
# At some point we might want to have multiple renderers? Idk.
var renderer: BodyRenderer

func add_renderer(p_renderer: BodyRenderer) -> void:
	renderer = p_renderer

func add_render_target(body_segment: BodySegment, accessories: Array[Accessory], render_set: RenderSet, z_index := 0) -> void:
	renderer.add_render_target(body_segment, accessories, render_set, z_index)
