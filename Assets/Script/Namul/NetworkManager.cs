using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine.UI;

public class NetworkManager : MonoBehaviourPunCallbacks
{
    public InputField NicnNameInput;
    public GameObject DisconnectPanel;
    public GameObject RespawnPanel;
    public Transform SpawnPos;
    public GameObject main;

    private void Awake()
    {
        Screen.SetResolution(960, 540, false);
        PhotonNetwork.SendRate = 60;
        PhotonNetwork.SerializationRate = 30;
    }

    public void Connect() => PhotonNetwork.ConnectUsingSettings();

    public override void OnConnectedToMaster()
    {
        PhotonNetwork.LocalPlayer.NickName = NicnNameInput.text;
        PhotonNetwork.JoinOrCreateRoom("Room", new RoomOptions { MaxPlayers = 6 }, null);
    }

    public override void OnJoinedRoom()
    {
        DisconnectPanel.SetActive(false);
        Spawn();
        main.SetActive(false);
    }

    void Update()
    {
        if (Input.GetKeyDown(KeyCode.P) && PhotonNetwork.IsConnected)
            PhotonNetwork.Disconnect();
    }

    public void Spawn()
    {
        PhotonNetwork.Instantiate("Player", SpawnPos.position , Quaternion.identity);
        RespawnPanel.SetActive(false);
        main.SetActive(false);
    }

    public override void OnDisconnected(DisconnectCause cause)
    {
        DisconnectPanel.SetActive(true);
        RespawnPanel.SetActive(false);
        main.SetActive(true);
    }
}
