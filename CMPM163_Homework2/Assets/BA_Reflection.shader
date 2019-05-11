Shader "Custom/BA_Reflection" {
    Properties {
      
      _Cube ("Cubemap", CUBE) = "" {}
	  _Tint("Tint", Color) = (0,0,0,0)
	  _Intensity("Tint Intensity", Range(0,1)) = 0.5
	  _Reflectiveness("Reflectiveness", Range(0,1)) = 0.5
	  _Opacity("Opacity", Range(0,1)) = 1
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
                float3 normalInWorldCoords : NORMAL;
                float3 vertexInWorldCoords : TEXCOORD1;
            };

            v2f vert (appdata v)
            {
                v2f o;
                
                o.vertexInWorldCoords = mul(unity_ObjectToWorld, v.vertex); //Vertex position in WORLD coords
                o.normalInWorldCoords = UnityObjectToWorldNormal(v.normal); //Normal 
                
                o.vertex = UnityObjectToClipPos(v.vertex);
                
                return o;
            }
            
            samplerCUBE _Cube;
			float4 _Tint;
			float _Intensity;
			float _Reflectiveness;
			float _Opacity;
            
            fixed4 frag (v2f i) : SV_Target
            {
            
             float3 P = i.vertexInWorldCoords.xyz;
             
             //get normalized incident ray (from camera to vertex)
             float3 vIncident = normalize(P - _WorldSpaceCameraPos);
             
             //reflect that ray around the normal using built-in HLSL command
             float3 vReflect = reflect( vIncident, i.normalInWorldCoords ); 
             
             //use the reflect ray to sample the skybox
             float4 reflectColor = texCUBE( _Cube, vReflect ) * _Reflectiveness;
             
			 float4 col; // = lerp(reflectColor, _Tint, _Intensity);
			 col.r = lerp(reflectColor.r, 1, _Tint.r*_Intensity);
			 col.g = lerp(reflectColor.g, 1, _Tint.g*_Intensity);
			 col.b = lerp(reflectColor.b, 1, _Tint.b*_Intensity);

             return float4(col.rgb, _Opacity);
                
                
            }
      
            ENDCG
        }
    }

    
    
    Fallback "Diffuse"
  }
