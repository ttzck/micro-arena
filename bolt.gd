extends Area2D

func _on_body_entered(body: Node2D):
	body.mana = body.max_mana
	queue_free()
