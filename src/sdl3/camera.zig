//! Camera (SDL_camera.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

pub const CameraId = enum(u32) { invalid = 0, _ };

pub const Camera = opaque {};

// TODO: Camera API
