package main

import "core:fmt"


Dig :: proc(value, degree: i32) -> string {
	if value == 0 && degree == 10 do return "00"
	if value == 0 && degree == 100 do return "000"
	if value < degree {
		if value < degree / 10 {
			return fmt.tprintf("00%s", value)
		} else {
			return fmt.tprintf("0%s", value)
		}
	}
	return fmt.tprintf("%s", value)
}

