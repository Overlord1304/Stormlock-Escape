extends Node


var SEG1 = false
var SEG2 = false

var r = randf()
func _process(_delta):
	choose()


func choose():
	if 1-r > 0.5:
		SEG1 = true
		SEG2 = false
	else:
		SEG1 = false
		SEG2 = true
 
