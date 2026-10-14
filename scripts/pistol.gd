extends Node3D

@export var casing_scene = preload("res://scenes/casing.tscn")
@export var fire_rate = 0.1

@onready var casing_spawn: Marker3D = $CasingSpawn

var can_shoot := true


func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("Shoot") and can_shoot and not Autoloads.pistol_is_reloading:
		shoot()
		
	if Input.is_action_just_pressed("Reload") and not Autoloads.pistol_is_reloading:
		reload()
	if Autoloads.AmmoCount <= 0 and not Autoloads.pistol_is_reloading:
		reload()

func shoot() -> void:
	if Autoloads.AmmoCount <= 0:
		return
	can_shoot = false
	Autoloads.AmmoCount -= 1
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


func reload() -> void:
	if Autoloads.pistol_is_reloading:
		return
		
	if Autoloads.AmmoCount >= Autoloads.StartAmmoCount:
		return
	
	Autoloads.pistol_is_reloading = true
	can_shoot = false
	
	await get_tree().create_timer(3.2).timeout
	
	Autoloads.AmmoCount = Autoloads.StartAmmoCount
	
	Autoloads.pistol_is_reloading = false
	can_shoot = true
