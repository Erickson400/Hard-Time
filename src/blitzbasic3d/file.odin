package blitzbasic3d

import "core:os"
import "core:mem"


WriteFile :: proc(path: string, loc := #caller_location) -> os.Handle{
    file, err := os.open(path, os.O_CREATE | os.O_TRUNC | os.O_WRONLY, 0o600)
    assert(err==nil, "Failed to open file", loc)
    return file
}


ReadFile :: proc(path: string, loc := #caller_location) -> os.Handle{
    file, err := os.open(path, os.O_RDONLY, 0o600)
    assert(err==nil, "Failed to open file", loc)
    return file
}


CloseFile :: proc(file: os.Handle) {
    os.close(file)
}


WriteInt :: proc(file: os.Handle, value: i32, loc := #caller_location) {
    value := value
    _, err := os.write(file, mem.ptr_to_bytes(&value))
    assert(err==nil, "Failed to write to file", loc)
}


WriteFloat :: proc(file: os.Handle, value: f32, loc := #caller_location) {
    value := value
    _, err := os.write(file, mem.ptr_to_bytes(&value))
    assert(err==nil, "Failed to write to file", loc)
}


WriteString :: proc(file: os.Handle, text: string) {
    err: os.Error
    text_length := len(text)
    _, err = os.write(file, mem.ptr_to_bytes(&text_length)); assert(err==nil)
    _, err = os.write_string(file, text); assert(err==nil)
}


ReadInt :: proc(file: os.Handle, loc := #caller_location) -> i32 {
    value: i32
    _, err := os.write(file, mem.ptr_to_bytes(&value))
    assert(err==nil, "Failed to read file", loc)
    return value
}


ReadString :: proc(file: os.Handle) -> string {
    text_length: int
    err: os.Error
    _, err = os.read(file, mem.ptr_to_bytes(&text_length)); assert(err==nil)
    bytes := make([]u8, text_length)
    _, err = os.read(file, bytes); assert(err==nil)
    return string(bytes)
}


ReadFloat :: proc(file: os.Handle, loc := #caller_location) -> f32 {
    value: f32
    _, err := os.write(file, mem.ptr_to_bytes(&value))
    assert(err==nil, "Failed to read file", loc)
    return value
}
