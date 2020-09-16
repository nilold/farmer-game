extends Node2D

var can_place = true
var is_panning = true
onready var ground = get_node("/root/World/Ground/Field")
onready var field = ground.get_node("Field")
onready var editor = get_node("/root/World/cam_container")
onready var editor_cam = editor.get_node("Camera2D")

var current_item

export var cam_speed = 10

func _ready():
	editor_cam.current = true


func _process(_delta):
	global_position = get_global_mouse_position()
	if current_item and can_place and Input.is_action_just_pressed("mb_left"):
		print("Can place:" + str(can_place))
		if current_item._bundled.names[0] == "Crop":
			_place_on_field(global_position)
		else:
			_place_on_ground(global_position)

	move_editor()
	is_panning = Input.is_action_pressed("mb_middle")

#TODO: actually we should have another TileMap to place buildings and other stuff
# because it shouldnt be so free
func _place_on_ground(global_position):
	var new_item = current_item.instance()
	ground.add_child(new_item)
	new_item.position = global_position


func _place_on_field(global_position):
	var new_crop = current_item.instance()
	field.add_crop_at(new_crop, global_position)


#TODO: move this logic to elsewhere
func move_editor():
	if Input.is_action_pressed("w"):
		editor.global_position.y -= cam_speed
	if Input.is_action_pressed("a"):
		editor.global_position.x -= cam_speed
	if Input.is_action_pressed("s"):
		editor.global_position.y += cam_speed
	if Input.is_action_pressed("d"):
		editor.global_position.x += cam_speed
