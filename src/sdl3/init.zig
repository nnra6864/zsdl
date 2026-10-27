//! Initialization and Shutdown (SDL_init.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

pub const InitFlags = packed struct(u32) {
    __unused0: bool = false,
    __unused1: bool = false,
    __unused2: bool = false,
    __unused3: bool = false,
    audio: bool = false,
    video: bool = false,
    __unused6: bool = false,
    __unused7: bool = false,
    __unused8: bool = false,
    joystick: bool = false,
    __unused10: bool = false,
    __unused11: bool = false,
    haptic: bool = false,
    gamepad: bool = false,
    events: bool = false,
    sensor: bool = false,
    camera: bool = false,
    __unused17: u15 = 0,

    pub const everything: InitFlags = .{
        .audio = true,
        .video = true,
        .events = true,
        .joystick = true,
        .haptic = true,
        .gamepad = true,
        .sensor = true,
        .camera = true,
    };
};

pub fn init(flags: InitFlags) Error!void {
    if (!SDL_Init(flags)) return makeError();
}
extern fn SDL_Init(flags: InitFlags) bool;

pub const quit = SDL_Quit;
extern fn SDL_Quit() void;
