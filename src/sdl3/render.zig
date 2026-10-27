//! 2D Accelerated Rendering (SDL_render.h)

const std = @import("std");
const assert = std.debug.assert;

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

pub const Vertex = extern struct {
    position: sdl.FPoint,
    color: sdl.FColor,
    tex_coord: sdl.FPoint,
};

pub const TextureAccess = enum(c_int) {
    static,
    streaming,
    target,
};

pub const RendererLogicalPresentationMode = enum(c_int) {
    disabled,
    stretch,
    letterbox,
    overscan,
    integer_scale,
};

pub const Texture = opaque {
    pub const destroy = destroyTexture;
    pub const lock = lockTexture;
    pub const unlock = unlockTexture;
};

pub const destroyTexture = SDL_DestroyTexture;
extern fn SDL_DestroyTexture(texture: ?*Texture) void;

pub fn lockTexture(texture: *Texture, rect: ?*sdl.Rect) !struct {
    pixels: [*]u8,
    pitch: c_int,
} {
    var pixels: *anyopaque = undefined;
    var pitch: c_int = undefined;
    if (!SDL_LockTexture(texture, rect, &pixels, &pitch)) {
        return makeError();
    }
    return .{
        .pixels = @ptrCast(pixels),
        .pitch = pitch,
    };
}
extern fn SDL_LockTexture(
    texture: *Texture,
    rect: ?*sdl.Rect,
    pixels: **anyopaque,
    pitch: *c_int,
) bool;

pub const unlockTexture = SDL_UnlockTexture;
extern fn SDL_UnlockTexture(texture: *Texture) void;

pub const Renderer = opaque {
    pub const Flags = packed struct(u32) {
        software: bool = false,
        accelerated: bool = false,
        present_vsync: bool = false,
        _: u29 = 0,
    };

    pub const create = createRenderer;
    pub const destroy = destroyRenderer;
    pub const present = renderPresent;
    pub const debugText = renderDebugText;
};

/// Get the number of 2D rendering drivers available for the current display.
///
/// A render driver is a set of code that handles rendering and texture
/// management on a particular display. Normally there is only one, but some
/// drivers may have several available with different capabilities.
///
/// There may be none if SDL was compiled without render support.
pub const getNumRenderDrivers = SDL_GetNumRenderDrivers;
extern fn SDL_GetNumRenderDrivers() c_int;

/// Use this function to get the name of a built in 2D rendering driver.
///
/// The list of rendering drivers is given in the order that they are normally
/// initialized by default; the drivers that seem more reasonable to choose
/// first (as far as the SDL developers believe) are earlier in the list.
///
/// The names of drivers are all simple, low-ASCII identifiers, like "opengl",
/// "direct3d12" or "metal". These never have Unicode characters, and are not
/// meant to be proper names.
pub fn getRenderDriver(index: c_int) ?[:0]const u8 {
    if (SDL_GetRenderDriver(index)) |ptr| {
        return std.mem.span(ptr);
    }
    return null;
}
extern fn SDL_GetRenderDriver(index: c_int) [*c]const u8;

/// Create a window and default renderer.
pub fn createWindowAndRenderer(
    window_title: [:0]const u8,
    width: c_int,
    height: c_int,
    window_flags: sdl.Window.Flags,
    window: **sdl.Window,
    renderer: **Renderer,
) Error!void {
    assert(width > 0);
    assert(height > 0);
    if (!SDL_CreateWindowAndRenderer(
        @ptrCast(window_title.ptr),
        width,
        height,
        window_flags,
        @ptrCast(window),
        @ptrCast(renderer),
    )) {
        return makeError();
    }
}
extern fn SDL_CreateWindowAndRenderer(
    title: [*c]const u8,
    width: c_int,
    height: c_int,
    window_flags: sdl.Window.Flags,
    window: ?*?*sdl.Window,
    renderer: ?*?*Renderer,
) bool;

