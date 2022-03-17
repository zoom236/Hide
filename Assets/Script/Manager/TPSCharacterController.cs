using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class TPSCharacterController : MonoBehaviour
{
    [SerializeField]
    private Transform characterBody;
    [SerializeField]
    private Transform cameraArm;

    Animator animator;

    private int toggleView = 3; // 1=1ÀÎÄª, 3=3ÀÎÄª

    private Rigidbody rigid;

    public float speed;

    public GameObject[] grenades;
    public int hasGrenades;
    public GameObject grenadeObj;
    public Camera followCamera;
   

    bool wDown;
    bool jDown;
    bool gDown;
    bool isJump;

    //public int hasGrenades;
    public int maxHasGrenades;


    // Start is called before the first frame update
    void Awake()
    {
        rigid = GetComponent<Rigidbody>();
        animator = GetComponentInChildren<Animator>();
    }

    // Update is called once per frame
    void Update()
    {
        LookAround();
        Move();
        GetInput();
        Jump();
        Grenade();
    }

    void GetInput()
    {
        wDown = Input.GetButton("Walk");
        jDown = Input.GetButtonDown("Jump");
        gDown = Input.GetButtonDown("Fire2");
    }

    private void Move()
    {
        Vector2 moveInput = new Vector2(Input.GetAxis("Horizontal"), Input.GetAxis("Vertical"));
        bool isMove = moveInput.magnitude != 0;



        animator.SetBool("isRun", isMove);
        animator.SetBool("isWalk", wDown);

        if (isMove)
        {
            Vector3 lookForward = new Vector3(cameraArm.forward.x, 0f, cameraArm.forward.z).normalized;
            Vector3 lookRight = new Vector3(cameraArm.right.x, 0f, cameraArm.right.z).normalized;
            Vector3 moveDir = lookForward * moveInput.y + lookRight * moveInput.x;

            characterBody.forward = moveDir;
            //characterBody.forward = lookForward;
            transform.position += moveDir * Time.deltaTime * 5f;

            transform.position += moveDir * 10f * (wDown ? 0.3f : 1f) * Time.deltaTime;
        }
        //Debug.DrawRay(cameraArm.position, new Vector3(cameraArm.forward.x, 0f, cameraArm.forward.z).normalized, Color.red);
    }

    private void LookAround()
    {
        Vector2 mouseDelta = new Vector2(Input.GetAxis("Mouse X"), Input.GetAxis("Mouse Y"));
        Vector3 camAngle = cameraArm.rotation.eulerAngles;
        float x = camAngle.x - mouseDelta.y;

        if (x < 180f)
        {
            x = Mathf.Clamp(x, -1f, 70f);
        }
        else
        {
            x = Mathf.Clamp(x, 355f, 361f);
        }

        cameraArm.rotation = Quaternion.Euler(x, camAngle.y + mouseDelta.x, camAngle.z);

    }

    private void Jump()
    {
        if (jDown && !isJump)
        {
            rigid.AddForce(Vector3.up * 20, ForceMode.Impulse);
            animator.SetBool("isJump", true);
            animator.SetTrigger("doJump");
            isJump = true;
        }
    }

    void Grenade()
    {
       if(hasGrenades == 0)
        {
            return;
        }

        if(gDown)
        {

            Ray ray = followCamera.ScreenPointToRay(Input.mousePosition);
            RaycastHit rayHit;

            if(Physics.Raycast(ray, out rayHit, 100))
            {
                Vector3 nextVec = rayHit.point - transform.position;
                nextVec.y = 10;

                GameObject instantGrenade = Instantiate(grenadeObj, transform.position, transform.rotation);
                Rigidbody rigidGrenade = instantGrenade. GetComponent<Rigidbody>();
                rigidGrenade.AddForce(nextVec, ForceMode.Impulse);
                rigidGrenade.AddTorque(Vector3.back * 10,  ForceMode.Impulse);

                hasGrenades--;
                grenades[hasGrenades].SetActive(false);
            }
            
        }
    }

    void OnCollisionEnter(Collision collision)
    {
        if (collision.gameObject.tag == "Floor")
        {
            animator.SetBool("isJump", false);
            isJump = false;
        }
    }

    void OnTriggerEnter(Collider other)
    {
        if (other.tag == "Item")
        {
            Item2 item = other.GetComponent<Item2>();
            switch (item.type)
            {
                case Item2.Type.Grenade:
                    grenades[hasGrenades].SetActive(true);
                    hasGrenades += item.value;
                    if (hasGrenades > maxHasGrenades)
                        hasGrenades = maxHasGrenades;
                    break;

            }
            Destroy(other.gameObject);
        }
    }
}
