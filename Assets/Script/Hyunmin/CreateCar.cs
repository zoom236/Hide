using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class CreateCar : MonoBehaviour
{

    public GameObject m_goPrefab = null;


   
    // Start is called before the first frame update
    void Start()
    {
        StartCoroutine(CreateCoroutine());
    }

    // Update is called once per frame
  

    IEnumerator CreateCoroutine()
    {
        while(true)
        {
            yield return null;
            Instantiate(m_goPrefab, Vector3.zero, Quaternion.identity);

        }
    }
}
