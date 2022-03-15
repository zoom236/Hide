using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class RouletteController : MonoBehaviour
{
    // Start is called before the first frame update
    

    public GameObject Roulette;   // 실제로 돌아갈 룰렛판
    public Transform Needle;   //거리를 확인하기 위한 바늘
    public GameObject[] DisplayMapScene;

    List<int> StartList = new List<int>();    //랜덤 뽑기를 위한 리스트
    
    int MapCnt = 8;



    void Start()
    {
        for (int i = 0; i < MapCnt; i++)
        {
            StartList.Add(i);               //

        }

        for (int i = 0; i < MapCnt; i++)
        {
            int randomIndex = Random.Range(0, StartList.Count);          //
            
            StartList.RemoveAt(randomIndex);

        }


    }

     void Update()
    {
        if (Input.GetMouseButtonDown(0))
        {
            StartCoroutine(StartRoulette());
        }

    }
    IEnumerator StartRoulette()
    {

        yield return new WaitForSeconds(2f);

        float randomSpd = Random.Range(1.0f, 5.0f);
        float rotateSpeed = 100f * randomSpd;// 회전 속도 초기값

        
            while (true)
            {
                yield return null;
                if (rotateSpeed <= 0.01f) break;  //만약 rotatespeed가 0.01이하이면 멈춤

                rotateSpeed = Mathf.Lerp(rotateSpeed, 0, Time.deltaTime * 2f);    //while문으로 rotatespeed를 Lerp함수로 줄인다
                Roulette.transform.Rotate(0, 0, rotateSpeed);  //z축 회전
            }
            yield return new WaitForSeconds(1f);
            Result();
        
    }

     void Result()
    {
        float closetIndex = 0;
        float closetDis = 500f;
        float currentDis = 0f;

        for(int i = 0; i < MapCnt; i++)
        {
            currentDis = Vector2.Distance(DisplayMapScene[i].transform.position, Needle.position);
            if(closetDis > currentDis)
            {
                closetDis = currentDis;
                closetIndex = i;
            }
        }

        Debug.Log("당첨" + closetIndex);

    }

}

//   void Update()
//  {

// transform.Rotate(0, 0, rotationSpeed);  // 회전 속도만큼 룰렛을 회전
// rotationSpeed *= 0.996f;     //룰렛을 감속시킨다.
//List<int> ResultIndexList = new List<int>(); // 결과 값에 저장할 리스트
//ResultIndexList.Add(StartList[randomIndex]);
// if (Input.GetMouseButtonDown(0))    //클릭하면 회전 속도를 설정
// {
//  rotationSpeed = 10;
// }



/// }
//}
