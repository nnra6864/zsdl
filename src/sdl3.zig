//! SDL3 bindings for Zig
//! Ordered by category as per https://wiki.libsdl.org/SDL3/APIByCategory
//!
//! Each SDL header lives in its own file under `src/sdl3/` (e.g. `SDL_video.h` -> `src/sdl3/video.zig`),
//! with declarations in the same order as in the header. Everything is re-exported from here,
//! so the public API is flat: `sdl.createWindow`, `sdl.Window`, ...

const std = @import("std");

test {
    refAllDeclsRecursive(@This(), 4);
}

test "every public declaration is re-exported" {
    inline for (modules) |M| {
        inline for (comptime std.meta.declarations(M)) |decl| {
            if (!@hasDecl(@This(), decl)) @compileError("missing re-export: " ++ decl);
        }
    }
}

fn refAllDeclsRecursive(comptime T: type, comptime depth: u32) void {
    inline for (comptime std.meta.declarations(T)) |decl| {
        const D = @field(T, decl);
        if (@TypeOf(D) == type) {
            if (depth > 0) switch (@typeInfo(D)) {
                .@"struct", .@"enum", .@"union", .@"opaque" => refAllDeclsRecursive(D, depth - 1),
                else => {},
            };
        } else {
            _ = &@field(T, decl);
        }
    }
}

pub const Error = error{SdlError};

/// Logs the current SDL error (see `getError`) and returns `error.SdlError`.
pub fn makeError() error{SdlError} {
    if (getError()) |str| {
        logError(.@"error", "{s}", .{str});
    }
    return error.SdlError;
}

// @generated-exports
// Everything below is re-exported from src/sdl3/*.zig, in header declaration order.

//--------------------------------------------------------------------------------------------------
// Application entry points (SDL_main.h)
//--------------------------------------------------------------------------------------------------
const main_h = @import("sdl3/main.zig");
pub const AppResult = main_h.AppResult;
pub const AppInitFn = main_h.AppInitFn;
pub const AppIterateFn = main_h.AppIterateFn;
pub const AppEventFn = main_h.AppEventFn;
pub const AppQuitFn = main_h.AppQuitFn;
pub const enterAppMainCallbacks = main_h.enterAppMainCallbacks;
pub const setMainReady = main_h.setMainReady;

//--------------------------------------------------------------------------------------------------
// Initialization and Shutdown (SDL_init.h)
//--------------------------------------------------------------------------------------------------
const init_h = @import("sdl3/init.zig");
pub const InitFlags = init_h.InitFlags;
pub const init = init_h.init;
pub const quit = init_h.quit;

//--------------------------------------------------------------------------------------------------
// Configuration Variables (SDL_hints.h)
//--------------------------------------------------------------------------------------------------
const hints_h = @import("sdl3/hints.zig");
pub const hint_windows_dpi_awareness = hints_h.hint_windows_dpi_awareness;
pub const setHint = hints_h.setHint;
pub const setAppMetadata = hints_h.setAppMetadata;

//--------------------------------------------------------------------------------------------------
// Object Properties (SDL_properties.h)
//--------------------------------------------------------------------------------------------------
const properties_h = @import("sdl3/properties.zig");
pub const PropertiesID = properties_h.PropertiesID;
pub const PropertyType = properties_h.PropertyType;
pub const CleanupPropertyCallback = properties_h.CleanupPropertyCallback;
pub const EnumeratePropertiesCallback = properties_h.EnumeratePropertiesCallback;
pub const getGlobalProperties = properties_h.getGlobalProperties;
pub const createProperties = properties_h.createProperties;
pub const copyProperties = properties_h.copyProperties;
pub const lockProperties = properties_h.lockProperties;
pub const unlockProperties = properties_h.unlockProperties;
pub const setPointerPropertyWithCleanup = properties_h.setPointerPropertyWithCleanup;
pub const setPointerProperty = properties_h.setPointerProperty;
pub const setStringProperty = properties_h.setStringProperty;
pub const setNumberProperty = properties_h.setNumberProperty;
pub const setFloatProperty = properties_h.setFloatProperty;
pub const setBooleanProperty = properties_h.setBooleanProperty;
pub const hasProperty = properties_h.hasProperty;
pub const getPropertyType = properties_h.getPropertyType;
pub const getPointerProperty = properties_h.getPointerProperty;
pub const getStringProperty = properties_h.getStringProperty;
pub const getNumberProperty = properties_h.getNumberProperty;
pub const getFloatProperty = properties_h.getFloatProperty;
pub const getBooleanProperty = properties_h.getBooleanProperty;
pub const clearProperty = properties_h.clearProperty;
pub const enumerateProperties = properties_h.enumerateProperties;
pub const destroyProperties = properties_h.destroyProperties;

//--------------------------------------------------------------------------------------------------
// Error Handling (SDL_error.h)
//--------------------------------------------------------------------------------------------------
const error_h = @import("sdl3/error.zig");
pub const getError = error_h.getError;

//--------------------------------------------------------------------------------------------------
// Log Handling (SDL_log.h)
//--------------------------------------------------------------------------------------------------
const log_h = @import("sdl3/log.zig");
pub const max_log_message = log_h.max_log_message;
pub const LogCategory = log_h.LogCategory;
pub const LogPriority = log_h.LogPriority;
pub const setLogPriorities = log_h.setLogPriorities;
pub const setLogPriority = log_h.setLogPriority;
pub const getLogPriority = log_h.getLogPriority;
pub const resetLogPriorities = log_h.resetLogPriorities;
pub const setLogPriorityPrefix = log_h.setLogPriorityPrefix;
pub const log = log_h.log;
pub const logTrace = log_h.logTrace;
pub const logVerbose = log_h.logVerbose;
pub const logDebug = log_h.logDebug;
pub const logInfo = log_h.logInfo;
pub const logWarn = log_h.logWarn;
pub const logError = log_h.logError;
pub const logCritical = log_h.logCritical;
pub const logMessage = log_h.logMessage;
pub const LogOutputFunction = log_h.LogOutputFunction;
pub const getDefaultLogOutputFunction = log_h.getDefaultLogOutputFunction;
pub const getLogOutputFunction = log_h.getLogOutputFunction;
pub const setLogOutputFunction = log_h.setLogOutputFunction;

