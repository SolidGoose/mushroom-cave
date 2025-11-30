extends CharacterBody2D

const tile_size: Vector2 = Vector2(16, 16)
var sprite_node_pos_tween: Tween


func _physics_process(delta: float) -> void:
	if !sprite_node_pos_tween or not sprite_node_pos_tween.is_running():
		if Input.is_action_just_pressed("Up") and !$Up.is_colliding():
			print("Going up!")
			_move(Vector2(0, -1))
		elif Input.is_action_just_pressed("Down") and !$Down.is_colliding():
			print("Going down!")
			_move(Vector2(0, 1))
		elif Input.is_action_just_pressed("Left") and !$Left.is_colliding():
			print("Going left!")
			_move(Vector2(-1, 0))
		elif Input.is_action_just_pressed("Right") and !$Right.is_colliding():
			print("Going right!")
			_move(Vector2(1, 0))


func _move(dir: Vector2):
	var walk_vector: Vector2 = dir * tile_size
	print("Moving mushroom: " + str(walk_vector))
	global_position += walk_vector
	$AnimatedSprite2D.global_position -= walk_vector

	if sprite_node_pos_tween:
		print("Killing existing tween")
		sprite_node_pos_tween.kill()
	print("Creating new tween")
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property($AnimatedSprite2D, "global_position", global_position, 0.2).set_trans(Tween.TRANS_SINE)
