package blitzbasic3d

import "core:math"

Left :: proc(text: string, count: i32) -> string {
	length := math.min(len(text), int(count))
	return text[:length]
}

