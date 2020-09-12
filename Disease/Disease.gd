extends Node


var ID = "DISEASE"

export var MAX_HEALTH = 100
export var health = 100
export var CONTAMINATION_RADIUS = 1

func _to_string():
	return self.ID + ", health: " + str(self.health)

func copy():
#	override in derived class
	assert(false)
