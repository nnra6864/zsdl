//! Pixel Formats and Conversion Routines (SDL_pixels.h)

const std = @import("std");
const assert = std.debug.assert;

const sdl = @import("../sdl3.zig");

pub const ALPHA_OPAQUE: u8 = 255;
pub const ALPHA_OPAQUE_FLOAT: f32 = 1.0;
pub const ALPHA_TRANSPARENT: u8 = 0;
pub const ALPHA_TRANSPARENT_FLOAT: f32 = 0.0;

pub const PixelType = enum(c_int) {
    unknown = 0,
    index1,
    index4,
    index8,
    packed8,
    packed16,
    packed32,
    arrayu8,
    arrayu16,
    arrayu32,
    arrayf16,
    arrayf32,
    // appended at end for compatibility with sdl2-compat
    index2,
};

/// Bitmap pixel order, high bit -> low bit.
pub const BitmapOrder = enum(c_int) {
    none = 0,
    @"4321",
    @"1234",
};

/// Packed component order, high bit -> low bit.
pub const PackedOrder = enum(c_int) {
    none = 0,
    xrgb,
    rgbx,
    argb,
    rgba,
    xbgr,
    bgrx,
    abgr,
    bgra,
};

/// Array component order, low byte -> high byte.
pub const ArrayOrder = enum(c_int) {
    none = 0,
    rgb,
    rgba,
    argb,
    bgr,
    bgra,
    abgr,
};

/// Packed component layout.
pub const PackedLayout = enum(c_int) {
    none = 0,
    @"332",
    @"4444",
    @"1555",
    @"5551",
    @"565",
    @"8888",
    @"2101010",
    @"1010102",
};

fn definePixelFormat(
    _type: PixelType,
    order: anytype,
    layout: u32,
    bits: u32,
    bytes: u32,
) u32 {
    switch (_type) {
        .index1, .index2, .index4, .index8 => {
            assert(@TypeOf(order) == BitmapOrder);
        },
        .packed8, .packed16, .packed32 => {
            assert(@TypeOf(order) == PackedOrder);
        },
        .arrayu8, .arrayu16, .arrayu32, .arrayf16, .arrayf32 => {
            assert(@TypeOf(order) == ArrayOrder);
        },
        .unknown => unreachable,
    }
    return ((1 << 28) | ((@backingInt(_type)) << 24) | ((@backingInt(order)) << 20) |
        ((layout) << 16) | ((bits) << 8) | ((bytes) << 0));
}

