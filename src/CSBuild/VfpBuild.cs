using System;
using System.Diagnostics;
using System.Reflection;
using System.Runtime.Remoting;
using System.Runtime.InteropServices;

using vfpbuild;

namespace VfpBuild
{
    public class VfpBuild
    {
        [STAThread]
        public static void Main()
        {
            Console.Write("Starting");

            if (Debugger.IsAttached)
                Debugger.Break();
            else
                Console.ReadKey();

            Load();

            Console.Write("Finished");
        }


        public static Ivfpbuild Builder { get; set; }
        public static Exception LastError { get; set; }

        public static void Load()
        {
            string path = "Interop.vfpbuild.dll";
            LastError = null;
            dynamic ovfp = null;

            try
            {
                path = AppDomain.CurrentDomain.BaseDirectory + path;
                var tName = "vfpbuild.vfpbuild";

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

                Type tObj = Type.GetTypeFromProgID(tName, throwOnError: true);

                dynamic obj = Activator.CreateInstance(tObj);
                Builder = obj as Ivfpbuild; //  new vfpbuild();
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

                CreateApplication?.Invoke(obj, null);

                obj.ErrorMsg("hello VFP builder!");

                // Builder.CreateApplication();

                ovfp = Type.GetTypeFromProgID("VisualFoxPro.Application", throwOnError: true);

                Builder.SetVfp(ovfp);
                if (ovfp != null)
                {
                    var oVisible = ovfp.Eval("_SCREEN.Visible");
                    var StartMode = ovfp.Eval("_VFP.StartMode");

                    ovfp.DoCmd("_VFP.Visible = .T.");
                }

                obj.ErrorMsg("VFP Success!");

            }
            catch (AccessViolationException e1) {

                //An unhandled exception of type 'System.AccessViolationException' occurred in CSVfpBuild.exe
                //Attempted to read or write protected memory.This is often an indication that other memory is corrupt.
                LastError = e1.InnerException ?? e1;
            }
            catch (Exception ex) {
                LastError = ex.InnerException ?? ex;
            }

            if (LastError != null)
                Console.WriteLine($"Error {LastError.Message} \n {LastError.StackTrace}");

        }
    }
}

/*
 * 
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

*/
