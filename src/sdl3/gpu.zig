//! 3D Rendering and GPU Compute (SDL_gpu.h)

const std = @import("std");

const sdl = @import("../sdl3.zig");
const Error = sdl.Error;
const makeError = sdl.makeError;

// Type Declarations

pub const GPUDevice = opaque {
    pub const Properties = struct {
        pub const create_debugmode_boolean = "SDL.gpu.device.create.debugmode";
        pub const create_preferlowpower_boolean = "SDL.gpu.device.create.preferlowpower";
        pub const create_name_string = "SDL.gpu.device.create.name";
        pub const create_shaders_private_boolean = "SDL.gpu.device.create.shaders.private";
        pub const create_shaders_spirv_boolean = "SDL.gpu.device.create.shaders.spirv";
        pub const create_shaders_dxbc_boolean = "SDL.gpu.device.create.shaders.dxbc";
        pub const create_shaders_dxil_boolean = "SDL.gpu.device.create.shaders.dxil";
        pub const create_shaders_msl_boolean = "SDL.gpu.device.create.shaders.msl";
        pub const create_shaders_metallib_boolean = "SDL.gpu.device.create.shaders.metallib";
        pub const create_d3d12_semantic_name_string = "SDL.gpu.device.create.d3d12.semantic";
    };
};

pub const GPUBuffer = opaque {
    pub const Properties = struct {
        pub const create_name_string = "SDL.gpu.buffer.create.name";
    };
};

pub const GPUTransferBuffer = opaque {
    pub const Properties = struct {
        pub const create_name_string = "SDL.gpu.transferbuffer.create.name";
    };
};

pub const GPUTexture = opaque {
    pub const Properties = struct {
        pub const create_d3d12_clear_r_float = "SDL.gpu.texture.create.d3d12.clear.r";
        pub const create_d3d12_clear_g_float = "SDL.gpu.texture.create.d3d12.clear.g";
        pub const create_d3d12_clear_b_float = "SDL.gpu.texture.create.d3d12.clear.b";
        pub const create_d3d12_clear_a_float = "SDL.gpu.texture.create.d3d12.clear.a";
        pub const create_d3d12_clear_depth_float = "SDL.gpu.texture.create.d3d12.clear.depth";
        pub const create_d3d12_clear_stencil_number = "SDL.gpu.texture.create.d3d12.clear.stencil";
        pub const create_name_string = "SDL.gpu.texture.create.name";
    };
};

pub const GPUSampler = opaque {
    pub const Properties = struct {
        pub const create_name_string = "SDL.gpu.sampler.create.name";
    };
};

pub const GPUShader = opaque {
    pub const Properties = struct {
        pub const create_name_string = "SDL.gpu.shader.create.name";
    };
};

pub const GPUComputePipeline = opaque {
    pub const Properties = struct {
        pub const create_name_string = "SDL.gpu.computepipeline.create.name";
    };
};

pub const GPUGraphicsPipeline = opaque {
    pub const Properties = struct {
        pub const create_name_string = "SDL.gpu.graphicspipeline.create.name";
    };
};

pub const GPUCommandBuffer = opaque {};

pub const GPURenderPass = opaque {};

pub const GPUComputePass = opaque {};

pub const GPUCopyPass = opaque {};

pub const GPUFence = opaque {};

pub const GPUPrimitiveType = enum(c_int) {
    /// A series of separate triangles.
    trianglelist = 0,
    /// A series of connected triangles.
    trianglestrip,
    /// A series of separate lines.
    linelist,
    /// A series of connected lines.
    linestrip,
    /// A series of separate points.
    pointlist,
};

pub const GPULoadOp = enum(c_int) {
    /// The previous contents of the texture will be preserved.
    load = 0,
    /// The contents of the texture will be cleared to a color.
    clear,
    /// The previous contents of the texture need not be preserved. The contents
    /// will be undefined.
    dont_care,
};

pub const GPUStoreOp = enum(c_int) {
    /// The contents generated during the render pass will be written to memory.
    store = 0,
    /// The contents generated during the render pass are not needed and may be
    /// discarded. The contents will be undefined.
    dont_care,
    /// The multisample contents generated during the render pass will be
    /// resolved to a non-multisample texture. The contents in the multisample
    /// texture may then be discarded and will be undefined.
    resolve,
    /// The multisample contents generated during the render pass will be
    /// resolved to a non-multisample texture. The contents in the multisample
    /// texture will be written to memory.
    resolve_and_store,
};

pub const GPUIndexElementSize = enum(c_int) {
    ///  The index elements are 16-bit.
    size_16bit = 0,
    ///  The index elements are 32-bit.
    size_32bit,
};

pub const GPUTextureFormat = enum(c_uint) {
    invalid = 0,

    // Unsigned Normalized Float Color Formats
    a8_unorm,
    r8_unorm,
    r8g8_unorm,
    r8g8b8a8_unorm,
    r16_unorm,
    r16g16_unorm,
    r16g16b16a16_unorm,
    r10g10b10a2_unorm,
    b5g6r5_unorm,
    b5g5r5a1_unorm,
    b4g4r4a4_unorm,
    b8g8r8a8_unorm,

    // Compressed Unsigned Normalized Float Color Formats
    bc1_rgba_unorm,
    bc2_rgba_unorm,
    bc3_rgba_unorm,
    bc4_r_unorm,
    bc5_rg_unorm,
    bc7_rgba_unorm,

    // Compressed Signed Float Color Formats
    bc6h_rgb_float,

    // Compressed Unsigned Float Color Formats
    bc6h_rgb_ufloat,

    // Signed Normalized Float Color Formats
    r8_snorm,
    r8g8_snorm,
    r8g8b8a8_snorm,
    r16_snorm,
    r16g16_snorm,
    r16g16b16a16_snorm,

    // Signed Float Color Formats
    r16_float,
    r16g16_float,
    r16g16b16a16_float,
    r32_float,
    r32g32_float,
    r32g32b32a32_float,

    // Unsigned Float Color Formats
    r11g11b10_ufloat,

    // Unsigned Integer Color Formats
    r8_uint,
    r8g8_uint,
    r8g8b8a8_uint,
    r16_uint,
    r16g16_uint,
    r16g16b16a16_uint,
    r32_uint,
    r32g32_uint,
    r32g32b32a32_uint,

    // Signed Integer Color Formats
    r8_int,
    r8g8_int,
    r8g8b8a8_int,
    r16_int,
    r16g16_int,
    r16g16b16a16_int,
    r32_int,
    r32g32_int,
    r32g32b32a32_int,

    // SRGB Unsigned Normalized Color Formats
    r8g8b8a8_unorm_srgb,
    b8g8r8a8_unorm_srgb,

    // Compressed SRGB Unsigned Normalized Color Formats
    bc1_rgba_unorm_srgb,
    bc2_rgba_unorm_srgb,
    bc3_rgba_unorm_srgb,
    bc7_rgba_unorm_srgb,

    // Depth Formats
    d16_unorm,
    d24_unorm,
    d32_float,
    d24_unorm_s8_uint,
    d32_float_s8_uint,

    // Compressed ASTC Normalized Float Color Formats
    astc_4x4_unorm,
    astc_5x4_unorm,
    astc_5x5_unorm,
    astc_6x5_unorm,
    astc_6x6_unorm,
    astc_8x5_unorm,
    astc_8x6_unorm,
    astc_8x8_unorm,
    astc_10x5_unorm,
    astc_10x6_unorm,
    astc_10x8_unorm,
    astc_10x10_unorm,
    astc_12x10_unorm,
    astc_12x12_unorm,

    // Compressed SRGB ASTC Normalized Float Color Formats
    astc_4x4_unorm_srgb,
    astc_5x4_unorm_srgb,
    astc_5x5_unorm_srgb,
    astc_6x5_unorm_srgb,
    astc_6x6_unorm_srgb,
    astc_8x5_unorm_srgb,
    astc_8x6_unorm_srgb,
    astc_8x8_unorm_srgb,
    astc_10x5_unorm_srgb,
    astc_10x6_unorm_srgb,
    astc_10x8_unorm_srgb,
    astc_10x10_unorm_srgb,
    astc_12x10_unorm_srgb,
    astc_12x12_unorm_srgb,

    // Compressed ASTC Signed Float Color Formats
    astc_4x4_float,
    astc_5x4_float,
    astc_5x5_float,
    astc_6x5_float,
    astc_6x6_float,
    astc_8x5_float,
    astc_8x6_float,
    astc_8x8_float,
    astc_10x5_float,
    astc_10x6_float,
    astc_10x8_float,
    astc_10x10_float,
    astc_12x10_float,
    astc_12x12_float,
};

