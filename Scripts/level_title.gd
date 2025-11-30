extends Control

var fade_duration = 1.0

func _ready():
	$Title.modulate.a = 0
	fade_in()
	print("Start timer")
	$DisplayDelayTimer.start()

func fade_in():
	print("Starting fade-in")
	var tween = create_tween()
	tween.tween_property($Title, "modulate:a", 1, fade_duration)
	tween.play()
	await tween.finished
	tween.kill()

func fade_out():
	print("Starting fade-out")
	var tween = create_tween()
	tween.tween_property($Title, "modulate:a", 0, fade_duration)
	tween.play()
	await tween.finished
	tween.kill()

func _on_display_delay_timer_timeout() -> void:
	print("Display delay timer timeout")
	fade_out()
