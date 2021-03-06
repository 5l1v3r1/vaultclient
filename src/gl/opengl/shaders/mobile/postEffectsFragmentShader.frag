#version 300 es
precision mediump float;
precision highp int;

uniform highp sampler2D SPIRV_Cross_CombinedsceneNormalTexturesceneNormalSampler;
uniform highp sampler2D SPIRV_Cross_CombinedsceneDepthTexturesceneDepthSampler;
uniform highp sampler2D SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler;

in highp vec2 varying_TEXCOORD0;
in highp vec2 varying_TEXCOORD1;
in highp vec2 varying_TEXCOORD2;
in highp vec2 varying_TEXCOORD3;
in highp vec2 varying_TEXCOORD4;
in highp vec2 varying_TEXCOORD5;
in highp float varying_TEXCOORD6;
layout(location = 0) out highp vec4 out_var_SV_Target0;
layout(location = 1) out highp vec4 out_var_SV_Target1;

float _69;
vec2 _70;
vec2 _71;

void main()
{
    highp vec4 _83 = texture(SPIRV_Cross_CombinedsceneNormalTexturesceneNormalSampler, varying_TEXCOORD0);
    highp vec4 _87 = texture(SPIRV_Cross_CombinedsceneDepthTexturesceneDepthSampler, varying_TEXCOORD0);
    highp float _88 = _87.x;
    highp vec4 _542;
    if ((1.0 - (((step(abs(texture(SPIRV_Cross_CombinedsceneDepthTexturesceneDepthSampler, varying_TEXCOORD1).x - _88), 0.0030000000260770320892333984375) * step(abs(texture(SPIRV_Cross_CombinedsceneDepthTexturesceneDepthSampler, varying_TEXCOORD2).x - _88), 0.0030000000260770320892333984375)) * step(abs(texture(SPIRV_Cross_CombinedsceneDepthTexturesceneDepthSampler, varying_TEXCOORD3).x - _88), 0.0030000000260770320892333984375)) * step(abs(texture(SPIRV_Cross_CombinedsceneDepthTexturesceneDepthSampler, varying_TEXCOORD4).x - _88), 0.0030000000260770320892333984375))) == 0.0)
    {
        _542 = texture(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, varying_TEXCOORD0);
    }
    else
    {
        highp vec4 _541;
        switch (0u)
        {
            case 0u:
            {
                highp vec2 _130 = _70;
                _130.x = varying_TEXCOORD0.x;
                highp vec2 _132 = _130;
                _132.y = varying_TEXCOORD0.y;
                highp vec4 _134 = textureLod(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _132, 0.0);
                highp vec4 _136 = textureLodOffset(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _132, 0.0, ivec2(0, 1));
                highp float _137 = _136.y;
                highp vec4 _139 = textureLodOffset(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _132, 0.0, ivec2(1, 0));
                highp float _140 = _139.y;
                highp vec4 _142 = textureLodOffset(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _132, 0.0, ivec2(0, -1));
                highp float _143 = _142.y;
                highp vec4 _145 = textureLodOffset(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _132, 0.0, ivec2(-1, 0));
                highp float _146 = _145.y;
                highp float _147 = _134.y;
                highp float _154 = max(max(_143, _146), max(_140, max(_137, _147)));
                highp float _157 = _154 - min(min(_143, _146), min(_140, min(_137, _147)));
                if (_157 < max(0.0, _154 * 0.125))
                {
                    _541 = _134;
                    break;
                }
                highp vec4 _163 = textureLodOffset(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _132, 0.0, ivec2(-1));
                highp float _164 = _163.y;
                highp vec4 _166 = textureLodOffset(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _132, 0.0, ivec2(1));
                highp float _167 = _166.y;
                highp vec4 _169 = textureLodOffset(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _132, 0.0, ivec2(1, -1));
                highp float _170 = _169.y;
                highp vec4 _172 = textureLodOffset(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _132, 0.0, ivec2(-1, 1));
                highp float _173 = _172.y;
                highp float _174 = _143 + _137;
                highp float _175 = _146 + _140;
                highp float _178 = (-2.0) * _147;
                highp float _181 = _170 + _167;
                highp float _187 = _164 + _173;
                bool _207 = (abs(((-2.0) * _146) + _187) + ((abs(_178 + _174) * 2.0) + abs(((-2.0) * _140) + _181))) >= (abs(((-2.0) * _137) + (_173 + _167)) + ((abs(_178 + _175) * 2.0) + abs(((-2.0) * _143) + (_164 + _170))));
                bool _210 = !_207;
                highp float _211 = _210 ? _146 : _143;
                highp float _212 = _210 ? _140 : _137;
                highp float _216;
                if (_207)
                {
                    _216 = varying_TEXCOORD5.y;
                }
                else
                {
                    _216 = varying_TEXCOORD5.x;
                }
                highp float _223 = abs(_211 - _147);
                highp float _224 = abs(_212 - _147);
                bool _225 = _223 >= _224;
                highp float _230;
                if (_225)
                {
                    _230 = -_216;
                }
                else
                {
                    _230 = _216;
                }
                highp float _233 = clamp(abs(((((_174 + _175) * 2.0) + (_187 + _181)) * 0.083333335816860198974609375) - _147) * (1.0 / _157), 0.0, 1.0);
                highp float _234 = _210 ? 0.0 : varying_TEXCOORD5.x;
                highp float _236 = _207 ? 0.0 : varying_TEXCOORD5.y;
                highp vec2 _242;
                if (_210)
                {
                    highp vec2 _241 = _132;
                    _241.x = varying_TEXCOORD0.x + (_230 * 0.5);
                    _242 = _241;
                }
                else
                {
                    _242 = _132;
                }
                highp vec2 _249;
                if (_207)
                {
                    highp vec2 _248 = _242;
                    _248.y = _242.y + (_230 * 0.5);
                    _249 = _248;
                }
                else
                {
                    _249 = _242;
                }
                highp float _251 = _249.x - _234;
                highp vec2 _252 = _70;
                _252.x = _251;
                highp vec2 _255 = _252;
                _255.y = _249.y - _236;
                highp float _256 = _249.x + _234;
                highp vec2 _257 = _70;
                _257.x = _256;
                highp vec2 _259 = _257;
                _259.y = _249.y + _236;
                highp float _271 = max(_223, _224) * 0.25;
                highp float _272 = ((!_225) ? (_212 + _147) : (_211 + _147)) * 0.5;
                highp float _274 = (((-2.0) * _233) + 3.0) * (_233 * _233);
                bool _275 = (_147 - _272) < 0.0;
                highp float _276 = textureLod(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _255, 0.0).y - _272;
                highp float _277 = textureLod(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _259, 0.0).y - _272;
                bool _282 = !(abs(_276) >= _271);
                highp vec2 _288;
                if (_282)
                {
                    highp vec2 _287 = _255;
                    _287.x = _251 - (_234 * 1.5);
                    _288 = _287;
                }
                else
                {
                    _288 = _255;
                }
                highp vec2 _295;
                if (_282)
                {
                    highp vec2 _294 = _288;
                    _294.y = _288.y - (_236 * 1.5);
                    _295 = _294;
                }
                else
                {
                    _295 = _288;
                }
                bool _296 = !(abs(_277) >= _271);
                highp vec2 _303;
                if (_296)
                {
                    highp vec2 _302 = _259;
                    _302.x = _256 + (_234 * 1.5);
                    _303 = _302;
                }
                else
                {
                    _303 = _259;
                }
                highp vec2 _310;
                if (_296)
                {
                    highp vec2 _309 = _303;
                    _309.y = _303.y + (_236 * 1.5);
                    _310 = _309;
                }
                else
                {
                    _310 = _303;
                }
                highp vec2 _489;
                highp vec2 _490;
                highp float _491;
                highp float _492;
                if (_282 || _296)
                {
                    highp float _318;
                    if (_282)
                    {
                        _318 = textureLod(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _295, 0.0).y;
                    }
                    else
                    {
                        _318 = _276;
                    }
                    highp float _324;
                    if (_296)
                    {
                        _324 = textureLod(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _310, 0.0).y;
                    }
                    else
                    {
                        _324 = _277;
                    }
                    highp float _328;
                    if (_282)
                    {
                        _328 = _318 - _272;
                    }
                    else
                    {
                        _328 = _318;
                    }
                    highp float _332;
                    if (_296)
                    {
                        _332 = _324 - _272;
                    }
                    else
                    {
                        _332 = _324;
                    }
                    bool _337 = !(abs(_328) >= _271);
                    highp vec2 _344;
                    if (_337)
                    {
                        highp vec2 _343 = _295;
                        _343.x = _295.x - (_234 * 2.0);
                        _344 = _343;
                    }
                    else
                    {
                        _344 = _295;
                    }
                    highp vec2 _351;
                    if (_337)
                    {
                        highp vec2 _350 = _344;
                        _350.y = _344.y - (_236 * 2.0);
                        _351 = _350;
                    }
                    else
                    {
                        _351 = _344;
                    }
                    bool _352 = !(abs(_332) >= _271);
                    highp vec2 _360;
                    if (_352)
                    {
                        highp vec2 _359 = _310;
                        _359.x = _310.x + (_234 * 2.0);
                        _360 = _359;
                    }
                    else
                    {
                        _360 = _310;
                    }
                    highp vec2 _367;
                    if (_352)
                    {
                        highp vec2 _366 = _360;
                        _366.y = _360.y + (_236 * 2.0);
                        _367 = _366;
                    }
                    else
                    {
                        _367 = _360;
                    }
                    highp vec2 _485;
                    highp vec2 _486;
                    highp float _487;
                    highp float _488;
                    if (_337 || _352)
                    {
                        highp float _375;
                        if (_337)
                        {
                            _375 = textureLod(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _351, 0.0).y;
                        }
                        else
                        {
                            _375 = _328;
                        }
                        highp float _381;
                        if (_352)
                        {
                            _381 = textureLod(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _367, 0.0).y;
                        }
                        else
                        {
                            _381 = _332;
                        }
                        highp float _385;
                        if (_337)
                        {
                            _385 = _375 - _272;
                        }
                        else
                        {
                            _385 = _375;
                        }
                        highp float _389;
                        if (_352)
                        {
                            _389 = _381 - _272;
                        }
                        else
                        {
                            _389 = _381;
                        }
                        bool _394 = !(abs(_385) >= _271);
                        highp vec2 _401;
                        if (_394)
                        {
                            highp vec2 _400 = _351;
                            _400.x = _351.x - (_234 * 4.0);
                            _401 = _400;
                        }
                        else
                        {
                            _401 = _351;
                        }
                        highp vec2 _408;
                        if (_394)
                        {
                            highp vec2 _407 = _401;
                            _407.y = _401.y - (_236 * 4.0);
                            _408 = _407;
                        }
                        else
                        {
                            _408 = _401;
                        }
                        bool _409 = !(abs(_389) >= _271);
                        highp vec2 _417;
                        if (_409)
                        {
                            highp vec2 _416 = _367;
                            _416.x = _367.x + (_234 * 4.0);
                            _417 = _416;
                        }
                        else
                        {
                            _417 = _367;
                        }
                        highp vec2 _424;
                        if (_409)
                        {
                            highp vec2 _423 = _417;
                            _423.y = _417.y + (_236 * 4.0);
                            _424 = _423;
                        }
                        else
                        {
                            _424 = _417;
                        }
                        highp vec2 _481;
                        highp vec2 _482;
                        highp float _483;
                        highp float _484;
                        if (_394 || _409)
                        {
                            highp float _432;
                            if (_394)
                            {
                                _432 = textureLod(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _408, 0.0).y;
                            }
                            else
                            {
                                _432 = _385;
                            }
                            highp float _438;
                            if (_409)
                            {
                                _438 = textureLod(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _424, 0.0).y;
                            }
                            else
                            {
                                _438 = _389;
                            }
                            highp float _442;
                            if (_394)
                            {
                                _442 = _432 - _272;
                            }
                            else
                            {
                                _442 = _432;
                            }
                            highp float _446;
                            if (_409)
                            {
                                _446 = _438 - _272;
                            }
                            else
                            {
                                _446 = _438;
                            }
                            bool _451 = !(abs(_442) >= _271);
                            highp vec2 _458;
                            if (_451)
                            {
                                highp vec2 _457 = _408;
                                _457.x = _408.x - (_234 * 12.0);
                                _458 = _457;
                            }
                            else
                            {
                                _458 = _408;
                            }
                            highp vec2 _465;
                            if (_451)
                            {
                                highp vec2 _464 = _458;
                                _464.y = _458.y - (_236 * 12.0);
                                _465 = _464;
                            }
                            else
                            {
                                _465 = _458;
                            }
                            bool _466 = !(abs(_446) >= _271);
                            highp vec2 _473;
                            if (_466)
                            {
                                highp vec2 _472 = _424;
                                _472.x = _424.x + (_234 * 12.0);
                                _473 = _472;
                            }
                            else
                            {
                                _473 = _424;
                            }
                            highp vec2 _480;
                            if (_466)
                            {
                                highp vec2 _479 = _473;
                                _479.y = _473.y + (_236 * 12.0);
                                _480 = _479;
                            }
                            else
                            {
                                _480 = _473;
                            }
                            _481 = _480;
                            _482 = _465;
                            _483 = _446;
                            _484 = _442;
                        }
                        else
                        {
                            _481 = _424;
                            _482 = _408;
                            _483 = _389;
                            _484 = _385;
                        }
                        _485 = _481;
                        _486 = _482;
                        _487 = _483;
                        _488 = _484;
                    }
                    else
                    {
                        _485 = _367;
                        _486 = _351;
                        _487 = _332;
                        _488 = _328;
                    }
                    _489 = _485;
                    _490 = _486;
                    _491 = _487;
                    _492 = _488;
                }
                else
                {
                    _489 = _310;
                    _490 = _295;
                    _491 = _277;
                    _492 = _276;
                }
                highp float _501;
                if (_210)
                {
                    _501 = varying_TEXCOORD0.y - _490.y;
                }
                else
                {
                    _501 = varying_TEXCOORD0.x - _490.x;
                }
                highp float _506;
                if (_210)
                {
                    _506 = _489.y - varying_TEXCOORD0.y;
                }
                else
                {
                    _506 = _489.x - varying_TEXCOORD0.x;
                }
                highp float _521 = max(((_501 < _506) ? ((_492 < 0.0) != _275) : ((_491 < 0.0) != _275)) ? ((min(_501, _506) * ((-1.0) / (_506 + _501))) + 0.5) : 0.0, (_274 * _274) * 0.75);
                highp vec2 _527;
                if (_210)
                {
                    highp vec2 _526 = _132;
                    _526.x = varying_TEXCOORD0.x + (_521 * _230);
                    _527 = _526;
                }
                else
                {
                    _527 = _132;
                }
                highp vec2 _534;
                if (_207)
                {
                    highp vec2 _533 = _527;
                    _533.y = _527.y + (_521 * _230);
                    _534 = _533;
                }
                else
                {
                    _534 = _527;
                }
                _541 = vec4(textureLod(SPIRV_Cross_CombinedsceneColourTexturesceneColourSampler, _534, 0.0).xyz, _69);
                break;
            }
        }
        _542 = _541;
    }
    out_var_SV_Target0 = vec4(mix(vec3(dot(_542.xyz, vec3(0.2125000059604644775390625, 0.7153999805450439453125, 0.07209999859333038330078125))), _542.xyz, vec3(varying_TEXCOORD6)), 1.0);
    out_var_SV_Target1 = _83;
}

