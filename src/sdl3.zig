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
    @setEvalBranchQuota(100_000);
    inline for (modules) |M| {
        inline for (comptime std.meta.declarations(M)) |decl| {
            if (!@hasDecl(@This(), decl)) @compileError("missing re-export: " ++ decl);
        }
    }
}

fn refAllDeclsRecursive(comptime T: type, comptime depth: u32) void {
    @setEvalBranchQuota(100_000);
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
    const str = getError();
    if (str.len > 0) logError(.@"error", "{s}", .{str});
    return error.SdlError;
}

// @generated-exports
// Everything below is re-exported from src/sdl3/*.zig, in header declaration order.

//--------------------------------------------------------------------------------------------------
// Application entry points (SDL_main.h)
//--------------------------------------------------------------------------------------------------
const main_h = @import("sdl3/main.zig");
pub const MainFn = main_h.MainFn;
pub const setMainReady = main_h.setMainReady;
pub const runApp = main_h.runApp;
pub const enterAppMainCallbacks = main_h.enterAppMainCallbacks;
pub const registerApp = main_h.registerApp;
pub const unregisterApp = main_h.unregisterApp;
pub const gdkSuspendComplete = main_h.gdkSuspendComplete;

//--------------------------------------------------------------------------------------------------
// Initialization and Shutdown (SDL_init.h)
//--------------------------------------------------------------------------------------------------
const init_h = @import("sdl3/init.zig");
pub const InitFlags = init_h.InitFlags;
pub const AppResult = init_h.AppResult;
pub const AppInitFn = init_h.AppInitFn;
pub const AppIterateFn = init_h.AppIterateFn;
pub const AppEventFn = init_h.AppEventFn;
pub const AppQuitFn = init_h.AppQuitFn;
pub const init = init_h.init;
pub const initSubSystem = init_h.initSubSystem;
pub const quitSubSystem = init_h.quitSubSystem;
pub const wasInit = init_h.wasInit;
pub const quit = init_h.quit;
pub const isMainThread = init_h.isMainThread;
pub const MainThreadCallback = init_h.MainThreadCallback;
pub const runOnMainThread = init_h.runOnMainThread;
pub const setAppMetadata = init_h.setAppMetadata;
pub const setAppMetadataProperty = init_h.setAppMetadataProperty;
pub const prop_app_metadata_name_string = init_h.prop_app_metadata_name_string;
pub const prop_app_metadata_version_string = init_h.prop_app_metadata_version_string;
pub const prop_app_metadata_identifier_string = init_h.prop_app_metadata_identifier_string;
pub const prop_app_metadata_creator_string = init_h.prop_app_metadata_creator_string;
pub const prop_app_metadata_copyright_string = init_h.prop_app_metadata_copyright_string;
pub const prop_app_metadata_url_string = init_h.prop_app_metadata_url_string;
pub const prop_app_metadata_type_string = init_h.prop_app_metadata_type_string;
pub const getAppMetadataProperty = init_h.getAppMetadataProperty;

