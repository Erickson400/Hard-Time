#+private
package blitzbasic3d

import "core:os"
import "core:mem"


open_file :: proc(path: string, read: bool, loc := #caller_location) -> os.Handle {
    if read {
        file, err := os.open(path, os.O_RDONLY, 0o600)
        assert(err==nil, "Failed to open file", loc)
        return file
    }
    file, err := os.open(path, os.O_CREATE | os.O_TRUNC | os.O_WRONLY, 0o600)
    assert(err==nil, "Failed to open file", loc)
    return file
}


write_int :: proc(file: os.Handle, value: i32, loc := #caller_location) {
    value := value
    _, err := os.write(file, mem.ptr_to_bytes(&value))
    assert(err==nil, "Failed to write to file", loc)
}


write_float :: proc(file: os.Handle, value: f32, loc := #caller_location) {
    value := value
    _, err := os.write(file, mem.ptr_to_bytes(&value))
    assert(err==nil, "Failed to write to file", loc)
}


write_string :: proc(file: os.Handle, text: string, loc := #caller_location) {
    err: os.Error
    text_length := len(text)
    _, err = os.write(file, mem.ptr_to_bytes(&text_length)); assert(err==nil, loc = loc)
    _, err = os.write_string(file, text); assert(err==nil, loc = loc)
}


read_int :: proc(file: os.Handle, loc := #caller_location) -> i32 {
    value: i32
    _, err := os.write(file, mem.ptr_to_bytes(&value))
    assert(err==nil, "Failed to read file", loc)
    return value
}


read_string :: proc(file: os.Handle, loc := #caller_location) -> string {
    text_length: int
    err: os.Error
    _, err = os.read(file, mem.ptr_to_bytes(&text_length)); assert(err==nil, loc = loc)
    bytes := make([]u8, text_length)
    _, err = os.read(file, bytes); assert(err==nil, loc = loc)
    return string(bytes)
}


read_float :: proc(file: os.Handle, loc := #caller_location) -> f32 {
    value: f32
    _, err := os.write(file, mem.ptr_to_bytes(&value))
    assert(err==nil, "Failed to read file", loc)
    return value
}
