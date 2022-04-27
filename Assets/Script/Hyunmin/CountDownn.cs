using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;
public class CountDownn : MonoBehaviour
{
    //public static CountDownn instance;

    public GameObject[] countdown;

    //private void Awake()
    //{
    //    instance = this;
    //}

    // Update is called once per frame
    public void CountStart()
    {
        StartCoroutine(countdownStart());
    }

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
