extends Node2D

var weapon_data : WeaponData
@onready var weapon_sprite : Sprite2D = $WeaponPivot/Sprite2D

func set_weapon_data(data : WeaponData):
	weapon_sprite.texture = data.texture
