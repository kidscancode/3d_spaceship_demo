extends KinematicBody

export (PackedScene) var Bullet = preload("res://Bullet.tscn")
export var max_speed = 50
export var acceleration = 0.6
export var pitch_speed = 1.5
export var roll_speed = 1.9
export var yaw_speed = 0.75
export var input_response = 8.0

var velocity = Vector3.ZERO
var forward_speed = 0
var pitch_input = 0
var roll_input = 0
var yaw_input = 0
var can_shoot = true


func _ready():
	Debug.stats.add_property(self, "velocity", "length")
	$Executioner.material_override = $Executioner.get_active_material(0).duplicate()
#	$Executioner.set_surface_material(1, $Executioner.get_surface_material(1).duplicate())
	$ThrustLeft.emitting = true
	$ThrustRight.emitting = true


func get_input(delta):
	if Input.is_action_pressed("throttle_up"):
		forward_speed = lerp(forward_speed, max_speed, acceleration * delta)
	if Input.is_action_pressed("throttle_down"):
		forward_speed = lerp(forward_speed, 0, acceleration * delta)

	pitch_input = lerp(pitch_input, 
			Input.get_action_strength("pitch_up") - Input.get_action_strength("pitch_down"),
			input_response * delta)
	roll_input = lerp(roll_input,
			Input.get_action_strength("roll_left") - Input.get_action_strength("roll_right"),
			input_response * delta)
#	yaw_input = lerp(yaw_input,
#			Input.get_action_strength("yaw_left") - Input.get_action_strength("yaw_right"), 
#			input_response * delta)
	yaw_input = roll_input

	if Input.is_action_pressed("shoot") and can_shoot:
		can_shoot = false
		$Timer.start()
		AudioManager.play("res://assets/sfx_07b.ogg")
		for gun in $Guns.get_children():
			var b = Bullet.instance()
			owner.add_child(b)
			b.global_transform = gun.global_transform
			b.speed += velocity.length()
			


func _physics_process(delta):
	get_input(delta)
	transform.basis = transform.basis.rotated(transform.basis.z, roll_input * roll_speed * delta)
	transform.basis = transform.basis.rotated(transform.basis.x, pitch_input * pitch_speed * delta)
	transform.basis = transform.basis.rotated(transform.basis.y, yaw_input * yaw_speed * delta)
	transform.basis = transform.basis.orthonormalized()
	velocity = -transform.basis.z * forward_speed
	move_and_collide(velocity * delta)


func _on_Timer_timeout():
	can_shoot = true
