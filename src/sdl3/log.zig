//! Log Handling (SDL_log.h)

const std = @import("std");
const assert = std.debug.assert;

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

pub const max_log_message = 4096;

/// The predefined log categories
///
/// By default the application and gpu categories are enabled at the INFO
/// level, the assert category is enabled at the WARN level, test is enabled at
/// the VERBOSE level and all other categories are enabled at the ERROR level.
pub const LogCategory = enum(c_int) {
    application = 0,
    @"error",
    assert,
    system,
    audio,
    video,
    render,
    input,
    @"test",
    gpu,
    reserved2,
    reserved3,
    reserved4,
    reserved5,
    reserved6,
    reserved7,
    reserved8,
    reserved9,
    reserved10,
    custom,
    _,
};

/// The predefined log priorities
pub const LogPriority = enum(c_int) {
    invalid = 0,
    trace,
    verbose,
    debug,
    info,
    warn,
    @"error",
    critical,
};

/// Set the priority of all log categories.
pub fn setLogPriorities(priority: LogPriority) void {
    SDL_SetLogPriorities(priority);
}
extern fn SDL_SetLogPriorities(priority: LogPriority) void;

/// Set the priority of a particular log category.
pub fn setLogPriority(category: LogCategory, priority: LogPriority) void {
    SDL_SetLogPriority(@backingInt(category), priority);
}
extern fn SDL_SetLogPriority(category: c_int, priority: LogPriority) void;

/// Get the priority of a particular log category.
pub fn getLogPriority(category: LogCategory) LogPriority {
    return SDL_GetLogPriority(@backingInt(category));
}
extern fn SDL_GetLogPriority(category: c_int) LogPriority;

/// Reset all priorities to default.
///
/// This is called by quit().
pub const resetLogPriorities = SDL_ResetLogPriorities;
extern fn SDL_ResetLogPriorities() void;

/// Set the text prepended to log messages of a given priority.
///
/// By default INFO and below have no prefix, and WARN and higher have a prefix
/// showing their priority, e.g. "WARNING: ".
pub fn setLogPriorityPrefix(priority: LogPriority, prefix: ?[:0]const u8) Error!void {
    if (!SDL_SetLogPriorityPrefix(
        priority,
        if (prefix) |p| @ptrCast(p.ptr) else null,
    )) {
        return makeError();
    }
}
extern fn SDL_SetLogPriorityPrefix(priority: LogPriority, prefix: [*c]const u8) bool;

/// Log a message with SDL_LOG_CATEGORY_APPLICATION and SDL_LOG_PRIORITY_INFO.
pub fn log(comptime fmt: []const u8, args: anytype) void {
    assert(fmt.len > 0 and fmt.len < max_log_message - 1);
    var buf: [max_log_message]u8 = undefined;
    const message = std.fmt.bufPrintSentinel(&buf, fmt, args, 0) catch |err| switch (err) {
        std.fmt.BufPrintError.NoSpaceLeft => {
            SDL_LogError(
                @backingInt(LogCategory.assert),
                "(log message exceeded %d characters)",
                @as(u32, max_log_message),
            );
            return;
        },
    };
    SDL_Log(@ptrCast(message.ptr));
}
extern fn SDL_Log(fmt: [*c]const u8, ...) void;

/// Log a message with SDL_LOG_PRIORITY_TRACE.
pub fn logTrace(category: LogCategory, comptime fmt: []const u8, args: anytype) void {
    assert(fmt.len > 0 and fmt.len < max_log_message - 1);
    var buf: [max_log_message]u8 = undefined;
    const message = std.fmt.bufPrintSentinel(&buf, fmt, args, 0) catch |err| switch (err) {
        std.fmt.BufPrintError.NoSpaceLeft => {
            SDL_LogError(
                @backingInt(LogCategory.assert),
                "(log message exceeded %d characters)",
                @as(u32, max_log_message),
            );
            return;
        },
    };
    SDL_LogTrace(@backingInt(category), @ptrCast(message.ptr));
}
extern fn SDL_LogTrace(category: c_int, fmt: [*c]const u8, ...) void;

/// Log a message with SDL_LOG_PRIORITY_VERBOSE.
pub fn logVerbose(category: LogCategory, comptime fmt: []const u8, args: anytype) void {
    assert(fmt.len > 0 and fmt.len < max_log_message - 1);
    var buf: [max_log_message]u8 = undefined;
    const message = std.fmt.bufPrintSentinel(&buf, fmt, args, 0) catch |err| switch (err) {
        std.fmt.BufPrintError.NoSpaceLeft => {
            SDL_LogError(
                @backingInt(LogCategory.assert),
                "(log message exceeded %d characters)",
                @as(u32, max_log_message),
            );
            return;
        },
    };
    SDL_LogVerbose(@backingInt(category), @ptrCast(message.ptr));
}
extern fn SDL_LogVerbose(category: c_int, fmt: [*c]const u8, ...) void;

/// Log a message with SDL_LOG_PRIORITY_DEBUG.
pub fn logDebug(category: LogCategory, comptime fmt: []const u8, args: anytype) void {
    assert(fmt.len > 0 and fmt.len < max_log_message - 1);
    var buf: [max_log_message]u8 = undefined;
    const message = std.fmt.bufPrintSentinel(&buf, fmt, args, 0) catch |err| switch (err) {
        std.fmt.BufPrintError.NoSpaceLeft => {
            SDL_LogError(
                @backingInt(LogCategory.assert),
                "(log message exceeded %d characters)",
                @as(u32, max_log_message),
            );
            return;
        },
    };
    SDL_LogDebug(@backingInt(category), @ptrCast(message.ptr));
}
extern fn SDL_LogDebug(category: c_int, fmt: [*c]const u8, ...) void;