//--------------------------------------------------------------------------------------------------
// Assertions (SDL_assert.h)
//--------------------------------------------------------------------------------------------------
const assert_h = @import("sdl3/assert.zig");

//--------------------------------------------------------------------------------------------------
// Querying SDL Version (SDL_version.h)
//--------------------------------------------------------------------------------------------------
const version_h = @import("sdl3/version.zig");
pub const Version = version_h.Version;
pub const getVersion = version_h.getVersion;

//--------------------------------------------------------------------------------------------------
// Display and Window Management (SDL_video.h)
//--------------------------------------------------------------------------------------------------
const video_h = @import("sdl3/video.zig");
pub const DisplayId = video_h.DisplayId;
pub const WindowId = video_h.WindowId;
pub const SystemTheme = video_h.SystemTheme;
pub const DisplayMode = video_h.DisplayMode;
pub const DisplayOrientation = video_h.DisplayOrientation;
pub const Window = video_h.Window;
pub const posUndefinedDisplay = video_h.posUndefinedDisplay;
pub const pos_undefined = video_h.pos_undefined;
pub const posIsUndefined = video_h.posIsUndefined;
pub const posCenteredDisplay = video_h.posCenteredDisplay;
pub const pos_centered = video_h.pos_centered;
pub const posIsCentered = video_h.posIsCentered;
pub const FlashOperation = video_h.FlashOperation;
pub const GLContextState = video_h.GLContextState;
pub const GLContext = video_h.GLContext;
pub const EGLDisplay = video_h.EGLDisplay;
pub const EGLConfig = video_h.EGLConfig;
pub const EGLSurface = video_h.EGLSurface;
pub const EGLAttrib = video_h.EGLAttrib;
pub const EGLint = video_h.EGLint;
pub const EGLAttribArrayCallback = video_h.EGLAttribArrayCallback;
pub const EGLIntArrayCallback = video_h.EGLIntArrayCallback;
pub const gl = video_h.gl;
pub const createWindow = video_h.createWindow;
pub const destroyWindow = video_h.destroyWindow;
pub const getWindowFullscreenMode = video_h.getWindowFullscreenMode;
pub const getWindowPosition = video_h.getWindowPosition;
pub const getWindowSize = video_h.getWindowSize;
pub const getWindowSizeInPixels = video_h.getWindowSizeInPixels;
pub const setWindowTitle = video_h.setWindowTitle;
pub const getNumVideoDrivers = video_h.getNumVideoDrivers;
pub const getVideoDriver = video_h.getVideoDriver;
pub const getCurrentVideoDriver = video_h.getCurrentVideoDriver;
pub const getDisplayContentScale = video_h.getDisplayContentScale;
pub const getWindowDisplayScale = video_h.getWindowDisplayScale;

//--------------------------------------------------------------------------------------------------
// 2D Accelerated Rendering (SDL_render.h)
//--------------------------------------------------------------------------------------------------
const render_h = @import("sdl3/render.zig");
pub const Vertex = render_h.Vertex;
pub const TextureAccess = render_h.TextureAccess;
pub const RendererLogicalPresentationMode = render_h.RendererLogicalPresentationMode;
pub const Texture = render_h.Texture;
pub const destroyTexture = render_h.destroyTexture;
pub const lockTexture = render_h.lockTexture;
pub const unlockTexture = render_h.unlockTexture;
pub const Renderer = render_h.Renderer;
pub const getNumRenderDrivers = render_h.getNumRenderDrivers;
pub const getRenderDriver = render_h.getRenderDriver;
pub const createWindowAndRenderer = render_h.createWindowAndRenderer;
pub const createRenderer = render_h.createRenderer;
pub const destroyRenderer = render_h.destroyRenderer;
pub const renderClear = render_h.renderClear;
pub const renderPresent = render_h.renderPresent;
pub const renderTexture = render_h.renderTexture;
pub const renderTextureRotated = render_h.renderTextureRotated;
pub const setRenderScale = render_h.setRenderScale;
pub const renderLine = render_h.renderLine;
pub const renderPoint = render_h.renderPoint;
pub const renderFillRect = render_h.renderFillRect;
pub const renderRect = render_h.renderRect;
pub const renderGeometry = render_h.renderGeometry;
pub const setRenderDrawColor = render_h.setRenderDrawColor;
pub const getRenderDrawColor = render_h.getRenderDrawColor;
pub const getRenderDrawBlendMode = render_h.getRenderDrawBlendMode;
pub const setRenderDrawBlendMode = render_h.setRenderDrawBlendMode;
pub const getCurrentRenderOutputSize = render_h.getCurrentRenderOutputSize;
pub const createTexture = render_h.createTexture;
pub const createTextureFromSurface = render_h.createTextureFromSurface;
pub const renderClipEnabled = render_h.renderClipEnabled;
pub const setRenderClipRect = render_h.setRenderClipRect;
pub const getRenderClipRect = render_h.getRenderClipRect;
pub const getRenderLogicalPresentation = render_h.getRenderLogicalPresentation;
pub const setRenderLogicalPresentation = render_h.setRenderLogicalPresentation;
pub const getRenderViewport = render_h.getRenderViewport;
pub const setRenderViewport = render_h.setRenderViewport;
pub const setRenderTarget = render_h.setRenderTarget;
pub const renderReadPixels = render_h.renderReadPixels;
pub const renderDebugText = render_h.renderDebugText;

//--------------------------------------------------------------------------------------------------
// Pixel Formats and Conversion Routines (SDL_pixels.h)
//--------------------------------------------------------------------------------------------------
const pixels_h = @import("sdl3/pixels.zig");
pub const ALPHA_OPAQUE = pixels_h.ALPHA_OPAQUE;
pub const ALPHA_OPAQUE_FLOAT = pixels_h.ALPHA_OPAQUE_FLOAT;
pub const ALPHA_TRANSPARENT = pixels_h.ALPHA_TRANSPARENT;
pub const ALPHA_TRANSPARENT_FLOAT = pixels_h.ALPHA_TRANSPARENT_FLOAT;
pub const PixelType = pixels_h.PixelType;
pub const BitmapOrder = pixels_h.BitmapOrder;
pub const PackedOrder = pixels_h.PackedOrder;
pub const ArrayOrder = pixels_h.ArrayOrder;
pub const PackedLayout = pixels_h.PackedLayout;
pub const PixelFormatEnum = pixels_h.PixelFormatEnum;
pub const Color = pixels_h.Color;
pub const FColor = pixels_h.FColor;

