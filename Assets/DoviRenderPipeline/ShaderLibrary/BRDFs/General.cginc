#ifndef VXGI_BRDFS_GENERAL
  #define VXGI_BRDFS_GENERAL

  #include "Assets/DoviRenderPipeline/ShaderLibrary/BRDFs/Diffuse.cginc"
  #include "Assets/DoviRenderPipeline/ShaderLibrary/BRDFs/Specular.cginc"
  #include "Assets/DoviRenderPipeline/ShaderLibrary/Structs/LightingData.cginc"

  float3 GeneralBRDF(LightingData data)
  {
    return DiffuseBRDF(data) + SpecularBRDF(data);
  }
#endif
