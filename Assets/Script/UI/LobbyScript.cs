using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class LobbyScript : MonoBehaviour
{
    // Start is called before the first frame update
  

    public void LobbyScriptBtn()
    {
        switch (this.gameObject.name)
        {
                case "RoomMakeBtn":
                SceneManager.LoadScene("GameRoom");
                break;

                        case "StoreBtn":
                            SceneManager.LoadScene("StoreScene");
                            break;

            case "StoreExit":
                SceneManager.LoadScene("LobbyUI");
                break;
                    }
                }
        }
 
