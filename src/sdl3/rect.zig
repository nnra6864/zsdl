//! Rectangle Functions (SDL_rect.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

pub const Rect = extern struct {
    x: c_int,
    y: c_int,
    w: c_int,
    h: c_int,

    pub fn hasIntersection(a: *const Rect, b: *const Rect) bool {
        return hasRectIntersection(a, b);
    }

    pub fn getIntersection(a: *const Rect, b: *const Rect, result: *Rect) bool {
        return getRectIntersection(a, b, result);
    }

    pub fn getLineIntersection(rect: *const Rect, x1: *i32, y1: *i32, x2: *i32, y2: *i32) bool {
        return getRectAndLineIntersection(rect, x1, y1, x2, y2);
    }
};

pub const hasRectIntersection = SDL_HasRectIntersection;
extern fn SDL_HasRectIntersection(a: *const Rect, b: *const Rect) bool;

pub const getRectIntersection = SDL_GetRectIntersection;
extern fn SDL_GetRectIntersection(a: *const Rect, b: *const Rect, result: *Rect) bool;

pub const getRectAndLineIntersection = SDL_GetRectAndLineIntersection;
extern fn SDL_GetRectAndLineIntersection(
    r: *const Rect,
    x1: *c_int,
    y1: *c_int,
    x2: *c_int,
    y2: *c_int,
) bool;

pub const FRect = extern struct {
    x: f32,
    y: f32,
    w: f32,
    h: f32,

    pub fn hasIntersection(a: *const FRect, b: *const FRect) bool {
        return hasRectIntersectionFloat(a, b);
    }

    pub fn getRectIntersecton(a: *const FRect, b: *const FRect, result: *FRect) bool {
        return getRectIntersectionFloat(a, b, result);
    }

    pub fn getLineIntersection(rect: *const FRect, x1: *f32, y1: *f32, x2: *f32, y2: *f32) bool {
        return getRectAndLineIntersectionFloat(rect, x1, y1, x2, y2);
    }
};

pub const hasRectIntersectionFloat = SDL_HasRectIntersectionFloat;
extern fn SDL_HasRectIntersectionFloat(a: *const FRect, b: *const FRect) bool;

pub const getRectIntersectionFloat = SDL_GetRectIntersectionFloat;
extern fn SDL_GetRectIntersectionFloat(a: *const FRect, b: *const FRect, result: *FRect) bool;

pub const getRectAndLineIntersectionFloat = SDL_GetRectAndLineIntersectionFloat;
extern fn SDL_GetRectAndLineIntersectionFloat(
    r: *const FRect,
    x1: *f32,
    y1: *f32,
    x2: *f32,
    y2: *f32,
) bool;

pub const Point = extern struct {
    x: c_int,
    y: c_int,
};

pub const FPoint = extern struct {
    x: f32,
    y: f32,
};
