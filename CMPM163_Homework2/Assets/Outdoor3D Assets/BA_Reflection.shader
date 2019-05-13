Shader "Custom/BA_Reflection" {
    Properties {
      
      _Cube ("Cubemap", CUBE) = "" {}
	  _Tint("Tint", Color) = (0,0,0,0)
	  _Intensity("Tint Intensity", Range(0,1)) = 0.5
	  _Reflectiveness("Reflectiveness", Range(0,1)) = 0.5
	  _Opacity("Opacity", Range(0,1)) = 1
	  _FresStr("Fresnel Strength", Range(0,1)) = 1
    }
     SubShader
    {
		Tags{ "RenderType" = "Transparent" "Queue" = "Transparent"}
        Pass
        {
			Blend SrcAlpha OneMinusSrcAlpha
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"
            
            struct appdata
            {
                float4 vertex : POSITION;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float4 vertex : SV_POSITION;
				float3 normal : NORMAL;
                float3 vertexInWorldCoords : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                
                o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); //Vertex position in WORLD coords
                o.vertex = UnityObjectToClipPos(v.vertex);
				o.normal = v.normal;
                
                return o;
            }
            
            samplerCUBE _Cube;
			float4 _Tint;
			float _Intensity;
			float _Reflectiveness;
			float _Opacity;
			float _FresStr;
            
            fixed4 frag (v2f i) : SV_Target
            {
            
             float3 P = i.vertexInWorldCoords.xyz;
             
             //get normalized incident ray (from camera to vertex)
             float3 vIncident = normalize(P - _WorldSpaceCameraPos);
             
             //reflect that ray around the normal using built-in HLSL command
             float3 vReflect = reflect( vIncident, i.normal ); 

			 float ndotv = dot(vIncident, i.normal);

			 float fresnel = ndotv / 2 + 1;
			 
             
             //use the reflect ray to sample the skybox
			 float4 reflectColor = texCUBE(_Cube, vReflect) * _Reflectiveness;

			 float highestRGB = max(reflectColor.r, max(reflectColor.g, reflectColor.b));

			 float4 tint = (1,1,1,1);
			 tint.rgb = lerp(float3(1, 1, 1)*highestRGB, _Tint.rgb, _Intensity);

			 float4 col = tint + reflectColor;
			 
             
			 //float4 col = (reflectColor * _Reflectiveness) + (_Tint * _Intensity * (1-_Reflectiveness));
			 col.a = _Opacity * lerp(fresnel, 1, 1-_FresStr);

			 return col;
                
                
            }
      
            ENDCG
        }
    }

    
    
    Fallback "Diffuse"
  }
