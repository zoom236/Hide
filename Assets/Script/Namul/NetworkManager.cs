using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using Photon.Pun;
using Photon.Realtime;
using UnityEngine.UI;

public class NetworkManager : MonoBehaviourPunCallbacks
{
    public static NetworkManager instance;
    public InputField NicnNameInput;
    public GameObject DisconnectPanel;
    public GameObject RespawnPanel;
    public Transform SpawnPos;
    public GameObject main;
    public bool doke;

    private void Awake()
    {
        instance = this;
        Screen.SetResolution(1920, 1080, false);
        PhotonNetwork.SendRate = 60;
        PhotonNetwork.SerializationRate = 30;
    }

    public void children()
    {
        Connect();
    }

    public void dokebi()
    {
        doke = true;
        Connect();
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

    IEnumerator DestroyBullet()
    {
        yield return new WaitForSeconds(0.2f);
        foreach (GameObject GO in GameObject.FindGameObjectsWithTag("RedBean")) GO.GetComponent<PhotonView>().RPC("DestroyRPC", RpcTarget.All);
    }


    void Update()
    {
        if (Input.GetKeyDown(KeyCode.P) && PhotonNetwork.IsConnected)
            PhotonNetwork.Disconnect();
    }

    public void Spawn()
    {
        main.SetActive(false);
        if (!doke)
        {
            PhotonNetwork.Instantiate("Player", SpawnPos.position, Quaternion.identity);
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }
        else
        {
            PhotonNetwork.Instantiate("Enemy", SpawnPos.position, Quaternion.identity);
            Cursor.lockState = CursorLockMode.Locked;
            Cursor.visible = false;
        }
        RespawnPanel.SetActive(false);
    }

    public override void OnDisconnected(DisconnectCause cause)
    {
        DisconnectPanel.SetActive(true);
        RespawnPanel.SetActive(false);
        main.SetActive(true);
    }
}
