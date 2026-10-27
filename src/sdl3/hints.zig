//! Configuration Variables (SDL_hints.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

pub const hint_windows_dpi_awareness = "SDL_WINDOWS_DPI_AWARENESS";

pub fn setHint(name: [:0]const u8, value: [:0]const u8) bool {
    return SDL_SetHint(@ptrCast(name.ptr), @ptrCast(value.ptr));
}
extern fn SDL_SetHint(name: [*c]const u8, value: [*c]const u8) bool;

pub fn setAppMetadata(name: [:0]const u8, version: [:0]const u8, identifier: [:0]const u8) Error!void {
    if (!SDL_SetAppMetadata(@ptrCast(name.ptr), @ptrCast(version.ptr), @ptrCast(identifier.ptr))) {
        return makeError();
    }
}
extern fn SDL_SetAppMetadata(appname: [*c]const u8, appversion: [*c]const u8, appidentifier: [*c]const u8) bool;
