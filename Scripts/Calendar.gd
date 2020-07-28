extends Node2D

signal date_changed
signal week_end
var year
var month
var day

var year_str
var month_str
var day_str

var game_speed = 10
var time = 0
var week_timer = 0

var days = {
	"January": 31,
	"February": 28,
	"March": 31,
	"April": 30,
	"May": 31,
	"June": 30,
	"July": 31,
	"August": 31,
	"September": 30,
	"October": 31,
	"November": 31,
	"December": 31
}

var month_strings = ["N/A"]

func _ready():
	for month in days.keys():
		month_strings.append(month)
	$Timer.wait_time = game_speed

func _on_Timer_timeout():
	advance_day()
	set_strings()
	emit_signal("date_changed", get_date_string())

func set_start_date():
	year = 1600
	month = 1
	day = 1
	set_strings()
	emit_signal("date_changed", get_date_string())

func get_date_string():
	return month_str + " " + day_str + ", " + year_str

func get_day_string():
	if day == 1 or day == 21 or day == 31:
		return str(day) + "st"
	elif day == 2 or day == 22:
		return str(day) + "nd"
	elif day == 3 or day == 23:
		return str(day) + "nd"
	else:
		return str(day) + "th"

func set_strings():
	day_str = get_day_string()
	month_str = month_strings[month]
	year_str = str(year)


func advance_day():
	week_timer += 1
	if week_timer == 7:
		week_timer = 0
		emit_signal("week_end")
	if day < days[month_str]:
		day += 1
	else:
		day = 1
		advance_month()

func advance_month():
	if month < 12:
		month += 1
	else:
		month = 1
		advance_year()

func advance_year():
	year += 1


