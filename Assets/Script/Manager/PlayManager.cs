using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class PlayManager : MonoBehaviour
{
    public static PlayManager instance { get; private set; }
    private void Awake() =>  instance = this;

    delegate void GameStart();
    GameStart GS;

    delegate int Calculator<T>(T start, T end);
    Calculator<int> PERCENT, PICK, SELECT; 

    static class YieldCash
    {
        public static readonly WaitForEndOfFrame EOF = new WaitForEndOfFrame();
        public static readonly WaitForFixedUpdate FixdUpdate = new WaitForFixedUpdate();
        public static readonly WaitForSeconds Seconds001 = new WaitForSeconds(0.1f);
        public static readonly WaitForSeconds Seconds01 = new WaitForSeconds(1);
    }


    //코루틴


    //외부참조


}
