
extends Control

signal submitted(answers: Dictionary)
signal next_pressed


# ==========================================
# 1. SETTINGS
# ==========================================

const UI_SCALE := Vector2(0.5, 0.5)

# Names displayed on the donation form
const FIELD_TITLES := {
	"item": "Object",
	"origin": "Origin",
	"age": "Object's age",
	"duration": "Relationship duration",
	"place": "Location",

	"breakup_time": "Time since breakup",
	"age_at_breakup": "Age at breakup",
	"found_in": "Found in",
	"owner": "Original owner",
	"handwriting": "Handwriting"
}

# The order fields appear on the paper
const FIELD_ORDER := [
	"item",
	"origin",
	"age",
	"duration",
	"place",
	"breakup_time",
	"age_at_breakup",
	"found_in",
	"owner",
	"handwriting"
]

# Main form text position
const FORM_POSITION := Vector2(470, 425)
const FORM_SIZE := Vector2(420, 290)

# Field layout for different donors
const FOUR_FIELD_START := 60.0
const FOUR_FIELD_SPACING := 45.0

const SIX_FIELD_START := 30.0
const SIX_FIELD_SPACING := 33.0

# Floating word positions
# Change these coordinates to move the words
const WORD_POSITIONS := [
	Vector2(300, 105),
	Vector2(545, 105),
	Vector2(790, 105),

	Vector2(300, 165),
	Vector2(545, 165),
	Vector2(790, 165),

	Vector2(300, 225),
	Vector2(545, 225),
	Vector2(790, 225),

	Vector2(300, 285),
	Vector2(545, 285),
	Vector2(790, 285)
]

# Font sizes
const FORM_FONT_SIZE := 12
const WORD_FONT_SIZE := 20
const STATUS_FONT_SIZE := 12


# ==========================================
# 2. VARIABLES
# ==========================================

var _art: TextureRect
var _submit_button: TextureButton

var _form_panel: Control
var _words: Control

var _status: Label
var _next_button: Button

var _slots: Dictionary = {}
var _filed: Dictionary = {}

var _required_fields: Array[String] = []

var _selected := ""
var _active := false


# ==========================================
# 3. BUILD FORM INTERFACE
# ==========================================

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	scale = UI_SCALE

	# Floating words container
	_words = Control.new()
	_words.mouse_filter = Control.MOUSE_FILTER_IGNORE

	add_child(_words)

	_words.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	_words.hide()

	# Form fields container
	_form_panel = Control.new()
	_form_panel.mouse_filter = Control.MOUSE_FILTER_IGNORE

	add_child(_form_panel)

	_form_panel.position = FORM_POSITION
	_form_panel.size = FORM_SIZE

	# Create every possible field
	for field in FIELD_ORDER:
		_make_slot(field)

	# Next donor / Finish day button
	_next_button = Button.new()
	add_child(_next_button)

	_next_button.position = Vector2(545, 225)
	_next_button.size = Vector2(170, 35)

	_next_button.add_theme_font_size_override(
		"font_size", 14
	)

	_next_button.pressed.connect(_on_next)
	_next_button.hide()

	# Status and result text
	_status = Label.new()
	_form_panel.add_child(_status)

	_status.position = Vector2(15, 215)
	_status.size = Vector2(390, 40)

	_status.add_theme_font_size_override(
		"font_size", STATUS_FONT_SIZE
	)

	_status.add_theme_color_override(
		"font_color",
		Color("#503342")
	)

	_status.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_status.hide()

	_form_panel.hide()


# ==========================================
# 4. CONNECT EXISTING FORM ART
# ==========================================

func configure(
	art: TextureRect,
	submit_button: TextureButton
) -> void:

	_art = art
	_submit_button = submit_button

	if not _submit_button.pressed.is_connected(_on_submit):
		_submit_button.pressed.connect(_on_submit)

	_art.hide()
	_submit_button.hide()
	_submit_button.disabled = true


# ==========================================
# 5. PREPARE FIELDS FOR CURRENT DONOR
# ==========================================

func _prepare_fields(donor: Dictionary) -> void:
	_required_fields.clear()
	_filed.clear()
	_selected = ""

	var clues: Dictionary = donor["clues"]

	# Hide all unused fields
	for field in FIELD_ORDER:
		var slot: Button = _slots[field]

		slot.visible = clues.has(field)
		slot.text = str(FIELD_TITLES[field]) + ": __________"

		if clues.has(field):
			_required_fields.append(field)

	# Choose layout based on field count
	var count := _required_fields.size()

	var start_y := FOUR_FIELD_START
	var spacing := FOUR_FIELD_SPACING

	if count > 4:
		start_y = SIX_FIELD_START
		spacing = SIX_FIELD_SPACING

	# Position visible fields
	for i in range(count):
		var field := _required_fields[i]
		var slot: Button = _slots[field]

		slot.position = Vector2(
			35,
			start_y + i * spacing
		)

		slot.size = Vector2(380, 30)


