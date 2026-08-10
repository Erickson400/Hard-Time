package blitzbasic3d

import "core:time"
import "core:sync"
import "core:thread"

Timer :: struct {
	hertz: i32,
	is_running: bool,
	counter: i32,
	thread: ^thread.Thread,
	mutex: sync.Mutex,
	cond: sync.Cond,
}

@(private="file")
_timer_proc :: proc() {
	timer := cast(^Timer)context.user_ptr
	sleep_duration := cast(time.Duration)((1.0 / cast(f64)timer.hertz) * 1_000_000) * time.Nanosecond
	for {
		time.sleep(sleep_duration)
		sync.lock(&timer.mutex)
		if !timer.is_running {
			sync.unlock(&timer.mutex)
			break
		}
		timer.counter += 1
		sync.cond_signal(&timer.cond)
		sync.unlock(&timer.mutex)
	}
}

CreateTimer :: proc(hertz: i32, allocator := context.allocator) -> ^Timer {
	timer := new(Timer, allocator)
	timer.hertz = hertz
	timer.is_running = true
	context.user_ptr = timer
	timer.thread = thread.create_and_start(_timer_proc, context)
	return timer
}

WaitTimer :: proc(timer: ^Timer) -> i32 {
	sync.lock(&timer.mutex)
	for timer.counter == 0 {
		sync.cond_wait(&timer.cond, &timer.mutex)
	}
	counter := timer.counter
	timer.counter = 0
	sync.unlock(&timer.mutex)
	return counter
}

FreeTimer :: proc(timer: ^Timer) {
	sync.lock(&timer.mutex)
	timer.is_running = false
	sync.unlock(&timer.mutex)
	thread.join(timer.thread)
	thread.destroy(timer.thread)
	free(timer)
}
