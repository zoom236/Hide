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
        //startButton.onClick.AddListener(JoinRoom);     //���۹�ư Ŭ�� �� �� ����
        OnLogin(); //OnLogin() �Լ� ȣ��
    }

    void OnLogin()
    {
       // PhotonNetwork.ConnectUsingSettings();  //�����Ʈ��ũ ���� ����
        //startButton.interactable = false;
        //StatusText.text = "������ ������ ������";

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
