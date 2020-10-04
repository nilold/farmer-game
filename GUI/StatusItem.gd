extends HBoxContainer

onready var key_item = get_node("Key")
onready var value_item = get_node("Value")

func _round2(value:float):
	return round(100 * value) / 100

func _str_dict(dict):
	var str_dict = ""
	for key in dict:
		str_dict += key + ":" + str(_round2(dict[key])) + ", "

	return str_dict

func set(key: String, value):
	key_item.set_text(key)
	if typeof(value) == TYPE_REAL:
		value = _round2(value)
	elif typeof(value) == TYPE_DICTIONARY:
		value = _str_dict(value)
	value_item.set_text(str(value))
