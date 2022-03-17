using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Inventory : MonoBehaviour
{
    public delegate void OnSlotCountChage(int val);
    public OnSlotCountChage onSlotCountChange;

    public delegate void OnChangeItem();  // 인벤토리 ui 바뀌도록
    public OnChangeItem onChangeItem;

    public List<Item> items = new List<Item>();  // 획득한 아이템을 담을 리스트

    private int slotCnt;
    public int SlotCnt
    {
        get=>slotCnt;
        set
        {
            slotCnt = value;
            //onSlotCountChange.Invoke(slotCnt);
        }
    }

    // Start is called before the first frame update
    void Start()
    {
        SlotCnt = 5;
    }

    public bool AddItem(Item _item)  //items 리스트에 아이템을 추가할 수 있는 메서드
    {
        if (items.Count < SlotCnt)
        {
            items.Add(_item);
            if(onChangeItem != null)
            
            onChangeItem.Invoke();
            return true;  // 아이템 추가에 성공하면
        }
        return false;
        // items의 개수가 slotCnt (현재 활성 슬롯)보다 작을 때만 아이템 추가될 수 있도록
    }

    private void OnTriggerEnter(Collider collision)
    {
        if (collision.CompareTag("FieldItem"))
        {
            Debug.Log("충돌");

            FieldItem fieldItems = collision.GetComponent<FieldItem>();
            if (AddItem(fieldItems.GetItem()))
                fieldItems.DestroyItem();
            
        }
    }

    // Update is called once per frame
    void Update()
    {

    }

}
