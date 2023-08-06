@tool
extends Node
class_name BehaviourNode

signal enabled_changed

var enabled:bool = false:
	set(val):
		enabled = val
		__update_node()
		emit_signal("enabled_changed")


func _init():
	update_configuration_warnings()
	if !Engine.is_editor_hint():
		__update_node()

		await tree_entered
		if get_parent() is BehaviourTree:
			get_parent().behaviours_disabled.connect(__on_disable)
			get_parent().behaviour_changed.connect(__on_behaviour_change)


func _notification(what):
	if what == NOTIFICATION_PARENTED:
		update_configuration_warnings()


func _get_configuration_warnings():
	if !get_parent() is BehaviourTree:
		return ["Parent must be a BehaviourTree node for it to function."]
	return []


func change_behaviour(behaviour_name:StringName):
	get_parent().change_behaviour(behaviour_name)


func __update_node():
	set_physics_process(enabled)
	set_process(enabled)
	set_process_input(enabled)
	set_process_unhandled_input(enabled)


func __on_disable():
	enabled = false
	
	
func __on_behaviour_change(behaviour_name:StringName):
	enabled = name == behaviour_name
