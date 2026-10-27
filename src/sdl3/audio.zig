//! Audio Device Management, Playing and Recording (SDL_audio.h)

const std = @import("std");
const builtin = @import("builtin");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

pub const AUDIO_MASK_BITSIZE = @as(c_uint, 0xff);
pub const AUDIO_MASK_FLOAT = @as(c_uint, 1) << 8;
pub const AUDIO_MASK_BIG_ENDIAN = @as(c_uint, 1) << 12;
pub const AUDIO_MASK_SIGNED = @as(c_uint, 1) << 15;

pub const AudioFormat = enum(c_uint) {
    UNKNOWN = 0x0,
    U8 = 0x0008,
    S8 = 0x8008,
    S16LE = 0x8010,
    S16BE = 0x9010,
    S32LE = 0x8020,
    S32BE = 0x9020,
    F32LE = 0x8120,
    F32BE = 0x9120,

    pub const S16 = if (builtin.target.cpu.arch.endian() == .little) AudioFormat.S16LE else AudioFormat.S16BE;
    pub const S32 = if (builtin.target.cpu.arch.endian() == .little) AudioFormat.S32LE else AudioFormat.S32BE;
    pub const F32 = if (builtin.target.cpu.arch.endian() == .little) AudioFormat.F32LE else AudioFormat.F32BE;
};

pub inline fn AUDIO_BITSIZE(format: AudioFormat) c_uint {
    return @backingInt(format) & AUDIO_MASK_BITSIZE;
}

pub inline fn AUDIO_BYTESIZE(format: AudioFormat) c_uint {
    return AUDIO_BITSIZE(@backingInt(format)) / 8;
}

pub inline fn AUDIO_ISFLOAT(format: AudioFormat) bool {
    return (@backingInt(format) & AUDIO_MASK_FLOAT) != 0;
}

pub inline fn AUDIO_ISBIGENDIAN(format: AudioFormat) bool {
    return (@backingInt(format) & AUDIO_MASK_BIG_ENDIAN) != 0;
}

pub inline fn AUDIO_ISSIGNED(format: AudioFormat) bool {
    return (@backingInt(format) & AUDIO_MASK_SIGNED) != 0;
}

pub inline fn AUDIO_ISINT(format: AudioFormat) bool {
    return !AUDIO_ISFLOAT(format);
}

pub inline fn AUDIO_ISLITTLEENDIAN(format: AudioFormat) bool {
    return !AUDIO_ISBIGENDIAN(format);
}

pub inline fn AUDIO_ISUNSIGNED(format: AudioFormat) bool {
    return !AUDIO_ISSIGNED(format);
}

pub const AudioDeviceId = enum(u32) { invalid = 0, _ };

pub const AUDIO_DEVICE_DEFAULT_PLAYBACK = 0xFFFFFFFF;
pub const AUDIO_DEVICE_DEFAULT_RECORDING = 0xFFFFFFFE;

pub const AudioSpec = extern struct {
    channels: u8,
    format: AudioFormat,
    freq: c_int,
};

pub inline fn AUDIO_FRAMESIZE(spec: AudioSpec) c_uint {
    return AUDIO_BYTESIZE(spec.format) * spec.channels;
}

pub const AudioStream = opaque {};

/// Use this function to get the number of built-in audio drivers.
///
/// This function returns a hardcoded number. This never returns a negative
/// value; if there are no drivers compiled into this build of SDL, this
/// function returns zero. The presence of a driver in this list does not mean
/// it will function, it just means SDL is capable of interacting with that
/// interface. For example, a build of SDL might have esound support, but if
/// there's no esound server available, SDL's esound driver would fail if used.
pub const getNumAudioDrivers = SDL_GetNumAudioDrivers;
extern fn SDL_GetNumAudioDrivers() c_int;

/// Use this function to get the name of a built in audio driver.
pub fn getAudioDriver(index: c_int) ?[:0]const u8 {
    if (SDL_GetAudioDriver(index)) |name| {
        return std.mem.span(name);
    } else {
        return null;
    }
}
extern fn SDL_GetAudioDriver(index: c_int) [*c]const u8;

