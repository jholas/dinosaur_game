extends Node2D

# main.gd
# Root scene controller. Manages game states: idle, running, game over.
# Wires up all child nodes and drives the score counter.

enum GameState { IDLE, RUNNING, GAME_OVER }

# Night-mode colour transition every 700 points.
const NIGHT_MODE_INTERVAL: int = 700
const BG_DAY_COLOR: Color = Color("#F7F7F7")
const BG_NIGHT_COLOR: Color = Color("#202124")
const COLOR_TRANSITION_TIME: float = 1.5

@onready var dino: CharacterBody2D = $Dino
@onready var spawner: Node2D = $Spawner
@onready var scrolling_ground: Node2D = $ScrollingGround
@onready var hud: CanvasLayer = $HUD
@onready var background_rect: ColorRect = $Background

var _state: GameState = GameState.IDLE
var _elapsed: float = 0.0
var _last_night_threshold: int = 0
var _tween: Tween = null


func _ready() -> void:
	hud.retry_requested.connect(_start_game)
	dino.died.connect(_on_dino_died)
	# Link the scrolling ground to the spawner so it reads game_speed.
	scrolling_ground.spawner = spawner
	background_rect.color = BG_DAY_COLOR
	_start_game()


func _process(delta: float) -> void:
	if _state != GameState.RUNNING:
		return

	_elapsed += delta
	# Score increases at ~10 points per second.
	var score: int = int(_elapsed * 10.0)
	hud.set_score(score)
	spawner.update_score(score)

	# Trigger night mode every NIGHT_MODE_INTERVAL points.
	var threshold: int = (score / NIGHT_MODE_INTERVAL) * NIGHT_MODE_INTERVAL
	if threshold > _last_night_threshold:
		_last_night_threshold = threshold
		_toggle_night_mode(threshold % (NIGHT_MODE_INTERVAL * 2) != 0)


func _start_game() -> void:
	_state = GameState.RUNNING
	_elapsed = 0.0
	_last_night_threshold = 0

	# Reset the dino position and state.
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	dino.position = Vector2(viewport_size.x * 0.15, viewport_size.y * 0.80)
	dino.velocity = Vector2.ZERO
	dino.is_dead = false

	# Remove any leftover obstacles.
	for child in spawner.get_children():
		if child.has_method("set_speed"):
			child.queue_free()

	hud.reset()
	spawner.start()
	scrolling_ground.start()


func _on_dino_died() -> void:
	_state = GameState.GAME_OVER
	spawner.stop()
	scrolling_ground.stop()
	hud.show_game_over()


func _toggle_night_mode(is_night: bool) -> void:
	var target_color: Color = BG_NIGHT_COLOR if is_night else BG_DAY_COLOR
	if _tween:
		_tween.kill()
	_tween = create_tween()
	_tween.tween_property(background_rect, "color", target_color, COLOR_TRANSITION_TIME)
