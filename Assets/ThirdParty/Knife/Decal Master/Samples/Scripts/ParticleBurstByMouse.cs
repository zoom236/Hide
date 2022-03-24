using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.UI;

public class ParticleBurstByMouse : MonoBehaviour
{
    public ParticleSystem TargetSystem;

    private void Update()
    {
        bool shift = Input.GetKey(KeyCode.LeftShift);
        if ((Input.GetMouseButtonDown(0) && !shift) || (Input.GetMouseButton(0) && shift))
        {
            EmitBurst();
        }
    }

    private void EmitBurst()
    {
        TargetSystem.Emit(30);
    }
}