/// Get the name of the current audio driver.
pub fn getCurrentAudioDriver() ?[:0]const u8 {
    if (SDL_GetCurrentAudioDriver()) |name| {
        return std.mem.span(name);
    } else {
        return null;
    }
}
extern fn SDL_GetCurrentAudioDriver() [*c]const u8;

/// Get a list of currently-connected audio playback devices.
///
/// This only returns a list of physical devices; it will not have any device
/// IDs returned by SDL_OpenAudioDevice().
///
/// If this function returns NULL, to signify an error, `*count` will be set to  zero.
///
/// Returns a 0 terminated array of device instance IDs or NULL on error;
/// call SDL_free() when it is no longer needed.
pub fn getAudioPlaybackDevices() Error![]AudioDeviceId {
    var count: c_int = undefined;
    const maybe_list = SDL_GetAudioPlaybackDevices(&count);
    return if (maybe_list) |list| list[0..@intCast(count)] else makeError();
}
extern fn SDL_GetAudioPlaybackDevices(out_count: ?*c_int) ?[*]AudioDeviceId;

/// Get a list of currently-connected audio recording devices.
///
/// This only returns a list of physical devices; it will not have any device
/// IDs returned by SDL_OpenAudioDevice().
///
/// If this function returns NULL, to signify an error, `*count` will be set to  zero.
///
/// Returns a 0 terminated array of device instance IDs or NULL on error;
/// call SDL_free() when it is no longer needed.
pub fn getAudioRecordingDevices() Error![]AudioDeviceId {
    var count: c_int = undefined;
    const maybe_list = SDL_GetAudioRecordingDevices(&count);
    return if (maybe_list) |list| list[0..@intCast(count)] else makeError();
}
extern fn SDL_GetAudioRecordingDevices(out_count: ?*c_int) ?[*]AudioDeviceId;

/// Get the human-readable name of a specific audio device.
pub fn getAudioDeviceName(devid: AudioDeviceId) Error![:0]const u8 {
    if (SDL_GetAudioDeviceName(devid)) |name| {
        return std.mem.span(name);
    } else {
        return makeError();
    }
}
extern fn SDL_GetAudioDeviceName(AudioDeviceId) [*c]const u8;

/// Get the current audio format of a specific audio device.
pub fn getAudioDeviceFormat(devid: AudioDeviceId) Error!struct { spec: AudioSpec, sample_frames: c_int } {
    var spec: AudioSpec = undefined;
    var sample_frames: c_int = undefined;
    if (!SDL_GetAudioDeviceFormat(devid, &spec, &sample_frames)) {
        return makeError();
    }
    return .{ .spec = spec, .sample_frames = sample_frames };
}
extern fn SDL_GetAudioDeviceFormat(AudioDeviceId, out_spec: *AudioSpec, out_sample_frames: *c_int) bool;

/// Get the current audio format of a specific audio device.
/// Channel maps are optional; most things do not need them, instead passing
/// data in the [order that SDL expects](CategoryAudio#channel-layouts).
///
/// Audio devices usually have no remapping applied. This is represented by
/// returning NULL, and does not signify an error.
///
/// Returns an array of the current channel mapping, with as many elements as
/// the current output spec's channels, or NULL if default. This
/// should be freed with SDL_free() when it is no longer needed.
pub fn getAudioDeviceChannelMap(devid: AudioDeviceId) ?[]c_int {
    var count: c_int = undefined;
    return if (SDL_GetAudioDeviceChannelMap(devid, &count)) |list_ptr| list_ptr[0..@intCast(count)] else null;
}
extern fn SDL_GetAudioDeviceChannelMap(AudioDeviceId, out_count: *c_int) [*c]c_int;

/// Open a specific audio device.
pub fn openAudioDevice(device: AudioDeviceId, spec: ?*const AudioSpec) Error!AudioDeviceId {
    const opened_device_id = SDL_OpenAudioDevice(device, spec);
    if (opened_device_id == .invalid) {
        return makeError();
    }
    return opened_device_id;
}
extern fn SDL_OpenAudioDevice(AudioDeviceId, ?*const AudioSpec) AudioDeviceId;

