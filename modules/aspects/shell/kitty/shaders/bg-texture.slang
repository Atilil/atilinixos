#language slang 2026
// Soft vignette + fixed grain, background pixels only

import kitty_custom_shader_types;

static const float VIGNETTE = 0.45;
static const float GRAIN = 0.16;
static const float GRAIN_PX = 1.6;
static const float GREEN_BIAS = 0.15;
// Linear RGB
static const float BG_TOLERANCE = 0.004;

float hash(float2 p) {
    return frac(sin(dot(p, float2(127.1, 311.7))) * 43758.5453);
}

float vnoise(float2 p) {
    float2 i = floor(p);
    float2 f = frac(p);
    float2 u = f * f * (3.0 - 2.0 * f);
    return lerp(lerp(hash(i), hash(i + float2(1.0, 0.0)), u.x),
                lerp(hash(i + float2(0.0, 1.0)), hash(i + float2(1.0, 1.0)), u.x), u.y);
}

public float4
fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
    float dist_bg = min(distance(color.rgb, d.background.rgb),
                        distance(color.rgb, d.active_window_background.rgb));
    if (dist_bg > BG_TOLERANCE) return color;

    float2 vp = float2(d.viewport_size_pixels);
    float2 c = (t.pos - 0.5) * 2.0;
    float v = 1.0 - saturate(dot(c, c) * 0.5);
    v = v * v;
    float grain = vnoise(t.pos * vp / GRAIN_PX) * 2.0 - 1.0;

    float3 rgb = color.rgb * (1.0 - VIGNETTE * 0.5 + VIGNETTE * v) * (1.0 + GRAIN * grain);
    rgb.g *= 1.0 + GREEN_BIAS * v;
    return float4(rgb, color.a);
}
