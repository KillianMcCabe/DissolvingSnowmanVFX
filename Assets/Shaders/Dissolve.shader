
Shader "Killian/Dissolve" 
{
	Properties 
	{
		_MainTex ("Diffuse (RGBA)", 2D) = "white"{}
		_DissolveMap ("Dissolve Map (RGB)", 2D) = "black"{}
		_DissolveValue ("Value", Range(0, 1)) = 1.0
		_DissolveThreshold ("Dissolve Threshold", Range(0.1, 1.0)) = 0.0
		_OutlineColor ("Outline Color", Color) = (1,1,1,1)
		_OutlineSize ("Outline Size", Range(0.01, 1.0)) = 0.0
	}

	CGINCLUDE

    #include "UnityCG.cginc"

	sampler2D _MainTex;
	// fixed4 _Color;
	sampler2D _DissolveMap;
	float _DissolveValue;
	float _DissolveThreshold;
	fixed4 _OutlineColor;
	float _OutlineSize;
	
    struct vIN
	{
		float4 vertex : POSITION;
		float2 texcoord : TEXCOORD0;
		float2 texcoord1 : TEXCOORD1;
	};
	
	struct vOUT
	{
		float4 pos : SV_POSITION;
		float2 uv : TEXCOORD0;
		float2 uv1 : TEXCOORD1;
		float3 objectPos : TEXCOORD3;
	};

	vOUT vert(vIN v)
	{
		vOUT o;
		o.pos = UnityObjectToClipPos(v.vertex);
		o.uv = v.texcoord;
		o.uv1 = v.texcoord1;
		o.objectPos = v.vertex.xyz;
		return o;
	}
	
	fixed4 frag(vOUT i) : COLOR
	{
		// read colour from main texture
		fixed4 mainTex = tex2D(_MainTex, i.uv1);
		fixed4 col = mainTex;

		// calculate dissolve value

		fixed max_yPos = 3;
		fixed max_DissolveValue = 1;
		fixed max_noiseVal = 1;

		fixed dissolveTextureVal = tex2D(_DissolveMap, i.uv).r;

		// _DissolveValue = (_DissolveValue * (i.objectPos.y + 0.5)) / (max_yPos); // without dissolve map
		// _DissolveValue = (_DissolveValue * (i.objectPos.y + dissolveTextureVal + 0.5)) / (max_yPos + max_noiseVal);
		_DissolveValue = (_DissolveValue * (i.objectPos.y + dissolveTextureVal + 1)) / (max_yPos + max_noiseVal + 4);

		_DissolveValue = saturate(_DissolveValue); // clamps value between 0 and 1

		if ( _DissolveValue < _DissolveThreshold) {
			col.a = 0; // mesh is dissolved - alpha 0
		} else if ( _DissolveValue < _DissolveThreshold + _OutlineSize) {
			col = _OutlineColor; // show dissolve outline
		}

		return col;
	}

    ENDCG

	SubShader 
	{
		Tags
		{
			"RenderType"="Transparent"
			"Queue"="Transparent"
		}

		// render back faces
		Pass
		{
			Cull Front
			ZWrite On
			ZTest LEqual
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag

			ENDCG
		}

		// render front faces
		Pass
		{
			Cull Back
			ZWrite On
			ZTest LEqual
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag

			ENDCG
		}
	} 
}