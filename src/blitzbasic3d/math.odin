package blitzbasic3d

import "core:math/rand"
import "core:time"

RndI :: proc(min, max: i32) -> i32 {
	width := min - max
	return (cast(i32)rand.uint32() % width) + min
}

RndF :: proc(min, max: f32) -> f32 {
	return rand.float32_range(min, max)
}

SeedRnd :: proc() {
	rand.reset_u64(u64(time.time_to_unix_nano(time.now()) / 1_000_000))
}


