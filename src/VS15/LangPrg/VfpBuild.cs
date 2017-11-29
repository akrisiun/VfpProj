using System;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices;
// using vfpbuild;

namespace VfpLanguage.LangPrg
{
    public static class VfpBuild
    {
        public static object // Ivfpbuild 
                      Build { get; set; }

        public static FoxAppObject FoxObject { get; set; }

        public static void BuildPrj(string file, string outputFile)
        {
            object app = null;
            FoxObject = FoxAppObject.Instance ?? FoxAppObject.Load(app);

            if (Build != null)
            {
                // Build.CPROJECT = file;
                string path = Environment.CurrentDirectory;

                //  "EXE", 
                if (Build != null)
                {
                    // Build.BuildProject(file, outputFile, 0, file, "", path);
                }
            }
        }
    }
}

#if !INTEROPT

namespace vfpbuild
{
    // [Guid("07A33D7B-08DE-404A-970D-BC61A5D8869C")]
    [Guid("07A33D7B-08DE-404A-970D-BC61A5D8869D")]
    [TypeLibType(2)]
    //[ClassInterface(0)] //[ComImport]
    [ComVisible(true)]
    public class vfpbuildClass // : Ivfpbuild // , vfpbuild.vfpbuild
    {
        //[DispId(0)]
        //[IndexerName("cErrorMessage")]
        //public virtual string this[] {
        //    [DispId(0), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        //    get;
        //}

        public object OVFP {
            [DispId(0), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
            get;
            [DispId(0), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
            set;
        }

        public dynamic CPROJECT { get; set; }

        public dynamic SetVfp(object obj)
        {
            return null;
        }

        public dynamic CloseVfp()
        {
            return null;
        }

        [DispId(0)]
        public virtual string cErrorMessage {
            get;
            protected set;
        }

        [DispId(1)]
        public virtual string cWarningMessage {
            //[DispId(1), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
            get;
            protected set;
        }

        //[MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        public vfpbuildClass() { }

        [DispId(2)]
        //[MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        // cProjectFile, cOutputName, nBuildAction, cVsProjectFile, cBuildTime, cBuildPath
        public virtual bool BuildProject(
            [MarshalAs(UnmanagedType.BStr), In] string cProjectFile, [MarshalAs(UnmanagedType.BStr), In] string cOutputName, 
            [In] int nBuildAction, [MarshalAs(UnmanagedType.BStr), In] string cVsProjectFile, [MarshalAs(UnmanagedType.BStr), In] string cBuildTime,
            [MarshalAs(UnmanagedType.BStr), In] string cBuildPath)
        {
            return false;
        }
    }
}


#endif