pub const GPUTextureUsageFlags = packed struct(u32) {
    sampler: bool = false,
    color_target: bool = false,
    depth_stencil_target: bool = false,
    graphics_storage_read: bool = false,
    compute_storage_read: bool = false,
    compute_storage_write: bool = false,
    compute_storage_simultaneous_read_write: bool = false,

    __unused: u25 = 0,
};

pub const GPUTextureType = enum(c_int) {
    texturetype_2d = 0,
    texturetype_2d_array,
    texturetype_3d,
    texturetype_cube,
    texturetype_cube_array,
};

pub const GPUSampleCount = enum(c_int) {
    samplecount_1 = 0,
    samplecount_2,
    samplecount_4,
    samplecount_8,
};

pub const GPUCubeMapFace = enum(c_int) {
    positive_x = 0,
    negative_x,
    positive_y,
    negative_y,
    positive_z,
    negative_z,
};

pub const GPUBufferUsageFlags = packed struct(u32) {
    /// Buffer is a vertex buffer.
    vertex: bool = false,
    /// Buffer is an index buffer.
    index: bool = false,
    /// Buffer is an indirect buffer.
    indirect: bool = false,
    /// Buffer supports storage reads in graphics stages.
    graphics_storage_read: bool = false,
    /// Buffer supports storage reads in the compute stage.
    compute_storage_read: bool = false,
    /// Buffer supports storage writes in the compute stage.
    compute_storage_write: bool = false,

    __unused: u26 = 0,
};

pub const GPUTransferBufferUsage = enum(c_int) {
    upload = 0,
    download,
};

pub const GPUShaderStage = enum(c_int) {
    vertex = 0,
    fragment,
};

pub const GPUShaderFormat = packed struct(u32) {
    /// Shaders for NDA'd platforms.
    private: bool = false,
    /// SPIR-V shaders for Vulkan.
    spirv: bool = false,
    /// DXBC SM5_1 shaders for D3D12.
    dxbc: bool = false,
    /// DXIL SM6_0 shaders for D3D12.
    dxil: bool = false,
    /// MSL shaders for Metal.
    msl: bool = false,
    /// Precompiled metallib shaders for Metal.
    metallib: bool = false,

    __unused: u26 = 0,
};

pub const GPUVertexElementFormat = enum(c_int) {
    invalid = 0,

    // 32-bit Signed Integers
    int,
    int2,
    int3,
    int4,

    // 32-bit Unsigned Integers
    uint,
    uint2,
    uint3,
    uint4,

    // 32-bit Floats
    float,
    float2,
    float3,
    float4,

    // 8-bit Signed Integers
    byte2,
    byte4,

    // 8-bit Unsigned Integers
    ubyte2,
    ubyte4,

    // 8-bit Signed Normalized
    byte2_norm,
    byte4_norm,

    // 8-bit Unsigned Normalized
    ubyte2_norm,
    ubyte4_norm,

    // 16-bit Signed Integers
    short2,
    short4,

    // 16-bit Unsigned Integers
    ushort2,
    ushort4,

    // 16-bit Signed Normalized
    short2_norm,
    short4_norm,

    // 16-bit Unsigned Normalized
    ushort2_norm,
    ushort4_norm,

    // 16-bit Floats
    half2,
    half4,
};

pub const GPUVertexInputRate = enum(c_int) {
    ///  Attribute addressing is a function of the vertex index.
    vertex = 0,
    ///  Attribute addressing is a function of the instance index.
    instance,
};

pub const GPUFillMode = enum(c_int) {
    ///  Polygons will be rendered via rasterization.
    fill = 0,
    ///  Polygon edges will be drawn as line segments.
    line,
};

pub const GPUCullMode = enum(c_int) {
    ///  No triangles are culled.
    none = 0,
    ///  Front-facing triangles are culled.
    front,
    ///  Back-facing triangles are culled.
    back,
};

pub const GPUFrontFace = enum(c_int) {
    ///  A triangle with counter-clockwise vertex winding will be considered front-facing.
    counter_clockwise = 0,
    ///  A triangle with clockwise vertex winding will be considered front-facing.
    clockwise,
};

pub const GPUCompareOp = enum(c_int) {
    invalid = 0,
    ///  The comparison always evaluates false.
    never,
    ///  The comparison evaluates reference < test.
    less,
    ///  The comparison evaluates reference == test.
    equal,
    ///  The comparison evaluates reference <= test.
    less_or_equal,
    ///  The comparison evaluates reference > test.
    greater,
    ///  The comparison evaluates reference != test.
    not_equal,
    ///  The comparison evaluates reference >= test.
    greater_or_equal,
    ///  The comparison always evaluates true.
    always,
};

pub const GPUStencilOp = enum(c_int) {
    invalid = 0,
    ///  Keeps the current value.
    keep,
    ///  Sets the value to 0.
    zero,
    ///  Sets the value to reference.
    replace,
    ///  Increments the current value and clamps to the maximum value.
    increment_and_clamp,
    ///  Decrements the current value and clamps to 0.
    decrement_and_clamp,
    ///  Bitwise-inverts the current value.
    invert,
    ///  Increments the current value and wraps back to 0.
    increment_and_wrap,
    ///  Decrements the current value and wraps to the maximum value.
    decrement_and_wrap,
};

pub const GPUBlendOp = enum(c_int) {
    invalid = 0,
    /// (source * source_factor) + (destination * destination_factor)
    add,
    /// (source * source_factor) - (destination * destination_factor)
    subtract,
    /// (destination * destination_factor) - (source * source_factor)
    reverse_subtract,
    /// min(source, destination)
    min,
    /// max(source, destination)
    max,
};

pub const GPUBlendFactor = enum(c_int) {
    invalid = 0,
    zero,
    one,
    /// source color
    src_color,
    /// 1 - source color
    one_minus_src_color,
    /// destination color
    dst_color,
    /// 1 - destination color
    one_minus_dst_color,
    /// source alpha
    src_alpha,
    /// 1 - source alpha
    one_minus_src_alpha,
    /// destination alpha
    dst_alpha,
    /// 1 - destination alpha
    one_minus_dst_alpha,
    /// blend constant
    constant_color,
    /// 1 - blend constant
    one_minus_constant_color,
    /// min(source alpha, 1 - destination alpha)
    src_alpha_saturate,
};

pub const GPUColorComponentFlags = packed struct(u8) {
    red: bool = false,
    green: bool = false,
    blue: bool = false,
    alpha: bool = false,

    __padding: u4 = 0,
};

pub const GPUFilter = enum(c_int) {
    /// Point filtering.
    nearest = 0,
    /// Linear filtering.
    linear,
};

pub const GPUSamplerMipmapMode = enum(c_int) {
    /// Point filtering.
    nearest = 0,
    /// Linear filtering.
    linear,
};

pub const GPUSamplerAddressMode = enum(c_int) {
    /// Specifies that the coordinates will wrap around.
    repeat = 0,
    /// Specifies that the coordinates will wrap around mirrored.
    mirrored_repeat,
    /// Specifies that the coordinates will clamp to the 0-1 range.
    clamp_to_edge,
};

pub const GPUPresentMode = enum(c_int) {
    vsync = 0,
    immediate,
    mailbox,
};

pub const GPUSwapchainComposition = enum(c_int) {
    sdr = 0,
    sdr_linear,
    hdr_extended_linear,
    hdr10_st2084,
};

// Structures

