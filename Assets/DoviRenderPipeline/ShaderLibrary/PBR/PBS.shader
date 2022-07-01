Shader "DoviRenderPipeline/PBR/PBS"
{
    Properties
    {
        _MainTex ("Base Color", 2D) = "white" {}
        _Color ("Color", Color) = (0.0,0.0,0.0,1)

        _NormalTex ("Normal Map", 2D) = "bump" {}

        _MetallicTex ("Metallic Texture", 2D) = "white" {}

        _RoughnessTex("Roughness Texture",2D) = "white" {}

        _AmbientOcclusion("Ambient Occlusion",2D) = "white" {}

        _IrradianceMap("Irradiance",CUBE) = ""{}
        _PrefilterMap("Prefilter",CUBE) = ""{}
        _LUT ("LUT", 2D) = "white" {}
    }

    SubShader
    {
        Tags
        {
            "LightMode"="DoviLit"
        }
        Pass
        {
            HLSLPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "../Common/PARAMESINPUT.hlsl"
            #include "UnityCG.cginc"
            #include "../Common/brdf.hlsl"
            uniform samplerCUBE _IrradianceMap;
            uniform samplerCUBE _PrefilterMap;
            uniform sampler2D _brdfLut;
            struct VertexInput_LIT
            {
                float2 texcoord0 : TEXCOORD0;
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                float4 tangent : TANGENT;
            };

            struct VertexOutput_LIT
            {
                float4 pos : SV_POSITION;
                float2 uv0 : TEXCOORD0;
                float4 posWorld : TEXCOORD1;
                
                half3 normalDir : TEXCOORD2; 
                half3 tangentDir : TEXCOORD3; 
                half3 bitangentDir : TEXCOORD4; 
                float3 normal : NORMAL;
            };

            float3 BRDFOut(VertexOutput_LIT i)
            {
                const float3 tanNormal = UnpackNormal(tex2D(_NormalTex, TRANSFORM_TEX(i.uv0,_NormalTex)));
                const float3x3 tangentTransform = float3x3(i.tangentDir, i.bitangentDir, i.normalDir);
                const half3 worldNormal  = normalize(mul(tanNormal, tangentTransform));

				const float3 V = normalize(_WorldSpaceCameraPos.xyz -i.posWorld.xyz);
                const float3 R = reflect(-V, worldNormal);
                const float3 metallic = tex2D(_MetallicTex,  i.uv0);
                const float3 albedo = tex2D(_MainTex, TRANSFORM_TEX(i.uv0, _MainTex));
                float roughness = tex2D(_RoughnessTex,  i.uv0).x;
                const float ao = tex2D(_AmbientOcclusion, TRANSFORM_TEX(i.uv0, _AmbientOcclusion)).x;
 
                float3 F0 = float3(0.04, 0.04, 0.04);
                F0 = lerp(F0, albedo, metallic);
                
                // direct light
				const float3 L = normalize(_kLightDirectionArr[0].xyz -i.posWorld.xyz);
                //const float3 L = normalize(_kLightDirectionArr[0].xyz);
                const float3 H = normalize(V + L);
                const float distance = length(_WorldSpaceLightPos0 - i.posWorld);
                //const float attenuation = 1.0 / (distance * distance);
                const float attenuation = 1.0;
                const float3 radiance = _kLightColorArr[0].rgb * attenuation;
                
                // Cook-Torrance BRDF
                const float NDF = DistributionGGX(worldNormal, H, roughness);
                const float G = GeometrySmith2(worldNormal, V, L, roughness);
                float3 F = fresnelSchlick(max(dot(H, V), 0.0), F0);

                const float3 nominator = NDF * G * F;
                const float denominator = 4 * max(dot(worldNormal, V), 0.0) * max(dot(worldNormal, L), 0.0) + 0.001;
                float3 specular = nominator / denominator;

                float3 kS = F;
                float3 kD = float3(1, 1, 1) - kS;
                kD *= 1.0 - metallic;
                const float NdotL = max(dot(worldNormal, L), 0.0);
               float3 directColor = (kD * albedo / PI + specular) * radiance * NdotL;

                // ambient lighting (we now use IBL as the ambient term)
                F = fresnelSchlickRoughness(max(dot(worldNormal, V), 0.0), F0, roughness);
                kS = F;
                kD = 1.0 - kS;
                kD *= 1.0 - metallic;

                const float3 irradiance = texCUBE(_IrradianceMap, worldNormal).rgb;
                const float3 diffuse = irradiance * albedo;

                //const float max_reflect_lod = 4.0;
                //const float3 prefilteredColor = texCUBElod(_PrefilterMap, float4(R, roughness * max_reflect_lod)).rgb;
				const float3 prefilteredColor = texCUBE(_PrefilterMap, R).rgb;

                float NdotV = max(dot(worldNormal, V), 0);
                const float2 brdf = tex2D(_LUT, float2(NdotV, roughness)).rg;
                specular = prefilteredColor * (F * brdf.x + brdf.y);
                const float3 indirectColor = (kD * diffuse + specular) * ao;
				float3 color = indirectColor + directColor;
                // HDR tonemapping
                //color = color / (color + float3(1, 1, 1));
                // gamma correct
                // color = pow(color, float3(0.44, 0.44, 0.44)); // 0.45 = 1.0/2.2
                return color;
            }

            VertexOutput_LIT vert(VertexInput_LIT v)
            {
                VertexOutput_LIT o = (VertexOutput_LIT)0;
                o.pos = UnityObjectToClipPos(v.vertex);
                o.normal = UnityObjectToWorldNormal(v.normal);
                o.posWorld = mul(unity_ObjectToWorld, v.vertex);
                o.uv0 = v.texcoord0;

                o.normalDir = UnityObjectToWorldNormal(v.normal);
                o.tangentDir = normalize(mul(unity_ObjectToWorld, float4( v.tangent.xyz, 0.0)).xyz);
                o.bitangentDir = normalize(cross(o.normalDir, o.tangentDir) * v.tangent.w);
                return o;
            }

            fixed4 frag(VertexOutput_LIT i) : SV_Target
            {
                float3 o = BRDFOut(i);
                return fixed4(o, 1);
            }
            
            ENDHLSL
        }
    }
}