using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ThrowBall : MonoBehaviour
{



    public GameObject ballPosition;      //무기를 발사할 위치 지정

    public GameObject ballFactory;   //무기 오브젝트


    public float throwPower = 15f;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetMouseButton(1))    //마우스 클릭시 발사
        {
           
            GameObject ball = Instantiate(ballFactory);
            ball.transform.position = ballPosition.transform.position;
            Rigidbody rb = ball.GetComponent<Rigidbody>();
            //카메라의 정면 방향으로 무기에 물리적 힘

            rb.AddForce(Camera.main.transform.forward * throwPower, ForceMode.Impulse);





        }

    }



}
