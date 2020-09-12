extends Node2D

onready var substract = $Substract
onready var sprite = $Sprite
var diseases = {}

func inffect(disease):
	var success = false
	if not disease.ID in diseases and inffection_succeeds(disease):
		diseases[disease.ID] = disease
		success = true
		
	if len(diseases) > 0:
		sprite.material.set_shader_param("redish", true)
		
	return success

func inffection_succeeds(_disease):
	return randf() > 0.7

func activate_diseases():
	for disease in diseases:
		disease.consume(substract)
