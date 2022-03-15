using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerController : MonoBehaviour
{
    public float speed;
    float hAxis;
    float vAxis;

    bool jDown;  // ¡°«¡
    bool isJump;

    bool sDown;  // æ…±‚
    bool isSit;

    bool swDown;  // æ…¿∫ªÛ≈¬ø°º≠ ∞»±‚
    bool isSitWalk;
    
    Vector3 moveVec;
    Rigidbody rigid;
    Animator anim;

    void Awake()
    {
        anim = GetComponent<Animator>();
        rigid = GetComponent<Rigidbody>();
    }

    void Update()
    {
        GetInput();
        Move();
        Trun();
        Jump();
        Sit();
    }

    void GetInput()
    {
        hAxis = Input.GetAxisRaw("Horizontal");
        vAxis = Input.GetAxisRaw("Vertical");
        jDown = Input.GetButtonDown("Jump");
        sDown = Input.GetKeyDown(KeyCode.V);
    }

    void Move()
    {
        moveVec = new Vector3(hAxis, 0, vAxis).normalized;

        anim.SetBool("isRun", moveVec != Vector3.zero);
    }

    void Trun()
    {
        transform.LookAt(transform.position + moveVec);
    }

    void Jump()
    {
        if (jDown && !isJump)
        {
            rigid.AddForce(Vector3.up * 5, ForceMode.Impulse);
            anim.SetBool("isJump", true);
            anim.SetTrigger("doJump");
            isJump = true;
        }
    }

    void Sit()
    {
        if (sDown && !isSit)
        {
            anim.SetBool("isSit", true);
            isSit = true;
        }
        //isSit = false;
    }

    void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Floor")
        {
            //anim.SetBool("isJump", false);
            isJump = false;
            isSit = false;
        }
    }
}
