extends Node2D

class_name GameManager

var projectile_speed := 150.0
var creep_wave_size := 5
var creep_spawn_period := 10
var bolt_spawn_period := 8

var score := 0

var keys = [KEY_Q, KEY_W, KEY_E, KEY_R, KEY_A, KEY_S, KEY_D, KEY_F]
var labels = ["Q", "W", "E", "R", "A", "S", "D", "F"]

const UNIT_SCENE = preload("res://unit.tscn")
const CREEP_SCENE = preload("res://creep.tscn")
const PROJECTILE_SCENE = preload("res://projectile.tscn")
const BOLT_SCENE = preload("res://bolt.tscn")
const SKULL_SCENE = preload("res://skull.tscn")

var units = []
var creeps = []

@onready var center = Vector2(get_viewport().size.x/2, get_viewport().size.y/2)


func _ready() -> void:
	for i in keys.size():
		spawn_unit(center + Vector2(i * 10, 0), labels[i])
	
	spawn_creep_wave()

	var creep_spawn_timer = Timer.new()
	add_child(creep_spawn_timer)
	creep_spawn_timer.timeout.connect(spawn_creep_wave) 
	creep_spawn_timer.start(creep_spawn_period)
	
	var bolt_spawn_timer = Timer.new()
	add_child(bolt_spawn_timer)
	bolt_spawn_timer.timeout.connect(func(): spawn_bolt(random_position())) 
	bolt_spawn_timer.start(bolt_spawn_period)


func spawn_creep_wave():
	var pos = random_position()
	var skull = spawn_skull(pos)
	await get_tree().create_timer(5).timeout 
	for i in creep_wave_size:
		spawn_creep(pos + Vector2(randf() * 30, randf() * 30))
	skull.queue_free()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		for i in keys.size():
			if Input.is_key_pressed(keys[i]):
				units[i].movement_target = get_viewport().get_mouse_position()


func _process(delta: float) -> void:
	for i in keys.size():
		var label = units[i].get_node("Label")
		label.scale = Vector2(0.05, 0.05)
		if Input.is_key_pressed(keys[i]):
			label.scale = Vector2(0.1, 0.1)
	
	var new_creeps = []
	for creep in creeps:
		if creep.remove:
			creep.queue_free()
		else:
			new_creeps.push_back(creep)
	creeps = new_creeps
	
	$Label.text = str(score)


func random_position() -> Vector2:
	var size = get_viewport().size
	return Vector2(randf() * size.x, randf() * size.y)


func find_closest(objects: Array, pos: Vector2) -> Node2D:
	var closest_obj = null
	var min_distance = INF
	for obj in objects:
		var distance = pos.distance_squared_to(obj.position)
		if min_distance > distance:
			min_distance = distance
			closest_obj = obj
	return closest_obj


func find_closest_creep(node):
	return find_closest(creeps, node.position)


func find_closest_unit(node):
	return find_closest(units, node.position)


func spawn_projectile(pos: Vector2, direction: Vector2, damage: int) -> void:
	var projectile = PROJECTILE_SCENE.instantiate()
	projectile.position = pos
	projectile.velocity = direction * projectile_speed
	projectile.damage = damage
	projectile.look_at(pos + direction)
	add_child(projectile)


func spawn_unit(pos: Vector2, text: String) -> void:
	var unit = UNIT_SCENE.instantiate()
	unit.position = pos
	unit.gm = self
	unit.get_node("Label").text = text
	add_child(unit)
	units.push_back(unit)


func spawn_creep(pos: Vector2) -> void:
	var creep = CREEP_SCENE.instantiate()
	creep.position = pos
	creep.gm = self
	add_child(creep)
	creeps.push_back(creep)


func spawn_bolt(pos: Vector2) -> void:
	var bolt = BOLT_SCENE.instantiate()
	bolt.position = pos
	add_child(bolt)
	

func spawn_skull(pos: Vector2):
	var skull = SKULL_SCENE.instantiate()
	skull.position = pos
	add_child(skull)
	return skull
