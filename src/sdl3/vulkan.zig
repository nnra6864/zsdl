//! Vulkan Support (SDL_vulkan.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

pub const vk = struct {
    pub const FunctionPointer = ?*const anyopaque;
    pub const Instance = enum(usize) { null_handle = 0, _ };
    pub const PhysicalDevice = enum(usize) { null_handle = 0, _ };
    pub const SurfaceKHR = enum(usize) { null_handle = 0, _ };

    pub fn loadLibrary(path: [:0]const u8) Error!void {
        if (!SDL_Vulkan_LoadLibrary(@ptrCast(path.ptr))) return makeError();
    }
    extern fn SDL_Vulkan_LoadLibrary(path: [*c]const u8) bool;

    pub const getVkGetInstanceProcAddr = SDL_Vulkan_GetVkGetInstanceProcAddr;
    extern fn SDL_Vulkan_GetVkGetInstanceProcAddr() FunctionPointer;

    pub const unloadLibrary = SDL_Vulkan_UnloadLibrary;
    extern fn SDL_Vulkan_UnloadLibrary() void;

    pub const getInstanceExtensions = SDL_Vulkan_GetInstanceExtensions;
    extern fn SDL_Vulkan_GetInstanceExtensions(count: *u32) [*c]const [*c]const u8;

    pub const getPresentationSupport = SDL_Vulkan_GetPresentationSupport;
    extern fn SDL_Vulkan_GetPresentationSupport(instance: Instance, physical_device: PhysicalDevice, queue_family_index: u32) bool;

    pub const createSurface = SDL_Vulkan_CreateSurface;
    extern fn SDL_Vulkan_CreateSurface(window: *sdl.Window, instance: Instance, allocator_callbacks: ?*anyopaque, surface: *anyopaque) bool;

    pub const destroySurface = SDL_Vulkan_DestroySurface;
    extern fn SDL_Vulkan_DestroySurface(instance: Instance, surface: SurfaceKHR, allocator_callbacks: ?*anyopaque) void;
};
