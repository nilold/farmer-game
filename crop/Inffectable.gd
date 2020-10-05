extends Node2D

onready var substract = $Substract
onready var sprite = $Sprite

export var MAX_HEALTH: float = 1.0
var health = MAX_HEALTH
var diseases = {}


func inffect(disease):
	var success = false
	if not disease.ID in diseases and _inffection_succeeds(disease):
		diseases[disease.ID] = disease
		success = true

		if len(diseases) > 0 and sprite:
			sprite.material.set_shader_param("redish", true)

			return success


func has_disease(disease_id: String):
	return disease_id in diseases


func _inffection_succeeds(_disease):
	return randf() > (health / MAX_HEALTH) - 0.1  # becouse nobody is invencible


func _activate_diseases():
	for disease in diseases:
		diseases[disease].consume(substract)
