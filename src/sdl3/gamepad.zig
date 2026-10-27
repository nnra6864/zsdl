//! Gamepad Support (SDL_gamepad.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");

pub const Gamepad = opaque {
    pub const Type = enum(c_int) {
        unknown,
        standard,
        xbox360,
        xboxone,
        ps3,
        ps4,
        ps5,
        nintendo_switch_pro,
        nintendo_switch_joycon_left,
        nintendo_switch_joycon_right,
        nintendo_switch_joycon_pair,
    };

    pub const Button = enum(c_int) {
        invalid = -1,
        south,
        east,
        west,
        north,
        back,
        guide,
        start,
        left_stick,
        right_stick,
        left_shoulder,
        right_shoulder,
        dpad_up,
        dpad_down,
        dpad_left,
        dpad_right,
        misc1,
        right_paddle1,
        left_paddle1,
        right_paddle2,
        left_paddle2,
        touchpad,
        misc2,
        misc3,
        misc4,
        misc5,
        misc6,
    };

    pub const ButtonLabel = enum(c_int) {
        unknown,
        label_a,
        label_b,
        label_x,
        label_y,
        label_cross,
        label_circle,
        label_square,
        label_triangle,
    };

    pub const Axis = enum(c_int) {
        invalid = -1,
        leftx,
        lefty,
        rightx,
        righty,
        left_trigger,
        right_trigger,
    };

    pub const BindingType = enum(c_int) {
        none,
        button,
        axis,
        hat,
    };

    /// A mapping between one joystick input to a gamepad control.
    ///
    /// A gamepad has a collection of several bindings, to say, for example, when
    /// joystick button number 5 is pressed, that should be treated like the
    /// gamepad's "start" button.
    ///
    /// SDL has these bindings built-in for many popular controllers, and can add
    /// more with a simple text string. Those strings are parsed into a collection
    /// of these structs to make it easier to operate on the data.
    pub const Binding = extern struct {
        input_type: BindingType,
        input: extern union {
            button: Button,
            axis: extern struct {
                axis: Axis,
                axis_min: c_int,
                axis_max: c_int,
            },
            hat: extern struct {
                hat: c_int,
                hat_mask: c_int,
            },
        },
        output_type: BindingType,
        output: extern union {
            button: Button,
            axis: extern struct {
                axis: Axis,
                axis_min: c_int,
                axis_max: c_int,
            },
        },
    };

    pub const close = closeGamepad;
    pub const getAxis = getGamepadAxis;
    pub const getButton = getGamepadButton;
};

// TODO
// - SDL_AddGamepadMapping
// - SDL_AddGamepadMappingsFromIO
// - SDL_AddGamepadMappingsFromFile
// - SDL_ReloadGamepadMappings
// - SDL_GetGamepadMappings
// - SDL_GetGamepadMappingForGUID
// - SDL_GetGamepadMapping
// - SDL_SetGamepadMapping
// - SDL_HasGamepad
// - SDL_GetGamepads
// - SDL_IsGamepad
// - SDL_GetGamepadNameForID
// - SDL_GetGamepadPathForID
// - SDL_GetGamepadPlayerIndexForID
// - SDL_GetGamepadGUIDForID
// - SDL_GetGamepadVendorForID
// - SDL_GetGamepadProductForID
// - SDL_GetGamepadProductVersionForID
// - SDL_GetGamepadTypeForID
// - SDL_GetRealGamepadTypeForID
// - SDL_GetGamepadMappingForID

pub const openGamepad = SDL_OpenGamepad;
extern fn SDL_OpenGamepad(joystick_index: sdl.Joystick.Id) ?*Gamepad;

// TODO
// - SDL_GetGamepadFromID
// - SDL_GetGamepadFromPlayerIndex
// - SDL_GetGamepadProperties
// - SDL_GetGamepadID
// - SDL_GetGamepadName
// - SDL_GetGamepadPath
// - SDL_GetGamepadType
// - SDL_GetRealGamepadType
// - SDL_GetGamepadPlayerIndex
// - SDL_SetGamepadPlayerIndex
// - SDL_GetGamepadVendor
// - SDL_GetGamepadProduct
// - SDL_GetGamepadProductVersion
// - SDL_GetGamepadSerial
// - SDL_GetGamepadSteamHandle
// - SDL_GetGamepadConnectionState
// - SDL_GetGamepadPowerInfo
// - SDL_GamepadConnected
// - SDL_GetGamepadJoystick
// - SDL_SetGamepadEventsEnabled
// - SDL_GamepadEventsEnabled
// - SDL_GetGamepadBindings
// - SDL_UpdateGamepads
// - SDL_GetGamepadTypeFromString
// - SDL_GetGamepadStringForType
// - SDL_GetGamepadAxisFromString
// - SDL_GetGamepadStringForAxis
// - SDL_GamepadHasAxis

pub const getGamepadAxis = SDL_GetGamepadAxis;
extern fn SDL_GetGamepadAxis(*Gamepad, axis: Gamepad.Axis) i16;

// TODO
// - SDL_GetGamepadButtonFromString
// - SDL_GetGamepadStringForButton
// - SDL_GamepadHasButton
// - SDL_GetGamepadButton

pub const getGamepadButton = SDL_GetGamepadButton;
extern fn SDL_GetGamepadButton(*Gamepad, Gamepad.Button) bool;

// TODO
// - SDL_GetGamepadButtonLabelForType
// - SDL_GetGamepadButtonLabel
// - SDL_GetNumGamepadTouchpads
// - SDL_GetNumGamepadTouchpadFingers
// - SDL_GetGamepadTouchpadFinger
// - SDL_GamepadHasSensor
// - SDL_SetGamepadSensorEnabled
// - SDL_GamepadSensorEnabled
// - SDL_GetGamepadSensorDataRate
// - SDL_GetGamepadSensorData
// - SDL_RumbleGamepad
// - SDL_RumbleGamepadTriggers
// - SDL_SetGamepadLED
// - SDL_SendGamepadEffect

pub const closeGamepad = SDL_CloseGamepad;
extern fn SDL_CloseGamepad(joystick: *Gamepad) void;
