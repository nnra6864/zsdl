//! Touch Support (SDL_touch.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

pub const TouchId = u64;

pub const FingerId = u64;

pub const TouchDeviceType = enum(c_int) {
    invalid = -1,
    direct,
    indirect_absolute,
    indirect_relative,
};

pub const Finger = extern struct {
    id: FingerId,
    x: f32,
    y: f32,
    pressure: f32,
};

pub const TOUCH_MOUSEID: c_int = -1;

pub const MOUSE_TOUCHID: c_int = -1;

// TODO
// - SDL_GetTouchDevices
// - SDL_GetTouchDeviceName
// - SDL_GetTouchDeviceType
// - SDL_GetTouchFingers
