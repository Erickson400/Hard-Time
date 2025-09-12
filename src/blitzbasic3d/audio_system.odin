#+private
package blitzbasic3d

import ray "vendor:raylib"
import "core:strings"
import "core:log"
import "core:fmt"

SoundResource :: struct {
	sound: ray.Sound,
	path: string,
	use_3d: bool,
}

loaded_sounds: [dynamic]SoundResource


init_audio_system :: proc() {
	loaded_sounds = make([dynamic]SoundResource, 0, 10)
}


destroy_audio_system :: proc() {
	for &ls in loaded_sounds {
		ray.UnloadSound(ls.sound)
		delete(ls.path)
	}
	delete(loaded_sounds)
}


load_sound :: proc(filename: string, use_3d: bool) -> i32 {
	path, err := strings.concatenate({"assets/", filename}); assert(err==nil)

	// Check if path is already loaded
	for ls, index in loaded_sounds {
		if ls.path == path {
			log.warnf("Sound: '%s' is already loaded", path)
			return i32(index)
		}
	}

	cstring_path := strings.clone_to_cstring(path)
	defer delete(cstring_path)

	sound: SoundResource
	sound.sound = ray.LoadSound(cstring_path)
	sound.path = path
	sound.use_3d = use_3d
	error_string := fmt.aprintf("Failed to load sound: %s", path)
	assert(ray.IsSoundValid(sound.sound), error_string)
	delete(error_string)
	
	append(&loaded_sounds, sound)
	return i32(len(loaded_sounds) - 1)
}
