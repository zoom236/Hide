using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;


public class StartScript : MonoBehaviour
{
    // Start is called before the first frame update

    public void Click()
    {
        SceneManager.LoadScene(1);
    }


    public void StartClick()
    {
        SceneManager.LoadScene(2);
    }

}
