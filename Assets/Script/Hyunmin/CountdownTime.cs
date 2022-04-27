using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CountdownTime : MonoBehaviour
{

    public int countdownTime;
    public Text countdownDisplay;
    public Image countdownImage;


    // Start is called before the first frame update

    private void Start()
    {
        StartCoroutine(CountdownToStart());        
    }

    IEnumerator CountdownToStart()
    {
        while(countdownTime > 0)
        {
            countdownDisplay.text = countdownTime.ToString();


            yield return new WaitForSeconds(1f);


            countdownTime--;

        }

        countdownDisplay.text = "Go!";

        //GameController.instance.BeginGame();

        yield return new WaitForSeconds(1f);

        countdownDisplay.gameObject.SetActive(false);
        countdownImage.gameObject.SetActive(false);

    }
}
