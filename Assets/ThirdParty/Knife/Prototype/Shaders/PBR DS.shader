// Made with Amplify Shader Editor
// Available at the Unity Asset Store - http://u3d.as/y3X 
Shader "Knife/PBR DS"
{
	Properties
	{
		_Tint("Tint", Color) = (1,1,1,1)
		_MainTex("Albedo", 2D) = "white" {}
		_Specular("Specular", 2D) = "black" {}
		_Smoothness("Smoothness", Range( 0 , 1)) = 0.5
		_NormalMap("NormalMap", 2D) = "bump" {}
		_NormalScale("NormalScale", Float) = 1
		[HideInInspector] _texcoord( "", 2D ) = "white" {}
		[HideInInspector] __dirty( "", Int ) = 1
	}

	SubShader
	{
		Tags{ "RenderType" = "Opaque"  "Queue" = "Geometry+0" }
		Cull Off
		CGPROGRAM
		#include "UnityStandardUtils.cginc"
		#pragma target 3.0
		#pragma surface surf StandardSpecular keepalpha addshadow fullforwardshadows 
		struct Input
		{
			half ASEVFace : VFACE;
			float2 uv_texcoord;
		};

		uniform float _NormalScale;
		uniform sampler2D _NormalMap;
		uniform float4 _NormalMap_ST;
		uniform float4 _Tint;
		uniform sampler2D _MainTex;
		uniform float4 _MainTex_ST;
		uniform sampler2D _Specular;
		uniform float4 _Specular_ST;
		uniform float _Smoothness;

		void surf( Input i , inout SurfaceOutputStandardSpecular o )
		{
			float Face0114 = (0.0 + (i.ASEVFace - -1.0) * (1.0 - 0.0) / (1.0 - -1.0));
			float lerpResult16 = lerp( 0.0 , _NormalScale , Face0114);
			float2 uv_NormalMap = i.uv_texcoord * _NormalMap_ST.xy + _NormalMap_ST.zw;
			o.Normal = UnpackScaleNormal( tex2D( _NormalMap, uv_NormalMap ), lerpResult16 );
			float2 uv_MainTex = i.uv_texcoord * _MainTex_ST.xy + _MainTex_ST.zw;
			float4 lerpResult18 = lerp( float4( 0,0,0,0 ) , ( _Tint * tex2D( _MainTex, uv_MainTex ) ) , Face0114);
			o.Albedo = lerpResult18.rgb;
			float2 uv_Specular = i.uv_texcoord * _Specular_ST.xy + _Specular_ST.zw;
			float4 tex2DNode3 = tex2D( _Specular, uv_Specular );
			float4 lerpResult20 = lerp( float4( 0,0,0,0 ) , tex2DNode3 , Face0114);
			o.Specular = lerpResult20.rgb;
			float lerpResult22 = lerp( 0.0 , ( tex2DNode3.a * _Smoothness ) , Face0114);
			o.Smoothness = lerpResult22;
			o.Alpha = 1;
		}

		ENDCG
	}
	Fallback "Diffuse"
	CustomEditor "ASEMaterialInspector"
}
/*ASEBEGIN
Version=16700
-1858;1;1842;1010;1163.792;346.812;1;True;False
Node;AmplifyShaderEditor.FaceVariableNode;12;-1132.556,596.416;Float;False;0;1;FLOAT;0
Node;AmplifyShaderEditor.TFHCRemapNode;13;-958.5563,642.416;Float;False;5;0;FLOAT;0;False;1;FLOAT;-1;False;2;FLOAT;1;False;3;FLOAT;0;False;4;FLOAT;1;False;1;FLOAT;0
Node;AmplifyShaderEditor.RegisterLocalVarNode;14;-727.1096,680.7584;Float;False;Face01;-1;True;1;0;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.ColorNode;6;-520,-353.5;Float;False;Property;_Tint;Tint;0;0;Create;True;0;0;False;0;1,1,1,1;1,1,1,1;True;0;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;3;-522,250.5;Float;True;Property;_Specular;Specular;2;0;Create;True;0;0;False;0;None;7d6ecf56f69921144baf9ddc392118de;True;0;False;black;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.SamplerNode;1;-604,-188.5;Float;True;Property;_MainTex;Albedo;1;0;Create;False;0;0;False;0;None;0eb98c8528fcd3e43804e9d07b52a0c4;True;0;False;white;Auto;False;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;COLOR;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.GetLocalVarNode;17;-991.7922,235.188;Float;False;14;Face01;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;5;-1000,109.5;Float;False;Property;_NormalScale;NormalScale;5;0;Create;True;0;0;False;0;1;1;0;0;0;1;FLOAT;0
Node;AmplifyShaderEditor.RangedFloatNode;7;-372,478.5;Float;False;Property;_Smoothness;Smoothness;3;0;Create;True;0;0;False;0;0.5;0.665;0;1;0;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;16;-786.7922,113.188;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;21;-29.29221,194.1881;Float;False;14;Face01;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.GetLocalVarNode;19;-130.2922,-59.81195;Float;False;14;Face01;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;8;-73,335.5;Float;False;2;2;0;FLOAT;0;False;1;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.SimpleMultiplyOpNode;10;-253,-269.5;Float;False;2;2;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;1;COLOR;0
Node;AmplifyShaderEditor.GetLocalVarNode;23;-48.29222,532.188;Float;False;14;Face01;1;0;OBJECT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;22;156.7078,410.188;Float;False;3;0;FLOAT;0;False;1;FLOAT;0;False;2;FLOAT;0;False;1;FLOAT;0
Node;AmplifyShaderEditor.LerpOp;20;175.7078,72.18805;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.SamplerNode;2;-612,14.5;Float;True;Property;_NormalMap;NormalMap;4;0;Create;True;0;0;False;0;None;7cb2bb30503618e4eae978c13117e888;True;0;True;bump;Auto;True;Object;-1;Auto;Texture2D;6;0;SAMPLER2D;;False;1;FLOAT2;0,0;False;2;FLOAT;0;False;3;FLOAT2;0,0;False;4;FLOAT2;0,0;False;5;FLOAT;1;False;5;FLOAT3;0;FLOAT;1;FLOAT;2;FLOAT;3;FLOAT;4
Node;AmplifyShaderEditor.LerpOp;18;74.70776,-181.812;Float;False;3;0;COLOR;0,0,0,0;False;1;COLOR;0,0,0,0;False;2;FLOAT;0;False;1;COLOR;0
Node;AmplifyShaderEditor.StandardSurfaceOutputNode;0;361,-44;Float;False;True;2;Float;ASEMaterialInspector;0;0;StandardSpecular;Knife/PBR DS;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;False;Off;0;False;-1;0;False;-1;False;0;False;-1;0;False;-1;False;0;Opaque;0.5;True;True;0;False;Opaque;;Geometry;All;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;True;0;False;-1;False;0;False;-1;255;False;-1;255;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;-1;False;2;15;10;25;False;0.5;True;0;0;False;-1;0;False;-1;0;0;False;-1;0;False;-1;0;False;-1;0;False;-1;0;False;0;0,0,0,0;VertexOffset;True;False;Cylindrical;False;Relative;0;;-1;-1;-1;-1;0;False;0;0;False;-1;-1;0;False;-1;0;0;0;False;0.1;False;-1;0;False;-1;16;0;FLOAT3;0,0,0;False;1;FLOAT3;0,0,0;False;2;FLOAT3;0,0,0;False;3;FLOAT3;0,0,0;False;4;FLOAT;0;False;5;FLOAT;0;False;6;FLOAT3;0,0,0;False;7;FLOAT3;0,0,0;False;8;FLOAT;0;False;9;FLOAT;0;False;10;FLOAT;0;False;13;FLOAT3;0,0,0;False;11;FLOAT3;0,0,0;False;12;FLOAT3;0,0,0;False;14;FLOAT4;0,0,0,0;False;15;FLOAT3;0,0,0;False;0
WireConnection;13;0;12;0
WireConnection;14;0;13;0
WireConnection;16;1;5;0
WireConnection;16;2;17;0
WireConnection;8;0;3;4
WireConnection;8;1;7;0
WireConnection;10;0;6;0
WireConnection;10;1;1;0
WireConnection;22;1;8;0
WireConnection;22;2;23;0
WireConnection;20;1;3;0
WireConnection;20;2;21;0
WireConnection;2;5;16;0
WireConnection;18;1;10;0
WireConnection;18;2;19;0
WireConnection;0;0;18;0
WireConnection;0;1;2;0
WireConnection;0;3;20;0
WireConnection;0;4;22;0
ASEEND*/
//CHKSM=5167F949FEFDF7EDBB1559C95A5E8887E3D93EE9