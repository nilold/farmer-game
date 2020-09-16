extends ScrollContainer

onready var object_cursor = get_node("/root/World/Editor_Object")


# Called when the node enters the scene tree for the first time.
func _ready():
	var _err1 = connect("mouse_entered", self, "mouse_enter")
	var _err2 = connect("mouse_exited", self, "mouse_leave")


func mouse_enter():
	object_cursor.hide()
	object_cursor.can_place = false
	
	
func mouse_leave():
	object_cursor.show()
	object_cursor.can_place = true
