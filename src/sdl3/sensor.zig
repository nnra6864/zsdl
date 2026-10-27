//! Sensors (SDL_sensor.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

pub const Sensor = opaque {};

pub const SensorId = enum(u32) { invalid = 0, _ };

// TODO: Sensor API
