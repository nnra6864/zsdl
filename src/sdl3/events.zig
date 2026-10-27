//! Event Handling (SDL_events.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

pub const EventType = enum(u32) {
    first = 0,

    quit = 0x100,
    terminating,
    low_memory,
    will_enter_background,
    did_enter_background,
    will_enter_foreground,
    did_enter_foreground,
    locale_changed,
    system_theme_changed,

    // Display events
    // _reserved_sdl2compat_displayevent = 0x150,
    display_orientation = 0x151,
    display_connected,
    display_disconnected,
    display_moved,
    display_content_scale_changed,

    // Window events
    // _reserved_sdl2compat_windowevent = 0x200,
    // _reserved_sdl2compat_syswm = 0x201
    window_shown = 0x202,
    window_hidden,
    window_exposed,
    window_moved,
    window_resized,
    window_pixel_size_changed,
    window_minimized,
    window_maximized,
    window_restored,
    window_mouse_enter,
    window_mouse_leave,
    window_focus_gained,
    window_focus_lost,
    window_close_requested,
    window_take_focus,
    window_hit_test,
    window_iccprof_changed,
    window_display_changed,
    window_display_scale_changed,
    window_destroyed,
    window_hdr_state_changed,

    // Keyboard events
    key_down = 0x300,
    key_up,
    text_editing,
    text_input,
    keymap_changed,
    keyboard_added,
    keyboard_removed,
    text_editing_candidates,

    // Mouse events
    mouse_motion = 0x400,
    mouse_button_down,
    mouse_button_up,
    mouse_wheel,
    mouse_added,
    mouse_removed,

    // Joystick events
    joystick_axis_motion = 0x600,
    joystick_ball_motion,
    joystick_hat_motion,
    joystick_button_down,
    joystick_button_up,
    joystick_added,
    joystick_removed,
    joystick_battery_updated,
    joystick_update_complete,

    // Gamepad events
    gamepad_axis_motion = 0x650,
    gamepad_button_down,
    gamepad_button_up,
    gamepad_added,
    gamepad_removed,
    gamepad_remapped,
    gamepad_touchpad_down,
    gamepad_touchpad_motion,
    gamepad_touchpad_up,
    gamepad_sensor_update,
    gamepad_update_complete,
    gamepad_steam_handle_updated,

    // Touch events
    finger_down = 0x700,
    finger_up,
    finger_motion,
    finger_cancelled,

    // 0x800, 0x801, 0x802 were gesture events from SDL2, reserved for sdl compat
    // _reserved_sdl2compat_dollargesture = 0x800,
    // _reserved_sdl2compat_dollarrecord,
    // _reserved_sdl2compat_multigesture,

    // CLipboard events
    clipboard_update = 0x900,

    // Drag and drop events
    drop_file = 0x1000,
    drop_text,
    drop_begin,
    drop_complete,
    drop_position,

    // Audio hotplug events
    audio_device_added = 0x1100,
    audio_device_removed,
    audio_device_format_changed,

    // Sensor events
    sensor_update = 0x1200,

    // Pressure-sensitive pen events
    pen_proximity_in = 0x1300,
    pen_proximity_out,
    pen_down,
    pen_up,
    pen_button_down,
    pen_button_up,
    pen_motion,
    pen_axis,

    // Camera hotplug events
    camera_device_added = 0x1400,
    camera_device_removed,
    camera_device_approved,
    camera_device_denied,

    // Render events
    render_targets_reset = 0x2000,
    render_device_reset,
    render_device_lost,

    // Reserved events for private platforms
    private0 = 0x4000,
    private1,
    private2,
    private3,

    // Internal events
    poll_sentinel = 0x7f00,

    // 0x8000 to 0xffff are for your own use, and should be allocated with SDL_RegisterEvents
    // user = 0x8000,
    _,
};

pub const CommonEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
};

pub const DisplayEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    display_id: sdl.DisplayId,
    data1: i32,
    data2: i32,
};

pub const WindowEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    window_id: sdl.WindowId,
    data1: i32,
    data2: i32,
};

pub const KeyboardDeviceEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    which: sdl.KeyboardId,
};