/// Create a 2D rendering context for a window.
///
/// If you want a specific renderer, you can specify its name here. A list of
/// available renderers can be obtained by calling SDL_GetRenderDriver()
/// multiple times, with indices from 0 to SDL_GetNumRenderDrivers()-1. If you
/// don't need a specific renderer, specify NULL and SDL will attempt to choose
/// the best option for you, based on what is available on the user's system.
///
/// If `name` is a comma-separated list, SDL will try each name, in the order
/// listed, until one succeeds or all of them fail.
///
/// By default the rendering size matches the window size in pixels, but you
/// can call SDL_SetRenderLogicalPresentation() to change the content size and
/// scaling options.
pub fn createRenderer(window: *sdl.Window, maybe_name: ?[:0]const u8) Error!*Renderer {
    return SDL_CreateRenderer(
        window,
        if (maybe_name) |name| @as([*c]const u8, @ptrCast(name.ptr)) else null,
    ) orelse makeError();
}
extern fn SDL_CreateRenderer(window: *sdl.Window, name: [*c]const u8) ?*Renderer;

// TODO

pub const destroyRenderer = SDL_DestroyRenderer;
extern fn SDL_DestroyRenderer(r: *Renderer) void;

pub fn renderClear(r: *Renderer) !void {
    if (!SDL_RenderClear(r)) return makeError();
}
extern fn SDL_RenderClear(r: *Renderer) bool;

pub const renderPresent = SDL_RenderPresent;
extern fn SDL_RenderPresent(r: *Renderer) void;

pub fn renderTexture(
    r: *Renderer,
    tex: *Texture,
    src: ?*const sdl.FRect,
    dst: ?*const sdl.FRect,
) Error!void {
    if (!SDL_RenderTexture(r, tex, src, dst)) {
        return makeError();
    }
}
extern fn SDL_RenderTexture(
    r: *Renderer,
    t: *Texture,
    srcrect: ?*const sdl.FRect,
    dstrect: ?*const sdl.FRect,
) bool;

pub fn renderTextureRotated(
    r: *Renderer,
    tex: *Texture,
    src: ?*const sdl.FRect,
    dst: ?*const sdl.FRect,
    angle: f64,
    center: ?*const sdl.FPoint,
    flip: sdl.Surface.FlipMode,
) Error!void {
    if (!SDL_RenderTextureRotated(r, tex, src, dst, angle, center, flip)) {
        return makeError();
    }
}
extern fn SDL_RenderTextureRotated(
    r: *Renderer,
    t: *Texture,
    srcrect: ?*const sdl.FRect,
    dstrect: ?*const sdl.FRect,
    angle: f64,
    center: ?*const sdl.FPoint,
    flip: sdl.Surface.FlipMode,
) bool;

pub fn setRenderScale(renderer: *Renderer, x: f32, y: f32) Error!void {
    if (!SDL_SetRenderScale(renderer, x, y)) return makeError();
}
extern fn SDL_SetRenderScale(renderer: *Renderer, scaleX: f32, scaleY: f32) bool;

pub fn renderLine(renderer: *Renderer, x0: f32, y0: f32, x1: f32, y1: f32) Error!void {
    if (!SDL_RenderLine(renderer, x0, y0, x1, y1)) return makeError();
}
extern fn SDL_RenderLine(renderer: *Renderer, x1: f32, y1: f32, x2: f32, y2: f32) bool;

pub fn renderPoint(renderer: *Renderer, x: f32, y: f32) Error!void {
    if (!SDL_RenderPoint(renderer, x, y)) return makeError();
}
extern fn SDL_RenderPoint(renderer: *Renderer, x: f32, y: f32) bool;

pub fn renderFillRect(renderer: *Renderer, _rect: sdl.FRect) Error!void {
    if (!SDL_RenderFillRect(renderer, &_rect)) return makeError();
}
extern fn SDL_RenderFillRect(renderer: ?*Renderer, rect: *const sdl.FRect) bool;

