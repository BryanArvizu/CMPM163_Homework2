// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "Custom/BA_Outline"
{
    Properties
    {
		_Stroke("Stroke", Float) = 1.0
		_Color1 ("Main Color", Color) = (1,1,1,1)
        _Color2 ("Stroke Color", Color) = (0,0,0,1)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

        Pass
        {
			Cull Front

            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            // make fog work
            #pragma multi_compile_fog

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
				float4 normal : NORMAL;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
				float4 normal : NORMAL;
            };

			float _Stroke;
			float4 _Color2;

            v2f vert (appdata v)
            {
				v2f o;
				o.vertex.xyz = (v.vertex.xyz*(_Stroke+1)*2) + (v.normal.xyz*_Stroke);
				o.vertex = UnityObjectToClipPos(o.vertex);
				o.normal = UnityObjectToClipPos(-1 * v.normal);
				
				o.uv = v.uv;

				return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                return _Color2;
            }
            ENDCG
        }

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			float4 _Color1;

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return _Color1;
			}
		ENDCG
	}/**/
    }
}
