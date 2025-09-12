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

loaded_fonts: [dynamic]FontResource


init_font_system :: proc() {
	loaded_fonts = make([dynamic]FontResource, 0, 10)
}


destroy_font_system :: proc() {
	for &lf in loaded_fonts {
		ray.UnloadFont(lf.font)
		delete(lf.path)
	}
	delete(loaded_fonts)
}


load_font :: proc(filename: string, height: i32, bold: bool, italic: bool, underline: bool) -> i32 {
	path, err := strings.concatenate({"assets/Fonts/", filename}); assert(err==nil)

	// Check if path is already loaded
	for lf, index in loaded_fonts {
		if lf.path == path && lf.font.baseSize == height && lf.bold == bold && lf.italic == italic && lf.underline == underline {
			log.warnf("Font: '%s' is already loaded with the provided properties", path)
			return i32(index)
		}
	}

	cstring_filename := strings.clone_to_cstring(path)
	defer delete(cstring_filename)

	font: FontResource
	font.font = ray.LoadFont(cstring_filename)
	font.font.baseSize = height
	font.path = path
	font.bold = bold
	font.italic = italic
	font.underline = underline
	error_string := fmt.aprintf("Failed to load font: %s", path)
	assert(ray.IsFontValid(font.font), error_string)
	delete(error_string)

	append(&loaded_fonts, font)
	return i32(len(loaded_fonts) - 1)
}

