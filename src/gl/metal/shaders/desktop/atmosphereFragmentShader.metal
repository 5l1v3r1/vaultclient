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
    float4 u_camera;
    float4 u_whitePoint;
    float4 u_earthCenter;
    float4 u_sunDirection;
    float4 u_sunSize;
};

constant float4 _107 = {};

struct main0_out
{
    float4 out_var_SV_Target0 [[color(0)]];
    float4 out_var_SV_Target1 [[color(1)]];
    float gl_FragDepth [[depth(any)]];
};

struct main0_in
{
    float2 in_var_TEXCOORD0 [[user(locn0)]];
    float3 in_var_TEXCOORD1 [[user(locn1)]];
};

fragment main0_out main0(main0_in in [[stage_in]], constant type_u_cameraPlaneParams& u_cameraPlaneParams [[buffer(0)]], constant type_u_fragParams& u_fragParams [[buffer(1)]], texture2d<float> transmittanceTexture [[texture(0)]], texture3d<float> scatteringTexture [[texture(1)]], texture2d<float> irradianceTexture [[texture(2)]], texture2d<float> sceneColourTexture [[texture(3)]], texture2d<float> sceneNormalTexture [[texture(4)]], texture2d<float> sceneDepthTexture [[texture(5)]], sampler transmittanceSampler [[sampler(0)]], sampler scatteringSampler [[sampler(1)]], sampler irradianceSampler [[sampler(2)]], sampler sceneColourSampler [[sampler(3)]], sampler sceneNormalSampler [[sampler(4)]], sampler sceneDepthSampler [[sampler(5)]])
{
    main0_out out = {};
    float _115 = u_fragParams.u_earthCenter.w + 60000.0;
    float3 _128 = normalize(in.in_var_TEXCOORD1);
    float4 _132 = sceneColourTexture.sample(sceneColourSampler, in.in_var_TEXCOORD0);
    float4 _136 = sceneNormalTexture.sample(sceneNormalSampler, in.in_var_TEXCOORD0);
    float4 _140 = sceneDepthTexture.sample(sceneDepthSampler, in.in_var_TEXCOORD0);
    float _141 = _140.x;
    float _146 = u_cameraPlaneParams.s_CameraFarPlane - u_cameraPlaneParams.s_CameraNearPlane;
    float2 _164 = _136.zw;
    float3 _169 = float3(_136.zw, float(int(sign(_136.y))) * sqrt(1.0 - dot(_164, _164)));
    float3 _172 = pow(abs(_132.xyz), float3(2.2000000476837158203125));
    float _178 = ((2.0 * u_cameraPlaneParams.s_CameraNearPlane) / ((u_cameraPlaneParams.s_CameraFarPlane + u_cameraPlaneParams.s_CameraNearPlane) - (((u_cameraPlaneParams.s_CameraFarPlane / _146) + (((u_cameraPlaneParams.s_CameraFarPlane * u_cameraPlaneParams.s_CameraNearPlane) / (u_cameraPlaneParams.s_CameraNearPlane - u_cameraPlaneParams.s_CameraFarPlane)) / (pow(2.0, _141 * log2(u_cameraPlaneParams.s_CameraFarPlane + 1.0)) - 1.0))) * _146))) * u_cameraPlaneParams.s_CameraFarPlane;
    float3 _180 = u_fragParams.u_camera.xyz + (_128 * _178);
    float3 _181 = u_fragParams.u_camera.xyz - u_fragParams.u_earthCenter.xyz;
    float _182 = dot(_181, _128);
    float _184 = _182 * _182;
    float _186 = -_182;
    float _187 = u_fragParams.u_earthCenter.w * u_fragParams.u_earthCenter.w;
    float _190 = _186 - sqrt(_187 - (dot(_181, _181) - _184));
    bool _191 = _190 > 0.0;
    float3 _196;
    if (_191)
    {
        _196 = u_fragParams.u_camera.xyz + (_128 * _190);
    }
    else
    {
        _196 = _180;
    }
    float3 _206;
    if (length(_169) == 0.0)
    {
        _206 = normalize(_180 - u_fragParams.u_earthCenter.xyz);
    }
    else
    {
        _206 = _169;
    }
    bool _207 = _141 < 0.75;
    float3 _795;
    if (_207)
    {
        float3 _210 = _180 - u_fragParams.u_earthCenter.xyz;
        float _213 = length(_210);
        float _215 = dot(_210, u_fragParams.u_sunDirection.xyz) / _213;
        float _217 = _115 - u_fragParams.u_earthCenter.w;
        float4 _228 = irradianceTexture.sample(irradianceSampler, float2(0.0078125 + (((_215 * 0.5) + 0.5) * 0.984375), 0.03125 + (((_213 - u_fragParams.u_earthCenter.w) / _217) * 0.9375)));
        float _235 = u_fragParams.u_earthCenter.w / _213;
        float _241 = _115 * _115;
        float _243 = sqrt(_241 - _187);
        float _244 = _213 * _213;
        float _247 = sqrt(fast::max(_244 - _187, 0.0));
        float _258 = _115 - _213;
        float4 _271 = transmittanceTexture.sample(transmittanceSampler, float2(0.001953125 + (((fast::max(((-_213) * _215) + sqrt(fast::max((_244 * ((_215 * _215) - 1.0)) + _241, 0.0)), 0.0) - _258) / ((_247 + _243) - _258)) * 0.99609375), 0.0078125 + ((_247 / _243) * 0.984375)));
        float _288 = fast::max(0.0, fast::min(0.0, _178));
        float3 _291 = normalize(_210 - _181);
        float _292 = length(_181);
        float _293 = dot(_181, _291);
        float _300 = (-_293) - sqrt(((_293 * _293) - (_292 * _292)) + _241);
        bool _301 = _300 > 0.0;
        float3 _307;
        float _308;
        if (_301)
        {
            _307 = _181 + (_291 * _300);
            _308 = _293 + _300;
        }
        else
        {
            _307 = _181;
            _308 = _293;
        }
        float _327;
        float _309 = _301 ? _115 : _292;
        float _310 = _308 / _309;
        float _311 = dot(_307, u_fragParams.u_sunDirection.xyz);
        float _312 = _311 / _309;
        float _313 = dot(_291, u_fragParams.u_sunDirection.xyz);
        float _315 = length(_210 - _307);
        float _317 = _309 * _309;
        float _320 = _317 * ((_310 * _310) - 1.0);
        bool _323 = (_310 < 0.0) && ((_320 + _187) >= 0.0);
        float3 _452;
        switch (0u)
        {
            default:
            {
                _327 = (2.0 * _309) * _310;
                float _332 = fast::clamp(sqrt((_315 * (_315 + _327)) + _317), u_fragParams.u_earthCenter.w, _115);
                float _335 = fast::clamp((_308 + _315) / _332, -1.0, 1.0);
                if (_323)
                {
                    float _393 = -_335;
                    float _394 = _332 * _332;
                    float _397 = sqrt(fast::max(_394 - _187, 0.0));
                    float _408 = _115 - _332;
                    float _422 = -_310;
                    float _425 = sqrt(fast::max(_317 - _187, 0.0));
                    float _436 = _115 - _309;
                    _452 = fast::min(transmittanceTexture.sample(transmittanceSampler, float2(0.001953125 + (((fast::max(((-_332) * _393) + sqrt(fast::max((_394 * ((_393 * _393) - 1.0)) + _241, 0.0)), 0.0) - _408) / ((_397 + _243) - _408)) * 0.99609375), 0.0078125 + ((_397 / _243) * 0.984375))).xyz / transmittanceTexture.sample(transmittanceSampler, float2(0.001953125 + (((fast::max(((-_309) * _422) + sqrt(fast::max((_317 * ((_422 * _422) - 1.0)) + _241, 0.0)), 0.0) - _436) / ((_425 + _243) - _436)) * 0.99609375), 0.0078125 + ((_425 / _243) * 0.984375))).xyz, float3(1.0));
                    break;
                }
                else
                {
                    float _341 = sqrt(fast::max(_317 - _187, 0.0));
                    float _349 = _115 - _309;
                    float _363 = _332 * _332;
                    float _366 = sqrt(fast::max(_363 - _187, 0.0));
                    float _377 = _115 - _332;
                    _452 = fast::min(transmittanceTexture.sample(transmittanceSampler, float2(0.001953125 + (((fast::max(((-_309) * _310) + sqrt(fast::max(_320 + _241, 0.0)), 0.0) - _349) / ((_341 + _243) - _349)) * 0.99609375), 0.0078125 + ((_341 / _243) * 0.984375))).xyz / transmittanceTexture.sample(transmittanceSampler, float2(0.001953125 + (((fast::max(((-_332) * _335) + sqrt(fast::max((_363 * ((_335 * _335) - 1.0)) + _241, 0.0)), 0.0) - _377) / ((_366 + _243) - _377)) * 0.99609375), 0.0078125 + ((_366 / _243) * 0.984375))).xyz, float3(1.0));
                    break;
                }
            }
        }
        float _455 = sqrt(fast::max(_317 - _187, 0.0));
        float _456 = _455 / _243;
        float _458 = 0.015625 + (_456 * 0.96875);
        float _461 = ((_308 * _308) - _317) + _187;
        float _494;
        if (_323)
        {
            float _484 = _309 - u_fragParams.u_earthCenter.w;
            _494 = 0.5 - (0.5 * (0.0078125 + (((_455 == _484) ? 0.0 : ((((-_308) - sqrt(fast::max(_461, 0.0))) - _484) / (_455 - _484))) * 0.984375)));
        }
        else
        {
            float _471 = _115 - _309;
            _494 = 0.5 + (0.5 * (0.0078125 + (((((-_308) + sqrt(fast::max(_461 + (_243 * _243), 0.0))) - _471) / ((_455 + _243) - _471)) * 0.984375)));
        }
        float _499 = -u_fragParams.u_earthCenter.w;
        float _506 = _243 - _217;
        float _507 = (fast::max((_499 * _312) + sqrt(fast::max((_187 * ((_312 * _312) - 1.0)) + _241, 0.0)), 0.0) - _217) / _506;
        float _509 = (0.415823996067047119140625 * u_fragParams.u_earthCenter.w) / _506;
        float _516 = 0.015625 + ((fast::max(1.0 - (_507 / _509), 0.0) / (1.0 + _507)) * 0.96875);
        float _518 = (_313 + 1.0) * 3.5;
        float _519 = floor(_518);
        float _520 = _518 - _519;
        float _524 = _519 + 1.0;
        float4 _530 = scatteringTexture.sample(scatteringSampler, float3((_519 + _516) * 0.125, _494, _458));
        float _531 = 1.0 - _520;
        float4 _534 = scatteringTexture.sample(scatteringSampler, float3((_524 + _516) * 0.125, _494, _458));
        float4 _536 = (_530 * _531) + (_534 * _520);
        float3 _537 = _536.xyz;
        float3 _550;
        switch (0u)
        {
            default:
            {
                float _540 = _536.x;
                if (_540 == 0.0)
                {
                    _550 = float3(0.0);
                    break;
                }
                _550 = (((_537 * _536.w) / float3(_540)) * 1.5) * float3(0.66666662693023681640625, 0.28571426868438720703125, 0.121212117373943328857421875);
                break;
            }
        }
        float _552 = fast::max(_315 - _288, 0.0);
        float _557 = fast::clamp(sqrt((_552 * (_552 + _327)) + _317), u_fragParams.u_earthCenter.w, _115);
        float _558 = _308 + _552;
        float _561 = (_311 + (_552 * _313)) / _557;
        float _562 = _557 * _557;
        float _565 = sqrt(fast::max(_562 - _187, 0.0));
        float _566 = _565 / _243;
        float _568 = 0.015625 + (_566 * 0.96875);
        float _571 = ((_558 * _558) - _562) + _187;
        float _604;
        if (_323)
        {
            float _594 = _557 - u_fragParams.u_earthCenter.w;
            _604 = 0.5 - (0.5 * (0.0078125 + (((_565 == _594) ? 0.0 : ((((-_558) - sqrt(fast::max(_571, 0.0))) - _594) / (_565 - _594))) * 0.984375)));
        }
        else
        {
            float _581 = _115 - _557;
            _604 = 0.5 + (0.5 * (0.0078125 + (((((-_558) + sqrt(fast::max(_571 + (_243 * _243), 0.0))) - _581) / ((_565 + _243) - _581)) * 0.984375)));
        }
        float _615 = (fast::max((_499 * _561) + sqrt(fast::max((_187 * ((_561 * _561) - 1.0)) + _241, 0.0)), 0.0) - _217) / _506;
        float _622 = 0.015625 + ((fast::max(1.0 - (_615 / _509), 0.0) / (1.0 + _615)) * 0.96875);
        float4 _630 = scatteringTexture.sample(scatteringSampler, float3((_519 + _622) * 0.125, _604, _568));
        float4 _633 = scatteringTexture.sample(scatteringSampler, float3((_524 + _622) * 0.125, _604, _568));
        float4 _635 = (_630 * _531) + (_633 * _520);
        float3 _636 = _635.xyz;
        float3 _649;
        switch (0u)
        {
            default:
            {
                float _639 = _635.x;
                if (_639 == 0.0)
                {
                    _649 = float3(0.0);
                    break;
                }
                _649 = (((_636 * _635.w) / float3(_639)) * 1.5) * float3(0.66666662693023681640625, 0.28571426868438720703125, 0.121212117373943328857421875);
                break;
            }
        }
        float3 _756;
        if (_288 > 0.0)
        {
            float3 _755;
            switch (0u)
            {
                default:
                {
                    float _656 = fast::clamp(_558 / _557, -1.0, 1.0);
                    if (_323)
                    {
                        float _705 = -_656;
                        float _716 = _115 - _557;
                        float _729 = -_310;
                        float _740 = _115 - _309;
                        _755 = fast::min(transmittanceTexture.sample(transmittanceSampler, float2(0.001953125 + (((fast::max(((-_557) * _705) + sqrt(fast::max((_562 * ((_705 * _705) - 1.0)) + _241, 0.0)), 0.0) - _716) / ((_565 + _243) - _716)) * 0.99609375), 0.0078125 + (_566 * 0.984375))).xyz / transmittanceTexture.sample(transmittanceSampler, float2(0.001953125 + (((fast::max(((-_309) * _729) + sqrt(fast::max((_317 * ((_729 * _729) - 1.0)) + _241, 0.0)), 0.0) - _740) / ((_455 + _243) - _740)) * 0.99609375), 0.0078125 + (_456 * 0.984375))).xyz, float3(1.0));
                        break;
                    }
                    else
                    {
                        float _667 = _115 - _309;
                        float _690 = _115 - _557;
                        _755 = fast::min(transmittanceTexture.sample(transmittanceSampler, float2(0.001953125 + (((fast::max(((-_309) * _310) + sqrt(fast::max(_320 + _241, 0.0)), 0.0) - _667) / ((_455 + _243) - _667)) * 0.99609375), 0.0078125 + (_456 * 0.984375))).xyz / transmittanceTexture.sample(transmittanceSampler, float2(0.001953125 + (((fast::max(((-_557) * _656) + sqrt(fast::max((_562 * ((_656 * _656) - 1.0)) + _241, 0.0)), 0.0) - _690) / ((_565 + _243) - _690)) * 0.99609375), 0.0078125 + (_566 * 0.984375))).xyz, float3(1.0));
                        break;
                    }
                }
            }
            _756 = _755;
        }
        else
        {
            _756 = _452;
        }
        float3 _758 = _537 - (_756 * _636);
        float3 _760 = _550 - (_756 * _649);
        float _761 = _760.x;
        float _762 = _758.x;
        float3 _777;
        switch (0u)
        {
            default:
            {
                if (_762 == 0.0)
                {
                    _777 = float3(0.0);
                    break;
                }
                _777 = (((float4(_762, _758.yz, _761).xyz * _761) / float3(_762)) * 1.5) * float3(0.66666662693023681640625, 0.28571426868438720703125, 0.121212117373943328857421875);
                break;
            }
        }
        float _781 = 1.0 + (_313 * _313);
        _795 = (((_172.xyz * 0.3183098733425140380859375) * ((float3(1.47399997711181640625, 1.85039997100830078125, 1.91198003292083740234375) * fast::max((_271.xyz * smoothstep(_235 * (-0.004674999974668025970458984375), _235 * 0.004674999974668025970458984375, _215 - (-sqrt(fast::max(1.0 - (_235 * _235), 0.0))))) * fast::max(dot(_206, u_fragParams.u_sunDirection.xyz), 0.0), float3(0.001000000047497451305389404296875))) + ((_228.xyz * (1.0 + (dot(_206, _210) / _213))) * 0.5))) * _452) + (((_758 * (0.0596831031143665313720703125 * _781)) + ((_777 * smoothstep(0.0, 0.00999999977648258209228515625, _312)) * ((0.01627720706164836883544921875 * _781) / pow(1.6400001049041748046875 - (1.60000002384185791015625 * _313), 1.5)))) * mix(0.5, 1.0, fast::min(1.0, pow(_141, 6.0) * 6.0)));
    }
    else
    {
        _795 = float3(0.0);
    }
    float3 _1272;
    if (_191)
    {
        float3 _799 = _196 - u_fragParams.u_earthCenter.xyz;
        float _802 = length(_799);
        float _804 = dot(_799, u_fragParams.u_sunDirection.xyz) / _802;
        float _806 = _115 - u_fragParams.u_earthCenter.w;
        float4 _817 = irradianceTexture.sample(irradianceSampler, float2(0.0078125 + (((_804 * 0.5) + 0.5) * 0.984375), 0.03125 + (((_802 - u_fragParams.u_earthCenter.w) / _806) * 0.9375)));
        float _824 = u_fragParams.u_earthCenter.w / _802;
        float _830 = _115 * _115;
        float _832 = sqrt(_830 - _187);
        float _833 = _802 * _802;
        float _836 = sqrt(fast::max(_833 - _187, 0.0));
        float _847 = _115 - _802;
        float4 _860 = transmittanceTexture.sample(transmittanceSampler, float2(0.001953125 + (((fast::max(((-_802) * _804) + sqrt(fast::max((_833 * ((_804 * _804) - 1.0)) + _830, 0.0)), 0.0) - _847) / ((_836 + _832) - _847)) * 0.99609375), 0.0078125 + ((_836 / _832) * 0.984375)));
        float3 _878 = normalize(_799 - _181);
        float _879 = length(_181);
        float _880 = dot(_181, _878);
        float _887 = (-_880) - sqrt(((_880 * _880) - (_879 * _879)) + _830);
        bool _888 = _887 > 0.0;
        float3 _894;
        float _895;
        if (_888)
        {
            _894 = _181 + (_878 * _887);
            _895 = _880 + _887;
        }
        else
        {
            _894 = _181;
            _895 = _880;
        }
        float _914;
        float _896 = _888 ? _115 : _879;
        float _897 = _895 / _896;
        float _898 = dot(_894, u_fragParams.u_sunDirection.xyz);
        float _899 = _898 / _896;
        float _900 = dot(_878, u_fragParams.u_sunDirection.xyz);
        float _902 = length(_799 - _894);
        float _904 = _896 * _896;
        float _907 = _904 * ((_897 * _897) - 1.0);
        bool _910 = (_897 < 0.0) && ((_907 + _187) >= 0.0);
        float3 _1039;
        switch (0u)
        {
            default:
            {
                _914 = (2.0 * _896) * _897;
                float _919 = fast::clamp(sqrt((_902 * (_902 + _914)) + _904), u_fragParams.u_earthCenter.w, _115);
                float _922 = fast::clamp((_895 + _902) / _919, -1.0, 1.0);
                if (_910)
                {
                    float _980 = -_922;
                    float _981 = _919 * _919;
                    float _984 = sqrt(fast::max(_981 - _187, 0.0));
                    float _995 = _115 - _919;
                    float _1009 = -_897;
                    float _1012 = sqrt(fast::max(_904 - _187, 0.0));
                    float _1023 = _115 - _896;
                    _1039 = fast::min(transmittanceTexture.sample(transmittanceSampler, float2(0.001953125 + (((fast::max(((-_919) * _980) + sqrt(fast::max((_981 * ((_980 * _980) - 1.0)) + _830, 0.0)), 0.0) - _995) / ((_984 + _832) - _995)) * 0.99609375), 0.0078125 + ((_984 / _832) * 0.984375))).xyz / transmittanceTexture.sample(transmittanceSampler, float2(0.001953125 + (((fast::max(((-_896) * _1009) + sqrt(fast::max((_904 * ((_1009 * _1009) - 1.0)) + _830, 0.0)), 0.0) - _1023) / ((_1012 + _832) - _1023)) * 0.99609375), 0.0078125 + ((_1012 / _832) * 0.984375))).xyz, float3(1.0));
                    break;
                }
                else
                {
                    float _928 = sqrt(fast::max(_904 - _187, 0.0));
                    float _936 = _115 - _896;
                    float _950 = _919 * _919;
                    float _953 = sqrt(fast::max(_950 - _187, 0.0));
                    float _964 = _115 - _919;
                    _1039 = fast::min(transmittanceTexture.sample(transmittanceSampler, float2(0.001953125 + (((fast::max(((-_896) * _897) + sqrt(fast::max(_907 + _830, 0.0)), 0.0) - _936) / ((_928 + _832) - _936)) * 0.99609375), 0.0078125 + ((_928 / _832) * 0.984375))).xyz / transmittanceTexture.sample(transmittanceSampler, float2(0.001953125 + (((fast::max(((-_919) * _922) + sqrt(fast::max((_950 * ((_922 * _922) - 1.0)) + _830, 0.0)), 0.0) - _964) / ((_953 + _832) - _964)) * 0.99609375), 0.0078125 + ((_953 / _832) * 0.984375))).xyz, float3(1.0));
                    break;
                }
            }
        }
        float _1042 = sqrt(fast::max(_904 - _187, 0.0));
        float _1045 = 0.015625 + ((_1042 / _832) * 0.96875);
        float _1048 = ((_895 * _895) - _904) + _187;
        float _1081;
        if (_910)
        {
            float _1071 = _896 - u_fragParams.u_earthCenter.w;
            _1081 = 0.5 - (0.5 * (0.0078125 + (((_1042 == _1071) ? 0.0 : ((((-_895) - sqrt(fast::max(_1048, 0.0))) - _1071) / (_1042 - _1071))) * 0.984375)));
        }
        else
        {
            float _1058 = _115 - _896;
            _1081 = 0.5 + (0.5 * (0.0078125 + (((((-_895) + sqrt(fast::max(_1048 + (_832 * _832), 0.0))) - _1058) / ((_1042 + _832) - _1058)) * 0.984375)));
        }
        float _1086 = -u_fragParams.u_earthCenter.w;
        float _1093 = _832 - _806;
        float _1094 = (fast::max((_1086 * _899) + sqrt(fast::max((_187 * ((_899 * _899) - 1.0)) + _830, 0.0)), 0.0) - _806) / _1093;
        float _1096 = (0.415823996067047119140625 * u_fragParams.u_earthCenter.w) / _1093;
        float _1103 = 0.015625 + ((fast::max(1.0 - (_1094 / _1096), 0.0) / (1.0 + _1094)) * 0.96875);
        float _1105 = (_900 + 1.0) * 3.5;
        float _1106 = floor(_1105);
        float _1107 = _1105 - _1106;
        float _1111 = _1106 + 1.0;
        float4 _1117 = scatteringTexture.sample(scatteringSampler, float3((_1106 + _1103) * 0.125, _1081, _1045));
        float _1118 = 1.0 - _1107;
        float4 _1121 = scatteringTexture.sample(scatteringSampler, float3((_1111 + _1103) * 0.125, _1081, _1045));
        float4 _1123 = (_1117 * _1118) + (_1121 * _1107);
        float3 _1124 = _1123.xyz;
        float3 _1137;
        switch (0u)
        {
            default:
            {
                float _1127 = _1123.x;
                if (_1127 == 0.0)
                {
                    _1137 = float3(0.0);
                    break;
                }
                _1137 = (((_1124 * _1123.w) / float3(_1127)) * 1.5) * float3(0.66666662693023681640625, 0.28571426868438720703125, 0.121212117373943328857421875);
                break;
            }
        }
        float _1138 = fast::max(_902, 0.0);
        float _1143 = fast::clamp(sqrt((_1138 * (_1138 + _914)) + _904), u_fragParams.u_earthCenter.w, _115);
        float _1144 = _895 + _1138;
        float _1147 = (_898 + (_1138 * _900)) / _1143;
        float _1148 = _1143 * _1143;
        float _1151 = sqrt(fast::max(_1148 - _187, 0.0));
        float _1154 = 0.015625 + ((_1151 / _832) * 0.96875);
        float _1157 = ((_1144 * _1144) - _1148) + _187;
        float _1190;
        if (_910)
        {
            float _1180 = _1143 - u_fragParams.u_earthCenter.w;
            _1190 = 0.5 - (0.5 * (0.0078125 + (((_1151 == _1180) ? 0.0 : ((((-_1144) - sqrt(fast::max(_1157, 0.0))) - _1180) / (_1151 - _1180))) * 0.984375)));
        }
        else
        {
            float _1167 = _115 - _1143;
            _1190 = 0.5 + (0.5 * (0.0078125 + (((((-_1144) + sqrt(fast::max(_1157 + (_832 * _832), 0.0))) - _1167) / ((_1151 + _832) - _1167)) * 0.984375)));
        }
        float _1201 = (fast::max((_1086 * _1147) + sqrt(fast::max((_187 * ((_1147 * _1147) - 1.0)) + _830, 0.0)), 0.0) - _806) / _1093;
        float _1208 = 0.015625 + ((fast::max(1.0 - (_1201 / _1096), 0.0) / (1.0 + _1201)) * 0.96875);
        float4 _1216 = scatteringTexture.sample(scatteringSampler, float3((_1106 + _1208) * 0.125, _1190, _1154));
        float4 _1219 = scatteringTexture.sample(scatteringSampler, float3((_1111 + _1208) * 0.125, _1190, _1154));
        float4 _1221 = (_1216 * _1118) + (_1219 * _1107);
        float3 _1222 = _1221.xyz;
        float3 _1235;
        switch (0u)
        {
            default:
            {
                float _1225 = _1221.x;
                if (_1225 == 0.0)
                {
                    _1235 = float3(0.0);
                    break;
                }
                _1235 = (((_1222 * _1221.w) / float3(_1225)) * 1.5) * float3(0.66666662693023681640625, 0.28571426868438720703125, 0.121212117373943328857421875);
                break;
            }
        }
        float3 _1237 = _1124 - (_1039 * _1222);
        float3 _1239 = _1137 - (_1039 * _1235);
        float _1240 = _1239.x;
        float _1241 = _1237.x;
        float3 _1256;
        switch (0u)
        {
            default:
            {
                if (_1241 == 0.0)
                {
                    _1256 = float3(0.0);
                    break;
                }
                _1256 = (((float4(_1241, _1237.yz, _1240).xyz * _1240) / float3(_1241)) * 1.5) * float3(0.66666662693023681640625, 0.28571426868438720703125, 0.121212117373943328857421875);
                break;
            }
        }
        float _1260 = 1.0 + (_900 * _900);
        _1272 = (((_172.xyz * 0.3183098733425140380859375) * ((float3(1.47399997711181640625, 1.85039997100830078125, 1.91198003292083740234375) * fast::max((_860.xyz * smoothstep(_824 * (-0.004674999974668025970458984375), _824 * 0.004674999974668025970458984375, _804 - (-sqrt(fast::max(1.0 - (_824 * _824), 0.0))))) * fast::max(dot(_206, u_fragParams.u_sunDirection.xyz), 0.0), float3(0.001000000047497451305389404296875))) + ((_817.xyz * (1.0 + (dot(_206, _799) / _802))) * 0.5))) * _1039) + ((_1237 * (0.0596831031143665313720703125 * _1260)) + ((_1256 * smoothstep(0.0, 0.00999999977648258209228515625, _899)) * ((0.01627720706164836883544921875 * _1260) / pow(1.6400001049041748046875 - (1.60000002384185791015625 * _900), 1.5))));
    }
    else
    {
        _1272 = float3(0.0);
    }
    float3 _1442;
    float3 _1443;
    switch (0u)
    {
        default:
        {
            float _1278 = length(_181);
            float _1281 = _115 * _115;
            float _1284 = _186 - sqrt((_184 - (_1278 * _1278)) + _1281);
            bool _1285 = _1284 > 0.0;
            float3 _1295;
            float _1296;
            if (_1285)
            {
                _1295 = _181 + (_128 * _1284);
                _1296 = _182 + _1284;
            }
            else
            {
                if (_1278 > _115)
                {
                    _1442 = float3(1.0);
                    _1443 = float3(0.0);
                    break;
                }
                _1295 = _181;
                _1296 = _182;
            }
            float _1297 = _1285 ? _115 : _1278;
            float _1298 = _1296 / _1297;
            float _1300 = dot(_1295, u_fragParams.u_sunDirection.xyz) / _1297;
            float _1301 = dot(_128, u_fragParams.u_sunDirection.xyz);
            float _1303 = _1297 * _1297;
            float _1306 = _1303 * ((_1298 * _1298) - 1.0);
            bool _1309 = (_1298 < 0.0) && ((_1306 + _187) >= 0.0);
            float _1311 = sqrt(_1281 - _187);
            float _1314 = sqrt(fast::max(_1303 - _187, 0.0));
            float _1322 = _115 - _1297;
            float _1325 = (_1314 + _1311) - _1322;
            float _1327 = _1314 / _1311;
            float4 _1335 = transmittanceTexture.sample(transmittanceSampler, float2(0.001953125 + (((fast::max(((-_1297) * _1298) + sqrt(fast::max(_1306 + _1281, 0.0)), 0.0) - _1322) / _1325) * 0.99609375), 0.0078125 + (_1327 * 0.984375)));
            float _1340 = 0.015625 + (_1327 * 0.96875);
            float _1343 = ((_1296 * _1296) - _1303) + _187;
            float _1373;
            if (_1309)
            {
                float _1363 = _1297 - u_fragParams.u_earthCenter.w;
                _1373 = 0.5 - (0.5 * (0.0078125 + (((_1314 == _1363) ? 0.0 : ((((-_1296) - sqrt(fast::max(_1343, 0.0))) - _1363) / (_1314 - _1363))) * 0.984375)));
            }
            else
            {
                _1373 = 0.5 + (0.5 * (0.0078125 + (((((-_1296) + sqrt(fast::max(_1343 + (_1311 * _1311), 0.0))) - _1322) / _1325) * 0.984375)));
            }
            float _1384 = _115 - u_fragParams.u_earthCenter.w;
            float _1386 = _1311 - _1384;
            float _1387 = (fast::max(((-u_fragParams.u_earthCenter.w) * _1300) + sqrt(fast::max((_187 * ((_1300 * _1300) - 1.0)) + _1281, 0.0)), 0.0) - _1384) / _1386;
            float _1396 = 0.015625 + ((fast::max(1.0 - (_1387 / ((0.415823996067047119140625 * u_fragParams.u_earthCenter.w) / _1386)), 0.0) / (1.0 + _1387)) * 0.96875);
            float _1398 = (_1301 + 1.0) * 3.5;
            float _1399 = floor(_1398);
            float _1400 = _1398 - _1399;
            float4 _1410 = scatteringTexture.sample(scatteringSampler, float3((_1399 + _1396) * 0.125, _1373, _1340));
            float4 _1414 = scatteringTexture.sample(scatteringSampler, float3(((_1399 + 1.0) + _1396) * 0.125, _1373, _1340));
            float4 _1416 = (_1410 * (1.0 - _1400)) + (_1414 * _1400);
            float3 _1417 = _1416.xyz;
            float3 _1430;
            switch (0u)
            {
                default:
                {
                    float _1420 = _1416.x;
                    if (_1420 == 0.0)
                    {
                        _1430 = float3(0.0);
                        break;
                    }
                    _1430 = (((_1417 * _1416.w) / float3(_1420)) * 1.5) * float3(0.66666662693023681640625, 0.28571426868438720703125, 0.121212117373943328857421875);
                    break;
                }
            }
            float _1432 = 1.0 + (_1301 * _1301);
            _1442 = select(_1335.xyz, float3(0.0), bool3(_1309));
            _1443 = (_1417 * (0.0596831031143665313720703125 * _1432)) + (_1430 * ((0.01627720706164836883544921875 * _1432) / pow(1.6400001049041748046875 - (1.60000002384185791015625 * _1301), 1.5)));
            break;
        }
    }
    float3 _1451;
    if (dot(_128, u_fragParams.u_sunDirection.xyz) > u_fragParams.u_sunSize.y)
    {
        _1451 = _1443 + (_1442 * float3(21467.642578125, 26949.611328125, 27846.474609375));
    }
    else
    {
        _1451 = _1443;
    }
    float3 _1469 = pow(abs(float3(1.0) - exp(((-mix(mix(_1451, _1272, float3(float(_191))), _795, float3(float(_207) * fast::min(1.0, 1.0 - smoothstep(0.64999997615814208984375, 0.75, _141))))) / u_fragParams.u_whitePoint.xyz) * u_fragParams.u_camera.w)), float3(0.4545454680919647216796875));
    float4 _1471 = float4(_1469.x, _1469.y, _1469.z, _107.w);
    _1471.w = 1.0;
    out.out_var_SV_Target0 = _1471;
    out.out_var_SV_Target1 = _136;
    out.gl_FragDepth = _141;
    return out;
}

