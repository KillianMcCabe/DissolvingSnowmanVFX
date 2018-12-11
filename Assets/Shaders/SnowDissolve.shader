
Shader "Killian/Dissolve" 
{
	Properties 
	{
		_MainTex ("Diffuse (RGBA)", 2D) = "white"{}
		_NoiseTex ("Burn Map (RGB)", 2D) = "black"{}
		_DissolveValue ("Value", Range(0,1)) = 1.0
	}
	SubShader 
	{
		Tags {"Queue" = "Transparent"}
		
		Pass
		{
			Blend SrcAlpha OneMinusSrcAlpha
			Cull back
			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			sampler2D _MainTex;
			sampler2D _NoiseTex;
			fixed _DissolveValue;
			
			struct vIN
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};
			
			struct vOUT
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
			};
			
			vOUT vert(vIN v)
			{
				vOUT o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				return o;
			}
			
			fixed4 frag(vOUT i) : COLOR
			{
				fixed4 mainTex = tex2D(_MainTex, i.uv);
				fixed noiseVal = tex2D(_NoiseTex, i.uv).r;
				mainTex.a *= floor(_DissolveValue + noiseVal.r);
				//mainTex.a *= floor(_DissolveValue + min(0.99, noiseVal.r));
				return mainTex;
			}
			
			ENDCG
		}
	} 
}