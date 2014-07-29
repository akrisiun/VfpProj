using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Runtime;
using System.Runtime.InteropServices;

namespace VfpProj.Native
{
    public class NativeMethods
    {
        public delegate int EnumWindowsProc(IntPtr hwnd, int lParam);

        [DllImport("user32")]
        public extern static int EnumWindows(
            EnumWindowsProc lpEnumFunc, int lParam);

        [DllImport("user32")]
        public extern static int EnumChildWindows(
            IntPtr hWndParent, EnumWindowsProc lpEnumFunc, int lParam);

        [DllImport("user32.dll", SetLastError = true)]
        public static extern bool BringWindowToTop(IntPtr hWnd);

        [DllImport("user32.dll")]
        public static extern IntPtr SetFocus(IntPtr hWnd);

        [DllImport("user32.dll")]
        [return: MarshalAs(UnmanagedType.Bool)]
        public static extern bool IsWindowVisible(IntPtr hWnd);

        [DllImport("user32.dll")]
        public static extern IntPtr GetForegroundWindow();

        static private int WindowEnum(IntPtr hWnd, int lParam)
        {
            if (OnWindowEnum(hWnd))
            {
                return 1;
            }
            else
            {
                return 0;
            }
        }

        static bool OnWindowEnum(IntPtr hWnd)
        {
            items.Add(hWnd);
            return true;
        }

        [DllImport("user32.dll", SetLastError = true, CharSet = CharSet.Auto)]
        static extern int GetClassName(IntPtr hWnd, System.Text.StringBuilder lpClassName, int nMaxCount);

        [DllImport("user32.dll", CharSet = CharSet.Auto, SetLastError = true)]
        static extern int GetWindowText(IntPtr hWnd, System.Text.StringBuilder lpString, int nMaxCount);

        public static string GetClassName(IntPtr hWnd)
        {
            System.Text.StringBuilder ClassName = new System.Text.StringBuilder(256);
            int nRet = GetClassName(hWnd, ClassName, ClassName.Capacity);
            if (nRet != 0)
                return ClassName.ToString();

            return string.Empty;
        }

        public static string GetWindowText(IntPtr hWnd)
        {
            System.Text.StringBuilder WindowName = new System.Text.StringBuilder(256);
            int nRet = GetWindowText(hWnd, WindowName, WindowName.Capacity);
            if (nRet != 0)
                return WindowName.ToString();

            return string.Empty;
        }

        static System.Collections.ObjectModel.Collection<IntPtr> items;
        /// 
        public static System.Collections.ObjectModel.Collection<IntPtr> GetWindows()
        {
            items = new System.Collections.ObjectModel.Collection<IntPtr>();
            // EnumWindows(new EnumWindowsProc(WindowEnum), 0);
            
            // EnumChildWindows(Program.nativeWindow.Handle, new EnumWindowsProc(WindowEnum), 0);
            return items;
        }

    }

}
