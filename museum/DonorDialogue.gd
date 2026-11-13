
extends Control

# ==========================================
# 1. SIGNALS
# ==========================================

signal conversation_finished(remembered: Dictionary)
signal player_line_requested(text: String)
signal inspection_requested

# ==========================================
# 2. VARIABLES
# ==========================================

var _panel: Panel
var _story: RichTextLabel
var _space_hint: Label

var _donor: Dictionary = {}
var _remembered: Dictionary = {}

var _line_index := 0
var _active := false


# ==========================================
# 3. BUILD DONOR SPEECH BUBBLE
# ==========================================

func _ready() -> void:
	mouse_filter = Control.MOUSE_FILTER_IGNORE

	set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	scale = Vector2(0.5, 0.5)

	# Main bubble
	_panel = Panel.new()
	add_child(_panel)

	_panel.position = Vector2(600, 100)
	_panel.size = Vector2(500, 250)

	var style := StyleBoxFlat.new()
	style.bg_color = Color("#F5E7DD")
	style.border_color = Color("#6A4752")
	style.set_border_width_all(3)
	style.set_corner_radius_all(15)

	_panel.add_theme_stylebox_override("panel", style)

	# ======================================
	# DONOR DIALOGUE TEXT
	# ======================================

	_story = RichTextLabel.new()
	_panel.add_child(_story)

	_story.position = Vector2(18, 20)
	_story.size = Vector2(464, 185)

	_story.bbcode_enabled = true
	_story.meta_underlined = false
	_story.scroll_active = false
	_story.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	_story.add_theme_font_size_override(
		"normal_font_size", 18
	)

	_story.add_theme_color_override(
		"default_color",
		Color("#3A2834")
	)

	# IMPORTANT: Keep clickable keywords!
	_story.meta_clicked.connect(_on_clue_clicked)

	# ======================================
	# SPACE INDICATOR
	# ======================================

	_space_hint = Label.new()
	_panel.add_child(_space_hint)

	_space_hint.text = "[ SPACE ]"
	_space_hint.mouse_filter = Control.MOUSE_FILTER_IGNORE

	# Bottom-right corner
	_space_hint.anchor_left = 1.0
	_space_hint.anchor_right = 1.0
	_space_hint.anchor_top = 1.0
	_space_hint.anchor_bottom = 1.0

	_space_hint.offset_left = -100
	_space_hint.offset_right = -14
	_space_hint.offset_top = -30
	_space_hint.offset_bottom = -10

	_space_hint.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

	_space_hint.add_theme_font_size_override(
		"font_size", 12
	)

	_space_hint.add_theme_color_override(
		"font_color",
		Color("#6A4752")
	)

	_panel.hide()


# ==========================================
# 4. START DONOR CONVERSATION
# ==========================================

func play(donor: Dictionary) -> void:
	_donor = donor
	_remembered.clear()

	_line_index = 0
	_active = true

	_show_current_line()


# ==========================================
# 5. SHOW CURRENT DIALOGUE LINE
# ==========================================

func _show_current_line() -> void:
	var lines: Array = _donor["lines"]

	if _line_index >= lines.size():
		_finish_conversation()
		return

	var line: Variant = lines[_line_index]

	# --------------------------------------
	# OBJECT INSPECTION EVENT
	# --------------------------------------

	if line is Dictionary:
		if line.get("event", "") == "inspect":
			_active = false
			_panel.hide()

			inspection_requested.emit()
			return

	# --------------------------------------
	# PLAYER DIALOGUE
	# --------------------------------------

	if line is Dictionary:
		if line.get("speaker", "") == "PLAYER":
			_active = false
			_panel.hide()

			player_line_requested.emit(
				str(line.get("text", ""))
			)
			return

	# --------------------------------------
	# DONOR DIALOGUE / NARRATION
	# --------------------------------------

	_active = true
	_panel.show()

	if line is Dictionary:
		_story.text = str(line.get("text", ""))
	else:
		# Supports older donor stories too
		_story.text = str(line)


# ==========================================
# 6. ADVANCE DONOR DIALOGUE
# ==========================================

func _advance() -> void:
	if not _active:
		return

	_line_index += 1
	_show_current_line()


# ==========================================
# 7. RESUME AFTER PLAYER / INSPECTION
# ==========================================

func resume() -> void:
	_line_index += 1
	_show_current_line()


# ==========================================
# 8. COLLECT CLICKABLE KEYWORDS
# ==========================================

func _on_clue_clicked(meta: Variant) -> void:
	if not _active:
		return

	var clue_id := str(meta)
	var clues: Dictionary = _donor["clues"]

	if not clues.has(clue_id):
		return

	_remembered[clue_id] = clues[clue_id]


# ==========================================
# 9. FINISH CONVERSATION
# ==========================================

func _finish_conversation() -> void:
	_active = false
	_panel.hide()

	conversation_finished.emit(
		_remembered.duplicate()
	)


func hide_chat() -> void:
	_active = false
	_panel.hide()


# ==========================================
# 10. SPACE KEY INPUT
# ==========================================

func _input(event: InputEvent) -> void:
	if not _active:
		return

	if event is InputEventKey:
		if event.keycode == KEY_SPACE and event.pressed and not event.echo:
			_advance()
			get_viewport().set_input_as_handled()
