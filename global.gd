extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var gameOverClicked = 0
var rng3 = RandomNumberGenerator.new()
var uniqueID = makeid(6)
var IRBcode = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func makeid(length):
	var result           = ''
	var characters       = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789'
	var charactersLength = characters.length() - 1
	for i in length:
		rng3.randomize()
		result += characters[rng3.randi_range(0, charactersLength)]
	return result
