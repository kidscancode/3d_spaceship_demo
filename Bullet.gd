extends Area

var speed = 150

func _physics_process(delta):
	transform.origin += -transform.basis.z * speed * delta


func _on_Bullet_body_entered(body):
	pass # Replace with function body.


func _on_Timer_timeout():
	queue_free()
