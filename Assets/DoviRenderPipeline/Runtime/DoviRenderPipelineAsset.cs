using UnityEngine;
using UnityEngine.Rendering;

[CreateAssetMenu(fileName = "DoviRenderPipeline.asset", menuName = "Rendering/Dovi Render Pipeline Asset", order = 320)]
public class DoviRenderPipelineAsset : RenderPipelineAsset
{
    /// <summary>
    /// 公有成员
    /// </summary>
    #region Public Parames
    public bool SRPBatching;
    public PerObjectData perObjectData;
    #endregion

    /// <summary>
    /// 重写
    /// </summary>
    #region override
    public override Material defaultMaterial => (Material)Resources.Load("GI/Material/Default");
    public override Material defaultParticleMaterial => (Material)Resources.Load("GI/Material/Default-Particle");
    public override Shader defaultShader => Shader.Find("GI/Standard");

    protected override RenderPipeline CreatePipeline() => new DoviRenderPipeline(this);
    #endregion
}
