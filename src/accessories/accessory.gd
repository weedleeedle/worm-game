## An accessory is anything we want to draw "on top" of our body.
## 
## This doesn't actually place it in the world or draw anything.
## That's an AccessoryModel.
@abstract 
class_name Accessory
extends Resource

## Where on the body the accessory should be placed (0 is on the tip of the head, 1 is on the end of the tail)
@export_range(0.0, 1.0, 0.01) var placement: float = 0.0

var accessory_model_scene: PackedScene = preload("res://component/accessory_model/accessory_model.tscn")

## Used to track which accessory model this corresponds to.
var current_accessory_model: AccessoryModel

## By default, we initialize a regular, empty accessory model.
## 
## But you can also initialize a custom scene with an AccessoryModel root.
## This allows you to use sprites and stuff instead of manually drawing everything
## and using the draw_accessory_model.
func init_accessory_model() -> AccessoryModel:
	var accessory_model: AccessoryModel = accessory_model_scene.instantiate()
	current_accessory_model = accessory_model
	return accessory_model

## Uses the accessory model to draw stuff!
@abstract func draw_accessory_model() -> void