pub const GPUViewport = extern struct {
    ///  The left offset of the viewport.
    x: f32,
    ///  The top offset of the viewport.
    y: f32,
    ///  The width of the viewport.
    w: f32,
    ///  The height of the viewport.
    h: f32,
    ///  The minimum depth of the viewport.
    min_depth: f32,
    ///  The maximum depth of the viewport.
    max_depth: f32,
};

pub const GPUTextureTransferInfo = extern struct {
    ///  The transfer buffer used in the transfer operation.
    transfer_buffer: *GPUTransferBuffer,
    ///  The starting byte of the image data in the transfer buffer.
    offset: u32,
    ///  The number of pixels from one row to the next.
    pixels_per_row: u32,
    ///  The number of rows from one layer/depth-slice to the next.
    rows_per_layer: u32,
};

pub const GPUTransferBufferLocation = extern struct {
    ///  The transfer buffer used in the transfer operation.
    transfer_buffer: *GPUTransferBuffer,
    /// The starting byte of the buffer data in the transfer buffer.
    offset: u32,
};

pub const GPUTextureLocation = extern struct {
    ///  The texture used in the copy operation.
    texture: *GPUTexture,
    ///  The mip level index of the location.
    mip_level: u32,
    ///  The layer index of the location.
    layer: u32,
    ///  The left offset of the location.
    x: u32,
    ///  The top offset of the location.
    y: u32,
    ///  The front offset of the location.
    z: u32,
};

pub const GPUTextureRegion = extern struct {
    ///  The texture used in the copy operation.
    texture: *GPUTexture,
    ///  The mip level index to transfer.
    mip_level: u32,
    ///  The layer index to transfer.
    layer: u32,
    ///  The left offset of the region.
    x: u32,
    ///  The top offset of the region.
    y: u32,
    ///  The front offset of the region.
    z: u32,
    ///  The width of the region.
    w: u32,
    ///  The height of the region.
    h: u32,
    ///  The depth of the region.
    d: u32,
};

pub const GPUBlitRegion = extern struct {
    ///  The texture.
    texture: *GPUTexture,
    ///  The mip level index of the region.
    mip_level: u32,
    ///  The layer index or depth plane of the region. This value is treated as a layer index on 2D array and cube textures, and as a depth plane on 3D textures.
    layer_or_depth_plane: u32,
    ///  The left offset of the region.
    x: u32,
    ///  The top offset of the region.
    y: u32,
    ///  The width of the region.
    w: u32,
    ///  The height of the region.
    h: u32,
};

pub const GPUBufferLocation = extern struct {
    ///  The buffer.
    buffer: *GPUBuffer,
    ///  The starting byte within the buffer.
    offset: u32,
};

pub const GPUBufferRegion = extern struct {
    ///  The buffer.
    buffer: *GPUBuffer,
    ///  The starting byte within the buffer.
    offset: u32,
    ///  The size in bytes of the region.
    size: u32,
};

pub const GPUIndirectDrawCommand = extern struct {
    ///  The number of vertices to draw.
    num_vertices: u32,
    ///  The number of instances to draw.
    num_instances: u32,
    ///  The index of the first vertex to draw.
    first_vertex: u32,
    ///  The ID of the first instance to draw.
    first_instance: u32,
};

pub const GPUIndexedIndirectDrawCommand = extern struct {
    ///  The number of indices to draw per instance.
    num_indices: u32,
    ///  The number of instances to draw.
    num_instances: u32,
    ///  The base index within the index buffer.
    first_index: u32,
    ///  The value added to the vertex index before indexing into the vertex buffer.
    vertex_offset: i32,
    ///  The ID of the first instance to draw.
    first_instance: u32,
};

pub const GPUIndirectDispatchCommand = extern struct {
    ///  The number of local workgroups to dispatch in the X dimension.
    groupcount_x: u32,
    ///  The number of local workgroups to dispatch in the Y dimension.
    groupcount_y: u32,
    ///  The number of local workgroups to dispatch in the Z dimension.
    groupcount_z: u32,
};

// State structures

pub const GPUSamplerCreateInfo = extern struct {
    /// The minification filter to apply to lookups.
    min_filter: GPUFilter,
    /// The magnification filter to apply to lookups.
    mag_filter: GPUFilter,
    /// The mipmap filter to apply to lookups.
    mipmap_mode: GPUSamplerMipmapMode,
    /// The addressing mode for U coordinates outside [0, 1).
    address_mode_u: GPUSamplerAddressMode,
    /// The addressing mode for V coordinates outside [0, 1).
    address_mode_v: GPUSamplerAddressMode,
    /// The addressing mode for W coordinates outside [0, 1).
    address_mode_w: GPUSamplerAddressMode,
    /// The bias to be added to mipmap LOD calculation.
    mip_lod_bias: f32,
    /// The anisotropy value clamp used by the sampler. If enable_anisotropy is false, this is ignored.
    max_anisotropy: f32,
    /// The comparison operator to apply to fetched data before filtering.
    compare_op: GPUCompareOp,
    /// Clamps the minimum of the computed LOD value.
    min_lod: f32,
    /// Clamps the maximum of the computed LOD value.
    max_lod: f32,
    /// true to enable anisotropic filtering.
    enable_anisotropy: bool,
    /// true to enable comparison against a reference value during lookups.
    enable_compare: bool,

    padding1: u8 = 0,
    padding2: u8 = 0,

    /// A properties ID for extensions. Should be 0 if no extensions are needed.
    props: sdl.PropertiesId = .invalid,
};

pub const GPUVertexBufferDescription = extern struct {
    /// The binding slot of the vertex buffer.
    slot: u32,
    /// The size of a single element + the offset between elements.
    pitch: u32,
    /// Whether attribute addressing is a function of the vertex index or instance index.
    input_rate: GPUVertexInputRate,
    /// Reserved for future use. Must be set to 0.
    instance_step_rate: u32 = 0,
};

pub const GPUVertexAttribute = extern struct {
    /// The shader input location index.
    location: u32,
    /// The binding slot of the associated vertex buffer.
    buffer_slot: u32,
    /// The size and type of the attribute data.
    format: GPUVertexElementFormat,
    /// The byte offset of this attribute relative to the start of the vertex element.
    offset: u32,
};

pub const GPUVertexInputState = extern struct {
    /// A pointer to an array of vertex buffer descriptions.
    vertex_buffer_descriptions: [*c]const GPUVertexBufferDescription,
    /// The number of vertex buffer descriptions in the above array.
    num_vertex_buffers: u32,
    /// A pointer to an array of vertex attribute descriptions.
    vertex_attributes: [*c]const GPUVertexAttribute,
    /// The number of vertex attribute descriptions in the above array.
    num_vertex_attributes: u32,
};

pub const GPUStencilOpState = extern struct {
    /// The action performed on samples that fail the stencil test.
    fail_op: GPUStencilOp,
    /// The action performed on samples that pass the depth and stencil tests.
    pass_op: GPUStencilOp,
    /// The action performed on samples that pass the stencil test and fail the depth test.
    depth_fail_op: GPUStencilOp,
    /// The comparison operator used in the stencil test.
    compare_op: GPUCompareOp,
};

pub const GPUColorTargetBlendState = extern struct {
    /// The value to be multiplied by the source RGB value.
    src_color_blendfactor: GPUBlendFactor,
    /// The value to be multiplied by the destination RGB value.
    dst_color_blendfactor: GPUBlendFactor,
    /// The blend operation for the RGB components.
    color_blend_op: GPUBlendOp,
    /// The value to be multiplied by the source alpha.
    src_alpha_blendfactor: GPUBlendFactor,
    /// The value to be multiplied by the destination alpha.
    dst_alpha_blendfactor: GPUBlendFactor,
    /// The blend operation for the alpha component.
    alpha_blend_op: GPUBlendOp,
    /// A bitmask specifying which of the RGBA components are enabled for writing. Writes to all channels if enable_color_write_mask is false.
    color_write_mask: GPUColorComponentFlags,
    /// Whether blending is enabled for the color target.
    enable_blend: bool,
    /// Whether the color write mask is enabled.
    enable_color_write_mask: bool,

    padding1: u8 = 0,
    padding2: u8 = 0,
};

