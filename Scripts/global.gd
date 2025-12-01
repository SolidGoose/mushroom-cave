extends Node

var allow_restart: bool = false


func fade_in(node: Node, fade_in_duration: float = 1.0) -> void:
	print("Starting fade-in for the node: " + str(node.name))
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1, fade_in_duration)
	tween.play()
	await tween.finished
	tween.kill()


func fade_out(node: Node, fade_out_duration: float = 1.0) -> void:
	print("Starting fade-out for the node: " + str(node.name))
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 0, fade_out_duration)
	tween.play()
	await tween.finished
	tween.kill()


func _input(event):
	if event.is_action_pressed("Restart") and allow_restart:
		print("Restarting level...")
		get_tree().reload_current_scene()
		allow_restart = false
