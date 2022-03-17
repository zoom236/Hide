using System.Collections;
using System.Collections.Generic;
using UnityEditor;
using UnityEngine;

namespace Knife.Tools
{
    [CustomEditor(typeof(DecalTemplatesKit))]
    public class DecalTemplatesKitEditor : Editor
    {
        public override bool RequiresConstantRepaint()
        {
            return true;
        }
    }
}