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
    public Toggle windowscreenBtn;

    int resolutionNum;

  
    public void Start()
    {
        InitUI();
    }

    void InitUI()
    {


        int setWidth = 1920;
        int setHeight = 1080;

        Screen.SetResolution(setWidth, setHeight, true);

        //        Resolution.[i] = Screen.SetResolution(1920, 1080, true);


        //        for (int i = 0; i < screen.resolutions.length; i++)
        //        {

        //            if (screen.resolutions[i].refreshrate == 60)
        //                resolutions.add(screen.resolutions[i]);

        //        }


        //        resoultionDropdown.options.Clear();  // 옵션 리스트 클리어

        //            int optionNum = 0;

        //        foreach (Resolution item in resolutions)
        //        {
        //            Dropdown.OptionData option = new Dropdown.OptionData();
        //            option.text = item.width + " x " + item.height;      //옵션 해상도 출력
        //            resoultionDropdown.options.Add(option);    //옵션 추가


        //            if (item.width == Screen.width && item.height == Screen.height)      //스크린 가로 세로 같을 때

        //                resoultionDropdown.value = optionNum;     //
        //            optionNum++;
        //        }

        //        resoultionDropdown.RefreshShownValue();

        //        fullscreenBtn.isOn = Screen.fullScreenMode.Equals(FullScreenMode.FullScreenWindow) ? true : false;

        //    }


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

