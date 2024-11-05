extends CharacterBody2D

var gm : GameManager
var remove := false
var movement_speed := 6.0
var hp := 10
var hit_frames = 0
@onready var color = $Sprite2D.modulate

func _process(delta: float) -> void:
	hit_frames -= 1
	if hit_frames > 0:
		$Sprite2D.modulate = Color(1, 1, 1)
	else:
		$Sprite2D.modulate = color
	pass
	
func _physics_process(delta: float) -> void:
	var target = gm.find_closest_unit(self)
	var direction = position.direction_to(target.position)
	velocity = direction * movement_speed
	move_and_slide()


func hit(damage):
	hit_frames = 3
	hp -= damage
	if hp <= 0:
		remove = true
		gm.score += 1
