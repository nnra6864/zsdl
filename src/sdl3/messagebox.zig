//! Message Boxes (SDL_messagebox.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

pub const MessageBoxFlags = packed struct(u32) {
    err: bool = false,
    warning: bool = false,
    information: bool = false,
    buttons_left_to_right: bool = false,
    buttons_right_to_left: bool = false,
    __unused: u27 = 0,
};

pub fn showSimpleMessageBox(
    flags: MessageBoxFlags,
    title: ?[:0]const u8,
    message: ?[:0]const u8,
    window: ?*sdl.Window,
) Error!void {
    if (!SDL_ShowSimpleMessageBox(flags, @ptrCast(title), @ptrCast(message), window)) {
        return makeError();
    }
}
extern fn SDL_ShowSimpleMessageBox(
    flags: MessageBoxFlags,
    title: [*c]const u8,
    message: [*c]const u8,
    window: ?*sdl.Window,
) bool;
