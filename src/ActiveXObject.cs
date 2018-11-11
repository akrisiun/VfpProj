using System;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Text;
using System.Threading;
using System.Windows.Forms;
using Microsoft.Win32;
using System.Security.Permissions;
using System.Security;
using System.Drawing;

namespace Kosmala.Michal.ActiveXTest
{
    /// <summary>
    /// Summary description for Class1.
    /// </summary>
    [ProgId("ADendrite.OurActiveX"), Guid("121C3E0E-DC6E-45dc-952B-A6617F0FAA32")]
    [ClassInterface(ClassInterfaceType.AutoDual), ComSourceInterfaces(typeof(ControlEvents)), ComVisible(true)]
    public class ActiveXObject : Control, IDisposable, UnsafeNativeMethods.IViewObject // IOleObject
    {
        // __ComObject.

        private string myParam = "Empty";

        public ActiveXObject()
        {
            this.Controls.Add(new TextBox { Text = "text 1" });
            this.Controls.Add(new TextBox { Text = "text 2" });
            this.Controls[0].Top = 30;
            this.Controls[1].Top = 50;
        }

        public event ControlEventHandler OnClose;

        /// <summary>
        /// Opens application. Called from JS
        /// </summary>
        [ComVisible(true)]
        public void Open()
        {
            try
            {
                MessageBox.Show(myParam); //Show param that was passed from JS
                Thread.Sleep(2000); //Wait a little before closing. This is just to show the gap between calling OnClose event.
                Close(); //Close application

            }
            catch (Exception e)
            {
                //ExceptionHandling.AppException(e);
                throw e;
            }
        }

        [ComVisible(true)]
        public void Run()
        {
            (this.Controls[1] as TextBox).Text = "Run";
        }

        [ComVisible(true)]
        public void Stop()
        {
            (this.Controls[1] as TextBox).Text = "Stop";
            Close();
        }

        [ComVisible(true)]
        public string MyParam { get; set; }

        [ComVisible(true)]
        public void Close()
        {
            if (OnClose != null)
            {
                // OnClose("http://otherwebsite.com"); //Calling event that will be catched in JS
                MessageBox.Show("Closing");
            }
            else
            {
                MessageBox.Show("No Event Attached"); //If no events are attached send message.
            }
        }

        #region Registry

        ///	<summary>
        ///	Register the class as a	control	and	set	it's CodeBase entry
        ///	</summary>
        ///	<param name="key">The registry key of the control</param>
        [ComRegisterFunction()]
        public static void RegisterClass(string key)
        {
            // Strip off HKEY_CLASSES_ROOT\ from the passed key as I don't need it
            StringBuilder sb = new StringBuilder(key);
            sb.Replace(@"HKEY_CLASSES_ROOT\", "");

            var subkey = sb.ToString();
            RegistryKey k = null; //  Registry.ClassesRoot.OpenSubKey(key, true);

            try
            {
                k = Registry.ClassesRoot.OpenSubKey(subkey, true);

                RegistryKey ctrl = k.CreateSubKey("Control");
                ctrl.Close();

                // Next create the CodeBase entry	- needed if	not	string named and GACced.
                RegistryKey inprocServer32 = k.OpenSubKey("InprocServer32", true);
                inprocServer32.SetValue("CodeBase", Assembly.GetExecutingAssembly().CodeBase);
                inprocServer32.Close();
                // Finally close the main	key
                k.Close();

                MessageBox.Show("Registered " + subkey);
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.ToString());
            }
        }