pub const GPUShaderCreateInfo = extern struct {
    /// The size in bytes of the code pointed to.
    code_size: usize,
    /// A pointer to shader code.
    code: *const u8,
    /// A pointer to a null-terminated UTF-8 string specifying the entry point function name for the shader.
    entrypoint: [*c]const u8,
    /// The format of the shader code.
    format: GPUShaderFormat,
    /// The stage the shader program corresponds to.
    stage: GPUShaderStage,
    /// The number of samplers defined in the shader.
    num_samplers: u32,
    /// The number of storage textures defined in the shader.
    num_storage_textures: u32,
    /// The number of storage buffers defined in the shader.
    num_storage_buffers: u32,
    /// The number of uniform buffers defined in the shader.
    num_uniform_buffers: u32,

    /// A properties ID for extensions. Should be 0 if no extensions are needed.
    props: sdl.PropertiesId = .invalid,
};

pub const GPUTextureCreateInfo = extern struct {
    /// The base dimensionality of the texture.
    type: GPUTextureType,
    /// The pixel format of the texture.
    format: GPUTextureFormat,
    /// How the texture is intended to be used by the client.
    usage: GPUTextureUsageFlags,
    /// The width of the texture.
    width: u32,
    /// The height of the texture.
    height: u32,
    /// The layer count or depth of the texture. This value is treated as a layer count on 2D array textures, and as a depth value on 3D textures.
    layer_count_or_depth: u32,
    /// The number of mip levels in the texture.
    num_levels: u32,
    /// The number of samples per texel. Only applies if the texture is used as a render target.
    sample_count: GPUSampleCount,

    /// A properties ID for extensions. Should be 0 if no extensions are needed.
    props: sdl.PropertiesId = .invalid,
};

pub const GPUBufferCreateInfo = extern struct {
    /// How the buffer is intended to be used by the client.
    usage: GPUBufferUsageFlags,
    /// The size in bytes of the buffer.
    size: u32,

    /// A properties ID for extensions. Should be 0 if no extensions are needed.
    props: sdl.PropertiesId = .invalid,
};

pub const GPUTransferBufferCreateInfo = extern struct {
    /// How the transfer buffer is intended to be used by the client.
    usage: GPUTransferBufferUsage,
    /// The size in bytes of the transfer buffer.
    size: u32,

    /// A properties ID for extensions. Should be 0 if no extensions are needed.
    props: sdl.PropertiesId = .invalid,
};

pub const GPURasterizerState = extern struct {
    /// Whether polygons will be filled in or drawn as lines.
    fill_mode: GPUFillMode,
    /// The facing direction in which triangles will be culled.
    cull_mode: GPUCullMode,
    /// The vertex winding that will cause a triangle to be determined as front-facing.
    front_face: GPUFrontFace,
    /// A scalar factor controlling the depth value added to each fragment.
    depth_bias_constant_factor: f32,
    /// The maximum depth bias of a fragment.
    depth_bias_clamp: f32,
    /// A scalar factor applied to a fragment's slope in depth calculations.
    depth_bias_slope_factor: f32,
    /// true to bias fragment depth values.
    enable_depth_bias: bool,
    /// true to enable depth clip, false to enable depth clamp.
    enable_depth_clip: bool,

    padding1: u8 = 0,
    padding2: u8 = 0,
};

pub const GPUMultisampleState = extern struct {
    /// The number of samples to be used in rasterization.
    sample_count: GPUSampleCount,
    /// Reserved for future use. Must be set to 0.
    sample_mask: u32 = 0,
    /// Reserved for future use. Must be set to false.
    enable_mask: bool = false,

    padding1: u8 = 0,
    padding2: u8 = 0,
    padding3: u8 = 0,
};

pub const GPUDepthStencilState = extern struct {
    /// The comparison operator used for depth testing.
    compare_op: GPUCompareOp,
    /// The stencil op state for back-facing triangles.
    back_stencil_state: GPUStencilOpState,
    /// The stencil op state for front-facing triangles.
    front_stencil_state: GPUStencilOpState,
    /// Selects the bits of the stencil values participating in the stencil test.
    compare_mask: u8,
    /// Selects the bits of the stencil values updated by the stencil test.
    write_mask: u8,
    /// true enables the depth test.
    enable_depth_test: bool,
    /// true enables depth writes. Depth writes are always disabled when enable_depth_test is false.
    enable_depth_write: bool,
    /// true enables the stencil test.
    enable_stencil_test: bool,

    padding1: u8 = 0,
    padding2: u8 = 0,
    padding3: u8 = 0,
};

pub const GPUColorTargetDescription = extern struct {
    /// The pixel format of the texture to be used as a color target.
    format: GPUTextureFormat,
    /// The blend state to be used for the color target.
    blend_state: GPUColorTargetBlendState,
};

pub const GPUGraphicsPipelineTargetInfo = extern struct {
    /// A pointer to an array of color target descriptions.
    color_target_descriptions: [*c]const GPUColorTargetDescription,
    /// The number of color target descriptions in the above array.
    num_color_targets: u32,
    /// The pixel format of the depth-stencil target. Ignored if has_depth_stencil_target is false.
    depth_stencil_format: GPUTextureFormat,
    /// true specifies that the pipeline uses a depth-stencil target.
    has_depth_stencil_target: bool,

    padding1: u8 = 0,
    padding2: u8 = 0,
    padding3: u8 = 0,
};

pub const GPUGraphicsPipelineCreateInfo = extern struct {
    /// The vertex shader used by the graphics pipeline.
    vertex_shader: *GPUShader,
    /// The fragment shader used by the graphics pipeline.
    fragment_shader: *GPUShader,
    /// The vertex layout of the graphics pipeline.
    vertex_input_state: GPUVertexInputState,
    /// The primitive topology of the graphics pipeline.
    primitive_type: GPUPrimitiveType,
    /// The rasterizer state of the graphics pipeline.
    rasterizer_state: GPURasterizerState,
    /// The multisample state of the graphics pipeline.
    multisample_state: GPUMultisampleState,
    /// The depth-stencil state of the graphics pipeline.
    depth_stencil_state: GPUDepthStencilState,
    /// Formats and blend modes for the render targets of the graphics pipeline.
    target_info: GPUGraphicsPipelineTargetInfo,

    /// A properties ID for extensions. Should be 0 if no extensions are needed.
    props: sdl.PropertiesId = .invalid,
};

pub const GPUComputePipelineCreateInfo = extern struct {
    /// The size in bytes of the compute shader code pointed to.
    code_size: usize,
    /// A pointer to compute shader code.
    code: *const u8,
    /// A pointer to a null-terminated UTF-8 string specifying the entry point function name for the shader.
    entrypoint: [*c]const u8,
    /// The format of the compute shader code.
    format: GPUShaderFormat,
    /// The number of samplers defined in the shader.
    num_samplers: u32,
    /// The number of readonly storage textures defined in the shader.
    num_readonly_storage_textures: u32,
    /// The number of readonly storage buffers defined in the shader.
    num_readonly_storage_buffers: u32,
    /// The number of read-write storage textures defined in the shader.
    num_readwrite_storage_textures: u32,
    /// The number of read-write storage buffers defined in the shader.
    num_readwrite_storage_buffers: u32,
    /// The number of uniform buffers defined in the shader.
    num_uniform_buffers: u32,
    /// The number of threads in the X dimension. This should match the value in the shader.
    threadcount_x: u32,
    /// The number of threads in the Y dimension. This should match the value in the shader.
    threadcount_y: u32,
    /// The number of threads in the Z dimension. This should match the value in the shader.
    threadcount_z: u32,

    /// A properties ID for extensions. Should be 0 if no extensions are needed.
    props: sdl.PropertiesId = .invalid,
};

