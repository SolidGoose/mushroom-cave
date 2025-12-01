extends CharacterBody2D

const tile_size: Vector2 = Vector2(16, 16)
var sprite_node_pos_tween: Tween
var tml: TileMapLayer

# ice = (8, 1), grey/floor = (1,7), wall = (1,1)
const ICE_CELL_TYPE = Vector2i(8,1)
const FLOOR_CELL_TYPE = Vector2i(1,7)
const WALL_CELL_TYPE = Vector2i(1,1)

func _ready() -> void:
	tml = get_parent().get_node("TileMapLayer")

func _physics_process(delta: float) -> void:
	if !sprite_node_pos_tween or not sprite_node_pos_tween.is_running():
		var dir = Vector2(0,0)
		var pos = Vector2(0,0)
		if Input.is_action_just_pressed("Up") and !$Up.is_colliding():
			dir = Vector2(0, -1)
			pos = tml.local_to_map(global_position)
		elif Input.is_action_just_pressed("Down") and !$Down.is_colliding():
			dir = Vector2(0, 1)
			pos = tml.local_to_map(global_position)
		elif Input.is_action_just_pressed("Left") and !$Left.is_colliding():
			dir = Vector2(-1, 0)
			pos = tml.local_to_map(global_position)
		elif Input.is_action_just_pressed("Right") and !$Right.is_colliding():
			dir = Vector2(1, 0)
			pos = tml.local_to_map(global_position)
		
		if is_ice_next(dir, pos):
			var len = get_ice_length(dir, pos)
			var speed = 0.185*(len+1) # change 0.2 to what speed you want
			dir = dir*(len+1) # this is hacky i know
			_move(dir, speed)
		else:
			if dir != Vector2(0,0):
				_move(dir)
		
func is_ice(pos: Vector2):
	var cell_type = tml.get_cell_atlas_coords(pos)
	if cell_type != Vector2i(-1, -1):
		return cell_type == ICE_CELL_TYPE
	return false
	
func is_ice_next(dir: Vector2, pos: Vector2):
	var pos_new = Vector2(dir.x+pos.x, dir.y+pos.y)
	return is_ice(pos_new)
	
func is_tile(pos: Vector2, TILE_TYPE: Vector2i):
	var cell_type = tml.get_cell_atlas_coords(pos)
	if cell_type != Vector2i(-1, -1):
		return cell_type == TILE_TYPE
	return false 

func get_ice_length(dir: Vector2, pos: Vector2):
	var i = pos.x
	var j = pos.y
	var len = 0
	
	while i >= 0 and j >= 0:
		i = i + dir.x
		j = j + dir.y
		var curr_pos = Vector2i(i,j)
		var cell_type = tml.get_cell_atlas_coords(curr_pos)
		if cell_type == ICE_CELL_TYPE:
			len += 1
		else:
			if is_tile(curr_pos, FLOOR_CELL_TYPE):
				return len
			elif is_tile(curr_pos, WALL_CELL_TYPE):
				return len-1
	return len

func _move(dir: Vector2, speed: float=0.2):
	var walk_vector: Vector2 = dir * tile_size
	global_position += walk_vector
	$AnimatedSprite2D.global_position -= walk_vector

	if sprite_node_pos_tween:
		sprite_node_pos_tween.kill()
	
	sprite_node_pos_tween = create_tween()
	sprite_node_pos_tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	sprite_node_pos_tween.tween_property($AnimatedSprite2D, "global_position", global_position, speed).set_trans(Tween.TRANS_SINE)
