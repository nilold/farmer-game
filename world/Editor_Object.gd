extends Node2D

onready var ground = get_node("/root/World/Ground")
onready var field = ground.get_node("Field")

var can_place = true
var current_item
var is_placing = false
var start_pos
var end_pos


func _process(_delta):
	global_position = get_global_mouse_position()
	if current_item and can_place:
		if Input.is_action_just_pressed("mb_left"):
			is_placing = true
			start_pos = global_position

		elif is_placing and Input.is_action_just_released("mb_left"):
			is_placing = false
			end_pos = global_position

			var place_positions = _calculate_posistions()

			if current_item._bundled.names[0] == "Crop":
				for pos in place_positions:
					_place_on_field(pos)
			else:
				for pos in place_positions:
					_place_on_ground(pos)


func _calculate_posistions():
	if start_pos == end_pos:
		return [start_pos]

	var step_x = 1
	var step_y = 1
	if start_pos.x > end_pos.x:
		step_x = -1
	if start_pos.y > end_pos.y:
		step_y = -1

	var positions = []
	for x in range(start_pos.x, end_pos.x, step_x):
		for y in range(start_pos.y, end_pos.y, step_y):
			positions.append(Vector2(x, y))

	return positions


#TODO: actually we should have another TileMap to place buildings and other stuff
# because it shouldnt be so free
func _place_on_ground(position):
	var new_item = current_item.instance()
	ground.add_child(new_item)
	new_item.position = position


func _place_on_field(position):
	var new_crop = current_item.instance()
	field.add_crop_at(new_crop, position)