//--------------------------------------------------------------------------------------------------
// Configuration Variables (SDL_hints.h)
//--------------------------------------------------------------------------------------------------
const hints_h = @import("sdl3/hints.zig");
pub const hint_allow_alt_tab_while_grabbed = hints_h.hint_allow_alt_tab_while_grabbed;
pub const hint_android_allow_recreate_activity = hints_h.hint_android_allow_recreate_activity;
pub const hint_android_block_on_pause = hints_h.hint_android_block_on_pause;
pub const hint_android_low_latency_audio = hints_h.hint_android_low_latency_audio;
pub const hint_android_trap_back_button = hints_h.hint_android_trap_back_button;
pub const hint_app_id = hints_h.hint_app_id;
pub const hint_app_name = hints_h.hint_app_name;
pub const hint_apple_tv_controller_ui_events = hints_h.hint_apple_tv_controller_ui_events;
pub const hint_apple_tv_remote_allow_rotation = hints_h.hint_apple_tv_remote_allow_rotation;
pub const hint_audio_alsa_default_device = hints_h.hint_audio_alsa_default_device;
pub const hint_audio_alsa_default_playback_device = hints_h.hint_audio_alsa_default_playback_device;
pub const hint_audio_alsa_default_recording_device = hints_h.hint_audio_alsa_default_recording_device;
pub const hint_audio_category = hints_h.hint_audio_category;
pub const hint_audio_channels = hints_h.hint_audio_channels;
pub const hint_audio_device_app_icon_name = hints_h.hint_audio_device_app_icon_name;
pub const hint_audio_device_sample_frames = hints_h.hint_audio_device_sample_frames;
pub const hint_audio_device_stream_name = hints_h.hint_audio_device_stream_name;
pub const hint_audio_device_stream_role = hints_h.hint_audio_device_stream_role;
pub const hint_audio_disk_input_file = hints_h.hint_audio_disk_input_file;
pub const hint_audio_disk_output_file = hints_h.hint_audio_disk_output_file;
pub const hint_audio_disk_timescale = hints_h.hint_audio_disk_timescale;
pub const hint_audio_driver = hints_h.hint_audio_driver;
pub const hint_audio_dummy_timescale = hints_h.hint_audio_dummy_timescale;
pub const hint_audio_format = hints_h.hint_audio_format;
pub const hint_audio_frequency = hints_h.hint_audio_frequency;
pub const hint_audio_include_monitors = hints_h.hint_audio_include_monitors;
pub const hint_auto_update_joysticks = hints_h.hint_auto_update_joysticks;
pub const hint_auto_update_sensors = hints_h.hint_auto_update_sensors;
pub const hint_bmp_save_legacy_format = hints_h.hint_bmp_save_legacy_format;
pub const hint_camera_driver = hints_h.hint_camera_driver;
pub const hint_cpu_feature_mask = hints_h.hint_cpu_feature_mask;
pub const hint_joystick_directinput = hints_h.hint_joystick_directinput;
pub const hint_file_dialog_driver = hints_h.hint_file_dialog_driver;
pub const hint_display_usable_bounds = hints_h.hint_display_usable_bounds;
pub const hint_emscripten_asyncify = hints_h.hint_emscripten_asyncify;
pub const hint_emscripten_canvas_selector = hints_h.hint_emscripten_canvas_selector;
pub const hint_emscripten_keyboard_element = hints_h.hint_emscripten_keyboard_element;
pub const hint_enable_screen_keyboard = hints_h.hint_enable_screen_keyboard;
pub const hint_evdev_devices = hints_h.hint_evdev_devices;
pub const hint_event_logging = hints_h.hint_event_logging;
pub const hint_force_raisewindow = hints_h.hint_force_raisewindow;
pub const hint_framebuffer_acceleration = hints_h.hint_framebuffer_acceleration;
pub const hint_gamecontrollerconfig = hints_h.hint_gamecontrollerconfig;
pub const hint_gamecontrollerconfig_file = hints_h.hint_gamecontrollerconfig_file;
pub const hint_gamecontrollertype = hints_h.hint_gamecontrollertype;
pub const hint_gamecontroller_ignore_devices = hints_h.hint_gamecontroller_ignore_devices;
pub const hint_gamecontroller_ignore_devices_except = hints_h.hint_gamecontroller_ignore_devices_except;
pub const hint_gamecontroller_sensor_fusion = hints_h.hint_gamecontroller_sensor_fusion;
pub const hint_gdk_textinput_default_text = hints_h.hint_gdk_textinput_default_text;
pub const hint_gdk_textinput_description = hints_h.hint_gdk_textinput_description;
pub const hint_gdk_textinput_max_length = hints_h.hint_gdk_textinput_max_length;
pub const hint_gdk_textinput_scope = hints_h.hint_gdk_textinput_scope;
pub const hint_gdk_textinput_title = hints_h.hint_gdk_textinput_title;
pub const hint_hidapi_libusb = hints_h.hint_hidapi_libusb;
pub const hint_hidapi_libusb_whitelist = hints_h.hint_hidapi_libusb_whitelist;
pub const hint_hidapi_udev = hints_h.hint_hidapi_udev;
pub const hint_gpu_driver = hints_h.hint_gpu_driver;
pub const hint_hidapi_enumerate_only_controllers = hints_h.hint_hidapi_enumerate_only_controllers;
pub const hint_hidapi_ignore_devices = hints_h.hint_hidapi_ignore_devices;
pub const hint_ime_implemented_ui = hints_h.hint_ime_implemented_ui;
pub const hint_ios_hide_home_indicator = hints_h.hint_ios_hide_home_indicator;
pub const hint_joystick_allow_background_events = hints_h.hint_joystick_allow_background_events;
pub const hint_joystick_arcadestick_devices = hints_h.hint_joystick_arcadestick_devices;
pub const hint_joystick_arcadestick_devices_excluded = hints_h.hint_joystick_arcadestick_devices_excluded;
pub const hint_joystick_blacklist_devices = hints_h.hint_joystick_blacklist_devices;
pub const hint_joystick_blacklist_devices_excluded = hints_h.hint_joystick_blacklist_devices_excluded;
pub const hint_joystick_device = hints_h.hint_joystick_device;
pub const hint_joystick_enhanced_reports = hints_h.hint_joystick_enhanced_reports;
pub const hint_joystick_flightstick_devices = hints_h.hint_joystick_flightstick_devices;
pub const hint_joystick_flightstick_devices_excluded = hints_h.hint_joystick_flightstick_devices_excluded;
pub const hint_joystick_gameinput = hints_h.hint_joystick_gameinput;
pub const hint_joystick_gamecube_devices = hints_h.hint_joystick_gamecube_devices;
pub const hint_joystick_gamecube_devices_excluded = hints_h.hint_joystick_gamecube_devices_excluded;
pub const hint_joystick_hidapi = hints_h.hint_joystick_hidapi;
pub const hint_joystick_hidapi_combine_joy_cons = hints_h.hint_joystick_hidapi_combine_joy_cons;
pub const hint_joystick_hidapi_gamecube = hints_h.hint_joystick_hidapi_gamecube;
pub const hint_joystick_hidapi_gamecube_rumble_brake = hints_h.hint_joystick_hidapi_gamecube_rumble_brake;
pub const hint_joystick_hidapi_joy_cons = hints_h.hint_joystick_hidapi_joy_cons;
pub const hint_joystick_hidapi_joycon_home_led = hints_h.hint_joystick_hidapi_joycon_home_led;
pub const hint_joystick_hidapi_luna = hints_h.hint_joystick_hidapi_luna;
pub const hint_joystick_hidapi_nintendo_classic = hints_h.hint_joystick_hidapi_nintendo_classic;
pub const hint_joystick_hidapi_ps3 = hints_h.hint_joystick_hidapi_ps3;
pub const hint_joystick_hidapi_ps3_sixaxis_driver = hints_h.hint_joystick_hidapi_ps3_sixaxis_driver;
pub const hint_joystick_hidapi_ps4 = hints_h.hint_joystick_hidapi_ps4;
pub const hint_joystick_hidapi_ps4_report_interval = hints_h.hint_joystick_hidapi_ps4_report_interval;
pub const hint_joystick_hidapi_ps5 = hints_h.hint_joystick_hidapi_ps5;
pub const hint_joystick_hidapi_ps5_player_led = hints_h.hint_joystick_hidapi_ps5_player_led;
pub const hint_joystick_hidapi_shield = hints_h.hint_joystick_hidapi_shield;
pub const hint_joystick_hidapi_stadia = hints_h.hint_joystick_hidapi_stadia;
pub const hint_joystick_hidapi_steam = hints_h.hint_joystick_hidapi_steam;
pub const hint_joystick_hidapi_steam_home_led = hints_h.hint_joystick_hidapi_steam_home_led;
pub const hint_joystick_hidapi_steamdeck = hints_h.hint_joystick_hidapi_steamdeck;
pub const hint_joystick_hidapi_steam_hori = hints_h.hint_joystick_hidapi_steam_hori;
pub const hint_joystick_hidapi_switch = hints_h.hint_joystick_hidapi_switch;
pub const hint_joystick_hidapi_switch_home_led = hints_h.hint_joystick_hidapi_switch_home_led;
pub const hint_joystick_hidapi_switch_player_led = hints_h.hint_joystick_hidapi_switch_player_led;
pub const hint_joystick_hidapi_vertical_joy_cons = hints_h.hint_joystick_hidapi_vertical_joy_cons;
pub const hint_joystick_hidapi_wii = hints_h.hint_joystick_hidapi_wii;
pub const hint_joystick_hidapi_wii_player_led = hints_h.hint_joystick_hidapi_wii_player_led;
pub const hint_joystick_hidapi_xbox = hints_h.hint_joystick_hidapi_xbox;
pub const hint_joystick_hidapi_xbox_360 = hints_h.hint_joystick_hidapi_xbox_360;
pub const hint_joystick_hidapi_xbox_360_player_led = hints_h.hint_joystick_hidapi_xbox_360_player_led;
pub const hint_joystick_hidapi_xbox_360_wireless = hints_h.hint_joystick_hidapi_xbox_360_wireless;
pub const hint_joystick_hidapi_xbox_one = hints_h.hint_joystick_hidapi_xbox_one;
pub const hint_joystick_hidapi_xbox_one_home_led = hints_h.hint_joystick_hidapi_xbox_one_home_led;
pub const hint_joystick_iokit = hints_h.hint_joystick_iokit;
pub const hint_joystick_linux_classic = hints_h.hint_joystick_linux_classic;
pub const hint_joystick_linux_deadzones = hints_h.hint_joystick_linux_deadzones;
pub const hint_joystick_linux_digital_hats = hints_h.hint_joystick_linux_digital_hats;
pub const hint_joystick_linux_hat_deadzones = hints_h.hint_joystick_linux_hat_deadzones;
pub const hint_joystick_mfi = hints_h.hint_joystick_mfi;
pub const hint_joystick_rawinput = hints_h.hint_joystick_rawinput;
pub const hint_joystick_rawinput_correlate_xinput = hints_h.hint_joystick_rawinput_correlate_xinput;
pub const hint_joystick_rog_chakram = hints_h.hint_joystick_rog_chakram;
pub const hint_joystick_thread = hints_h.hint_joystick_thread;
pub const hint_joystick_throttle_devices = hints_h.hint_joystick_throttle_devices;
pub const hint_joystick_throttle_devices_excluded = hints_h.hint_joystick_throttle_devices_excluded;
pub const hint_joystick_wgi = hints_h.hint_joystick_wgi;
pub const hint_joystick_wheel_devices = hints_h.hint_joystick_wheel_devices;
pub const hint_joystick_wheel_devices_excluded = hints_h.hint_joystick_wheel_devices_excluded;
pub const hint_joystick_zero_centered_devices = hints_h.hint_joystick_zero_centered_devices;
pub const hint_joystick_haptic_axes = hints_h.hint_joystick_haptic_axes;
pub const hint_keycode_options = hints_h.hint_keycode_options;
pub const hint_kmsdrm_device_index = hints_h.hint_kmsdrm_device_index;
pub const hint_kmsdrm_require_drm_master = hints_h.hint_kmsdrm_require_drm_master;
pub const hint_logging = hints_h.hint_logging;
pub const hint_mac_background_app = hints_h.hint_mac_background_app;
pub const hint_mac_ctrl_click_emulate_right_click = hints_h.hint_mac_ctrl_click_emulate_right_click;
pub const hint_mac_opengl_async_dispatch = hints_h.hint_mac_opengl_async_dispatch;
pub const hint_mac_option_as_alt = hints_h.hint_mac_option_as_alt;
pub const hint_mac_scroll_momentum = hints_h.hint_mac_scroll_momentum;
pub const hint_main_callback_rate = hints_h.hint_main_callback_rate;
pub const hint_mouse_auto_capture = hints_h.hint_mouse_auto_capture;
pub const hint_mouse_double_click_radius = hints_h.hint_mouse_double_click_radius;
pub const hint_mouse_double_click_time = hints_h.hint_mouse_double_click_time;
pub const hint_mouse_default_system_cursor = hints_h.hint_mouse_default_system_cursor;
pub const hint_mouse_emulate_warp_with_relative = hints_h.hint_mouse_emulate_warp_with_relative;
pub const hint_mouse_focus_clickthrough = hints_h.hint_mouse_focus_clickthrough;
pub const hint_mouse_normal_speed_scale = hints_h.hint_mouse_normal_speed_scale;
pub const hint_mouse_relative_mode_center = hints_h.hint_mouse_relative_mode_center;
pub const hint_mouse_relative_speed_scale = hints_h.hint_mouse_relative_speed_scale;
pub const hint_mouse_relative_system_scale = hints_h.hint_mouse_relative_system_scale;
pub const hint_mouse_relative_warp_motion = hints_h.hint_mouse_relative_warp_motion;
pub const hint_mouse_relative_cursor_visible = hints_h.hint_mouse_relative_cursor_visible;
pub const hint_mouse_touch_events = hints_h.hint_mouse_touch_events;
pub const hint_mute_console_keyboard = hints_h.hint_mute_console_keyboard;
pub const hint_no_signal_handlers = hints_h.hint_no_signal_handlers;
pub const hint_opengl_library = hints_h.hint_opengl_library;
pub const hint_egl_library = hints_h.hint_egl_library;
pub const hint_opengl_es_driver = hints_h.hint_opengl_es_driver;
pub const hint_openvr_library = hints_h.hint_openvr_library;
pub const hint_orientations = hints_h.hint_orientations;
pub const hint_poll_sentinel = hints_h.hint_poll_sentinel;
pub const hint_preferred_locales = hints_h.hint_preferred_locales;
pub const hint_quit_on_last_window_close = hints_h.hint_quit_on_last_window_close;
pub const hint_render_direct3d_threadsafe = hints_h.hint_render_direct3d_threadsafe;
pub const hint_render_direct3d11_debug = hints_h.hint_render_direct3d11_debug;
pub const hint_render_vulkan_debug = hints_h.hint_render_vulkan_debug;
pub const hint_render_gpu_debug = hints_h.hint_render_gpu_debug;
pub const hint_render_gpu_low_power = hints_h.hint_render_gpu_low_power;
pub const hint_render_driver = hints_h.hint_render_driver;
pub const hint_render_line_method = hints_h.hint_render_line_method;
pub const hint_render_metal_prefer_low_power_device = hints_h.hint_render_metal_prefer_low_power_device;
pub const hint_render_vsync = hints_h.hint_render_vsync;
pub const hint_return_key_hides_ime = hints_h.hint_return_key_hides_ime;
pub const hint_rog_gamepad_mice = hints_h.hint_rog_gamepad_mice;
pub const hint_rog_gamepad_mice_excluded = hints_h.hint_rog_gamepad_mice_excluded;
pub const hint_rpi_video_layer = hints_h.hint_rpi_video_layer;
pub const hint_screensaver_inhibit_activity_name = hints_h.hint_screensaver_inhibit_activity_name;
pub const hint_shutdown_dbus_on_quit = hints_h.hint_shutdown_dbus_on_quit;
pub const hint_storage_title_driver = hints_h.hint_storage_title_driver;
pub const hint_storage_user_driver = hints_h.hint_storage_user_driver;
pub const hint_thread_force_realtime_time_critical = hints_h.hint_thread_force_realtime_time_critical;
pub const hint_thread_priority_policy = hints_h.hint_thread_priority_policy;
pub const hint_timer_resolution = hints_h.hint_timer_resolution;
pub const hint_touch_mouse_events = hints_h.hint_touch_mouse_events;
pub const hint_trackpad_is_touch_only = hints_h.hint_trackpad_is_touch_only;
pub const hint_tv_remote_as_joystick = hints_h.hint_tv_remote_as_joystick;
pub const hint_video_allow_screensaver = hints_h.hint_video_allow_screensaver;
pub const hint_video_display_priority = hints_h.hint_video_display_priority;
pub const hint_video_double_buffer = hints_h.hint_video_double_buffer;
pub const hint_video_driver = hints_h.hint_video_driver;
pub const hint_video_dummy_save_frames = hints_h.hint_video_dummy_save_frames;
pub const hint_video_egl_allow_getdisplay_fallback = hints_h.hint_video_egl_allow_getdisplay_fallback;
pub const hint_video_force_egl = hints_h.hint_video_force_egl;
pub const hint_video_mac_fullscreen_spaces = hints_h.hint_video_mac_fullscreen_spaces;
pub const hint_video_mac_fullscreen_menu_visibility = hints_h.hint_video_mac_fullscreen_menu_visibility;
pub const hint_video_minimize_on_focus_loss = hints_h.hint_video_minimize_on_focus_loss;
pub const hint_video_offscreen_save_frames = hints_h.hint_video_offscreen_save_frames;
pub const hint_video_sync_window_operations = hints_h.hint_video_sync_window_operations;
pub const hint_video_wayland_allow_libdecor = hints_h.hint_video_wayland_allow_libdecor;
pub const hint_video_wayland_mode_emulation = hints_h.hint_video_wayland_mode_emulation;
pub const hint_video_wayland_mode_scaling = hints_h.hint_video_wayland_mode_scaling;
pub const hint_video_wayland_prefer_libdecor = hints_h.hint_video_wayland_prefer_libdecor;
pub const hint_video_wayland_scale_to_display = hints_h.hint_video_wayland_scale_to_display;
pub const hint_video_win_d3dcompiler = hints_h.hint_video_win_d3dcompiler;
pub const hint_video_x11_external_window_input = hints_h.hint_video_x11_external_window_input;
pub const hint_video_x11_net_wm_bypass_compositor = hints_h.hint_video_x11_net_wm_bypass_compositor;
pub const hint_video_x11_net_wm_ping = hints_h.hint_video_x11_net_wm_ping;
pub const hint_video_x11_nodirectcolor = hints_h.hint_video_x11_nodirectcolor;
pub const hint_video_x11_scaling_factor = hints_h.hint_video_x11_scaling_factor;
pub const hint_video_x11_visualid = hints_h.hint_video_x11_visualid;
pub const hint_video_x11_window_visualid = hints_h.hint_video_x11_window_visualid;
pub const hint_video_x11_xrandr = hints_h.hint_video_x11_xrandr;
pub const hint_vita_enable_back_touch = hints_h.hint_vita_enable_back_touch;
pub const hint_vita_enable_front_touch = hints_h.hint_vita_enable_front_touch;
pub const hint_vita_module_path = hints_h.hint_vita_module_path;
pub const hint_vita_pvr_init = hints_h.hint_vita_pvr_init;
pub const hint_vita_resolution = hints_h.hint_vita_resolution;
pub const hint_vita_pvr_opengl = hints_h.hint_vita_pvr_opengl;
pub const hint_vita_touch_mouse_device = hints_h.hint_vita_touch_mouse_device;
pub const hint_vulkan_display = hints_h.hint_vulkan_display;
pub const hint_vulkan_library = hints_h.hint_vulkan_library;
pub const hint_wave_fact_chunk = hints_h.hint_wave_fact_chunk;
pub const hint_wave_chunk_limit = hints_h.hint_wave_chunk_limit;
pub const hint_wave_riff_chunk_size = hints_h.hint_wave_riff_chunk_size;
pub const hint_wave_truncation = hints_h.hint_wave_truncation;
pub const hint_window_activate_when_raised = hints_h.hint_window_activate_when_raised;
pub const hint_window_activate_when_shown = hints_h.hint_window_activate_when_shown;
pub const hint_window_allow_topmost = hints_h.hint_window_allow_topmost;
pub const hint_window_frame_usable_while_cursor_hidden = hints_h.hint_window_frame_usable_while_cursor_hidden;
pub const hint_windows_close_on_alt_f4 = hints_h.hint_windows_close_on_alt_f4;
pub const hint_windows_enable_menu_mnemonics = hints_h.hint_windows_enable_menu_mnemonics;
pub const hint_windows_enable_messageloop = hints_h.hint_windows_enable_messageloop;
pub const hint_windows_gameinput = hints_h.hint_windows_gameinput;
pub const hint_windows_raw_keyboard = hints_h.hint_windows_raw_keyboard;
pub const hint_windows_force_semaphore_kernel = hints_h.hint_windows_force_semaphore_kernel;
pub const hint_windows_intresource_icon = hints_h.hint_windows_intresource_icon;
pub const hint_windows_intresource_icon_small = hints_h.hint_windows_intresource_icon_small;
pub const hint_windows_use_d3d9ex = hints_h.hint_windows_use_d3d9ex;
pub const hint_windows_erase_background_mode = hints_h.hint_windows_erase_background_mode;
pub const hint_x11_force_override_redirect = hints_h.hint_x11_force_override_redirect;
pub const hint_x11_window_type = hints_h.hint_x11_window_type;
pub const hint_x11_xcb_library = hints_h.hint_x11_xcb_library;
pub const hint_xinput_enabled = hints_h.hint_xinput_enabled;
pub const hint_assert = hints_h.hint_assert;
pub const hint_pen_mouse_events = hints_h.hint_pen_mouse_events;
pub const hint_pen_touch_events = hints_h.hint_pen_touch_events;
pub const HintPriority = hints_h.HintPriority;
pub const setHintWithPriority = hints_h.setHintWithPriority;
pub const setHint = hints_h.setHint;
pub const resetHint = hints_h.resetHint;
pub const resetHints = hints_h.resetHints;
pub const getHint = hints_h.getHint;
pub const getHintBoolean = hints_h.getHintBoolean;
pub const HintCallback = hints_h.HintCallback;
pub const addHintCallback = hints_h.addHintCallback;
pub const removeHintCallback = hints_h.removeHintCallback;

