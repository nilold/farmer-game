extends TileMap

var Crop1 = preload("res://crop/Crop.tscn")
onready var crops = $Crops

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	_tileset = get_tileset()
#	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			BUTTON_LEFT:
				left_clicked_on_tile()
			BUTTON_MIDDLE:
				middle_button_clicked()

func left_clicked_on_tile():
	pass

func middle_button_clicked():
	create_new_crop_at(get_global_mouse_position())

func create_new_crop_at(global_position):
	var newCrop = Crop1.instance()
	var mapPos = world_to_map(global_position)
	newCrop.position = map_to_world(mapPos)
	newCrop.index = mapPos
	crops.add_child(newCrop)
