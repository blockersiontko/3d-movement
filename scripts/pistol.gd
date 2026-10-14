extends Node3D

@export var casing_scene = preload("res://scenes/casing.tscn")
@export var fire_rate = 0.1

@onready var casing_spawn: Marker3D = $CasingSpawn

var can_shoot := true


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("Shoot") and can_shoot:
		shoot()


func shoot() -> void:
	can_shoot = false
	spawn_casing()
	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true


func spawn_casing() -> void:
	var casing = casing_scene.instantiate()
	get_tree().current_scene.add_child(casing)
	casing.global_transform = casing_spawn.global_transform
	
	if casing is RigidBody3D:
		casing.collision_layer = 1 << 2
		casing.collision_mask = (1 << 0) | (1 << 2)
		var dir = casing_spawn.global_transform.basis.x
		casing.linear_velocity = dir * randf_range(1.5, 3.0) + Vector3.UP * randf_range(0.2, 0.5)
	
	await get_tree().create_timer(10.0).timeout
	if is_instance_valid(casing):
		casing.queue_free()