//--------------------------------------------------------------------------------------------------
// Object Properties (SDL_properties.h)
//--------------------------------------------------------------------------------------------------
const properties_h = @import("sdl3/properties.zig");
pub const PropertiesId = properties_h.PropertiesId;
pub const PropertyType = properties_h.PropertyType;
pub const getGlobalProperties = properties_h.getGlobalProperties;
pub const createProperties = properties_h.createProperties;
pub const copyProperties = properties_h.copyProperties;
pub const lockProperties = properties_h.lockProperties;
pub const unlockProperties = properties_h.unlockProperties;
pub const CleanupPropertyCallback = properties_h.CleanupPropertyCallback;
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
pub const EnumeratePropertiesCallback = properties_h.EnumeratePropertiesCallback;
pub const enumerateProperties = properties_h.enumerateProperties;
pub const destroyProperties = properties_h.destroyProperties;

//--------------------------------------------------------------------------------------------------
// Error Handling (SDL_error.h)
//--------------------------------------------------------------------------------------------------
const error_h = @import("sdl3/error.zig");
pub const setError = error_h.setError;
pub const setErrorV = error_h.setErrorV;
pub const outOfMemory = error_h.outOfMemory;
pub const getError = error_h.getError;
pub const clearError = error_h.clearError;

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
pub const logMessageV = log_h.logMessageV;
pub const LogOutputFunction = log_h.LogOutputFunction;
pub const getDefaultLogOutputFunction = log_h.getDefaultLogOutputFunction;
pub const getLogOutputFunction = log_h.getLogOutputFunction;
pub const setLogOutputFunction = log_h.setLogOutputFunction;

