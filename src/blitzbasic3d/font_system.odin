#+private
package blitzbasic3d

import ray "vendor:raylib"
import "core:strings"
import "core:log"
import "core:fmt"


FontResource :: struct {
	font: ray.Font, // Also stores height
	path: string,
	bold: bool,
	italic: bool,
	underline: bool,
}

loaded_fonts: [dynamic]^FontResource


init_font_system :: proc() {
	loaded_fonts = make([dynamic]^FontResource, 0, 10)
}


destroy_font_system :: proc() {
	for &lf in loaded_fonts {
		if lf == nil do continue
		ray.UnloadFont(lf.font)
		delete(lf.path)
		free(lf)
		lf = nil
	}
	delete(loaded_fonts)
}


load_font :: proc(filename: string, height: i32, bold: bool, italic: bool, underline: bool) -> FontHandle {
	path, err := strings.concatenate({"assets/Fonts/", filename}); assert(err==nil)

	// Check if path is already loaded
	for lf, index in loaded_fonts {
		if lf == nil do continue
		if lf.path == path && lf.font.baseSize == height && lf.bold == bold && lf.italic == italic && lf.underline == underline {
			log.warnf("Font: '%s' is already loaded with the provided properties", path)
			return FontHandle(index)
		}
	}

	cstring_filename := strings.clone_to_cstring(path)
	defer delete(cstring_filename)

	font := new(FontResource)
	font.font = ray.LoadFont(cstring_filename)
	font.font.baseSize = height
	font.path = path
	font.bold = bold
	font.italic = italic
	font.underline = underline
	error_string := fmt.aprintf("Failed to load font: %s", path)
	assert(ray.IsFontValid(font.font), error_string)
	delete(error_string)
	
	// Find an empty slot
	found_empty_slot := false
	slot_used := -1
	for i in 0..<len(loaded_fonts) {
		if loaded_fonts[i] == nil {
			loaded_fonts[i] = font
			slot_used = i
			found_empty_slot = true
			break
		}
	}

	if !found_empty_slot {
		append(&loaded_fonts, font)
		slot_used = len(loaded_fonts) - 1
	}

	return FontHandle(slot_used)
}

is_font_handle_valid :: proc(handle: FontHandle) -> bool {
	if handle == -1 do return false
	if handle >= len(loaded_fonts) do return false
	if loaded_fonts[handle] == nil do return false
	return true
}