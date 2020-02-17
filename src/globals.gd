extends Node2D

enum CELL_TYPES { EMPTY = -1, FLOOR, WALL, BLACK }
enum MASK_CELL_TYPES { EMPTY = -1, FULL, DARK }
enum LOG_CAT {DEBUG, PLAYER_INFO, ERROR, CRITICAL}

const LASER_COLOR := Color(0.9, 0.2, 0.1)

const SPAWN_TYPE_RANDOM_MONSTER := "random_monster"
const SPAWN_TYPE_RANDOM_ITEM := "random_item"

var map_cell_size : int = 16

var player_entity : PlayerEntity
var player_input : PlayerInput
var console : Console
var board : Board
var camera : Camera2D
var fov : FOV
var bsp : BSP
var spawner : Spawner
var item_area : ItemArea
var npc_area : NPCArea
var character_info_modal : CharacterInfoModal
var time_manager : TimeManager
var dead_screen : DeadScreen
var debug_settings : DebugSettings
var debug_mouse_pos : DebugMousePos
var debug_grid : DebugGrid
var main : Main

var max_int := 9223372036854775807

var rng := RandomNumberGenerator.new()

onready var system_label = preload("res://src/SystemLabel.tscn")

func _init():
	rng.randomize()
