using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TestManager : MonoBehaviour
{
    public Transform GuideGroup;
    public Transform[] Guides;
    // Start is called before the first frame update
    void Start()
    {
        for(int i=0;i<GuideGroup.childCount;i++)
        {
            Guides[i] = GuideGroup.GetChild(i);
            var book = ObjectPool.GetBook();
            book.transform.SetParent(Guides[i]);
            book.transform.position = Guides[i].position;
        }

    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
