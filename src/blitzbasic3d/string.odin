package blitzbasic3d

import "core:strings"
import "core:math"

Upper :: proc(text: string, allocator := context.temp_allocator) -> string {
	return strings.to_upper(text, allocator)
}

Lower :: proc(text: string, allocator := context.temp_allocator) -> string {
	return strings.to_lower(text, allocator)
}

Left :: proc(text: string, count: i32) -> string {
	length := math.min(len(text), int(count))
	return text[:length]
}

