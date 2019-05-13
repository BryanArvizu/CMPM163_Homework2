Shader "Custom/BA_HeightMap"
{
    Properties
    {
        _MainTex ("Main Texture", 2D) = "white" {}
		_SecTex ("Secondary Texture", 2D) = "brown" {}
		_HeightMap("Height Map", 2D) = "white" {}
		_Amplitude("Amplitude", float) = 0
		_SeaLevel("Sea Level", float) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        LOD 100

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
                float4 vertex : SV_POSITION;
				float4 vertexWorld : TEXCOORD1;
            };

            sampler2D _MainTex;
			float4 _MainTex_ST;
			sampler2D _SecTex;
			float4 _SecTex_ST;
			sampler2D _HeightMap;
			float _Amplitude;
			float _SeaLevel;

            v2f vert (appdata v)
            {
                v2f o;

				float4 col = tex2Dlod(_HeightMap, float4(v.uv, 0,0));

				o.vertexWorld = mul(unity_ObjectToWorld, v.vertex + float4(0, col.r * _Amplitude, 0, 0));

                o.vertex = mul(UNITY_MATRIX_VP, o.vertexWorld);
				
				o.uv = v.uv;
				
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
				fixed4 col;
				if (i.vertexWorld.y > _SeaLevel)
					col = tex2D(_MainTex, i.uv*_MainTex_ST.x);
				else
					col = tex2D(_SecTex, i.uv*_SecTex_ST.x);
                return col;
            }
            ENDCG
        }
    }
}
