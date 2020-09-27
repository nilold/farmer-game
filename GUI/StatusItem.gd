extends HBoxContainer

onready var key_item = get_node("Key")
onready var value_item = get_node("Value")


func set(key: String, value: String):
	key_item.set_text(key)
	value_item.set_text(value)