pub fn renderRect(renderer: *Renderer, _rect: sdl.FRect) Error!void {
    if (!SDL_RenderRect(renderer, &_rect)) return makeError();
}
extern fn SDL_RenderRect(renderer: *Renderer, rect: *const sdl.FRect) bool;

pub fn renderGeometry(
    r: *Renderer,
    tex: ?*const Texture,
    vertices: []const Vertex,
    maybe_indices: ?[]const c_int,
) Error!void {
    if (!SDL_RenderGeometry(
        r,
        tex,
        vertices.ptr,
        @intCast(vertices.len),
        if (maybe_indices) |indices| indices.ptr else null,
        if (maybe_indices) |indices| @intCast(indices.len) else 0,
    )) {
        return makeError();
    }
}
extern fn SDL_RenderGeometry(
    renderer: *Renderer,
    texture: ?*const Texture,
    vertices: [*c]const Vertex,
    num_vertices: c_int,
    indices: [*c]const c_int,
    num_indices: c_int,
) bool;

pub fn setRenderDrawColor(renderer: *Renderer, color: sdl.Color) Error!void {
    if (!SDL_SetRenderDrawColor(renderer, color.r, color.g, color.b, color.a)) {
        return makeError();
    }
}
extern fn SDL_SetRenderDrawColor(renderer: *Renderer, r: u8, g: u8, b: u8, a: u8) bool;

pub fn getRenderDrawColor(renderer: *const Renderer) Error!sdl.Color {
    var color: sdl.Color = undefined;
    if (!SDL_GetRenderDrawColor(renderer, &color.r, &color.g, &color.b, &color.a)) {
        return makeError();
    }
    return color;
}
extern fn SDL_GetRenderDrawColor(renderer: *const Renderer, r: *u8, g: *u8, b: *u8, a: *u8) bool;

pub fn getRenderDrawBlendMode(r: *const Renderer) Error!sdl.BlendMode {
    var blend_mode: sdl.BlendMode = undefined;
    if (!SDL_GetRenderDrawBlendMode(r, &blend_mode)) return makeError();
    return blend_mode;
}
extern fn SDL_GetRenderDrawBlendMode(renderer: *const Renderer, blendMode: *sdl.BlendMode) bool;

pub fn setRenderDrawBlendMode(r: *Renderer, blend_mode: sdl.BlendMode) Error!void {
    if (!SDL_SetRenderDrawBlendMode(r, blend_mode)) return makeError();
}
extern fn SDL_SetRenderDrawBlendMode(renderer: *Renderer, blendMode: sdl.BlendMode) bool;

pub fn getCurrentRenderOutputSize(r: *const Renderer, w: ?*c_int, h: ?*c_int) Error!void {
    if (!SDL_GetCurrentRenderOutputSize(r, w, h)) return makeError();
}
extern fn SDL_GetCurrentRenderOutputSize(renderer: *const Renderer, w: ?*c_int, h: ?*c_int) bool;

pub fn createTexture(
    renderer: *Renderer,
    format: sdl.PixelFormat,
    access: TextureAccess,
    width: c_int,
    height: c_int,
) Error!*Texture {
    assert(width > 0);
    assert(height > 0);
    return SDL_CreateTexture(renderer, format, access, width, height) orelse makeError();
}
extern fn SDL_CreateTexture(
    renderer: *Renderer,
    format: sdl.PixelFormat,
    access: TextureAccess,
    w: c_int,
    h: c_int,
) ?*Texture;

pub fn createTextureFromSurface(renderer: *Renderer, surface: *sdl.Surface) Error!*Texture {
    return SDL_CreateTextureFromSurface(renderer, surface) orelse makeError();
}
extern fn SDL_CreateTextureFromSurface(renderer: *Renderer, surface: *sdl.Surface) ?*Texture;

pub const renderClipEnabled = SDL_RenderClipEnabled;
extern fn SDL_RenderClipEnabled(renderer: *const Renderer) bool;

