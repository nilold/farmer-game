extends Node2D

enum mouse_states {
	ADD_CROP,
	ADD_DISEASE,
	EVOLVE,
	SPREAD
}

var mouse_state = 0

func _input(event):
	if event is InputEventKey:
		match event.scancode:
			KEY_K:
				mouse_state = mouse_states.ADD_CROP
				print("add_crop")
			KEY_D:
				mouse_state = mouse_states.ADD_DISEASE
				print("add_disease")
			KEY_E:
				mouse_state = mouse_states.EVOLVE
				print("evolve (not implemented)")
			KEY_S:
				mouse_state = mouse_states.SPREAD
				print("spread")
