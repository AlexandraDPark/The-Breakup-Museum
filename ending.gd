extends Control

# ==========================================
# 1. DAY RESULTS
# ==========================================

var donor_scores: Array[int] = []
var correct_total: int = 0
var possible_total: int = 6
var fame: int = 0

const LINE_DELAY := 0.65


# ==========================================
# 2. BUILD ENDING SCREEN
# ==========================================

func _ready() -> void:
	# Background
	var background := ColorRect.new()
	background.color = Color("#EEE5D8")
	add_child(background)
	background.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	# Center everything
	var center := CenterContainer.new()
	add_child(center)
	center.set_anchors_and_offsets_preset(
		Control.PRESET_FULL_RECT
	)

	var column := VBoxContainer.new()
	column.custom_minimum_size = Vector2(400, 0)
	column.add_theme_constant_override(
		"separation", 12
	)
	center.add_child(column)

	# Title
	var title := Label.new()
	title.text = "DAY 1 COMPLETE"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 26)
	title.add_theme_color_override(
		"font_color", Color("#48333B")
	)
	column.add_child(title)

	# Separator
	var separator := HSeparator.new()
	column.add_child(separator)

	# Build results
	var results: Array[Label] = []

	for i in range(donor_scores.size()):
		var line := _make_result_label(
            "Donor %d — %d/2 correct"
			% [i + 1, donor_scores[i]]
		)
		column.add_child(line)
		results.append(line)
		line.hide()

	var total_line := _make_result_label(
        "Total Accuracy: %d/%d"
		% [correct_total, possible_total]
	)
	column.add_child(total_line)
	results.append(total_line)
	total_line.hide()

	var fame_line := _make_result_label(
		"Museum Fame: %d/100" % fame
	)
	column.add_child(fame_line)
	results.append(fame_line)
	fame_line.hide()

	# Arrow button
	var arrow := Button.new()
	arrow.text = "→"
	arrow.custom_minimum_size = Vector2(55, 35)
	arrow.size_flags_horizontal = Control.SIZE_SHRINK_END
	arrow.add_theme_font_size_override("font_size", 22)
	column.add_child(arrow)
	arrow.hide()

	arrow.pressed.connect(_return_to_title)

	# ======================================
	# 3. REVEAL RESULTS ONE BY ONE
	# ======================================

	await get_tree().create_timer(0.7).timeout

	for line in results:
		line.show()
		line.modulate.a = 0.0

		var tween := create_tween()
		tween.tween_property(
			line, "modulate:a", 1.0, 0.35
		)

		await tween.finished
		await get_tree().create_timer(LINE_DELAY).timeout

	# Show arrow when results are complete
	arrow.show()


# ==========================================
# 4. RESULT LABEL HELPER
# ==========================================

func _make_result_label(value: String) -> Label:
	var label := Label.new()
	label.text = value
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.add_theme_font_size_override("font_size", 16)
	label.add_theme_color_override(
		"font_color", Color("#503C44")
	)
	return label


# ==========================================
# 5. RETURN TO TITLE
# ==========================================

func _return_to_title() -> void:
	get_tree().change_scene_to_file(
        "res://title_screen.tscn"
	)