//--------------------------------------------------------------------------------------------------
// Blend modes (SDL_blendmode.h)
//--------------------------------------------------------------------------------------------------
const blendmode_h = @import("sdl3/blendmode.zig");
pub const BlendMode = blendmode_h.BlendMode;

//--------------------------------------------------------------------------------------------------
// Rectangle Functions (SDL_rect.h)
//--------------------------------------------------------------------------------------------------
const rect_h = @import("sdl3/rect.zig");
pub const Rect = rect_h.Rect;
pub const hasRectIntersection = rect_h.hasRectIntersection;
pub const getRectIntersection = rect_h.getRectIntersection;
pub const getRectAndLineIntersection = rect_h.getRectAndLineIntersection;
pub const FRect = rect_h.FRect;
pub const hasRectIntersectionFloat = rect_h.hasRectIntersectionFloat;
pub const getRectIntersectionFloat = rect_h.getRectIntersectionFloat;
pub const getRectAndLineIntersectionFloat = rect_h.getRectAndLineIntersectionFloat;
pub const Point = rect_h.Point;
pub const FPoint = rect_h.FPoint;

//--------------------------------------------------------------------------------------------------
// Surface Creation and Simple Drawing (SDL_surface.h)
//--------------------------------------------------------------------------------------------------
const surface_h = @import("sdl3/surface.zig");
pub const ScaleMode = surface_h.ScaleMode;
pub const Surface = surface_h.Surface;
pub const destroySurface = surface_h.destroySurface;

//--------------------------------------------------------------------------------------------------
// Clipboard Handling (SDL_clipboard.h)
//--------------------------------------------------------------------------------------------------
const clipboard_h = @import("sdl3/clipboard.zig");

//--------------------------------------------------------------------------------------------------
// Vulkan Support (SDL_vulkan.h)
//--------------------------------------------------------------------------------------------------
const vulkan_h = @import("sdl3/vulkan.zig");
pub const vk = vulkan_h.vk;

//--------------------------------------------------------------------------------------------------
// Metal Support (SDL_metal.h)
//--------------------------------------------------------------------------------------------------
const metal_h = @import("sdl3/metal.zig");

//--------------------------------------------------------------------------------------------------
// Camera (SDL_camera.h)
//--------------------------------------------------------------------------------------------------
const camera_h = @import("sdl3/camera.zig");
pub const CameraId = camera_h.CameraId;
pub const Camera = camera_h.Camera;

//--------------------------------------------------------------------------------------------------
// Event Handling (SDL_events.h)
//--------------------------------------------------------------------------------------------------
const events_h = @import("sdl3/events.zig");
pub const EventType = events_h.EventType;
pub const CommonEvent = events_h.CommonEvent;
pub const DisplayEvent = events_h.DisplayEvent;
pub const WindowEvent = events_h.WindowEvent;
pub const KeyboardDeviceEvent = events_h.KeyboardDeviceEvent;
pub const KeyboardEvent = events_h.KeyboardEvent;
pub const TextEditingEvent = events_h.TextEditingEvent;
pub const TextEditingCandidatesEvent = events_h.TextEditingCandidatesEvent;
pub const TextInputEvent = events_h.TextInputEvent;
pub const MouseDeviceEvent = events_h.MouseDeviceEvent;
pub const MouseMotionEvent = events_h.MouseMotionEvent;
pub const MouseButtonEvent = events_h.MouseButtonEvent;
pub const MouseWheelEvent = events_h.MouseWheelEvent;
pub const JoyAxisEvent = events_h.JoyAxisEvent;
pub const JoyBallEvent = events_h.JoyBallEvent;
pub const JoyHatEvent = events_h.JoyHatEvent;
pub const JoyButtonEvent = events_h.JoyButtonEvent;
pub const JoyDeviceEvent = events_h.JoyDeviceEvent;
pub const JoyBatteryEvent = events_h.JoyBatteryEvent;
pub const GamepadAxisEvent = events_h.GamepadAxisEvent;
pub const GamepadButtonEvent = events_h.GamepadButtonEvent;
pub const GamepadDeviceEvent = events_h.GamepadDeviceEvent;
pub const GamepadTouchpadEvent = events_h.GamepadTouchpadEvent;
pub const GamepadSensorEvent = events_h.GamepadSensorEvent;
pub const AudioDeviceEvent = events_h.AudioDeviceEvent;
pub const CameraDeviceEvent = events_h.CameraDeviceEvent;
pub const RenderEvent = events_h.RenderEvent;
pub const TouchFingerEvent = events_h.TouchFingerEvent;
pub const PenProximityEvent = events_h.PenProximityEvent;
pub const PenMotionEvent = events_h.PenMotionEvent;
pub const PenTouchEvent = events_h.PenTouchEvent;
pub const PenButtonEvent = events_h.PenButtonEvent;
pub const PenAxisEvent = events_h.PenAxisEvent;
pub const DropEvent = events_h.DropEvent;
pub const ClipboardEvent = events_h.ClipboardEvent;
pub const SensorEvent = events_h.SensorEvent;
pub const QuitEvent = events_h.QuitEvent;
pub const UserEvent = events_h.UserEvent;
pub const Event = events_h.Event;
pub const pumpEvents = events_h.pumpEvents;
pub const EventAction = events_h.EventAction;
pub const pollEvent = events_h.pollEvent;
pub const pushEvent = events_h.pushEvent;
pub const EventFilter = events_h.EventFilter;

//--------------------------------------------------------------------------------------------------
// Keyboard Support (SDL_keyboard.h)
//--------------------------------------------------------------------------------------------------
const keyboard_h = @import("sdl3/keyboard.zig");
pub const KeyboardId = keyboard_h.KeyboardId;
pub const hasKeyboard = keyboard_h.hasKeyboard;
pub const getKeyboards = keyboard_h.getKeyboards;
pub const getKeyboardNameForId = keyboard_h.getKeyboardNameForId;
pub const getKeyboardFocus = keyboard_h.getKeyboardFocus;
pub const getKeyboardState = keyboard_h.getKeyboardState;
pub const resetKeyboard = keyboard_h.resetKeyboard;
pub const getModState = keyboard_h.getModState;
pub const setModState = keyboard_h.setModState;