pub const isAudioDevicePhysical = SDL_IsAudioDevicePhysical;
extern fn SDL_IsAudioDevicePhysical(AudioDeviceId) bool;

pub const isAudioDevicePlayback = SDL_IsAudioDevicePlayback;
extern fn SDL_IsAudioDevicePlayback(AudioDeviceId) bool;

/// Use this function to pause audio playback on a specified device.
///
/// This function pauses audio processing for a given device. Any bound audio
/// streams will not progress, and no audio will be generated. Pausing one
/// device does not prevent other unpaused devices from running.
///
/// Unlike in SDL2, audio devices start in an _unpaused_ state, since an app
/// has to bind a stream before any audio will flow. Pausing a paused device is
/// a legal no-op.
///
/// Pausing a device can be useful to halt all audio without unbinding all the
/// audio streams. This might be useful while a game is paused, or a level is
/// loading, etc.
///
/// Physical devices can not be paused or unpaused, only logical devices
/// created through SDL_OpenAudioDevice() can be.
pub const pauseAudioDevice = SDL_PauseAudioDevice;
extern fn SDL_PauseAudioDevice(AudioDeviceId) bool;

/// Use this function to unpause audio playback on a specified device.
///
/// This function unpauses audio processing for a given device that has
/// previously been paused with SDL_PauseAudioDevice(). Once unpaused, any
/// bound audio streams will begin to progress again, and audio can be
/// generated.
///
/// Unlike in SDL2, audio devices start in an _unpaused_ state, since an app
/// has to bind a stream before any audio will flow. Pausing a paused device is
/// a legal no-op.
///
/// Physical devices can not be paused or unpaused, only logical devices
/// created through SDL_OpenAudioDevice() can be.
pub const resumeAudioDevice = SDL_ResumeAudioDevice;
extern fn SDL_ResumeAudioDevice(AudioDeviceId) bool;

/// Use this function to query if an audio device is paused.
///
/// Unlike in SDL2, audio devices start in an _unpaused_ state, since an app
/// has to bind a stream before any audio will flow. Pausing a paused device is
/// a legal no-op.
///
/// Physical devices can not be paused or unpaused, only logical devices
/// created through SDL_OpenAudioDevice() can be.
pub const audioDevicePaused = SDL_AudioDevicePaused;
extern fn SDL_AudioDevicePaused(AudioDeviceId) bool;

/// Get the gain of an audio device.
///
/// Physical devices may not have their gain changed, only logical devices, and
/// this function will always return -1.0f when used on physical devices.
pub fn getAudioDeviceGain(device: AudioDeviceId) Error!f32 {
    const gain = SDL_GetAudioDeviceGain(device);
    return if (gain == -1.0) makeError() else gain;
}
extern fn SDL_GetAudioDeviceGain(AudioDeviceId) f32;

/// Change the gain of an audio device.
///
/// Physical devices may not have their gain changed, only logical devices, and
/// this function will always return false when used on physical devices. While
/// it might seem attractive to adjust several logical devices at once in this
/// way, it would allow an app or library to interfere with another portion of
/// the program's otherwise-isolated devices.
///
/// This is applied, along with any per-audiostream gain, during playback to
/// the hardware, and can be continuously changed to create various effects. On
/// recording devices, this will adjust the gain before passing the data into
/// an audiostream; that recording audiostream can then adjust its gain further
/// when outputting the data elsewhere, if it likes, but that second gain is
/// not applied until the data leaves the audiostream again.
pub fn setAudioDeviceGain(device: AudioDeviceId, gain: f32) Error!void {
    if (!SDL_SetAudioDeviceGain(device, gain)) {
        return makeError();
    }
}
extern fn SDL_SetAudioDeviceGain(AudioDeviceId, f32) bool;

/// Close a previously-opened audio device.
///
/// The application should close open audio devices once they are no longer  needed.
///
/// This function may block briefly while pending audio data is played by the
/// hardware, so that applications don't drop the last buffer of data they
/// supplied if terminating immediately afterwards.
pub const closeAudioDevice = SDL_CloseAudioDevice;
extern fn SDL_CloseAudioDevice(AudioDeviceId) void;

