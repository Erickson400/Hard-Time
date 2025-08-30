package blitzbasic3d


RenderingEntryType :: enum {
	CLEAR, // Clear color never specified
	DRAW_IMAGE,
	TILE_IMAGE,
}



RenderingEntry :: struct {
	type: RenderingEntryType,
	data: rawptr,
}



rendering_queue: [dynamic]RenderingEntry


init_rendering_system :: proc() {
	rendering_queue = make([dynamic]RenderingEntry, 0, 100);
}


destroy_rendering_system :: proc() {
	delete(rendering_queue)
}


cls :: proc() {

}


flip :: proc() {

}