//--------------------------------------------------------------------------------------------------
// Keyboard Scancodes (SDL_scancode.h)
//--------------------------------------------------------------------------------------------------
const scancode_h = @import("sdl3/scancode.zig");
pub const Scancode = scancode_h.Scancode;
pub const SCANCODE_TO_KEYCODE = scancode_h.SCANCODE_TO_KEYCODE;

//--------------------------------------------------------------------------------------------------
// Keyboard Keycodes (SDL_keycode.h)
//--------------------------------------------------------------------------------------------------
const keycode_h = @import("sdl3/keycode.zig");
pub const Keycode = keycode_h.Keycode;
pub const Keymod = keycode_h.Keymod;
pub const TextInputType = keycode_h.TextInputType;
pub const Capitalization = keycode_h.Capitalization;

//--------------------------------------------------------------------------------------------------
// Mouse Support (SDL_mouse.h)
//--------------------------------------------------------------------------------------------------
const mouse_h = @import("sdl3/mouse.zig");
pub const MouseId = mouse_h.MouseId;
pub const Cursor = mouse_h.Cursor;
pub const SystemCursor = mouse_h.SystemCursor;
pub const MouseWheelDirection = mouse_h.MouseWheelDirection;
pub const MouseButtonFlags = mouse_h.MouseButtonFlags;
pub const hasMouse = mouse_h.hasMouse;
pub const getMice = mouse_h.getMice;
pub const getMouseNameForId = mouse_h.getMouseNameForId;
pub const getMouseFocus = mouse_h.getMouseFocus;
pub const getMouseState = mouse_h.getMouseState;
pub const getGlobalMouseState = mouse_h.getGlobalMouseState;
pub const getRelativeMouseState = mouse_h.getRelativeMouseState;
pub const warpMouseInWindow = mouse_h.warpMouseInWindow;
pub const warpMouseGlobal = mouse_h.warpMouseGlobal;
pub const setWindowRelativeMouseMode = mouse_h.setWindowRelativeMouseMode;
pub const getWindowRelativeMouseMode = mouse_h.getWindowRelativeMouseMode;
pub const captureMouse = mouse_h.captureMouse;
pub const createCursor = mouse_h.createCursor;
pub const createColorCursor = mouse_h.createColorCursor;
pub const createSystemCursor = mouse_h.createSystemCursor;
pub const setCursor = mouse_h.setCursor;
pub const getCursor = mouse_h.getCursor;
pub const getDefaultCursor = mouse_h.getDefaultCursor;
pub const destroyCursor = mouse_h.destroyCursor;
pub const showCursor = mouse_h.showCursor;
pub const hideCursor = mouse_h.hideCursor;
pub const cursorVisible = mouse_h.cursorVisible;

//--------------------------------------------------------------------------------------------------
// Joystick Support (SDL_joystick.h)
//--------------------------------------------------------------------------------------------------
const joystick_h = @import("sdl3/joystick.zig");
pub const Joystick = joystick_h.Joystick;

//--------------------------------------------------------------------------------------------------
// Gamepad Support (SDL_gamepad.h)
//--------------------------------------------------------------------------------------------------
const gamepad_h = @import("sdl3/gamepad.zig");
pub const Gamepad = gamepad_h.Gamepad;
pub const openGamepad = gamepad_h.openGamepad;
pub const getGamepadAxis = gamepad_h.getGamepadAxis;
pub const getGamepadButton = gamepad_h.getGamepadButton;
pub const closeGamepad = gamepad_h.closeGamepad;

//--------------------------------------------------------------------------------------------------
// Touch Support (SDL_touch.h)
//--------------------------------------------------------------------------------------------------
const touch_h = @import("sdl3/touch.zig");
pub const TouchId = touch_h.TouchId;
pub const FingerId = touch_h.FingerId;
pub const TouchDeviceType = touch_h.TouchDeviceType;
pub const Finger = touch_h.Finger;
pub const TOUCH_MOUSEID = touch_h.TOUCH_MOUSEID;
pub const MOUSE_TOUCHID = touch_h.MOUSE_TOUCHID;

//--------------------------------------------------------------------------------------------------
// Pen Support (SDL_pen.h)
//--------------------------------------------------------------------------------------------------
const pen_h = @import("sdl3/pen.zig");
pub const PenId = pen_h.PenId;
pub const PEN_MOUSEID = pen_h.PEN_MOUSEID;
pub const PEN_TOUCHID = pen_h.PEN_TOUCHID;
pub const PenInputFlags = pen_h.PenInputFlags;
pub const PEN_INPUT_DOWN = pen_h.PEN_INPUT_DOWN;
pub const PEN_INPUT_BUTTON_1 = pen_h.PEN_INPUT_BUTTON_1;
pub const PEN_INPUT_BUTTON_2 = pen_h.PEN_INPUT_BUTTON_2;
pub const PEN_INPUT_BUTTON_3 = pen_h.PEN_INPUT_BUTTON_3;
pub const PEN_INPUT_BUTTON_4 = pen_h.PEN_INPUT_BUTTON_4;
pub const PEN_INPUT_BUTTON_5 = pen_h.PEN_INPUT_BUTTON_5;
pub const PEN_INPUT_ERASER_TIP = pen_h.PEN_INPUT_ERASER_TIP;
pub const PenAxis = pen_h.PenAxis;

//--------------------------------------------------------------------------------------------------
// Sensors (SDL_sensor.h)
//--------------------------------------------------------------------------------------------------
const sensor_h = @import("sdl3/sensor.zig");
pub const Sensor = sensor_h.Sensor;
pub const SensorId = sensor_h.SensorId;

//--------------------------------------------------------------------------------------------------
// HIDAPI (SDL_hidapi.h)
//--------------------------------------------------------------------------------------------------
const hidapi_h = @import("sdl3/hidapi.zig");

//--------------------------------------------------------------------------------------------------
// Force Feedback Support (SDL_haptic.h)
//--------------------------------------------------------------------------------------------------
const haptic_h = @import("sdl3/haptic.zig");

