package main

import "core:fmt"

// FORMAT DIGITS (to 2 or 3 digits with leading zeros)
Dig :: proc(value, degree: i32) -> string {
	if value == 0 && degree == 10 do return "00"
	if value == 0 && degree == 100 do return "000"
	if value < degree {
		if value < degree / 10 {
			return fmt.aprintf("00%s", value)
		} else {
			return fmt.aprintf("0%s", value)
		}
	}
	return fmt.aprintf("%s", value)
}


// CALCULATE CENTRE (of any 2 numbers)
GetCentre :: proc(source, dest: f32) -> f32 {
	return source + (GetDiff(source, dest) / 2)
}


// CALCULATE DIFFERENCE (between any 2 numbers)
GetDiff :: proc(source, dest: f32) -> f32 {
	diff := dest - source
	if diff < 0 {
		diff = MakePositive(diff)
	}
	return diff
}


// FORCE MINUS INTO POSITIVE
MakePositive :: proc(value: f32) -> f32 {
	if value < 0 {
		return value - (value * 2)
	}
	return value
}