//--------------------------------------------------------------------------------------------------
// Assertions (SDL_assert.h)
//--------------------------------------------------------------------------------------------------
const assert_h = @import("sdl3/assert.zig");
pub const AssertState = assert_h.AssertState;
pub const AssertData = assert_h.AssertData;
pub const reportAssertion = assert_h.reportAssertion;
pub const AssertionHandler = assert_h.AssertionHandler;
pub const setAssertionHandler = assert_h.setAssertionHandler;
pub const getDefaultAssertionHandler = assert_h.getDefaultAssertionHandler;
pub const getAssertionHandler = assert_h.getAssertionHandler;
pub const getAssertionReport = assert_h.getAssertionReport;
pub const resetAssertionReport = assert_h.resetAssertionReport;

//--------------------------------------------------------------------------------------------------
// Querying SDL Version (SDL_version.h)
//--------------------------------------------------------------------------------------------------
const version_h = @import("sdl3/version.zig");
pub const major_version = version_h.major_version;
pub const minor_version = version_h.minor_version;
pub const micro_version = version_h.micro_version;
pub const Version = version_h.Version;
pub const versionNum = version_h.versionNum;
pub const versionNumMajor = version_h.versionNumMajor;
pub const versionNumMinor = version_h.versionNumMinor;
pub const versionNumMicro = version_h.versionNumMicro;
pub const version = version_h.version;
pub const versionAtLeast = version_h.versionAtLeast;
pub const getVersion = version_h.getVersion;
pub const getRevision = version_h.getRevision;

