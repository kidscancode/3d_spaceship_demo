extends Spatial

onready var cameras = [$ChaseCamera, $FixedCamera]
var current_camera = 1

func _process(delta):
	$FixedCamera.look_at($ExecutionerKB.transform.origin, Vector3.UP)

func _unhandled_input(event):
	if event.is_action_pressed("ui_focus_next"):
		current_camera = wrapi(current_camera + 1, 0, cameras.size())
		cameras[current_camera].current = true
