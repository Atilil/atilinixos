#language slang 2026
// Tab change: short slide-in + fade

import kitty_custom_shader_types;

static const float SLIDE_PX = 24.0;
static const float START_BRIGHTNESS = 0.6;

public float4
fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
    float4 ca = d.central_area;
    if (ca.z <= 0.0 || ca.w <= 0.0) return color;
    if (any(t.pos < ca.xy) || any(t.pos > ca.xy + ca.zw)) return color;

    float p = t.animation_progress;
    float shift = SLIDE_PX * (1.0 - p) / float(d.viewport_size_pixels.x);
    float2 src = float2(max(t.pos.x - shift, ca.x), t.pos.y);
    float3 rgb = t.backbuffer.Sample(src).rgb;
    return float4(rgb * lerp(START_BRIGHTNESS, 1.0, p), color.a);
}
