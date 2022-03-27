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

            // 아이템 사용
            Debug.Log("RedBean, slotNumber : " + (transform.parent.GetComponent<SlotCheck>().num + 1));
            StartCoroutine(ItemUse());
        }

        else
            isUse = false;
    }

    IEnumerator ItemUse()
    {
        yield return new WaitForSeconds(0.5f);
        Destroy(this.gameObject);
    }

}
