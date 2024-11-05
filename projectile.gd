extends CharacterBody2D

var damage : int


func _ready() -> void:
	pass # Replace with function body.


func _physics_process(delta: float) -> void:
	var collision = move_and_collide(velocity * delta)
	if collision:
		var coll = collision.get_collider()
		coll.hit(damage)
		queue_free()
