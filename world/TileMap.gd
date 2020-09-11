extends TileMap

var gound

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
#	_tileset = get_tileset()
#	set_process_input(true)

func _input(event):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			left_clicked_on_tile(world_to_map(event.position))

func left_clicked_on_tile(pos: Vector2):
	print(pos)
