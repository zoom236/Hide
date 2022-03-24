using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class YutPlay: MonoBehaviour
{


    delegate int Calculator<T>(T start, T end);
    Calculator<int> PICK;


    // Start is called before the first frame update
    private void Start()
    {
        SetDel();
        
    }


    // Update is called once per frame
    void SetDel()
    {
        PICK += (start, end) => { return Random.Range(start, end); };

    }


    void Update()
    {
        if(Input.GetKeyDown(KeyCode.Space))
        {
            Ran();
        }
    }



    void Ran()
    {

        List<string> Yut = new List<string>();

        Yut.Add("µµ");
        Yut.Add("°³");
        Yut.Add("°É");
        Yut.Add("À·");
        Yut.Add("¸ð");
        Yut.Add("»ªµµ");

        int  Yute = 0;

        Yute = PICK(0, 6);

        
        if(Yute == 0)
            {
                Debug.Log(Yut[0]);
            }
            else if(Yute == 1)
            {
                Debug.Log(Yut[1]);
            }
            else if (Yute == 2)
            {
                Debug.Log(Yut[2]);
            }
            else if (Yute == 3)
            {
                Debug.Log(Yut[3]);
            }
            else if (Yute == 4)
            {
                Debug.Log(Yut[4]);
            }
            else if (Yute == 5)
            {
                Debug.Log(Yut[5]);
            }
        
    }
}
