class_name ConstraintParser
extends RefCounted

## Convert from IDs to parsers
var PARSERS = {
	"max_distance": DistanceConstraintParser.new(),
	"min_angle": AngleConstraintParser.new(),
	"follow_mouse": FollowMouseConstraintParser.new(),
	"group": GroupConstraintParser.new(),
	"iterator": IteratorConstraintParser.new(),
}


func parse_json(json_obj: Dictionary) -> SegmentConstraint:
	var constraint_id = json_obj.get("constraint_type")
	if constraint_id == null:
		push_error("Expected 'constraint_type' field")
		return null

	var parser: ConstraintParser = PARSERS.get(constraint_id)
	if parser == null:
		push_error("No parser found for constraint_type ", constraint_id)
		return null
		
	var data = json_obj.get("data")
	if data == null:
		push_error("Expected 'data' field")
		return null

	# I'm not thrilled about the fact that ConstraintParser technically works on a different
	# format of data than its children... it's probably fine?
	
	# We could also maybe treat this as a custom data type and make it statically typed instead of having all these checks...
	# But maybe that's just even more work for what we're already *doing.*
	return parser.parse_json(data)
