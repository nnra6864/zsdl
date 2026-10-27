//! Pen Support (SDL_pen.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

/// SDL pen instance IDs.
///
/// Zero is used to signify an invalid/null device.
///
/// These show up in pen events when SDL sees input from them. They remain
/// consistent as long as SDL can recognize a tool to be the same pen; but if a
/// pen physically leaves the area and returns, it might get a new ID.
pub const PenId = enum(u32) { invalid = 0, _ };

/// The `MouseId` for mouse events simulated with pen input.
pub const pen_mouseid: sdl.MouseId = @fromBackingInt(@intCast(std.math.maxInt(u32) - 1));

/// The `TouchId` for touch events simulated with pen input.
pub const pen_touchid: sdl.TouchId = @fromBackingInt(@intCast(std.math.maxInt(u64) - 1));

/// Pen input flags, as reported by various pen events' `pen_state` field.
pub const PenInputFlags = packed struct(u32) {
    /// pen is pressed down
    down: bool = false,
    /// button 1 is pressed
    button_1: bool = false,
    /// button 2 is pressed
    button_2: bool = false,
    /// button 3 is pressed
    button_3: bool = false,
    /// button 4 is pressed
    button_4: bool = false,
    /// button 5 is pressed
    button_5: bool = false,
    __unused6: u24 = 0,
    /// eraser tip is used
    eraser_tip: bool = false,
    __unused31: u1 = 0,
};

/// Pen axis indices.
///
/// These are the valid values for the `axis` field in `PenAxisEvent`. All
/// axes are either normalised to 0..1 or report a (positive or negative) angle
/// in degrees, with 0.0 representing the centre. Not all pens/backends support
/// all axes: unsupported axes are always zero.
///
/// To convert angles for tilt and rotation into vector representation, use
/// `sinf` on the XTILT, YTILT, or ROTATION component, for example:
///
/// ``sinf`(xtilt * SDL_PI_F / 180.0)`.
pub const PenAxis = enum(c_int) {
    /// Pen pressure.  Unidirectional: 0 to 1.0
    pressure,
    /// Pen horizontal tilt angle.  Bidirectional: -90.0 to 90.0 (left-to-right).
    xtilt,
    /// Pen vertical tilt angle.  Bidirectional: -90.0 to 90.0 (top-to-down).
    ytilt,
    /// Pen distance to drawing surface.  Unidirectional: 0.0 to 1.0
    distance,
    /// Pen barrel rotation.  Bidirectional: -180 to 179.9 (clockwise, 0 is facing up, -180.0 is facing down).
    rotation,
    /// Pen finger wheel or slider (e.g., Airbrush Pen).  Unidirectional: 0 to 1.0
    slider,
    /// Pressure from squeezing the pen ("barrel pressure").
    tangential_pressure,
    /// Total known pen axis types in this version of SDL. This number may grow in future releases!
    count,
};