pub fn setRenderClipRect(r: *Renderer, clip_rect: ?*const sdl.Rect) Error!void {
    if (!SDL_SetRenderClipRect(r, clip_rect)) return makeError();
}
extern fn SDL_SetRenderClipRect(renderer: *Renderer, rect: ?*const sdl.Rect) bool;

pub fn getRenderClipRect(r: *Renderer) Error!sdl.Rect {
    var clip_rect: sdl.Rect = undefined;
    if (!SDL_GetRenderClipRect(r, &clip_rect)) return makeError();
    return clip_rect;
}
extern fn SDL_GetRenderClipRect(renderer: *Renderer, rect: ?*sdl.Rect) bool;

pub fn getRenderLogicalPresentation(
    renderer: *const Renderer,
    w: *c_int,
    h: *c_int,
    mode: *RendererLogicalPresentationMode,
    scale_mode: *sdl.ScaleMode,
) Error!void {
    if (!SDL_GetRenderLogicalPresentation(renderer, w, h, mode, scale_mode)) {
        return makeError();
    }
}
extern fn SDL_GetRenderLogicalPresentation(
    renderer: *const Renderer,
    w: *c_int,
    h: *c_int,
    mode: *RendererLogicalPresentationMode,
    scale_mode: *sdl.ScaleMode,
) bool;

pub fn setRenderLogicalPresentation(
    renderer: *Renderer,
    w: c_int,
    h: c_int,
    mode: RendererLogicalPresentationMode,
    scale_mode: sdl.ScaleMode,
) Error!void {
    if (!SDL_SetRenderLogicalPresentation(renderer, w, h, mode, scale_mode)) {
        return makeError();
    }
}
extern fn SDL_SetRenderLogicalPresentation(
    renderer: *Renderer,
    w: c_int,
    h: c_int,
    mode: RendererLogicalPresentationMode,
    scale_mode: sdl.ScaleMode,
) bool;

pub fn getRenderViewport(renderer: *const Renderer) Error!sdl.Rect {
    var viewport: sdl.Rect = undefined;
    if (SDL_GetRenderViewport(renderer, &viewport)) {
        return viewport;
    } else {
        return makeError();
    }
}
extern fn SDL_GetRenderViewport(renderer: *const Renderer, rect: *sdl.Rect) bool;

pub fn setRenderViewport(renderer: *Renderer, maybe_rect: ?*const sdl.Rect) Error!void {
    if (!SDL_SetRenderViewport(renderer, maybe_rect)) {
        return makeError();
    }
}
extern fn SDL_SetRenderViewport(renderer: *Renderer, rect: ?*const sdl.Rect) bool;

pub fn setRenderTarget(r: *Renderer, tex: ?*const Texture) Error!void {
    if (!SDL_SetRenderTarget(r, tex)) return makeError();
}
extern fn SDL_SetRenderTarget(renderer: *Renderer, texture: ?*const Texture) bool;

pub fn renderReadPixels(
    renderer: *const Renderer,
    _rect: ?*const sdl.Rect,
    format: sdl.PixelFormat,
    pixels: [*]u8,
    pitch: c_int,
) Error!void {
    if (!SDL_RenderReadPixels(renderer, _rect, format, pixels, pitch)) {
        return makeError();
    }
}
extern fn SDL_RenderReadPixels(
    renderer: *const Renderer,
    rect: ?*const sdl.Rect,
    format: sdl.PixelFormat,
    pixels: ?*anyopaque,
    pitch: c_int,
) bool;

pub fn renderDebugText(renderer: *Renderer, x: f32, y: f32, str: [:0]const u8) Error!void {
    if (!SDL_RenderDebugText(renderer, x, y, @ptrCast(str.ptr))) return makeError();
}
extern fn SDL_RenderDebugText(renderer: *Renderer, x: f32, y: f32, str: [*c]const u8) bool;
