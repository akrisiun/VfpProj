using System;
using System.Diagnostics;
using System.IO;

namespace VfpBuild
{
    // msbuild /v:m /p:PlatformTarget=x86
    
    // & "C:\bin\Microsoft Visual Studio\2017\BuildTools\MSBuild\15.0\Bin\MSBuild.exe" /v:m  /p:PlatformTarget=x86
    // bin\Debug\net461\DotVfp.exe

    public class VfpBuild
    {
        [STAThread]
        public static void Main(string[] args)
        {
            Console.Write("Vfp build:");
            var pjx = "";
            var exe = "";
            if (Debugger.IsAttached)
                Debugger.Break();

            if (args.Length == 1)
            {
                pjx = args[0] ?? "";
            }
            else if (args.Length >= 2)
            {
                // Console.WriteLine($"arg 1: {args[0]}");
                // Console.WriteLine($"arg 2: {args[1]}");
                if ((args[0] ?? "").Contains(".exe") && args.Length >= 3)
                {
                    pjx = args[1];
                    exe = args[2];
                }
                else
                {
                    pjx = args[0];
                    exe = args[1];
                }
            }

            /*  // TEST
            if (Debugger.IsAttached)
            {
                pjx = @"d:\sanitex\pricesql\pricevfp.pjx";
                exe = "pricevfp2.exe";
            }
            */

            var dir = Environment.CurrentDirectory + @"\";
            if (pjx.IndexOf(":") >= 0)
                pjx = dir + pjx;
            if (pjx.IndexOf("/") >= 0)                
                pjx = pjx.Replace("/", @"\");

            string result = "";
            try 
            {
                Task.Assembly = TaskDll.LoadBuild();

                if (pjx.Length == 0)
                {
                    var files = new DirectoryInfo(dir).GetFiles("*.pjx");
                    if (files.Length == 0)
                        Console.WriteLine($"No pjx at {dir}");
                    else if (files.Length == 1)
                        pjx = files[0].FullName;
                    else 
                        Task.ListFiles($"Found pjx:", files);
                }
                if (pjx.Length == 0 || !File.Exists(pjx)) {
                    Console.WriteLine("Parameters error: no file {pjx}");
                    return;
                }

                if (exe.Length == 0)
                    exe = Path.GetFileNameWithoutExtension(pjx) + ".exe";

                if (exe.IndexOf(".dll") < 0)
                    result = Task.BuildExe(pjx, exe) ?? "failed";
                else 
                    result = Task.BuildDll(pjx, exe) ?? "failed";
                
                Console.Write($"Finished . {result}");
            } 
            catch (FileNotFoundException ex)
            {
                Console.Write($"Load failure Interop.vfpbuild.dll : {ex.Message}.");
            }
        }
    }

}

namespace VfpBuild
{
    using System.Collections.Generic;
    using System.Reflection;
    using System.Runtime.InteropServices;
    using vfpbuild;
    using VisualFoxpro;

    public class TaskDll
    {
        public static Exception LastError { get; set; }
        public static Assembly LoadBuild()
        {
            if (Task.Assembly != null)
                return Task.Assembly;

            string path = "Interop.vfpbuild.dll";
            path = AppDomain.CurrentDomain.BaseDirectory + path;
            Assembly interopt = null;
            Console.Write($" loading {path}");
            try
            {
                interopt = Assembly.LoadFile(path);
                Console.WriteLine($" OK.");
            } catch (Exception ex) { LastError = ex;
                Console.WriteLine($" failed {ex.Message}");
             }
            return interopt;
        }
    }
    public class Task 
    {
        public static Ivfpbuild Builder { get; set; }
        public static Application App { get; set; }
        public static IFoxProject Project { get; set; }

        public static Exception LastError { get; set; }
        public static Assembly  Assembly  { get; set; }

        const string dllName = "vfpbuild.VfpBuild";

