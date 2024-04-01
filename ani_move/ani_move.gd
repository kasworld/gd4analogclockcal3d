extends Node2D

var enabled = false
var current_step = 0
var begin_tick = 0
var step_dur_sec = 1.0
var remain_step :int

func toggle()->void:
	if enabled:
		stop()
	else:
		start(step_dur_sec)

func start(p :float = 1)->void:
	step_dur_sec = p
	enabled = true
	begin_tick = Time.get_unix_time_from_system()
	$Timer.start(step_dur_sec)

# auto stop after step change
func start_with_step(step :int, p :float = 1, )->void:
	remain_step = step
	start(p)

func stop()->void:
	enabled = false
	$Timer.stop()

func _on_timer_timeout() -> void:
	current_step += 1
	begin_tick = Time.get_unix_time_from_system()
	if remain_step > 0 :
		remain_step -= 1
		if remain_step <= 0:
			stop()

# v1,v2 : + - , * with float
# return type of v1,v2
func calc_inter(v1 , v2 , t :float):
	return (cos(t *PI / step_dur_sec)/2 +0.5) * (v1-v2) + v2

# o :position , p1,p2 : + - , * with float
func move_by_ms(o , p1 , p2 , ms:float)->void:
	o.position = calc_inter(p1,p2,ms)

# o :position, pos_list[n] : + - , * with float
func move_position(o , pos_list :Array, ms :float)->void:
	var l = pos_list.size()
	var p1 = pos_list[current_step%l]
	var p2 = pos_list[(current_step+1)%l]
	o.position = calc_inter(p1,p2,ms)

func get_ms()->float:
	return Time.get_unix_time_from_system() - begin_tick

