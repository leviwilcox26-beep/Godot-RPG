extends CharacterBody2D


@onready var animation_player : AnimationPlayer = $AnimationPlayer
const SPEED : float = 75.0
const DASH_SPEED : float = 175.0
var is_dashing : bool = false
var health : int = 100
var pointing : String

func _ready() -> void:
	if SaveManager.data:
		print("applying save data")
		global_position = SaveManager.data.player_pos
		health = SaveManager.data.player_health

func _process(_delta: float) -> void:
	die()
	attack()

func _physics_process(delta: float) -> void:
	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_vector("left", "right", "up", "down")
	# If not dashing, look for input with regular speed
	if !is_dashing:
		if direction:
			velocity = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			velocity.y = move_toward(velocity.y, 0, SPEED)
	# If not dashing and dash is pressed, use dash speed and start the countdown
	if Input.is_action_just_pressed("dash") && !is_dashing:
		velocity = direction * DASH_SPEED
		$DashLengthTimer.start()
		is_dashing = true
	
	# Teleports
	if Input.is_action_just_pressed("create_portal"):
		SaveManager.create_new_save_point()
		
	
	# Finds out which way the player is facing
	var dir_to_mouse = round(global_position.direction_to(get_global_mouse_position()).normalized())
	if dir_to_mouse.x > 0:
		pointing = "right"
	elif dir_to_mouse.x < 0:
		pointing = "left"
	elif dir_to_mouse.y < 0:
		pointing = "up"
	else:
		pointing = "down"
	
	move_and_slide()

func _on_dash_length_timer_timeout() -> void:
	is_dashing = false
		

func attack():
	if Input.is_action_just_pressed("attack"):
		if pointing == "right":
			animation_player.play("default")
			# Wait until animation player is done to continue function
			await animation_player.animation_finished
				
		elif pointing == "left":
			animation_player.play("swing_left")
			await animation_player.animation_finished
		elif pointing == "up":
			animation_player.play("swing_up")
			await animation_player.animation_finished
		else:
			animation_player.play("swing_down")
			await animation_player.animation_finished
	else:
		pass


func die():
	if health == 0:
		queue_free()

func take_damage(damage : int):
	health -= damage
	print(health)

func _on_damage_area_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		take_damage(20)
		$ProgressBar.value = health
		$ProgressBar.show()
		$DamageTimer.start()

func _on_damage_area_body_exited(body: Node2D) -> void:
	$DamageTimer.stop()
	$ProgressBar.hide()

func _on_damage_timer_timeout() -> void:
	take_damage(20)
	$ProgressBar.value = health