//--------------------------------------------------------------------------------------------------
// Display and Window Management (SDL_video.h)
//--------------------------------------------------------------------------------------------------
const video_h = @import("sdl3/video.zig");
pub const DisplayId = video_h.DisplayId;
pub const WindowId = video_h.WindowId;
pub const prop_global_video_wayland_wl_display_pointer = video_h.prop_global_video_wayland_wl_display_pointer;
pub const SystemTheme = video_h.SystemTheme;
pub const DisplayModeData = video_h.DisplayModeData;
pub const DisplayMode = video_h.DisplayMode;
pub const DisplayOrientation = video_h.DisplayOrientation;
pub const Window = video_h.Window;
pub const WindowFlags = video_h.WindowFlags;
pub const posUndefinedDisplay = video_h.posUndefinedDisplay;
pub const pos_undefined = video_h.pos_undefined;
pub const posIsUndefined = video_h.posIsUndefined;
pub const posCenteredDisplay = video_h.posCenteredDisplay;
pub const pos_centered = video_h.pos_centered;
pub const posIsCentered = video_h.posIsCentered;
pub const FlashOperation = video_h.FlashOperation;
pub const GLContext = video_h.GLContext;
pub const GLContextState = video_h.GLContextState;
pub const EGLDisplay = video_h.EGLDisplay;
pub const EGLConfig = video_h.EGLConfig;
pub const EGLSurface = video_h.EGLSurface;
pub const EGLAttrib = video_h.EGLAttrib;
pub const EGLint = video_h.EGLint;
pub const EGLAttribArrayCallback = video_h.EGLAttribArrayCallback;
pub const EGLIntArrayCallback = video_h.EGLIntArrayCallback;
pub const egl = video_h.egl;
pub const gl = video_h.gl;
pub const getNumVideoDrivers = video_h.getNumVideoDrivers;
pub const getVideoDriver = video_h.getVideoDriver;
pub const getCurrentVideoDriver = video_h.getCurrentVideoDriver;
pub const getSystemTheme = video_h.getSystemTheme;
pub const getDisplays = video_h.getDisplays;
pub const getPrimaryDisplay = video_h.getPrimaryDisplay;
pub const getDisplayProperties = video_h.getDisplayProperties;
pub const getDisplayName = video_h.getDisplayName;
pub const getDisplayBounds = video_h.getDisplayBounds;
pub const getDisplayUsableBounds = video_h.getDisplayUsableBounds;
pub const getNaturalDisplayOrientation = video_h.getNaturalDisplayOrientation;
pub const getCurrentDisplayOrientation = video_h.getCurrentDisplayOrientation;
pub const getDisplayContentScale = video_h.getDisplayContentScale;
pub const getFullscreenDisplayModes = video_h.getFullscreenDisplayModes;
pub const getClosestFullscreenDisplayMode = video_h.getClosestFullscreenDisplayMode;
pub const getDesktopDisplayMode = video_h.getDesktopDisplayMode;
pub const getCurrentDisplayMode = video_h.getCurrentDisplayMode;
pub const getDisplayForPoint = video_h.getDisplayForPoint;
pub const getDisplayForRect = video_h.getDisplayForRect;
pub const getDisplayForWindow = video_h.getDisplayForWindow;
pub const getWindowPixelDensity = video_h.getWindowPixelDensity;
pub const getWindowDisplayScale = video_h.getWindowDisplayScale;
pub const setWindowFullscreenMode = video_h.setWindowFullscreenMode;
pub const getWindowFullscreenMode = video_h.getWindowFullscreenMode;
pub const getWindowICCProfile = video_h.getWindowICCProfile;
pub const getWindowPixelFormat = video_h.getWindowPixelFormat;
pub const getWindows = video_h.getWindows;
pub const createWindow = video_h.createWindow;
pub const createPopupWindow = video_h.createPopupWindow;
pub const createWindowWithProperties = video_h.createWindowWithProperties;
pub const getWindowId = video_h.getWindowId;
pub const getWindowFromId = video_h.getWindowFromId;
pub const getWindowParent = video_h.getWindowParent;
pub const getWindowProperties = video_h.getWindowProperties;
pub const getWindowFlags = video_h.getWindowFlags;
pub const setWindowTitle = video_h.setWindowTitle;
pub const getWindowTitle = video_h.getWindowTitle;
pub const setWindowIcon = video_h.setWindowIcon;
pub const setWindowPosition = video_h.setWindowPosition;
pub const getWindowPosition = video_h.getWindowPosition;
pub const setWindowSize = video_h.setWindowSize;
pub const getWindowSize = video_h.getWindowSize;
pub const getWindowSafeArea = video_h.getWindowSafeArea;
pub const setWindowAspectRatio = video_h.setWindowAspectRatio;
pub const getWindowAspectRatio = video_h.getWindowAspectRatio;
pub const getWindowBordersSize = video_h.getWindowBordersSize;
pub const getWindowSizeInPixels = video_h.getWindowSizeInPixels;
pub const setWindowMinimumSize = video_h.setWindowMinimumSize;
pub const getWindowMinimumSize = video_h.getWindowMinimumSize;
pub const setWindowMaximumSize = video_h.setWindowMaximumSize;
pub const getWindowMaximumSize = video_h.getWindowMaximumSize;
pub const setWindowBordered = video_h.setWindowBordered;
pub const setWindowResizable = video_h.setWindowResizable;
pub const setWindowAlwaysOnTop = video_h.setWindowAlwaysOnTop;
pub const showWindow = video_h.showWindow;
pub const hideWindow = video_h.hideWindow;
pub const raiseWindow = video_h.raiseWindow;
pub const maximizeWindow = video_h.maximizeWindow;
pub const minimizeWindow = video_h.minimizeWindow;
pub const restoreWindow = video_h.restoreWindow;
pub const setWindowFullscreen = video_h.setWindowFullscreen;
pub const syncWindow = video_h.syncWindow;
pub const windowHasSurface = video_h.windowHasSurface;
pub const getWindowSurface = video_h.getWindowSurface;
pub const setWindowSurfaceVSync = video_h.setWindowSurfaceVSync;
pub const window_surface_vsync_disabled = video_h.window_surface_vsync_disabled;
pub const window_surface_vsync_adaptive = video_h.window_surface_vsync_adaptive;
pub const getWindowSurfaceVSync = video_h.getWindowSurfaceVSync;
pub const updateWindowSurface = video_h.updateWindowSurface;
pub const updateWindowSurfaceRects = video_h.updateWindowSurfaceRects;
pub const destroyWindowSurface = video_h.destroyWindowSurface;
pub const setWindowKeyboardGrab = video_h.setWindowKeyboardGrab;
pub const setWindowMouseGrab = video_h.setWindowMouseGrab;
pub const getWindowKeyboardGrab = video_h.getWindowKeyboardGrab;
pub const getWindowMouseGrab = video_h.getWindowMouseGrab;
pub const getGrabbedWindow = video_h.getGrabbedWindow;
pub const setWindowMouseRect = video_h.setWindowMouseRect;
pub const getWindowMouseRect = video_h.getWindowMouseRect;
pub const setWindowOpacity = video_h.setWindowOpacity;
pub const getWindowOpacity = video_h.getWindowOpacity;
pub const setWindowParent = video_h.setWindowParent;
pub const setWindowModal = video_h.setWindowModal;
pub const setWindowFocusable = video_h.setWindowFocusable;
pub const showWindowSystemMenu = video_h.showWindowSystemMenu;
pub const HitTestResult = video_h.HitTestResult;
pub const HitTest = video_h.HitTest;
pub const setWindowHitTest = video_h.setWindowHitTest;
pub const setWindowShape = video_h.setWindowShape;
pub const flashWindow = video_h.flashWindow;
pub const destroyWindow = video_h.destroyWindow;
pub const screenSaverEnabled = video_h.screenSaverEnabled;
pub const enableScreenSaver = video_h.enableScreenSaver;
pub const disableScreenSaver = video_h.disableScreenSaver;

