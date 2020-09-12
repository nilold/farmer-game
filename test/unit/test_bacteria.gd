extends "res://addons/gut/test.gd"

var Bacteria = load("res://Disease/Bacteria.gd")
var Substract = load("res://Substract.gd")

var substract
var bacteria
var initial_health = 100


func before_all():
	pass


func before_each():
	substract = autofree(Substract.new())
	bacteria = autofree(Bacteria.new())
	bacteria.health = initial_health


func after_each():
	pass


func after_all():
	pass


func test_bacteria_dies_after_if_no_nutrient():
	substract.nutrients = {}
	bacteria.consume(substract)

	assert_lt(bacteria.health, initial_health)
	assert_true(bacteria.is_dead)


func test_bacteria_reduces_health_if_insuficient_nutrients():
	substract.nutrients = {"Na": 8}
	bacteria.needs = {"Na": 5}

	bacteria.consume(substract)
	assert_eq(bacteria.health, initial_health)

	bacteria.consume(substract)
	assert_lt(bacteria.health, initial_health)
	assert_gt(bacteria.health, 0)
