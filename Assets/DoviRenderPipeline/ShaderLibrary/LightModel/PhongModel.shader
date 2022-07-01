Shader "DoviRenderPipeline/LightModel/PhongModel"
{
    Properties
    {
        _Color("Main Color",color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
        _SpecularPow("SpecularPow",Range(10,100)) = 3
        _Ia("Ambient",color) = (1,1,1,1)
        _Ka("Ka",Range(0,1)) = 1
        _Kd("Kd",Range(0,1)) = 1
        _Ks("Ks",Range(0,1)) = 1
    }
    SubShader
    {
        Tags{ "Queue" = "Geometry" }
        Pass
        {
			Tags{ "LightMode" = "DoviLit" }
			HLSLPROGRAM
			#pragma vertex VERT_PHONG
			#pragma fragment FRAGMENT_PHONG
            #include "UnityCG.cginc"
            #include "CommonLighting.hlsl"
            #include "BaseLightModel.hlsl"
			ENDHLSL
        }
    }
}
