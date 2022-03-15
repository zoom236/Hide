using System.Collections;
using System.Collections.Generic;
using UnityEngine;


public class Dice : MonoBehaviour
{
    // Start is called before the first frame update
     Rigidbody rb;

    bool hasLanded;
    bool thrown;

    Vector3 initPosition;

    public int diceValue;

    public DiceSide[] diceSides;


    private static List<Dice> instances = new List<Dice>();

   

    private void Awake()
    {
        instances.Add(this);

    }

    private void OnDestroy()
    {
        instances.Remove(this);

    }

     void Start()
    {
        rb = GetComponent<Rigidbody>();
        initPosition = transform.position;
        rb.useGravity = false;

    }

     void Update()
    {
        if(Input.GetKeyDown(KeyCode.Space))
        {
            RollDice();

        }

        if(rb.IsSleeping() && !hasLanded && thrown)
        {
            hasLanded = true;
            rb.useGravity = false;
            SideValueCheck();

        }
        else if(rb.IsSleeping() && hasLanded && diceValue == 0)
        {
            RollAgain();

        }

    }

    void RollDice()
    {
        if(!thrown && !hasLanded)
        {
            thrown = true;
            rb.useGravity = true;
            rb.AddTorque(Random.Range(0, 500), Random.Range(0, 500), Random.Range(0, 500));
        }

        else if (thrown && hasLanded)
        {
            Reset();
        }
    }

     void Reset()
    {
        transform.position = initPosition;
        thrown = false;
        hasLanded = false;
        rb.useGravity = false;

    }
 
    void RollAgain()
    {
       // Reset();
        
       // rb.AddTorque(Random.Range(0, 500), Random.Range(0, 500), Random.Range(0, 500));
    }

    void SideValueCheck()
    {
        diceValue = 0;

        foreach(DiceSide side in diceSides)
        {
            if (side.OnGround())
            {
                diceValue = side.sideValue;
                Debug.Log(diceValue);
            }
        }




    }
}
