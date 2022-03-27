using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class RedBeanSpawn : MonoBehaviour
{
    //public static RedBeanSpawn instance { get; private set; }
    //private void Awake() => instance = this;

    public GameObject RedBeanObj;       // 팥 프리팹 저장
    public GameObject Spawn;     // 팥 스폰 위치
    public Camera followCamera;         // 따라올 카메라
    public GameObject player;
    RedBeanItem redbeanscript;

    public GameObject slotParent;
    public GameObject[] slot;

    //public bool RedBeanUse;

    // Start is called before the first frame update
    void Start()
    {
        for (int i = 0; i < slotParent.transform.childCount; i++)
        {
            slot[i] = slotParent.transform.GetChild(i).gameObject;
        }
    }

    // Update is called once per frame
    void Update()
    {
        Drop();
    }

    void Drop()
    {
        Debug.DrawRay(Spawn.transform.position, Spawn.transform.forward * 100f, Color.red);

        for (int i = 0; i < 3; i++)
        {
            if (slot[i].transform.childCount > 0)
            {
                if (slot[i].transform.GetChild(0).GetComponent<RedBeanItem>().isUse)
                {
                    Ray ray = followCamera.ScreenPointToRay(Input.mousePosition);
                    RaycastHit rayhit;
                    int floorMask = LayerMask.GetMask("Floor");
                    Vector3 nextVec;

                    if (Physics.Raycast(ray, out rayhit, 50f, floorMask))
                    {
                        nextVec = rayhit.point - player.transform.position;
                    }
                    else
                    {
                        nextVec = transform.forward * 20f;
                    }

                    nextVec.y = 10f;

                    GameObject instantRedBean = Instantiate(RedBeanObj, transform.position, transform.rotation);
                    Rigidbody rigidBean = instantRedBean.GetComponent<Rigidbody>();
                    rigidBean.AddForce(nextVec, ForceMode.Impulse);

                }
            }
        }

    }
}
