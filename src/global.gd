extends Node

# play_best_score is the best score, we got.
var play_best_score: int = 0
var play_best_auto_icon: Texture = null

# play_score is the last score, we got.
var play_score: int = 0

# auto_sprite is a path to the SpriteFrames .tres file (by default taxi).
# used by Main and Auto scenes
var auto_sprite: String = "res://src/taxi.tres"
var auto_icon: Texture = null

var touchscreen_enabled: bool = false
