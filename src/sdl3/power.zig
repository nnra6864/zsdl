//! Power Management Status (SDL_power.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

pub const PowerState = enum(c_int) {
    @"error" = -1,
    unknown,
    on_battery,
    no_battery,
    charging,
    charged,
};

// TODO: SDL_GetPowerInfo
