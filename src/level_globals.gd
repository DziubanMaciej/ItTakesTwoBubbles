extends Node

const TILE_SIZE : int = 64
const PLAYER_COLLISION_LAYER : int = 2
const ENEMY_COLLISION_LAYER : int = 3

var root : Root = null
var camera : Camera2D = null
var players : Array = Array()
var enemies : Array = Array()
var projectile_container : Node2D = null
