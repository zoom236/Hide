using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class CustomizeUI : MonoBehaviour
{
    //private ImageConversion characterPreview;
    [SerializeField]
    private Image characterPreview;


    [SerializeField]
    private List<ColorSelectButton> colorSelectButtons;

    // Start is called before the first frame update
    void Start()
    {
        var inst = Instantiate(characterPreview.material);
        //characterPreview.material = inst;
        characterPreview.material = inst;




    }

    // Update is called once per frame
    public void UpdateColorButton()
    {
      //  var roomSlots = (NetworkManager.singleton as Am );
    }
}