/// Log a message with SDL_LOG_PRIORITY_INFO.
pub fn logInfo(category: LogCategory, comptime fmt: []const u8, args: anytype) void {
    assert(fmt.len > 0 and fmt.len < max_log_message - 1);
    var buf: [max_log_message]u8 = undefined;
    const message = std.fmt.bufPrintSentinel(&buf, fmt, args, 0) catch |err| switch (err) {
        std.fmt.BufPrintError.NoSpaceLeft => {
            SDL_LogError(
                @backingInt(LogCategory.assert),
                "(log message exceeded %d characters)",
                @as(u32, max_log_message),
            );
            return;
        },
    };
    SDL_LogInfo(@backingInt(category), @ptrCast(message.ptr));
}
extern fn SDL_LogInfo(category: c_int, fmt: [*c]const u8, ...) void;

/// Log a message with SDL_LOG_PRIORITY_WARN.
pub fn logWarn(category: LogCategory, comptime fmt: []const u8, args: anytype) void {
    assert(fmt.len > 0 and fmt.len < max_log_message - 1);
    var buf: [max_log_message]u8 = undefined;
    const message = std.fmt.bufPrintSentinel(&buf, fmt, args, 0) catch |err| switch (err) {
        std.fmt.BufPrintError.NoSpaceLeft => {
            SDL_LogError(
                @backingInt(LogCategory.assert),
                "(log message exceeded %d characters)",
                @as(u32, max_log_message),
            );
            return;
        },
    };
    SDL_LogWarn(@backingInt(category), @ptrCast(message.ptr));
}
extern fn SDL_LogWarn(category: c_int, fmt: [*c]const u8, ...) void;

/// Log a message with SDL_LOG_PRIORITY_ERROR.
pub fn logError(category: LogCategory, comptime fmt: []const u8, args: anytype) void {
    assert(fmt.len > 0 and fmt.len < max_log_message - 1);
    var buf: [max_log_message]u8 = undefined;
    const message = std.fmt.bufPrintSentinel(&buf, fmt, args, 0) catch |err| switch (err) {
        std.fmt.BufPrintError.NoSpaceLeft => {
            SDL_LogError(
                @backingInt(LogCategory.assert),
                "(log message exceeded %d characters)",
                @as(u32, max_log_message),
            );
            return;
        },
    };
    SDL_LogError(@backingInt(category), @ptrCast(message.ptr));
}
extern fn SDL_LogError(category: c_int, fmt: [*c]const u8, ...) void;

/// Log a message with SDL_LOG_PRIORITY_CRITICAL.
pub fn logCritical(category: LogCategory, comptime fmt: []const u8, args: anytype) void {
    assert(fmt.len > 0 and fmt.len < max_log_message - 1);
    var buf: [max_log_message]u8 = undefined;
    const message = std.fmt.bufPrintSentinel(&buf, fmt, args, 0) catch |err| switch (err) {
        std.fmt.BufPrintError.NoSpaceLeft => {
            SDL_LogError(
                @backingInt(LogCategory.assert),
                "(log message exceeded %d characters)",
                @as(u32, max_log_message),
            );
            return;
        },
    };
    SDL_LogCritical(@backingInt(category), @ptrCast(message.ptr));
}
extern fn SDL_LogCritical(category: c_int, fmt: [*c]const u8, ...) void;

/// Log a message with the specified category and priority.
pub fn logMessage(category: LogCategory, priority: LogPriority, comptime fmt: []const u8, args: anytype) void {
    assert(fmt.len > 0 and fmt.len < max_log_message - 1);
    var buf: [max_log_message]u8 = undefined;
    const message = std.fmt.bufPrintSentinel(&buf, fmt, args, 0) catch |err| switch (err) {
        std.fmt.BufPrintError.NoSpaceLeft => {
            SDL_LogError(
                @backingInt(LogCategory.assert),
                "(log message exceeded %d characters)",
                @as(u32, max_log_message),
            );
            return;
        },
    };
    SDL_LogMessage(@backingInt(category), priority, @ptrCast(message.ptr));
}
extern fn SDL_LogMessage(category: c_int, priority: LogPriority, fmt: [*c]const u8, ...) void;

/// The prototype for the log output callback function.
///
/// This function is called by SDL when there is new text to be logged. A mutex
/// is held so that this function is never called by more than one thread at
/// once.
pub const LogOutputFunction = *const fn (
    userdata: ?*anyopaque,
    category: c_int,
    priority: LogPriority,
    message: [*c]const u8,
) callconv(.c) void;

/// Get the default log output function.
pub const getDefaultLogOutputFunction = SDL_GetDefaultLogOutputFunction;
extern fn SDL_GetDefaultLogOutputFunction() LogOutputFunction;

/// Get the current log output function.
pub fn getLogOutputFunction(callback: *LogOutputFunction, userdata: *?*anyopaque) void {
    SDL_GetLogOutputFunction(callback, userdata);
}
extern fn SDL_GetLogOutputFunction(callback: *LogOutputFunction, userdata: *?*anyopaque) void;

/// Replace the default log output function with one of your own.
pub fn setLogOutputFunction(callback: LogOutputFunction, userdata: ?*anyopaque) void {
    SDL_SetLogOutputFunction(callback, userdata);
}
extern fn SDL_SetLogOutputFunction(callback: LogOutputFunction, userdata: ?*anyopaque) void;
