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

    void Awake()
    {
        //animator = this.GetComponent<Animator>();
        camera = Camera.main;
        //rigid = this.GetComponent<Rigidbody>();

        NickNameText.text = PV.IsMine ? PhotonNetwork.NickName : PV.Owner.NickName;
        NickNameText.color = PV.IsMine ? Color.green : Color.red;
    }

    void Update()
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
        if(Input.GetKeyDown(KeyCode.Space)&&PV.IsMine&& !isJump)
        {
            PV.RPC("JumpRPC", RpcTarget.All);
            isJump = true;
        }
    }
    [PunRPC]
    void JumpRPC()
    {
        //RB.velocity = Vector3.zero;
        RB.AddForce(Vector3.up * 400);
    }

    void LateUpdate()
    {
        if (toggleCameraRotation != true&&PV.IsMine)
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


    void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Floor")
        {
            isJump = false;
        }
    }

    public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
    {
        if(stream.IsWriting)
        {
            stream.SendNext(transform.position);
        }
        else
        {
            curPos = (Vector3)stream.ReceiveNext();

        }
    }
}
