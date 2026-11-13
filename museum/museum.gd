extends Control

# MAIN GAMEPLAY CONTROLLER
# Attach this script to your Museum root node.

const DATA = preload("res://museum/DonorData.gd")
const THOUGHT_UI = preload("res://museum/ThoughtDialogue.gd")
const DONOR_UI = preload("res://museum/DonorDialogue.gd")
const FORM_UI = preload("res://museum/DonationFormUI.gd")

@onready var npcs: Array[TextureRect] = [
	$NPC1,
	$NPC2,
	$NPC3
]

@onready var donation_form_art: TextureRect = $DonationForm
@onready var submit_button: TextureButton = $SubmitButton

var donors: Array[Dictionary] = []
var correct_total := 0
var fame := 0
var donor_scores: Array[int] = []

var thoughts: CanvasLayer
var donor_chat: Control
var form_ui: Control

var score_root: Control
var fame_label: Label
var fame_bar: ProgressBar

# ==========================================
# OBJECT INSPECTION
# ==========================================

signal object_clicked

var current_donor_index := -1

var object_layer: CanvasLayer
var object_screen: Control

var small_object: TextureRect
var large_object: TextureRect
var medium_object: TextureRect


# ==========================================
# 1. INITIAL SETUP
# ==========================================

func _ready() -> void:
	donors = DATA.all_donors()

	for npc in npcs:
		npc.hide()

	donation_form_art.hide()
	submit_button.hide()

	thoughts = THOUGHT_UI.new()
	add_child(thoughts)

	_run_day()



# ==========================================
# MAIN GAMEPLAY SEQUENCE
# ==========================================

func _run_day() -> void:

	# ======================================
	# 1. OPENING THOUGHTS
	# ======================================

	thoughts.play(DATA.opening_thoughts())
	await thoughts.finished

	# ======================================
	# 2. BUILD GAME INTERFACE
	# ======================================

	_build_fame_ui()

	donor_chat = DONOR_UI.new()
	add_child(donor_chat)

	# Connect dialogue events
	donor_chat.player_line_requested.connect(
		_on_player_line_requested
	)

	donor_chat.inspection_requested.connect(
		_on_inspection_requested
	)

	form_ui = FORM_UI.new()
	add_child(form_ui)

	form_ui.configure(
		donation_form_art,
		submit_button
	)

	# ======================================
	# 3. HANDLE ALL THREE DONORS
	# ======================================

	for donor_index in range(donors.size()):

		current_donor_index = donor_index

		var donor: Dictionary = donors[donor_index]

		# Wait before donor arrives
		await get_tree().create_timer(
			randf_range(1.0, 2.0)
		).timeout

		# Donor appears
		await _show_donor(donor_index)

		# Start the donor conversation
		donor_chat.play(donor)

		# The dialogue controller pauses for:
		# - player speech
		# - object inspection
		# and resumes after each one.

		var remembered: Dictionary = (
			await donor_chat.conversation_finished
		)

		# ==================================
		# 4. DONOR LEAVES
		# ==================================

		await _hide_donor(donor_index)
		donor_chat.hide_chat()

		# ==================================
		# 5. DONATION FORM
		# ==================================

		await form_ui.pop_in(donor, remembered)

		var answers: Dictionary = (
			await form_ui.submitted
		)

		# Object is collected after submission
		_clear_object()

		# ==================================
		# 6. SCORE THE FORM
		# ==================================

		var correct := _score_form(donor, answers)

		form_ui.show_result(
			correct,
			fame,
			donor_index == donors.size() - 1
		)

		# Wait for next donor / finish day
		await form_ui.next_pressed

		form_ui.clear_form()

		# ==================================
		# 7. GO TO ENDING
		# ==================================

		if donor_index == donors.size() - 1:
			_go_to_ending()
			return



# ==========================================
# PLAYER DIALOGUE
# ==========================================

func _on_player_line_requested(text: String) -> void:
	# Remove italic formatting from narration
	var clean_text := text.replace("[i]", "").replace("[/i]", "")

	# Show one line in the bottom dialogue box
	var player_lines: Array[String] = [clean_text]

	thoughts.play(player_lines)

	# Wait until player finishes with Space
	await thoughts.finished

	# Continue donor conversation on the next frame
	donor_chat.call_deferred("resume")


# ==========================================
# OBJECT INSPECTION REQUEST
# ==========================================

func _on_inspection_requested() -> void:
	var donor: Dictionary = donors[current_donor_index]

	if donor.has("inspection"):
		await _inspect_object(donor)

	# Resume donor conversation after inspection
	donor_chat.call_deferred("resume")


# ==========================================
# CREATE OBJECT IMAGE
# ==========================================

func _create_object(
	image_path: String,
	image_size: Vector2,
	image_position: Vector2
) -> TextureRect:

	var texture := load(image_path) as Texture2D

	if texture == null:
		push_error("Missing object image: " + image_path)
		return null

	var object := TextureRect.new()

	object.texture = texture
	object.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	object.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

	object.size = image_size
	object.position = image_position

	object.mouse_filter = Control.MOUSE_FILTER_IGNORE

	object_screen.add_child(object)

	return object


# ==========================================
# CLICK SMALL OBJECT
# ==========================================

func _on_small_object_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			object_clicked.emit()
			get_viewport().set_input_as_handled()


# ==========================================
# CLEAR OBJECTS
# ==========================================

func _clear_object() -> void:
	if is_instance_valid(medium_object):
		medium_object.queue_free()

	if is_instance_valid(object_layer):
		object_layer.queue_free()

	object_layer = null
	object_screen = null

	small_object = null
	large_object = null
	medium_object = null



# ==========================================
# OBJECT INSPECTION SEQUENCE
# ==========================================

