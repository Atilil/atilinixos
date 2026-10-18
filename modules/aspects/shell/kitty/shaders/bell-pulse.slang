#language slang 2026
// Visual bell: green glow on the belled window edges

import kitty_custom_shader_types;

static const float GLOW_PX = 6.0;
static const float STRENGTH = 0.6;

public float4
fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
    float4 g = d.bell_window_geometry;
    if (g.z <= 0.0 || g.w <= 0.0) return color;
    float2 vp = float2(d.viewport_size_pixels);
    float2 lo = g.xy * vp, hi = (g.xy + g.zw) * vp, px = t.pos * vp;
    if (any(px < lo) || any(px > hi)) return color;

    float2 e = min(px - lo, hi - px);
    float glow = smoothstep(GLOW_PX, 0.0, min(e.x, e.y)) * (1.0 - t.animation_progress);
    return float4(lerp(color.rgb, float3(0.05, 0.6, 0.13), glow * STRENGTH), color.a);
}
