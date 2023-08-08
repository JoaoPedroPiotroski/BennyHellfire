extends CheckBox
class_name ShopCheckBox

@export var price : int = 1

func _ready() -> void:
	connect("button_down", _on_button_down)
	set_process(true)
	button_pressed = Save.upgrades.has(text)
	if has_node("Pricetag"):
		get_node("Pricetag").text = str(price) + "G"
	
func _process(delta):
	if Save.upgrades.has(text):
		button_pressed = true
	else:
		button_pressed = false
	
func _on_button_down():
	if Save.upgrades.has(text):
		button_pressed = true
		return
	else:
		button_pressed = false
		if price <= Save.money:
			Save.money -= price
			Save.upgrades.append(text)
			button_pressed = true
			AudioManager.play_fx("res://assets/sounds/shop_get.wav")
