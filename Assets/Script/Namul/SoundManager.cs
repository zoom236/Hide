using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class SoundManager : MonoBehaviour
{
    public static SoundManager instance;

    AudioSource audio;

    private void Awake()
    {
        instance = this;
        audio = transform.GetComponent<AudioSource>();
    }

    public void Play()
    {
        audio.Play();
    }

    // Update is called once per frame
    void Update()
    {
        
    }
}
