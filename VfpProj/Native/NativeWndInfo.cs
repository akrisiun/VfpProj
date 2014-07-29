using System;
using System.Collections.Generic;
using VfpProj.Native;

namespace VfpInterop
{

    public class NativeWndInfo
    {
        public IntPtr ptr;
        public string text;
        public string cls;
        public string item;

        public NativeWndInfo(IntPtr ptr)
        {
            this.ptr = ptr;
            item = ptr.ToString("X8");

            text = NativeMethods.GetWindowText(ptr);
            cls = NativeMethods.GetClassName(ptr);
        }

    }

}
