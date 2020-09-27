extends Node2D

onready var _weather = $Weather
onready var _statuses = $Statuses

func get_temperature():
	return _weather.temperature

func get_sun_strength():
	return _weather.sun_strength

func get_watcher():
	return _statuses
