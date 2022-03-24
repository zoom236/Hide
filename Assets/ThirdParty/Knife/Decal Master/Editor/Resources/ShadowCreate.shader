Shader "Hidden/Knife/ShadowCreate"
{
    Properties
    {
		_Color("Color", Color) = (0,0,0,0)
        _MainTex ("Texture", 2D) = "white" {}
        _Emission ("Texture", 2D) = "black" {}
		_EmissionColor("Emission color", Color) = (0,0,0,0)
        _NormalMap ("Normal", 2D) = "black" {}
		_NormalScale("Normal scale", Float) = 1
		_TextureSize("Texture size", Int) = 0
		_ShadowOffset("Shadow offset", Vector) = (0,0,0,0)
		_Tiling("Tiling", Vector) = (0,0,0,0)
		_ShadowOpacity("Shadow opacity", Range(0, 1)) = 1
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "UnityStandardUtils.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };
			
            sampler2D _MainTex;
            sampler2D _Emission;
            sampler2D _NormalMap;
            float4 _MainTex_ST;
			int _TextureSize;
			float2 _ShadowOffset;
			float4 _Tiling;
			float4 _Color;
			float4 _EmissionColor;
			float _ShadowOpacity;
			float _NormalScale;
			int _ClampUV;
			int _NormalsOnly;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

			half3 UnpackNormalScale(half4 packednormal, half Scale)
			{
				half3 normal;
				normal.xy = (packednormal.wy * 2 - 1);
				normal.xy *= Scale;
				normal.z = sqrt(1.0 - saturate(dot(normal.xy, normal.xy)));
				return normal;
			}

            fixed4 frag (v2f i) : SV_Target
            {
				float2 uv = i.uv * _Tiling.xy + _Tiling.zw;
				if(_ClampUV == 1)
				{
					uv.x = clamp(uv.x, 0, 1);
					uv.y = clamp(uv.x, 0, 1);
				}

                fixed4 colOrig = tex2D(_MainTex, uv) * _Color;
				
				float3 lightColor = float3(1,1,1) * 0.05;
				float3 lightDirection = normalize(float3(1, -1, 2));

				float3 norm = UnpackNormalScale(tex2D(_NormalMap,  uv), _NormalScale * 5);
				float attenuation = max(0, dot(norm, -lightDirection) * 0.5 + 0.5);
				//return float4(attenuation, attenuation, attenuation, colOrig.a);

				if(_NormalsOnly == 1)
				{
					colOrig.a = 1;
					colOrig.rgb = 0;
					colOrig.rgb += (attenuation) * float4(lightColor * 20, 1);
					return float4(norm * 0.5 + 0.5, 1);
				} else
				{
					colOrig.rgb += (attenuation) * lightColor;
				
					colOrig.rgb += tex2D(_Emission, uv) * _EmissionColor;

					fixed4 col = tex2D(_MainTex, uv - _ShadowOffset / _TextureSize) * _Color;
					float4 shadow = float4(0,0,0, clamp(col.a * _ShadowOpacity, 0, 1));
					//return lerp(shadow, colOrig, 1 - _ShadowOpacity * col.a * (1 - colOrig.a) * (length(colOrig)));

					float blackBlend = smoothstep(0, 0.4, length(colOrig));

					return lerp(shadow * blackBlend, colOrig, colOrig.a);
				}
            }
            ENDCG
        }
		
		Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
			#include "UnityStandardUtils.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
            };

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				return float4(1,1,1,1);
            }
            ENDCG
        }
    }
}
