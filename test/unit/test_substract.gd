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


func test_nutrients_consumption():
	substract.nutrients = {"K": 10}

	assert_eq(substract.consume_nutrient("K", 7), 7)
	assert_eq(substract.consume_nutrient("K", 7), 3)
	assert_eq(substract.consume_nutrient("K", 7), 0)
