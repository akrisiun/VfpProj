
using System;
using System.Collections;
using System.Collections.Generic;
// using System.Configuration;
using System.Diagnostics;
using System.IO;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
using System.Security;

// NETFRAMEWORK;NET40

namespace VfpConsole
{
#if NET40
    using System.Runtime.Versioning;
#endif

    public class VfpConsole
    {
        public static string[] Args { get => Environment.GetCommandLineArgs(); }
#if NET40
        // using System.Runtime.Versioning;
        public static bool Is64bit { get => Environment.Is64BitProcess; }
        public static bool Is64BitOperatingSystem { get => Environment.Is64BitOperatingSystem; }
#endif
        public static OperatingSystem OperatingSystem { get => Environment.OSVersion; }

        public static object VfpObj { get; set; }

        public static void Main()
        {
            Console.WriteLine("Hello C# with VFP");
            Exception err = null;

#if NET40
            Console.WriteLine($"Is64bit={Is64bit}, OperatingSystem={OperatingSystem}");
#endif
            var domain = AppDomain.CurrentDomain;
            var setup = domain.SetupInformation;
            var getTargetNetworkName = setup.GetType().GetProperty("TargetFrameworkName", 
                BindingFlags.Public | BindingFlags.Instance);
            object TargetNetworkName = getTargetNetworkName?.GetValue(setup, new object[] { }) ?? "";
            Console.WriteLine($"Domain ConfigurationFile={setup.ConfigurationFile} " +
                 $"\nTargetNetworkName={TargetNetworkName}");

            // Could not load file or assembly 'Interop.VisualFoxpro, Version=8.0.0.0, Culture=neutral, PublicKeyToken=null' 
            try
            {
                VfpObj = Vfp.Startup.Instance.LoadVfp();
                Console.WriteLine("Loaded? {VfpConsole}");
            } catch (Exception ex) { err = ex.InnerException ?? ex; }

            if (err != null)
                Console.WriteLine($"Error: {err}");

            Console.ReadKey();
        }
    }
}

namespace Vfp
{
    // using VfpProj;
    using IFoxApplication = IDictionary<string, object>;

    public interface ILastError {
        Exception LastError { get; set; }
    }

    public class Startup : ILastError, IDisposable
    {
        static Startup()
        {
            Instance = new Startup();
        }

        public static Startup Instance { get; private set; }
        public static IntPtr ThreadId { get; private set; }

        public static string BaseDirectory { get => AppDomain.CurrentDomain.BaseDirectory; }

        public Exception LastError { get; set; }
        internal SafeLibraryHandle? Vfp8R { get; set; }

        public void Dispose()
        {
            App = null;
            Vfp8R?.Dispose();
            Vfp8R = null;
        }

        // public VisualFoxpro.FoxApplication App { get; set; }
        public IFoxApplication App { get; set; }
        public static Assembly AsmOle { get; private set; }

        public object LoadVfp()
        {
            LastError = null;
            try
            {
                ThreadId = SafeLibraryHandle.Win32.GetCurrentThreadId();
                Console.Write($"ThreadId=0x{ThreadId.ToString("X8")}  ");

                string dll = Path.Combine(BaseDirectory, "vfp8r.dll");
                Console.Write(dll);
                Vfp8R = SafeLibraryHandle.Win32.LoadLibrary(dll);

                Console.WriteLine($" Vfp8R.handle={Vfp8R}");

                dll = Path.Combine(BaseDirectory, "VfpOleLib.dll");
                Console.Write(dll);
                if (File.Exists(dll))
                    AsmOle = Assembly.LoadFrom(dll);
                if (AsmOle != null)
                    Console.Write($" Ole OK\n");
                else 
                    Console.WriteLine($" \nfailed: Assembly.LoadFrom(\"{dll}\") ");

                dll = Path.Combine(BaseDirectory, "Interop.VisualFoxpro.dll");
                Console.Write(dll);
                var asm = Assembly.LoadFrom(dll);
                Console.WriteLine($" Interop.VisualFoxpro={asm}");

            } catch (Exception ex) {
                LastError = ex;
                Console.WriteLine($"{ex.InnerException ?? ex}");
                // return App;
            }

