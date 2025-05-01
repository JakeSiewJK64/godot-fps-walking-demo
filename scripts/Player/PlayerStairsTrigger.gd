extends Area3D

var stairs = 0

func enter_trigger(body):
	if "Stairs" in body.name:
		stairs += 1

func exit_trigger(body):
	if "Stairs" in body.name:
		stairs -= 1
