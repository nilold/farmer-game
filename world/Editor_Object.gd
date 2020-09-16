extends Node2D

var can_place = true
onready var ground = get_node("/root/World/Ground/Field")
onready var field = get_node("/root/World/Ground/Field")

var current_item


func _ready():
	pass  # Replace with function body.


func _process(_delta):
	global_position = get_global_mouse_position()
	if current_item and can_place and Input.is_action_just_pressed("mb_left"):
		print("Can place:" + str(can_place))
		if current_item._bundled.names[0] == "Crop":
			_place_on_field(global_position)
		else:
			_place_on_ground(global_position)

#TODO: actually we should have another TileMap to place buildings and other stuff
# because it shouldnt be so free
func _place_on_ground(global_position):
	var new_item = current_item.instance()
	ground.add_child(new_item)
	new_item.position = global_position


func _place_on_field(global_position):
	var new_crop = current_item.instance()
	field.add_crop_at(new_crop, global_position)
