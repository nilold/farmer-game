extends MarginContainer

onready var Item = preload("res://GUI/StatusItem.tscn")
onready var items = $Items


func _add_item(key: String, value: String):
	var item = Item.instance()
	item.name = key
	items.add_child(item)
	item.set(key, value)


func set_item(key: String, value: String):
	var item = items.get_node(key)
	if item:
		item.set(key, value)
	else:
		_add_item(key, value)