//--------------------------------------------------------------------------------------------------
// 2D Accelerated Rendering (SDL_render.h)
//--------------------------------------------------------------------------------------------------
const render_h = @import("sdl3/render.zig");
pub const software_renderer = render_h.software_renderer;
pub const Vertex = render_h.Vertex;
pub const TextureAccess = render_h.TextureAccess;
pub const RendererLogicalPresentation = render_h.RendererLogicalPresentation;
pub const Renderer = render_h.Renderer;
pub const Texture = render_h.Texture;
pub const getNumRenderDrivers = render_h.getNumRenderDrivers;
pub const getRenderDriver = render_h.getRenderDriver;
pub const createWindowAndRenderer = render_h.createWindowAndRenderer;
pub const createRenderer = render_h.createRenderer;
pub const createRendererWithProperties = render_h.createRendererWithProperties;
pub const createSoftwareRenderer = render_h.createSoftwareRenderer;
pub const getRenderer = render_h.getRenderer;
pub const getRenderWindow = render_h.getRenderWindow;
pub const getRendererName = render_h.getRendererName;
pub const getRendererProperties = render_h.getRendererProperties;
pub const getRenderOutputSize = render_h.getRenderOutputSize;
pub const getCurrentRenderOutputSize = render_h.getCurrentRenderOutputSize;
pub const createTexture = render_h.createTexture;
pub const createTextureFromSurface = render_h.createTextureFromSurface;
pub const createTextureWithProperties = render_h.createTextureWithProperties;
pub const getTextureProperties = render_h.getTextureProperties;
pub const getRendererFromTexture = render_h.getRendererFromTexture;
pub const getTextureSize = render_h.getTextureSize;
pub const setTextureColorMod = render_h.setTextureColorMod;
pub const setTextureColorModFloat = render_h.setTextureColorModFloat;
pub const getTextureColorMod = render_h.getTextureColorMod;
pub const getTextureColorModFloat = render_h.getTextureColorModFloat;
pub const setTextureAlphaMod = render_h.setTextureAlphaMod;
pub const setTextureAlphaModFloat = render_h.setTextureAlphaModFloat;
pub const getTextureAlphaMod = render_h.getTextureAlphaMod;
pub const getTextureAlphaModFloat = render_h.getTextureAlphaModFloat;
pub const setTextureBlendMode = render_h.setTextureBlendMode;
pub const getTextureBlendMode = render_h.getTextureBlendMode;
pub const setTextureScaleMode = render_h.setTextureScaleMode;
pub const getTextureScaleMode = render_h.getTextureScaleMode;
pub const updateTexture = render_h.updateTexture;
pub const updateYUVTexture = render_h.updateYUVTexture;
pub const updateNVTexture = render_h.updateNVTexture;
pub const lockTexture = render_h.lockTexture;
pub const lockTextureToSurface = render_h.lockTextureToSurface;
pub const unlockTexture = render_h.unlockTexture;
pub const setRenderTarget = render_h.setRenderTarget;
pub const getRenderTarget = render_h.getRenderTarget;
pub const setRenderLogicalPresentation = render_h.setRenderLogicalPresentation;
pub const getRenderLogicalPresentation = render_h.getRenderLogicalPresentation;
pub const getRenderLogicalPresentationRect = render_h.getRenderLogicalPresentationRect;
pub const renderCoordinatesFromWindow = render_h.renderCoordinatesFromWindow;
pub const renderCoordinatesToWindow = render_h.renderCoordinatesToWindow;
pub const convertEventToRenderCoordinates = render_h.convertEventToRenderCoordinates;
pub const setRenderViewport = render_h.setRenderViewport;
pub const getRenderViewport = render_h.getRenderViewport;
pub const renderViewportSet = render_h.renderViewportSet;
pub const getRenderSafeArea = render_h.getRenderSafeArea;
pub const setRenderClipRect = render_h.setRenderClipRect;
pub const getRenderClipRect = render_h.getRenderClipRect;
pub const renderClipEnabled = render_h.renderClipEnabled;
pub const setRenderScale = render_h.setRenderScale;
pub const getRenderScale = render_h.getRenderScale;
pub const setRenderDrawColor = render_h.setRenderDrawColor;
pub const setRenderDrawColorFloat = render_h.setRenderDrawColorFloat;
pub const getRenderDrawColor = render_h.getRenderDrawColor;
pub const getRenderDrawColorFloat = render_h.getRenderDrawColorFloat;
pub const setRenderColorScale = render_h.setRenderColorScale;
pub const getRenderColorScale = render_h.getRenderColorScale;
pub const setRenderDrawBlendMode = render_h.setRenderDrawBlendMode;
pub const getRenderDrawBlendMode = render_h.getRenderDrawBlendMode;
pub const renderClear = render_h.renderClear;
pub const renderPoint = render_h.renderPoint;
pub const renderPoints = render_h.renderPoints;
pub const renderLine = render_h.renderLine;
pub const renderLines = render_h.renderLines;
pub const renderRect = render_h.renderRect;
pub const renderRects = render_h.renderRects;
pub const renderFillRect = render_h.renderFillRect;
pub const renderFillRects = render_h.renderFillRects;
pub const renderTexture = render_h.renderTexture;
pub const renderTextureRotated = render_h.renderTextureRotated;
pub const renderTextureAffine = render_h.renderTextureAffine;
pub const renderTextureTiled = render_h.renderTextureTiled;
pub const renderTexture9Grid = render_h.renderTexture9Grid;
pub const renderGeometry = render_h.renderGeometry;
pub const renderGeometryRaw = render_h.renderGeometryRaw;
pub const renderReadPixels = render_h.renderReadPixels;
pub const renderPresent = render_h.renderPresent;
pub const destroyTexture = render_h.destroyTexture;
pub const destroyRenderer = render_h.destroyRenderer;
pub const flushRenderer = render_h.flushRenderer;
pub const getRenderMetalLayer = render_h.getRenderMetalLayer;
pub const getRenderMetalCommandEncoder = render_h.getRenderMetalCommandEncoder;
pub const addVulkanRenderSemaphores = render_h.addVulkanRenderSemaphores;
pub const setRenderVSync = render_h.setRenderVSync;
pub const renderer_vsync_disabled = render_h.renderer_vsync_disabled;
pub const renderer_vsync_adaptive = render_h.renderer_vsync_adaptive;
pub const getRenderVSync = render_h.getRenderVSync;
pub const debug_text_font_character_size = render_h.debug_text_font_character_size;
pub const renderDebugText = render_h.renderDebugText;
pub const renderDebugTextFormat = render_h.renderDebugTextFormat;

