
Shader "Killian/DissolveNoise" 
{
	Properties 
	{
		_MainTex ("Diffuse (RGBA)", 2D) = "white"{}
		// _Color ("Base Color", Color) = (1,1,1,1)
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
		// calculate colour

		fixed4 mainTex = tex2D(_MainTex, i.uv1);
		fixed4 col = mainTex;

		// calculate dissolve value

		fixed noiseVal = tex2D(_DissolveMap, i.uv).r;
		// _DissolveValue += noiseVal;

		// dissolve over height
		fixed max_yPos = 3;
		fixed max_DissolveValue = 1;
		fixed max_noiseVal = 1;

		// _DissolveValue = (_DissolveValue * i.objectPos.y) / (max_yPos);
		// _DissolveValue = (_DissolveValue * (i.objectPos.y + 1)) / (max_yPos + 1);
		_DissolveValue = (_DissolveValue * (i.objectPos.y + noiseVal + 0.5)) / (max_yPos + max_noiseVal);

		fixed overOne = saturate(_DissolveValue); // clamps value between 0 and 1

		if ( overOne < _DissolveThreshold) {
			col.a = 0; // mesh is disolved - alpha 0
		} else if ( overOne < _DissolveThreshold + _OutlineSize) {
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