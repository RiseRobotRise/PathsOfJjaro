extends Spatial

var id = 2

func _on_Area_body_entered(body):
	if body.has_method("pick_up"):
		body.pick_up(id, "ammo")
		queue_free()
