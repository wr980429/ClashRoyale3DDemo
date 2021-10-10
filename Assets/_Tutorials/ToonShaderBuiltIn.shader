Shader "91make.top/ToonShaderBuiltIn"
{
    Properties // 让美工去调节
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Brightness("Brightness", Range(0,1)) = 0.3
        _Strength("Strength", Range(0,1)) = 0.5
        _Color("Color", COLOR) = (1,1,1,1)
        _Detail("Detail", Range(0,1)) = 0.3
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

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                float3 normal : NORMAL;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
                half3 worldNormal : TEXCOORD1;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;
            float _Brightness;
            float _Strength;
            float4 _Color;
            float _Detail;

            float Toon(float3 normal, float lightDir)
            {
                float f = max(0.0, dot(normalize(normal), normalize(lightDir)));
                return floor(f/_Detail);
            }

            v2f vert (appdata v)
            {
                v2f o;
                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.worldNormal = UnityObjectToClipPos(v.normal);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                col *= Toon(i.worldNormal, _WorldSpaceLightPos0.xyz)*_Strength*_Color+_Brightness;
                return col;
            }
            ENDCG
        }
        Pass 
        { 
            Name "PlanarShadow"
            //ptags
            //states|oldstates
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            
            #include "UnityCG.cginc"
            #include "Lighting.cginc"
            #include "AutoLight.cginc"
            
            struct appdata
            {
                float4 vertex : POSITION;
            };
            
            struct v2f
            {
                float4 vertex : SV_POSITION;
            };
            
            v2f vert (appdata v) // appdata_base | appdata_tan | appdata_full
            {
                v2f o;
                float4 vWorld = mul(unity_ObjectToWorld, v.vertex);
                vWorld.y = 1;
                o.vertex = mul(unity_MatrixVP, vWorld);
                return o;
            }
            
            fixed4 frag (v2f i) : SV_Target
            {
                // 对纹理进行采样
                return 0;
            }
            ENDCG
            
        }
    }
}