        public static void RegisterClass2(string key)
        {
            // Strip off HKEY_CLASSES_ROOT\ from the passed key as I don't need it
            StringBuilder sb = new StringBuilder(key);

            sb.Replace(@"HKEY_CLASSES_ROOT\", "");
            var subkey = sb.ToString();
            var keyToAssertPermissionFor = key;
            RegistryKey k = null;

            new RegistryPermission(RegistryPermissionAccess.Read, keyToAssertPermissionFor).Assert(); // BlessedAssert
            try
            {
                k = Registry.ClassesRoot.OpenSubKey(subkey);
                RegistryPermission.RevertAssert();

                var keyToAssertControl = key + "\\Control";
                new RegistryPermission(RegistryPermissionAccess.AllAccess, keyToAssertControl).Assert(); // BlessedAssert

                RegistryKey ctrl = k.CreateSubKey("Control");
                ctrl.Close();

                var keyToAssertInprocServer32 = key + "\\InprocServer32";
                new RegistryPermission(RegistryPermissionAccess.AllAccess, keyToAssertInprocServer32).Assert(); // BlessedAssert

                // Next create the CodeBase entry	- needed if	not	string named and GACced.
                RegistryKey inprocServer32 = k.OpenSubKey("InprocServer32", true);
                inprocServer32.SetValue("CodeBase", Assembly.GetExecutingAssembly().CodeBase);
                inprocServer32.Close();
                // Finally close the main	key
                k.Close();

                MessageBox.Show("Registered");

            }
            finally
            {
                RegistryPermission.RevertAssert();
            }

        }

        ///	<summary>
        ///	Called to unregister the control
        ///	</summary>
        ///	<param name="key">Tke registry key</param>
        [ComUnregisterFunction()]
        public static void UnregisterClass(string key)
        {
            StringBuilder sb = new StringBuilder(key);
            sb.Replace(@"HKEY_CLASSES_ROOT\", "");

            // Open	HKCR\CLSID\{guid} for write	access
            RegistryKey k = Registry.ClassesRoot.OpenSubKey(sb.ToString(), true);

            // Delete the 'Control'	key, but don't throw an	exception if it	does not exist
            k.DeleteSubKey("Control", false);

            // Next	open up	InprocServer32
            //RegistryKey	inprocServer32 = 
            k.OpenSubKey("InprocServer32", true);

            // And delete the CodeBase key,	again not throwing if missing
            k.DeleteSubKey("CodeBase", false);

            // Finally close the main key
            k.Close();
            MessageBox.Show("UnRegistered");
        }

        #endregion


        public int Draw(int dwDrawAspect, int lindex, IntPtr pvAspect, 
            UnsafeNativeMethods.tagDVTARGETDEVICE ptd, IntPtr hdcTargetDev, IntPtr hdcDraw, UnsafeNativeMethods.COMRECT lprcBounds, UnsafeNativeMethods.COMRECT lprcWBounds, IntPtr pfnContinue, int dwContinue)
        {
            throw new NotImplementedException();
        }

        public int GetColorSet(int dwDrawAspect, int lindex, IntPtr pvAspect,
            UnsafeNativeMethods.tagDVTARGETDEVICE ptd, IntPtr hicTargetDev, UnsafeNativeMethods.tagLOGPALETTE ppColorSet)
        {
            throw new NotImplementedException();
        }

        public int Freeze(int dwDrawAspect, int lindex, IntPtr pvAspect, IntPtr pdwFreeze)
        {
            throw new NotImplementedException();
        }

        public int Unfreeze(int dwFreeze)
        {
            throw new NotImplementedException();
        }

        public void SetAdvise(int aspects, int advf, System.Runtime.InteropServices.ComTypes.IAdviseSink pAdvSink)
        {
            throw new NotImplementedException();
        }

        public void GetAdvise(int[] paspects, int[] advf, System.Runtime.InteropServices.ComTypes.IAdviseSink[] pAdvSink)
        {
            throw new NotImplementedException();
        }
    }

    /// <summary>
    /// Event handler for events that will be visible from JavaScript
    /// </summary>
    public delegate void ControlEventHandler(string redirectUrl);


    /// <summary>
    /// This interface shows events to javascript
    /// </summary>
    [Guid("68BD4E0D-D7BC-4cf6-BEB7-CAB950161E79")]
    [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface ControlEvents
    {
        //Add a DispIdAttribute to any members in the source interface to specify the COM DispId.
        [DispId(0x60020001)]
        void OnClose(string redirectUrl); //This method will be visible from JS
    }

    [SuppressUnmanagedCodeSecurity]
    //internal 
    public static class UnsafeNativeMethods
    {

        [StructLayout(LayoutKind.Sequential)]
        public sealed class tagDVTARGETDEVICE
        {
            [MarshalAs(UnmanagedType.U4)]
            public int tdSize;
            [MarshalAs(UnmanagedType.U2)]
            public short tdDriverNameOffset;
            [MarshalAs(UnmanagedType.U2)]
            public short tdDeviceNameOffset;
            [MarshalAs(UnmanagedType.U2)]
            public short tdPortNameOffset;
            [MarshalAs(UnmanagedType.U2)]
            public short tdExtDevmodeOffset;
        }



        [StructLayout(LayoutKind.Sequential)]
        public class COMRECT
        {
            public int left;
            public int top;
            public int right;
            public int bottom;
            public COMRECT()
            {
            }

            public COMRECT(Rectangle r)
            {
                this.left = r.X;
                this.top = r.Y;
                this.right = r.Right;
                this.bottom = r.Bottom;
            }

            public COMRECT(int left, int top, int right, int bottom)
            {
                this.left = left;
                this.top = top;
                this.right = right;
                this.bottom = bottom;
            }

            public static COMRECT FromXYWH(int x, int y, int width, int height)
            {
                return new COMRECT(x, y, x + width, y + height);
            }

            public override string ToString()
            {
                return string.Concat(new object[] { "Left = ", this.left, " Top ", this.top, " Right = ", this.right, " Bottom = ", this.bottom });
            }
        }

        [StructLayout(LayoutKind.Sequential)]
        public sealed class tagLOGPALETTE
        {
            [MarshalAs(UnmanagedType.U2)]
            public short palVersion;
            [MarshalAs(UnmanagedType.U2)]
            public short palNumEntries;
        }

        public static Guid IID_IViewObject = new Guid("{0000010d-0000-0000-C000-000000000046}");

        [ComImport, Guid("0000010d-0000-0000-C000-000000000046"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
        public interface IViewObject
        {
            [PreserveSig]
            int Draw([In, MarshalAs(UnmanagedType.U4)] int dwDrawAspect, int lindex, IntPtr pvAspect, [In] tagDVTARGETDEVICE ptd, IntPtr hdcTargetDev, IntPtr hdcDraw,
                    [In] COMRECT lprcBounds, [In] COMRECT lprcWBounds, IntPtr pfnContinue, [In] int dwContinue);
            [PreserveSig]
            int GetColorSet([In, MarshalAs(UnmanagedType.U4)] int dwDrawAspect, int lindex, IntPtr pvAspect,
                    [In] tagDVTARGETDEVICE ptd, IntPtr hicTargetDev, [Out] tagLOGPALETTE ppColorSet);
            [PreserveSig]
            int Freeze([In, MarshalAs(UnmanagedType.U4)] int dwDrawAspect, int lindex, IntPtr pvAspect, [Out] IntPtr pdwFreeze);
            [PreserveSig]
            int Unfreeze([In, MarshalAs(UnmanagedType.U4)] int dwFreeze);
            void SetAdvise([In, MarshalAs(UnmanagedType.U4)] int aspects, [In, MarshalAs(UnmanagedType.U4)] int advf, [In, MarshalAs(UnmanagedType.Interface)] System.Runtime.InteropServices.ComTypes.IAdviseSink pAdvSink);
            void GetAdvise([In, Out, MarshalAs(UnmanagedType.LPArray)] int[] paspects, [In, Out, MarshalAs(UnmanagedType.LPArray)] int[] advf, [In, Out, MarshalAs(UnmanagedType.LPArray)] System.Runtime.InteropServices.ComTypes.IAdviseSink[] pAdvSink);
        }
    }

}
