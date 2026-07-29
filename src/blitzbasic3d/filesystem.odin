package blitzbasic3d

import "core:os"
import "core:fmt"
import "core:path/filepath"

WriteFile :: proc(path: string) -> ^os.File {
	full_path, _ := filepath.join({"assets", path})
	file, err := os.open(full_path, {.Write, .Trunc, .Create})
	if err != nil do fmt.panicf("File could not be opened: %s", full_path)
	delete(full_path)
	return file
}

ReadFile :: proc(path: string) -> ^os.File {
	full_path, _ := filepath.join({"assets", path})
	file, err := os.open(full_path)
	if err != nil do fmt.panicf("File could not be opened: %s", full_path)
	delete(full_path)
	return file
}

CloseFile :: proc(file: ^os.File) {
	os.close(file)
}

WriteInt :: proc(file: ^os.File, value: i32) {
	bytes := transmute([4]byte)value
	_, err := os.write(file, bytes[:])
	if err != nil do fmt.panicf("Could not write to file")
}

WriteFloat :: proc(file: ^os.File, value: f32) {
	bytes := transmute([4]byte)value
	_, err := os.write(file, bytes[:])
	if err != nil do fmt.panicf("Could not write to file")
}

WriteString :: proc(file: ^os.File, value: string) {
	text := transmute([]byte)value
	size := transmute([4]byte)cast(i32)(len(value))
	_, err := os.write(file, size[:])
	if err != nil do fmt.panicf("Could not write to file")
	_, err = os.write(file, text[:])
	if err != nil do fmt.panicf("Could not write to file")
}

ReadInt :: proc(file: ^os.File) -> i32 {
	buff: [4]byte
	_, err := os.read(file, buff[:])
	if err != nil do fmt.panicf("Could not read file")
	return transmute(i32)buff
}

ReadFloat :: proc(file: ^os.File) -> f32 {
	buff: [4]byte
	_, err := os.read(file, buff[:])
	if err != nil do fmt.panicf("Could not read file")
	return transmute(f32)buff
}

ReadString :: proc(file: ^os.File, allocator := context.allocator) -> string {
	size_array: [4]byte
	_, err := os.read(file, size_array[:])
	if err != nil do fmt.panicf("Could not read file")
	size := transmute(i32)size_array
	text := make([]byte, size, allocator)
	_, err = os.read(file, text[:])
	if err != nil do fmt.panicf("Could not read file")
	return transmute(string)text
}

