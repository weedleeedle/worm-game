## Contains all the information needed to render a body, including fill color and one or more outline colors.
class_name RenderSet
extends Resource

## The fill color to use for the body.
@export var fill_color: Color:
	get:
		return fill_color
	set(value):
		fill_color = value
		_dirty = true

## Zero or more outlines to render the body with
@export var outlines: Array[Outline]: 
	get:
		return outlines
	set(value):
		outlines = value
		_dirty = true

var _dirty: bool = true
# Cache for outlines
var _outlines: Array[Outline]

## USE THIS TO GET THE ACTUAL LIST OF COLORS INCLUDING THE FILL COLOR!!
func get_outlines() -> Array[Outline]:
	if _dirty:
		_outlines = outlines.duplicate()
		# Sort the outlines based on descending width (so the biggest width is rendered first)
		_outlines.sort_custom(func (a, b): return a.outline_width > b.outline_width)
		# Push the fill color as an outline with 0 width to the end. Teehee!
		_outlines.push_back(Outline.new(fill_color, 0.0))

	return _outlines

func _init(p_fill_color := Color.WHITE, p_outlines: Array[Outline] = []) -> void:
	fill_color = p_fill_color
	outlines = p_outlines
