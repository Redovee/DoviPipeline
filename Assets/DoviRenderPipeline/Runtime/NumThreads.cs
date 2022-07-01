using UnityEngine;

public class NumThreads
{
    public int x
    {
        get { return (int)_numThreads[0]; }
    }
    public int y
    {
        get { return (int)_numThreads[1]; }
    }
    public int z
    {
        get { return (int)_numThreads[2]; }
    }

    uint[] _numThreads = new uint[] { 1, 1, 1 };
    
    public NumThreads(ComputeShader compute, int kernelIndex)
    {
        //获取内核线程组大小，kernelIndex要查询的内核，x,y,z尺寸中的线程组大小，这里始终是（1,1,1）
        compute.GetKernelThreadGroupSizes(kernelIndex, out _numThreads[0], out _numThreads[1], out _numThreads[2]);
    }

    public static implicit operator int[](NumThreads t)
    {
        return new int[] { t.x, t.y, t.z };
    }
}