//--------------------------------------------------------------------------------------------------
// Pixel Formats and Conversion Routines (SDL_pixels.h)
//--------------------------------------------------------------------------------------------------
const pixels_h = @import("sdl3/pixels.zig");
pub const alpha_opaque = pixels_h.alpha_opaque;
pub const alpha_opaque_float = pixels_h.alpha_opaque_float;
pub const alpha_transparent = pixels_h.alpha_transparent;
pub const alpha_transparent_float = pixels_h.alpha_transparent_float;
pub const PixelType = pixels_h.PixelType;
pub const BitmapOrder = pixels_h.BitmapOrder;
pub const PackedOrder = pixels_h.PackedOrder;
pub const ArrayOrder = pixels_h.ArrayOrder;
pub const PackedLayout = pixels_h.PackedLayout;
pub const PixelFormat = pixels_h.PixelFormat;
pub const ColorType = pixels_h.ColorType;
pub const ColorRange = pixels_h.ColorRange;
pub const ColorPrimaries = pixels_h.ColorPrimaries;
pub const TransferCharacteristics = pixels_h.TransferCharacteristics;
pub const MatrixCoefficients = pixels_h.MatrixCoefficients;
pub const ChromaLocation = pixels_h.ChromaLocation;
pub const Colorspace = pixels_h.Colorspace;
pub const Color = pixels_h.Color;
pub const FColor = pixels_h.FColor;
pub const Palette = pixels_h.Palette;
pub const PixelFormatDetails = pixels_h.PixelFormatDetails;
pub const getPixelFormatName = pixels_h.getPixelFormatName;
pub const getMasksForPixelFormat = pixels_h.getMasksForPixelFormat;
pub const getPixelFormatForMasks = pixels_h.getPixelFormatForMasks;
pub const getPixelFormatDetails = pixels_h.getPixelFormatDetails;
pub const createPalette = pixels_h.createPalette;
pub const setPaletteColors = pixels_h.setPaletteColors;
pub const destroyPalette = pixels_h.destroyPalette;
pub const mapRGB = pixels_h.mapRGB;
pub const mapRGBA = pixels_h.mapRGBA;
pub const getRGB = pixels_h.getRGB;
pub const getRGBA = pixels_h.getRGBA;

//--------------------------------------------------------------------------------------------------
// Blend modes (SDL_blendmode.h)
//--------------------------------------------------------------------------------------------------
const blendmode_h = @import("sdl3/blendmode.zig");
pub const BlendMode = blendmode_h.BlendMode;
pub const BlendOperation = blendmode_h.BlendOperation;
pub const BlendFactor = blendmode_h.BlendFactor;
pub const composeCustomBlendMode = blendmode_h.composeCustomBlendMode;

//--------------------------------------------------------------------------------------------------
// Rectangle Functions (SDL_rect.h)
//--------------------------------------------------------------------------------------------------
const rect_h = @import("sdl3/rect.zig");
pub const Point = rect_h.Point;
pub const FPoint = rect_h.FPoint;
pub const Rect = rect_h.Rect;
pub const FRect = rect_h.FRect;
pub const rectToFRect = rect_h.rectToFRect;
pub const pointInRect = rect_h.pointInRect;
pub const rectEmpty = rect_h.rectEmpty;
pub const rectsEqual = rect_h.rectsEqual;
pub const hasRectIntersection = rect_h.hasRectIntersection;
pub const getRectIntersection = rect_h.getRectIntersection;
pub const getRectUnion = rect_h.getRectUnion;
pub const getRectEnclosingPoints = rect_h.getRectEnclosingPoints;
pub const getRectAndLineIntersection = rect_h.getRectAndLineIntersection;
pub const pointInRectFloat = rect_h.pointInRectFloat;
pub const rectEmptyFloat = rect_h.rectEmptyFloat;
pub const rectsEqualEpsilon = rect_h.rectsEqualEpsilon;
pub const rectsEqualFloat = rect_h.rectsEqualFloat;
pub const hasRectIntersectionFloat = rect_h.hasRectIntersectionFloat;
pub const getRectIntersectionFloat = rect_h.getRectIntersectionFloat;
pub const getRectUnionFloat = rect_h.getRectUnionFloat;
pub const getRectEnclosingPointsFloat = rect_h.getRectEnclosingPointsFloat;
pub const getRectAndLineIntersectionFloat = rect_h.getRectAndLineIntersectionFloat;

