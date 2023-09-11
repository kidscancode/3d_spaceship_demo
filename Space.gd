extends Node3D

@onready var cameras = [$ChaseCamera, $FixedCamera]
var current_camera = 1

func _ready():
	AudioManager.play("res://assets/DST-RailJet [qubodup short-cut loop].ogg")
	$Imperial/Imperial2.get_active_material(0).albedo_texture = load("res://assets/ultimate_spaceships/Imperial_Red.png")
	
func _process(delta):
	$FixedCamera.look_at($ExecutionerKB.transform.origin, Vector3.UP)
	
func _unhandled_input(event):
	if event.is_action_pressed("ui_focus_next"):
		current_camera = wrapi(current_camera + 1, 0, cameras.size())
		cameras[current_camera].current = true
