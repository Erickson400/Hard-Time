package main

import bb "blitzbasic3d"
import "core:fmt"
import "core:log"
import "core:mem"
import "core:os"
// import "core:time"

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
	log_file, err := os.open("logs.txt", {.Create, .Write, .Trunc}); assert(err == nil)
	context.logger = log.create_file_logger(
		log_file,
		.Debug when ODIN_DEBUG else .Error,
		{.Level, .Time, .Short_File_Path, .Line},
	)
	defer os.close(log_file)
	defer log.destroy_file_logger(context.logger )

	// Initialize BlitzBasic3D
	bb.Init()
	defer bb.Destroy()

	// time.sleep(1 * time.Second)

	// Values.bb is the only file with global code execution, and global variable declarations.
	init_values()
	log.debugf("Values initialized")

	// Gameplay.bb entry point, the code section after the includes
	entry_point()
}
