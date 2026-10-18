#language slang 2026
// Matrix cursor trail with afterglow.
// Based on kitty's cursor-trail-default and inside-the-matrix (GPLv3).

import kitty_custom_shader_types;

// Linear RGB
static const float3 HEAD_COLOR = float3(0.40, 1.00, 0.65);
static const float3 TAIL_COLOR = float3(0.05, 0.60, 0.13);
static const float WASH = 0.35;
static const float FLICKER_RATE = 18.0;
static const float FALL_SPEED = 14.0;
static const float GLYPH_PAD = 0.18;
// Seconds
static const float AFTERGLOW = 0.12;
// Set by the pipeline
static const int STAGE = 2;


bool
inside_trail_quad(float2 uv, float2 c0, float2 c1, float2 c2, float2 c3) {
    float2 e0 = c1 - c0;
    float2 e1 = c2 - c1;
    float2 e2 = c3 - c2;
    float2 e3 = c0 - c3;
    float s0 = e0.x * (uv.y - c0.y) - e0.y * (uv.x - c0.x);
    float s1 = e1.x * (uv.y - c1.y) - e1.y * (uv.x - c1.x);
    float s2 = e2.x * (uv.y - c2.y) - e2.y * (uv.x - c2.x);
    float s3 = e3.x * (uv.y - c3.y) - e3.y * (uv.x - c3.x);
    return s0 <= 0.0 && s1 <= 0.0 && s2 <= 0.0 && s3 <= 0.0;
}


float
hash(float2 v) {
    return frac(sin(dot(v, float2(5.3983f, 5.4427f))) * 43758.5453123f);
}

float4
hash4(float2 v) {
    float4 p = mul(v, float2x4(127.1f, 269.5f, 113.5f, 246.1f, 311.7f, 183.3f, 271.9f, 124.6f));
    return frac(sin(p) * 43758.5453123f);
}

float
rune_line(float2 p, float2 a, float2 b) {
    p -= a;
    b -= a;
    float h = clamp(dot(p, b) / dot(b, b), 0.0f, 1.0f);
    return length(p - b * h);
}

float
rune(float2 U, float2 seed) {
    float d = 1e5f;
    [ForceUnroll]
    for (int i = 0; i < 4; i++) {
        float4 pos = hash4(seed);
        seed += 1.0f;
        pos.y = (i == 0) ? 0.0f : pos.y;
        pos.x = (i == 1) ? 0.999f : pos.x;
        pos.x = (i == 2) ? 0.0f : pos.x;
        pos.y = (i == 3) ? 0.999f : pos.y;
        float4 snaps = float4(2.0f, 3.0f, 2.0f, 3.0f);
        pos = (floor(pos * snaps) + 0.5f) / snaps;
        if (any(pos.xy != pos.zw)) d = min(d, rune_line(U, pos.xy, pos.zw + 0.001f));
    }
    return smoothstep(0.17f, 0.03f, d);
}


float
trail_intensity(float2 uv, KittyCustomShaderData d) {
    float opacity = d.cursor_trail_color.a;
    if (opacity <= 0.0) return 0.0;
    float2 c0 = float2(d.cursor_trail_corners_x.x, d.cursor_trail_corners_y.x);
    float2 c1 = float2(d.cursor_trail_corners_x.y, d.cursor_trail_corners_y.y);
    float2 c2 = float2(d.cursor_trail_corners_x.z, d.cursor_trail_corners_y.z);
    float2 c3 = float2(d.cursor_trail_corners_x.w, d.cursor_trail_corners_y.w);
    if (!inside_trail_quad(uv, c0, c1, c2, c3)) return 0.0;

    float4 e = d.cursor_trail_edge;
    float2 head = float2(e.x + e.y, e.z + e.w) * 0.5;
    float2 far = c0;
    far = distance(c1, head) > distance(far, head) ? c1 : far;
    far = distance(c2, head) > distance(far, head) ? c2 : far;
    far = distance(c3, head) > distance(far, head) ? c3 : far;
    float along = saturate(distance(uv, head) / max(distance(far, head), 1e-4));
    return sqrt(opacity) * (1.0 - along * 0.5);
}

public float4
fragment_main(float4 color, KittyTextures t, KittyCustomShaderData d) {
    float2 uv = t.pos;

    if (STAGE == 0) {
        float dt = max(d.timestamp - d.last_rendered_at, 0.0);
        float prev = t.persist.Sample(uv).r * exp(-dt / AFTERGLOW);
        return float4(max(prev, trail_intensity(uv, d)), 0.0, 0.0, 1.0);
    }
    if (STAGE == 1) return t.a.Sample(uv);

    float glow = t.a.Sample(uv).r;
    if (glow <= 0.004) return color;

    float4 e = d.cursor_trail_edge;
    float2 cell = float2(e.y - e.x, e.z - e.w);
    if (cell.x <= 0.0 || cell.y <= 0.0) return color;
    // Leave the real cursor untouched
    if (uv.x >= e.x && uv.x <= e.y && uv.y >= e.w && uv.y <= e.z) return color;

    // Grid aligned on terminal cells
    float2 g = (uv - float2(e.x, e.w)) / cell;
    float2 id = floor(g);
    float2 U = (frac(g) - GLYPH_PAD) / (1.0 - 2.0 * GLYPH_PAD);

    float col_phase = hash(float2(id.x, 7.0)) * 50.0;
    float row = id.y + floor(d.timestamp * FALL_SPEED + col_phase);
    float tick = floor(d.timestamp * FLICKER_RATE * (0.5 + hash(float2(id.x, row))));
    float glyph = 0.0;
    if (all(U >= 0.0) && all(U <= 1.0)) glyph = rune(U, float2(id.x * 13.0 + row, tick));

    float3 green = lerp(TAIL_COLOR, HEAD_COLOR, glow * glow);
    float3 rgb = lerp(color.rgb, TAIL_COLOR * 0.25, WASH * glow);
    rgb = lerp(rgb, green, glyph * glow);
    return float4(rgb, color.a);
}
