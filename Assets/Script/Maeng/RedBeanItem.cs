using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RedBeanItem : MonoBehaviour
{
    
    public bool isUse;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {

        if (Input.inputString == (transform.parent.GetComponent<SlotCheck>().num + 1).ToString())
        {
            isUse = true;

            // ������ ���
            Debug.Log("RedBean, slotNumber : " + (transform.parent.GetComponent<SlotCheck>().num + 1));
            Destroy(this.gameObject);
        }

        else
            isUse = false;
    }

}
