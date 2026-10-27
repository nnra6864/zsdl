//! Joystick Support (SDL_joystick.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

pub const Joystick = struct {
    pub const Id = enum(u32) { invalid = 0, _ };

    pub const Type = enum(c_int) {
        unknown,
        gamepad,
        wheel,
        arcade_stick,
        flight_stick,
        dance_pad,
        guitar,
        drum_kit,
        arcade_pad,
        throttle,
    };

    pub const ConnectionState = enum(c_int) {
        invalid = -1,
        unknown,
        wired,
        wireless,
    };

    pub const JOYSTICK_AXIS_MAX = 32767;
    pub const JOYSTICK_AXIS_MIN = -32768;
};

// TODO: Joystick API (see SDL_joystick.h)
