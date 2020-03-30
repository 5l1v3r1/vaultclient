#version 300 es
precision mediump float;
precision highp int;

layout(std140) uniform type_u_EveryFrameFrag
{
    highp vec4 u_specularDir;
    layout(row_major) highp mat4 u_eyeNormalMatrix;
    layout(row_major) highp mat4 u_inverseViewMatrix;
} u_EveryFrameFrag;

uniform highp sampler2D SPIRV_Cross_Combinedu_normalMapsampler0;
uniform highp sampler2D SPIRV_Cross_Combinedu_skyboxsampler1;

in highp vec2 varying_TEXCOORD0;
in highp vec2 varying_TEXCOORD1;
in highp vec4 varying_COLOR0;
in highp vec4 varying_COLOR1;
layout(location = 0) out highp vec4 out_var_SV_Target;

void main()
{
    highp vec3 _77 = normalize(((texture(SPIRV_Cross_Combinedu_normalMapsampler0, varying_TEXCOORD0).xyz * vec3(2.0)) - vec3(1.0)) + ((texture(SPIRV_Cross_Combinedu_normalMapsampler0, varying_TEXCOORD1).xyz * vec3(2.0)) - vec3(1.0)));
    highp vec3 _79 = normalize(varying_COLOR0.xyz);
    highp vec3 _95 = normalize((vec4(_77, 0.0) * u_EveryFrameFrag.u_eyeNormalMatrix).xyz);
    highp vec3 _97 = normalize(reflect(_79, _95));
    highp vec3 _121 = normalize((vec4(_97, 0.0) * u_EveryFrameFrag.u_inverseViewMatrix).xyz);
    out_var_SV_Target = vec4(mix(texture(SPIRV_Cross_Combinedu_skyboxsampler1, vec2(atan(_121.x, _121.y) + 3.1415927410125732421875, acos(_121.z)) * vec2(0.15915493667125701904296875, 0.3183098733425140380859375)).xyz, varying_COLOR1.xyz * mix(vec3(1.0, 1.0, 0.60000002384185791015625), vec3(0.3499999940395355224609375), vec3(pow(max(0.0, _77.z), 5.0))), vec3(((dot(_95, _79) * (-0.5)) + 0.5) * 0.75)) + vec3(pow(abs(dot(_97, normalize((vec4(normalize(u_EveryFrameFrag.u_specularDir.xyz), 0.0) * u_EveryFrameFrag.u_eyeNormalMatrix).xyz))), 50.0) * 0.5), 1.0);
}