pub const KeyboardEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    window_id: sdl.WindowId,
    which: sdl.KeyboardId,
    scancode: sdl.Scancode,
    key: sdl.Keycode,
    mod: sdl.Keymod,
    raw: u16,
    down: bool,
    repeat: bool,
};

pub const TextEditingEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    window_id: sdl.WindowId,
    text: [*c]const u8,
    start: i32,
    length: i32,
};

pub const TextEditingCandidatesEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    window_id: sdl.WindowId,
    candidates: *const [*c]const u8,
    num_candidates: i32,
    selected_candidate: i32,
    horizontal: bool,
    // padding
    _: u8,
    __: u8,
    ___: u8,
};

pub const TextInputEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    window_id: sdl.WindowId,
    text: [*c]const u8,
};

pub const MouseDeviceEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    which: sdl.MouseId,
};

pub const MouseMotionEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    window_id: sdl.WindowId,
    which: sdl.MouseId,
    state: sdl.MouseButtonFlags,
    x: f32,
    y: f32,
    xrel: f32,
    yrel: f32,
};

pub const MouseButtonEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    window_id: sdl.WindowId,
    which: sdl.MouseId,
    button: u8,
    down: bool,
    clicks: u8,
    _: u8, // padding
    x: f32,
    y: f32,
};

pub const MouseWheelEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    window_id: sdl.WindowId,
    which: sdl.MouseId,
    x: f32,
    y: f32,
    direction: sdl.MouseWheelDirection,
    mouse_x: f32,
    mouse_y: f32,
};

pub const JoyAxisEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    which: sdl.Joystick.Id,
    axis: u8,
    // padding
    _: u8,
    __: u8,
    ___: u8,
    value: i16,
    ____: u16, // padding
};

pub const JoyBallEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    which: sdl.Joystick.Id,
    ball: u8,
    // padding
    _: u8,
    __: u8,
    ___: u8,
    xrel: i16,
    yrel: i16,
};

pub const JoyHatEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    which: sdl.Joystick.Id,
    hat: u8,
    value: u8,
    _: u16, // padding
};

pub const JoyButtonEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    which: sdl.Joystick.Id,
    button: u8,
    down: bool,
    _: u16, // padding
};

pub const JoyDeviceEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    which: sdl.Joystick.Id,
};

pub const JoyBatteryEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    which: sdl.Joystick.Id,
    state: sdl.PowerState,
    percent: c_int,
};

pub const GamepadAxisEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    which: sdl.Joystick.Id,
    axis: u8,
    // padding
    _: u8,
    __: u8,
    ___: u8,
    value: i16,
    ____: u16, // padding
};

pub const GamepadButtonEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    which: sdl.Joystick.Id,
    button: u8,
    down: bool,
    _: u16, // padding
};

pub const GamepadDeviceEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    which: sdl.Joystick.Id,
};

pub const GamepadTouchpadEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u32,
    which: sdl.Joystick.Id,
    touchpad: i32,
    finger: i32,
    x: f32,
    y: f32,
    pressure: f32,
};

pub const GamepadSensorEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    which: sdl.Joystick.Id,
    senor: i32,
    data: [3]f32,
    sensor_timestamp: u64,
};

pub const AudioDeviceEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    which: sdl.AudioDeviceId,
    recording: bool,
    // padding
    _: u8,
    __: u8,
    ___: u8,
};

pub const CameraDeviceEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    which: sdl.CameraId,
};

pub const RenderEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    window_id: sdl.WindowId,
};

pub const TouchFingerEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    touch_id: sdl.TouchId,
    finger_id: sdl.FingerId,
    x: f32,
    y: f32,
    dx: f32,
    dy: f32,
    pressure: f32,
    window_id: sdl.WindowId,
};

pub const PenProximityEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    window_id: sdl.WindowId,
    which: sdl.PenId,
};

pub const PenMotionEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    window_id: sdl.WindowId,
    which: sdl.PenId,
    pen_state: sdl.PenInputFlags,
    x: f32,
    y: f32,
};

pub const PenTouchEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    window_id: sdl.WindowId,
    which: sdl.PenId,
    pen_state: sdl.PenInputFlags,
    x: f32,
    y: f32,
    eraser: bool,
    down: bool,
};

