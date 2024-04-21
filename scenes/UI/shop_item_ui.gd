extends Control

@export var item_name : String
@export var price : float
@export var rect : TextureRect
@export var label : Label
@export var label_name : Label

var shop_component : ShopComponent

var money_manager : MoneyManager

func _ready():
	money_manager = get_tree().get_first_node_in_group("money_manager")

func set_data(new_item_name, new_price, new_shop_component):
	shop_component = new_shop_component
	item_name = new_item_name
	price = new_price
	set_icon()
	label.text = "$" + str(price)
	if DataImport.skill_data.has(item_name): 
		label_name.text = DataImport.skill_data[item_name].name
	else: label_name.text = DataImport.item_data[item_name].name

func set_icon() -> void:
	var filename = item_name
	if DataImport.skill_data.has(item_name): filename = "spell_default"
	var image = Image.load_from_file("res://assets/icon/" + filename + ".png")
	rect.texture = ImageTexture.create_from_image(image)


func _on_gui_input(event: InputEvent) -> void:
	if(event.is_pressed()):
		print("a")
		##WARNING Esta logica quizas seria mejor que este en el componente de tienda
		if !money_manager.try_buy(price): return
		shop_component.sell(item_name)
