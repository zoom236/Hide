using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class FieldItem : MonoBehaviour
{
    public Item item;  // 어떤 아이템인가?
    public MeshRenderer image; // 아이템이랑 맞는 이미지 넣기

    public void SetItem(Item _item)
    {
        item.itemName = _item.itemName;  // 아이템 이름
        item.itemImage = _item.itemImage;   // 해당 오브젝트의 이미지
        item.itemType = _item.itemType;  // 소모품인지 장비인지

        //image.material = _item.itemMaterial;
    }

    public Item GetItem()  // 아이템 획득
    {
        return item;
    }

    public void DestroyItem()
    {
        Destroy(gameObject);
    }

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
