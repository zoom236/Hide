using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;

public class SmokeGrenade : MonoBehaviourPunCallbacks
{
    // Start is called before the first frame update

    //public GameObject gameObject1;

    // Update is called once per frame

    public PhotonView PV;
    public Rigidbody rigid;
    public GameObject effectobj;



    //public bool playsmoke = false;
    //public ParticleSystem particleObject;
    // public GameObject smoke2;
    private void Awake()
    {
        //gameObject1 = GetComponent<GameObject>();

    }


    void Start()
    {

        StartCoroutine(Explosion());
        // StartCoroutine(Explosion());
        //  particleObject.Play();

    }




    public void OnTriggerEnter(Collider other)
    {
        if (other.name == "Player")
        {
            Playball player = other.GetComponent<Playball>();
            player.itemCount++;
            Destroy(gameObject);

        }

    }



    IEnumerator Explosion()
    {

        yield return new WaitForSeconds(3f);
        rigid.velocity = Vector3.zero;
        rigid.angularVelocity = Vector3.zero;
        effectobj.SetActive(true);


    }





}

/*
IEnumerator Explosion()
{
    Debug.Log("1");
    yield return new WaitForSeconds(3f);
    rigid.velocity = Vector3.zero;
    rigid.angularVelocity = Vector3.zero;
    playsmoke = false;
    smoke2.SetActive(false);



}
*/


/*  private void OnCollisionEnter(Collision collision)
{
    GameObject eff = Instantiate(bombEffect);

    eff.transform.position = transform.position;

    Destroy(gameObject);
}






 void OnCollisionStay(Collision collision)
{

    gameObject1.SetActive(false);

}

*/


