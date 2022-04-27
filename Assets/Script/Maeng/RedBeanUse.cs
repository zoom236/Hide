using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RedBeanUse : MonoBehaviour
{
    public GameObject meshObj;
    public GameObject effectObj;
    public Rigidbody rigid;
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(Explosion());
    }

    

    IEnumerator Explosion()
    {
        yield return new WaitForSeconds(3f);        // 3초 뒤에 폭발
        rigid.velocity = Vector3.zero;
        rigid.angularVelocity = Vector3.zero;
        meshObj.SetActive(false);
        effectObj.SetActive(true);

        RaycastHit[] rayHits = Physics.SphereCastAll(transform.position, 10, Vector3.up, 0f, LayerMask.GetMask("Enemy"));
        // 10 범위만큼 Enemy Layer를 가진 물체에게 피해

        foreach(RaycastHit hitObj in rayHits)
        {
            hitObj.transform.GetComponent<Enemy>().HitByRedBean(transform.position);
        }
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
