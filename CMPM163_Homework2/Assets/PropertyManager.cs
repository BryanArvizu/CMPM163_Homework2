using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PropertyManager : MonoBehaviour
{
    [SerializeField] private GameObject terrain;
    [SerializeField] private GameObject water;

    private Material terrainMat;
    private Material waterMat;

    private void Start()
    {
        terrainMat = terrain.GetComponent<Renderer>().material;
        waterMat = water.GetComponent<Renderer>().material;
    }

    public void TerrainAmp(float val)
    {
        terrainMat.SetFloat("_Amplitude", val);
    }

    public void TintIntensity(float val)
    {
        waterMat.SetFloat("_Intensity", val);
    }

    public void Reflectiveness(float val)
    {
        waterMat.SetFloat("_Reflectiveness", val);
    }

    public void Opacity(float val)
    {
        waterMat.SetFloat("_Opacity", val);
    }

    public void FresnelStrength(float val)
    {
        waterMat.SetFloat("_FresStr", val);
    }

}
