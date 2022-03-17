using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RayScript : MonoBehaviour
{
    RaycastHit hit;
    float MaxDistance = 15f;
    public float speed = 5;

    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {


        /*if (Input.GetKey(KeyCode.D))  //오른쪽
        {
            transform.position = new Vector3(transform.position.x + 0.05f, transform.position.y, transform.position.z);
        }
        else if (Input.GetKey(KeyCode.A))  //왼쪽
        {
            transform.position = new Vector3(transform.position.x - 0.05f, transform.position.y, transform.position.z);
        }
        else if (Input.GetKey(KeyCode.W))  //앞
        {
            transform.position = new Vector3(transform.position.x, transform.position.y, transform.position.z + 0.05f);
        }
        else if (Input.GetKey(KeyCode.S))  //뒤
        {
            transform.position = new Vector3(transform.position.x, transform.position.y, transform.position.z - 0.05f);
        }*/

        float h = Input.GetAxis("Horizontal");
        float v = Input.GetAxis("Vertical");

        Vector3 dir = Vector3.right * h + Vector3.forward * v;
        dir.Normalize();

        transform.position += dir * speed * Time.deltaTime;

        if (Input.GetKeyDown(KeyCode.Space))
        {
            if (Physics.Raycast(transform.position, transform.forward, out hit, MaxDistance))
            {
                Debug.DrawRay(transform.position, transform.forward * MaxDistance, Color.blue, 0.3f);
                hit.transform.GetComponent<MeshRenderer>().material.color = Color.red;
            }

        }
    }
}
