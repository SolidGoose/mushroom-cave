extends Control

var fade_duration = 1.0

@onready var title = $Title

func _ready():
	title.modulate.a = 0
	Global.fade_in(title, fade_duration)
	print("Start timer")
	$DisplayDelayTimer.start()

func _on_display_delay_timer_timeout() -> void:
	print("Display delay timer timeout")
	Global.fade_out(title, fade_duration)
