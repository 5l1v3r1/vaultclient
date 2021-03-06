#pragma clang diagnostic ignored "-Wmissing-prototypes"

#include <metal_stdlib>
#include <simd/simd.h>

using namespace metal;

struct type_u_cameraPlaneParams
{
    float s_CameraNearPlane;
    float s_CameraFarPlane;
    float u_clipZNear;
    float u_clipZFar;
};

struct type_u_fragParams
{
    float4 u_screenParams;
    float4x4 u_inverseViewProjection;
    float4x4 u_inverseProjection;
    float4 u_eyeToEarthSurfaceEyeSpace;
    float4 u_outlineColour;
    float4 u_outlineParams;
    float4 u_colourizeHeightColourMin;
    float4 u_colourizeHeightColourMax;
    float4 u_colourizeHeightParams;
    float4 u_colourizeDepthColour;
    float4 u_colourizeDepthParams;
    float4 u_contourColour;
    float4 u_contourParams;
};

struct main0_out
{
    float4 out_var_SV_Target0 [[color(0)]];
    float4 out_var_SV_Target1 [[color(1)]];
    float gl_FragDepth [[depth(any)]];
};

struct main0_in
{
    float4 in_var_TEXCOORD0 [[user(locn0)]];
    float2 in_var_TEXCOORD1 [[user(locn1)]];
    float2 in_var_TEXCOORD2 [[user(locn2)]];
    float2 in_var_TEXCOORD3 [[user(locn3)]];
    float2 in_var_TEXCOORD4 [[user(locn4)]];
    float2 in_var_TEXCOORD5 [[user(locn5)]];
};

// Implementation of the GLSL mod() function, which is slightly different than Metal fmod()
template<typename Tx, typename Ty>
inline Tx mod(Tx x, Ty y)
{
    return x - y * floor(x / y);
}

