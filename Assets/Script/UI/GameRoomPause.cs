using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.EventSystems;
using UnityEngine.SceneManagement;

public class GameRoomPause : MonoBehaviour
{
    // Start is called before the first frame update

    public static bool GameIsPaused = false; //������ �Ͻ� �����Ǿ� �ִ��� ���� Ȯ��

    public GameObject pauseMenuUI;

    private void Update()
    {

        if (Input.GetKeyDown(KeyCode.Escape))
        {
            if (GameIsPaused)
            {
                Resume();
            }
            else
            {
                Exit();
            }
        }
    }

    void Resume()
    {
        pauseMenuUI.SetActive(false);
        Time.timeScale = 1f;
        GameIsPaused = false;
    }

    void Exit()

    {
        pauseMenuUI.SetActive(true);
        Time.timeScale = 0f;
        GameIsPaused = true;
    }


    public void Click()
    {
        SceneManager.LoadScene(1);
    }




 



}
