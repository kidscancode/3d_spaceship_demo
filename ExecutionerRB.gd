extends RigidBody3D

var max_speed = 45
var acceleration = 0.5
@export var pitch_speed = 31.0
@export var roll_speed = 7.5
@export var yaw_speed = 20.0

var throttle = 0
var pitch_input = 0
var roll_input = 0
var yaw_input = 0

func _ready():
	Debug.stats.add_property(self, "linear_velocity", "length")
	
func get_input(delta):
	if Input.is_action_pressed("throttle_up"):
		throttle = lerp(throttle, max_speed, acceleration * delta)
	if Input.is_action_pressed("throttle_down"):
		throttle = lerp(throttle, 0, acceleration * delta)
	roll_input = Input.get_action_strength("roll_right") - Input.get_action_strength("roll_left")
	pitch_input = Input.get_action_strength("pitch_up") - Input.get_action_strength("pitch_down")
	yaw_input = Input.get_action_strength("yaw_left") - Input.get_action_strength("yaw_right")
#	yaw_input = roll_input
	
func _integrate_forces(state):
	get_input(state.step)
	linear_velocity = -transform.basis.z * throttle
	apply_torque(-transform.basis.z * roll_input * 7.5)
	apply_torque(transform.basis.x * pitch_input * 35.5)
	apply_torque(transform.basis.y * yaw_input * 20)
