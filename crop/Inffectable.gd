extends Node2D

onready var substract = $Substract
onready var sprite = $Sprite

export var MAX_HEALTH = 100
var health = MAX_HEALTH
var diseases = {}


func inffect(disease):
	var success = false
	if not disease.ID in diseases and inffection_succeeds(disease):
		diseases[disease.ID] = disease
		success = true

	if len(diseases) > 0 and sprite:
		sprite.material.set_shader_param("redish", true)

	return success


func inffection_succeeds(_disease):
	return randf() > (health / MAX_HEALTH) - 0.1  # becouse nobody is invencible


func activate_diseases():
	for disease in diseases:
		disease.consume(substract)


func has_disease(disease_id: String):
	return disease_id in diseases
