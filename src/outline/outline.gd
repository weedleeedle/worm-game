## We render a body with a fill color and one or more outline colors. This is one of those outlines
class_name Outline
extends Resource

## The color to use for this outline
@export var outline_color: Color

## The width to use for this outline
@export var outline_width: float

func _init(p_outline_color := Color.WHITE, p_outline_width := 5.0) -> void:
	outline_color = p_outline_color
	outline_width = p_outline_width
