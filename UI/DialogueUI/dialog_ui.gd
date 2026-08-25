extends Control

@export var dialogue: Array[AddDialogue] = []
@export var answers_arararar: Array[AnswersGroup] = []

@onready var main_dialogue_text = $ColorRect/RichTextLabel
@onready var BTN0 = $BTNnode/Button
@onready var BTN1 = $BTNnode/Button2
@onready var BTN2 = $BTNnode/Button3

var btns
var nodes

var start_showing_text = false

func _ready() -> void:
	nodes = [$".",$ColorRect,$BTNnode]
	btns = [BTN0,BTN1,BTN2]
	hide_nodes()
	start_dialogue($".",dialogue,0,answers_arararar)
	
	
	
func start_dialogue(body,dialogue_array,dialogue_number:int,answerGroup):
	for btn in btns:
		btn.visible = false
		if btn.pressed.get_connections().size() > 0:
			for c in btn.pressed.get_connections():
				btn.pressed.disconnect(c.callable)
	var current_dialogue = dialogue_array[dialogue_number]
	main_dialogue_text.text = current_dialogue.text
	# animacja node = current_dialogue.animation
	nodes[1].visible = true
	nodes[0].visible = true
	main_dialogue_text.visible_characters = 0
	start_showing_text = true
	print('check 1')
	while start_showing_text:
		if main_dialogue_text.visible_ratio == 1:
			start_showing_text = false
		main_dialogue_text.visible_characters += 1
		await get_tree().create_timer(0.01).timeout
	print('check 2')
	if current_dialogue.answer:
		var current_answers = answerGroup[current_dialogue.answer_number]
		for i in range(current_answers.answers.size()):
			btns[i].visible = true
			btns[i].text = current_answers.answers[i].text
			btns[i].pressed.connect(func():
				start_dialogue(body,dialogue_array,current_answers.answers[i].next_dialogue,answerGroup)
				)
	elif current_dialogue.answer == false:
		btns[0].visible = true
		btns[0].text = "Continue"
		btns[0].pressed.connect(func():
				start_dialogue(body,dialogue_array,current_dialogue.next_dialogue,answerGroup)
				)
	$BTNnode.visible = true
	print('koniec')


func hide_nodes():
	for node in nodes:
		node.visible = false
	for btn in btns:
		btn.visible = false
