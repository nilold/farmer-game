extends MarginContainer

onready var Item = preload("res://GUI/StatusItem.tscn")
onready var crop_items = $watchers/CropItems
onready var field_items = $watchers/FieldItems

enum containers { CROP, FIELD }


func _add_crop_item(key: String, value):
	var item = Item.instance()
	item.name = key
	crop_items.add_child(item)
	item.set(key, value)


func _add_field_item(key: String, value):
	var item = Item.instance()
	item.name = key
	field_items.add_child(item)
	item.set(key, value)


func set_item(key: String, value, container: int = containers.CROP):
	match container:
		containers.CROP:
			var item = crop_items.get_node(key)
			if item:
				item.set(key, value)
			else:
				_add_crop_item(key, value)
		containers.FIELD:
			var item = field_items.get_node(key)
			if item:
				item.set(key, value)
			else:
				_add_field_item(key, value)
