extends "res://addons/gut/test.gd"

var Substract = load("res://Substract.gd")

var substract


func before_all():
	pass


func before_each():
	substract = autofree(Substract.new())


func after_each():
	pass


func after_all():
	pass


func test_add_mineral():
	substract.minerals = {}
	substract.add_mineral("K", 10)
	assert_eq(substract.minerals["K"], 10.0)


func test_minerals_consumption():
	substract.minerals = {"K": 10}

	assert_eq(substract.consume_mineral("K", 7), 7.0)
	assert_eq(substract.consume_mineral("K", 7), 3.0)
	assert_eq(substract.consume_mineral("K", 7), 0.0)


func test_water_consumption():
	substract.water = 10

	assert_eq(substract.consume_water(7), 7.0)
	assert_eq(substract.consume_water(7), 3.0)
	assert_eq(substract.consume_water(7), 0.0)
