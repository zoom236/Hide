Shader /*ase_name*/ "Hidden/Templates/Decal" /*end*/
{

	Properties
	{
		/*ase_props*/
		_BlendNormals("Blend normals", Range(0, 1)) = 1.0
		[Toggle(TERRAIN_DECAL)] _TerrainDecal ("Terrain Decal", Float) = 0
		[Toggle(NORMAL_CLIP)] _NormalBlendOrClip ("Clip by Normals", Float) = 0
		[Toggle(NORMAL_EDGE_BLENDING)] _NormalEdgeBlending ("Normal Edge Blending", Float) = 0
		[Toggle(NORMAL_MASK)] _NormalsMask ("Normal Mask", Float) = 0
		_ClipNormals("Clip normals", Range(0, 1)) = 0.1
		_TerrainClipHeight("Terrain height clip", Range(-0.01, 0.01)) = 0.001
		_TerrainClipHeightPower("Terrain height clip power", Range(0, 15)) = 1
	}
	
	SubShader
	{
		/*ase_subshader_options:Name=Additional Options
			Option,0:Normal:Absolute
			Option,1:SpecularSmoothness:Absolute
		*/

		Tags { "RenderType"="Opaque" }
		LOD 100

		/*ase_all_modules*/
		
		/*ase_pass*/
		Pass // before lighting (diffuse and ambient light)
		{
			Name "Before Lighting"
			Fog { Mode Off }
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers nomrt
			#pragma multi_compile __ NO_TERRAIN
			#pragma multi_compile __ TERRAIN_DECAL
			#pragma multi_compile __ MULTI_TERRAIN_DECAL
			#pragma multi_compile __ NORMAL_CLIP
			#pragma multi_compile __ NORMAL_EDGE_BLENDING
			#pragma multi_compile __ NORMAL_MASK
			#pragma multi_compile_instancing
			
			#include "UnityCG.cginc"
			#if TERRAIN_DECAL && !NO_TERRAIN
				#include "TerrainDecals.cginc"
			#endif
			#include "UnityStandardUtils.cginc"

			/*ase_pragma*/

			struct appdata
			{
				float3 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				/*ase_vdata:p=p;c=c;uv0=p.xz+0.5*/
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 decalUV : TEXCOORD8;
				float4 screenUV : TEXCOORD7;
				float3 ray : TEXCOORD6;
				half3 orientation : TEXCOORD3;
				half3 orientationX : TEXCOORD4;
				half3 orientationZ : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				/*ase_interp(0,):sp=sp.xyzw*/
			};

			/*ase_globals*/
			
			v2f vertDecal (appdata v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.pos = UnityObjectToClipPos (float4(v.vertex,1));
				o.decalUV = v.vertex.xz+0.5;
				o.screenUV = ComputeScreenPos (o.pos);
				o.ray = mul (UNITY_MATRIX_MV, float4(v.vertex,1)).xyz * float3(-1,-1,1);
				o.orientation = mul ((float3x3)unity_ObjectToWorld, float3(0,1,0));
				o.orientationX = mul ((float3x3)unity_ObjectToWorld, float3(1,0,0));
				o.orientationZ = mul ((float3x3)unity_ObjectToWorld, float3(0,0,1));
				o.orientation = normalize(o.orientation);
				o.orientationX = normalize(o.orientationX);
				o.orientationZ = normalize(o.orientationZ);
				/*ase_vert_code:v=appdata;o=v2f*/
				return o;
			}
			
			v2f vert ( appdata v /*ase_vert_input*/)
			{
				v2f o = vertDecal(v);
				return o;
			}

			sampler2D_float _CameraDepthTexture;
			sampler2D _NormalsCopy;
			float _BlendNormals;
			float _ClipNormals;
			// xy - projected decal UV, zw - screen uv
			float4 fragDecalUV(v2f i)
			{
				i.ray = i.ray * (_ProjectionParams.z / i.ray.z);
				float2 uv = i.screenUV.xy / i.screenUV.w;
				
				float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv);
				depth = Linear01Depth (depth);
				float4 vpos = float4(i.ray * depth,1);
				float3 wpos = mul (unity_CameraToWorld, vpos).xyz;
				float3 opos = mul (unity_WorldToObject, float4(wpos,1)).xyz;
				
				clip (float3(0.5,1,0.5) - abs(opos.xyz));

				float2 meshUV = (opos.xz+0.5);
				
				return float4(meshUV, uv);
			}
			
			void frag (v2f i, out float4 outDiffuse : COLOR0, out float4 outNormal : COLOR1, out float4 outEmission : COLOR2 /*ase_frag_input*/)
			{
				UNITY_SETUP_INSTANCE_ID(i);

				float4 meshUVAndScreenUV = fragDecalUV(i);
				float2 uv = meshUVAndScreenUV.zw;
				float2 meshUV = meshUVAndScreenUV.xy;

				i.decalUV = meshUV;

				fixed4 finalColor;
				fixed3 normal;
				/*ase_frag_code:i=v2f*/
				
				finalColor = /*ase_frag_out:Albedo;Float4*/fixed4(1,1,1,1)/*end*/;
				normal = /*ase_frag_out:Normal;Float3*/ float3(0.5,0.5,1) /*end*/;
				float3x3 norMat = float3x3(i.orientationX, i.orientationZ, i.orientation);
				normal = mul (normal, norMat);
				
				float3 normalScreen = tex2D(_NormalsCopy, uv).rgb;
				float3 wnormal = normalScreen.rgb * 2.0 - 1.0;
				float blendByNormal = 1;

				#if NORMAL_CLIP
					clip (dot(wnormal, i.orientation) - _ClipNormals);
				#else
					float dotResult = dot(wnormal, i.orientation);
					blendByNormal = smoothstep(0, _ClipNormals, dotResult);
				#endif
				finalColor.a *= blendByNormal;

				float4 normalResult;
				normalResult.xyz = lerp(normal, wnormal + normal, 1 - _BlendNormals);
				normalResult.xyz = normalize(normalResult.xyz);

				float normalBlendFactor = (_BlendNormals) * finalColor.a;

				normalResult = float4(normalResult.xyz * 0.5f + 0.5f, normalBlendFactor);

				float3 shColor = ShadeSH9(float4(normalResult.xyz, 1));

				outDiffuse = finalColor;
				outNormal = normalResult;
				outEmission = float4(shColor.rgb * finalColor.rgb, finalColor.a);
			}
			ENDCG
		}

		/*ase_pass*/
		Pass // after lighting - emission
		{
			Name "Emission"
			Fog { Mode Off }
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers nomrt
			#pragma multi_compile __ NO_TERRAIN
			#pragma multi_compile __ TERRAIN_DECAL
			#pragma multi_compile __ MULTI_TERRAIN_DECAL
			#pragma multi_compile __ NORMAL_CLIP
			#pragma multi_compile __ NORMAL_EDGE_BLENDING
			#pragma multi_compile __ NORMAL_MASK
			#pragma multi_compile_instancing
			
			#include "UnityCG.cginc"
			#if TERRAIN_DECAL && !NO_TERRAIN
				#include "TerrainDecals.cginc"
			#endif
			#include "UnityStandardUtils.cginc"

			/*ase_pragma*/

			struct appdata
			{
				float3 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				/*ase_vdata:p=p;c=c;uv0=p.xz+float2(0.5, 0.5)*/
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 decalUV : TEXCOORD8;
				float4 screenUV : TEXCOORD7;
				float3 ray : TEXCOORD6;
				half3 orientation : TEXCOORD3;
				half3 orientationX : TEXCOORD4;
				half3 orientationZ : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				/*ase_interp(0,):sp=sp.xyzw*/
			};

			/*ase_globals*/
			
			v2f vertDecal (appdata v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.pos = UnityObjectToClipPos (float4(v.vertex,1));
				o.decalUV = v.vertex.xz+0.5;
				o.screenUV = ComputeScreenPos (o.pos);
				o.ray = mul (UNITY_MATRIX_MV, float4(v.vertex,1)).xyz * float3(-1,-1,1);
				o.orientation = mul ((float3x3)unity_ObjectToWorld, float3(0,1,0));
				o.orientationX = mul ((float3x3)unity_ObjectToWorld, float3(1,0,0));
				o.orientationZ = mul ((float3x3)unity_ObjectToWorld, float3(0,0,1));
				o.orientation = normalize(o.orientation);
				o.orientationX = normalize(o.orientationX);
				o.orientationZ = normalize(o.orientationZ);
				/*ase_vert_code:v=appdata;o=v2f*/
				return o;
			}
			
			v2f vert ( appdata v /*ase_vert_input*/)
			{
				v2f o = vertDecal(v);
				return o;
			}

			sampler2D_float _CameraDepthTexture;
			// xy - projected decal UV, zw - screen uv
			float4 fragDecalUV(v2f i)
			{
				i.ray = i.ray * (_ProjectionParams.z / i.ray.z);
				float2 uv = i.screenUV.xy / i.screenUV.w;
				
				float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv);
				depth = Linear01Depth (depth);
				float4 vpos = float4(i.ray * depth,1);
				float3 wpos = mul (unity_CameraToWorld, vpos).xyz;
				float3 opos = mul (unity_WorldToObject, float4(wpos,1)).xyz;
				
				clip (float3(0.5,1,0.5) - abs(opos.xyz));

				float2 meshUV = (opos.xz+0.5);
				
				return float4(meshUV, uv);
			}
			
			float4 frag (v2f i /*ase_frag_input*/) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(i);

				float4 meshUVAndScreenUV = fragDecalUV(i);
				float2 uv = meshUVAndScreenUV.zw;
				float2 meshUV = meshUVAndScreenUV.xy;

				i.decalUV = meshUV;

				fixed4 finalColor;
				/*ase_frag_code:i=v2f*/
				
				finalColor = /*ase_frag_out:Emission;Float4*/fixed4(0,0,0,0)/*end*/;
				return finalColor;
			}
			ENDCG
		}
		
		/*ase_pass*/
		Pass // editor only - selection
		{
			/*ase_hide_pass*/
			Name "Selection"
			Fog { Mode Off }
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers nomrt
			#pragma multi_compile __ NO_TERRAIN
			#pragma multi_compile __ TERRAIN_DECAL
			#pragma multi_compile __ MULTI_TERRAIN_DECAL
			#pragma multi_compile __ NORMAL_CLIP
			#pragma multi_compile __ NORMAL_EDGE_BLENDING
			#pragma multi_compile __ NORMAL_MASK
			#pragma multi_compile_instancing
			
			#include "UnityCG.cginc"
			#if TERRAIN_DECAL && !NO_TERRAIN
				#include "TerrainDecals.cginc"
			#endif
			#include "UnityStandardUtils.cginc"

			/*ase_pragma*/

			struct appdata
			{
				float3 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				/*ase_vdata:p=p;c=c;uv0=p.xz+float2(0.5, 0.5)*/
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 decalUV : TEXCOORD8;
				float4 screenUV : TEXCOORD7;
				float3 ray : TEXCOORD6;
				half3 orientation : TEXCOORD3;
				half3 orientationX : TEXCOORD4;
				half3 orientationZ : TEXCOORD5;
				float3 worldScale  : TEXCOORD2;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				/*ase_interp(0,):sp=sp.xyzw*/
			};

			/*ase_globals*/
			
			float SelectionTime;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;

			v2f vertDecal (appdata v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.pos = UnityObjectToClipPos (float4(v.vertex,1));
				o.decalUV = v.vertex.xz+0.5;
				o.screenUV = ComputeScreenPos (o.pos);
				o.ray = mul (UNITY_MATRIX_MV, float4(v.vertex,1)).xyz * float3(-1,-1,1);
				o.orientation = mul ((float3x3)unity_ObjectToWorld, float3(0,1,0));
				o.orientationX = mul ((float3x3)unity_ObjectToWorld, float3(1,0,0));
				o.orientationZ = mul ((float3x3)unity_ObjectToWorld, float3(0,0,1));
				o.orientation = normalize(o.orientation);
				o.orientationX = normalize(o.orientationX);
				o.orientationZ = normalize(o.orientationZ);
				o.worldScale = float3(
					length(float3(unity_ObjectToWorld[0].x, unity_ObjectToWorld[1].x, unity_ObjectToWorld[2].x)), // scale x axis
					length(float3(unity_ObjectToWorld[0].y, unity_ObjectToWorld[1].y, unity_ObjectToWorld[2].y)), // scale y axis
					length(float3(unity_ObjectToWorld[0].z, unity_ObjectToWorld[1].z, unity_ObjectToWorld[2].z))  // scale z axis
				);
				/*ase_vert_code:v=appdata;o=v2f*/
				return o;
			}
			
			v2f vert ( appdata v /*ase_vert_input*/)
			{
				v2f o = vertDecal(v);
				return o;
			}

			sampler2D_float _CameraDepthTexture;
			sampler2D _BaseColorCopy;
			// xy - projected decal UV, zw - screen uv
			float4 fragDecalUV(v2f i)
			{
				i.ray = i.ray * (_ProjectionParams.z / i.ray.z);
				float2 uv = i.screenUV.xy / i.screenUV.w;
				
				float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv);
				depth = Linear01Depth (depth);
				float4 vpos = float4(i.ray * depth,1);
				float3 wpos = mul (unity_CameraToWorld, vpos).xyz;
				float3 opos = mul (unity_WorldToObject, float4(wpos,1)).xyz;
				
				clip (float3(0.5,1,0.5) - abs(opos.xyz));

				float2 meshUV = (opos.xz+0.5);
				
				return float4(meshUV, uv);
			}
			
			float GetAlphaInPixel(float2 uv, float2 deltaUV)
			{
				fixed4 col10 = tex2D (_MainTex, clamp(uv + deltaUV, float2(0,0), _MainTex_ST.xy + _MainTex_ST.zw));

				return col10.a;
			}

			float4 CalcSelectionColor(float2 uv, float alpha, float2 deltaUV)
			{
				float alphaInRightPixel = GetAlphaInPixel(uv, float2(deltaUV.x, 0));
				float alphaInLeftPixel = GetAlphaInPixel(uv, float2(-deltaUV.x, 0));
				float alphaInUpPixel = GetAlphaInPixel(uv, float2(0, deltaUV.y));
				float alphaInBottomPixel = GetAlphaInPixel(uv, float2(0, -deltaUV.y));

				bool isOutlinedPixel = (alphaInRightPixel < 0.2 || alphaInLeftPixel < 0.2 || alphaInUpPixel < 0.2 || alphaInBottomPixel < 0.2);
				
				//float3 color = float3(255.0f / 255.0f, 102.0f / 255.0f, 0.0f / 255.0f); // orange
				float3 color = float3(0.0f / 255.0f, 174.0f / 255.0f, 239.0f / 255.0f); // blue
				return float4(color,isOutlinedPixel * pow(alpha, 0.5));//float4(color, alphaInRightPixel);
			}

			float4 frag (v2f i /*ase_frag_input*/) : SV_TARGET
			{
				UNITY_SETUP_INSTANCE_ID(i);

				float4 meshUVAndScreenUV = fragDecalUV(i);
				float2 uv = meshUVAndScreenUV.zw;
				float2 meshUV = meshUVAndScreenUV.xy;
				float notLinearDepth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv);

				i.decalUV = meshUV * _MainTex_ST.xy + _MainTex_ST.zw;

				fixed4 finalColor;
				fixed4 diffuse = tex2D (_MainTex, i.decalUV);
				float scaleLength = length(i.worldScale.xz);
				scaleLength *= scaleLength;
				float4 selectionColor = CalcSelectionColor(i.decalUV, diffuse.a, float2(0.00002 / notLinearDepth / scaleLength, 0.00002 / notLinearDepth / scaleLength)) * 4 * SelectionTime;

				fixed4 currentEmission = tex2D(_BaseColorCopy, uv);
				return float4(currentEmission.rgb + selectionColor.rgb * selectionColor.a, diffuse.a);
			}
			ENDCG
		}
		
		/*ase_pass*/
		Pass // before lighting (spec blend)
		{
			Name "Specular Smoothness"
			Fog { Mode Off }
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers nomrt
			#pragma multi_compile __ NO_TERRAIN
			#pragma multi_compile __ TERRAIN_DECAL
			#pragma multi_compile __ MULTI_TERRAIN_DECAL
			#pragma multi_compile __ NORMAL_CLIP
			#pragma multi_compile __ NORMAL_EDGE_BLENDING
			#pragma multi_compile __ NORMAL_MASK
			#pragma multi_compile_instancing
			
			#include "UnityCG.cginc"
			#if TERRAIN_DECAL && !NO_TERRAIN
				#include "TerrainDecals.cginc"
			#endif
			#include "UnityStandardUtils.cginc"

			/*ase_pragma*/

			struct appdata
			{
				float3 vertex : POSITION;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				/*ase_vdata:p=p;c=c;uv0=p.xz+0.5*/
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 decalUV : TEXCOORD8;
				float4 screenUV : TEXCOORD7;
				float3 ray : TEXCOORD6;
				half3 orientation : TEXCOORD3;
				half3 orientationX : TEXCOORD4;
				half3 orientationZ : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
				/*ase_interp(0,):sp=sp.xyzw*/
			};

			/*ase_globals*/
			
			v2f vertDecal (appdata v)
			{
				v2f o;
				UNITY_SETUP_INSTANCE_ID(v);
				UNITY_TRANSFER_INSTANCE_ID(v, o);
				o.pos = UnityObjectToClipPos (float4(v.vertex,1));
				o.decalUV = v.vertex.xz+0.5;
				o.screenUV = ComputeScreenPos (o.pos);
				o.ray = mul (UNITY_MATRIX_MV, float4(v.vertex,1)).xyz * float3(-1,-1,1);
				o.orientation = mul ((float3x3)unity_ObjectToWorld, float3(0,1,0));
				o.orientationX = mul ((float3x3)unity_ObjectToWorld, float3(1,0,0));
				o.orientationZ = mul ((float3x3)unity_ObjectToWorld, float3(0,0,1));
				o.orientation = normalize(o.orientation);
				o.orientationX = normalize(o.orientationX);
				o.orientationZ = normalize(o.orientationZ);
				/*ase_vert_code:v=appdata;o=v2f*/
				return o;
			}
			
			v2f vert ( appdata v /*ase_vert_input*/)
			{
				v2f o = vertDecal(v);
				return o;
			}

			sampler2D_float _CameraDepthTexture;
			sampler2D _SpecRoughnessCopy;
			sampler2D _NormalsCopy;
			float _BlendNormals;
			float _ClipNormals;
			// xy - projected decal UV, zw - screen uv
			float4 fragDecalUV(v2f i)
			{
				i.ray = i.ray * (_ProjectionParams.z / i.ray.z);
				float2 uv = i.screenUV.xy / i.screenUV.w;
				
				float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv);
				depth = Linear01Depth (depth);
				float4 vpos = float4(i.ray * depth,1);
				float3 wpos = mul (unity_CameraToWorld, vpos).xyz;
				float3 opos = mul (unity_WorldToObject, float4(wpos,1)).xyz;
				
				clip (float3(0.5,1,0.5) - abs(opos.xyz));

				float2 meshUV = (opos.xz+0.5);
				
				return float4(meshUV, uv);
			}
			
			void frag (v2f i, out float4 outSpecular : COLOR0, out float4 outSmoothness : COLOR1 /*ase_frag_input*/)
			{
				UNITY_SETUP_INSTANCE_ID(i);

				float4 meshUVAndScreenUV = fragDecalUV(i);
				float2 uv = meshUVAndScreenUV.zw;
				float2 meshUV = meshUVAndScreenUV.xy;

				i.decalUV = meshUV;

				fixed4 finalColor;
				fixed4 specGloss;
				fixed3 normal;
				/*ase_frag_code:i=v2f*/
				
				finalColor = /*ase_frag_out:Albedo;Float4*/fixed4(1,1,1,1)/*end*/;
				normal = /*ase_frag_out:Normal;Float3*/ float3(0.5,0.5,1) /*end*/;
				specGloss = /*ase_frag_out:SpecGloss;Float4*/ float4(0,0,0, 0) /*end*/;
				float3x3 norMat = float3x3(i.orientationX, i.orientationZ, i.orientation);
				normal = mul (normal, norMat);
				
				float3 normalScreen = tex2D(_NormalsCopy, uv).rgb;
				float3 wnormal = normalScreen.rgb * 2.0 - 1.0;
				float blendByNormal = 1;

				#if NORMAL_CLIP
					clip (dot(wnormal, i.orientation) - _ClipNormals);
				#else
					float dotResult = dot(wnormal, i.orientation);
					blendByNormal = smoothstep(0, _ClipNormals, dotResult);
				#endif
				finalColor.a *= blendByNormal;

				float4 currentSpecRoughness = tex2D(_SpecRoughnessCopy, uv);
				specGloss.a *= finalColor.a;

				outSpecular = float4(specGloss.rgb, finalColor.a);
				outSmoothness = float4(specGloss.a, 0, 0, finalColor.a);
			}
			ENDCG
		}
	}
	CustomEditor "ASEMaterialInspector"
}
