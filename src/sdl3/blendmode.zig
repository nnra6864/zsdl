//! Blend modes (SDL_blendmode.h)

const std = @import("std");
const assert = std.debug.assert;

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

pub const BlendMode = enum(c_int) {
    none = 0x00000000,
    blend = 0x00000001,
    add = 0x00000002,
    mod = 0x00000004,
    multiply = 0x00000008,
    invalid = 0x7fffffff,
};
