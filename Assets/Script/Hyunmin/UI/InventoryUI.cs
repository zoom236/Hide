using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class InventoryUI : MonoBehaviour
{
    Inventory inven;

    public GameObject inventoryPanel;
    bool activeInventory = false;

    public Slot[] slots;
    public Transform slotHolder;

    // Start is called before the first frame update
    void Start()
    {
        //inven = Inventory.instance;
        slots = slotHolder.GetComponentsInChildren<Slot>();
        //inven.onSlotCountChange += SlotChange;
        inven.onChangeItem += RedrawSlotUI;
        inventoryPanel.SetActive(activeInventory);
    }

    // Update is called once per frame
    void Update()
    {
        if (Input.GetKeyDown(KeyCode.F))
        {
            activeInventory = !activeInventory;
            inventoryPanel.SetActive(activeInventory);
        }
    }

    public void AddSlot()
    {
        inven.SlotCnt = inven.SlotCnt + 4;
    }

    void RedrawSlotUI()
    {
        for (int i=0;i<slots.Length;i++)
        {
            //slots.RemoveSlot();
        }
        for (int i = 0; i<inven.items.Count;i++)
        {
            slots[i].item = inven.items[i];
            slots[i].UpdateSlotUI();
        }
    }
}
