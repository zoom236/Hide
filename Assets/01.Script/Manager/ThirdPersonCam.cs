using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ThirdPersonCam : MonoBehaviour
{
    public Transform follow;
    [SerializeField] float m_Speed;
    [SerializeField] float m_MaxRayDist = 1;
    [SerializeField] float m_Zoom = 3f;
    RaycastHit m_Hit;
    Vector2 m_Input;

    void Start()
    {
    }

    void Rotate()
    {
        if (Input.GetMouseButton(0))
        {
            m_Input.x = Input.GetAxis("Mouse X");
            m_Input.y = Input.GetAxis("Mouse Y");

            if (m_Input.magnitude != 0)
            {
                Quaternion q = follow.rotation;
                q.eulerAngles = new Vector3(q.eulerAngles.x + m_Input.y * m_Speed, q.eulerAngles.y + m_Input.x * m_Speed, q.eulerAngles.z);
                follow.rotation = q;

            }
        }
    }

    void Zoom()
    {
        float scroll = Input.GetAxis("Mouse ScrollWheel");
        if (scroll != 0)
        {
            Transform cam = Camera.main.transform;
            if (CheckRay(cam, scroll))
            {
                Vector3 targetDist = cam.transform.position - follow.transform.position;
                targetDist = Vector3.Normalize(targetDist);
                Camera.main.transform.position -= (targetDist * scroll * m_Zoom);
            }
        }

        Camera.main.transform.LookAt(follow.transform);
    }

    public void LateUpdate()
    {
        Rotate();
        Zoom();
    }

    bool CheckRay(Transform cam, float scroll)
    {
        if (Physics.Raycast(cam.position, transform.forward, out m_Hit, m_MaxRayDist))
        {
            Debug.Log("hit point : " + m_Hit.point + ", distance : " + m_Hit.distance + ", name : " + m_Hit.collider.name);
            Debug.DrawRay(cam.position, transform.forward * m_Hit.distance, Color.red);
            cam.position += new Vector3(0, 0, m_Hit.point.z);
            return false;
        }

        return true;
    }
}
