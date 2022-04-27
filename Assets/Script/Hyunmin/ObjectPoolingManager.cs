using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ObjectPoolingManager : MonoBehaviour
{

    public static ObjectPoolingManager instance;

    public GameObject m_goPrefab = null;

    public Queue<GameObject> m_queue = new Queue<GameObject>();


    // Start is called before the first frame update
    void Start()
    {
        instance = this;

        GameObject t_object = Instantiate(m_goPrefab, Vector3.zero, Quaternion.identity);
        m_queue.Enqueue(t_object);
        t_object.SetActive(false);

    }

    // Update is called once per frame
    public void InsertQueue(GameObject p_object)
    {
        m_queue.Enqueue(p_object);
        p_object.SetActive(false);

    }

    public GameObject GetQueue()
    {
        GameObject t_object = m_queue.Dequeue();
        t_object.SetActive(true);
        return t_object;

    }
}

