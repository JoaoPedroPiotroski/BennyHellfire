extends Node

signal score_changed(int)

var score := 0 :
	set (value):
		score = value
		if score > high_score:
			high_score = score
			new_high = true
		emit_signal("score_changed", score)
var high_score := 0
var new_high = false
var bosses_slain = 0
