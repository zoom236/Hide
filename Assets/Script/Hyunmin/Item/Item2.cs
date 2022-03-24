using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Item2 : MonoBehaviour
{
    public enum Type
    {
        Ammo, Coin, Grenade, Heart, Weapon
    };

    public Type type;
    public int value;


    // Start is called before the first frame update
    void Start()
    {

    }

    // Update is called once per frame
    void Update()
    {
        transform.Rotate(Vector3.up * 20 * Time.deltaTime);
    }
}
