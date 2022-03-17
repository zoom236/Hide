using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ActionController : MonoBehaviour
{
    [SerializeField]
    //private float range;  // 아이템 습득이 가능한 최대 거리

    public bool pickupActivated = false;  // 아이템 습득 가능할시 True 

    public RaycastHit hitInfo;  // 충돌체 정보 저장
    public Inventory inven;
    

    //[SerializeField]
    //private LayerMask layerMask;  // 특정 레이어를 가진 오브젝트에 대해서만 습득할 수 있어야 한다.


    [SerializeField]
    public Text actionText;  // 행동을 보여 줄 텍스트

    GameObject book;

   



    public void TryAction()
    {
        if (Input.GetKeyDown(KeyCode.E))
        {
            Debug.Log("클릭");
            //CheckItem();
            CanPickUp();
        }
    }

    private void CheckItem()
    {
        //Debug.DrawRay(transform.position, transform.forward * range, Color.blue);
        //if (Physics.Raycast(transform.position, transform.forward, out hitInfo, range, layerMask))

        /*Debug.Log("아이템 확인");
        if (hitInfo.transform.tag == "Item")
        {
            ItemInfoAppear();
        }
        else
            ItemInfoDisappear();*/
    }

    public void ItemInfoAppear()
    {
        Debug.Log("아이템 찾음!");
        pickupActivated = true;
        actionText.gameObject.SetActive(true);
        TryAction();
        //actionText.text = hitInfo.transform.GetComponent<ItemPickUp>().item.itemName + " 획득 " + "<color=yellow>" + "(E)" + "</color>";
    }

    public void ItemInfoDisappear()
    {
        Debug.Log("pickupActivated 꺼졌지롱!");
        pickupActivated = false;
        actionText.gameObject.SetActive(false);
    }

    private void CanPickUp()
    {
        Debug.Log("E키 누름");
        if (pickupActivated)
        {
            Debug.Log("아이템 획득");  // 인벤토리 넣기

            Destroy(GameObject.FindGameObjectWithTag("Item"));
            ItemInfoDisappear();
        }
    }

    /*void OnCollisionEnter(Collision other)
    {
        Debug.Log("충돌");
        if (other.gameObject == book)
        {
            Debug.Log("아이템 확인");
            ItemInfoAppear();
        }
        else
            ItemInfoDisappear();
    }*/
}

