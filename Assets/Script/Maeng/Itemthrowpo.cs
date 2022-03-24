using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Itemthrowpo : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        GetComponent<Rigidbody>().isKinematic = true;
        //시작과 동시에 물체가 추락하지 않도록 하기 위한 코드
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetButtonDown("Fire1"))
        {
            Shoot();
            Debug.Log("1");
        }
    }

    void Shoot()
    {
        Vector3 speed = new Vector3((float)3.11, (float)4.84, (float)-26.13);
        GetComponent<Rigidbody>().AddForce(speed);
    }
}
