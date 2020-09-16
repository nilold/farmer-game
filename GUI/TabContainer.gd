extends TabContainer

onready var object_cursor = get_node("/root/World/Editor_Object")


func _on_TabContainer_mouse_entered():
	object_cursor.hide()
	object_cursor.can_place = false
	
	
func _on_TabContainer_mouse_exited():
	object_cursor.show()
	object_cursor.can_place = true
