package main

import bb "blitzbasic3d"
import "core:fmt"
import "core:log"
import "core:os"
import "core:mem"


LEAK_CHECKING :: true

file_for_loging: os.Handle
logger: log.Logger


main :: proc() {
	when LEAK_CHECKING {
		track: mem.Tracking_Allocator
		mem.tracking_allocator_init(&track, context.allocator)
		defer mem.tracking_allocator_destroy(&track)
		context.allocator = mem.tracking_allocator(&track)
		defer {
			total := 0
			for _, leak in track.allocation_map {
				fmt.printf("%v leaked %m\n", leak.location, leak.size)
				total += 1
			}
			fmt.println("Total leaks: ", total)
		}
	}

	err: os.Error
	file_for_loging, err = os.open("logs.txt", os.O_CREATE | os.O_WRONLY | os.O_TRUNC, 0o600)
	assert(err==nil)
	defer os.close(file_for_loging)

	logger = log.create_file_logger(file_for_loging)
	context.logger = logger
	defer log.destroy_file_logger(logger)

	bb.init()
	defer bb.destroy()

	// Includes
	// Note: Make sure its in the same order as the include commands in Gameplay.bb
	init_texts()
	init_values()
	free_all(context.temp_allocator) // Cleanup tprints

	// Gameplay.bb entry point, the code section after the includes
	entry_point()
}
