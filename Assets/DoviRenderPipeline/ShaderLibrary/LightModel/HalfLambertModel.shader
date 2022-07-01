Shader "DoviRenderPipeline/LightModel/HalfLambertModel"
{
    Properties
    {
        _Color("Main Color",color) = (1,1,1,1)
        _MainTex ("Texture", 2D) = "white" {}
    }
    SubShader
    {
        Tags{ "Queue" = "Geometry" }
        Pass
        {
			Tags{ "LightMode" = "DoviLit" }
			HLSLPROGRAM
			#pragma vertex VERT_HALFLAMBERT
			#pragma fragment FRAGMENT_HALFLAMBERT
            #include "UnityCG.cginc"
            #include "CommonLighting.hlsl"
            #include "BaseLightModel.hlsl"
			ENDHLSL
        }
    }
}
