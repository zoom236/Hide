using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class NetworkManager : MonoBehaviour
{


    // Start is called before the first frame update
    void  Awake()
    {

    }


    private void Start()
    {
        //startButton.onClick.AddListener(JoinRoom);     //시작버튼 클릭 시 방 입장
        OnLogin(); //OnLogin() 함수 호출
    }

    void OnLogin()
    {
       // PhotonNetwork.ConnectUsingSettings();  //포톤네트워크 연결 세팅
        //startButton.interactable = false;
        //StatusText.text = "마스터 서버에 접속중";

    }








}


/*
public InputField ChatInput;
public GameObject chatPanel, chatView;
public PhotonView PV;

private Text[] chatList;

void Awake()
{
    PhotonNetwork.AutomaticallySyncScene = true;
}

private void Start()
{
    chatList = chatView.GetComponentsInChildren<Text>();
*/
