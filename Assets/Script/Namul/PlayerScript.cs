using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine.UI;

public class PlayerScript : MonoBehaviourPunCallbacks, IPunObservable
{
    //Animator animator;
    Camera camera;
    //Rigidbody rigid;

    public float speed = 5f;
    public float runSpeed = 8f;
    public float finalSpeed;
    public bool toggleCameraRotation;
    public bool run;

    public float smoothness = 10f;

    public Rigidbody RB;
    public Animator AN;
    //public SpriteRenderer SR;
    public PhotonView PV;
    public Text NickNameText;
    //public Image HealthImage;
    Vector3 curPos;

    bool isJump;

    public GameObject BBADDA, ABox;
    public Material[] Sky;

    public GameObject Light, Neon;



    void Awake()
    {
        //animator = this.GetComponent<Animator>();
        camera = Camera.main;
        //rigid = this.GetComponent<Rigidbody>();

        NickNameText.text = PV.IsMine ? PhotonNetwork.NickName : PV.Owner.NickName;
        NickNameText.color = PV.IsMine ? Color.green : Color.red;



        Light = GameObject.Find("Directional Light");
        Neon = GameObject.Find("NeonOBJ");

        Neon.SetActive(false);
    }

    void Update()
    {
        if (PV.IsMine)
        {
            if (Input.GetKey(KeyCode.LeftAlt))
            {
                toggleCameraRotation = true;        // 둘러보기 활성화
            }
            else
            {
                toggleCameraRotation = false;       // 둘러보기 비활성화
            }
            if (Input.GetKey(KeyCode.LeftShift))
            {
                run = true;
            }
            else
            {
                run = false;
            }
            Move();

            if (Input.GetKeyDown(KeyCode.F))
            {
                Smoke();
            }
            if (Input.GetKeyDown(KeyCode.Space) && PV.IsMine && !isJump)
            {
                PV.RPC("JumpRPC", RpcTarget.All);
                isJump = true;
            }
            if (Input.GetKey(KeyCode.Q))
            {
                PV.RPC("BBADDARPC", RpcTarget.All);

            }

            Ray ray = camera.ScreenPointToRay(Input.mousePosition);
            RaycastHit rayhit;
            int floorMask = LayerMask.GetMask("Floor");
            if (Physics.Raycast(ray, out rayhit, 100))
            {
                Debug.DrawRay(transform.position, transform.forward * 100f, Color.red);
                if (Input.GetKeyDown(KeyCode.E))
                {

                    Vector3 nextVec = rayhit.point - transform.position;
                    nextVec.y = 6;

                    PhotonNetwork.Instantiate("RedBean", transform.position, Quaternion.identity)
                        .GetComponent<PhotonView>().RPC("DirRPC", RpcTarget.All, nextVec);
                }
            }
            //Debug.Log("콩");
            //if (Physics.Raycast(ray, out rayhit, 100, floorMask))
            //{
            //    Vector3 nextVec = rayhit.point - transform.position;
            //    nextVec.y = 6;

            //    GameObject instantRedBean = PhotonNetwork.Instantiate("RedBean", transform.position, transform.rotation);
            //    Rigidbody rigidBean = instantRedBean.GetComponent<Rigidbody>();
            //    rigidBean.AddForce(nextVec, ForceMode.Impulse);
            //}

        }

        if(Input.GetKeyDown(KeyCode.J))
        {
            PV.RPC("NightRPC", RpcTarget.All);
        }

        if (Input.GetKeyDown(KeyCode.K))
        {
            PV.RPC("DayRPC", RpcTarget.All);
        }
        if (Input.GetKeyDown(KeyCode.L))
        {
            PV.RPC("CountDownRPC", RpcTarget.All);
        }
        if (Input.GetKeyDown(KeyCode.N))
        {
            PV.RPC("NRPC", RpcTarget.All);
        }
        if (Input.GetKeyDown(KeyCode.M))
        {
            PV.RPC("DRPC", RpcTarget.All);
        }
    }

    [PunRPC]
    void NRPC()
    {
        Light.SetActive(false);
        Neon.SetActive(true);
        RenderSettings.skybox = Sky[0];
        //SoundManager.instance.Play();
    }
    [PunRPC]
    void DRPC()
    {
        Light.SetActive(true);
        Neon.SetActive(false);
        RenderSettings.skybox = Sky[1];
        //SoundManager.instance.Play();
    }



