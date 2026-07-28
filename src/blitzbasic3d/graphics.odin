package blitzbasic3d


// Legacy feature for old hardware
GfxMode3DExists :: proc(width, height, depth: i32) -> i32 { return 1}

Graphics3D :: proc(width, height, color, fullscreen: i32) {
	// This changes the resolution, not create the window.
	// The screen is always fullscreen. the windowed version was compiled separatly
	// and I'm not sure what the source code looks look.
	// Color param can also be ignored
	
}




