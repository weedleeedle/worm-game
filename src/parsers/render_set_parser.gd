class_name RenderSetParser
extends RefCounted

func parse_json(json_obj: Dictionary) -> RenderSet:
	var fill_color_str: String = json_obj.get("fill_color")
	if fill_color_str == null:
		push_error("Expected 'fill_color' field")
		return null

	var fill_color = Color(fill_color_str)

	var outlines: Array[Outline] = []

	if json_obj.has("outlines"):
		var outlines_json: Array[Dictionary] = json_obj.get("outlines")
		for outline_json in outlines_json:
			outlines.push_back(parse_outline(outline_json))
	
	return RenderSet.new(fill_color, outlines)

func parse_outline(outline_json: Dictionary) -> Outline:
	var width: float = outline_json.get("width")
	if width == null:
		push_error("Expected 'width' field")
		return null

	var color_string: String = outline_json.get("color")
	if color_string == null:
		push_error("Expected 'color' field")
		return null
	
	var color: Color = Color(color_string)

	return Outline.new(color, width)

func serialize(render_set: RenderSet) -> Dictionary:
	var outlines: Array[Dictionary] = []

	for outline in render_set.outlines:
		outlines.push_back(serialize_outline(outline))

	return {
		"fill_color": render_set.fill_color.to_html(),
		"outlines": outlines
	}

func serialize_outline(outline: Outline) -> Dictionary:
	return {
		"width": outline.outline_width,
		"color": outline.outline_color.to_html(),
	}


