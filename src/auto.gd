class_name Auto
extends AnimatedSprite
# Generic implementation for all vehicles.

const INTERPOLATE_DURATION     := 1.0
const MIN_INTERPOLATE_DURATION := 0.5
const INTERPOLATE_TRANSITION   := Tween.TRANS_LINEAR
const INTERPOLATE_EASE         := Tween.EASE_IN

const DirAnim: Dictionary = {
    Vector2.UP:    "n",
    Vector2.DOWN:  "s",
    Vector2.LEFT:  "w",
    Vector2.RIGHT: "e",
}

var map_to_world: FuncRef = null
var can_move: FuncRef = null

var _dt: float    = INTERPOLATE_DURATION
var _pos: Vector2 = Vector2.ZERO
var _dir: Vector2 = Vector2.RIGHT
var _is_moving: bool = false

onready var _tween: Tween = $Tween

func _ready():
    set_sprite_frames(load(Global.auto_sprite))


func move() -> void:
    play(DirAnim[_dir])

    if can_move != null && not (can_move.call_func(_pos, _dir) as bool):
        stop()
        return

    if _dt > MIN_INTERPOLATE_DURATION:
        _dt -= get_process_delta_time()

    _pos += _dir
    var world_pos = map_to_world.call_func(_pos) as Vector2 if map_to_world != null else _pos
    assert(_tween.interpolate_property(self, "position", null, world_pos, _dt, INTERPOLATE_TRANSITION, INTERPOLATE_EASE))
    assert(_tween.start())
    _is_moving = true


func start() -> void:
    if not _is_moving:
        move()

func stop() -> void:
    assert(_tween.stop_all())
    _is_moving = false


func turn_left() -> void:
    _dir = Vector2(_dir.y, - _dir.x)

func turn_right() -> void:
    _dir = Vector2(-_dir.y, _dir.x)

func turn_u() -> void:
    _dir = Vector2(-_dir.x, -_dir.y)


func _on_Tween_completed(_object, _key):
    if not _is_moving:
        return
    move()