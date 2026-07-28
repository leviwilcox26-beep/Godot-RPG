extends Node

@export var weapon_data : WeaponData
@onready var weapon_visual : Node2D = $WeaponVisual
@onready var weapon_hitbox : Area2D = $WeaponHitbox

func _ready() -> void:
	if weapon_data:
		weapon_visual.set_weapon_data(weapon_data)
		weapon_hitbox.set_weapon_data(weapon_data)
