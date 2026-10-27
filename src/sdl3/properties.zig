//! Object Properties (SDL_properties.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

pub const PropertiesID = enum(u32) { _ };

pub const PropertyType = enum(c_int) {
    invalid = 0,
    pointer = 1,
    string = 2,
    number = 3,
    float = 4,
    boolean = 5,
};

pub const CleanupPropertyCallback = *const fn (userdata: ?*anyopaque, value: ?*anyopaque) callconv(.c) void;

pub const EnumeratePropertiesCallback = *const fn (userdata: ?*anyopaque, props: PropertiesID, name: [*c]const u8) callconv(.c) void;

pub const getGlobalProperties = SDL_GetGlobalProperties;
extern fn SDL_GetGlobalProperties() PropertiesID;

pub const createProperties = SDL_CreateProperties;
extern fn SDL_CreateProperties() PropertiesID;

pub fn copyProperties(src: PropertiesID, dst: PropertiesID) Error!void {
    if (!SDL_CopyProperties(src, dst)) return makeError();
}
extern fn SDL_CopyProperties(src: PropertiesID, dst: PropertiesID) bool;

pub fn lockProperties(props: PropertiesID) Error!void {
    if (!SDL_LockProperties(props)) return makeError();
}
extern fn SDL_LockProperties(props: PropertiesID) bool;

pub const unlockProperties = SDL_UnlockProperties;
extern fn SDL_UnlockProperties(props: PropertiesID) void;

pub fn setPointerPropertyWithCleanup(
    props: PropertiesID,
    name: [:0]const u8,
    value: ?*anyopaque,
    cleanup: ?CleanupPropertyCallback,
    userdata: ?*anyopaque,
) Error!void {
    if (!SDL_SetPointerPropertyWithCleanup(props, @ptrCast(name.ptr), value, cleanup, userdata)) {
        return makeError();
    }
}
extern fn SDL_SetPointerPropertyWithCleanup(
    props: PropertiesID,
    name: [*c]const u8,
    value: ?*anyopaque,
    cleanup: ?CleanupPropertyCallback,
    userdata: ?*anyopaque,
) bool;

pub fn setPointerProperty(props: PropertiesID, name: [:0]const u8, value: ?*anyopaque) Error!void {
    if (!SDL_SetPointerProperty(props, @ptrCast(name.ptr), value)) return makeError();
}
extern fn SDL_SetPointerProperty(props: PropertiesID, name: [*c]const u8, value: ?*anyopaque) bool;

pub fn setStringProperty(props: PropertiesID, name: [:0]const u8, value: ?[:0]const u8) Error!void {
    const val_ptr = if (value) |v| @as([*c]const u8, @ptrCast(v.ptr)) else null;
    if (!SDL_SetStringProperty(props, @ptrCast(name.ptr), val_ptr)) return makeError();
}
extern fn SDL_SetStringProperty(props: PropertiesID, name: [*c]const u8, value: [*c]const u8) bool;

pub fn setNumberProperty(props: PropertiesID, name: [:0]const u8, value: i64) Error!void {
    if (!SDL_SetNumberProperty(props, @ptrCast(name.ptr), value)) return makeError();
}
extern fn SDL_SetNumberProperty(props: PropertiesID, name: [*c]const u8, value: i64) bool;

pub fn setFloatProperty(props: PropertiesID, name: [:0]const u8, value: f32) Error!void {
    if (!SDL_SetFloatProperty(props, @ptrCast(name.ptr), value)) return makeError();
}
extern fn SDL_SetFloatProperty(props: PropertiesID, name: [*c]const u8, value: f32) bool;

pub fn setBooleanProperty(props: PropertiesID, name: [:0]const u8, value: bool) Error!void {
    if (!SDL_SetBooleanProperty(props, @ptrCast(name.ptr), value)) return makeError();
}
extern fn SDL_SetBooleanProperty(props: PropertiesID, name: [*c]const u8, value: bool) bool;

pub fn hasProperty(props: PropertiesID, name: [:0]const u8) bool {
    return SDL_HasProperty(props, @ptrCast(name.ptr));
}
extern fn SDL_HasProperty(props: PropertiesID, name: [*c]const u8) bool;

pub fn getPropertyType(props: PropertiesID, name: [:0]const u8) PropertyType {
    return SDL_GetPropertyType(props, @ptrCast(name.ptr));
}
extern fn SDL_GetPropertyType(props: PropertiesID, name: [*c]const u8) PropertyType;

pub fn getPointerProperty(props: PropertiesID, name: [:0]const u8, default_value: ?*anyopaque) ?*anyopaque {
    return SDL_GetPointerProperty(props, @ptrCast(name.ptr), default_value);
}
extern fn SDL_GetPointerProperty(props: PropertiesID, name: [*c]const u8, default_value: ?*anyopaque) ?*anyopaque;

pub fn getStringProperty(props: PropertiesID, name: [:0]const u8, default_value: ?[:0]const u8) ?[*:0]const u8 {
    return @ptrCast(SDL_GetStringProperty(
        props,
        @ptrCast(name.ptr),
        if (default_value) |default_str| @ptrCast(default_str.ptr) else null,
    ));
}
extern fn SDL_GetStringProperty(props: PropertiesID, name: [*c]const u8, default_value: [*c]const u8) [*c]const u8;

pub fn getNumberProperty(props: PropertiesID, name: [:0]const u8, default_value: i64) i64 {
    return SDL_GetNumberProperty(props, @ptrCast(name.ptr), default_value);
}
extern fn SDL_GetNumberProperty(props: PropertiesID, name: [*c]const u8, default_value: i64) i64;

pub fn getFloatProperty(props: PropertiesID, name: [:0]const u8, default_value: f32) f32 {
    return SDL_GetFloatProperty(props, @ptrCast(name.ptr), default_value);
}
extern fn SDL_GetFloatProperty(props: PropertiesID, name: [*c]const u8, default_value: f32) f32;

pub fn getBooleanProperty(props: PropertiesID, name: [:0]const u8, default_value: bool) bool {
    return SDL_GetBooleanProperty(props, @ptrCast(name.ptr), default_value);
}
extern fn SDL_GetBooleanProperty(props: PropertiesID, name: [*c]const u8, default_value: bool) bool;

pub fn clearProperty(props: PropertiesID, name: [:0]const u8) Error!void {
    if (!SDL_ClearProperty(props, @ptrCast(name.ptr))) return makeError();
}
extern fn SDL_ClearProperty(props: PropertiesID, name: [*c]const u8) bool;

pub fn enumerateProperties(props: PropertiesID, callback: EnumeratePropertiesCallback, userdata: ?*anyopaque) Error!void {
    if (!SDL_EnumerateProperties(props, callback, userdata)) return makeError();
}
extern fn SDL_EnumerateProperties(props: PropertiesID, callback: EnumeratePropertiesCallback, userdata: ?*anyopaque) bool;

pub const destroyProperties = SDL_DestroyProperties;
extern fn SDL_DestroyProperties(props: PropertiesID) void;
