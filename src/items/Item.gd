extends EntityStats
class_name Item

enum Category { CONSUMABLE, MATERIAL, KEY, EQUIPMENT }

export var display_name : String
export var description : String
export var unique : bool = false
export(int) var sell_value
export var image : Texture

export var heal_amount : int

export var is_pickup := true
