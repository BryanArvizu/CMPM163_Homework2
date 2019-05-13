using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class UI_Navigator : MonoBehaviour
{
    [SerializeField] private Material terrainMat;
    [SerializeField] private Material waterMat;

    [SerializeField] private Text[] text;
    [SerializeField] private string[] propertyName;

    private List<string> baseTextStr;
    private int selected = 0;


    // Start is called before the first frame update
    void Start()
    {
        foreach(Text t in text)
        {
            baseTextStr.Add(t.text);
        }
        text[0].color = Color.green;
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void switchSelection(int newSelection)
    {
        text[selected].color = Color.white;
        selected = newSelection;
        text[selected].color = Color.green;
    }
}
