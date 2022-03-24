using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PowerUpItem : MonoBehaviour
{
    // Start is called before the first frame update


    public float increase = 30f;


        public void OnTriggerEnter(Collider other)
        {

        if (other.name == "Player")
        {
            Playball player = other.GetComponent<Playball>();
            player.PowerUpItem++;
            Destroy(gameObject);

            if (player)
            {
                player.moveSpeed += increase;

            }


            Destroy(gameObject);

        }

    }
}

