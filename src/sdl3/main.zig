//! Application entry points (SDL_main.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

pub const AppResult = enum(c_int) {
    @"continue" = 0,
    success = 1,
    failure = 2,
};

pub const AppInitFn = fn (?*?*anyopaque, c_int, [*c][*c]const u8) callconv(.c) AppResult;
pub const AppIterateFn = fn (?*anyopaque) callconv(.c) AppResult;
pub const AppEventFn = fn (?*anyopaque, *sdl.Event) callconv(.c) AppResult;
pub const AppQuitFn = fn (?*anyopaque, AppResult) callconv(.c) void;

pub const enterAppMainCallbacks = SDL_EnterAppMainCallbacks;
extern fn SDL_EnterAppMainCallbacks(
    argc: c_int,
    argv: [*c][*c]u8,
    appinit: ?*const AppInitFn,
    appiter: ?*const AppIterateFn,
    appevent: ?*const AppEventFn,
    appquit: ?*const AppQuitFn,
) c_int;

pub const setMainReady = SDL_SetMainReady;
extern fn SDL_SetMainReady() void;
