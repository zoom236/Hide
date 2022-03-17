Shader "Hidden/DepthToTarget"
{
    Properties
    {
		_MainTex("Main texture", 2D) = "white"
    }
    SubShader
    {
        Tags {"RenderType" = "Opaque"}

        Pass
        {
            Tags {"RenderType" = "Opaque"}
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile _ GLOBAL

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
				float2 uv : TEXCOORD;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
				float2 uv : TEXCOORD;
            };

			sampler2D _MainTex;
			sampler2D _GlobalTex;
            float4 _MainTex_ST;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            float4 frag (v2f i) : SV_Target
            {
                float4 col;
                #if GLOBAL
				col = tex2D(_GlobalTex, i.uv);
                #else
				col = tex2D(_MainTex, i.uv);

                #endif

                clip(col.a - 0.5);

                return i.vertex.z;
            }
            ENDCG
        }
    }
}