# ==========================================
# 6. FORM BOUNCE ANIMATION
# ==========================================

func pop_in(
	donor: Dictionary,
	remembered: Dictionary
) -> void:

	_clear_words()
	_prepare_fields(donor)

	_active = false
	_status.hide()
	_next_button.hide()

	# Save final positions
	var art_y := _art.position.y
	var submit_y := _submit_button.position.y
	var fields_y := _form_panel.position.y

	# Start below screen
	_art.position.y += _outside_screen_distance(_art)

	_submit_button.position.y += (
		_outside_screen_distance(_submit_button)
	)

	_form_panel.position.y += (
		_outside_screen_distance(_form_panel)
	)

	_art.show()
	_submit_button.show()
	_form_panel.show()

	_submit_button.disabled = true

	# Bounce animation
	var tween := create_tween()
	tween.set_parallel(true)

	tween.tween_property(
		_art,
		"position:y",
		art_y,
		0.7
	).set_trans(
		Tween.TRANS_BACK
	).set_ease(
		Tween.EASE_OUT
	)

	tween.tween_property(
		_submit_button,
		"position:y",
		submit_y,
		0.7
	).set_trans(
		Tween.TRANS_BACK
	).set_ease(
		Tween.EASE_OUT
	)

	tween.tween_property(
		_form_panel,
		"position:y",
		fields_y,
		0.7
	).set_trans(
		Tween.TRANS_BACK
	).set_ease(
		Tween.EASE_OUT
	)

	await tween.finished

	_active = true
	_submit_button.disabled = false

	_spawn_words(donor, remembered)


func _outside_screen_distance(node: Control) -> float:
	var pixels_per_unit := (
		node.get_global_transform_with_canvas().y.length()
	)

	return (
		(get_viewport_rect().size.y + 100.0)
		/ maxf(pixels_per_unit, 0.001)
	)


# ==========================================
# 7. CREATE INTERACTIVE FORM FIELDS
# ==========================================

func _make_slot(field: String) -> void:
	var slot := Button.new()
	_form_panel.add_child(slot)

	slot.position = Vector2(35, 0)
	slot.size = Vector2(380, 30)

	slot.text = str(FIELD_TITLES[field]) + ": __________"
	slot.flat = true

	slot.alignment = HORIZONTAL_ALIGNMENT_LEFT
	slot.focus_mode = Control.FOCUS_NONE
	slot.clip_text = true

	slot.add_theme_font_size_override(
		"font_size", FORM_FONT_SIZE
	)

	for state in [
		"font_color",
		"font_hover_color",
		"font_pressed_color",
		"font_focus_color"
	]:
		slot.add_theme_color_override(
			state,
			Color("#503342")
		)

	# Invisible background
	for state in [
		"normal",
		"hover",
		"pressed",
		"focus",
		"disabled"
	]:
		slot.add_theme_stylebox_override(
			state,
			StyleBoxEmpty.new()
		)

	# Click field to fill
	slot.pressed.connect(
		_fill_selected.bind(field)
	)

	# Drag and drop
	slot.set_drag_forwarding(
		Callable(),
		_can_drop_word,
		_drop_word.bind(field)
	)

	_slots[field] = slot


# ==========================================
# 8. SPAWN FLOATING WORDS
# ==========================================

