struct TerrainData
{
	int heightmapIndex;
	float4x4 world2Terrain;
	float3 terrainSize;
};

float _TerrainClipHeight;
float _TerrainClipHeightPower;

#if MULTI_TERRAIN_DECAL
	Texture2DArray<float> _TerrainsHeightMaps;
	SamplerState sampler_TerrainsHeightMaps;
	StructuredBuffer<TerrainData> TerrainsDatas;
	int TerrainsCount;
#elif TERRAIN_DECAL
	sampler2D_float _TerrainHeightMap;
	float4x4 _World2Terrain;
	float3 _TerrainSize;
#endif

float GetTerrainBlending(float3 wpos)
{
#if MULTI_TERRAIN_DECAL
	float alpha = 1;
	for(int i = 0; i < TerrainsCount; i++)
	{
		float3 terrainPos = mul(TerrainsDatas[i].world2Terrain, float4(wpos, 1));
		float3 terrainUV = float4(terrainPos / TerrainsDatas[i].terrainSize, 1);
		if(terrainUV.x > 1 || terrainUV.x < 0 || terrainUV.z > 1 || terrainUV.z < 0)
		{
		} else
		{
			float height = _TerrainsHeightMaps.Sample(sampler_TerrainsHeightMaps, float3(terrainUV.xz, TerrainsDatas[i].heightmapIndex));

			float deltaHeight = height - wpos.y;

			float clipVal = deltaHeight + _TerrainClipHeight * TerrainsDatas[i].terrainSize.y;
		
			float blendDither = smoothstep(0, _TerrainClipHeight * TerrainsDatas[i].terrainSize.y, clipVal);

			alpha *= pow(blendDither, _TerrainClipHeightPower);
		}
	}
	
	return alpha;
#elif TERRAIN_DECAL
	float alpha = 1;
	
	float3 terrainPos = mul(_World2Terrain, float4(wpos, 1));
	float3 terrainUV = float4(terrainPos / _TerrainSize, 1);

	if(terrainUV.x > 1 || terrainUV.x < 0 || terrainUV.z > 1 || terrainUV.z < 0)
		return 1;

	float height = tex2D(_TerrainHeightMap, terrainUV.xz);
	float deltaHeight = height - wpos.y;

	float clipVal = deltaHeight + _TerrainClipHeight * _TerrainSize.y;
	
	float blendDither = smoothstep(0, _TerrainClipHeight * _TerrainSize.y, clipVal);

	alpha *= pow(blendDither, _TerrainClipHeightPower);

	return alpha;
#endif
	return 0;
}