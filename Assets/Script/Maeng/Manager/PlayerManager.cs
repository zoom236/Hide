using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayerManager : MonoBehaviour
{
    RaycastHit hit;
    float maxDistance = 100;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        //Debug.DrawRay(gameObject.transform.position, gameObject.transform.forward * hit.distance, Color.red);

        if (Physics.Raycast(gameObject.transform.position, gameObject.transform.forward, out hit, 100))
        {
            Debug.Log(hit.collider.name);  //레이케스트에 닿인 오브젝트 이름 출력
            Debug.DrawRay(gameObject.transform.position, gameObject.transform.forward * hit.distance, Color.red);  //DrawRay (발사할 위치, 발사할 방향과 거리, 발사 색)
        }
        else 
        {
            Debug.DrawRay(gameObject.transform.position, gameObject.transform.forward * maxDistance, Color.red);
        }
    }
}