            // var asmList = AppDomain.CurrentDomain.GetAssemblies();
            // var types = AsmOle.GetExportedTypes();

            if (AsmOle == null)
                throw new Exception("VfpOleLib.dll error");

            var FoxCmd = AsmOle?.GetType("VfpProj.FoxCmd");
            if (FoxCmd == null)
                throw new Exception("VfpOleLib.dll type VfpProj.FoxCmd error");

            var attach = FoxCmd.GetMethod("Attach", BindingFlags.Static | BindingFlags.Public);

            attach.Invoke(null, new object[] { false });
            var FoxApp = FoxCmd.GetProperty("App", BindingFlags.Static | BindingFlags.Public);

            var appObj = FoxApp.GetValue(null, new object[] { });
            App = appObj as IFoxApplication;
            // App = FoxCmd.App;
            // FoxCmd.DebugObj(App);

            var properties = App.GetType().GetProperties();

            Console.WriteLine($"[Properties]: ");
            foreach (var prop in properties)
            {
                if (prop.Name == "Keys" || prop.Name == "Values" || prop.Name == "Item" || prop.Name == "Comparer")
                    continue;

                Console.Write($"{prop.Name}=");
                string value = prop.GetValue(App, new object[] { })?.ToString() ?? "-";
                Console.WriteLine($"{value}");
            }

            Console.WriteLine($"[Dictionary]: ");
            var GetEnumerator = App.GetType().GetMethod("GetEnumerator", BindingFlags.Public | BindingFlags.Instance); 
            //  | BindingFlags.FlattenHierarchy);
            var x = App.GetType().GetMethods();
            var n = GetEnumerator.Invoke(App, new object[] { }) as IEnumerator;
            while (n.MoveNext())
            {
                var item = n.Current;
                var pair = (KeyValuePair<string, object>)item;
                Console.WriteLine($"{pair.Key}={pair.Value?.ToString() ?? ""}");
            }

            //  App = FoxCmd.App as IFoxApplication;
            return App;
        }
    }

    [DebuggerDisplay("{Handle.ToString(\"X8\")}h")]
    public struct SafeLibraryHandle : IDisposable
    {
        internal class Win32
        {
            const string KERNEL32 = "kernel32.dll";

            [DllImport(KERNEL32, ExactSpelling = false, SetLastError = true)] // , CharSet = CharSet.Unicode)]
            //[ResourceExposure(ResourceScope.Machine)]
            [SuppressUnmanagedCodeSecurity][SecurityCritical]
            internal static extern SafeLibraryHandle LoadLibrary(String libPath);

            [DllImport(KERNEL32, ExactSpelling = true, CallingConvention = CallingConvention.StdCall, SetLastError = true)]
            internal static extern IntPtr GetCurrentThreadId();

            [System.Security.SecurityCritical]
            [DllImport(KERNEL32, CallingConvention = CallingConvention.Winapi, SetLastError = true)]
            internal extern static IntPtr GetProcAddress(SafeLibraryHandle hModule, string entryPoint);

            [System.Security.SecurityCritical]
            [DllImport(KERNEL32, CallingConvention = CallingConvention.Winapi, SetLastError = true)]
            internal extern static IntPtr GetProcAddress(IntPtr hModule, string entryPoint);

            [DllImport(KERNEL32, ExactSpelling = true)]
            [SuppressUnmanagedCodeSecurity]
            [SecurityCritical]
            internal static extern bool FreeLibrary(IntPtr moduleHandle);
        }

        public IntPtr Handle { get; set; }

        public bool IsEmpty { get => Handle == IntPtr.Zero; }

        internal SafeLibraryHandle(IntPtr handle)
        {
            Handle = handle;
        }

        public unsafe bool HasFunction(string functionName)
        {
            IntPtr ret = Win32.GetProcAddress(this, functionName);
            return (ret != IntPtr.Zero);
        }

