#+private
package blitzbasic3d

import ray "vendor:raylib"
import "core:strings"
import "core:log"
import "core:fmt"

/*
	This system also handles GPU textures
*/


ImageResource :: struct {
	image: ray.Image,
	texture: ray.Texture2D,
	path: string,
}

TextureResource :: struct {
	texture: ray.Texture2D,
	flags: i32,
	path: string,
}

AnimTextureResource :: struct {
	textures: [dynamic]ray.Texture2D,
	flags: i32,
}


loaded_images: [dynamic]ImageResource
loaded_textures: [dynamic]TextureResource
loaded_anim_textures: [dynamic]AnimTextureResource


init_image_system :: proc() {
	loaded_images = make([dynamic]ImageResource, 0, 10)
	loaded_textures = make([dynamic]TextureResource, 0, 10)
	loaded_anim_textures = make([dynamic]AnimTextureResource)
}


destroy_image_system :: proc() {
	for &li in loaded_images {
		ray.UnloadImage(li.image)
		ray.UnloadTexture(li.texture)
		delete(li.path)
	}
	delete(loaded_images)

	for &lt in loaded_textures {
		ray.UnloadTexture(lt.texture)
		delete(lt.path)
	}
	delete(loaded_textures)

	for &lat in loaded_anim_textures {
		for &tex in lat.textures {
			ray.UnloadTexture(tex)
		}
		delete(lat.textures)
	}
	delete(loaded_anim_textures)
}


load_image :: proc(filename: string) -> i32 {
	path, err := strings.concatenate({"assets/", filename}); assert(err==nil)

	// Check if path is already loaded
	for li, index in loaded_images {
		if li.path == path {
			log.warnf("Image: '%s' is already loaded", path)
			return i32(index)
		}
	}

	cstring_filename := strings.clone_to_cstring(path)
	defer delete(cstring_filename)

	image: ImageResource
	image.image = ray.LoadImage(cstring_filename)
	image.path = path
	error_string := fmt.aprintf("Failed to load image: %s", path)
	assert(ray.IsImageValid(image.image), error_string)
	delete(error_string)
	ray.ImageFormat(&image.image, ray.PixelFormat.UNCOMPRESSED_R8G8B8A8)
	image.texture = ray.LoadTextureFromImage(image.image)
	assert(ray.IsTextureValid(image.texture), "Failed to create texture from image")

	append(&loaded_images, image)
	return i32(len(loaded_images) - 1)
}


mask_image :: proc(image_handle: i32, r, g, b: u8, loc := #caller_location) {
	assert(int(image_handle) < len(loaded_images), loc = loc)
	ray.ImageColorReplace(&loaded_images[image_handle].image, ray.Color{r, g, b, 255}, ray.BLANK)
	ray.UpdateTexture(loaded_images[image_handle].texture, loaded_images[image_handle].image.data)
}


load_texture :: proc(filename: string, flags: i32 = 1) -> i32 {
	// 1: Color - colour map, what you see is what you get.
	// 4: Masked - all areas of a texture coloured 0,0,0 will not be drawn to the screen.
	
	path, err := strings.concatenate({"assets/", filename}); assert(err==nil)

	// Check if path is already loaded
	for lt, index in loaded_textures {
		if lt.path == path {
			log.warnf("Texture: '%s' is already loaded", path)
			return i32(index)
		}
	}

	cstring_filename := strings.clone_to_cstring(path)
	defer delete(cstring_filename)

	texture: TextureResource
	texture.texture = ray.LoadTexture(cstring_filename)
	texture.flags = flags
	texture.path = path
	error_string := fmt.aprintf("Failed to load texture: %s", path)
	assert(ray.IsTextureValid(texture.texture), error_string)
	delete(error_string)

	append(&loaded_textures, texture)
	return i32(len(loaded_textures) - 1)
}


load_anim_texture :: proc(filenames: string, flags: i32, frame_width, frame_height, first_frame, frame_count: i32) -> i32 {
	cstring_filenames := strings.clone_to_cstring(filenames)
	defer delete(cstring_filenames)
	sprite_sheet := ray.LoadImage(cstring_filenames)
	assert(ray.IsImageValid(sprite_sheet), "Failed to load image for animated texture")
	defer ray.UnloadImage(sprite_sheet)

	frames := make([dynamic]ray.Image)
	defer delete(frames)

	h_count := i32(sprite_sheet.width / frame_width)
	v_count := i32(sprite_sheet.height / frame_height)

	for y in 0..<v_count {
		for x in 0..<h_count {
			rect := ray.Rectangle{f32(x*frame_width), f32(y*frame_height), f32(frame_width), f32(frame_height)}
			frame := ray.ImageFromImage(sprite_sheet, rect)
			append(&frames, frame)
		}   
	}

	anim_texture: AnimTextureResource
	anim_texture.flags = flags
	anim_texture.textures = make([dynamic]ray.Texture2D, frame_count)
	for frame_index in first_frame..<frame_count {
		append(&anim_texture.textures, ray.LoadTextureFromImage(frames[frame_index]))
	}
	append(&loaded_anim_textures, anim_texture)
	return i32(len(loaded_anim_textures) - 1)
}


save_image :: proc(image_handle: i32, path: string) -> i32 {
	cpath := fmt.caprint(path)
	defer delete(cpath)
	ok := ray.ExportImage(loaded_images[image_handle].image, cpath)
	return 1 if ok else 0
}