        public static string BuildExe(string pjx, string exe)
        {
            string msg = "";
            LastError = null;
            dynamic ovfp = null;
            dynamic obj = null;
            try
            {
                var asm = TaskDll.LoadBuild();
                Type tObj = Type.GetTypeFromProgID(dllName, throwOnError: true);
                obj = Builder as object ?? Activator.CreateInstance(tObj);
                Builder = obj as Ivfpbuild;

                obj.ErrorMsg(" vfp.. ");
                // --  ovfp = Builder.CreateApplication() -- // Attempted to read or write protected memory
                ovfp = App  as object ?? Type.GetTypeFromProgID("VisualFoxPro.Application", throwOnError: true);
                App = ovfp as Application;

                Builder.SetVfp(ovfp);
                if (ovfp != null)
                {
                    // obj.DoCmd("_SCREEN.Visible = .T.");
                    // obj.BuildVisible(true);  // SetVisible
                }

                Console.WriteLine($"Project  : {pjx}");

                // BUILD ------------------------------------------------------------
                Console.WriteLine($"Building : {exe}");
                obj.ErrorMsg($"Building : {exe}");
                var rez = obj.BuildPjx(pjx, exe);

                msg = rez as string ?? "";
                string StatusBar = "";

                StatusBar = App?.StatusBar ?? " ";
                msg = msg + StatusBar;
                if (!($"Building : {exe}").Equals(obj.cErrorMessage))
                   msg += " " + obj.cErrorMessage ?? "";

                obj.ErrorMsg(msg ?? "VFP Success!");
            }
            catch (AccessViolationException e1)
            {
                // An unhandled exception of type 'System.AccessViolationException' occurred.. 
                LastError = e1.InnerException ?? e1;
            }
            catch (Exception ex) {
                LastError = ex.InnerException ?? ex;
            }
            if (LastError != null)
                Console.WriteLine($"Error {LastError.Message} \n {LastError.StackTrace}");

            obj?.CloseVfp();

            return msg;
        }

        public static string BuildExe(IFoxProject pjx, string exe)
        {
            object outName = exe;
            var fBuildAll = false;

            pjx.Build(ref outName, BuildAction.BUILDEXE, fBuildAll, true, false);
            return outName as string;
        }

         public static string BuildDll(string pjx, string dll)
        {
            string msg = "";
            LastError = null;
            dynamic ovfp = null;
            try
            {
                var asm = TaskDll.LoadBuild();
                Type tObj = Type.GetTypeFromProgID(dllName, throwOnError: true);
                dynamic obj = Builder as object ?? Activator.CreateInstance(tObj);
                Builder = obj as Ivfpbuild;

                obj.ErrorMsg(" vfp.. ");
                ovfp = App as object ?? Type.GetTypeFromProgID("VisualFoxPro.Application", throwOnError: true);
                App = ovfp as Application;
                Builder.SetVfp(ovfp);

                // BUILD ------------------------------------------------------------
                Console.WriteLine($"Project  : {pjx}");
                var ok = obj.OpenPjx(pjx);

                Console.WriteLine($"Building : {dll}");

                /*
                FUNCTION BuildProject(cProjectFile AS STRING, cOutputName AS STRING ;
  		               , nBuildAction AS INTEGER, cVsProjectFile AS STRING, cBuildTime AS STRING, cBuildPath AS STRING) AS Boolean
                */

                var proj = obj.ActiveProject() as IFoxProject;
                
                string StatusBar = App?.StatusBar ?? "";
                msg = obj.cErrorMessage ?? "";
                Console.WriteLine($"StatusBar : {StatusBar}, {msg}");

                msg = App?.Eval("MESSAGE()") as string ?? "";
                if (proj == null)
                    throw new Exception($"Failed to open {pjx} : {msg}");

                //  var rez = BuildDll(proj, dll);
                //  msg = rez as string ?? "";
                StatusBar = App?.StatusBar ?? " ";
                msg = msg + StatusBar;
                if (!($"Building : {dll}").Equals(obj.cErrorMessage))
                   msg += " " + obj.cErrorMessage ?? "";

                obj.ErrorMsg(msg ?? "VFP Success!");
            }
            catch (AccessViolationException e1)
            {
                // An unhandled exception of type 'System.AccessViolationException' occurred.. 
                LastError = e1.InnerException ?? e1;
            }
            catch (Exception ex) {
                LastError = ex.InnerException ?? ex;
            }
            if (LastError != null)
                Console.WriteLine($"Error {LastError.Message} \n {LastError.StackTrace}");

            if (Builder != null)
                Builder.CloseVfp();

            return msg;
        }