        public void Dispose()
        {
            if (!IsEmpty)
                Win32.FreeLibrary(Handle);
            Handle = IntPtr.Zero;
        }
    }
}


#if !COM
namespace VisualFoxpro
{
    [Guid("00A19612-D8FC-4A3E-A95F-FEA211444BF7")]
    // [CoClass(typeof(FoxApplicationClass))]
    [ComImport]
    public interface FoxApplication : Application
    {
    }

    [TypeLibType(TypeLibTypeFlags.FDual | TypeLibTypeFlags.FDispatchable)]
    [Guid("00A19612-D8FC-4A3E-A95F-FEA211444BF7")]
    [ComImport]
    public interface Application
    {
        [DispId(0)]
        [IndexerName("Name")]
        string this[int idx] { [DispId(0), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(1)]
        string FullName { [DispId(1), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(2)]
        FoxApplication Application { [DispId(2), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(3)]
        object Parent { [DispId(3), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(4)]
        bool Visible { [DispId(4), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(4), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(5)]
        string Version { [DispId(5), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(6)]
        string Caption { [DispId(6), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(6), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(7)]
        string DefaultFilePath { [DispId(7), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(7), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(8)]
        string StatusBar { [DispId(8), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(8), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(9)]
        int Left { [DispId(9), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(9), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(10)]
        int Top { [DispId(10), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(10), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(11)]
        int Width { [DispId(11), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(11), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(12)]
        int Height { [DispId(12), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(12), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(13)]
        bool AutoYield { [DispId(13), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(13), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(14)]
        object ActiveForm { [DispId(14), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        //[DispId(15)]
        //IFoxForms Forms { [DispId(15), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(16)]
        object Objects { [DispId(16), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(24)]
        int OLERequestPendingTimeout { [DispId(24), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(24), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(25)]
        int OLEServerBusyTimeout { [DispId(25), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(25), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(26)]
        bool OLEServerBusyRaiseError { [DispId(26), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(26), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(27)]
        int StartMode { [DispId(27), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        //[DispId(28)]
        //IFoxProject ActiveProject { [DispId(28), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        //[DispId(29)]
        //IFoxProjects Projects { [DispId(29), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(30)]
        string ServerName { [DispId(30), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(31)]
        int ThreadId { [DispId(31), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(32)]
        int ProcessId { [DispId(32), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(33)]
        string EditorOptions { [DispId(33), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(33), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(34)]
        int LanguageOptions { [DispId(34), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(34), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(38)]
        int hWnd { [DispId(38), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(39)]
        string VFPXMLProgId { [DispId(39), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(39), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(17)]
        [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        void DoCmd([MarshalAs(UnmanagedType.BStr), In] string bstrCmd);

        [DispId(18)]
        [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        [return: MarshalAs(UnmanagedType.Struct)]
        object Eval([MarshalAs(UnmanagedType.BStr), In] string bstrExpr);

        [DispId(19)]
        [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        void Quit();

        [DispId(20)]
        [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        [return: MarshalAs(UnmanagedType.Struct)]
        object RequestData([MarshalAs(UnmanagedType.Struct), In, Optional] ref object lpvarWrkArea, [MarshalAs(UnmanagedType.Struct), In, Optional] ref object lpvarNumRows);

        [DispId(21)]
        [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        [return: MarshalAs(UnmanagedType.Struct)]
        object DataToClip([MarshalAs(UnmanagedType.Struct), In, Optional] ref object lpvarWrkArea, [MarshalAs(UnmanagedType.Struct), In, Optional] ref object lpvarNumRows, [MarshalAs(UnmanagedType.Struct), In, Optional] ref object lpvarClipFormat);

        [DispId(22)]
        [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        void SetVar([MarshalAs(UnmanagedType.BStr), In] string bstrVarName,
             [MarshalAs(UnmanagedType.Struct), In] object lpvarNumRows);

    }

}

#endif