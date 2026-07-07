Shader "Custom/Water"
{
    Properties
    {
        // =====================================================
        // Wave parameters -- 8 Gerstner waves (wind ~NE)
        // =====================================================
        [Header(Wave 1)]
        _WaveDir1("Direction (xy) / Steepness (z)", Vector) = (0.95,0.31,0.28,0)
        _WaveLen1("Wavelength (x) / Speed (y) / Phase (z)", Vector) = (10.0, 3.95, 0.0, 0)
        _WaveAmp1("Amplitude", Float) = 0.50

        [Header(Wave 2)]
        _WaveDir2("Direction (xy) / Steepness (z)", Vector) = (0.87,0.50,0.25,0)
        _WaveLen2("Wavelength (x) / Speed (y) / Phase (z)", Vector) = (6.5, 3.19, 1.5, 0)
        _WaveAmp2("Amplitude", Float) = 0.32

        [Header(Wave 3)]
        _WaveDir3("Direction (xy) / Steepness (z)", Vector) = (0.77,0.64,0.28,0)
        _WaveLen3("Wavelength (x) / Speed (y) / Phase (z)", Vector) = (4.0, 2.50, 2.8, 0)
        _WaveAmp3("Amplitude", Float) = 0.20

        [Header(Wave 4)]
        _WaveDir4("Direction (xy) / Steepness (z)", Vector) = (0.64,0.77,0.22,0)
        _WaveLen4("Wavelength (x) / Speed (y) / Phase (z)", Vector) = (2.6, 2.02, 4.2, 0)
        _WaveAmp4("Amplitude", Float) = 0.12

        [Header(Wave 5)]
        _WaveDir5("Direction (xy) / Steepness (z)", Vector) = (-0.20,-0.98,0.18,0)
        _WaveLen5("Wavelength (x) / Speed (y) / Phase (z)", Vector) = (7.0, 3.31, 1.8, 0)
        _WaveAmp5("Amplitude", Float) = 0.08

        [Header(Wave 6)]
        _WaveDir6("Direction (xy) / Steepness (z)", Vector) = (0.50,0.87,0.20,0)
        _WaveLen6("Wavelength (x) / Speed (y) / Phase (z)", Vector) = (1.6, 1.58, 5.0, 0)
        _WaveAmp6("Amplitude", Float) = 0.06

        [Header(Wave 7)]
        _WaveDir7("Direction (xy) / Steepness (z)", Vector) = (0.34,0.94,0.15,0)
        _WaveLen7("Wavelength (x) / Speed (y) / Phase (z)", Vector) = (1.0, 1.25, 3.5, 0)
        _WaveAmp7("Amplitude", Float) = 0.03

        [Header(Wave 8)]
        _WaveDir8("Direction (xy) / Steepness (z)", Vector) = (-0.10,-0.99,0.12,0)
        _WaveLen8("Wavelength (x) / Speed (y) / Phase (z)", Vector) = (0.5, 0.88, 6.0, 0)
        _WaveAmp8("Amplitude", Float) = 0.015

        [Header(Wave Global)]
        _WaveStrength("Overall Strength", Range(0, 3)) = 0.35
        _WaveSpeed("Overall Speed", Range(0, 3)) = 0.8

        // =====================================================
        // Tessellation
        // =====================================================
        [Header(Tessellation)]
        _TessMax("Max Tessellation", Range(1, 32)) = 32
        _TessMin("Min Tessellation", Range(1, 8)) = 8
        _TessDist("Tessellation Distance", Range(10, 200)) = 121

        // =====================================================
        // Optical parameters
        // =====================================================
        [Header(Optics)]
        _IOR("Index of Refraction", Range(1.0, 1.5)) = 1.333
        _RefractionStrength("Refraction Strength", Range(0.0, 1.0)) = 0.122
        _RefractionDepthFade("Refraction Depth Edge Guard", Range(0.05, 5.0)) = 5.0
        _RefractionEdgeSoftness("Refraction Edge Softness", Range(0.0, 3.0)) = 1.0
        _Roughness("Roughness", Range(0.0, 1.0)) = 0.15
        _Specular("Specular Strength", Range(0.0, 2.0)) = 1.0
        _FresnelPower("Fresnel Power", Range(0.5, 8.0)) = 0.5

        // =====================================================
        // Water color / Scattering (BSDF model)
        // =====================================================
        [Header(Scattering BSDF)]
        _AbsorptionColor("Absorption 渭a (RGB)", Color) = (0.57232696, 0.24206604, 0.17457764, 1)
        _ScatterColor("Scattering 渭s (RGB)", Color) = (0.040821113, 0.11993185, 0.3018868, 1)
        _PhaseG("HG Phase G", Range(-0.99, 0.99)) = -0.42
        _RaySteps("Ray March Steps", Range(1, 8)) = 2.5

        // =====================================================
        // Output toggles
        // =====================================================
        [Header(Output Toggles)]
        [ToggleUI] _ReflectionOn("Enable Reflection", Float) = 1
        [ToggleUI] _RefractionOn("Enable Refraction", Float) = 1
        [ToggleUI] _ScatteringOn("Enable Scattering", Float) = 1
        [ToggleUI] _TransmissionOn("Enable Transmission", Float) = 1

        // =====================================================
        // Foam / Waterline
        // =====================================================
        [Header(Foam)]
        [Toggle(_FOAM_ON)] _FoamOn("Enable Foam", Float) = 0
        _FoamColor("Foam Color", Color) = (0.9, 0.95, 1.0, 1)
        _FoamDepth("Foam Depth Range", Range(0.01, 2.0)) = 0.3
        _FoamCrest("Foam Crest Threshold", Range(0.3, 1.0)) = 0.7

        // =====================================================
        // Reflection
        // =====================================================
        [Header(Reflection)]
        _ReflectionStrength("Reflection Strength", Range(0.0, 1.0)) = 0.8

        // =====================================================
        // Caustics
        // =====================================================
        [Header(Caustics)]
        [Toggle(_CAUSTICS_ON)] _CausticsOn("Enable Caustics", Float) = 1
        _CausticsRT("Caustics RT", 2D) = "black" {}
        _CausticsStrength("Caustics Strength", Range(0.0, 3.0)) = 1.2

    }

    CustomEditor "WaterShaderGUI"

    SubShader
    {
        Tags
        {
            "RenderType" = "Transparent"
            "Queue" = "Transparent"
            "RenderPipeline" = "UniversalPipeline"
        }
        LOD 300
        Blend SrcAlpha OneMinusSrcAlpha
        Cull Back
        ZWrite On

        Pass
        {
            Name "Water"
            Tags { "LightMode" = "UniversalForward" }

            HLSLPROGRAM
            #pragma target 5.0
            #pragma vertex Vert
            #pragma hull Hull
            #pragma domain Domain
            #pragma fragment FragWater

            // URP keywords
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS
            #pragma multi_compile _ _MAIN_LIGHT_SHADOWS_CASCADE
            #pragma multi_compile _ _SHADOWS_SOFT

            // Feature toggles
            #pragma shader_feature_local _FOAM_ON
            #pragma shader_feature_local _CAUSTICS_ON

            // ---------------------------------------------------
            // Includes
            // ---------------------------------------------------
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Lighting.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareDepthTexture.hlsl"
            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/DeclareOpaqueTexture.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/BSDF.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/ImageBasedLighting.hlsl"
            #include "Packages/com.unity.render-pipelines.core/ShaderLibrary/Random.hlsl"
            #include "GerstnerWaves.hlsl"

            // Caustics cascade textures (set globally by CausticsFeature B+A)
            TEXTURE2D(_C0Tex); SAMPLER(sampler_C0Tex);
            TEXTURE2D(_C1Tex); SAMPLER(sampler_C1Tex);
            TEXTURE2D(_C2Tex); SAMPLER(sampler_C2Tex);
            TEXTURE2D(_CSTex); SAMPLER(sampler_CSTex);
            float4 _C0Center, _C1Center, _C2Center, _CSCenter;
            float4 _C0Size,   _C1Size,   _C2Size,   _CSSize;

            // ---------------------------------------------------
            // Material uniforms 鈥?all Properties-block variables declared here.
            // GerstnerWaves.hlsl only defines structs/functions, no uniforms.
            // ---------------------------------------------------
            CBUFFER_START(UnityPerMaterial)
                float4 _WaveDir1, _WaveDir2, _WaveDir3, _WaveDir4, _WaveDir5, _WaveDir6, _WaveDir7, _WaveDir8;
                float4 _WaveLen1, _WaveLen2, _WaveLen3, _WaveLen4, _WaveLen5, _WaveLen6, _WaveLen7, _WaveLen8;
                float  _WaveAmp1, _WaveAmp2, _WaveAmp3, _WaveAmp4, _WaveAmp5, _WaveAmp6, _WaveAmp7, _WaveAmp8;
                float  _WaveStrength, _WaveSpeed;
                float  _TessMax, _TessMin, _TessDist;
                float  _IOR, _RefractionStrength, _RefractionDepthFade, _RefractionEdgeSoftness, _Roughness, _Specular, _FresnelPower;
                float4 _AbsorptionColor, _ScatterColor;
                float  _PhaseG, _RaySteps;
                float  _ReflectionOn, _RefractionOn, _ScatteringOn, _TransmissionOn;
                float  _FoamOn;
                float4 _FoamColor;
                float  _FoamDepth, _FoamCrest;
                float  _CausticsOn, _CausticsStrength;
                float  _ReflectionStrength;
            CBUFFER_END

            // ---------------------------------------------------
            // Structs
            // ---------------------------------------------------
            struct Attributes
            {
                float3 positionOS : POSITION;
                float3 normalOS   : NORMAL;
                float4 tangentOS  : TANGENT;
                float2 uv         : TEXCOORD0;
            };

            struct TessellationControlPoint
            {
                float3 positionWS : INTERNALTESSPOS;
                float3 normalWS   : NORMAL;
                float4 tangentWS  : TANGENT;
                float2 uv         : TEXCOORD0;
            };

            struct HullOut
            {
                float3 positionWS : INTERNALTESSPOS;
                float3 normalWS   : NORMAL;
                float4 tangentWS  : TANGENT;
                float2 uv         : TEXCOORD0;
            };

            struct HsConstantOut
            {
                float edgeFactors[3] : SV_TessFactor;
                float insideFactor   : SV_InsideTessFactor;
            };

            struct Varyings
            {
                float4 positionCS       : SV_POSITION;
                float3 positionWS       : TEXCOORD0;
                float3 normalWS         : TEXCOORD1;
                float2 uv               : TEXCOORD2;
                float4 screenPos        : TEXCOORD3;
                float3 viewDirWS        : TEXCOORD4;
                float  waveHeight       : TEXCOORD5;
            };

            // ---------------------------------------------------
            // Snell's law refraction direction
            // ---------------------------------------------------
            float3 RefractDir(float3 V, float3 N, float eta)
            {
                float NoV = dot(N, -V);
                float k = 1.0 - eta * eta * (1.0 - NoV * NoV);
                if (k < 0.0) return reflect(V, N);
                return eta * (-V) - (eta * NoV + sqrt(k)) * N;
            }

            float2 ProjectWorldToScreenUV(float3 worldPos)
            {
                float4 clipPos = TransformWorldToHClip(worldPos);
                float4 screenPos = ComputeScreenPos(clipPos);
                return screenPos.xy / max(screenPos.w, 0.001);
            }

            float3 ReconstructWorldFromDepth(float2 uv, float rawDepth)
            {
                float4 ndc = float4(uv * 2.0 - 1.0, rawDepth, 1.0);
                ndc.y *= _ProjectionParams.x;
                float4 worldPos = mul(UNITY_MATRIX_I_VP, ndc);
                return worldPos.xyz / max(worldPos.w, 0.0001);
            }

            float RefractionDepthTrust(float2 uv, float3 referencePosWS, float2 texelOffset)
            {
                float2 sampleUV = saturate(uv + texelOffset);
                float rawDepth = SampleSceneDepth(sampleUV);
                float3 samplePosWS = ReconstructWorldFromDepth(sampleUV, rawDepth);
                float depthMismatch = distance(samplePosWS, referencePosWS);
                return 1.0 - smoothstep(_RefractionDepthFade * 0.25, _RefractionDepthFade, depthMismatch);
            }

            // ---------------------------------------------------
            // Henyey-Greenstein phase function
            // cosTheta = dot(viewDir, lightDir), g = forward-scattering bias
            // ---------------------------------------------------
            float HGPhase(float cosTheta, float g)
            {
                float g2 = g * g;
                float denom = 1.0 + g2 - 2.0 * g * cosTheta;
                return (1.0 - g2) / max(denom * sqrt(denom), 0.001) * 0.07957747; // / (4*PI)
            }

            // Mixed Rayleigh + Mie phase (5% Rayleigh, 95% HG)
            float3 ScatterPhase(float cosTheta, float g)
            {
                // Rayleigh: short wavelengths scatter more (beta 鈭?1/位鈦?
                float rayleighPhase = (1.0 + cosTheta * cosTheta) * (3.0 / (16.0 * 3.14159265));
                float3 rayleighBeta = float3(5.8, 13.5, 33.1);
                float3 rayleigh = rayleighBeta * rayleighPhase;

                float mie = HGPhase(cosTheta, g);
                return rayleigh * 0.05 + mie * 0.95;
            }

            // ---------------------------------------------------
            // Fresnel from IOR
            // ---------------------------------------------------
            float FresnelSchlickIOR(float NdotV, float ior)
            {
                float f0 = IorToFresnel0(ior);
                float f = F_Schlick(f0, NdotV);
                return saturate(f);
            }

            // ---------------------------------------------------
            // GGX specular for main directional light
            // ---------------------------------------------------
            float3 GGXSpecular(float3 N, float3 V, float3 L, float3 lightColor,
                               float roughness, float NdotV, float NdotL)
            {
                if (NdotL <= 0.0 || NdotV <= 0.0) return float3(0, 0, 0);

                float3 H = normalize(V + L);
                float  NdotH = saturate(dot(N, H));

                float D = D_GGX(NdotH, roughness);
                float G = V_SmithJointGGX(NdotL, NdotV, roughness);
                float3 F = F_Schlick(IorToFresnel0(_IOR), saturate(dot(H, V)));

                return lightColor * (D * G * F) * _Specular;
            }

            // ---------------------------------------------------
            // Vertex shader (control points for tessellation)
            // ---------------------------------------------------
            TessellationControlPoint Vert(Attributes input)
            {
                TessellationControlPoint o;
                o.positionWS = TransformObjectToWorld(input.positionOS);
                o.normalWS   = TransformObjectToWorldNormal(input.normalOS);
                o.tangentWS  = float4(TransformObjectToWorldDir(input.tangentOS.xyz), input.tangentOS.w);
                o.uv         = input.uv;
                return o;
            }

            // ---------------------------------------------------
            // Hull constant function: per-patch tess factors
            // ---------------------------------------------------
            HsConstantOut HullConstant(
                InputPatch<TessellationControlPoint, 3> patch,
                uint patchID : SV_PrimitiveID)
            {
                HsConstantOut o;
                float3 avgPos = (patch[0].positionWS + patch[1].positionWS + patch[2].positionWS) / 3.0;
                float tess = ComputeTessFactor(avgPos, _WorldSpaceCameraPos, _TessDist, _TessMax, _TessMin);

                o.edgeFactors[0] = tess;
                o.edgeFactors[1] = tess;
                o.edgeFactors[2] = tess;
                o.insideFactor   = tess;
                return o;
            }

            // ---------------------------------------------------
            // Hull shader: control point pass-through
            // ---------------------------------------------------
            [domain("tri")]
            [partitioning("fractional_odd")]
            [outputtopology("triangle_cw")]
            [outputcontrolpoints(3)]
            [patchconstantfunc("HullConstant")]
            HullOut Hull(
                InputPatch<TessellationControlPoint, 3> patch,
                uint id : SV_OutputControlPointID)
            {
                HullOut o;
                o.positionWS = patch[id].positionWS;
                o.normalWS   = patch[id].normalWS;
                o.tangentWS  = patch[id].tangentWS;
                o.uv         = patch[id].uv;
                return o;
            }

            // ---------------------------------------------------
            // Domain shader: apply Gerstner displacement
            // ---------------------------------------------------
            [domain("tri")]
            Varyings Domain(
                HsConstantOut hsConst,
                const OutputPatch<HullOut, 3> patch,
                float3 bary : SV_DomainLocation)
            {
                Varyings o;

                float3 basePosWS = patch[0].positionWS * bary.x
                                 + patch[1].positionWS * bary.y
                                 + patch[2].positionWS * bary.z;

                o.uv = patch[0].uv * bary.x + patch[1].uv * bary.y + patch[2].uv * bary.z;

                // Pack wave uniforms into struct, then apply all 8 Gerstner waves
                GerstnerWaveUniforms wu = BuildWaveUniforms(
                    _WaveDir1, _WaveLen1, _WaveAmp1,
                    _WaveDir2, _WaveLen2, _WaveAmp2,
                    _WaveDir3, _WaveLen3, _WaveAmp3,
                    _WaveDir4, _WaveLen4, _WaveAmp4,
                    _WaveDir5, _WaveLen5, _WaveAmp5,
                    _WaveDir6, _WaveLen6, _WaveAmp6,
                    _WaveDir7, _WaveLen7, _WaveAmp7,
                    _WaveDir8, _WaveLen8, _WaveAmp8,
                    _WaveStrength, _WaveSpeed
                );
                float3 dispPosWS, normalWS;
                EvaluateGerstnerWaves(basePosWS, wu, dispPosWS, normalWS);

                o.positionWS = dispPosWS;
                o.normalWS   = normalWS;
                o.waveHeight = dispPosWS.y - basePosWS.y;

                o.positionCS = TransformWorldToHClip(dispPosWS);
                o.screenPos  = ComputeScreenPos(o.positionCS);
                o.viewDirWS  = GetWorldSpaceNormalizeViewDir(dispPosWS);

                return o;
            }

            // ===================================================================
            // 鐗囧厓鐫€鑹插櫒  鈥? 姘翠綋鍏夊鍚堟垚
            // ===================================================================
            half4 FragWater(Varyings input) : SV_Target
            {
                // ---- 鍑嗗锛氬綊涓€鍖栧悜閲?+ 灞忓箷 UV + 鍦烘櫙娣卞害 ----
                float3 N     = normalize(input.normalWS);
                float3 V     = normalize(input.viewDirWS);
                float3 posWS = input.positionWS;
                float  NdotV = saturate(dot(N, V));
                float2 screenUV = input.screenPos.xy / max(input.screenPos.w, 0.001);

                // Reconstruct the opaque scene point below the water surface.
                float  sceneDepthRaw = SampleSceneDepth(screenUV);
                float3 scenePosWS = ReconstructWorldFromDepth(screenUV, sceneDepthRaw);

                // Vertical depth and optical distance through the water.
                float waterDepth    = max(0.0, posWS.y - scenePosWS.y);
                float waterDistance = max(0.0, distance(posWS, scenePosWS));

                // Main light.
                Light mainLight = GetMainLight();
                float3 L     = mainLight.direction;
                float  NdotL = saturate(dot(N, L));

                // 鏁ｅ皠鍙傛暟
                float3 muA = _AbsorptionColor.rgb;       // 鍚告敹绯绘暟
                float3 muS = _ScatterColor.rgb;          // 鏁ｅ皠绯绘暟
                float3 muT = muA + muS;                  // 娑堝厜绯绘暟 渭t = 渭a + 渭s
                float3 omega = muS / max(muT, 0.0001);   // 鏁ｅ皠鍙嶇収鐜?蠅 = 渭s/渭t

                // =========================================================
                // 鈶?鎶樺皠  鈥? Snell 瀹氬緥 + 灞忓箷绌洪棿閲囨牱
                // =========================================================
                float eta = 1.0 / _IOR;
                float3 refractDir = RefractDir(V, N, eta);   // 鎶樺皠鍚庣殑瑙嗙嚎鏂瑰悜

                // 鎶樺皠灏勭嚎涓庢按搴曠殑鍑犱綍浜ょ偣
                float  t = waterDepth / max(abs(refractDir.y), 0.001);
                float3 hitPosWS = posWS + refractDir * t;

                // 鍛戒腑鐐规姇褰卞洖灞忓箷 UV锛岄噰鏍蜂笉閫忔槑绾圭悊
                float  refractionToggle = saturate(_RefractionOn);
                float2 projectedRefractUV = ProjectWorldToScreenUV(hitPosWS);
                float2 candidateRefractUV = saturate(lerp(screenUV, projectedRefractUV, _RefractionStrength));
                float2 edgeTexel = rcp(max(_ScreenParams.xy, 1.0)) * _RefractionEdgeSoftness;
                float  depthTrust = RefractionDepthTrust(candidateRefractUV, scenePosWS, float2(0.0, 0.0));
                depthTrust = min(depthTrust, RefractionDepthTrust(candidateRefractUV, scenePosWS, float2( edgeTexel.x, 0.0)));
                depthTrust = min(depthTrust, RefractionDepthTrust(candidateRefractUV, scenePosWS, float2(-edgeTexel.x, 0.0)));
                depthTrust = min(depthTrust, RefractionDepthTrust(candidateRefractUV, scenePosWS, float2(0.0,  edgeTexel.y)));
                depthTrust = min(depthTrust, RefractionDepthTrust(candidateRefractUV, scenePosWS, float2(0.0, -edgeTexel.y)));
                float2 refractScreenUV = lerp(screenUV, candidateRefractUV, depthTrust);
                float  refractedDepthRaw = SampleSceneDepth(refractScreenUV);
                float3 refractedScenePosWS = ReconstructWorldFromDepth(refractScreenUV, refractedDepthRaw);
                float  refractedWaterDistance = max(0.0, distance(posWS, refractedScenePosWS));
                float3 sceneColor = SampleSceneColor(screenUV);
                float3 refractedColor = lerp(sceneColor, SampleSceneColor(refractScreenUV), refractionToggle);
                float3 opticalScenePosWS = lerp(scenePosWS, refractedScenePosWS, refractionToggle);
                float  opticalWaterDistance = lerp(waterDistance, refractedWaterDistance, refractionToggle);

                // =========================================================
                // 鈶?鍙嶅皠  鈥? 鐜鎺㈤拡 IBL + 鐙珛涓诲厜婧?GGX 楂樺厜
                // =========================================================
                float3 reflectDir = reflect(-V, N);
                float3 iblRefl = GlossyEnvironmentReflection(reflectDir, posWS, _Roughness, 1.0);
                float3 ggxSpec = GGXSpecular(N, V, L, mainLight.color, _Roughness, NdotV, NdotL);
                float  reflectionToggle = saturate(_ReflectionOn);
                float3 reflection = iblRefl * _ReflectionStrength * reflectionToggle;
                float3 specularReflection = ggxSpec * reflectionToggle;

                // =========================================================
                // 鈶?鑿叉秴鑰? 鈥? 鍙嶅皠 / 鎶樺皠娣峰悎姣?                // =========================================================
                float fresnel = FresnelSchlickIOR(NdotV, _IOR);
                fresnel = pow(saturate(fresnel), _FresnelPower);

                // =========================================================
                // 鈶?鏁ｅ皠  鈥? 渭a/渭s 鍒嗙 + HG 鐩镐綅 + 瑙嗙嚎 Ray March
                // =========================================================
                int   steps    = max(1, (int)_RaySteps);
                float rcpSteps = 1.0 / float(steps);
                float rayLen   = opticalWaterDistance;
                float jitter   = InterleavedGradientNoise(input.positionCS.xy, 0) * 0.5;

                float3 accumScatter  = float3(0, 0, 0);
                float3 transmittance = float3(1, 1, 1);

                if (_ScatteringOn > 0.5)
                {
                    for (int s = 0; s < steps; s++)
                    {
                        float  tNorm  = (float(s) + jitter) * rcpSteps;
                        float  stepLen = rayLen * rcpSteps;
                        float3 stepT   = exp(-muT * stepLen);                     // 姝ラ暱鍐呯殑閫忓皠鐜?
                        // Light removed over this step, weighted by single scattering albedo and phase.
                        float3 scattered = mainLight.color * transmittance * (1.0 - stepT) * omega;
                        scattered *= ScatterPhase(dot(-refractDir, L), _PhaseG);

                        accumScatter  += scattered;
                        transmittance *= stepT;
                    }
                }

                // 鎶樺皠鏂瑰悜缁撴灉 = 鍦烘櫙鑹茬粡姘翠綋琛板噺 + 瑙嗙嚎涓婄殑鏁ｅ皠绱Н
                float3 refractionResult = refractedColor * transmittance;
                float3 scattering = accumScatter;

                // =========================================================
                // 鈶?鑳屽厜閫忓皠  鈥? 鍏夋簮鍦ㄦ按闈㈣儗鍚庢椂绌块€忚杽姘村眰鐨勮緣鍏?                // =========================================================
                float  G_backlit   = saturate(-NdotL);
                float  T_backlit   = 1.0 - F_Schlick(IorToFresnel0(_IOR), G_backlit);
                float3 extinction  = exp(-muT * opticalWaterDistance);
                float  cosBacklit  = dot(-V, L);
                float3 P_backlit   = ScatterPhase(cosBacklit, 0.9);
                float3 transmission = mainLight.color * G_backlit * T_backlit * extinction * P_backlit * saturate(_TransmissionOn);

                // =========================================================
                // 鈶?娉℃搏  鈥? 鍚冩按绾?+ 娉㈠嘲锛堝彲寮€鍏筹級
                // =========================================================
                float foam = 0;
                #if defined(_FOAM_ON)
                {
                    float foamDepth = 1.0 - saturate(waterDistance / _FoamDepth);
                    foamDepth = smoothstep(0.0, 1.0, foamDepth);
                    float foamCrest = saturate((input.waveHeight - _FoamCrest) / max(1.0 - _FoamCrest, 0.001));
                    foam = max(foamDepth, foamCrest);
                }
                #endif

                // =========================================================
                // 鈶?鐒︽暎  鈥? 鏉ヨ嚜 Compute Shader 鐨勬按搴曞厜瀛愭槧灏勶紙鍙紑鍏筹級
                // =========================================================
                float3 caustics = float3(0, 0, 0);
                #if defined(_CAUSTICS_ON)
                {
                    // B+A cascade selection by camera distance
                    float2 worldXZ = opticalScenePosWS.xz;
                    float  camDist = distance(_WorldSpaceCameraPos.xz, worldXZ);
                    float2 cuv; float  edgeFade = 0;
                    float4 ctex;

                    // Cross-fade blending at cascade boundaries
                    float t01 = smoothstep(13, 15, camDist);  // C0→C1 blend weight
                    float t12 = smoothstep(26, 30, camDist);  // C1→C2 blend weight
                    float t2S = smoothstep(56, 60, camDist);  // C2→S  blend weight

                    float2 uv0 = (worldXZ - _C0Center.xy) / max(_C0Size.x, 0.001) + 0.5;
                    float2 uv1 = (worldXZ - _C1Center.xy) / max(_C1Size.x, 0.001) + 0.5;
                    float2 uv2 = (worldXZ - _C2Center.xy) / max(_C2Size.x, 0.001) + 0.5;
                    float2 uvS = (worldXZ - _CSCenter.xy) / max(_CSSize.x, 0.001) + 0.5;

                    float4 c0 = SAMPLE_TEXTURE2D_LOD(_C0Tex, sampler_C0Tex, uv0, 0);
                    float4 c1 = SAMPLE_TEXTURE2D_LOD(_C1Tex, sampler_C1Tex, uv1, 0);
                    float4 c2 = SAMPLE_TEXTURE2D_LOD(_C2Tex, sampler_C2Tex, uv2, 0);
                    float4 cS = SAMPLE_TEXTURE2D_LOD(_CSTex, sampler_CSTex, uvS, 0);

                    if (camDist < 13)      { ctex = c0; cuv = uv0; }
                    else if (camDist < 26) { ctex = lerp(c0, c1, t01); cuv = uv0; }
                    else if (camDist < 56) { ctex = lerp(c1, c2, t12); cuv = uv1; }
                    else                   { ctex = lerp(c2, cS, t2S); cuv = uv2; }

                    float2 causticEdge = saturate(cuv) * saturate(1.0 - cuv);
                    float causticAreaFade = smoothstep(0.0, 0.03, min(causticEdge.x, causticEdge.y));
                    float depthFade = smoothstep(0.0, 1.0, saturate(opticalWaterDistance / max(_RefractionDepthFade, 0.001)));
                    float cliffFade = lerp(1.0, depthTrust, refractionToggle * 0.65);
                    caustics = max(ctex.rgb, 0.0);
                    caustics *= _CausticsStrength * saturate(_CausticsOn) * causticAreaFade * depthFade * cliffFade * (1.0 - edgeFade);
                }
                #endif

                // =========================================================
                // 鈶?鍚堟垚  鈥? 鐙珛鍒嗛噺: 鎶樺皠 + 鏁ｅ皠 + 鍙嶅皠 + 閫忓皠 + 姘翠笅鐒︽暎 + GGX
                // =========================================================
                // 焦散照亮水底场景 + 少量散射贡献（模拟水底的散射回光）
                refractionResult += caustics * transmittance;
                scattering += caustics * 0.15;

                float3 waterColor = lerp(refractionResult, reflection, fresnel * reflectionToggle);
                float  transWeight = 1.0 - fresnel;
                waterColor += scattering;
                waterColor += transmission * transWeight;                           // Backlit transmission
                waterColor  = lerp(waterColor, _FoamColor.rgb, foam);              // 娉℃搏瑕嗙洊
                waterColor += specularReflection;                                  // GGX BRDF already contains its Fresnel term

                return half4(waterColor, 1.0);
            }
            ENDHLSL
        }
    }

    FallBack "Universal Render Pipeline/Lit"
}
