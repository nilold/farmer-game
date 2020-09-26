extends Node2D

onready var _weather = $Weather

func get_temperature():
	return _weather.temperature

func get_sun_strength():
	return _weather.sun_strength