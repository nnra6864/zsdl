//! Querying SDL Version (SDL_version.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

pub const Version = extern struct {
    major: u8,
    minor: u8,
    patch: u8,
};

/// Returns the linked SDL version
pub fn getVersion() Version {
    var version: Version = undefined;
    SDL_GetVersion(&version);

    return version;
}
extern fn SDL_GetVersion(version: *Version) void;
