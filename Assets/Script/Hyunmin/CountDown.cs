using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class CountDown : MonoBehaviour
{


    public GameObject[] countdown;


    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(countdownStart());

    }

    // Update is called once per frame


    IEnumerator countdownStart()
    {
        for (int i = 0; i <= 11; i++)
        {
            countdown[i].SetActive(true);
            yield return new WaitForSeconds(1f);
            countdown[i].SetActive(false);
        }

    }
}
