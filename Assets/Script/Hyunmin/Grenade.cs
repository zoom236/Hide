using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Grenade : MonoBehaviour
{

    public GameObject meshObj;
    public GameObject effectObj;
    public Rigidbody rigid;



    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(Explosion());
        
    }

    // Update is called once per frame
    IEnumerator Explosion()
    {
        yield return new WaitForSeconds(3F);
        rigid.velocity = Vector3.zero;
        rigid.angularVelocity = Vector3.zero;
        
        meshObj.SetActive(false);
        effectObj.SetActive(true);
    }
}
