extends Label

var disappear_timer = .2

func _ready():
	Scoring.connect("score_changed", _on_score_changed)
	
func _process(delta: float) -> void:
	disappear_timer -= delta
	if disappear_timer < 0:
		visible = false
	
func _on_score_changed(value):
	text = str(value)
	visible = true
	disappear_timer = .2
