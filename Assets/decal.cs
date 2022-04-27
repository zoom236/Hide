using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class decal : MonoBehaviour
{
    Camera camera;
    public GameObject dec;
    public Transform e;
    public GameObject parent;
    // Start is called before the first frame update
    void Start()
    {
        camera = Camera.main;   
    }

    // Update is called once per frame
    void Update()
    {
        if(Input.GetMouseButtonDown(0))
        {
            ray();
        }
    }

    void ray()
    {
        Ray ray = camera.ScreenPointToRay(Input.mousePosition);
        RaycastHit rayhit;
        
        if (Physics.Raycast(ray, out rayhit, 100))
        {
            Debug.DrawRay(transform.position, transform.forward * 100f, Color.red);
            e.position = rayhit.point;
            GameObject inst = Instantiate(dec, e);
            inst.transform.SetParent(null);
            inst.SetActive(true);
        }
    }
}