// TODO
// - SDL_BindAudioStreams
// - SDL_UnbindAudioStreams
// - SDL_UnbindAudioStream

/// Query an audio stream for its currently-bound device.
///
/// This reports the audio device that an audio stream is currently bound to.
///
/// If not bound, or invalid, this returns zero, which is not a valid device ID.
pub const getAudioStreamDevice = SDL_GetAudioStreamDevice;
extern fn SDL_GetAudioStreamDevice(*AudioStream) AudioDeviceId;

// TODO
// - SDL_GetAudioStreamProperties
// - SDL_GetAudioStreamFormat
// - SDL_SetAudioStreamFormat
// - SDL_GetAudioStreamFrequencyRatio
// - SDL_SetAudioStreamFrequencyRatio
// - SDL_GetAudioStreamGain
// - SDL_SetAudioStreamGain
// - SDL_GetAudioStreamInputChannelMap
// - SDL_GetAudioStreamOutputChannelMap
// - SDL_SetAudioStreamInputChannelMap
// - SDL_SetAudioStreamOutputChannelMap

/// Add data to the stream.
///
/// This data must match the format/channels/samplerate specified in the latest
/// call to SDL_SetAudioStreamFormat, or the format specified when creating the
/// stream if it hasn't been changed.
///
/// Note that this call simply copies the unconverted data for later. This is
/// different than SDL2, where data was converted during the Put call and the
/// Get call would just dequeue the previously-converted data.
pub fn putAudioStreamData(comptime SampleType: type, stream: *AudioStream, data: []const SampleType) Error!void {
    if (!SDL_PutAudioStreamData(stream, @ptrCast(data.ptr), @intCast(@sizeOf(SampleType) * data.len))) {
        return makeError();
    }
}
extern fn SDL_PutAudioStreamData(*AudioStream, data: *const anyopaque, len: c_int) bool;

pub const createAudioStream = SDL_CreateAudioStream;
extern fn SDL_CreateAudioStream(src_spec: *const AudioSpec, dst_spec: ?*const AudioSpec) ?*AudioStream;

/// Bind an audio stream to an audio device.
///
/// This binds a single audio stream to the specified audio device. The stream
/// can then be used to play or record audio.
pub fn bindAudioStream(devid: AudioDeviceId, stream: *AudioStream) Error!void {
    if (!SDL_BindAudioStream(devid, stream)) return makeError();
}
extern fn SDL_BindAudioStream(devid: AudioDeviceId, stream: *AudioStream) bool;

// TODO
// - SDL_GetAudioStreamData
// - SDL_GetAudioStreamAvailable

/// Get the number of bytes currently queued.
///
// This is the number of bytes put into a stream as input, not the number that
// can be retrieved as output. Because of several details, it's not possible
// to calculate one number directly from the other. If you need to know how
// much usable data can be retrieved right now, you should use
// SDL_GetAudioStreamAvailable() and not this function.
//
// Note that audio streams can change their input format at any time, even if
// there is still data queued in a different format, so the returned byte
// count will not necessarily match the number of _sample frames_ available.
// Users of this API should be aware of format changes they make when feeding
// a stream and plan accordingly.
//
// Queued data is not converted until it is consumed by
// SDL_GetAudioStreamData, so this value should be representative of the exact
// data that was put into the stream.
//
// If the stream has so much data that it would overflow an int, the return
// value is clamped to a maximum value, but no queued data is lost; if there
// are gigabytes of data queued, the app might need to read some of it with
// SDL_GetAudioStreamData before this function's return value is no longer
// clamped.
pub fn getAudioStreamQueued(stream: *AudioStream) Error!usize {
    const queued = SDL_GetAudioStreamQueued(stream);
    if (queued < 0) {
        return makeError();
    }
    return @intCast(queued);
}
extern fn SDL_GetAudioStreamQueued(*AudioStream) c_int;

