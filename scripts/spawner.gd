extends Node2D

# spawner.gd
# Write a Node2D script that spawns obstacles from right to left.
# Obstacles are instantiated packages: Cactus scenes or Pterodactyl scenes.
# Spawn timer intervals should decrease slightly as the game speed increases.
# Track a global speed variable that increases over time.

const CACTUS_SCENE: PackedScene = preload("res://scenes/Cactus.tscn")
const PTERODACTYL_SCENE: PackedScene = preload("res://scenes/Pterodactyl.tscn")

# Speed in pixels per second. Shared via GameState autoload or passed from Main.
var game_speed: float = 400.0
const SPEED_INCREMENT: float = 10.0
const MAX_SPEED: float = 1200.0

# Minimum and maximum time between spawns (seconds).
const SPAWN_INTERVAL_MIN: float = 0.8
const SPAWN_INTERVAL_MAX: float = 2.5
# Score threshold before pterodactyls start appearing.
const PTERODACTYL_SCORE_THRESHOLD: int = 500

var _score: int = 0
var _is_running: bool = false

@onready var _spawn_timer: Timer = $SpawnTimer


func _ready() -> void:
	_spawn_timer.timeout.connect(_on_spawn_timer_timeout)


func start() -> void:
	_is_running = true
	game_speed = 400.0
	_schedule_next_spawn()


func stop() -> void:
	_is_running = false
	_spawn_timer.stop()


func update_score(score: int) -> void:
	_score = score


func _physics_process(delta: float) -> void:
	if not _is_running:
		return
	# Gradually increase speed.
	game_speed = min(game_speed + SPEED_INCREMENT * delta, MAX_SPEED)


func _on_spawn_timer_timeout() -> void:
	if not _is_running:
		return
	_spawn_obstacle()
	_schedule_next_spawn()


func _spawn_obstacle() -> void:
	var viewport_size: Vector2 = get_viewport().get_visible_rect().size
	var spawn_x: float = viewport_size.x + 60.0

	# Decide type based on current score.
	var use_pterodactyl: bool = _score >= PTERODACTYL_SCORE_THRESHOLD and randf() < 0.35

	var obstacle: Node2D
	if use_pterodactyl:
		obstacle = PTERODACTYL_SCENE.instantiate() as Node2D
		# Assign random flight height: low / medium / high.
		var ground_y: float = viewport_size.y * 0.80
		var heights: Array[float] = [
			ground_y - 40.0,   # low  – player must jump
			ground_y - 120.0,  # medium – player must duck
			ground_y - 220.0   # high – can be ignored
		]
		obstacle.position = Vector2(spawn_x, heights[randi() % heights.size()])
	else:
		obstacle = CACTUS_SCENE.instantiate() as Node2D
		var ground_y: float = viewport_size.y * 0.80
		obstacle.position = Vector2(spawn_x, ground_y)

	add_child(obstacle)

	# Pass current speed so the obstacle moves correctly.
	if obstacle.has_method("set_speed"):
		obstacle.set_speed(game_speed)


func _schedule_next_spawn() -> void:
	# Interval shrinks as speed grows, clamped to minimum.
	var speed_fraction: float = (game_speed - 400.0) / (MAX_SPEED - 400.0)
	var interval: float = lerp(SPAWN_INTERVAL_MAX, SPAWN_INTERVAL_MIN, speed_fraction)
	_spawn_timer.wait_time = interval
	_spawn_timer.start()
