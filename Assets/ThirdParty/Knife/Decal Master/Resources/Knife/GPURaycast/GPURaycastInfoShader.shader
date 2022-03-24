Shader "Hidden/Knife/GPURaycastInfoShader"
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
				UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float4 worldPos : TEXCOORD0;
                float3 worldNormal : TEXCOORD1;
				float id : TEXCOORD2;
                float4 vertex : SV_POSITION;
            };
			
			struct FragmentOutput
			{ 
				float4 WorldPosBuffer : SV_Target0; 
				float4 WorldNormalBuffer : SV_Target1;
				float4 IDBuffer : SV_Target2;
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
				o.worldNormal = mul(unity_ObjectToWorld, float4(v.normal, 0));
				o.id = UNITY_ACCESS_INSTANCED_PROP(Props, ObjectID) + 1;

                return o;
            }

            FragmentOutput frag (v2f i)
            {
                FragmentOutput output;
				output.WorldPosBuffer = float4(i.worldPos.xyz, 1);
				output.WorldNormalBuffer = float4(normalize(i.worldNormal), 1);
				output.IDBuffer = float4(i.id, 0, 0, 1);
				return output;
            }
            ENDCG
        }
    }
}
