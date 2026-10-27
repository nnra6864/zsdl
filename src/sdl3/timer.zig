//! Timer Support (SDL_timer.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

/// Get the number of nanoseconds since SDL library initialization.
pub const getTicksNS = SDL_GetTicksNS;
extern fn SDL_GetTicksNS() u64;

pub const getPerformanceCounter = SDL_GetPerformanceCounter;
extern fn SDL_GetPerformanceCounter() u64;

pub const getPerformanceFrequency = SDL_GetPerformanceFrequency;
extern fn SDL_GetPerformanceFrequency() u64;

pub const delay = SDL_Delay;
extern fn SDL_Delay(ms: u32) void;

pub const getTicks = SDL_GetTicks;
extern fn SDL_GetTicks() u64;