pub const GPUColorTargetInfo = extern struct {
    /// The texture that will be used as a color target by a render pass.
    texture: *GPUTexture,
    ///  The mip level to use as a color target.
    mip_level: u32,
    ///  The layer index or depth plane to use as a color target. This value is treated as a layer index on 2D array and cube textures, and as a depth plane on 3D textures.
    layer_or_depth_plane: u32,
    ///  The color to clear the color target to at the start of the render pass. Ignored if SDL_GPU_LOADOP_CLEAR is not used.
    clear_color: sdl.FColor,
    ///  What is done with the contents of the color target at the beginning of the render pass.
    load_op: GPULoadOp,
    ///  What is done with the results of the render pass.
    store_op: GPUStoreOp,
    ///  The texture that will receive the results of a multisample resolve operation. Ignored if a RESOLVE* store_op is not used.
    resolve_texture: ?*GPUTexture = null,
    ///  The mip level of the resolve texture to use for the resolve operation. Ignored if a RESOLVE* store_op is not used.
    resolve_mip_level: u32 = 0,
    ///  The layer index of the resolve texture to use for the resolve operation. Ignored if a RESOLVE* store_op is not used.
    resolve_layer: u32 = 0,
    /// true cycles the texture if the texture is bound and load_op is not LOAD
    cycle: bool,
    ///  true cycles the resolve texture if the resolve texture is bound. Ignored if a RESOLVE* store_op is not used.
    cycle_resolve_texture: bool = false,

    padding1: u8 = 0,
    padding2: u8 = 0,
};

pub const GPUDepthStencilTargetInfo = extern struct {
    ///  The texture that will be used as the depth stencil target by the render pass.
    texture: *GPUTexture,
    ///  The value to clear the depth component to at the beginning of the render pass. Ignored if SDL_GPU_LOADOP_CLEAR is not used.
    clear_depth: f32,
    ///  What is done with the depth contents at the beginning of the render pass.
    load_op: GPULoadOp,
    ///  What is done with the depth results of the render pass.
    store_op: GPUStoreOp,
    ///  What is done with the stencil contents at the beginning of the render pass.
    stencil_load_op: GPULoadOp,
    ///  What is done with the stencil results of the render pass.
    stencil_store_op: GPUStoreOp,
    /// true cycles the texture if the texture is bound and any load ops are not LOAD
    cycle: bool,
    ///  The value to clear the stencil component to at the beginning of the render pass. Ignored if SDL_GPU_LOADOP_CLEAR is not used.
    clear_stencil: u8,

    padding1: u8 = 0,
    padding2: u8 = 0,
};

pub const GPUBlitInfo = extern struct {
    /// The source region for the blit.
    source: GPUBlitRegion,
    /// The destination region for the blit.
    destination: GPUBlitRegion,
    /// What is done with the contents of the destination before the blit.
    load_op: GPULoadOp,
    /// The color to clear the destination region to before the blit. Ignored if load_op is not SDL_GPU_LOADOP_CLEAR.
    clear_color: sdl.FColor,
    /// The flip mode for the source region.
    flip_mode: sdl.FlipMode,
    /// The filter mode used when blitting.
    filter: GPUFilter,
    /// true cycles the destination texture if it is already bound.
    cycle: bool,

    padding1: u8 = 0,
    padding2: u8 = 0,
    padding3: u8 = 0,
};

// Binding structs

pub const GPUBufferBinding = extern struct {
    /// The buffer to bind. Must have been created with SDL_GPU_BUFFERUSAGE_VERTEX for SDL_BindGPUVertexBuffers, or SDL_GPU_BUFFERUSAGE_INDEX for SDL_BindGPUIndexBuffer.
    buffer: *GPUBuffer,
    /// The starting byte of the data to bind in the buffer.
    offset: u32,
};

pub const GPUTextureSamplerBinding = extern struct {
    /// The texture to bind. Must have been created with SDL_GPU_TEXTUREUSAGE_SAMPLER.
    texture: *GPUTexture,
    /// The sampler to bind.
    sampler: *GPUSampler,
};

pub const GPUStorageBufferReadWriteBinding = extern struct {
    /// The buffer to bind. Must have been created with SDL_GPU_BUFFERUSAGE_COMPUTE_STORAGE_WRITE.
    buffer: *GPUBuffer,
    /// true cycles the buffer if it is already bound.
    cycle: bool,

    padding1: u8 = 0,
    padding2: u8 = 0,
    padding3: u8 = 0,
};

pub const GPUStorageTextureReadWriteBinding = extern struct {
    /// The texture to bind. Must have been created with SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_WRITE or SDL_GPU_TEXTUREUSAGE_COMPUTE_STORAGE_SIMULTANEOUS_READ_WRITE.
    texture: *GPUTexture,
    /// The mip level index to bind.
    mip_level: u32,
    /// The layer index to bind.
    layer: u32,
    /// true cycles the texture if it is already bound.
    cycle: bool,

    padding1: u8 = 0,
    padding2: u8 = 0,
    padding3: u8 = 0,
};

// Functions

// Device

pub fn gpuSupportsShaderFormats(format_flags: GPUShaderFormat, maybe_name: ?[:0]const u8) bool {
    return SDL_GPUSupportsShaderFormats(
        format_flags,
        if (maybe_name) |name| @as([*c]const u8, @ptrCast(name.ptr)) else null,
    );
}
extern fn SDL_GPUSupportsShaderFormats(GPUShaderFormat, [*c]const u8) bool;

pub fn gpuSupportsProperties(props: sdl.PropertiesId) bool {
    return SDL_GPUSupportsProperties(props);
}
extern fn SDL_GPUSupportsProperties(sdl.PropertiesId) bool;

pub fn createGPUDevice(format_flags: GPUShaderFormat, debug_mode: bool, maybe_name: ?[:0]const u8) Error!*GPUDevice {
    const maybe_gpu = SDL_CreateGPUDevice(
        format_flags,
        debug_mode,
        if (maybe_name) |name| @as([*c]const u8, @ptrCast(name.ptr)) else null,
    );
    return if (maybe_gpu) |gpu| gpu else makeError();
}
extern fn SDL_CreateGPUDevice(GPUShaderFormat, bool, [*c]const u8) ?*GPUDevice;

pub fn createGPUDeviceWithProperties(props: sdl.PropertiesId) Error!*GPUDevice {
    const maybe_gpu = SDL_CreateGPUDeviceWithProperties(props);
    return if (maybe_gpu) |gpu| gpu else makeError();
}
extern fn SDL_CreateGPUDeviceWithProperties(sdl.PropertiesId) ?*GPUDevice;

pub const destroyGPUDevice = SDL_DestroyGPUDevice;
extern fn SDL_DestroyGPUDevice(device: *GPUDevice) void;

pub const getNumGPUDrivers = SDL_GetNumGPUDrivers;
extern fn SDL_GetNumGPUDrivers() c_int;

pub fn getGPUDriver(index: c_int) [:0]const u8 {
    const driver = SDL_GetGPUDriver(index);
    return std.mem.span(driver);
}
extern fn SDL_GetGPUDriver(c_int) [*c]const u8;

pub fn getGPUDeviceDriver(device: *GPUDevice) Error![:0]const u8 {
    const maybe_driver = SDL_GetGPUDeviceDriver(device);
    return if (maybe_driver) |driver| std.mem.span(driver) else makeError();
}
extern fn SDL_GetGPUDeviceDriver(*GPUDevice) [*c]const u8;

pub const getGPUShaderFormats = SDL_GetGPUShaderFormats;
extern fn SDL_GetGPUShaderFormats(device: *GPUDevice) GPUShaderFormat;

// State Creation
pub fn createGPUComputePipeline(device: *GPUDevice, createinfo: *const GPUComputePipelineCreateInfo) Error!*GPUComputePipeline {
    const maybe_compute_pipeline = SDL_CreateGPUComputePipeline(device, createinfo);
    return if (maybe_compute_pipeline) |compute_pipeline| compute_pipeline else makeError();
}
extern fn SDL_CreateGPUComputePipeline(*GPUDevice, *const GPUComputePipelineCreateInfo) ?*GPUComputePipeline;

