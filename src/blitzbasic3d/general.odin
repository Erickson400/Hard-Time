#+private
package blitzbasic3d

import "core:fmt"
import "core:math/rand"


rnd_float :: proc(min, max: f32) -> f32 {
    return rand.float32_range(min, max)
}


rnd_int :: proc(min, max: i32) -> i32 {
    width := min - max
    return (cast(i32)rand.uint32() % width) + min
}
