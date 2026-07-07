#ifndef GERSTNER_WAVES_INCLUDED
#define GERSTNER_WAVES_INCLUDED

// Gerstner wave parameters — 8 waves, packed into structs.
// Uses Unity's built-in _Time.y for animation — no C# driver needed.

#define GERSTNER_WAVE_COUNT 8

// Per-wave data
struct GerstnerWaveData
{
    float2 direction;
    float  steepness;
    float  wavelength;
    float  speed;
    float  phaseOffset;
    float  amplitude;
};

// All 8 waves (no time — _Time.y is used directly)
struct GerstnerWaveUniforms
{
    GerstnerWaveData waves[GERSTNER_WAVE_COUNT];
};

// -----------------------------------------------------------------------
// Pack material uniforms into the wave struct.
// strength/speed: global multipliers.
// -----------------------------------------------------------------------
GerstnerWaveUniforms BuildWaveUniforms(
    float4 dir1, float4 len1, float amp1,
    float4 dir2, float4 len2, float amp2,
    float4 dir3, float4 len3, float amp3,
    float4 dir4, float4 len4, float amp4,
    float4 dir5, float4 len5, float amp5,
    float4 dir6, float4 len6, float amp6,
    float4 dir7, float4 len7, float amp7,
    float4 dir8, float4 len8, float amp8,
    float  strength,
    float  speed
)
{
    GerstnerWaveUniforms wu;

    #define PACK(i, d, l, a) \
        wu.waves[i].direction   = (d).xy; \
        wu.waves[i].steepness   = (d).z;  \
        wu.waves[i].wavelength  = (l).x;  \
        wu.waves[i].speed       = (l).y * speed;  \
        wu.waves[i].phaseOffset = (l).z;  \
        wu.waves[i].amplitude   = a * strength;

    PACK(0, dir1, len1, amp1)
    PACK(1, dir2, len2, amp2)
    PACK(2, dir3, len3, amp3)
    PACK(3, dir4, len4, amp4)
    PACK(4, dir5, len5, amp5)
    PACK(5, dir6, len6, amp6)
    PACK(6, dir7, len7, amp7)
    PACK(7, dir8, len8, amp8)
    #undef PACK

    return wu;
}

// -----------------------------------------------------------------------
// Single Gerstner wave evaluation — uses _Time.y directly
// -----------------------------------------------------------------------
void GerstnerWaveSingle(
    float2 posXZ,
    GerstnerWaveData data,
    inout float3 disp,
    inout float3 normalMod
)
{
    float  A = data.amplitude;
    if (A < 0.0001) return;

    float2 D = data.direction;
    float  Q = saturate(data.steepness);
    float  L = data.wavelength;
    float  S = data.speed;
    float  phaseOffset = data.phaseOffset;

    float  k = 6.28318530718 / max(L, 0.001);
    float  c = S * k;
    float  dp = dot(D, posXZ);
    float  phi = k * dp - c * _Time.y + phaseOffset;

    float sinPhi, cosPhi;
    sincos(phi, sinPhi, cosPhi);

    disp.xz += Q * A * cosPhi * D;
    disp.y  += A * sinPhi;

    float ka = k * A;
    normalMod.x += ka * cosPhi * D.x;
    normalMod.z += ka * cosPhi * D.y;
    normalMod.y += ka * Q * sinPhi;
}

// -----------------------------------------------------------------------
// Evaluate all 8 Gerstner waves
// -----------------------------------------------------------------------
void EvaluateGerstnerWaves(
    float3 positionWS,
    GerstnerWaveUniforms wu,
    out float3 dispPosWS,
    out float3 normalWS
)
{
    float3 disp = float3(0, 0, 0);
    float3 nMod = float3(0, 0, 0);

    for (int i = 0; i < GERSTNER_WAVE_COUNT; i++)
    {
        GerstnerWaveSingle(positionWS.xz, wu.waves[i], disp, nMod);
    }

    dispPosWS = positionWS + disp;
    normalWS  = normalize(float3(-nMod.x, 1.0 - nMod.y, -nMod.z));
}

// -----------------------------------------------------------------------
// Height only (no horizontal displacement) — for LOD / tide queries
// -----------------------------------------------------------------------
float EvaluateGerstnerHeight(float2 posXZ, GerstnerWaveUniforms wu)
{
    float h = 0;
    for (int i = 0; i < GERSTNER_WAVE_COUNT; i++)
    {
        GerstnerWaveData data = wu.waves[i];
        float A = data.amplitude;
        if (A < 0.0001) continue;

        float2 D = data.direction;
        float  L = data.wavelength;
        float  S = data.speed;
        float  phaseOffset = data.phaseOffset;

        float k = 6.28318530718 / max(L, 0.001);
        float c = S * k;
        float dp = dot(D, posXZ);
        float phi = k * dp - c * _Time.y + phaseOffset;
        h += A * sin(phi);
    }
    return h;
}

// -----------------------------------------------------------------------
// Distance-weighted tessellation factor
// -----------------------------------------------------------------------
float ComputeTessFactor(float3 worldPos, float3 cameraPos, float maxDist, float maxTess, float minTess)
{
    float dist = distance(worldPos, cameraPos);
    float t = 1.0 - saturate(dist / maxDist);
    return lerp(minTess, maxTess, t * t);
}

#endif // GERSTNER_WAVES_INCLUDED
