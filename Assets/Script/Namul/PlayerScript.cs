using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine.UI;

public class PlayerScript : MonoBehaviourPunCallbacks, IPunObservable
{
    Animator animator;
    Camera camera;
    Rigidbody rigid;

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

    void Awake()
    {
        animator = this.GetComponent<Animator>();
        camera = Camera.main;
        rigid = this.GetComponent<Rigidbody>();

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
    }


    void LateUpdate()
    {
        if (toggleCameraRotation != true)
        {
            Vector3 playerRotate = Vector3.Scale(camera.transform.forward, new Vector3(1, 0, 1));
            transform.rotation = Quaternion.Slerp(transform.rotation, Quaternion.LookRotation(playerRotate), Time.deltaTime * smoothness);
        }
    }
    void Smoke()
    {
        PhotonNetwork.Instantiate("SmokeGrenade", transform.position, Quaternion.identity);
    }

    void Move()
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

            float percent = ((run) ? 1 : 0.5f) * moveDirection.magnitude;
            animator.SetFloat("Blend", percent, 0.1f, Time.deltaTime);
        }
    }

    public void OnPhotonSerializeView(PhotonStream stream, PhotonMessageInfo info)
    {
        throw new System.NotImplementedException();
    }
}
