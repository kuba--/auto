class_name City
extends Node2D

signal tile_set(pos, idx)

enum {
    N = 1 << 0,
    E = 1 << 1,
    S = 1 << 2,
    W = 1 << 3
}

const Dir2Val: Dictionary = {
    Vector2.ZERO:  0,
    Vector2.UP:    N,
    Vector2.DOWN:  S,
    Vector2.LEFT:  W,
    Vector2.RIGHT: E,
}

const Val2Dir: Dictionary = {
    0: Vector2.ZERO,
    N: Vector2.UP,
    S: Vector2.DOWN,
    W: Vector2.LEFT,
    E: Vector2.RIGHT,
}

const N_TILE_TYPES = 16

var Heart  = preload("res://src/heart.tscn")
var _hearts: Dictionary = {}

var _n_exits: int = 0
onready var _map: TileMap = $TileMap

func _init():
    randomize()

func _ready():
    for v in _map.get_used_cells():
        var tile_idx: int = _map.get_cellv(v)
        for val in Val2Dir:
            if ((val > 0) and (tile_idx & val == val)
                and (_map.get_cellv(v + Val2Dir[val]) == TileMap.INVALID_CELL)):
                _n_exits += 1

func map_to_world(pos: Vector2, off: Vector2) -> Vector2:
    return _map.map_to_world(pos) + off

func world_to_map(pos: Vector2, off: Vector2) -> Vector2:
    return _map.world_to_map(pos - off)

func get_or_set_tile(pos: Vector2, dir: Vector2) -> int:
    var n_exits: int = _n_exits
    var tile_pos: Vector2 = pos + dir
    var tile_idx: int = _map.get_cellv(tile_pos)
    var tile_exists: bool = (tile_idx != TileMap.INVALID_CELL)
    if not tile_exists:
        var rand_tile := _rand_tile(tile_pos)
        tile_idx = rand_tile[0]
        n_exits = rand_tile[1]
    var val = (tile_idx & Dir2Val[-dir])
    var is_ok = (dir == -Val2Dir[val])
    if not is_ok:
        return 0
    if not tile_exists:
        # set random tile
        _map.set_cellv(tile_pos, tile_idx)
        emit_signal("tile_set", tile_pos, tile_idx)
        _n_exits = n_exits
    return tile_idx

func add_heart(exclude_pos: Array):
    var cells: Array = _map.get_used_cells()
    var pos: Vector2 = cells[randi() % len(cells)]
    if _hearts.has(pos) or (exclude_pos.find(pos) != -1):
        return
    var heart = Heart.instance()
    heart.position = map_to_world(pos, heart.OFFSET)
    _hearts[pos] = heart
    add_child(heart)

func delete_heart(pos: Vector2) -> bool:
    var heart: Heart = _hearts.get(pos)
    if heart == null:
        return false
    heart.queue_free()
    if not _hearts.erase(pos):
        printerr(_hearts, "erase", pos)
    return true

func has_road(pos: Vector2, dir: Vector2) -> bool:
    return get_or_set_tile(pos, dir) > 0

func has_exits() -> bool:
    return _n_exits > 0

func _n_exits_with_tile(pos: Vector2, idx: int) -> int:
    var n_exits: int = _n_exits
    for val in Val2Dir:
        if (val > 0) and (idx & val == val):
            if (_map.get_cellv(pos + Val2Dir[val]) == TileMap.INVALID_CELL) :
                n_exits += 1
            else:
                n_exits -= 1
    return n_exits

func _rand_tile(pos: Vector2) -> Array:
    var tiles: Array = []
    var exits: Array = []
    var deads: Array = []
    for i in range(N_TILE_TYPES):
        var is_ok: bool = true
        for dir in Dir2Val:
            var tile_idx: int = _map.get_cellv(pos + dir)
            if tile_idx == TileMap.INVALID_CELL:
                continue
            var val  = (i & Dir2Val[dir])
            var not_val = (tile_idx & Dir2Val[-dir])
            is_ok = (val == Dir2Val[-Val2Dir[not_val]])
            if not is_ok:
                break
        if is_ok:
            var n: int = _n_exits_with_tile(pos, i)
            if n > 0:
                tiles.append(i)
                exits.append(n)
            else:
                deads.append(i)
    if tiles.size() == 0:
        return [deads[0], 0] if deads.size() > 0 else [0, 0]
    var i: int = randi() % tiles.size()
    return [tiles[i], exits[i]]