    [PunRPC]
    void NightRPC()
    {
        //GameObject light = GameObject.Find("Player").gameObject;
        //GameObject.Find("Directional Light").gameObject.SetActive(false);
        //GameObject.Find("NeonOBJ").gameObject.SetActive(true);
        //GameObject.Find("Camera").AddComponent<Skybox>().material = Sky[0];

        //Light.SetActive(false);
        //Neon.SetActive(true);
        //RenderSettings.skybox = Sky[0];
        StartCoroutine(NN());
    }
    [PunRPC]
    IEnumerator NN()
    {
        SoundManager.instance.Play();
        yield return new WaitForSeconds(3);
        GameObject.Find("countdownumber").GetComponent<CountDownn>().CountStart();
        //CountDownn.instance.CountStart();
        yield return new WaitForSeconds(12);
        Light.SetActive(false);
        Neon.SetActive(true);
        RenderSettings.skybox = Sky[0];
        SoundManager.instance.Play();
    }


    [PunRPC]
    void DayRPC()
    {
        //GameObject light = GameObject.Find("Player").gameObject;
        //GameObject.Find("Directional Light").gameObject.SetActive(true);
        //GameObject.Find("NeonOBJ").gameObject.SetActive(false);
        //GameObject.Find("Camera").AddComponent<Skybox>().material = Sky[1];

        //Light.SetActive(true);
        //Neon.SetActive(false);
        //RenderSettings.skybox = Sky[1];
        StartCoroutine(DD());
    }
    [PunRPC]
    IEnumerator DD()
    {
        SoundManager.instance.Play();
        yield return new WaitForSeconds(3);
        GameObject.Find("countdownumber").GetComponent<CountDownn>().CountStart();
        //CountDownn.instance.CountStart();
        yield return new WaitForSeconds(12);
        Light.SetActive(true);
        Neon.SetActive(false);
        RenderSettings.skybox = Sky[1];
        SoundManager.instance.Play();
    }

    [PunRPC]
    void BBADDARPC()
    {
        AN.SetTrigger("BBADDA");

        StartCoroutine(ATK());
        //PV.RPC("ATK", RpcTarget.All);
    }
    [PunRPC]
    IEnumerator ATK()
    {
        BBADDA.SetActive(true);
        yield return new WaitForSeconds(1.3f);
        ABox.SetActive(true);
        yield return new WaitForSeconds(0.42f);
        ABox.SetActive(false);
        yield return new WaitForSeconds(0.4f);
        if (!NetworkManager.instance.doke)
            BBADDA.SetActive(false);
    }
    [PunRPC]
    void CountDownRPC()
    {
        StartCoroutine(Count());
    }
    [PunRPC]
    IEnumerator Count()
    {
        SoundManager.instance.Play();
        yield return new WaitForSeconds(3);
        GameObject.Find("countdownumber").GetComponent<CountDownn>().CountStart();
        //CountDownn.instance.CountStart();
        yield return new WaitForSeconds(12);
        SoundManager.instance.Play();
    }

    void LateUpdate()
    {
        if (toggleCameraRotation != true && PV.IsMine)
        {
            Vector3 playerRotate = Vector3.Scale(camera.transform.forward, new Vector3(1, 0, 1));
            transform.rotation = Quaternion.Slerp(transform.rotation, Quaternion.LookRotation(playerRotate), Time.deltaTime * smoothness);
        }
    }
    void Smoke()
    {
        //PhotonNetwork.Instantiate("SmokeGrenade", transform.position, Quaternion.identity);
    }

    void Move()
    {
        if (PV.IsMine)
        {
            finalSpeed = (run) ? runSpeed : speed;

            Vector2 moveInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
            bool isMove = moveInput.magnitude != 0;   // moveInput이 0이면 이동입력이 없는것

            if (isMove)
            {
                Vector3 forward = transform.TransformDirection(Vector3.forward);
                Vector3 right = transform.TransformDirection(Vector3.right);
                Vector3 moveDirection = forward * moveInput.y + right * moveInput.x;

                transform.position += moveDirection * Time.deltaTime * 5f;

                //RB.AddForce(moveDirection * 3);

                float percent = ((run) ? 1 : 0.5f) * moveDirection.magnitude;
                AN.SetFloat("Blend", percent, 0.1f, Time.deltaTime);

            }
        }
        else if ((transform.position - curPos).sqrMagnitude >= 100) transform.position = curPos;
        else transform.position = Vector3.Lerp(transform.position, curPos, Time.deltaTime * 10);
    }

    [PunRPC]
    void JumpRPC()
    {
        //RB.velocity = Vector3.zero;
        RB.AddForce(Vector3.up * 400);
    }

    void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Floor")
        {
            isJump = false;
        }
        //if(collision.gameObject.tag == "BBADDA")
        //{
        //    AN.SetTrigger("Hit");
        //    Debug.Log("Hit");
        //}
    }

    private void OnTriggerEnter(Collider other)
    {
        if (other.gameObject.tag == "BBADDA")
        {
            AN.SetTrigger("Hit");
            Debug.Log("Hit");
        }
    }

    public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
    {
        if (stream.IsWriting)
        {
            stream.SendNext(transform.position);
        }
        else
        {
            curPos = (Vector3)stream.ReceiveNext();

        }
    }
}