//--------------------------------------------------------------------------------------------------
// Surface Creation and Simple Drawing (SDL_surface.h)
//--------------------------------------------------------------------------------------------------
const surface_h = @import("sdl3/surface.zig");
pub const SurfaceFlags = surface_h.SurfaceFlags;
pub const ScaleMode = surface_h.ScaleMode;
pub const FlipMode = surface_h.FlipMode;
pub const Surface = surface_h.Surface;
pub const createSurface = surface_h.createSurface;
pub const createSurfaceFrom = surface_h.createSurfaceFrom;
pub const destroySurface = surface_h.destroySurface;
pub const getSurfaceProperties = surface_h.getSurfaceProperties;
pub const setSurfaceColorspace = surface_h.setSurfaceColorspace;
pub const getSurfaceColorspace = surface_h.getSurfaceColorspace;
pub const createSurfacePalette = surface_h.createSurfacePalette;
pub const setSurfacePalette = surface_h.setSurfacePalette;
pub const getSurfacePalette = surface_h.getSurfacePalette;
pub const addSurfaceAlternateImage = surface_h.addSurfaceAlternateImage;
pub const surfaceHasAlternateImages = surface_h.surfaceHasAlternateImages;
pub const getSurfaceImages = surface_h.getSurfaceImages;
pub const removeSurfaceAlternateImages = surface_h.removeSurfaceAlternateImages;
pub const lockSurface = surface_h.lockSurface;
pub const unlockSurface = surface_h.unlockSurface;
pub const loadBMP_IO = surface_h.loadBMP_IO;
pub const loadBMP = surface_h.loadBMP;
pub const saveBMP_IO = surface_h.saveBMP_IO;
pub const saveBMP = surface_h.saveBMP;
pub const setSurfaceRLE = surface_h.setSurfaceRLE;
pub const surfaceHasRLE = surface_h.surfaceHasRLE;
pub const setSurfaceColorKey = surface_h.setSurfaceColorKey;
pub const surfaceHasColorKey = surface_h.surfaceHasColorKey;
pub const getSurfaceColorKey = surface_h.getSurfaceColorKey;
pub const setSurfaceColorMod = surface_h.setSurfaceColorMod;
pub const getSurfaceColorMod = surface_h.getSurfaceColorMod;
pub const setSurfaceAlphaMod = surface_h.setSurfaceAlphaMod;
pub const getSurfaceAlphaMod = surface_h.getSurfaceAlphaMod;
pub const setSurfaceBlendMode = surface_h.setSurfaceBlendMode;
pub const getSurfaceBlendMode = surface_h.getSurfaceBlendMode;
pub const setSurfaceClipRect = surface_h.setSurfaceClipRect;
pub const getSurfaceClipRect = surface_h.getSurfaceClipRect;
pub const flipSurface = surface_h.flipSurface;
pub const duplicateSurface = surface_h.duplicateSurface;
pub const scaleSurface = surface_h.scaleSurface;
pub const convertSurface = surface_h.convertSurface;
pub const convertSurfaceAndColorspace = surface_h.convertSurfaceAndColorspace;
pub const convertPixels = surface_h.convertPixels;
pub const convertPixelsAndColorspace = surface_h.convertPixelsAndColorspace;
pub const premultiplyAlpha = surface_h.premultiplyAlpha;
pub const premultiplySurfaceAlpha = surface_h.premultiplySurfaceAlpha;
pub const clearSurface = surface_h.clearSurface;
pub const fillSurfaceRect = surface_h.fillSurfaceRect;
pub const fillSurfaceRects = surface_h.fillSurfaceRects;
pub const blitSurface = surface_h.blitSurface;
pub const blitSurfaceUnchecked = surface_h.blitSurfaceUnchecked;
pub const blitSurfaceScaled = surface_h.blitSurfaceScaled;
pub const blitSurfaceUncheckedScaled = surface_h.blitSurfaceUncheckedScaled;
pub const stretchSurface = surface_h.stretchSurface;
pub const blitSurfaceTiled = surface_h.blitSurfaceTiled;
pub const blitSurfaceTiledWithScale = surface_h.blitSurfaceTiledWithScale;
pub const blitSurface9Grid = surface_h.blitSurface9Grid;
pub const mapSurfaceRGB = surface_h.mapSurfaceRGB;
pub const mapSurfaceRGBA = surface_h.mapSurfaceRGBA;
pub const readSurfacePixel = surface_h.readSurfacePixel;
pub const readSurfacePixelFloat = surface_h.readSurfacePixelFloat;
pub const writeSurfacePixel = surface_h.writeSurfacePixel;
pub const writeSurfacePixelFloat = surface_h.writeSurfacePixelFloat;

//--------------------------------------------------------------------------------------------------
// Clipboard Handling (SDL_clipboard.h)
//--------------------------------------------------------------------------------------------------
const clipboard_h = @import("sdl3/clipboard.zig");
pub const setClipboardText = clipboard_h.setClipboardText;
pub const getClipboardText = clipboard_h.getClipboardText;
pub const hasClipboardText = clipboard_h.hasClipboardText;
pub const setPrimarySelectionText = clipboard_h.setPrimarySelectionText;
pub const getPrimarySelectionText = clipboard_h.getPrimarySelectionText;
pub const hasPrimarySelectionText = clipboard_h.hasPrimarySelectionText;
pub const ClipboardDataCallback = clipboard_h.ClipboardDataCallback;
pub const ClipboardCleanupCallback = clipboard_h.ClipboardCleanupCallback;
pub const setClipboardData = clipboard_h.setClipboardData;
pub const clearClipboardData = clipboard_h.clearClipboardData;
pub const getClipboardData = clipboard_h.getClipboardData;
pub const hasClipboardData = clipboard_h.hasClipboardData;
pub const getClipboardMimeTypes = clipboard_h.getClipboardMimeTypes;

//--------------------------------------------------------------------------------------------------
// Vulkan Support (SDL_vulkan.h)
//--------------------------------------------------------------------------------------------------
const vulkan_h = @import("sdl3/vulkan.zig");
pub const vk = vulkan_h.vk;

//--------------------------------------------------------------------------------------------------
// Metal Support (SDL_metal.h)
//--------------------------------------------------------------------------------------------------
const metal_h = @import("sdl3/metal.zig");
pub const MetalView = metal_h.MetalView;
pub const metal = metal_h.metal;

//--------------------------------------------------------------------------------------------------
// Camera (SDL_camera.h)
//--------------------------------------------------------------------------------------------------
const camera_h = @import("sdl3/camera.zig");
pub const CameraId = camera_h.CameraId;
pub const Camera = camera_h.Camera;
pub const CameraSpec = camera_h.CameraSpec;
pub const CameraPermissionState = camera_h.CameraPermissionState;
pub const CameraPosition = camera_h.CameraPosition;
pub const getNumCameraDrivers = camera_h.getNumCameraDrivers;
pub const getCameraDriver = camera_h.getCameraDriver;
pub const getCurrentCameraDriver = camera_h.getCurrentCameraDriver;
pub const getCameras = camera_h.getCameras;
pub const getCameraSupportedFormats = camera_h.getCameraSupportedFormats;
pub const getCameraName = camera_h.getCameraName;
pub const getCameraPosition = camera_h.getCameraPosition;
pub const openCamera = camera_h.openCamera;
pub const getCameraPermissionState = camera_h.getCameraPermissionState;
pub const getCameraId = camera_h.getCameraId;
pub const getCameraProperties = camera_h.getCameraProperties;
pub const getCameraFormat = camera_h.getCameraFormat;
pub const acquireCameraFrame = camera_h.acquireCameraFrame;
pub const releaseCameraFrame = camera_h.releaseCameraFrame;
pub const closeCamera = camera_h.closeCamera;

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
pub const IOStream = iostream_h.IOStream;

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
