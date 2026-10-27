//! Keyboard Support (SDL_keyboard.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

/// This is a unique ID for a keyboard for the time it is connected to the
/// system, and is never reused for the lifetime of the application.
///
/// If the keyboard is disconnected and reconnected, it will get a new ID.
///
/// The value 0 is an invalid ID.
pub const KeyboardId = enum(u32) { invalid = 0, _ };

/// Return whether a keyboard is currently connected.
pub const hasKeyboard = SDL_HasKeyboard;
extern fn SDL_HasKeyboard() bool;

/// Get a list of currently connected keyboards.
///
/// Note that this will include any device or virtual driver that includes
/// keyboard functionality, including some mice, KVM switches, motherboard
/// power buttons, etc. You should wait for input from a device before you
/// consider it actively in use.
pub fn getKeyboards() Error![]KeyboardId {
    var count: c_int = undefined;
    const keyboards = SDL_GetKeyboards(&count) orelse return makeError();
    return keyboards[0..@intCast(count)];
}
extern fn SDL_GetKeyboards(count: ?*c_int) ?[*]KeyboardId;

/// Get the name of a keyboard.
///
/// This function returns "" if the keyboard doesn't have a name.
pub fn getKeyboardNameForId(instance_id: KeyboardId) Error![:0]const u8 {
    const name = SDL_GetKeyboardNameForID(instance_id) orelse return makeError();
    return std.mem.span(name);
}
extern fn SDL_GetKeyboardNameForID(instance_id: KeyboardId) ?[*:0]const u8;

/// Query the window which currently has keyboard focus.
pub const getKeyboardFocus = SDL_GetKeyboardFocus;
extern fn SDL_GetKeyboardFocus() ?*sdl.Window;

/// Get a snapshot of the current state of the keyboard.
///
/// The pointer returned is a pointer to an internal SDL array. It will be
/// valid for the whole lifetime of the application and should not be freed by
/// the caller.
///
/// A array element with a value of true means that the key is pressed and a
/// value of false means that it is not. Indexes into this array are obtained
/// by using `Scancode` values.
///
/// Use `pumpEvents` to update the state array.
///
/// This function gives you the current state after all events have been
/// processed, so if a key or button has been pressed and released before you
/// process events, then the pressed state will never show up in the
/// `getKeyboardState` calls.
///
/// Note: This function doesn't take into account whether shift has been
/// pressed or not.
pub fn getKeyboardState() []const bool {
    var numkeys: c_int = undefined;
    const ptr = SDL_GetKeyboardState(&numkeys) orelse return &.{};
    return ptr[0..@intCast(numkeys)];
}
extern fn SDL_GetKeyboardState(numkeys: ?*c_int) ?[*]const bool;

/// Clear the state of the keyboard.
///
/// This function will generate key up events for all pressed keys.
pub const resetKeyboard = SDL_ResetKeyboard;
extern fn SDL_ResetKeyboard() void;

/// Get the current key modifier state for the keyboard.
pub const getModState = SDL_GetModState;
extern fn SDL_GetModState() sdl.Keymod;

/// Set the current key modifier state for the keyboard.
///
/// The inverse of SDL_GetModState(), SDL_SetModState() allows you to impose
/// modifier key states on your application. Simply pass your desired modifier
/// states into `modstate`. This value may be a bitwise, OR'd combination of
/// SDL_Keymod values.
///
/// This does not change the keyboard state, only the key modifier flags that
/// SDL reports.
pub const setModState = SDL_SetModState;
extern fn SDL_SetModState(modstate: sdl.Keymod) void;

// TODO
// - SDL_GetKeyFromScancode
// - SDL_GetScancodeFromKey
// - SDL_SetScancodeName
// - SDL_GetScancodeName
// - SDL_GetScancodeFromName
// - SDL_GetKeyName
// - SDL_GetKeyFromName
// - SDL_StartTextInput
// - SDL_StartTextInputWithProperties
// - SDL_TextInputActive
// - SDL_StopTextInput
// - SDL_ClearComposition
// - SDL_SetTextInputArea
// - SDL_GetTextInputArea
// - SDL_HasScreenKeyboardSupport
// - SDL_ScreenKeyboardShown
