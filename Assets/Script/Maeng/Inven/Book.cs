using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Book : MonoBehaviour
{
    GameObject player;
    private ActionController actioncontroller;

    public GameObject script_1;

    // Start is called before the first frame update


    //// Update is called once per frame
    //void Update()
    //{
    //    //player = GameObject.FindGameObjectWithTag("Player");
    //    //script_1.GetComponent<ActionController>().ItemInfoDisappear();
    //    //actioncontroller = GameObject.Find("Character").GetComponent<ActionController>
    //}

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            Debug.Log("아이템 확인");
            script_1.GetComponent<ActionController>().ItemInfoAppear();
            //actioncontroller.ItemInfoAppear();
        }
        //actioncontroller.ItemInfoDisappear();
    }

    private void OnTriggerExit(Collider other)
    {
        if (other.gameObject.CompareTag("Player"))
        {
            Debug.Log("아이템 아웃!");
            script_1.GetComponent<ActionController>().ItemInfoDisappear();
            //actioncontroller.ItemInfoAppear();
        }
    }
}
