Shader "Hidden/Knife.DPT.GUIShader"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
		Blend SrcAlpha OneMinusSrcAlpha
        LOD 100

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

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
            float4 _MainTex_ST;
			int Tile;
			int Clamp;
            float2 Offset;
			float Tiling;

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = v.uv;
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
				float2 tiling = float2(1,1);

				if(Tile == 1)
				{
					tiling = _ScreenParams.xy;
					tiling /= Tiling;
				}

				float2 uv = i.uv * tiling + Offset / _ScreenParams.xy * 100;

				if(Clamp == 1)
				{
					uv = clamp(uv, 0, 1);
				}

                fixed4 col = tex2D(_MainTex, uv);
                return col;
            }
            ENDCG
        }
    }
}
