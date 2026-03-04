#+vet !unused-imports
package main

import bb "blitzbasic3d"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"

main :: proc() {
	// Create tracking allocator
	when ODIN_DEBUG {
		tracker: mem.Tracking_Allocator
		mem.tracking_allocator_init(&tracker, context.allocator)
		context.allocator = mem.tracking_allocator(&tracker)
		defer {
			if len(tracker.allocation_map) > 0 {
				total_size := 0
				for _, leak in tracker.allocation_map {
					fmt.printf("%v leaked %m\n", leak.location, leak.size)
					total_size += leak.size
				}
				fmt.printf("Total leaks: %v\nTotal leak Size: %m", len(tracker.allocation_map), total_size)
			}
			mem.tracking_allocator_destroy(&tracker)
		}
	}

	// Create file logger. (Info level for debug, Error level for release)
	log_file, _ := os.open("logs.txt", {.Create, .Trunc})
	context.logger = log.create_file_logger(log_file)
	context.logger.lowest_level = .Info when ODIN_DEBUG else .Error
	defer os.close(log_file)
	defer log.destroy_file_logger(context.logger )

	
	// Initialize BlitzBasic3D
	bb.init()
	defer bb.destroy()

	// NOTE: Make sure its in the same order as the include commands in Gameplay.bb.
	// If the ported file has no init function then its because there is no global code execution,
	// they only define functions.
	// Gameplay.bb include files.
	init_values()
	free_all(context.temp_allocator) // Cleanup tprints

	// Gameplay.bb entry point, the code section after the includes
	entry_point()
}
