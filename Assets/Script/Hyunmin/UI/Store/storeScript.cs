using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class storeScript : MonoBehaviour
{

    Scrollbar bar;    //스크롤바 bar 변수


    // Start is called before the first frame update
    void Start()
    {
        bar = gameObject.GetComponent<Scrollbar>();     // 변수는 게임 오브젝트 scrollbar 가져옴
        bar.value = 1;     // bar값 1 설정

    }

    // Update is called once per frame
    void SetContentSize()

    {
        //SettingPanel.GetComponent().relativePositionOnReset = new Vector2(0, 0); 
    }
}


