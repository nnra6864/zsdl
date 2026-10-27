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

/// This is a unique ID for a joystick for the time it is connected to the
/// system, and is never reused for the lifetime of the application.
pub const JoystickId = Joystick.Id;

/// The state of a joystick hat (POV), as reported by joystick events and
/// `getJoystickHat`.
///
/// Note that zero (all fields false) means the POV is centered.
pub const HatState = packed struct(u8) {
    up: bool = false,
    right: bool = false,
    down: bool = false,
    left: bool = false,
    __unused4: u4 = 0,

    pub const centered: HatState = .{};
    pub const right_up: HatState = .{ .right = true, .up = true };
    pub const right_down: HatState = .{ .right = true, .down = true };
    pub const left_up: HatState = .{ .left = true, .up = true };
    pub const left_down: HatState = .{ .left = true, .down = true };
};
