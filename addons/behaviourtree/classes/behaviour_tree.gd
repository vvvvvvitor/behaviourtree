@tool
extends Node
class_name BehaviourTree


signal behaviours_disabled
signal behaviour_changed(behaviour:StringName)

@export_category("BehaviourTree")
@export var autostart_node:StringName = ""

func _init():
	update_configuration_warnings()
	if !Engine.is_editor_hint():
		await tree_entered
		if get_child_count() != 0:
			await get_children()[0].ready
			change_behaviour(get_child(0).name)


func _notification(what):
	if what == NOTIFICATION_CHILD_ORDER_CHANGED:
		update_configuration_warnings()


func _get_configuration_warnings():
	if get_child_count() == 0:
		return ["BehaviourTree must have at least one node for it to work properly."]
	return []


func find_behaviour(node_name:NodePath) -> Node:
	return get_node(node_name)


func change_behaviour(behaviour_name:StringName):
	emit_signal("behaviour_changed", behaviour_name)
	var animation_tree:AnimationTree = get_animation_tree()
	if animation_tree:
		var state_machine:AnimationNodeStateMachinePlayback = animation_tree["parameters/playback"]
		state_machine.travel(behaviour_name)


func disable_behaviours():
	emit_signal("behaviours_disabled")


func get_animation_tree() -> AnimationTree:
	for node in get_children():
		if node is AnimationTree:
			return node
	return