/// SDL's pixel formats have the following naming convention:
///
/// - Names with a list of components and a single bit count, such as RGB24 and
///   ABGR32, define a platform-independent encoding into bytes in the order
///   specified. For example, in RGB24 data, each pixel is encoded in 3 bytes
///   (red, green, blue) in that order, and in ABGR32 data, each pixel is
///   encoded in 4 bytes alpha, blue, green, red) in that order. Use these
///   names if the property of a format that is important to you is the order
///   of the bytes in memory or on disk.
/// - Names with a bit count per component, such as ARGB8888 and XRGB1555, are
///   "packed" into an appropriately-sized integer in the platform's native
///   endianness. For example, ARGB8888 is a sequence of 32-bit integers; in
///   each integer, the most significant bits are alpha, and the least
///   significant bits are blue. On a little-endian CPU such as x86, the least
///   significant bits of each integer are arranged first in memory, but on a
///   big-endian CPU such as s390x, the most significant bits are arranged
///   first. Use these names if the property of a format that is important to
///   you is the meaning of each bit position within a native-endianness
///   integer.
/// - In indexed formats such as INDEX4LSB, each pixel is represented by
///   encoding an index into the palette into the indicated number of bits,
///   with multiple pixels packed into each byte if appropriate. In LSB
///   formats, the first (leftmost) pixel is stored in the least-significant
///   bits of the byte; in MSB formats, it's stored in the most-significant
///   bits. INDEX8 does not need LSB/MSB variants, because each pixel exactly
///   fills one byte.
///
/// The 32-bit byte-array encodings such as RGBA32 are aliases for the
/// appropriate 8888 encoding for the current platform. For example, RGBA32 is
/// an alias for ABGR8888 on little-endian CPUs like x86, or an alias for
/// RGBA8888 on big-endian CPUs.
pub const PixelFormat = enum(u32) {
    index1lsb = definePixelFormat(.index1, BitmapOrder.@"4321", 0, 1, 0),
    index1msb = definePixelFormat(.index1, BitmapOrder.@"1234", 0, 1, 0),
    index4lsb = definePixelFormat(.index4, BitmapOrder.@"4321", 0, 4, 0),
    index4msb = definePixelFormat(.index4, BitmapOrder.@"1234", 0, 4, 0),
    index8 = definePixelFormat(.index8, BitmapOrder.none, 0, 8, 1),
    rgb332 = definePixelFormat(.packed8, PackedOrder.xrgb, @backingInt(PackedLayout.@"332"), 8, 1),
    xrgb4444 = definePixelFormat(.packed16, PackedOrder.xrgb, @backingInt(PackedLayout.@"4444"), 12, 2),
    xbgr4444 = definePixelFormat(.packed16, PackedOrder.xbgr, @backingInt(PackedLayout.@"4444"), 12, 2),
    xrgb1555 = definePixelFormat(.packed16, PackedOrder.xrgb, @backingInt(PackedLayout.@"1555"), 15, 2),
    xbgr1555 = definePixelFormat(.packed16, PackedOrder.xbgr, @backingInt(PackedLayout.@"1555"), 15, 2),
    argb4444 = definePixelFormat(.packed16, PackedOrder.argb, @backingInt(PackedLayout.@"4444"), 16, 2),
    rgba4444 = definePixelFormat(.packed16, PackedOrder.rgba, @backingInt(PackedLayout.@"4444"), 16, 2),
    abgr4444 = definePixelFormat(.packed16, PackedOrder.abgr, @backingInt(PackedLayout.@"4444"), 16, 2),
    bgra4444 = definePixelFormat(.packed16, PackedOrder.bgra, @backingInt(PackedLayout.@"4444"), 16, 2),
    argb1555 = definePixelFormat(.packed16, PackedOrder.argb, @backingInt(PackedLayout.@"1555"), 16, 2),
    rgba5551 = definePixelFormat(.packed16, PackedOrder.rgba, @backingInt(PackedLayout.@"5551"), 16, 2),
    abgr1555 = definePixelFormat(.packed16, PackedOrder.abgr, @backingInt(PackedLayout.@"1555"), 16, 2),
    bgra5551 = definePixelFormat(.packed16, PackedOrder.bgra, @backingInt(PackedLayout.@"5551"), 16, 2),
    rgb565 = definePixelFormat(.packed16, PackedOrder.xrgb, @backingInt(PackedLayout.@"565"), 16, 2),
    bgr565 = definePixelFormat(.packed16, PackedOrder.xbgr, @backingInt(PackedLayout.@"565"), 16, 2),
    rgb24 = definePixelFormat(.arrayu8, ArrayOrder.rgb, 0, 24, 3),
    bgr24 = definePixelFormat(.arrayu8, ArrayOrder.bgr, 0, 24, 3),
    xrgb8888 = definePixelFormat(.packed32, PackedOrder.xrgb, @backingInt(PackedLayout.@"8888"), 24, 4),
    rgbx8888 = definePixelFormat(.packed32, PackedOrder.rgbx, @backingInt(PackedLayout.@"8888"), 24, 4),
    xbgr8888 = definePixelFormat(.packed32, PackedOrder.xbgr, @backingInt(PackedLayout.@"8888"), 24, 4),
    bgrx8888 = definePixelFormat(.packed32, PackedOrder.bgrx, @backingInt(PackedLayout.@"8888"), 24, 4),
    argb8888 = definePixelFormat(.packed32, PackedOrder.argb, @backingInt(PackedLayout.@"8888"), 32, 4),
    rgba8888 = definePixelFormat(.packed32, PackedOrder.rgba, @backingInt(PackedLayout.@"8888"), 32, 4),
    abgr8888 = definePixelFormat(.packed32, PackedOrder.abgr, @backingInt(PackedLayout.@"8888"), 32, 4),
    bgra8888 = definePixelFormat(.packed32, PackedOrder.bgra, @backingInt(PackedLayout.@"8888"), 32, 4),
    argb2101010 = definePixelFormat(.packed32, PackedOrder.argb, @backingInt(PackedLayout.@"2101010"), 32, 4),
};

pub const Color = extern struct {
    r: u8,
    g: u8,
    b: u8,
    a: u8,
};

pub const FColor = extern struct {
    r: f32,
    g: f32,
    b: f32,
    a: f32,
};