/// Tell the stream that you're done sending data, and anything being buffered
/// should be converted/resampled and made available immediately.
///
/// It is legal to add more data to a stream after flushing, but there may be
/// audio gaps in the output. Generally this is intended to signal the end of
/// input, so the complete output becomes available.
pub fn flushAudioStream(stream: *AudioStream) Error!void {
    if (!SDL_FlushAudioStream(stream)) {
        return makeError();
    }
}
extern fn SDL_FlushAudioStream(*AudioStream) bool;

/// Clear any pending data in the stream.
///
/// This drops any queued data, so there will be nothing to read from the
/// stream until more is added.
pub fn clearAudioStream(stream: *AudioStream) Error!void {
    if (!SDL_ClearAudioStream(stream)) {
        return makeError();
    }
}
extern fn SDL_ClearAudioStream(*AudioStream) bool;

// TODO
// - SDL_PauseAudioStreamDevice
// - SDL_ResumeAudioStreamDevice
// - SDL_AudioStreamDevicePaused
// - SDL_LockAudioStream
// - SDL_UnlockAudioStream

pub const AudioStreamCallback = *const fn (
    userdata: ?*anyopaque,
    stream: ?*AudioStream,
    additional_amount: c_int,
    total_amount: c_int,
) callconv(.c) void;

// TODO
// - SDL_SetAudioStreamGetCallback
// - SDL_SetAudioStreamPutCallback
// - SDL_DestroyAudioStream

/// Convenience function for straightforward audio init for the common case.
///
/// If all your app intends to do is provide a single source of PCM audio, this
/// function allows you to do all your audio setup in a single call.
///
/// This is also intended to be a clean means to migrate apps from SDL2.
///
/// This function will open an audio device, create a stream and bind it.
/// Unlike other methods of setup, the audio device will be closed when this
/// stream is destroyed, so the app can treat the returned SDL_AudioStream as
/// the only object needed to manage audio playback.
///
/// Also unlike other functions, the audio device begins paused. This is to map
/// more closely to SDL2-style behavior, since there is no extra step here to
/// bind a stream to begin audio flowing. The audio device should be resumed
/// with `SDL_ResumeAudioStreamDevice(stream);`
///
/// This function works with both playback and recording devices.
///
/// The `spec` parameter represents the app's side of the audio stream. That
/// is, for recording audio, this will be the output format, and for playing
/// audio, this will be the input format. If spec is NULL, the system will
/// choose the format, and the app can use SDL_GetAudioStreamFormat() to obtain
/// this information later.
///
/// If you don't care about opening a specific audio device, you can (and
/// probably _should_), use SDL_AUDIO_DEVICE_DEFAULT_PLAYBACK for playback and
/// SDL_AUDIO_DEVICE_DEFAULT_RECORDING for recording.
///
/// One can optionally provide a callback function; if NULL, the app is
/// expected to queue audio data for playback (or unqueue audio data if
/// capturing). Otherwise, the callback will begin to fire once the device is
/// unpaused.
///
/// Destroying the returned stream with SDL_DestroyAudioStream will also close
/// the audio device associated with this stream.
pub fn openAudioDeviceStream(device: AudioDeviceId, spec: *const AudioSpec, callback: ?AudioStreamCallback, userdata: ?*anyopaque) Error!*AudioStream {
    const maybe_stream = SDL_OpenAudioDeviceStream(device, spec, callback, userdata);
    return if (maybe_stream) |stream| stream else makeError();
}
extern fn SDL_OpenAudioDeviceStream(AudioDeviceId, *const AudioSpec, ?AudioStreamCallback, ?*anyopaque) ?*AudioStream;

pub fn loadWAV(path: [:0]const u8, spec: *const AudioSpec, audio_buf: *const []u8, audio_len: *u32) bool {
    return SDL_LoadWAV(path, spec, audio_buf, audio_len);
}
extern fn SDL_LoadWAV([*c]const u8, *const AudioSpec, *const []u8, *u32) bool;

// TODO
// - SDL_AudioPostmixCallback
// - SDL_SetAudioPostmixCallback
// - SDL_LoadWAV_IO
// - SDL_MixAudio
// - SDL_ConvertAudioSamples
// - SDL_GetAudioFormatName
// - SDL_GetSilenceValueForFormat
