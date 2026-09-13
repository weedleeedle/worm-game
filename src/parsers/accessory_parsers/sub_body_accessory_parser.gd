class_name SubBodyAccessoryParser
extends AccessoryParser

func parse_json(json_obj: Dictionary) -> Accessory:
	var body_json: Dictionary = json_obj.get("body")
	if body_json == null:
		push_error("Expected 'body' field")
		return null

	var sub_body_blueprint: BodyBlueprint = BodyBlueprintParser.new().parse_json(body_json)

	return SubBodyAccessory.new(sub_body_blueprint)

func serialize(accessory: Accessory) -> Dictionary:
	var sub_body_accessory: SubBodyAccessory = accessory as SubBodyAccessory

	return {
		"body": BodyBlueprintParser.new().serialize(sub_body_accessory.body_blueprint)
	}
