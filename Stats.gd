extends Node2D

enum mouse_states { ADD_CROP, ADD_DISEASE, EVOLVE, SPREAD, CYCLE }

var mouse_state = 0

onready var editor = get_node("/root/World/cam_container")
var editor_cam

export var cam_speed = 10
export var cam_zoom_speed = 0.1
var is_panning = true

func _ready():
	if editor:
		editor_cam = editor.get_node("Camera2D")
		editor_cam.current = true
	else:
		printerr("Couldn't set camera")
	
func _process(_delta):
	move_editor()

#############################################################################
# Camera movement
func move_editor():
	if Input.is_action_pressed("w"):
		editor.global_position.y -= cam_speed
	if Input.is_action_pressed("a"):
		editor.global_position.x -= cam_speed
	if Input.is_action_pressed("s"):
		editor.global_position.y += cam_speed
	if Input.is_action_pressed("d"):
		editor.global_position.x += cam_speed


func _unhandled_input(event):
	#TODO: handle max/min zoom
	if event is InputEventMouseButton and event.is_pressed():
		if event.button_index == BUTTON_WHEEL_UP:
			editor_cam.zoom -= Vector2(cam_zoom_speed, cam_zoom_speed)
		if event.button_index == BUTTON_WHEEL_DOWN:
			editor_cam.zoom += Vector2(cam_zoom_speed, cam_zoom_speed)

	if event is InputEventMouseMotion and Input.is_action_pressed("mb_middle"):
		editor.global_position -= event.relative * editor_cam.zoom

###############################################################################

func _input(event):
	if event is InputEventKey:
		match event.scancode:
			KEY_K:
				mouse_state = mouse_states.ADD_CROP
				print("add_crop")
			KEY_D:
				mouse_state = mouse_states.ADD_DISEASE
				print("add_disease")
			KEY_E:
				mouse_state = mouse_states.EVOLVE
				print("evolve (not implemented)")
			KEY_S:
				mouse_state = mouse_states.SPREAD
				print("spread")
			KEY_C:
				mouse_state = mouse_states.CYCLE
				print("cycle")