func _spawn_words(
	donor: Dictionary,
	_remembered: Dictionary
) -> void:

	var clues: Dictionary = donor["clues"]
	var choices: Array[String] = []

	# Add every correct answer
	for field in clues.keys():
		var answer := str(clues[field])

		if not choices.has(answer):
			choices.append(answer)

	# Add incorrect answers
	for decoy in donor.get("decoys", []):
		var value := str(decoy)

		if not choices.has(value):
			choices.append(value)

	choices.shuffle()
	_words.show()

	for i in range(choices.size()):
		var value := choices[i]

		var chip := Button.new()
		_words.add_child(chip)

		chip.text = value

		# Word position
		var base_position: Vector2

		if i < WORD_POSITIONS.size():
			base_position = WORD_POSITIONS[i]
		else:
			# Additional rows if needed
			var extra := i - WORD_POSITIONS.size()
			var column := extra % 3
			var row := int(extra / 3)

			base_position = Vector2(
				300 + column * 245,
				345 + row * 55
			)

		chip.position = base_position
		chip.size = Vector2(245, 35)

		chip.flat = true
		chip.focus_mode = Control.FOCUS_NONE
		chip.alignment = HORIZONTAL_ALIGNMENT_CENTER
		chip.clip_text = true

		chip.add_theme_font_size_override(
			"font_size", WORD_FONT_SIZE
		)

		# Floating words use ordinary light text
		for state in [
			"font_color",
			"font_hover_color",
			"font_pressed_color",
			"font_focus_color"
		]:
			chip.add_theme_color_override(
				state,
				Color("#F4E9DA")
			)

		# No rectangular backgrounds
		for state in [
			"normal",
			"hover",
			"pressed",
			"focus",
			"disabled"
		]:
			chip.add_theme_stylebox_override(
				state,
				StyleBoxEmpty.new()
			)

		# Click to select
		chip.pressed.connect(
			_select_word.bind(value)
		)

		# Drag into form
		chip.set_drag_forwarding(
			_start_drag.bind(chip, value),
			Callable(),
			Callable()
		)

		# Gentle floating animation
		var original_y := chip.position.y
		var duration := 1.0 + float(i) * 0.12

		var floating := chip.create_tween()
		floating.set_loops()

		floating.tween_property(
			chip,
			"position:y",
			original_y - 5.0,
			duration
		).set_trans(
			Tween.TRANS_SINE
		)

		floating.tween_property(
			chip,
			"position:y",
			original_y + 5.0,
			duration
		).set_trans(
			Tween.TRANS_SINE
		)


# ==========================================
# 9. CLEAR FLOATING WORDS
# ==========================================

func _clear_words() -> void:
	_words.hide()

	for child in _words.get_children():
		_words.remove_child(child)
		child.queue_free()


# ==========================================
# 10. SELECT WORD
# ==========================================

func _select_word(value: String) -> void:
	if not _active:
		return

	_selected = value


# ==========================================
# 11. DRAG WORD
# ==========================================

func _start_drag(
	_position: Vector2,
	chip: Button,
	value: String
) -> Variant:

	if not _active:
		return null

	var preview := Label.new()
	preview.text = value

	preview.add_theme_font_size_override(
		"font_size", WORD_FONT_SIZE
	)

	preview.add_theme_color_override(
		"font_color",
		Color.WHITE
	)

	chip.set_drag_preview(preview)

	return {"value": value}


# ==========================================
# 12. DRAG AND DROP VALIDATION
# ==========================================

func _can_drop_word(
	_position: Vector2,
	data: Variant
) -> bool:

	return (
		_active
		and data is Dictionary
		and data.has("value")
	)


func _drop_word(
	_position: Vector2,
	data: Variant,
	field: String
) -> void:

	if not _active:
		return

	_set_field(
		field,
		str(data["value"])
	)


# ==========================================
# 13. FILL FORM FIELD
# ==========================================

func _fill_selected(field: String) -> void:
	if not _active:
		return

	if _selected.is_empty():
		_status.text = "Select a word first."
		_status.show()
		return

	_set_field(field, _selected)


func _set_field(
	field: String,
	value: String
) -> void:

	if not _active:
		return

	_filed[field] = value

	var slot: Button = _slots[field]

	slot.text = (
		str(FIELD_TITLES[field]) + ": " + value
	)

	_status.hide()


# ==========================================
# 14. SUBMIT FORM
# ==========================================

func _on_submit() -> void:
	if not _active:
		return

	# Check every required field
	for field in _required_fields:
		if not _filed.has(field):
			_status.text = "Complete every field."
			_status.show()
			return

	_active = false
	_submit_button.disabled = true

	submitted.emit(_filed.duplicate())


# ==========================================
# 15. SHOW SCORE
# ==========================================

func show_result(
	correct: int,
	fame: int,
	is_last: bool
) -> void:

	var possible := _required_fields.size()

	_status.text = (
		"%d/%d correct. Museum Fame: %d/100"
		% [correct, possible, fame]
	)

	_status.show()

	# Remove words once scored
	_clear_words()

	if is_last:
		_next_button.text = "Finish day"
	else:
		_next_button.text = "Next donor"

	_next_button.show()


# ==========================================
# 16. NEXT DONOR / FINISH DAY
# ==========================================

func _on_next() -> void:
	_next_button.hide()
	next_pressed.emit()


# ==========================================
# 17. CLEAR FORM
# ==========================================

func clear_form() -> void:
	_active = false
	_selected = ""

	_filed.clear()
	_required_fields.clear()

	_form_panel.hide()
	_art.hide()
	_submit_button.hide()

	_submit_button.disabled = true

	_next_button.hide()
	_status.hide()

	_clear_words()
