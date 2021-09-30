class_name City
extends Node2D

signal tile_set(pos, idx)

enum {
    N = 1 << 0,
    E = 1 << 1,
    S = 1 << 2,
    W = 1 << 3
}

const DirVal: Dictionary = {
    Vector2.ZERO:  0,
    Vector2.UP:    N,
    Vector2.DOWN:  S,
    Vector2.LEFT:  W,
    Vector2.RIGHT: E,
}

const ValDir: Dictionary = {
    0: Vector2.ZERO,
    N: Vector2.UP,
    S: Vector2.DOWN,
    W: Vector2.LEFT,
    E: Vector2.RIGHT,
}

const N_TILE_TYPES = 16

export(Vector2) var auto_offset: Vector2 = Vector2(0, 32)

onready var _map: TileMap = $TileMap

func _init():
    randomize()


func map_to_world(pos: Vector2) -> Vector2:
    return _map.map_to_world(pos) + auto_offset


func world_to_map(pos: Vector2) -> Vector2:
    return _map.world_to_map(pos - auto_offset)


func get_or_set_tile(pos: Vector2, dir: Vector2) -> int:
    var tile_pos: Vector2 = pos + dir
    var tile_idx: int = _map.get_cellv(tile_pos)
    var tile_exists: bool = (tile_idx != TileMap.INVALID_CELL)
    if not tile_exists:
        tile_idx = _rand_tile(tile_pos)

    var val = (tile_idx & DirVal[-dir])
    var is_ok = (dir == -ValDir[val])
    if not is_ok:
        return 0
    if not tile_exists:
        # set random tile
        _map.set_cellv(tile_pos, tile_idx)
        emit_signal("tile_set", tile_pos, tile_idx)

    return tile_idx

func has_tile(pos: Vector2, dir: Vector2) -> bool:
    return get_or_set_tile(pos, dir) > 0

func _rand_tile(pos: Vector2) -> int:
    var tiles: Array = []
    for i in range(N_TILE_TYPES):
        var is_ok: bool = true
        for dir in DirVal:
            var tile_idx: int = _map.get_cellv(pos + dir)
            if tile_idx == TileMap.INVALID_CELL:
                continue
            var val  = (i & DirVal[dir])
            var not_val = (tile_idx & DirVal[-dir])
            is_ok = (val == DirVal[-ValDir[not_val]])
            if not is_ok:
                break
        if is_ok:
            tiles.append(i)
    return tiles[randi() % tiles.size()] if tiles.size() > 0 else 0