fragment main0_out main0(main0_in in [[stage_in]], constant type_u_cameraPlaneParams& u_cameraPlaneParams [[buffer(0)]], constant type_u_fragParams& u_fragParams [[buffer(1)]], texture2d<float> sceneColourTexture [[texture(0)]], texture2d<float> sceneNormalTexture [[texture(1)]], texture2d<float> sceneDepthTexture [[texture(2)]], sampler sceneColourSampler [[sampler(0)]], sampler sceneNormalSampler [[sampler(1)]], sampler sceneDepthSampler [[sampler(2)]])
{
    main0_out out = {};
    float4 _81 = sceneColourTexture.sample(sceneColourSampler, in.in_var_TEXCOORD1);
    float4 _85 = sceneNormalTexture.sample(sceneNormalSampler, in.in_var_TEXCOORD1);
    float4 _89 = sceneDepthTexture.sample(sceneDepthSampler, in.in_var_TEXCOORD1);
    float _90 = _89.x;
    float _96 = u_cameraPlaneParams.s_CameraFarPlane / (u_cameraPlaneParams.s_CameraFarPlane - u_cameraPlaneParams.s_CameraNearPlane);
    float _99 = (u_cameraPlaneParams.s_CameraFarPlane * u_cameraPlaneParams.s_CameraNearPlane) / (u_cameraPlaneParams.s_CameraNearPlane - u_cameraPlaneParams.s_CameraFarPlane);
    float _101 = log2(u_cameraPlaneParams.s_CameraFarPlane + 1.0);
    float _111 = u_cameraPlaneParams.u_clipZFar - u_cameraPlaneParams.u_clipZNear;
    float _113 = ((_96 + (_99 / (pow(2.0, _90 * _101) - 1.0))) * _111) + u_cameraPlaneParams.u_clipZNear;
    float4 _119 = u_fragParams.u_inverseProjection * float4(in.in_var_TEXCOORD0.xy, _113, 1.0);
    float3 _123 = _81.xyz;
    float3 _124 = (_119 / float4(_119.w)).xyz;
    float _131 = dot(u_fragParams.u_eyeToEarthSurfaceEyeSpace.xyz, u_fragParams.u_eyeToEarthSurfaceEyeSpace.xyz);
    float3 _133 = u_fragParams.u_eyeToEarthSurfaceEyeSpace.xyz * (dot(_124, u_fragParams.u_eyeToEarthSurfaceEyeSpace.xyz) / _131);
    float _141 = length(u_fragParams.u_eyeToEarthSurfaceEyeSpace.xyz - _133) * ((float(dot(_133, _133) < _131) * 2.0) - 1.0);
    float _191 = abs(_141);
    float3 _217 = mix(mix(mix(mix(mix(_123, u_fragParams.u_colourizeHeightColourMin.xyz, float3(u_fragParams.u_colourizeHeightColourMin.w)), mix(_123, u_fragParams.u_colourizeHeightColourMax.xyz, float3(u_fragParams.u_colourizeHeightColourMax.w)), float3(fast::clamp((_141 - u_fragParams.u_colourizeHeightParams.x) / (u_fragParams.u_colourizeHeightParams.y - u_fragParams.u_colourizeHeightParams.x), 0.0, 1.0))).xyz, u_fragParams.u_colourizeDepthColour.xyz, float3(fast::clamp((length(_124) - u_fragParams.u_colourizeDepthParams.x) / (u_fragParams.u_colourizeDepthParams.y - u_fragParams.u_colourizeDepthParams.x), 0.0, 1.0) * u_fragParams.u_colourizeDepthColour.w)).xyz, fast::clamp(abs((fract(float3(_191 * (1.0 / u_fragParams.u_contourParams.z), 1.0, 1.0).xxx + float3(1.0, 0.666666686534881591796875, 0.3333333432674407958984375)) * 6.0) - float3(3.0)) - float3(1.0), float3(0.0), float3(1.0)) * 1.0, float3(u_fragParams.u_contourParams.w)), u_fragParams.u_contourColour.xyz, float3((1.0 - step(u_fragParams.u_contourParams.y, mod(abs(_191), u_fragParams.u_contourParams.x))) * u_fragParams.u_contourColour.w));
    float _367;
    float4 _368;
    if ((u_fragParams.u_outlineParams.x > 0.0) && (u_fragParams.u_outlineColour.w > 0.0))
    {
        float4 _239 = u_fragParams.u_inverseProjection * float4((in.in_var_TEXCOORD1.x * 2.0) - 1.0, (in.in_var_TEXCOORD1.y * 2.0) - 1.0, _113, 1.0);
        float4 _244 = sceneDepthTexture.sample(sceneDepthSampler, in.in_var_TEXCOORD2);
        float _245 = _244.x;
        float4 _247 = sceneDepthTexture.sample(sceneDepthSampler, in.in_var_TEXCOORD3);
        float _248 = _247.x;
        float4 _250 = sceneDepthTexture.sample(sceneDepthSampler, in.in_var_TEXCOORD4);
        float _251 = _250.x;
        float4 _253 = sceneDepthTexture.sample(sceneDepthSampler, in.in_var_TEXCOORD5);
        float _254 = _253.x;
        float4 _269 = u_fragParams.u_inverseProjection * float4((in.in_var_TEXCOORD2.x * 2.0) - 1.0, (in.in_var_TEXCOORD2.y * 2.0) - 1.0, ((_96 + (_99 / (pow(2.0, _245 * _101) - 1.0))) * _111) + u_cameraPlaneParams.u_clipZNear, 1.0);
        float4 _284 = u_fragParams.u_inverseProjection * float4((in.in_var_TEXCOORD3.x * 2.0) - 1.0, (in.in_var_TEXCOORD3.y * 2.0) - 1.0, ((_96 + (_99 / (pow(2.0, _248 * _101) - 1.0))) * _111) + u_cameraPlaneParams.u_clipZNear, 1.0);
        float4 _299 = u_fragParams.u_inverseProjection * float4((in.in_var_TEXCOORD4.x * 2.0) - 1.0, (in.in_var_TEXCOORD4.y * 2.0) - 1.0, ((_96 + (_99 / (pow(2.0, _251 * _101) - 1.0))) * _111) + u_cameraPlaneParams.u_clipZNear, 1.0);
        float4 _314 = u_fragParams.u_inverseProjection * float4((in.in_var_TEXCOORD5.x * 2.0) - 1.0, (in.in_var_TEXCOORD5.y * 2.0) - 1.0, ((_96 + (_99 / (pow(2.0, _254 * _101) - 1.0))) * _111) + u_cameraPlaneParams.u_clipZNear, 1.0);
        float3 _327 = (_239 / float4(_239.w)).xyz;
        float4 _364 = mix(float4(_217, _90), float4(mix(_217.xyz, u_fragParams.u_outlineColour.xyz, float3(u_fragParams.u_outlineColour.w)), fast::min(fast::min(fast::min(_245, _248), _251), _254)), float4(1.0 - (((step(length(_327 - (_269 / float4(_269.w)).xyz), u_fragParams.u_outlineParams.y) * step(length(_327 - (_284 / float4(_284.w)).xyz), u_fragParams.u_outlineParams.y)) * step(length(_327 - (_299 / float4(_299.w)).xyz), u_fragParams.u_outlineParams.y)) * step(length(_327 - (_314 / float4(_314.w)).xyz), u_fragParams.u_outlineParams.y))));
        _367 = _364.w;
        _368 = float4(_364.x, _364.y, _364.z, _81.w);
    }
    else
    {
        _367 = _90;
        _368 = float4(_217.x, _217.y, _217.z, _81.w);
    }
    out.out_var_SV_Target0 = float4(_368.xyz, 1.0);
    out.out_var_SV_Target1 = _85;
    out.gl_FragDepth = _367;
    return out;
}