//--------------------------------------------------------------------------------------------------
// Audio Device Management, Playing and Recording (SDL_audio.h)
//--------------------------------------------------------------------------------------------------
const audio_h = @import("sdl3/audio.zig");
pub const AUDIO_MASK_BITSIZE = audio_h.AUDIO_MASK_BITSIZE;
pub const AUDIO_MASK_FLOAT = audio_h.AUDIO_MASK_FLOAT;
pub const AUDIO_MASK_BIG_ENDIAN = audio_h.AUDIO_MASK_BIG_ENDIAN;
pub const AUDIO_MASK_SIGNED = audio_h.AUDIO_MASK_SIGNED;
pub const AudioFormat = audio_h.AudioFormat;
pub const AUDIO_BITSIZE = audio_h.AUDIO_BITSIZE;
pub const AUDIO_BYTESIZE = audio_h.AUDIO_BYTESIZE;
pub const AUDIO_ISFLOAT = audio_h.AUDIO_ISFLOAT;
pub const AUDIO_ISBIGENDIAN = audio_h.AUDIO_ISBIGENDIAN;
pub const AUDIO_ISSIGNED = audio_h.AUDIO_ISSIGNED;
pub const AUDIO_ISINT = audio_h.AUDIO_ISINT;
pub const AUDIO_ISLITTLEENDIAN = audio_h.AUDIO_ISLITTLEENDIAN;
pub const AUDIO_ISUNSIGNED = audio_h.AUDIO_ISUNSIGNED;
pub const AudioDeviceId = audio_h.AudioDeviceId;
pub const AUDIO_DEVICE_DEFAULT_PLAYBACK = audio_h.AUDIO_DEVICE_DEFAULT_PLAYBACK;
pub const AUDIO_DEVICE_DEFAULT_RECORDING = audio_h.AUDIO_DEVICE_DEFAULT_RECORDING;
pub const AudioSpec = audio_h.AudioSpec;
pub const AUDIO_FRAMESIZE = audio_h.AUDIO_FRAMESIZE;
pub const AudioStream = audio_h.AudioStream;
pub const getNumAudioDrivers = audio_h.getNumAudioDrivers;
pub const getAudioDriver = audio_h.getAudioDriver;
pub const getCurrentAudioDriver = audio_h.getCurrentAudioDriver;
pub const getAudioPlaybackDevices = audio_h.getAudioPlaybackDevices;
pub const getAudioRecordingDevices = audio_h.getAudioRecordingDevices;
pub const getAudioDeviceName = audio_h.getAudioDeviceName;
pub const getAudioDeviceFormat = audio_h.getAudioDeviceFormat;
pub const getAudioDeviceChannelMap = audio_h.getAudioDeviceChannelMap;
pub const openAudioDevice = audio_h.openAudioDevice;
pub const isAudioDevicePhysical = audio_h.isAudioDevicePhysical;
pub const isAudioDevicePlayback = audio_h.isAudioDevicePlayback;
pub const pauseAudioDevice = audio_h.pauseAudioDevice;
pub const resumeAudioDevice = audio_h.resumeAudioDevice;
pub const audioDevicePaused = audio_h.audioDevicePaused;
pub const getAudioDeviceGain = audio_h.getAudioDeviceGain;
pub const setAudioDeviceGain = audio_h.setAudioDeviceGain;
pub const closeAudioDevice = audio_h.closeAudioDevice;
pub const getAudioStreamDevice = audio_h.getAudioStreamDevice;
pub const putAudioStreamData = audio_h.putAudioStreamData;
pub const createAudioStream = audio_h.createAudioStream;
pub const bindAudioStream = audio_h.bindAudioStream;
pub const getAudioStreamQueued = audio_h.getAudioStreamQueued;
pub const flushAudioStream = audio_h.flushAudioStream;
pub const clearAudioStream = audio_h.clearAudioStream;
pub const AudioStreamCallback = audio_h.AudioStreamCallback;
pub const openAudioDeviceStream = audio_h.openAudioDeviceStream;
pub const loadWAV = audio_h.loadWAV;

