## Contains all the information needed to render a body, including fill color and one or more outline colors.
class_name RenderSet
extends Resource

## The fill color to use for the body.
@export var fill_color: Color

## Zero or more outlines to render the body with
@export var outlines: Array[Outline]: 
	get:
		return outlines
	set(value):
		# Sort the outlines based on descending width (so the biggest width is rendered first)
		value.sort_custom(func (a, b): return a.outline_width > b.outline_width)
		# Push the fill color as an outline with 0 width to the end. Teehee!
		value.push_back(Outline.new(fill_color, 0.0))
		outlines = value

func _init(p_fill_color := Color.WHITE, p_outlines: Array[Outline] = []) -> void:
	fill_color = p_fill_color
	outlines = p_outlines