pub fn createGPUGraphicsPipeline(device: *GPUDevice, createinfo: *const GPUGraphicsPipelineCreateInfo) Error!*GPUGraphicsPipeline {
    const maybe_graphics_pipeline = SDL_CreateGPUGraphicsPipeline(device, createinfo);
    return if (maybe_graphics_pipeline) |graphics_pipeline| graphics_pipeline else makeError();
}
extern fn SDL_CreateGPUGraphicsPipeline(*GPUDevice, *const GPUGraphicsPipelineCreateInfo) ?*GPUGraphicsPipeline;

pub fn createGPUSampler(device: *GPUDevice, createinfo: *const GPUSamplerCreateInfo) Error!*GPUSampler {
    const maybe_sampler = SDL_CreateGPUSampler(device, createinfo);
    return if (maybe_sampler) |sampler| sampler else makeError();
}
extern fn SDL_CreateGPUSampler(*GPUDevice, *const GPUSamplerCreateInfo) ?*GPUSampler;

pub fn createGPUShader(device: *GPUDevice, createinfo: *const GPUShaderCreateInfo) Error!*GPUShader {
    const maybe_shader = SDL_CreateGPUShader(device, createinfo);
    return if (maybe_shader) |shader| shader else makeError();
}
extern fn SDL_CreateGPUShader(*GPUDevice, *const GPUShaderCreateInfo) ?*GPUShader;

pub fn createGPUTexture(device: *GPUDevice, createinfo: *const GPUTextureCreateInfo) Error!*GPUTexture {
    const maybe_texture = SDL_CreateGPUTexture(device, createinfo);
    return if (maybe_texture) |texture| texture else makeError();
}
extern fn SDL_CreateGPUTexture(*GPUDevice, *const GPUTextureCreateInfo) ?*GPUTexture;

pub fn createGPUBuffer(device: *GPUDevice, createinfo: *const GPUBufferCreateInfo) Error!*GPUBuffer {
    const maybe_buffer = SDL_CreateGPUBuffer(device, createinfo);
    return if (maybe_buffer) |buffer| buffer else makeError();
}
extern fn SDL_CreateGPUBuffer(*GPUDevice, *const GPUBufferCreateInfo) ?*GPUBuffer;

pub fn createGPUTransferBuffer(device: *GPUDevice, createinfo: *const GPUTransferBufferCreateInfo) Error!*GPUTransferBuffer {
    const maybe_buffer = SDL_CreateGPUTransferBuffer(device, createinfo);
    return if (maybe_buffer) |buffer| buffer else makeError();
}
extern fn SDL_CreateGPUTransferBuffer(*GPUDevice, *const GPUTransferBufferCreateInfo) ?*GPUTransferBuffer;

// Debug Naming

pub const setGPUBufferName = SDL_SetGPUBufferName;
extern fn SDL_SetGPUBufferName(device: *GPUDevice, buffer: *GPUBuffer, text: [*c]const u8) void;

pub const setGPUTextureName = SDL_SetGPUTextureName;
extern fn SDL_SetGPUTextureName(device: *GPUDevice, texture: *GPUTexture, text: [*c]const u8) void;

pub const insertGPUDebugLabel = SDL_InsertGPUDebugLabel;
extern fn SDL_InsertGPUDebugLabel(command_buffer: *GPUCommandBuffer, text: [*c]const u8) void;

pub const pushGPUDebugGroup = SDL_PushGPUDebugGroup;
extern fn SDL_PushGPUDebugGroup(command_buffer: *GPUCommandBuffer, name: [*c]const u8) void;

pub const popGPUDebugGroup = SDL_PopGPUDebugGroup;
extern fn SDL_PopGPUDebugGroup(command_buffer: *GPUCommandBuffer) void;

// Disposal

pub const releaseGPUTexture = SDL_ReleaseGPUTexture;
extern fn SDL_ReleaseGPUTexture(device: *GPUDevice, texture: *GPUTexture) void;

pub const releaseGPUSampler = SDL_ReleaseGPUSampler;
extern fn SDL_ReleaseGPUSampler(device: *GPUDevice, sampler: *GPUSampler) void;

pub const releaseGPUBuffer = SDL_ReleaseGPUBuffer;
extern fn SDL_ReleaseGPUBuffer(device: *GPUDevice, buffer: *GPUBuffer) void;

pub const releaseGPUTransferBuffer = SDL_ReleaseGPUTransferBuffer;
extern fn SDL_ReleaseGPUTransferBuffer(device: *GPUDevice, transfer_buffer: *GPUTransferBuffer) void;

pub const releaseGPUComputePipeline = SDL_ReleaseGPUComputePipeline;
extern fn SDL_ReleaseGPUComputePipeline(device: *GPUDevice, compute_pipeline: *GPUComputePipeline) void;

pub const releaseGPUShader = SDL_ReleaseGPUShader;
extern fn SDL_ReleaseGPUShader(device: *GPUDevice, shader: *GPUShader) void;

pub const releaseGPUGraphicsPipeline = SDL_ReleaseGPUGraphicsPipeline;
extern fn SDL_ReleaseGPUGraphicsPipeline(device: *GPUDevice, graphics_pipeline: *GPUGraphicsPipeline) void;

pub fn acquireGPUCommandBuffer(device: *GPUDevice) Error!*GPUCommandBuffer {
    const maybe_command_buffer = SDL_AcquireGPUCommandBuffer(device);
    return if (maybe_command_buffer) |command_buffer| command_buffer else makeError();
}
extern fn SDL_AcquireGPUCommandBuffer(*GPUDevice) ?*GPUCommandBuffer;

// Uniform Data

pub const pushGPUVertexUniformData = SDL_PushGPUVertexUniformData;
extern fn SDL_PushGPUVertexUniformData(command_buffer: *GPUCommandBuffer, slot_index: u32, data: *const anyopaque, length: u32) void;

pub const pushGPUFragmentUniformData = SDL_PushGPUFragmentUniformData;
extern fn SDL_PushGPUFragmentUniformData(command_buffer: *GPUCommandBuffer, slot_index: u32, data: *const anyopaque, length: u32) void;

pub const pushGPUComputeUniformData = SDL_PushGPUComputeUniformData;
extern fn SDL_PushGPUComputeUniformData(command_buffer: *GPUCommandBuffer, slot_index: u32, data: *const anyopaque, length: u32) void;

// Graphics State

pub const beginGPURenderPass = SDL_BeginGPURenderPass;
extern fn SDL_BeginGPURenderPass(
    command_buffer: *GPUCommandBuffer,
    color_target_infos: [*c]const GPUColorTargetInfo,
    num_color_targets: u32,
    depth_stencil_target_info: ?*const GPUDepthStencilTargetInfo,
) *GPURenderPass;

pub const bindGPUGraphicsPipeline = SDL_BindGPUGraphicsPipeline;
extern fn SDL_BindGPUGraphicsPipeline(render_pass: *GPURenderPass, graphics_pipeline: *GPUGraphicsPipeline) void;

pub const setGPUViewport = SDL_SetGPUViewport;
extern fn SDL_SetGPUViewport(render_pass: *GPURenderPass, viewport: *const GPUViewport) void;

pub const setGPUScissor = SDL_SetGPUScissor;
extern fn SDL_SetGPUScissor(render_pass: *GPURenderPass, scissor: *const sdl.Rect) void;

pub const setGPUBlendConstants = SDL_SetGPUBlendConstants;
extern fn SDL_SetGPUBlendConstants(render_pass: *GPURenderPass, blend_constants: sdl.FColor) void;

pub const setGPUStencilReference = SDL_SetGPUStencilReference;
extern fn SDL_SetGPUStencilReference(render_pass: *GPURenderPass, reference: u8) void;

pub const bindGPUVertexBuffers = SDL_BindGPUVertexBuffers;
extern fn SDL_BindGPUVertexBuffers(render_pass: *GPURenderPass, first_slot: u32, [*c]const GPUBufferBinding, num_bindings: u32) void;

pub const bindGPUIndexBuffer = SDL_BindGPUIndexBuffer;
extern fn SDL_BindGPUIndexBuffer(render_pass: *GPURenderPass, binding: *const GPUBufferBinding, index_element_size: GPUIndexElementSize) void;

