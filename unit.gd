extends CharacterBody2D


@onready var movement_target : Vector2 = position
var movement_speed := 20.0
var gm : GameManager
var attack_charge := 0.0
var attack_rate := 2.0
var attack_range := 200
var attack_damage := 1
var mana := 50
var max_mana := 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


func _process(delta: float) -> void:
	queue_redraw()
	
	var target = gm.find_closest_creep(self)
	if target != null and is_in_attack_range(target) and mana > 0:
		attack_charge += attack_rate * delta
		if attack_charge > 1.0:
			attack(target)
	else:
		attack_charge = 0.0
		
	get_node("Mask").size.y = (1 - float(mana) / max_mana) * 28.0

func _draw() -> void:
	draw_dashed_line((movement_target - position), Vector2.ZERO, Color.WHITE, 0.5, 5.0, false, true)
	
func is_in_attack_range(target: Node2D) -> bool:
	return position.distance_to(target.position) < attack_range


func attack(target: Node2D) -> void:
	var direction = position.direction_to(target.position)
	gm.spawn_projectile(position, direction, attack_damage)
	attack_charge = 0.0
	mana -= 1


func _physics_process(delta: float) -> void:
	var direction = position.direction_to(movement_target)
	velocity = direction * movement_speed
	if move_and_slide():
		print("GAME OVER")
		get_tree().reload_current_scene()