        public static string BuildDll(IFoxProject pjx, string dll)
        {
            object outName = dll;
            var fBuildAll = false;

            pjx.Build(ref outName, BuildAction.BUILDEXE, fBuildAll, true, false);
            return outName as string;
        }

        public enum BuildAction : int {
            Rebuild = 0,
            BUILDAPP = 2, // Creates an.app
            // BUILDACTION_BUILDEXE
            BUILDEXE  = 3, // Creates an.exe
            BUILDDLL  = 4, // Creates a.dll
             BUILDMTDLL = 5 // Creates a multithreaded.dll
        }

        public static void ListFiles(string prefix, IEnumerable<FileInfo> files)
        {
            Console.WriteLine(prefix);
            foreach(var item in files)
               Console.Write(item.FullName);
        }

        public static void Test2(object obj = null)
        {

            // Assembly inter = Assembly.LoadFile(path);
            // Type t = inter.GetType(tName);

            // VFP
            /*
            a = newobject("vfpbuild.vfpbuild")
            m.a.CreateApplication()
            m.a.OVFP.Visible = .T.
            */

            // Class"// [TypeLibType(2)]        [Guid("07A33D7B-08DE-404A-970D-BC61A5D8869C")]
            // [ClassInterface(0)]         [ComImport]
            // public class vfpbuildClass : Ivfpbuild, vfpbuild

            MarshalByRefObject mObj = obj as MarshalByRefObject;

            // var ref1 = Builder.CreateApplication();

            var t2 = Builder.GetType();
            Type[] intList = t2.GetInterfaces();
            var m = t2.GetMethods();
            MethodInfo CreateApplication = System.Linq.Enumerable.FirstOrDefault(m, (n) => n.Name == "CreateApplication");
            MethodInfo CreateObjRef = System.Linq.Enumerable.FirstOrDefault(m, (n) => n.Name == "CreateObjRef");
            // var rez = CreateObjRef?.Invoke(obj, new object[] { tObj });

            // var rez = mObj.CreateObjRef(mObj.GetType());

            // Object GetData(System.Object)}
            // Object GetEventProvider 

            // CreateApplication?.Invoke(obj, null);
        }

    }
}

/*
 
StartingError Retrieving the COM class factory for component with CLSID {07A33D7B-08DE-404A-970D-BC61A5D8869C}
    failed due to the following error: 80040154 Class not registered (Exception from HRESULT: 0x80040154 (REGDB_E_CLASSNOTREG)). 

  : 0x80040154 (REGDB_E_CLASSNOTREG)). 
   at System.RuntimeTypeHandle.CreateInstance(RuntimeType type, Boolean publicOnly, Boolean& canBeCached, RuntimeMethodHandleInternal& ctor)
   at System.RuntimeType.CreateInstanceSlow(Boolean publicOnly, Boolean skipCheckThis, Boolean fillCache, StackCrawlMark& stackMark)
   at System.Activator.CreateInstance(Type type, Boolean nonPublic)


 *  [DispId(25)]
    [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
    [return: MarshalAs(UnmanagedType.Struct)]
    public virtual object CreateApplication();


 * [DefaultMember("OVFP")]
    [Guid("ADE5A288-4460-4D44-8B7C-A2EC76DA3EAE")]
    [TypeLibType(4304)]
    public interface Ivfpbuild
    {
        [DispId(22)]
        object Compile(string cPrgFile);
        [DispId(23)]
        object BuildPjx(string cProjectFile, string COUTPUTNAME);
        [DispId(24)]
        object BuildVisible(bool lVisible);
        [DispId(25)]
        object CreateApplication();
        [DispId(26)]
        object ApplicationMsg();
        [DispId(27)]
        object BuildExe(string cProjectFile, string COUTPUTNAME);
        [DispId(28)]
        bool BuildProject(string cProjectFile, string COUTPUTNAME, int NBUILDACTION, string cVsProjectFile, string cBuildTime, string cBuildPath);
        [DispId(29)]
        object SetVfp(object OVFP);
        [DispId(30)]
        object CloseVfp();
        [DispId(31)]
        object ErrorSet(object err);
        [DispId(32)]
        object ErrorMsg(string msg);

        [DispId(0)]
        object OVFP { get; set; }
        [DispId(2)]
        object URETVAL { get; set; }
        [DispId(4)]
        object DSID { get; set; }
        [DispId(6)]
        object FBUILDALL { get; set; }
        [DispId(8)]
        object LCLOSE { get; set; }
        [DispId(10)]
        object COUTPUTNAME { get; set; }
        [DispId(12)]
        object NBUILDACTION { get; set; }
        [DispId(14)]
        object CPROJECT { get; set; }
        [DispId(16)]
        object CFOLDER { get; set; }
        [DispId(18)]
        object LASTERROR { get; set; }
        [DispId(20)]
        string cErrorMessage { get; }
        [DispId(21)]
        string cWarningMessage { get; }
    }
}

    [DefaultMember("Name")]
    [Guid("00A19612-D8FC-4A3E-A95F-FEA211444BF7")]
    [TypeLibType(4160)]
    public interface Application
    {
        [DispId(17)]
        void DoCmd(string bstrCmd);
        [DispId(18)]
        object Eval(string bstrExpr);
        [DispId(19)]
        void Quit();
        [DispId(20)]
        object RequestData(ref object lpvarWrkArea, ref object lpvarNumRows);
        [DispId(21)]
        object DataToClip(ref object lpvarWrkArea, ref object lpvarNumRows, ref object lpvarClipFormat);
        [DispId(22)]
        void SetVar(string bstrVarName, ref object lpvarNumRows);
        [DispId(23)]
        void Help(ref object lpvarHelpFile, ref object lpvarHelpCid, ref object lpvarHelpString);

        [DispId(0)]
        string Name { get; }
        [DispId(1)]
        string FullName { get; }
        [DispId(2)]
        FoxApplication Application { get; }
        [DispId(3)]
        object Parent { get; }
        [DispId(4)]
        bool Visible { get; set; }

        [DispId(5)]
        string Version { get; }
        [DispId(6)]
        string Caption { get; set; }
        [DispId(7)]
        string DefaultFilePath { get; set; }
        [DispId(8)]
        string StatusBar { get; set; }
        [DispId(9)]
        int Left { get; set; }
        [DispId(10)]
        int Top { get; set; }
        [DispId(11)]
        int Width { get; set; }
        [DispId(12)]
        int Height { get; set; }
        [DispId(13)]
        bool AutoYield { get; set; }
        [DispId(14)]
        object ActiveForm { get; }
        [DispId(15)]
        IFoxForms Forms { get; }
        [DispId(16)]
        object Objects { get; }
        [DispId(24)]
        int OLERequestPendingTimeout { get; set; }
        [DispId(25)]
        int OLEServerBusyTimeout { get; set; }
        [DispId(26)]
        bool OLEServerBusyRaiseError { get; set; }
        [DispId(27)]
        int StartMode { get; }
        [DispId(28)]
        IFoxProject ActiveProject { get; }
        [DispId(29)]
        IFoxProjects Projects { get; }
        [DispId(30)]
        string ServerName { get; }
        [DispId(31)]
        int ThreadId { get; }
        [DispId(32)]
        int ProcessId { get; }
        [DispId(33)]
        string EditorOptions { get; set; }
        [DispId(34)]
        int LanguageOptions { get; set; }
        [DispId(38)]
        int hWnd { get; }
        [DispId(39)]
        string VFPXMLProgId { get; set; }
    }
}

*/
