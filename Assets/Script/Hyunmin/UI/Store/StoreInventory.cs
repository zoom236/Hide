using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class StoreInventory : MonoBehaviour
{




}




    /*
    public GameObject slotPrefab;
    public const int numSlots = 5;   // 아이템 슬롯 5개
    Image[] itemImages = new Image[numSlots];
    Item[] item = new Item[numSlots];      // 
    GameObject[] slots = new GameObject[numSlots];

    // Start is called before the first frame update
    private void Start()
    {
        CreateSlots();
    }

    // Update is called once per frame
    public void CreateSlots()
    {
        if (slotPrefab != null)
        {
            for (int i = 0; i < numSlots; i++)
            {
                GameObject newSlot = Instantiate(slotPrefab);
                newSlot.name = "ItemSlot" + 1;

                newSlot.transform.SetParent(gameObject.transform.GetChild(0).transform);

                slots[i] = newSlot;

                itemImages[i] = newSlot.transform.GetChild(1).GetComponent<Image>();
            }
        }
    }

    public bool AddItem(Item itemToAdd)
    {
        for(int i = 0; i <items.Length; i++)
        {
            if(items[i] != null && item[i].itemType == itemToAdd.itemType && itemToAdd.stackable == true)
            {
                item[i].quantity = item[i].quantity + 1;
                Slot slotScript = slots[i].gameObject.GetComponent<Slot>();

                Text quantityText = slotScript.qtyText;
                quantityText.enabled = true;
                quantityText.text = item[i].quantity.ToString();
                return true;
            }

            if(item[i] == null)
            {
                item[i] = Instantiate(itemToAdd);
                item[i].quantity = 1;
                itemImages[i].sprite = itemToAdd.sprite;
                itemImages[i].enabled = true;
                return true;

            }
        }

        return false;

    }
  
}
    */
    

