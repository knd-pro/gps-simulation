using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteAlways]
public class waterMaskHandler : MonoBehaviour
{    // Start is called before the first frame update
    void Start()
    {
        var data = System.IO.File.ReadAllBytes("Assets/StreamingAssets/water_mask.png");
        var oceanMask = new Texture2D(1,1);
        oceanMask.LoadRawTextureData(data);
        GetComponent<EarthRenderer>().BaseMaterial.SetTexture("_OceanMask", oceanMask);
    }
}
