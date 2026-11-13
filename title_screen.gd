extends Control

func _ready():
	$PlayButton.pressed.connect(_on_play_pressed)

func _on_play_pressed():
	$PlayButton.disabled = true

	var path = "res://museum.tscn"
	
	# Start loading the next scene in the background
	ResourceLoader.load_threaded_request(path)
	
	# Keep the current scene visible while loading
	while ResourceLoader.load_threaded_get_status(path) == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		await get_tree().process_frame

	if ResourceLoader.load_threaded_get_status(path) != ResourceLoader.THREAD_LOAD_LOADED:
		push_error("Failed to load next scene!")
		return

	# Next scene is loaded!
	var next_scene = ResourceLoader.load_threaded_get(path)

	# Fade out buttons
	var tween = create_tween()
	tween.tween_property($PlayButton, "modulate:a", 0.0, 0.5)
	tween.parallel().tween_property($Title, "modulate:a", 0.0, 1.5)

	await tween.finished

	get_tree().change_scene_to_packed(next_scene)
