using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class MoveControl : MonoBehaviour
{
    // Start is called before the first frame update

    [SerializeField] float speed = 300f;
    float moveX, moveY, moveZ;
    Rigidbody rb;

    private void Start()
    {
        rb = GetComponent<Rigidbody>();

    }
     void Update()
    {
        moveX = Input.GetAxis("Horizontal");
        moveY = Input.GetAxis("Vertical");
        rb.velocity = new Vector3(moveX * speed * Time.deltaTime, moveY * speed * Time.deltaTime, moveZ * speed * Time.deltaTime);
    }

}
