using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Enemy : MonoBehaviour
{
    public int maxHealth;       // 최대 HP
    public int curHealth;       // 현재 HP

    Rigidbody rigid;
    BoxCollider boxCollider;
    Material mat;

    void Awake()
    {
        rigid = GetComponent<Rigidbody>();
        boxCollider = GetComponent<BoxCollider>();
        mat = GetComponent<MeshRenderer>().material;
    }

    public void HitByRedBean(Vector3 explosionPos)
    {
        curHealth -= 20;
        Vector3 reactVec = transform.position - explosionPos;       // 반작용 방향 구하기
        StartCoroutine(OnDamage(reactVec));
    }

    IEnumerator OnDamage(Vector3 reactVec)
    {
        mat.color = Color.red;
        yield return new WaitForSeconds(0.1f);

        if (curHealth > 0)
        {
            mat.color = Color.white;

            reactVec = reactVec.normalized;                 // 맞은 방향 반대방향으로 넉백
            reactVec += Vector3.up;

            rigid.AddForce(reactVec * 3, ForceMode.Impulse);
        }

        else if (curHealth == 0)            // 죽었을 때
        {
            mat.color = Color.gray;
            gameObject.layer = 11;
            Debug.Log("아이 승리!");

            //Destroy(gameObject, 4);
        }
    }
}