pub const PenButtonEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    window_id: sdl.WindowId,
    which: sdl.PenId,
    pen_state: sdl.PenInputFlags,
    x: f32,
    y: f32,
    button: u8,
    down: bool,
};

pub const PenAxisEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    window_id: sdl.WindowId,
    which: sdl.PenId,
    pen_state: sdl.PenInputFlags,
    x: f32,
    y: f32,
    axis: sdl.PenAxis,
    value: f32,
};

pub const DropEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    window_id: sdl.WindowId,
    x: f32,
    y: f32,
    source: [*c]const u8,
    data: [*c]const u8,
};

pub const ClipboardEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    owner: bool,
    num_mime_types: i32,
    mime_types: [*c][*c]const u8,
};

pub const SensorEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    which: sdl.SensorId,
    data: [6]f32,
    sensor_timestamp: u64,
};

pub const QuitEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
};

pub const UserEvent = extern struct {
    type: EventType,
    reserved: u32,
    timestamp: u64,
    window_id: sdl.WindowId,
    code: i32,
    data1: ?*anyopaque,
    data2: ?*anyopaque,
};

pub const Event = extern union {
    type: EventType,
    common: CommonEvent,
    display: DisplayEvent,
    window: WindowEvent,
    kdevice: KeyboardDeviceEvent,
    key: KeyboardEvent,
    edit: TextEditingEvent,
    edit_candidates: TextEditingCandidatesEvent,
    text: TextInputEvent,
    mdevice: MouseDeviceEvent,
    motion: MouseMotionEvent,
    button: MouseButtonEvent,
    wheel: MouseWheelEvent,
    jdevice: JoyDeviceEvent,
    jaxis: JoyAxisEvent,
    jball: JoyBallEvent,
    jhat: JoyHatEvent,
    jbutton: JoyButtonEvent,
    jbattery: JoyBatteryEvent,
    gdevice: GamepadDeviceEvent,
    gaxis: GamepadAxisEvent,
    gbutton: GamepadButtonEvent,
    gtouchpad: GamepadTouchpadEvent,
    gsensor: GamepadSensorEvent,
    adevice: AudioDeviceEvent,
    cdevice: CameraDeviceEvent,
    sensor: SensorEvent,
    quit: QuitEvent,
    user: UserEvent,
    tfinger: TouchFingerEvent,
    pproximity: PenProximityEvent,
    ptouch: PenTouchEvent,
    pmotion: PenMotionEvent,
    pbutton: PenButtonEvent,
    paxis: PenAxisEvent,
    render: RenderEvent,
    drop: DropEvent,
    clipboard: ClipboardEvent,
    _: [128]u8, // padding
};

/// Pump the event loop, gathering events from the input devices.
pub const pumpEvents = SDL_PumpEvents;
extern fn SDL_PumpEvents() void;

/// The type of action to request from SDL_PeepEvents().
pub const EventAction = enum(c_int) {
    /// Add events to the back of the queue.
    addevent,
    /// Check but don't remove events from the queue front.
    peekevent,
    /// Retrieve/remove events from the front of the queue.
    getevent,
};

// TODO
// - SDL_PeepEvents
// - SDL_HasEvent
// - SDL_HasEvents
// - SDL_FlushEvent
// - SDL_FlushEvents

pub const pollEvent = SDL_PollEvent;
extern fn SDL_PollEvent(event: ?*Event) bool;

// TODO
// - SDL_WaitEvent
// - SDL_WaitEventTimeout

/// You should set the common.timestamp field before passing an event to `pushEvent`.
/// If the timestamp is 0 it will be filled in with `getTicksNS()`.
/// Returns true if event was added, false if event was filtered out or on failure;
/// call SDL_GetError() for more information.
pub const pushEvent = SDL_PushEvent;
extern fn SDL_PushEvent(event: *Event) bool;

/// A function pointer used for callbacks that watch the event queue.
pub const EventFilter = fn (userdata: ?*anyopaque, event: *Event) bool;

// TODO
// - SDL_SetEventFilter
// - SDL_GetEventFilter
// - SDL_AddEventWatch
// - SDL_RemoveEventWatch
// - SDL_FilterEvents
// - SDL_SetEventEnabled
// - SDL_EventEnabled
// - SDL_RegisterEvents
// - SDL_GetWindowFromEvent
