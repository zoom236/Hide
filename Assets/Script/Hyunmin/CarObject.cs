using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CarObject : MonoBehaviour
{

    Rigidbody m_myrigid = null;


    private void OnEnable()
    {
        if (m_myrigid ==null)
        {
            m_myrigid = GetComponent<Rigidbody>();
            


        }

        m_myrigid.AddExplosionForce(1000, transform.position, 1f);
        StartCoroutine(DestoryCar());


    }


    IEnumerator DestoryCar()
    {
        yield return new WaitForSeconds(1f);
        Destroy(gameObject);


    }




}
