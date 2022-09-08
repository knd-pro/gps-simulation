Shader "Test/EarthShader"
{
	Properties
	{
		_Color("Color", Color) = (1,1,1,1)
		_BaseMap("Earth Map", CUBE) = "white" {}

		_NormalMap("Normal Map", 2D) = "white" {}

		_OceanMask("Ocean Mask", 2D) = "white" {}

		// Ambient light is applied uniformly to all surfaces on the object.
		[HDR]
		_AmbientColor("Ambient Color", Color) = (0.4,0.4,0.4,1)
		[HDR]
		_SpecularColor("Specular Color", Color) = (0.9,0.9,0.9,1)
		// Controls the size of the specular reflection.
		_Glossiness("Glossiness", Float) = 3
	}

	SubShader
	{
		Pass
		{
			// Setup our pass to use Forward rendering, and only receive
			// data on the main directional light and ambient light.
			Tags
			{
				"LightMode" = "ForwardBase"
				"PassFlags" = "OnlyDirectional"
			}

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// Compile multiple versions of this shader depending on lighting settings.
			#pragma multi_compile_fwdbase

			#include "UnityCG.cginc"
			// Files below include macros and functions to assist
			// with lighting and shadows.
			#include "Lighting.cginc"
			#include "AutoLight.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float4 uv : TEXCOORD0;
				float3 normal : NORMAL;
				float4 tangent : TANGENT;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
				float3 normal : NORMAL;
				float2 uv : TEXCOORD0;
				float3 viewDir : TEXCOORD1;
				// Macro found in Autolight.cginc. Declares a vector4
				// into the TEXCOORD2 semantic with varying precision 
				// depending on platform target.
				SHADOW_COORDS(2)

				float3 normalWorld: TEXCOORD3;
				float3 tangentWorld: TEXCOORD4;
				float3 binormalWorld: TEXCOORD5;
			};

			samplerCUBE _BaseMap;
			float4 _BaseMap_ST;

			sampler2D _NormalMap;
			float4 _NormalMap_ST;

			sampler2D _OceanMask;

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				o.viewDir = WorldSpaceViewDir(v.vertex);
				o.normal = v.normal;
				o.uv = TRANSFORM_TEX(v.uv, _BaseMap);
				// Defined in Autolight.cginc. Assigns the above shadow coordinate
				// by transforming the vertex from world space to shadow-map space.

				float4x4 modelMatrix = unity_ObjectToWorld;
				float4x4 modelMatrixInverse = unity_WorldToObject;

				o.tangentWorld = normalize(
					mul(modelMatrix, float4(v.tangent.xyz, 0.0)).xyz);
				o.normalWorld = normalize(
					mul(float4(v.normal, 0.0), modelMatrixInverse).xyz);
				o.binormalWorld = normalize(
					cross(o.normalWorld, o.tangentWorld)
					* v.tangent.w); // tangent.w is specific to Unity

				TRANSFER_SHADOW(o)
				return o;
			}

			float4 _Color;
			float4 _AmbientColor;
			float4 _SpecularColor;
			float _Glossiness;
			half4 _SeaColor;


			float4 frag(v2f i) : SV_Target
			{
				// Retrieving normals from normal map texture
				// Using offsets to resize and move the normals
				float3 localCoords = UnpackNormal(tex2D( _NormalMap, 0.2 * (i.uv.xy * _NormalMap_ST.xy)));
				localCoords -= float3(1.5, 0.5, 0.0);
				
				// Normal Transpose Matrix
				float3x3 local2WorldTranspose = float3x3(
					i.tangentWorld,
					i.binormalWorld,
					i.normalWorld
				);

				// Calculate Normal Direction from normalmap
				float3 normalDir = normalize( mul(localCoords, local2WorldTranspose ) );

				float3 normal = i.normalWorld;

				float3 viewDir = normalize(i.viewDir);

				// Calculate illumination from directional light.
				// _WorldSpaceLightPos0 is a vector pointing the OPPOSITE
				// _WorldSpaceLightPos0 was replaced by normalDir to use the normalmap
				// direction of the main directional light.
				float NdotL = saturate(dot(normalDir, normal));

				// Samples the shadow map, returning a value in the 0...1 range,
				// where 0 is in the shadow, and 1 is not.
				float shadow = SHADOW_ATTENUATION(i);
				// Partition the intensity into light and dark, smoothly interpolated
				// between the two to avoid a jagged break.
				float lightIntensity = NdotL * shadow;

				// Multiply by the main directional light's intensity and color.
				float4 light = lightIntensity * _LightColor0;

				fixed3 ocean_mask_color = tex2D( _OceanMask, i.uv ).rgb;

				float4 specular = float4(0, 0, 0, 0);

				if (ocean_mask_color.r > 0.6)
				{
					// Specular reflection
					// Using 0.2 and pow 10 to decrease specular intensity
					specular = 0.2 * _SpecularColor * pow(saturate( dot( reflect( -normalDir, normal ), viewDir ) ), 10);
				}
				
				half4 base = texCUBE(_BaseMap, i.normal * float3(-1, 1, 1));

				return (light + _AmbientColor) * base + specular;
			}
			ENDCG
		}

		// Shadow casting support.
		UsePass "Legacy Shaders/VertexLit/SHADOWCASTER"
	}
}
