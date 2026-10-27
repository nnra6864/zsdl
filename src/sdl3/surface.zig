//! Surface Creation and Simple Drawing (SDL_surface.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

pub const ScaleMode = enum(c_int) {
    nearest = 0x0000,
    linear = 0x0001,
    best = 0x0002,
};

pub const Surface = opaque {
    pub const Flags = packed struct(u32) {
        /// Surface uses preallocatred pixel memory
        preallocated: bool = false,
        /// Surface needs to be locked to access pixels
        lock_needed: bool = false,
        /// Surface is currently locked
        locked: bool = false,
        /// Surface used pixel memory allocated wth SDL_aliged_alloc()
        simd_aligned: bool = false,
        _: u28 = 0,
    };

    pub const ScaleMode = enum(c_int) {
        nearest,
        linear,
    };

    pub const FlipMode = enum(c_int) {
        none,
        horizontal,
        vertical,
    };

    pub const destroy = destroySurface;
};

// TODO:
// - SDL_CreateSurface
// - SDL_CreateSurfaceFrom

pub fn destroySurface(surface: *Surface) void {
    SDL_DestroySurface(surface);
}
extern fn SDL_DestroySurface(surface: *Surface) void;

// TODO:
// - SDL_GetSurfaceProperties
// - SDL_SetSurfaceColorspace
// - SDL_GetSurfaceColorspace
// - SDL_CreateSurfacePalette
// - SDL_SetSurfacePalette
// - SDL_GetSurfacePalette
// - SDL_AddSurfaceAlternateImage
// - SDL_SurfaceHasAlternateImages
// - SDL_GetSurfaceImages
// - SDL_RemoveSurfaceAlternateImages
// - SDL_LockSurface
// - SDL_UnlockSurface
// - SDL_LoadBMP_IO
// - SDL_LoadBMP
// - SDL_SaveBMP_IO
// - SDL_SaveBMP
// - SDL_SetSurfaceRLE
// - SDL_SurfaceHasRLE
// - SDL_SetSurfaceColorKey
// - SDL_SurfaceHasColorKey
// - SDL_GetSurfaceColorKey
// - SDL_SetSurfaceColorMod
// - SDL_GetSurfaceColorMod
// - SDL_SetSurfaceAlphaMod
// - SDL_GetSurfaceAlphaMod
// - SDL_SetSurfaceBlendMode
// - SDL_GetSurfaceBlendMode
// - SDL_SetSurfaceClipRect
// - SDL_GetSurfaceClipRect
// - SDL_FlipSurface
// - SDL_DuplicateSurface
// - SDL_ScaleSurface
// - SDL_ConvertSurface
// - SDL_ConvertSurfaceAndColorspace
// - SDL_ConvertPixels
// - SDL_ConvertPixelsAndColorspace
// - SDL_PremultiplyAlpha
// - SDL_PremultiplySurfaceAlpha
// - SDL_ClearSurface
// - SDL_FillSurfaceRect
// - SDL_FillSurfaceRects
// - SDL_BlitSurface
// - SDL_BlitSurfaceUnchecked
// - SDL_BlitSurfaceScaled
// - SDL_BlitSurfaceUncheckedScaled
// - SDL_StretchSurface
// - SDL_BlitSurfaceTiled
// - SDL_BlitSurfaceTiledWithScale
// - SDL_BlitSurface9Grid
// - SDL_MapSurfaceRGB
// - SDL_MapSurfaceRGBA
// - SDL_ReadSurfacePixel
// - SDL_ReadSurfacePixelFloat
// - SDL_WriteSurfacePixel
// - SDL_WriteSurfacePixelFloat