//--------------------------------------------------------------------------------------------------
// 3D Rendering and GPU Compute (SDL_gpu.h)
//--------------------------------------------------------------------------------------------------
const gpu_h = @import("sdl3/gpu.zig");
pub const GPUDevice = gpu_h.GPUDevice;
pub const GPUBuffer = gpu_h.GPUBuffer;
pub const GPUTransferBuffer = gpu_h.GPUTransferBuffer;
pub const GPUTexture = gpu_h.GPUTexture;
pub const GPUSampler = gpu_h.GPUSampler;
pub const GPUShader = gpu_h.GPUShader;
pub const GPUComputePipeline = gpu_h.GPUComputePipeline;
pub const GPUGraphicsPipeline = gpu_h.GPUGraphicsPipeline;
pub const GPUCommandBuffer = gpu_h.GPUCommandBuffer;
pub const GPURenderPass = gpu_h.GPURenderPass;
pub const GPUComputePass = gpu_h.GPUComputePass;
pub const GPUCopyPass = gpu_h.GPUCopyPass;
pub const GPUFence = gpu_h.GPUFence;
pub const GPUPrimitiveType = gpu_h.GPUPrimitiveType;
pub const GPULoadOp = gpu_h.GPULoadOp;
pub const GPUStoreOp = gpu_h.GPUStoreOp;
pub const GPUIndexElementSize = gpu_h.GPUIndexElementSize;
pub const GPUTextureFormat = gpu_h.GPUTextureFormat;
pub const GPUTextureUsageFlags = gpu_h.GPUTextureUsageFlags;
pub const GPUTextureType = gpu_h.GPUTextureType;
pub const GPUSampleCount = gpu_h.GPUSampleCount;
pub const GPUCubeMapFace = gpu_h.GPUCubeMapFace;
pub const GPUBufferUsageFlags = gpu_h.GPUBufferUsageFlags;
pub const GPUTransferBufferUsage = gpu_h.GPUTransferBufferUsage;
pub const GPUShaderStage = gpu_h.GPUShaderStage;
pub const GPUShaderFormat = gpu_h.GPUShaderFormat;
pub const GPUVertexElementFormat = gpu_h.GPUVertexElementFormat;
pub const GPUVertexInputRate = gpu_h.GPUVertexInputRate;
pub const GPUFillMode = gpu_h.GPUFillMode;
pub const GPUCullMode = gpu_h.GPUCullMode;
pub const GPUFrontFace = gpu_h.GPUFrontFace;
pub const GPUCompareOp = gpu_h.GPUCompareOp;
pub const GPUStencilOp = gpu_h.GPUStencilOp;
pub const GPUBlendOp = gpu_h.GPUBlendOp;
pub const GPUBlendFactor = gpu_h.GPUBlendFactor;
pub const GPUColorComponentFlags = gpu_h.GPUColorComponentFlags;
pub const GPUFilter = gpu_h.GPUFilter;
pub const GPUSamplerMipmapMode = gpu_h.GPUSamplerMipmapMode;
pub const GPUSamplerAddressMode = gpu_h.GPUSamplerAddressMode;
pub const GPUPresentMode = gpu_h.GPUPresentMode;
pub const GPUSwapchainComposition = gpu_h.GPUSwapchainComposition;
pub const GPUViewport = gpu_h.GPUViewport;
pub const GPUTextureTransferInfo = gpu_h.GPUTextureTransferInfo;
pub const GPUTransferBufferLocation = gpu_h.GPUTransferBufferLocation;
pub const GPUTextureLocation = gpu_h.GPUTextureLocation;
pub const GPUTextureRegion = gpu_h.GPUTextureRegion;
pub const GPUBlitRegion = gpu_h.GPUBlitRegion;
pub const GPUBufferLocation = gpu_h.GPUBufferLocation;
pub const GPUBufferRegion = gpu_h.GPUBufferRegion;
pub const GPUIndirectDrawCommand = gpu_h.GPUIndirectDrawCommand;
pub const GPUIndexedIndirectDrawCommand = gpu_h.GPUIndexedIndirectDrawCommand;
pub const GPUIndirectDispatchCommand = gpu_h.GPUIndirectDispatchCommand;
pub const GPUSamplerCreateInfo = gpu_h.GPUSamplerCreateInfo;
pub const GPUVertexBufferDescription = gpu_h.GPUVertexBufferDescription;
pub const GPUVertexAttribute = gpu_h.GPUVertexAttribute;
pub const GPUVertexInputState = gpu_h.GPUVertexInputState;
pub const GPUStencilOpState = gpu_h.GPUStencilOpState;
pub const GPUColorTargetBlendState = gpu_h.GPUColorTargetBlendState;
pub const GPUShaderCreateInfo = gpu_h.GPUShaderCreateInfo;
pub const GPUTextureCreateInfo = gpu_h.GPUTextureCreateInfo;
pub const GPUBufferCreateInfo = gpu_h.GPUBufferCreateInfo;
pub const GPUTransferBufferCreateInfo = gpu_h.GPUTransferBufferCreateInfo;
pub const GPURasterizerState = gpu_h.GPURasterizerState;
pub const GPUMultisampleState = gpu_h.GPUMultisampleState;
pub const GPUDepthStencilState = gpu_h.GPUDepthStencilState;
pub const GPUColorTargetDescription = gpu_h.GPUColorTargetDescription;
pub const GPUGraphicsPipelineTargetInfo = gpu_h.GPUGraphicsPipelineTargetInfo;
pub const GPUGraphicsPipelineCreateInfo = gpu_h.GPUGraphicsPipelineCreateInfo;
pub const GPUComputePipelineCreateInfo = gpu_h.GPUComputePipelineCreateInfo;
pub const GPUColorTargetInfo = gpu_h.GPUColorTargetInfo;
pub const GPUDepthStencilTargetInfo = gpu_h.GPUDepthStencilTargetInfo;
pub const GPUBlitInfo = gpu_h.GPUBlitInfo;
pub const GPUBufferBinding = gpu_h.GPUBufferBinding;
pub const GPUTextureSamplerBinding = gpu_h.GPUTextureSamplerBinding;
pub const GPUStorageBufferReadWriteBinding = gpu_h.GPUStorageBufferReadWriteBinding;
pub const GPUStorageTextureReadWriteBinding = gpu_h.GPUStorageTextureReadWriteBinding;
pub const gpuSupportsShaderFormats = gpu_h.gpuSupportsShaderFormats;
pub const gpuSupportsProperties = gpu_h.gpuSupportsProperties;
pub const createGPUDevice = gpu_h.createGPUDevice;
pub const createGPUDeviceWithProperties = gpu_h.createGPUDeviceWithProperties;
pub const destroyGPUDevice = gpu_h.destroyGPUDevice;
pub const getNumGPUDrivers = gpu_h.getNumGPUDrivers;
pub const getGPUDriver = gpu_h.getGPUDriver;
pub const getGPUDeviceDriver = gpu_h.getGPUDeviceDriver;
pub const getGPUShaderFormats = gpu_h.getGPUShaderFormats;
pub const createGPUComputePipeline = gpu_h.createGPUComputePipeline;
pub const createGPUGraphicsPipeline = gpu_h.createGPUGraphicsPipeline;
pub const createGPUSampler = gpu_h.createGPUSampler;
pub const createGPUShader = gpu_h.createGPUShader;
pub const createGPUTexture = gpu_h.createGPUTexture;
pub const createGPUBuffer = gpu_h.createGPUBuffer;
pub const createGPUTransferBuffer = gpu_h.createGPUTransferBuffer;
pub const setGPUBufferName = gpu_h.setGPUBufferName;
pub const setGPUTextureName = gpu_h.setGPUTextureName;
pub const insertGPUDebugLabel = gpu_h.insertGPUDebugLabel;
pub const pushGPUDebugGroup = gpu_h.pushGPUDebugGroup;
pub const popGPUDebugGroup = gpu_h.popGPUDebugGroup;
pub const releaseGPUTexture = gpu_h.releaseGPUTexture;
pub const releaseGPUSampler = gpu_h.releaseGPUSampler;
pub const releaseGPUBuffer = gpu_h.releaseGPUBuffer;
pub const releaseGPUTransferBuffer = gpu_h.releaseGPUTransferBuffer;
pub const releaseGPUComputePipeline = gpu_h.releaseGPUComputePipeline;
pub const releaseGPUShader = gpu_h.releaseGPUShader;
pub const releaseGPUGraphicsPipeline = gpu_h.releaseGPUGraphicsPipeline;
pub const acquireGPUCommandBuffer = gpu_h.acquireGPUCommandBuffer;
pub const pushGPUVertexUniformData = gpu_h.pushGPUVertexUniformData;
pub const pushGPUFragmentUniformData = gpu_h.pushGPUFragmentUniformData;
pub const pushGPUComputeUniformData = gpu_h.pushGPUComputeUniformData;
pub const beginGPURenderPass = gpu_h.beginGPURenderPass;
pub const bindGPUGraphicsPipeline = gpu_h.bindGPUGraphicsPipeline;
pub const setGPUViewport = gpu_h.setGPUViewport;
pub const setGPUScissor = gpu_h.setGPUScissor;
pub const setGPUBlendConstants = gpu_h.setGPUBlendConstants;
pub const setGPUStencilReference = gpu_h.setGPUStencilReference;
pub const bindGPUVertexBuffers = gpu_h.bindGPUVertexBuffers;
pub const bindGPUIndexBuffer = gpu_h.bindGPUIndexBuffer;
pub const bindGPUVertexSamplers = gpu_h.bindGPUVertexSamplers;
pub const bindGPUVertexStorageTextures = gpu_h.bindGPUVertexStorageTextures;
pub const bindGPUVertexStorageBuffers = gpu_h.bindGPUVertexStorageBuffers;
pub const bindGPUFragmentSamplers = gpu_h.bindGPUFragmentSamplers;
pub const bindGPUFragmentStorageTextures = gpu_h.bindGPUFragmentStorageTextures;
pub const bindGPUFragmentStorageBuffers = gpu_h.bindGPUFragmentStorageBuffers;
pub const drawGPUIndexedPrimitives = gpu_h.drawGPUIndexedPrimitives;
pub const drawGPUPrimitives = gpu_h.drawGPUPrimitives;
pub const drawGPUPrimitivesIndirect = gpu_h.drawGPUPrimitivesIndirect;
pub const drawGPUIndexedPrimitivesIndirect = gpu_h.drawGPUIndexedPrimitivesIndirect;
pub const endGPURenderPass = gpu_h.endGPURenderPass;
pub const beginGPUComputePass = gpu_h.beginGPUComputePass;
pub const bindGPUComputePipeline = gpu_h.bindGPUComputePipeline;
pub const bindGPUComputeSamplers = gpu_h.bindGPUComputeSamplers;
pub const bindGPUComputeStorageTextures = gpu_h.bindGPUComputeStorageTextures;
pub const bindGPUComputeStorageBuffers = gpu_h.bindGPUComputeStorageBuffers;
pub const dispatchGPUCompute = gpu_h.dispatchGPUCompute;
pub const dispatchGPUComputeIndirect = gpu_h.dispatchGPUComputeIndirect;
pub const endGPUComputePass = gpu_h.endGPUComputePass;
pub const mapGPUTransferBuffer = gpu_h.mapGPUTransferBuffer;
pub const unmapGPUTransferBuffer = gpu_h.unmapGPUTransferBuffer;
pub const beginGPUCopyPass = gpu_h.beginGPUCopyPass;
pub const uploadToGPUTexture = gpu_h.uploadToGPUTexture;
pub const uploadToGPUBuffer = gpu_h.uploadToGPUBuffer;
pub const copyGPUTextureToTexture = gpu_h.copyGPUTextureToTexture;
pub const copyGPUBufferToBuffer = gpu_h.copyGPUBufferToBuffer;
pub const downloadFromGPUTexture = gpu_h.downloadFromGPUTexture;
pub const downloadFromGPUBuffer = gpu_h.downloadFromGPUBuffer;
pub const endGPUCopyPass = gpu_h.endGPUCopyPass;
pub const generateMipmapsForGPUTexture = gpu_h.generateMipmapsForGPUTexture;
pub const blitGPUTexture = gpu_h.blitGPUTexture;
pub const windowSupportsGPUSwapchainComposition = gpu_h.windowSupportsGPUSwapchainComposition;
pub const windowSupportsGPUPresentMode = gpu_h.windowSupportsGPUPresentMode;
pub const claimWindowForGPUDevice = gpu_h.claimWindowForGPUDevice;
pub const releaseWindowFromGPUDevice = gpu_h.releaseWindowFromGPUDevice;
pub const setGPUSwapchainParameters = gpu_h.setGPUSwapchainParameters;
pub const setGPUAllowedFramesInFlight = gpu_h.setGPUAllowedFramesInFlight;
pub const getGPUSwapchainTextureFormat = gpu_h.getGPUSwapchainTextureFormat;
pub const acquireGPUSwapchainTexture = gpu_h.acquireGPUSwapchainTexture;
pub const waitForGPUSwapchain = gpu_h.waitForGPUSwapchain;
pub const waitAndAcquireGPUSwapchainTexture = gpu_h.waitAndAcquireGPUSwapchainTexture;
pub const submitGPUCommandBuffer = gpu_h.submitGPUCommandBuffer;
pub const submitGPUCommandBufferAndAcquireFence = gpu_h.submitGPUCommandBufferAndAcquireFence;
pub const cancelGPUCommandBuffer = gpu_h.cancelGPUCommandBuffer;
pub const waitForGPUIdle = gpu_h.waitForGPUIdle;
pub const waitForGPUFences = gpu_h.waitForGPUFences;
pub const queryGPUFence = gpu_h.queryGPUFence;
pub const releaseGPUFence = gpu_h.releaseGPUFence;
pub const gpuTextureFormatTexelBlockSize = gpu_h.gpuTextureFormatTexelBlockSize;
pub const gpuTextureSupportsFormat = gpu_h.gpuTextureSupportsFormat;
pub const gpuTextureSupportsSampleCount = gpu_h.gpuTextureSupportsSampleCount;
pub const calculateGPUTextureFormatSize = gpu_h.calculateGPUTextureFormatSize;

