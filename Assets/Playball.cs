using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Playball : MonoBehaviour
{

    public float jumpPower;
    public int itemCount;
    bool isJump;
    public GameObject firePosition;    //무기를 발사할 위치 지정
    public float throwPower = 15f; //투척 파워
    public GameObject bombFactory; //무기 오브젝트
    public float moveSpeed = 10f;  //플레이어 이동 속도
    Rigidbody rigid;
    public int PowerUpItem;

    Vector3 movement;



    void Awake()
    {
        isJump = false;

        rigid = GetComponent<Rigidbody>();

        FixedUpdate();

    }


    // Start is called before the first frame update

    // Update is called once per frame
    void Update()
    {
        if (Input.GetButtonDown("Jump"))
        {
            Debug.Log("Jump");
            rigid.AddForce(new Vector3(0, jumpPower, 0), ForceMode.Impulse);
            isJump = true;

        }



        if (Input.GetButtonDown("Fire1"))
        {

            if (itemCount == 0)
                Debug.Log("아이템 없음");

            if (itemCount >= 1)
            {
                //gameObject.SetActive(true);
                itemCount--;
                Shoot();
               
            }

        }


    }

    void FixedUpdate()
    {
        float h = Input.GetAxisRaw("Horizontal");
        float v = Input.GetAxisRaw("Vertical");

        rigid.AddForce(new Vector3(h, 0, v), ForceMode.Impulse);

        //Run(h, v);

    }



    void Shoot()
    {
        //  gameObject.SetActive(true);
        // GameObject instantGrenade = Instantiate(gameobject, transform.position, transform.rotation);
        // Vector3 speed = new Vector3((float)3.11, (float)4.84, (float)-26.13);
        //Rigidbody rigidGrenade = instantGrenade.GetComponent<Rigidbody>();
        // instantGrenade.AddForce(speed,ForceMode.Impulse);
        // instantGrenade.AddTorque(Vector3.back * 10, ForceMode.Impulse);

        Vector3 throw1;
        throw1 = transform.forward * 20f;
        GameObject bomb = Instantiate(bombFactory, transform.position, transform.rotation);
        Rigidbody rby = bomb.GetComponent<Rigidbody>();
        bomb.transform.position = firePosition.transform.position;
        rby.AddForce(throw1, ForceMode.Impulse);


        

    }


     /*
void Run(float h, float v)
    {

        movement.Set(h, 0, v);

        movement = movement.normalized * moveSpeed * Time.deltaTime;

        rigid.MovePosition(transform.position + movement);

    }

    */

   

}
    











