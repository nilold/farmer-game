extends "res://addons/gut/test.gd"

var MyClass = load("res:/my_script.gd")

func before_all():
	pass

func before_each():
	pass

func after_each():
	pass

func after_all():
	pass


func test_somehting():
	gut.p("This is a test")
	assert_eq(1, 1)