//--------------------------------------------------------------------------------------------------
// Thread Management (SDL_thread.h)
//--------------------------------------------------------------------------------------------------
const thread_h = @import("sdl3/thread.zig");

//--------------------------------------------------------------------------------------------------
// Thread Synchronization Primitives (SDL_mutex.h)
//--------------------------------------------------------------------------------------------------
const mutex_h = @import("sdl3/mutex.zig");

//--------------------------------------------------------------------------------------------------
// Atomic Operations (SDL_atomic.h)
//--------------------------------------------------------------------------------------------------
const atomic_h = @import("sdl3/atomic.zig");

//--------------------------------------------------------------------------------------------------
// Timer Support (SDL_timer.h)
//--------------------------------------------------------------------------------------------------
const timer_h = @import("sdl3/timer.zig");
pub const getTicksNS = timer_h.getTicksNS;
pub const getPerformanceCounter = timer_h.getPerformanceCounter;
pub const getPerformanceFrequency = timer_h.getPerformanceFrequency;
pub const delay = timer_h.delay;
pub const getTicks = timer_h.getTicks;

//--------------------------------------------------------------------------------------------------
// Date and Time (SDL_time.h)
//--------------------------------------------------------------------------------------------------
const time_h = @import("sdl3/time.zig");

//--------------------------------------------------------------------------------------------------
// Filesystem Access (SDL_filesystem.h)
//--------------------------------------------------------------------------------------------------
const filesystem_h = @import("sdl3/filesystem.zig");
pub const getBasePath = filesystem_h.getBasePath;
pub const getPrefPath = filesystem_h.getPrefPath;

