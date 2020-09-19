extends Node2D

onready var editor = get_node("/root/World/cam_container")
onready var editor_cam = editor.get_node("Camera2D")

export var cam_speed = 10
export var cam_zoom_speed = 0.1
var is_panning = true

func _ready():
    editor_cam.current = true
    
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