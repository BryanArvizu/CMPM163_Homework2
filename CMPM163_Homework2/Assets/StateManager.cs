using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class StateManager : MonoBehaviour
{
    void Update()
    {
        if(Input.GetKeyUp(KeyCode.Q))
        {
            int index = SceneManager.GetActiveScene().buildIndex;
            if (index == 0)
                SceneManager.LoadScene(1);
            else if(index == 1)
                SceneManager.LoadScene(0);
        }
        if (Input.GetKeyUp(KeyCode.Escape))
        {
            Application.Quit();
        }
    }
}
