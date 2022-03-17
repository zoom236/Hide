using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class SlotNew : MonoBehaviour
{
    public Image RedBean;       // 팥
    public Image Zipshoes;      // 짚신
    public Image Amulet;        // 부적
    public Image Got;           // 갓
    public Image StickySlime;   // 끈끈이
    public Image SmokeBomb;     // 연막탄
    public Image BeanBomb;      // 콩알탄
    public Image GasTrap;       // 방구트랩

    public Image RedBean2;       // 팥
    public Image Zipshoes2;      // 짚신
    public Image Amulet2;        // 부적
    public Image Got2;           // 갓
    public Image StickySlime2;   // 끈끈이
    public Image SmokeBomb2;     // 연막탄
    public Image BeanBomb2;      // 콩알탄
    public Image GasTrap2;       // 방구트랩

    public Image RedBean3;       // 팥
    public Image Zipshoes3;      // 짚신
    public Image Amulet3;        // 부적
    public Image Got3;           // 갓
    public Image StickySlime3;   // 끈끈이
    public Image SmokeBomb3;     // 연막탄
    public Image BeanBomb3;      // 콩알탄
    public Image GasTrap3;       // 방구트랩


    string[] inven = new string[3];       // 인벤토리 3칸 배열

    private ItemNew index;

    int num = 0;
    string ItemName;

    [SerializeField] Text pickUpText;
    bool isPickUp;

    void Start()
    {
        
    }

    void Update()
    {
        ItemUse();

        
    }

    //void ItemSwitch()
    //{
    //    switch(index.Index)
    //    {
    //        case 1:
    //            RedBean.gameObject.SetActive(true);
    //            break;
    //    }
    //}

    void AddInven()
    {
        for (int i = 0; i < 3; i++)
        {
            if (inven[i] == null)
            {
                inven[i] = ItemName;
            }


            else
            {
                return;
            }
        }
    }

    void ItemUse()
    {
        if (Input.GetKeyDown(KeyCode.Alpha1))
        {
            inven[0] = null;
            //해당 이미지 비활성화
        }

        else if (Input.GetKeyDown(KeyCode.Alpha2))
        {
            inven[1] = null;
        }

        else if(Input.GetKeyDown(KeyCode.Alpha3))
        {
            inven[2] = null;
        }

    }

    void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.CompareTag("RedBean"))
        {
            //Debug.Log("충돌");
            num = 1;
        }

        else if (collision.gameObject.CompareTag("ZipShoes"))
        {
            //Debug.Log("충돌");
            num = 2;
        }

        else if (collision.gameObject.CompareTag("Amulet"))
        {
            //Debug.Log("충돌");
            num = 3;
        }

        else if (collision.gameObject.CompareTag("Got"))
        {
            //Debug.Log("충돌");
            num = 4;
        }

        else if (collision.gameObject.CompareTag("StickySlime"))
        {
            //Debug.Log("충돌");
            num = 5;
        }

        else if (collision.gameObject.CompareTag("SmokeBomb"))
        {
            //Debug.Log("충돌");
            num = 6;
        }

        else if (collision.gameObject.CompareTag("BeanBomb"))
        {
            //Debug.Log("충돌");
            num = 7;
        }

        else if (collision.gameObject.CompareTag("GasTrap"))
        {
            //Debug.Log("충돌");
            num = 8;
        }

        switch (num)
        {
            case 1:
                RedBean.gameObject.SetActive(true);     // 이미지 활성화
                ItemName = "RedBean";
                AddInven();
                break;
            case 2:
                Zipshoes.gameObject.SetActive(true);     // 이미지 활성화
                ItemName = "Zipshoes";
                AddInven();
                break;
            case 3:
                Amulet.gameObject.SetActive(true);     // 이미지 활성화
                ItemName = "Amulet";
                AddInven();
                break;
            case 4:
                Got.gameObject.SetActive(true);     // 이미지 활성화
                ItemName = "Got";
                AddInven();
                break;
            case 5:
                StickySlime.gameObject.SetActive(true);     // 이미지 활성화
                ItemName = "StickySlime";
                AddInven();
                break;
            case 6:
                SmokeBomb.gameObject.SetActive(true);     // 이미지 활성화
                ItemName = "SmokeBomb";
                AddInven();
                break;
            case 7:
                BeanBomb.gameObject.SetActive(true);     // 이미지 활성화
                ItemName = "BeanBomb";
                AddInven();
                break;
            case 8:
                GasTrap.gameObject.SetActive(true);     // 이미지 활성화
                ItemName = "GasTrap";
                AddInven();
                break;
        }
    }
}
