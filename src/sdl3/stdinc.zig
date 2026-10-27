//! Standard Library Functionality (SDL_stdinc.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

/// Allocate uinitialized memory.
///
/// The allocated memory returned by this function must be freed with SDL_free().
///
/// If `size` is 0, it will be set to 1.
///
/// If you want to allocate memory aligned to a specific alignment, consider using SDL_aligned_alloc().
///
/// Returns a pointer to the allocated memory, or NULL if allocation failed.
pub const malloc = SDL_malloc;
extern fn SDL_malloc(isize) *anyopaque;

/// Free allocated memory.
/// The pointer is no longer valid after this call and cannot be dereferenced  anymore.
pub const free = SDL_free;
extern fn SDL_free(*anyopaque) void;

// TODO
// - Declare SDL_malloc_func, SDL_calloc_func, SDL_realloc_func and SDL_free_func
// - Zig Allocator interface

/// SDL times are signed, 64-bit integers representing nanoseconds since the
/// Unix epoch (Jan 1, 1970).
///
/// They can be converted between POSIX time_t values with `nsToSeconds` and
/// `secondsToNS`, and between Windows FILETIME values with `timeToWindows`
/// and `timeFromWindows`.
pub const Time = i64;
pub const max_time: Time = std.math.maxInt(i64);
pub const min_time: Time = std.math.minInt(i64);
