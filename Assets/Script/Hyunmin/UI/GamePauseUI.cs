using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class GamePauseUI : MonoBehaviour
{

    [SerializeField]
    private ItemButtonUI itemButtonUI;
    public ItemButtonUI ItemButtonUI { get { return ItemButtonUI; } }


    // Start is called before the first frame update

    public static bool GameIsPaused = false; //게임이 일시 중지되어 있는지 여부 확인

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
