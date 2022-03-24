using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Newtonsoft.Json;
using System.IO;

[System.Serializable]
public class ItemNew
{
    public ItemNew(string _Type, string _Name, string _Index, string _Explain)
    { Type = _Type; Name = _Name; Index = _Index; Explain = _Explain;}

    public string Type, Name, Index, Explain;
    //public bool isUsing;
}

public class GameManager : MonoBehaviour
{
    public TextAsset ItemDatabase;
    public List<ItemNew> AllItemList;

    void Start()
    {
        // 전체 아이템 리스트 불러오기
        string[] line = ItemDatabase.text.Substring(0, ItemDatabase.text.Length).Split('\n');
        for (int i = 0; i < line.Length ; i++)
        {
            string[] row = line[i].Split('\t');

            AllItemList.Add(new ItemNew(row[0], row[1], row[2], row[3]));
        }
        //Load();

    }

    void ItemUse()
    {

    }

    void Save()
    {
        string jdata = JsonConvert.SerializeObject(AllItemList);
        //print(Application.dataPath);
        File.WriteAllText(Application.dataPath + "/UI/Item/MyItemText.txt", jdata);
    }

    //void Load()
    //{
    //    string jdata = File.ReadAllText(Application.dataPath + "/UI/Item/MyItemText.txt");
    //    MyItemList = JsonConvert.DeserializeObject<List<ItemNew>>(jdata);
    //}
}
