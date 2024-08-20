extends Node2D


func toGame() -> void:
	get_tree().change_scene_to_file("res://levels/level0.tscn");


func quit() -> void:
	get_tree().quit();
