//! Pen Support (SDL_pen.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

pub const PenId = enum(u32) { invalid = 0, _ };

pub const PEN_MOUSEID: c_int = -2;

pub const PEN_TOUCHID: c_int = -2;

pub const PenInputFlags = packed struct(u32) {
    down: u1,
    button_1: u1,
    button_2: u1,
    button_3: u1,
    button_4: u1,
    button_5: u1,
    _: u25,
    eraser_tip: u1,
};

pub const PEN_INPUT_DOWN: u32 = @as(u32, 1) << 0;
pub const PEN_INPUT_BUTTON_1: u32 = @as(u32, 1) << 1;
pub const PEN_INPUT_BUTTON_2: u32 = @as(u32, 1) << 2;
pub const PEN_INPUT_BUTTON_3: u32 = @as(u32, 1) << 3;
pub const PEN_INPUT_BUTTON_4: u32 = @as(u32, 1) << 4;
pub const PEN_INPUT_BUTTON_5: u32 = @as(u32, 1) << 5;
pub const PEN_INPUT_ERASER_TIP: u32 = @as(u32, 1) << 30;

pub const PenAxis = enum(c_int) {
    pressure,
    xtilt,
    ytilt,
    distance,
    rotation,
    slider,
    tangential_pressure,
};
