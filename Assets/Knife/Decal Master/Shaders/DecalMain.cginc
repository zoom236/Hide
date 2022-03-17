v2f vertDecal (appdata v)
{
	v2f o;
	UNITY_SETUP_INSTANCE_ID(v);
	UNITY_TRANSFER_INSTANCE_ID(v, o);
	o.pos = UnityObjectToClipPos (float4(v.vertex,1));
	#if PREVIEWCAMERA
		o.uv = TRANSFORM_TEX(float4(v.uv, 0, 0), _MainTex);
		o.screenUV = 0;
		o.ray = 0;
		o.orientation = 0;
		o.orientationX = 0;
		o.orientationZ = 0;
		o.orientation = 0;
		o.orientationX = 0;
		o.orientationZ = 0;
	#else
		o.uv = v.vertex.xz+0.5;
		o.screenUV = ComputeScreenPos (o.pos);
		o.ray = mul (UNITY_MATRIX_MV, float4(v.vertex,1)).xyz * float3(-1,-1,1);
		o.orientation = mul ((float3x3)unity_ObjectToWorld, float3(0,1,0));
		o.orientationX = mul ((float3x3)unity_ObjectToWorld, float3(1,0,0));
		o.orientationZ = mul ((float3x3)unity_ObjectToWorld, float3(0,0,1));
		o.orientation = normalize(o.orientation);
		o.orientationX = normalize(o.orientationX);
		o.orientationZ = normalize(o.orientationZ);
	#endif
	return o;
}

// xy - projected decal UV, zw - screen uv
float4 fragDecalUV(v2f i, out float3 wpos)
{
	i.ray = i.ray * (_ProjectionParams.z / i.ray.z);
	float2 uv = i.screenUV.xy / i.screenUV.w;
	
	float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv);
	depth = Linear01Depth (depth);
	float4 vpos = float4(i.ray * depth,1);
	wpos = mul (unity_CameraToWorld, vpos).xyz;
	float3 opos = mul (unity_WorldToObject, float4(wpos,1)).xyz;
	
	clip (float3(0.5,1,0.5) - abs(opos.xyz));

	float2 meshUV = (opos.xz+0.5);
	
	return float4(meshUV, uv);
}

// xy - projected decal UV, zw - screen uv
float4 fragDecalUV(v2f i, out float3 wpos, out bool needCull)
{
	i.ray = i.ray * (_ProjectionParams.z / i.ray.z);
	float2 uv = i.screenUV.xy / i.screenUV.w;
	
	float depth = SAMPLE_DEPTH_TEXTURE(_CameraDepthTexture, uv);
	float rawDepth = depth;
	depth = Linear01Depth (depth);
	float4 vpos = float4(i.ray * depth,1);
	wpos = mul (unity_CameraToWorld, vpos).xyz;
	float3 opos = mul (unity_WorldToObject, float4(wpos,1)).xyz;
	
	clip (float3(0.5,1,0.5) - abs(opos.xyz));

	float2 meshUV = (opos.xz+0.5);

	needCull = false;
	#if EXCLUSIONMASK && !NOEXCLUSIONMASK
		float exclusionMaskDepth = SAMPLE_DEPTH_TEXTURE(_ExclusionMask, uv);
		float delta = (rawDepth - exclusionMaskDepth);
		float threshold = 0.0001;
		needCull = abs(delta) <= threshold;
	#endif
	
	return float4(meshUV, uv);
}