func _inspect_object(donor: Dictionary) -> void:
	var info: Dictionary = donor["inspection"]

	# ======================================
	# 1. CREATE OBJECT LAYER
	# ======================================

	object_layer = CanvasLayer.new()
	object_layer.layer = 5
	add_child(object_layer)

	object_screen = Control.new()
	object_screen.mouse_filter = Control.MOUSE_FILTER_IGNORE

	object_layer.add_child(object_screen)

	object_screen.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	var screen_size := get_viewport_rect().size

	# ======================================
	# 2. SMALL OBJECT APPEARS
	# ======================================

	var small_size := (load(str(info["small"])) as Texture2D).get_size()

	small_object = _create_object(
		str(info["small"]),
		small_size,
		Vector2(
			screen_size.x * 0.50,
			screen_size.y * 0.50
		)
	)

	if small_object == null:
		_clear_object()
		return

	# Make the small object clickable
	small_object.mouse_filter = Control.MOUSE_FILTER_STOP

	small_object.mouse_default_cursor_shape = (
		Control.CURSOR_POINTING_HAND
	)

	small_object.gui_input.connect(
		_on_small_object_input
	)

	# Wait until the small object is clicked
	await object_clicked

	small_object.hide()

	# ======================================
	# 3. LARGE OBJECT IN CENTER
	# ======================================

	var large_size := (load(str(info["large"])) as Texture2D).get_size()

	large_object = _create_object(
		str(info["large"]),
		large_size,
		(screen_size - large_size) / 2.0
	)

	if large_object == null:
		_clear_object()
		return

	# ======================================
	# 4. PLAYER'S INNER THOUGHTS
	# ======================================

	var observations: Array[String] = []

	for line in info["thoughts"]:
		observations.append(str(line))

	thoughts.play(observations)

	# Space advances the observations
	await thoughts.finished

	# ======================================
	# 5. REMOVE LARGE OBJECT
	# ======================================

	large_object.queue_free()
	large_object = null

	# ======================================
	# 6. MEDIUM OBJECT ON DESK
	# ======================================

	var medium_size := (load(str(info["medium"])) as Texture2D).get_size()

	medium_object = _create_object(
		str(info["medium"]),
		medium_size,
		Vector2.ZERO
	)

	if medium_object != null:
		# Move it out of the CanvasLayer
		medium_object.reparent(self)

		# Place the object on the desk
		medium_object.position = Vector2(
			screen_size.x * 0.50,
			screen_size.y * 0.85
		)

		# Put it behind the donation form artwork
		move_child(
			medium_object,
			donation_form_art.get_index()
		)

	# Medium object remains on desk
	# until the donation form is submitted.



# ==========================================
# 3. DONOR APPEARANCE
# ==========================================

func _show_donor(index: int) -> void:
	var npc: TextureRect = npcs[index]

	npc.modulate.a = 0.0
	npc.show()

	var tween := create_tween()
	tween.tween_property(
		npc,
		"modulate:a",
		1.0,
		0.9
	)

	await tween.finished


func _hide_donor(index: int) -> void:
	var npc: TextureRect = npcs[index]

	var tween := create_tween()
	tween.tween_property(
		npc,
		"modulate:a",
		0.0,
		0.9
	)

	await tween.finished
	npc.hide()


# ==========================================
# SCORING SYSTEM
# ==========================================

func _score_form(donor: Dictionary, answers: Dictionary) -> int:
	var correct := 0
	var expected: Dictionary = donor["clues"]

	for field in expected.keys():
		var entered := str(
			answers.get(field, "")
		).strip_edges().to_lower()

		var answer := str(
			expected[field]
		).strip_edges().to_lower()

		if entered == answer:
			correct += 1

	correct_total += correct
	donor_scores.append(correct)

	fame = roundi(
		100.0 * float(correct_total)
		/ float(maxi(_total_possible_fields(), 1))
	)

	_update_fame()

	return correct


func _total_possible_fields() -> int:
	var total := 0

	for donor in donors:
		var clues: Dictionary = donor["clues"]
		total += clues.size()

	return total


# ==========================================
# 5. MUSEUM FAME INTERFACE
# ==========================================

func _build_fame_ui() -> void:
	score_root = Control.new()
	score_root.mouse_filter = Control.MOUSE_FILTER_IGNORE

	add_child(score_root)
	score_root.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	score_root.scale = Vector2(0.5, 0.5)

	fame_label = Label.new()
	score_root.add_child(fame_label)

	fame_label.position = Vector2(980, 12)
	fame_label.size = Vector2(275, 30)

	fame_label.add_theme_font_size_override(
		"font_size", 18
	)

	fame_label.add_theme_color_override(
		"font_color", Color("#3A2834")
	)

	fame_bar = ProgressBar.new()
	score_root.add_child(fame_bar)

	fame_bar.position = Vector2(980, 45)
	fame_bar.size = Vector2(255, 20)
	fame_bar.max_value = 100
	fame_bar.show_percentage = false

	_update_fame()


func _update_fame() -> void:
	fame_label.text = "Museum Fame: %d / 100" % fame
	fame_bar.value = fame


# ==========================================
# GO TO ENDING SCENE
# ==========================================

func _go_to_ending() -> void:
	print("Switching to ending scene...")

	var scene = load("res://ending.tscn")

	if scene == null:
		push_error("Ending scene not found!")
		return

	var ending = scene.instantiate()

	ending.donor_scores = donor_scores.duplicate()
	ending.correct_total = correct_total
	ending.possible_total = _total_possible_fields()
	ending.fame = fame

	var tree = get_tree()

	tree.root.add_child(ending)
	tree.current_scene = ending

	queue_free()