pub const bindGPUVertexSamplers = SDL_BindGPUVertexSamplers;
extern fn SDL_BindGPUVertexSamplers(
    render_pass: *GPURenderPass,
    first_slot: u32,
    texture_sampler_bindings: [*c]const GPUTextureSamplerBinding,
    num_bindings: u32,
) void;

pub const bindGPUVertexStorageTextures = SDL_BindGPUVertexStorageTextures;
extern fn SDL_BindGPUVertexStorageTextures(
    render_pass: *GPURenderPass,
    first_slot: u32,
    storage_textures: [*c]const *GPUTexture,
    num_bindings: u32,
) void;

pub const bindGPUVertexStorageBuffers = SDL_BindGPUVertexStorageBuffers;
extern fn SDL_BindGPUVertexStorageBuffers(
    render_pass: *GPURenderPass,
    first_slot: u32,
    storage_buffers: [*c]const *GPUBuffer,
    num_bindings: u32,
) void;

pub const bindGPUFragmentSamplers = SDL_BindGPUFragmentSamplers;
extern fn SDL_BindGPUFragmentSamplers(
    render_pass: *GPURenderPass,
    first_slot: u32,
    texture_sampler_bindings: [*c]const GPUTextureSamplerBinding,
    num_bindings: u32,
) void;

pub const bindGPUFragmentStorageTextures = SDL_BindGPUFragmentStorageTextures;
extern fn SDL_BindGPUFragmentStorageTextures(
    render_pass: *GPURenderPass,
    first_slot: u32,
    storage_textures: [*c]const *GPUTexture,
    num_bindings: u32,
) void;

pub const bindGPUFragmentStorageBuffers = SDL_BindGPUFragmentStorageBuffers;
extern fn SDL_BindGPUFragmentStorageBuffers(
    render_pass: *GPURenderPass,
    first_slot: u32,
    storage_buffers: [*c]const *GPUBuffer,
    num_bindings: u32,
) void;

// Drawing

pub const drawGPUIndexedPrimitives = SDL_DrawGPUIndexedPrimitives;
extern fn SDL_DrawGPUIndexedPrimitives(
    render_pass: *GPURenderPass,
    num_indices: u32,
    num_instances: u32,
    first_index: u32,
    vertex_offset: i32,
    first_instance: u32,
) void;

pub const drawGPUPrimitives = SDL_DrawGPUPrimitives;
extern fn SDL_DrawGPUPrimitives(
    render_pass: *GPURenderPass,
    num_vertices: u32,
    num_instances: u32,
    first_vertex: u32,
    first_instance: u32,
) void;

pub const drawGPUPrimitivesIndirect = SDL_DrawGPUPrimitivesIndirect;
extern fn SDL_DrawGPUPrimitivesIndirect(
    render_pass: *GPURenderPass,
    buffer: *GPUBuffer,
    offset: u32,
    draw_count: u32,
) void;

pub const drawGPUIndexedPrimitivesIndirect = SDL_DrawGPUIndexedPrimitivesIndirect;
extern fn SDL_DrawGPUIndexedPrimitivesIndirect(
    render_pass: *GPURenderPass,
    buffer: *GPUBuffer,
    offset: u32,
    draw_count: u32,
) void;

pub const endGPURenderPass = SDL_EndGPURenderPass;
extern fn SDL_EndGPURenderPass(render_pass: *GPURenderPass) void;

// Compute Pass

pub const beginGPUComputePass = SDL_BeginGPUComputePass;
extern fn SDL_BeginGPUComputePass(
    command_buffer: *GPUCommandBuffer,
    storage_texture_bindings: [*c]const GPUStorageTextureReadWriteBinding,
    num_storage_texture_bindings: u32,
    storage_buffer_bindings: [*c]const GPUStorageBufferReadWriteBinding,
    num_storage_buffer_bindings: u32,
) *GPUComputePass;

pub const bindGPUComputePipeline = SDL_BindGPUComputePipeline;
extern fn SDL_BindGPUComputePipeline(compute_pass: *GPUComputePass, compute_pipeline: *GPUComputePipeline) void;

pub const bindGPUComputeSamplers = SDL_BindGPUComputeSamplers;
extern fn SDL_BindGPUComputeSamplers(
    compute_pass: *GPUComputePass,
    first_slot: u32,
    texture_sampler_bindings: [*c]const GPUTextureSamplerBinding,
    num_bindings: u32,
) void;

pub const bindGPUComputeStorageTextures = SDL_BindGPUComputeStorageTextures;
extern fn SDL_BindGPUComputeStorageTextures(
    compute_pass: *GPUComputePass,
    first_slot: u32,
    storage_textures: [*c]const *GPUTexture,
    num_bindings: u32,
) void;

pub const bindGPUComputeStorageBuffers = SDL_BindGPUComputeStorageBuffers;
extern fn SDL_BindGPUComputeStorageBuffers(
    compute_pass: *GPUComputePass,
    first_slot: u32,
    storage_buffers: [*c]const *GPUBuffer,
    num_bindings: u32,
) void;

pub const dispatchGPUCompute = SDL_DispatchGPUCompute;
extern fn SDL_DispatchGPUCompute(compute_pass: *GPUComputePass, groupcount_x: u32, groupcount_y: u32, groupcount_z: u32) void;

pub const dispatchGPUComputeIndirect = SDL_DispatchGPUComputeIndirect;
extern fn SDL_DispatchGPUComputeIndirect(compute_pass: *GPUComputePass, buffer: *GPUBuffer, offset: u32) void;

pub const endGPUComputePass = SDL_EndGPUComputePass;
extern fn SDL_EndGPUComputePass(compute_pass: *GPUComputePass) void;

// TransferBuffer Data

pub fn mapGPUTransferBuffer(device: *GPUDevice, transfer_buffer: *GPUTransferBuffer, cycle: bool) Error!*anyopaque {
    const maybe_address = SDL_MapGPUTransferBuffer(device, transfer_buffer, cycle);
    return if (maybe_address) |address| address else makeError();
}
extern fn SDL_MapGPUTransferBuffer(*GPUDevice, *GPUTransferBuffer, bool) ?*anyopaque;

pub const unmapGPUTransferBuffer = SDL_UnmapGPUTransferBuffer;
extern fn SDL_UnmapGPUTransferBuffer(device: *GPUDevice, transfer_buffer: *GPUTransferBuffer) void;

// Copy Pass

pub const beginGPUCopyPass = SDL_BeginGPUCopyPass;
extern fn SDL_BeginGPUCopyPass(command_buffer: *GPUCommandBuffer) *GPUCopyPass;

pub const uploadToGPUTexture = SDL_UploadToGPUTexture;
extern fn SDL_UploadToGPUTexture(
    copy_pass: *GPUCopyPass,
    source: *const GPUTextureTransferInfo,
    destination: *const GPUTextureRegion,
    cycle: bool,
) void;

pub const uploadToGPUBuffer = SDL_UploadToGPUBuffer;
extern fn SDL_UploadToGPUBuffer(
    copy_pass: *GPUCopyPass,
    source: *const GPUTransferBufferLocation,
    destination: *const GPUBufferRegion,
    cycle: bool,
) void;

pub const copyGPUTextureToTexture = SDL_CopyGPUTextureToTexture;
extern fn SDL_CopyGPUTextureToTexture(
    copy_pass: *GPUCopyPass,
    source: *const GPUTextureLocation,
    destination: *const GPUTextureLocation,
    w: u32,
    h: u32,
    d: u32,
    cycle: bool,
) void;

pub const copyGPUBufferToBuffer = SDL_CopyGPUBufferToBuffer;
extern fn SDL_CopyGPUBufferToBuffer(
    copy_pass: *GPUCopyPass,
    source: *const GPUBufferLocation,
    destination: *const GPUBufferLocation,
    size: u32,
    cycle: bool,
) void;

pub const downloadFromGPUTexture = SDL_DownloadFromGPUTexture;
extern fn SDL_DownloadFromGPUTexture(
    copy_pass: *GPUCopyPass,
    source: *const GPUTextureRegion,
    destination: *const GPUTextureTransferInfo,
) void;

