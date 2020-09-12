extends "res://Disease/Disease.gd"

export var contamination_radius = 1

func _init():
	ID = "BACTERIA"
	CONTAMINATION_RADIUS = contamination_radius

func copy():
	return self.duplicate()

export var needs = {
	"K": 5,
}
