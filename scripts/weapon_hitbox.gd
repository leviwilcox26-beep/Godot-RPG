extends Area2D

var hit_targets : Array = []
var weapon_data : WeaponData

func set_weapon_data(data : WeaponData):
	weapon_data = data

func _on_body_entered(body: Node2D) -> void:
	#If the hit body has already been hit, return
	if body in hit_targets or body.is_in_group('player'):
		return
	
	hit_targets.append(body)
	
	if body.has_method("take_damage"):
		body.take_damage(weapon_data.damage)

func start_hitbox():
	hit_targets.clear()
	$CollisionShape2D.monitoring = true
	
func stop_hitbox():
	$CollisionShape2D.monitoring = false
