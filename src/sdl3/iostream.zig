//! I/O Streams (SDL_iostream.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

/// The read/write operation structure.
///
/// This operates as an opaque handle. There are several APIs to create
/// various types of I/O streams, or an app can supply an `IOStreamInterface`
/// to `openIO` to provide their own stream implementation behind this
/// struct's abstract interface.
pub const IOStream = opaque {};
