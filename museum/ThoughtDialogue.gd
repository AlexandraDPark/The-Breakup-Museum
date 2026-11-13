
extends CanvasLayer

signal finished

const LETTER_TIME := 0.035

var _box: Panel
var _text: Label

var _lines: Array[String] = []
var _index := 0

var _active := false
var _typing := false
var _tween: Tween


# ==========================================
# 1. BUILD THOUGHT DIALOGUE
# ==========================================

func _ready() -> void:
	layer = 10

	var screen := Control.new()
	screen.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(screen)

	screen.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	# Dialogue box
	_box = Panel.new()
	_box.mouse_filter = Control.MOUSE_FILTER_IGNORE
	_box.clip_contents = true

	screen.add_child(_box)

	_box.anchor_left = 0.0
	_box.anchor_right = 1.0
	_box.anchor_top = 1.0
	_box.anchor_bottom = 1.0

	_box.offset_left = 8
	_box.offset_right = -8
	_box.offset_top = -95
	_box.offset_bottom = -8

	# Background style
	var style := StyleBoxFlat.new()
	style.bg_color = Color("#131920")
	style.border_color = Color("#697681")
	style.set_border_width_all(1)
	style.set_corner_radius_all(6)

	_box.add_theme_stylebox_override("panel", style)

	# Inner margins
	var margin := MarginContainer.new()
	_box.add_child(margin)

	margin.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 6)

	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 3)
	margin.add_child(column)

	# Dialogue text
	_text = Label.new()

	_text.add_theme_font_size_override("font_size", 10)
	_text.add_theme_color_override(
		"font_color",
		Color("#E7E2D8")
	)

	_text.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	_text.size_flags_vertical = Control.SIZE_EXPAND_FILL
	_text.clip_text = true
	_text.max_lines_visible = 2

	column.add_child(_text)

	# Space indicator
	var footer := HBoxContainer.new()
	footer.alignment = BoxContainer.ALIGNMENT_END
	column.add_child(footer)

	var key := Label.new()
	key.text = "SPACE  >"

	key.add_theme_font_size_override("font_size", 8)
	key.add_theme_color_override(
		"font_color",
		Color("#E7E2D8")
	)

	var key_style := StyleBoxFlat.new()
	key_style.bg_color = Color("#303840")
	key_style.border_color = Color("#8B969F")
	key_style.set_border_width_all(1)
	key_style.set_corner_radius_all(4)
	key_style.set_content_margin_all(4)

	key.add_theme_stylebox_override("normal", key_style)
	footer.add_child(key)

	_box.hide()


# ==========================================
# 2. START THOUGHTS
# ==========================================

func play(lines: Array[String]) -> void:
	_lines = lines.duplicate()
	_index = 0
	_active = true

	_box.show()
	_show_line()


# ==========================================
# 3. TYPEWRITER EFFECT
# ==========================================

func _show_line() -> void:
	if _index >= _lines.size():
		_active = false
		_box.hide()
		finished.emit()
		return

	_text.text = _lines[_index]
	_text.visible_ratio = 0.0

	_typing = true

	_tween = create_tween()
	_tween.tween_property(
		_text,
		"visible_ratio",
		1.0,
		maxf(0.05, _text.text.length() * LETTER_TIME)
	)

	_tween.finished.connect(_on_typing_finished)


func _on_typing_finished() -> void:
	_typing = false


# ==========================================
# 4. SPACE TO CONTINUE
# ==========================================

func _input(event: InputEvent) -> void:
	if not _active:
		return

	if not (event is InputEventKey):
		return

	if not event.pressed or event.echo:
		return

	if event.keycode != KEY_SPACE:
		return

	if _typing:
		_tween.kill()
		_text.visible_ratio = 1.0
		_typing = false
	else:
		_index += 1
		_show_line()

	get_viewport().set_input_as_handled()
