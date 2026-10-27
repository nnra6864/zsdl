//! Error Handling (SDL_error.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

pub fn getError() ?[:0]const u8 {
    if (SDL_GetError()) |err_str| {
        return std.mem.span(err_str);
    }
    return null;
}
extern fn SDL_GetError() [*c]const u8;
