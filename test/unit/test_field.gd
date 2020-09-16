extends "res://addons/gut/test.gd"

var Field = load("res://Field/Field.gd")

func before_all():
	pass

func before_each():
	pass

func after_each():
	pass

func after_all():
	pass


func test_get_soil_always_returns_a_valid_soil():
	var field = autofree(Field.new())
	var substract = autofree(field.get_soil_minerals(Vector2(5, 42)))
	assert_gt(len(substract.minerals), 0)

func test_consuming_soil_substract():
	var field = autofree(Field.new())
	var pos = Vector2(5, 42)
	var substract = autofree(field.get_soil_minerals(pos))
	
	var original_values = autofree(substract.minerals.duplicate())

	for n in substract.minerals:
		substract.consume_mineral(n, 10)

	var same_substract = field.get_soil_minerals(pos)

	for n in same_substract.minerals:
		if original_values[n] > 0:
			assert_lt(same_substract.minerals[n], original_values[n])
