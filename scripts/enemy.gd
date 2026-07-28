extends CharacterBody2D

var enemy_health : int = 100
var target : Node2D

const SPEED : float = 250.0

func _process(_delta: float) -> void:
	die()
	
func _physics_process(_delta: float) -> void:
	if target == null:
		return
	else:
		var direction = global_position.direction_to(target.global_position)
		velocity = direction * SPEED
		
	move_and_slide()


func take_damage(damage : int):
	enemy_health -= damage
	$ProgressBar.value = enemy_health
	$ProgressBar.show()
	
func die():
	if enemy_health == 0:
		queue_free()
		


func _on_detection_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = body


func _on_detection_range_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		target = null
		$ProgressBar.hide()
