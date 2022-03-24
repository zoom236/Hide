Shader "Knife/Decals/PBR"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		[PerRendererData] _Tint("Tint", Color) = (1,1,1,1)
		[PerRendererData] _UV("UV", Vector) = (1,1,0,0)
		_MainTex ("Diffuse", 2D) = "white" {}
		[NoScaleOffset]_BumpMap ("Normals", 2D) = "bump" {}
		_NormalScale("Normal Scale", Float) = 1.0
		[NoScaleOffset]_SpecularMap ("Specular", 2D) = "black" {}
		[HDR]_EmissionColor("Emission Color", Color) = (1,1,1,1)
		[NoScaleOffset]_EmissionMap ("Emission", 2D) = "black" {}
		_Smoothness("Smoothness", Range(0, 1)) = 1.0
		_BlendNormals("Blend normals", Range(0, 1)) = 1.0
		[Toggle(TERRAIN_DECAL)] _TerrainDecal ("Terrain Decal", Float) = 0
		[Toggle(NORMAL_CLIP)] _NormalBlendOrClip ("Clip by Normals", Float) = 0
		[Toggle(NORMAL_EDGE_BLENDING)] _NormalEdgeBlending ("Normal Edge Blending", Float) = 0
		[Toggle(NORMAL_MASK)] _NormalsMask ("Normal Mask", Float) = 0
		_ClipNormals("Clip normals", Range(0, 1)) = 0.1
		_TerrainClipHeight("Terrain height clip", Range(-0.01, 0.01)) = 0.001
		_TerrainClipHeightPower("Terrain height clip power", Range(0, 15)) = 1
		[Toggle(NOEXCLUSIONMASK)] _NoExclusionMask ("Ignore Exclusion Mask", Float) = 0
	}
	SubShader
	{
		Tags
		{
			"PreviewType" = "Plane"
		}
		Pass // before lighting (diffuse and ambient light)
		{
			Fog { Mode Off }
			ZWrite Off
			Cull Back
			ZClip Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers nomrt
			#pragma multi_compile __ NO_TERRAIN
			#pragma multi_compile __ EXCLUSIONMASK
			#pragma multi_compile __ NOEXCLUSIONMASK
			#pragma multi_compile __ TERRAIN_DECAL
			#pragma multi_compile __ MULTI_TERRAIN_DECAL
			#pragma multi_compile __ NORMAL_CLIP
			#pragma multi_compile __ NORMAL_EDGE_BLENDING
			#pragma multi_compile __ NORMAL_MASK
			#pragma multi_compile __ UNITY_HDR_ON
			#pragma multi_compile __ PREVIEWCAMERA
			#pragma multi_compile_instancing
			
			#include "UnityCG.cginc"
			#if TERRAIN_DECAL && !NO_TERRAIN
				#include "TerrainDecals.cginc"
			#endif
			#include "UnityStandardUtils.cginc"
			
			struct appdata
			{
				float3 vertex : POSITION;
				float2 uv : TEXCOORD;
			#if UNITY_VERSION >= 550
				UNITY_VERTEX_INPUT_INSTANCE_ID
			#else
				UNITY_VERTEX_INPUT_INSTANCE_ID
			#endif
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
				float4 screenUV : TEXCOORD1;
				float3 ray : TEXCOORD2;
				half3 orientation : TEXCOORD3;
				half3 orientationX : TEXCOORD4;
				half3 orientationZ : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			UNITY_INSTANCING_BUFFER_START(DecalProps)
				UNITY_DEFINE_INSTANCED_PROP(float4, _Tint)
				UNITY_DEFINE_INSTANCED_PROP(float4, _UV)
			UNITY_INSTANCING_BUFFER_END(DecalProps)

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float4 _NotInstancedColor;
			float4 _NotInstancedUV;
			sampler2D _BumpMap;
			sampler2D _SpecularMap;
			float4 _EmissionColor;
			sampler2D _EmissionMap;

			float _NormalScale;
			float _Smoothness;
			float _BlendNormals;
			float _ClipNormals;

			sampler2D_float _CameraDepthTexture;
			sampler2D _NormalsCopy;
			sampler2D _CameraTargetCopy;
			sampler2D_float _ExclusionMask;
			#include "DecalMain.cginc"

			v2f vert (appdata v)
			{
				v2f o = vertDecal(v);
				return o;
			}
			
			void frag(v2f i, out float4 outDiffuse : COLOR0, out float4 outNormal : COLOR1, out float4 outEmission : COLOR2)
			{
				UNITY_SETUP_INSTANCE_ID(i);
				float4 uvInstanced = UNITY_ACCESS_INSTANCED_PROP(DecalProps, _UV);
				#if PREVIEWCAMERA
					float4 diffusePreview = tex2D (_MainTex, i.uv);
					float4 colPreview = diffusePreview * _Color;
					outDiffuse = colPreview;
					return;
				#endif
				
				float3 wpos;
				bool needCull;
				float4 meshUVAndScreenUV = fragDecalUV(i, wpos, needCull);

				outDiffuse = 0;
				outNormal = 0;
				outEmission = 0;
	
				#if EXCLUSIONMASK
					if(needCull)
						return;
				#endif

				float2 uv = meshUVAndScreenUV.zw;
				float2 meshUV = meshUVAndScreenUV.xy;

				i.uv = meshUV * _MainTex_ST.xy * (uvInstanced.xy * _NotInstancedUV.xy) + _MainTex_ST.zw + uvInstanced.zw + _NotInstancedUV.zw;
				
				float3 normal = tex2D(_NormalsCopy, uv).rgb;
				float3 wnormal = normal.rgb * 2.0 - 1.0;
				float blendByNormal = 1;

				#if NORMAL_CLIP
					clip (dot(wnormal, i.orientation) - _ClipNormals);
				#else
					float dotResult = dot(wnormal, i.orientation);
					blendByNormal = smoothstep(0, _ClipNormals, dotResult);
				#endif
				
				float4 diffuse = tex2D (_MainTex, i.uv);
				float4 col = diffuse * _Color * _NotInstancedColor;
				col.a *= blendByNormal;
				col *= UNITY_ACCESS_INSTANCED_PROP(DecalProps, _Tint);
				
				float blendTerrains = 1;
				#if TERRAIN_DECAL && !NO_TERRAIN
					blendTerrains = GetTerrainBlending(wpos);
					col.a *= blendTerrains;
				#endif
				outDiffuse = col;
				
				float3 nor = UnpackScaleNormal(tex2D(_BumpMap, i.uv), _NormalScale);
				float3x3 norMat = float3x3(i.orientationX, i.orientationZ, i.orientation);
				nor = mul (nor, norMat);
				float4 normalResult;
				normalResult.xyz = lerp(nor, wnormal + nor, 1 - _BlendNormals);
				normalResult.xyz = normalize(normalResult.xyz);

				float normalBlendFactor;

				#if NORMAL_EDGE_BLENDING
					#if NORMAL_MASK
						normalBlendFactor = diffuse.a;
					#else
						float dist = distance(meshUV, float2(.5, .5)) * 2;
						dist = pow(dist, 3);
						dist = clamp(dist, 0, 1);
						normalBlendFactor = (1 - dist);
					#endif
				#else
					normalBlendFactor = (_BlendNormals) * col.a;
				#endif

				normalResult = float4(normalResult.xyz * 0.5f + 0.5f, normalBlendFactor);

				float3 shColor = ShadeSH9(float4(normalResult.xyz, 1));

				//float4 currentLighting = tex2D(_CameraTargetCopy, uv);

				col.rgb = shColor.rgb * col.rgb;

				#ifndef UNITY_HDR_ON
					col.rgb = exp2(-col.rgb);
				#endif
				
				outEmission = float4(col.rgb + (tex2D (_EmissionMap, i.uv) * _EmissionColor).rgb * col.a, col.a);

				outNormal = normalResult;
			}
			ENDCG
		}
		
		Pass// Editor Only - SELECTION
		{
			Fog { Mode Off } // no fog in g-buffers pass
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers nomrt
			#pragma multi_compile __ TERRAIN_DECAL
			#pragma multi_compile __ MULTI_TERRAIN_DECAL
			#pragma multi_compile __ NORMAL_EDGE_BLENDING
			#pragma multi_compile __ NORMAL_MASK
			
			#include "UnityCG.cginc"
			#if TERRAIN_DECAL && !NO_TERRAIN
				#include "TerrainDecals.cginc"
			#endif
			#include "UnityStandardUtils.cginc"
			
			#include "AutoLight.cginc"
			#include "UnityPBSLighting.cginc"

			struct appdata
			{
				float3 vertex : POSITION;
			#if UNITY_VERSION >= 550
				UNITY_VERTEX_INPUT_INSTANCE_ID
			#else
				UNITY_VERTEX_INPUT_INSTANCE_ID
			#endif
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
				float4 screenUV : TEXCOORD1;
				float3 ray : TEXCOORD2;
				half3 orientation : TEXCOORD3;
				half3 orientationX : TEXCOORD4;
				half3 orientationZ : TEXCOORD5;
				float3 worldScale  : TEXCOORD6;
			};
			
			sampler2D _MainTex;
			sampler2D _BumpMap;
			float4 _MainTex_ST;
			float4 _Color;
			float4 _NotInstancedColor;
			float4 _NotInstancedUV;
			float _NormalScale;
			sampler2D _BaseColorCopy;

			sampler2D_float _CameraDepthTexture;
			sampler2D_float _ExclusionMask;
			sampler2D _NormalsCopy;

			float SelectionTime;

			#include "DecalMain.cginc"
			
			v2f vert (appdata v)
			{
				v2f o = vertDecal(v);
				o.worldScale = float3(
					length(float3(unity_ObjectToWorld[0].x, unity_ObjectToWorld[1].x, unity_ObjectToWorld[2].x)), // scale x axis
					length(float3(unity_ObjectToWorld[0].y, unity_ObjectToWorld[1].y, unity_ObjectToWorld[2].y)), // scale y axis
					length(float3(unity_ObjectToWorld[0].z, unity_ObjectToWorld[1].z, unity_ObjectToWorld[2].z))  // scale z axis
				);
				return o;
			}

			float GetAlphaInPixel(float2 uv, float2 deltaUV)
			{
				if(_Color.a > 0)
				{
					fixed4 col10 = tex2D (_MainTex, clamp(uv + deltaUV, float2(0,0), _MainTex_ST.xy + _MainTex_ST.zw)) * _Color * _NotInstancedColor;

					return col10.a;
				} else
				{
					fixed4 col10 = tex2D (_MainTex, clamp(uv + deltaUV, float2(0,0), _MainTex_ST.xy + _MainTex_ST.zw));

					return 1 - col10.a;
				}
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
			
			// return value is emission
			float4 frag(v2f i) : SV_TARGET
			{
				float3 wpos;
				float4 meshUVAndScreenUV = fragDecalUV(i, wpos);
				float2 uv = meshUVAndScreenUV.zw;
				float2 meshUV = meshUVAndScreenUV.xy;
				i.uv = meshUV * _MainTex_ST.xy * _NotInstancedUV.xy + _MainTex_ST.zw + _NotInstancedUV.zw;
				float notLinearDepth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv);

				half3 normal = tex2D(_NormalsCopy, uv).rgb;
				fixed3 wnormal = normal.rgb * 2.0 - 1.0;
				clip (dot(wnormal, i.orientation) - 0.1);
				
				fixed4 diffuse = tex2D (_MainTex, i.uv);
				fixed4 col = diffuse * _Color * _NotInstancedColor;
				float blendTerrains = 1;
				#if TERRAIN_DECAL && !NO_TERRAIN
					blendTerrains = GetTerrainBlending(wpos);
					col.a *= blendTerrains;
				#endif
				
				fixed4 currentEmission = tex2D(_BaseColorCopy, uv);

				float4 selectionColor = float4(0,0,0,0);
				float scaleLength = length(i.worldScale.xz);
				scaleLength *= scaleLength;

				float alpha = 1;
				#if NORMAL_EDGE_BLENDING
					#if NORMAL_MASK
						alpha = diffuse.a;
					#else
						float3 nor = UnpackScaleNormal(tex2D(_BumpMap, i.uv), _NormalScale);
						float3x3 norMat = float3x3(i.orientationX, i.orientationZ, i.orientation);
						//nor = mul (nor, norMat);
						alpha = 1 - dot(nor, float3(0.5, 0.5, 1));
						alpha = clamp(alpha, 0, 1);
						/*float dist = distance(meshUV, float2(.5, .5)) * 2;
						dist = pow(dist, 3);
						dist = clamp(dist, 0, 1);
						alpha = (1 - dist) * 0.01;*/
					#endif
				#else
					alpha = col.a;
				#endif

				selectionColor = CalcSelectionColor(i.uv, alpha, float2(0.0002 / notLinearDepth / scaleLength, 0.0002 / notLinearDepth / scaleLength)) * 2 * SelectionTime;
				//return selectionColor;

				return float4(selectionColor.rgb, diffuse.a * SelectionTime * selectionColor.a);
			}
			ENDCG
		}		
		
		Pass // before lighting (spec blend)
		{
			Fog { Mode Off }
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers nomrt
			#pragma multi_compile __ NO_TERRAIN
			#pragma multi_compile __ EXCLUSIONMASK
			#pragma multi_compile __ NOEXCLUSIONMASK
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

			struct appdata
			{
				float3 vertex : POSITION;
			#if UNITY_VERSION >= 550
				UNITY_VERTEX_INPUT_INSTANCE_ID
			#else
				UNITY_VERTEX_INPUT_INSTANCE_ID
			#endif
			};

			UNITY_INSTANCING_BUFFER_START(DecalProps)
				UNITY_DEFINE_INSTANCED_PROP(float4, _Tint)
				UNITY_DEFINE_INSTANCED_PROP(float4, _UV)
			UNITY_INSTANCING_BUFFER_END(DecalProps)

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
				float4 screenUV : TEXCOORD1;
				float3 ray : TEXCOORD2;
				half3 orientation : TEXCOORD3;
				half3 orientationX : TEXCOORD4;
				half3 orientationZ : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float4 _NotInstancedColor;
			float4 _NotInstancedUV;
			sampler2D _SpecularMap;
			float _ClipNormals;
			float _BlendNormals;

			float _Smoothness;

			sampler2D_float _CameraDepthTexture;
			sampler2D_float _ExclusionMask;
			sampler2D _NormalsCopy;
			sampler2D _SpecRoughnessCopy;
			#include "DecalMain.cginc"

			v2f vert (appdata v)
			{
				v2f o = vertDecal(v);
				return o;
			}
			
			void frag(v2f i, out float4 outSpecular : COLOR0, out float4 outSmoothness : COLOR1)
			{
				UNITY_SETUP_INSTANCE_ID(i);

				bool needCull;
				
				float3 wpos;
				float4 meshUVAndScreenUV = fragDecalUV(i, wpos, needCull);
				float2 uv = meshUVAndScreenUV.zw;

				outSpecular = 0;
				outSmoothness = 0;
	
				#if EXCLUSIONMASK
					if(needCull)
						return;
				#endif

				float2 meshUV = meshUVAndScreenUV.xy;
				float4 uvInstanced = UNITY_ACCESS_INSTANCED_PROP(DecalProps, _UV);
				i.uv = meshUV * _MainTex_ST.xy * (uvInstanced.xy * _NotInstancedUV.xy) + _MainTex_ST.zw + uvInstanced.zw + _NotInstancedUV.zw;

				float3 normal = tex2D(_NormalsCopy, uv).rgb;
				float3 wnormal = normal.rgb * 2.0 - 1.0;
				float blendByNormal = 1;
				#if NORMAL_CLIP
					clip (dot(wnormal, i.orientation) - _ClipNormals);
				#else
					float dotResult = dot(wnormal, i.orientation);
					blendByNormal = smoothstep(0, _ClipNormals, dotResult);
				#endif
				
				float4 diffuse = tex2D (_MainTex, i.uv);
				float4 col = diffuse * _Color * _NotInstancedColor;
				col.a *= blendByNormal;
				col *= UNITY_ACCESS_INSTANCED_PROP(DecalProps, _Tint);
				float blendTerrains = 1;
				#if TERRAIN_DECAL && !NO_TERRAIN
					blendTerrains = GetTerrainBlending(wpos);
					col.a *= blendTerrains;
				#endif
				
				float normalBlendFactor;

				#if NORMAL_EDGE_BLENDING
					#if NORMAL_MASK
						normalBlendFactor = diffuse.a;
					#else
						float dist = distance(meshUV, float2(.5, .5)) * 2;
						dist = pow(dist, 3);
						dist = clamp(dist, 0, 1);
						normalBlendFactor = (1 - dist);
					#endif
				#else
					normalBlendFactor = (_BlendNormals) * col.a;
				#endif
				
				float4 currentSpecRoughness = tex2D(_SpecRoughnessCopy, uv);
				float4 spec = tex2D (_SpecularMap, i.uv);
				spec.a *= _Smoothness * normalBlendFactor;

				outSpecular = float4(spec.rgb, normalBlendFactor);
				outSmoothness = float4(spec.a, 0, 0, normalBlendFactor);
			}
			ENDCG
		}

		// SAME, BUT CULL FRONT AND ZTEST Greater

		Pass // before lighting (diffuse and ambient light)
		{
			Fog { Mode Off }
			ZWrite Off
			Cull Front
			ZTest Greater
			ZClip Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers nomrt
			#pragma multi_compile __ NO_TERRAIN
			#pragma multi_compile __ EXCLUSIONMASK
			#pragma multi_compile __ NOEXCLUSIONMASK
			#pragma multi_compile __ TERRAIN_DECAL
			#pragma multi_compile __ MULTI_TERRAIN_DECAL
			#pragma multi_compile __ NORMAL_CLIP
			#pragma multi_compile __ NORMAL_EDGE_BLENDING
			#pragma multi_compile __ NORMAL_MASK
			#pragma multi_compile __ UNITY_HDR_ON
			#pragma multi_compile __ PREVIEWCAMERA
			#pragma multi_compile_instancing
			
			#include "UnityCG.cginc"
			#if TERRAIN_DECAL && !NO_TERRAIN
				#include "TerrainDecals.cginc"
			#endif
			#include "UnityStandardUtils.cginc"
			
			struct appdata
			{
				float3 vertex : POSITION;
				float2 uv : TEXCOORD;
			#if UNITY_VERSION >= 550
				UNITY_VERTEX_INPUT_INSTANCE_ID
			#else
				UNITY_VERTEX_INPUT_INSTANCE_ID
			#endif
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
				float4 screenUV : TEXCOORD1;
				float3 ray : TEXCOORD2;
				half3 orientation : TEXCOORD3;
				half3 orientationX : TEXCOORD4;
				half3 orientationZ : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			UNITY_INSTANCING_BUFFER_START(DecalProps)
				UNITY_DEFINE_INSTANCED_PROP(float4, _Tint)
				UNITY_DEFINE_INSTANCED_PROP(float4, _UV)
			UNITY_INSTANCING_BUFFER_END(DecalProps)

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float4 _NotInstancedColor;
			float4 _NotInstancedUV;
			sampler2D _BumpMap;
			sampler2D _SpecularMap;
			float4 _EmissionColor;
			sampler2D _EmissionMap;

			float _NormalScale;
			float _Smoothness;
			float _BlendNormals;
			float _ClipNormals;

			sampler2D_float _CameraDepthTexture;
			sampler2D _NormalsCopy;
			sampler2D _CameraTargetCopy;
			sampler2D_float _ExclusionMask;
			#include "DecalMain.cginc"

			v2f vert (appdata v)
			{
				v2f o = vertDecal(v);
				return o;
			}
			
			void frag(v2f i, out float4 outDiffuse : COLOR0, out float4 outNormal : COLOR1, out float4 outEmission : COLOR2)
			{
				UNITY_SETUP_INSTANCE_ID(i);
				float4 uvInstanced = UNITY_ACCESS_INSTANCED_PROP(DecalProps, _UV);
				#if PREVIEWCAMERA
					float4 diffusePreview = tex2D (_MainTex, i.uv);
					float4 colPreview = diffusePreview * _Color;
					outDiffuse = colPreview;
					return;
				#endif
				
				float3 wpos;
				bool needCull;
				float4 meshUVAndScreenUV = fragDecalUV(i, wpos, needCull);

				outDiffuse = 0;
				outNormal = 0;
				outEmission = 0;
	
				#if EXCLUSIONMASK
					if(needCull)
						return;
				#endif

				float2 uv = meshUVAndScreenUV.zw;
				float2 meshUV = meshUVAndScreenUV.xy;

				i.uv = meshUV * _MainTex_ST.xy * (uvInstanced.xy * _NotInstancedUV.xy) + _MainTex_ST.zw + uvInstanced.zw + _NotInstancedUV.zw;
				
				float3 normal = tex2D(_NormalsCopy, uv).rgb;
				float3 wnormal = normal.rgb * 2.0 - 1.0;
				float blendByNormal = 1;

				#if NORMAL_CLIP
					clip (dot(wnormal, i.orientation) - _ClipNormals);
				#else
					float dotResult = dot(wnormal, i.orientation);
					blendByNormal = smoothstep(0, _ClipNormals, dotResult);
				#endif
				
				float4 diffuse = tex2D (_MainTex, i.uv);
				float4 col = diffuse * _Color * _NotInstancedColor;
				col.a *= blendByNormal;
				col *= UNITY_ACCESS_INSTANCED_PROP(DecalProps, _Tint);
				
				float blendTerrains = 1;
				#if TERRAIN_DECAL && !NO_TERRAIN
					blendTerrains = GetTerrainBlending(wpos);
					col.a *= blendTerrains;
				#endif
				outDiffuse = col;
				
				float3 nor = UnpackScaleNormal(tex2D(_BumpMap, i.uv), _NormalScale);
				float3x3 norMat = float3x3(i.orientationX, i.orientationZ, i.orientation);
				nor = mul (nor, norMat);
				float4 normalResult;
				normalResult.xyz = lerp(nor, wnormal + nor, 1 - _BlendNormals);
				normalResult.xyz = normalize(normalResult.xyz);

				float normalBlendFactor;

				#if NORMAL_EDGE_BLENDING
					#if NORMAL_MASK
						normalBlendFactor = diffuse.a;
					#else
						float dist = distance(meshUV, float2(.5, .5)) * 2;
						dist = pow(dist, 3);
						dist = clamp(dist, 0, 1);
						normalBlendFactor = (1 - dist);
					#endif
				#else
					normalBlendFactor = (_BlendNormals) * col.a;
				#endif

				normalResult = float4(normalResult.xyz * 0.5f + 0.5f, normalBlendFactor);

				float3 shColor = ShadeSH9(float4(normalResult.xyz, 1));

				//float4 currentLighting = tex2D(_CameraTargetCopy, uv);

				col.rgb = shColor.rgb * col.rgb;

				#ifndef UNITY_HDR_ON
					col.rgb = exp2(-col.rgb);
				#endif
				
				outEmission = float4(col.rgb + (tex2D (_EmissionMap, i.uv) * _EmissionColor).rgb * col.a, col.a);

				outNormal = normalResult;
			}
			ENDCG
		}
		
		Pass// Editor Only - SELECTION
		{
			Fog { Mode Off } // no fog in g-buffers pass
			Cull Front
			ZTest Greater
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers nomrt
			#pragma multi_compile __ TERRAIN_DECAL
			#pragma multi_compile __ MULTI_TERRAIN_DECAL
			#pragma multi_compile __ NORMAL_EDGE_BLENDING
			#pragma multi_compile __ NORMAL_MASK
			
			#include "UnityCG.cginc"
			#if TERRAIN_DECAL && !NO_TERRAIN
				#include "TerrainDecals.cginc"
			#endif
			#include "UnityStandardUtils.cginc"
			
			#include "AutoLight.cginc"
			#include "UnityPBSLighting.cginc"

			struct appdata
			{
				float3 vertex : POSITION;
			#if UNITY_VERSION >= 550
				UNITY_VERTEX_INPUT_INSTANCE_ID
			#else
				UNITY_VERTEX_INPUT_INSTANCE_ID
			#endif
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
				float4 screenUV : TEXCOORD1;
				float3 ray : TEXCOORD2;
				half3 orientation : TEXCOORD3;
				half3 orientationX : TEXCOORD4;
				half3 orientationZ : TEXCOORD5;
				float3 worldScale  : TEXCOORD6;
			};
			
			sampler2D _MainTex;
			sampler2D _BumpMap;
			float4 _MainTex_ST;
			float4 _Color;
			float4 _NotInstancedColor;
			float4 _NotInstancedUV;
			float _NormalScale;
			sampler2D _BaseColorCopy;

			sampler2D_float _CameraDepthTexture;
			sampler2D_float _ExclusionMask;
			sampler2D _NormalsCopy;

			float SelectionTime;

			#include "DecalMain.cginc"
			
			v2f vert (appdata v)
			{
				v2f o = vertDecal(v);
				o.worldScale = float3(
					length(float3(unity_ObjectToWorld[0].x, unity_ObjectToWorld[1].x, unity_ObjectToWorld[2].x)), // scale x axis
					length(float3(unity_ObjectToWorld[0].y, unity_ObjectToWorld[1].y, unity_ObjectToWorld[2].y)), // scale y axis
					length(float3(unity_ObjectToWorld[0].z, unity_ObjectToWorld[1].z, unity_ObjectToWorld[2].z))  // scale z axis
				);
				return o;
			}

			float GetAlphaInPixel(float2 uv, float2 deltaUV)
			{
				if(_Color.a > 0)
				{
					fixed4 col10 = tex2D (_MainTex, clamp(uv + deltaUV, float2(0,0), _MainTex_ST.xy + _MainTex_ST.zw)) * _Color * _NotInstancedColor;

					return col10.a;
				} else
				{
					fixed4 col10 = tex2D (_MainTex, clamp(uv + deltaUV, float2(0,0), _MainTex_ST.xy + _MainTex_ST.zw));

					return 1 - col10.a;
				}
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
			
			// return value is emission
			float4 frag(v2f i) : SV_TARGET
			{
				float3 wpos;
				float4 meshUVAndScreenUV = fragDecalUV(i, wpos);
				float2 uv = meshUVAndScreenUV.zw;
				float2 meshUV = meshUVAndScreenUV.xy;
				i.uv = meshUV * _MainTex_ST.xy * _NotInstancedUV.xy + _MainTex_ST.zw + _NotInstancedUV.zw;
				float notLinearDepth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv);

				half3 normal = tex2D(_NormalsCopy, uv).rgb;
				fixed3 wnormal = normal.rgb * 2.0 - 1.0;
				clip (dot(wnormal, i.orientation) - 0.1);
				
				fixed4 diffuse = tex2D (_MainTex, i.uv);
				fixed4 col = diffuse * _Color * _NotInstancedColor;
				float blendTerrains = 1;
				#if TERRAIN_DECAL && !NO_TERRAIN
					blendTerrains = GetTerrainBlending(wpos);
					col.a *= blendTerrains;
				#endif
				
				fixed4 currentEmission = tex2D(_BaseColorCopy, uv);

				float4 selectionColor = float4(0,0,0,0);
				float scaleLength = length(i.worldScale.xz);
				scaleLength *= scaleLength;

				float alpha = 1;
				#if NORMAL_EDGE_BLENDING
					#if NORMAL_MASK
						alpha = diffuse.a;
					#else
						float3 nor = UnpackScaleNormal(tex2D(_BumpMap, i.uv), _NormalScale);
						float3x3 norMat = float3x3(i.orientationX, i.orientationZ, i.orientation);
						//nor = mul (nor, norMat);
						alpha = 1 - dot(nor, float3(0.5, 0.5, 1));
						alpha = clamp(alpha, 0, 1);
						/*float dist = distance(meshUV, float2(.5, .5)) * 2;
						dist = pow(dist, 3);
						dist = clamp(dist, 0, 1);
						alpha = (1 - dist) * 0.01;*/
					#endif
				#else
					alpha = col.a;
				#endif

				selectionColor = CalcSelectionColor(i.uv, alpha, float2(0.0002 / notLinearDepth / scaleLength, 0.0002 / notLinearDepth / scaleLength)) * 2 * SelectionTime;
				//return selectionColor;

				return float4(selectionColor.rgb, diffuse.a * SelectionTime * selectionColor.a);
			}
			ENDCG
		}		
		
		Pass // before lighting (spec blend)
		{
			Fog { Mode Off }
			Cull Front
			ZTest Greater
			ZWrite Off
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			#pragma target 3.0
			#pragma vertex vert
			#pragma fragment frag
			#pragma exclude_renderers nomrt
			#pragma multi_compile __ NO_TERRAIN
			#pragma multi_compile __ EXCLUSIONMASK
			#pragma multi_compile __ NOEXCLUSIONMASK
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

			struct appdata
			{
				float3 vertex : POSITION;
			#if UNITY_VERSION >= 550
				UNITY_VERTEX_INPUT_INSTANCE_ID
			#else
				UNITY_VERTEX_INPUT_INSTANCE_ID
			#endif
			};

			UNITY_INSTANCING_BUFFER_START(DecalProps)
				UNITY_DEFINE_INSTANCED_PROP(float4, _Tint)
				UNITY_DEFINE_INSTANCED_PROP(float4, _UV)
			UNITY_INSTANCING_BUFFER_END(DecalProps)

			struct v2f
			{
				float4 pos : SV_POSITION;
				half2 uv : TEXCOORD0;
				float4 screenUV : TEXCOORD1;
				float3 ray : TEXCOORD2;
				half3 orientation : TEXCOORD3;
				half3 orientationX : TEXCOORD4;
				half3 orientationZ : TEXCOORD5;
				UNITY_VERTEX_INPUT_INSTANCE_ID
			};

			sampler2D _MainTex;
			float4 _MainTex_ST;
			float4 _Color;
			float4 _NotInstancedColor;
			float4 _NotInstancedUV;
			sampler2D _SpecularMap;
			float _ClipNormals;
			float _BlendNormals;

			float _Smoothness;

			sampler2D_float _CameraDepthTexture;
			sampler2D_float _ExclusionMask;
			sampler2D _NormalsCopy;
			sampler2D _SpecRoughnessCopy;
			#include "DecalMain.cginc"

			v2f vert (appdata v)
			{
				v2f o = vertDecal(v);
				return o;
			}
			
			void frag(v2f i, out float4 outSpecular : COLOR0, out float4 outSmoothness : COLOR1)
			{
				UNITY_SETUP_INSTANCE_ID(i);

				bool needCull;
				
				float3 wpos;
				float4 meshUVAndScreenUV = fragDecalUV(i, wpos, needCull);
				float2 uv = meshUVAndScreenUV.zw;

				outSpecular = 0;
				outSmoothness = 0;
	
				#if EXCLUSIONMASK
					if(needCull)
						return;
				#endif

				float2 meshUV = meshUVAndScreenUV.xy;
				float4 uvInstanced = UNITY_ACCESS_INSTANCED_PROP(DecalProps, _UV);
				i.uv = meshUV * _MainTex_ST.xy * (uvInstanced.xy * _NotInstancedUV.xy) + _MainTex_ST.zw + uvInstanced.zw + _NotInstancedUV.zw;

				float3 normal = tex2D(_NormalsCopy, uv).rgb;
				float3 wnormal = normal.rgb * 2.0 - 1.0;
				float blendByNormal = 1;
				#if NORMAL_CLIP
					clip (dot(wnormal, i.orientation) - _ClipNormals);
				#else
					float dotResult = dot(wnormal, i.orientation);
					blendByNormal = smoothstep(0, _ClipNormals, dotResult);
				#endif
				
				float4 diffuse = tex2D (_MainTex, i.uv);
				float4 col = diffuse * _Color * _NotInstancedColor;
				col.a *= blendByNormal;
				col *= UNITY_ACCESS_INSTANCED_PROP(DecalProps, _Tint);
				float blendTerrains = 1;
				#if TERRAIN_DECAL && !NO_TERRAIN
					blendTerrains = GetTerrainBlending(wpos);
					col.a *= blendTerrains;
				#endif
				
				float normalBlendFactor;

				#if NORMAL_EDGE_BLENDING
					#if NORMAL_MASK
						normalBlendFactor = diffuse.a;
					#else
						float dist = distance(meshUV, float2(.5, .5)) * 2;
						dist = pow(dist, 3);
						dist = clamp(dist, 0, 1);
						normalBlendFactor = (1 - dist);
					#endif
				#else
					normalBlendFactor = (_BlendNormals) * col.a;
				#endif
				
				float4 currentSpecRoughness = tex2D(_SpecRoughnessCopy, uv);
				float4 spec = tex2D (_SpecularMap, i.uv);
				spec.a *= _Smoothness * normalBlendFactor;

				outSpecular = float4(spec.rgb, normalBlendFactor);
				outSmoothness = float4(spec.a, 0, 0, normalBlendFactor);
			}
			ENDCG
		}
	}

	Fallback Off
}
