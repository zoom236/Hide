using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;
using UnityEngine.UI;

public class MainScript : MonoBehaviour
{

    FullScreenMode screenMode;
    public Toggle fullscreenBtn;
    public Dropdown resoultionDropdown;
    List<Resolution> resolutions = new List<Resolution>();
    int resolutionNum;


    public void Start()
    {
        InitUI();
    }

    void InitUI()
    {

        for (int i = 0; i < Screen.resolutions.Length; i++)
        {

            if (Screen.resolutions[i].refreshRate == 60)
                resolutions.Add(Screen.resolutions[i]);

        }

        resolutions.AddRange(Screen.resolutions);
        resoultionDropdown.options.Clear();

        int optionNum = 0;

        foreach (Resolution item in resolutions)
        {
            Dropdown.OptionData option = new Dropdown.OptionData();
            option.text = item.width + " x " + item.height + " " + item.refreshRate;      //옵션 해상도 표시
            resoultionDropdown.options.Add(option);


            if (item.width == Screen.width && item.height == Screen.height)

                resoultionDropdown.value = optionNum;
            optionNum++;
        }

        resoultionDropdown.RefreshShownValue();

        fullscreenBtn.isOn = Screen.fullScreenMode.Equals(FullScreenMode.FullScreenWindow) ? true : false;

    }


    public void DropboxOptionChange(int x)
    {
        resolutionNum = x;
    }


    public void FullScreenBtn(bool isFull)
    {
        screenMode = isFull ? FullScreenMode.FullScreenWindow : FullScreenMode.Windowed;

    }

    void Click()
    {

        SceneManager.LoadScene(0);

    }

    public void OkBtnClick()
    {
        Screen.SetResolution(resolutions[resolutionNum].width,
        resolutions[resolutionNum].height,
        screenMode);
    }

   


 }

