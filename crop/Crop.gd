extends "res://crop/Inffectable.gd"

export var MAX_HEALTH = 100
var health = MAX_HEALTH
var index: Vector2


func _ready():
	print("new Node at " + str(index))

#func _input(event):
#	pass

func left_clicked_on_tile():
	print("Clicked on crop at" + str(index))

func _on_Crop_mouse_entered():
	pass # Replace with function body.


func _on_Crop_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.pressed:
		if event.button_index == BUTTON_LEFT:
			left_clicked_on_tile()


func activate_diseases():
	pass
