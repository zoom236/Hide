Shader "Hidden/Knife/GPURaycastPackedInfoShader"
{
    Properties
    {
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
			#pragma multi_compile_instancing

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
                uint vid : SV_VertexID;
				UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 worldPos : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
				float id : TEXCOORD2;
				float4 uv : TEXCOORD3;
                float4 vertex : SV_POSITION;
                uint vid : TEXCOORD4;
            };
			
			struct FragmentOutput
			{ 
				float4 PackedDataBuffer : SV_Target0;
			}; 
			
			UNITY_INSTANCING_BUFFER_START(Props)
                UNITY_DEFINE_INSTANCED_PROP(int, ObjectID)
            UNITY_INSTANCING_BUFFER_END(Props)

            v2f vert (appdata v)
            {
                v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.worldPos = mul(unity_ObjectToWorld, v.vertex);
				o.worldNormal = normalize(mul(unity_ObjectToWorld, float4(v.normal, 0)));
				o.id = UNITY_ACCESS_INSTANCED_PROP(Props, ObjectID) + 1;
	            o.uv = ComputeScreenPos (o.vertex);
                o.vid = v.vid;

                return o;
            }

            float PackInfo(float3 value)
            {
				return floor(value.x * 256) * 1000000 + floor(value.y * 256) * 1000 + floor(value.z * 256);
            }

            FragmentOutput frag (v2f i)
            {
                FragmentOutput output;

                float3 worldNorm = (i.worldNormal + 1) / 2;
                float3 uv = i.uv / i.uv.w;
			    uv.z = ( UNITY_NEAR_CLIP_VALUE >= 0 ) ? uv.z : uv.z * 0.5 + 0.5;
                uv.z = LinearEyeDepth(uv.z);
                output.PackedDataBuffer = float4(i.vid, uv.z, PackInfo(worldNorm), i.id);
                // output.PackedDataBuffer = float4(worldNorm, 0);
				return output;
            }
            ENDCG
        }
    }
}
