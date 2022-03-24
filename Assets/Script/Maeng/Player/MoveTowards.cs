using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveTowards : MonoBehaviour
{
    /* 시점 방향으로 이동하는 스크립트입니다. */

    public Camera cam; //메인카메라
    private float Speed = 0.5f; // 이동속도

    void Start()
    {
    }

    void Update()
    {
        MoveLookAt();
    }
    void MoveLookAt()
    {
        //메인카메라가 바라보는 방향입니다.
        Vector3 dir = cam.transform.localRotation * Vector3.forward;
        //카메라가 바라보는 방향으로 팩맨도 바라보게 합니다.
        transform.localRotation = cam.transform.localRotation;
        //팩맨의 Rotation.x값을 freeze해놓았지만 움직여서 따로 Rotation값을 0으로 세팅해주었습니다.
        transform.localRotation = new Quaternion(0, transform.localRotation.y, 0, transform.localRotation.w);
        //바라보는 시점 방향으로 이동합니다.
        gameObject.transform.Translate(dir * 0.1f * Time.deltaTime);
    }
}