pub const downloadFromGPUBuffer = SDL_DownloadFromGPUBuffer;
extern fn SDL_DownloadFromGPUBuffer(
    copy_pass: *GPUCopyPass,
    source: *const GPUBufferRegion,
    destination: *const GPUTransferBufferLocation,
) void;

pub const endGPUCopyPass = SDL_EndGPUCopyPass;
extern fn SDL_EndGPUCopyPass(copy_pass: *GPUCopyPass) void;

pub const generateMipmapsForGPUTexture = SDL_GenerateMipmapsForGPUTexture;
extern fn SDL_GenerateMipmapsForGPUTexture(command_buffer: *GPUCommandBuffer, texture: *GPUTexture) void;

pub const blitGPUTexture = SDL_BlitGPUTexture;
extern fn SDL_BlitGPUTexture(command_buffer: *GPUCommandBuffer, info: *const GPUBlitInfo) void;

// Submission/Presentation

pub const windowSupportsGPUSwapchainComposition = SDL_WindowSupportsGPUSwapchainComposition;
extern fn SDL_WindowSupportsGPUSwapchainComposition(
    device: *GPUDevice,
    window: *sdl.Window,
    swapchain_composition: GPUSwapchainComposition,
) bool;

pub const windowSupportsGPUPresentMode = SDL_WindowSupportsGPUPresentMode;
extern fn SDL_WindowSupportsGPUPresentMode(
    device: *GPUDevice,
    window: *sdl.Window,
    present_mode: GPUPresentMode,
) bool;

pub fn claimWindowForGPUDevice(device: *GPUDevice, window: *sdl.Window) Error!void {
    if (!SDL_ClaimWindowForGPUDevice(device, window)) return makeError();
}
extern fn SDL_ClaimWindowForGPUDevice(*GPUDevice, *sdl.Window) bool;

pub const releaseWindowFromGPUDevice = SDL_ReleaseWindowFromGPUDevice;
extern fn SDL_ReleaseWindowFromGPUDevice(device: *GPUDevice, window: *sdl.Window) void;

pub fn setGPUSwapchainParameters(
    device: *GPUDevice,
    window: *sdl.Window,
    swapchain_composition: GPUSwapchainComposition,
    present_mode: GPUPresentMode,
) Error!void {
    if (!SDL_SetGPUSwapchainParameters(device, window, swapchain_composition, present_mode)) return makeError();
}
extern fn SDL_SetGPUSwapchainParameters(*GPUDevice, *sdl.Window, GPUSwapchainComposition, GPUPresentMode) bool;

pub fn setGPUAllowedFramesInFlight(device: *GPUDevice, allowed_frames_in_flight: u32) Error!void {
    if (!SDL_SetGPUAllowedFramesInFlight(device, allowed_frames_in_flight)) return makeError();
}
extern fn SDL_SetGPUAllowedFramesInFlight(*GPUDevice, u32) bool;

pub const getGPUSwapchainTextureFormat = SDL_GetGPUSwapchainTextureFormat;
extern fn SDL_GetGPUSwapchainTextureFormat(device: *GPUDevice, window: *sdl.Window) GPUTextureFormat;

pub fn acquireGPUSwapchainTexture(
    command_buffer: *GPUCommandBuffer,
    window: *sdl.Window,
    swapchain_texture: *?*GPUTexture,
    swapchain_texture_width: ?*u32,
    swapchain_texture_height: ?*u32,
) Error!void {
    if (!SDL_AcquireGPUSwapchainTexture(
        command_buffer,
        window,
        swapchain_texture,
        swapchain_texture_width,
        swapchain_texture_height,
    )) return makeError();
}
extern fn SDL_AcquireGPUSwapchainTexture(*GPUCommandBuffer, *sdl.Window, *?*GPUTexture, ?*u32, ?*u32) bool;

pub fn waitForGPUSwapchain(device: *GPUDevice, window: *sdl.Window) Error!void {
    if (!SDL_WaitForGPUSwapchain(device, window)) return makeError();
}
extern fn SDL_WaitForGPUSwapchain(*GPUDevice, *sdl.Window) bool;

pub fn waitAndAcquireGPUSwapchainTexture(
    command_buffer: *GPUCommandBuffer,
    window: *sdl.Window,
    swapchain_texture: *?*GPUTexture,
    swapchain_texture_width: ?*u32,
    swapchain_texture_height: ?*u32,
) Error!void {
    if (!SDL_WaitAndAcquireGPUSwapchainTexture(
        command_buffer,
        window,
        swapchain_texture,
        swapchain_texture_width,
        swapchain_texture_height,
    )) return makeError();
}
extern fn SDL_WaitAndAcquireGPUSwapchainTexture(*GPUCommandBuffer, *sdl.Window, *?*GPUTexture, ?*u32, ?*u32) bool;

pub fn submitGPUCommandBuffer(command_buffer: *GPUCommandBuffer) Error!void {
    if (!SDL_SubmitGPUCommandBuffer(command_buffer)) return makeError();
}
extern fn SDL_SubmitGPUCommandBuffer(*GPUCommandBuffer) bool;

pub fn submitGPUCommandBufferAndAcquireFence(command_buffer: *GPUCommandBuffer) Error!*GPUFence {
    const maybe_fence = SDL_SubmitGPUCommandBufferAndAcquireFence(command_buffer);
    return if (maybe_fence) |fence| fence else makeError();
}
extern fn SDL_SubmitGPUCommandBufferAndAcquireFence(*GPUCommandBuffer) ?*GPUFence;

pub fn cancelGPUCommandBuffer(command_buffer: *GPUCommandBuffer) Error!void {
    if (!SDL_CancelGPUCommandBuffer(command_buffer)) return makeError();
}
extern fn SDL_CancelGPUCommandBuffer(*GPUCommandBuffer) bool;

pub fn waitForGPUIdle(device: *GPUDevice) Error!void {
    if (!SDL_WaitForGPUIdle(device)) return makeError();
}
extern fn SDL_WaitForGPUIdle(*GPUDevice) bool;

pub fn waitForGPUFences(device: *GPUDevice, wait_all: bool, fences: [*]const *GPUFence, num_fences: u32) Error!void {
    if (!SDL_WaitForGPUFences(device, wait_all, fences, num_fences)) return makeError();
}
extern fn SDL_WaitForGPUFences(*GPUDevice, bool, [*c]const *GPUFence, u32) bool;

pub const queryGPUFence = SDL_QueryGPUFence;
extern fn SDL_QueryGPUFence(device: *GPUDevice, fence: *GPUFence) bool;

pub const releaseGPUFence = SDL_ReleaseGPUFence;
extern fn SDL_ReleaseGPUFence(device: *GPUDevice, fence: *GPUFence) void;

// Format Info

pub const gpuTextureFormatTexelBlockSize = SDL_GPUTextureFormatTexelBlockSize;
extern fn SDL_GPUTextureFormatTexelBlockSize(format: GPUTextureFormat) u32;

pub const gpuTextureSupportsFormat = SDL_GPUTextureSupportsFormat;
extern fn SDL_GPUTextureSupportsFormat(
    device: *GPUDevice,
    format: GPUTextureFormat,
    type: GPUTextureType,
    usage: GPUTextureUsageFlags,
) bool;

pub const gpuTextureSupportsSampleCount = SDL_GPUTextureSupportsSampleCount;
extern fn SDL_GPUTextureSupportsSampleCount(
    device: *GPUDevice,
    format: GPUTextureFormat,
    sample_count: GPUSampleCount,
) bool;

pub const calculateGPUTextureFormatSize = SDL_CalculateGPUTextureFormatSize;
extern fn SDL_CalculateGPUTextureFormatSize(
    format: GPUTextureFormat,
    width: u32,
    height: u32,
    depth_or_layer_count: u32,
) u32;

// These two need special handling to be defined only on GDK platform.
// TODO:
// - SDL_GDKSuspendGPU
// - SDL_GDKResumeGPU
