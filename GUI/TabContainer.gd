extends TabContainer

onready var object_cursor = get_node("/root/World/Editor_Object")


func _on_TabContainer_mouse_entered():
	#TODO: not working well
	print("entered")
	object_cursor.can_place = false
	
	
func _on_TabContainer_mouse_exited():
	print("exited")
	object_cursor.can_place = true