//--------------------------------------------------------------------------------------------------
// Storage Abstraction (SDL_storage.h)
//--------------------------------------------------------------------------------------------------
const storage_h = @import("sdl3/storage.zig");

//--------------------------------------------------------------------------------------------------
// I/O Streams (SDL_iostream.h)
//--------------------------------------------------------------------------------------------------
const iostream_h = @import("sdl3/iostream.zig");

//--------------------------------------------------------------------------------------------------
// Async I/O (SDL_asyncio.h)
//--------------------------------------------------------------------------------------------------
const asyncio_h = @import("sdl3/asyncio.zig");

//--------------------------------------------------------------------------------------------------
// Shared Object/DLL Management (SDL_loadso.h)
//--------------------------------------------------------------------------------------------------
const loadso_h = @import("sdl3/loadso.zig");

//--------------------------------------------------------------------------------------------------
// Platform Detection (SDL_platform.h)
//--------------------------------------------------------------------------------------------------
const platform_h = @import("sdl3/platform.zig");

//--------------------------------------------------------------------------------------------------
// CPU Feature Detection (SDL_cpuinfo.h)
//--------------------------------------------------------------------------------------------------
const cpuinfo_h = @import("sdl3/cpuinfo.zig");

//--------------------------------------------------------------------------------------------------
// Byte Order and Byte Swapping (SDL_endian.h)
//--------------------------------------------------------------------------------------------------
const endian_h = @import("sdl3/endian.zig");

//--------------------------------------------------------------------------------------------------
// Bit Manipulation (SDL_bits.h)
//--------------------------------------------------------------------------------------------------
const bits_h = @import("sdl3/bits.zig");

//--------------------------------------------------------------------------------------------------
// Power Management Status (SDL_power.h)
//--------------------------------------------------------------------------------------------------
const power_h = @import("sdl3/power.zig");
pub const PowerState = power_h.PowerState;

//--------------------------------------------------------------------------------------------------
// Process Control (SDL_process.h)
//--------------------------------------------------------------------------------------------------
const process_h = @import("sdl3/process.zig");

//--------------------------------------------------------------------------------------------------
// Message Boxes (SDL_messagebox.h)
//--------------------------------------------------------------------------------------------------
const messagebox_h = @import("sdl3/messagebox.zig");
pub const MessageBoxFlags = messagebox_h.MessageBoxFlags;
pub const showSimpleMessageBox = messagebox_h.showSimpleMessageBox;

//--------------------------------------------------------------------------------------------------
// File Dialogs (SDL_dialog.h)
//--------------------------------------------------------------------------------------------------
const dialog_h = @import("sdl3/dialog.zig");

//--------------------------------------------------------------------------------------------------
// System Tray (SDL_tray.h)
//--------------------------------------------------------------------------------------------------
const tray_h = @import("sdl3/tray.zig");

//--------------------------------------------------------------------------------------------------
// Locale Info (SDL_locale.h)
//--------------------------------------------------------------------------------------------------
const locale_h = @import("sdl3/locale.zig");

//--------------------------------------------------------------------------------------------------
// Platform-specific Functionality (SDL_system.h)
//--------------------------------------------------------------------------------------------------
const system_h = @import("sdl3/system.zig");

//--------------------------------------------------------------------------------------------------
// Standard Library Functionality (SDL_stdinc.h)
//--------------------------------------------------------------------------------------------------
const stdinc_h = @import("sdl3/stdinc.zig");
pub const malloc = stdinc_h.malloc;
pub const free = stdinc_h.free;

//--------------------------------------------------------------------------------------------------
// GUIDs (SDL_guid.h)
//--------------------------------------------------------------------------------------------------
const guid_h = @import("sdl3/guid.zig");

//--------------------------------------------------------------------------------------------------
// Miscellaneous (SDL_misc.h)
//--------------------------------------------------------------------------------------------------
const misc_h = @import("sdl3/misc.zig");

const modules = .{
    main_h,
    init_h,
    hints_h,
    properties_h,
    error_h,
    log_h,
    assert_h,
    version_h,
    video_h,
    render_h,
    pixels_h,
    blendmode_h,
    rect_h,
    surface_h,
    clipboard_h,
    vulkan_h,
    metal_h,
    camera_h,
    events_h,
    keyboard_h,
    scancode_h,
    keycode_h,
    mouse_h,
    joystick_h,
    gamepad_h,
    touch_h,
    pen_h,
    sensor_h,
    hidapi_h,
    haptic_h,
    audio_h,
    gpu_h,
    thread_h,
    mutex_h,
    atomic_h,
    timer_h,
    time_h,
    filesystem_h,
    storage_h,
    iostream_h,
    asyncio_h,
    loadso_h,
    platform_h,
    cpuinfo_h,
    endian_h,
    bits_h,
    power_h,
    process_h,
    messagebox_h,
    dialog_h,
    tray_h,
    locale_h,
    system_h,
    stdinc_h,
    guid_h,
    misc_h,
};
