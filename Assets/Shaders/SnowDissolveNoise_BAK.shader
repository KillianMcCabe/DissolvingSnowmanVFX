// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Killian/DissolveNoise" 
{
	Properties 
	{
		_Color ("Base Color", Color) = (1,1,1,1)
		_BurnGradient("Burn Gradient (RGB)", 2D) = "white"{}
		_DissolveMap ("Dissolve Map (RGB)", 2D) = "black"{}
		_DissolveValue ("Value", Range(0,1)) = 1.0
		_GradientAdjust ("Gradient", Range(0.1,10.0)) = 10.0
	}
	SubShader 
	{
		Tags
		{
			"RenderType"="Transparent"
			"Queue"="Transparent"
		}

		Pass
		{
			Cull Front
			ZWrite On
			ZTest LEqual
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			fixed4 _Color;
			sampler2D _BurnGradient;
			sampler2D _DissolveMap;
			float _DissolveValue;
			float _GradientAdjust;
			
			struct vIN
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};
			
			struct vOUT
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 objectPos : TEXCOORD3;
			};
			
			vOUT vert(vIN v)
			{
				vOUT o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				o.objectPos = v.vertex.xyz;
				return o;
			}
			
			fixed4 frag(vOUT i) : COLOR
			{
				fixed4 col = _Color;
				fixed noiseVal = tex2D(_DissolveMap, i.uv).r;
				
				// _DissolveValue += noiseVal + abs(i.objectPos.y);
				// _DissolveValue = _DissolveValue / 3;

				_DissolveValue += abs(i.objectPos.y) - (0.5 + _GradientAdjust);
				_DissolveValue = _DissolveValue / 2;

				fixed overOne = saturate(_DissolveValue * _GradientAdjust); // clamps value between 0 and 1

				fixed4 burn = tex2D(_BurnGradient, float2(overOne, 0.5));

				return col * burn;
			}

			ENDCG
		}

		Pass
		{
			Cull Back
			ZWrite On
			ZTest LEqual
			Blend SrcAlpha OneMinusSrcAlpha

			CGPROGRAM
			
			#pragma vertex vert
			#pragma fragment frag
			
			fixed4 _Color;
			sampler2D _BurnGradient;
			sampler2D _DissolveMap;
			float _DissolveValue;
			float _GradientAdjust;
			
			struct vIN
			{
				float4 vertex : POSITION;
				float2 texcoord : TEXCOORD0;
			};
			
			struct vOUT
			{
				float4 pos : SV_POSITION;
				float2 uv : TEXCOORD0;
				float3 objectPos : TEXCOORD3;
			};
			
			vOUT vert(vIN v)
			{
				vOUT o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.uv = v.texcoord;
				o.objectPos = v.vertex.xyz;
				return o;
			}
			
			fixed4 frag(vOUT i) : COLOR
			{
				fixed4 col = _Color;
				fixed noiseVal = tex2D(_DissolveMap, i.uv).r;
				
				// _DissolveValue += noiseVal + abs(i.objectPos.y);
				// _DissolveValue = _DissolveValue / 3;

				_DissolveValue += abs(i.objectPos.y) - (0.5 + _GradientAdjust);
				_DissolveValue = _DissolveValue / 2;

				fixed overOne = saturate(_DissolveValue * _GradientAdjust); // clamps value between 0 and 1

				fixed4 burn = tex2D(_BurnGradient, float2(overOne, 0.5));

				return col * burn;
			}

			ENDCG
		}

		
		
		
		// Pass
		// {
		// 	Cull off
		// 	ZWrite On
		// 	ZTest LEqual
		// 	Blend SrcAlpha OneMinusSrcAlpha

		// 	CGPROGRAM
			
		// 	#pragma vertex vert
		// 	#pragma fragment frag
			
		// 	fixed4 _Color;
		// 	sampler2D _BurnGradient;
		// 	sampler2D _DissolveMap;
		// 	float _DissolveValue;
		// 	float _GradientAdjust;
			
		// 	struct vIN
		// 	{
		// 		float4 vertex : POSITION;
		// 		float2 texcoord : TEXCOORD0;
		// 	};
			
		// 	struct vOUT
		// 	{
		// 		float4 pos : SV_POSITION;
		// 		float2 uv : TEXCOORD0;
		// 		float3 objectPos : TEXCOORD3;
		// 	};
			
		// 	vOUT vert(vIN v)
		// 	{
		// 		vOUT o;
		// 		o.pos = UnityObjectToClipPos(v.vertex);
		// 		o.uv = v.texcoord;
		// 		o.objectPos = v.vertex.xyz;
		// 		return o;
		// 	}
			
		// 	fixed4 frag(vOUT i) : COLOR
		// 	{
		// 		fixed4 col = _Color;
		// 		fixed noiseVal = tex2D(_DissolveMap, i.uv).r;
				
		// 		// _DissolveValue += noiseVal + abs(i.objectPos.y);
		// 		// _DissolveValue = _DissolveValue / 3;

		// 		_DissolveValue += abs(i.objectPos.y) - (0.5 + _GradientAdjust);
		// 		_DissolveValue = _DissolveValue / 2;

		// 		fixed overOne = saturate(_DissolveValue * _GradientAdjust); // clamps value between 0 and 1

		// 		fixed4 burn = tex2D(_BurnGradient, float2(overOne, 0.5));
		// 		return col * burn;
		// 	}

		// 	ENDCG
		// }
	} 
}