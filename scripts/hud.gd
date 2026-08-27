extends CanvasLayer

# hud.gd
# Heads-Up Display: current score and high score.
# High score is persisted locally via ConfigFile.

const SAVE_PATH: String = "user://highscore.cfg"
const SAVE_SECTION: String = "scores"
const SAVE_KEY: String = "high_score"

@onready var score_label: Label = $ScoreLabel
@onready var high_score_label: Label = $HighScoreLabel
@onready var game_over_panel: Control = $GameOverPanel
@onready var retry_button: Button = $GameOverPanel/RetryButton

var _current_score: int = 0
var _high_score: int = 0

signal retry_requested


func _ready() -> void:
	_load_high_score()
	game_over_panel.hide()
	retry_button.pressed.connect(_on_retry_pressed)
	_update_labels()


func add_score(points: int) -> void:
	_current_score += points
	if _current_score > _high_score:
		_high_score = _current_score
	_update_labels()


func set_score(score: int) -> void:
	_current_score = score
	if _current_score > _high_score:
		_high_score = _current_score
	_update_labels()


func get_score() -> int:
	return _current_score


func reset() -> void:
	_current_score = 0
	game_over_panel.hide()
	_update_labels()


func show_game_over() -> void:
	_save_high_score()
	game_over_panel.show()


func _update_labels() -> void:
	score_label.text = "%05d" % _current_score
	high_score_label.text = "HI %05d" % _high_score


func _load_high_score() -> void:
	var cfg := ConfigFile.new()
	if cfg.load(SAVE_PATH) == OK:
		_high_score = cfg.get_value(SAVE_SECTION, SAVE_KEY, 0)


func _save_high_score() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value(SAVE_SECTION, SAVE_KEY, _high_score)
	cfg.save(SAVE_PATH)


func _on_retry_pressed() -> void:
	emit_signal("retry_requested")


func _input(event: InputEvent) -> void:
	# Allow tapping anywhere to retry when the game-over screen is visible.
	if game_over_panel.visible and event is InputEventScreenTouch:
		var touch := event as InputEventScreenTouch
		if touch.pressed:
			emit_signal("retry_requested")
