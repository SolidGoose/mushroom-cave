extends Area2D


func _on_body_entered(body: Node2D) -> void:
	print("Body detected")
	print("Body: " + str(body.get_groups()))
	if body.is_in_group("Player"):
		print("Player reached finish area!")
		LevelTransition.change_scene_to("res://Scenes/game_over_screen.tscn")
