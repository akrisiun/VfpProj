using System;
using System.Collections.Generic;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Runtime.InteropServices.ComTypes;
using System.Threading;
using System.Diagnostics;
using VisualFoxpro;
using System.Collections;

namespace VfpProj
{
    [ComVisible(true)]
    [ComImport]
    [CoClass(typeof(FoxApplication))]
    [Guid("00A19612-D8FC-4A3E-AFFF-FEA211444BF7")]
    [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface IFoxApplication
    {
        MarshalByRefObject MarshalObj { get; set; }

        bool Visible { get; set; }
        IntPtr ProcessId { get; }
        IntPtr hWnd { get; }
        bool? AutoYield { get; set; }

        int StartMode { get; set; }
        string DefaultFilePath { get; set; }
        string Caption { get; set; }
        string StatusBar { get; set; }

        object SetVar(string name, object value);
        object DoCmd(string name);
        object Eval(string expr);

        object Objects { get; }
        object Application { get; }
        object Projects { get; }

        object ActiveProject { get; }
        object ActiveForm { get; }
        object Forms { get; }

        object Object(int idx);
        object Form(int idx);
    }

    // A95F -> A9FF
    [ComVisible(true)]
    [Guid("00A19612-D8FC-4A3E-A9FF-FEA211444BF7")]
    [DebuggerDisplay("vfp://{DefaultFilePath} : {Caption}")]
    public class FoxApplication : Dictionary<String, object>, IDictionary<string, object>, 
        IEnumerable<object>, IFoxApplication
    {
        public static FoxApplication Wrap(object app) => new FoxApplication { Target = app as global::VisualFoxpro.FoxApplication };

        internal global::VisualFoxpro.FoxApplication Target { get; private set; }

        [ComVisible(true), DispId(0x70020000)]
        public MarshalByRefObject MarshalObj {
            get => Target as MarshalByRefObject;
            set {
                this.Target = value as VisualFoxpro.FoxApplication;
            }
        }

        public Type BaseType { get => ((object)Target ?? this).GetType().BaseType; }
        public Guid Guid { get => BaseType.GUID; }

        [ComVisible(true), DispId(0x70020001)]
        public object Objects { get => Target?.Objects as IFoxObjects; }
        [ComVisible(true), DispId(0x70020002)]
        public object Application { get => Target?.Application; }
        [ComVisible(true), DispId(0x70020003)]
        public object Projects { get => Target?.Projects; }

        [ComVisible(true), DispId(0x70020003)]
        public object ActiveProject { get => Safe(() => Target?.ActiveProject); }
        [ComVisible(true), DispId(0x70020005)]
        public object ActiveForm { get => Safe(() => Target?.ActiveForm); }
        [ComVisible(true), DispId(0x70020006)]
        public object Forms { get => Safe(() => Target?.Forms as IFoxForms); }

        public static object Safe(FuncObject getObj) {
            try { return getObj(); }
            catch (COMException) { return null; }
            catch { return null; }
        }
        public delegate object FuncObject();

        [ComVisible(true), DispId(0x70020011)]
        public object Object(int idx) => (Target.Objects as IFoxObjects)[idx as object];
        [ComVisible(true), DispId(0x70020012)]
        public object Form(int idx) => (Target.Forms as IFoxForms)[idx as object];

        public T Cast<T>() where T : class => Target as T;
        public static T CastObj<T>(object obj, T ifelse) where T : class => obj as T ?? ifelse;

        [ComVisible(true), DispId(0x70020051)]
        public bool Visible {
            get => Target?.Visible ?? false;
            set { Target.Visible = value; }
        }
        [ComVisible(true), DispId(0x70020052)]
        public IntPtr ProcessId { get => new IntPtr(Target.ProcessId); }
        [ComVisible(true), DispId(0x70020053)]
        public IntPtr hWnd { get => new IntPtr(Target.hWnd); }

        [ComVisible(true), DispId(0x70020054)]
        public bool? AutoYield {
            get => Target?.AutoYield;
            set { Target.AutoYield = value ?? false; }
        }

        [ComVisible(true), DispId(0x70020055)]
        public int StartMode {
            get => Target.StartMode;
            set { }
        }

        [ComVisible(true), DispId(0x70020056)]
        public string DefaultFilePath {
            get => Target.DefaultFilePath;
            set { Target.DefaultFilePath = value; }
        }
        [ComVisible(true), DispId(0x70020057)]
        public string Caption {
            get => Target.Caption;
            set { Target.Caption = value; }
        }

        [ComVisible(true), DispId(0x70020058)]
        public string StatusBar {
            get => Target.StatusBar;
            set { Target.StatusBar = value; }
        }

        [ComVisible(true), DispId(0x70020101)]
        public object SetVar(string name, object value)
        {
            object obj = value;
            Target.SetVar(name, ref obj);
            return this;
        }

        [ComVisible(true), DispId(0x70020102)]
        public object DoCmd(string name, params object[] args) 
            => DoCmd(name); // todo parse..
        [ComVisible(true), DispId(0x70020103)]
        public object Eval(string name, params object[] args) 
            => Eval(name);  // todo parse..

        [ComVisible(true), DispId(0x70020104)]
        public object DoCmd(string name)
        {
            Target.DoCmd(name);
            return this;
        }

        [ComVisible(true), DispId(0x70020105)]
        public object Eval(string expr) {
            var res = Target.Eval(expr);
            return res;
        }

        [ComVisible(true), DispId(0x70020106)]
        public new Enumerator GetEnumerator()
        {
            this.Clear();
            var obj = this;
            var properties = obj.GetType().GetProperties();
            foreach (var prop in properties)
            {
                if (prop.Name == "Keys" || prop.Name == "Values" || prop.Name == "Item" || prop.Name == "Comparer")
                    continue;

                try {
                    var value = prop.GetValue(obj, new object[] { });
                    this.Add(prop.Name, value);
                } catch (COMException) { }
            }

            return base.GetEnumerator();
        }

        IEnumerator<object> IEnumerable<object>.GetEnumerator()
        {
            var list = Target?.Objects as IFoxObjects;
            if (list.Count == 0)
                yield break;

            foreach (var item in list)
            {
                yield return item;
            }
        }

        // [DispId(15)] IFoxForms Forms { get; }
    }

    // 8fcf / 8fff
    [Guid("c155b373-563f-433f-8fff-18fd98100001")]
    [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface _Events20
    {
        [ComVisible(true), DispId(0x60020000)]
        _Form20 Form(FoxApplication app);

        [ComVisible(true), DispId(0x60030000)]
        IFoxApplication App { get; }

        [ComVisible(true), DispId(0x60020001)]
        bool IsLockForm { get; set; }

        [ComVisible(true), DispId(0x60020002)]
        IntPtr hWnd { get; set; }

        [ComVisible(true), DispId(0x60020003)]
        string Name { get; }

        //[ComVisible(true), DispId(0x60030001)]
        //CsObj GetInstance();

        [ComVisible(true), DispId(0x60022003)]
        Exception LastError {get; set;}

        //[ComVisible(true), DispId(0x60020004)]
        //_Form CmdForm { get; }

        [ComVisible(true), DispId(0x60020030)]
        _Form20 Show(object app);

        [ComVisible(true), DispId(0x60020011)]
        string DoCmd(string cmd);

        [ComVisible(true), DispId(0x60020012)]
        string Eval(string expr);

        [ComVisible(true), DispId(0x60020013)]
        IntPtr EvalPtr(string expr);

        [ComVisible(true), DispId(0x60020014)]
        string SetPtr(object ptr); // dynamic ptr);

        [ComVisible(true), DispId(0x60020020)]
        string SetIntPtr(IntPtr ptr);

        [ComVisible(true), DispId(0x60020026)]
        string SetProperty(IntPtr ptr, string property);

        //[ComVisible(true), DispId(0x60020021)]
        //string SetFoxObj(IFoxObjects ptr);

        //[ComVisible(true), DispId(0x60020022)]
        //string SetFoxForms(IFoxForms ptr);

        //[ComVisible(true), DispId(0x60020023)]
        //string SetProjects(IFoxProjects ptr);

#if NET40
        [ComVisible(true), DispId(0x60020024)]
        string GetXml(string command);

        //[ComVisible(true), DispId(0x60020025)]
        //XElement LoadXml(string command);
#endif

    }

    // 8fcf / 8fff
    [Guid("c155b373-563f-433f-8fff-18fd98100002")]
    [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface _Form20
    {
        [DispId(0x60030001)]
        [ComVisible(true)]
        string Directory { get; set; }

        [DispId(0x60030002)]
        [ComVisible(true)]
        // FoxApplication 
        // dynamic 
        object App { get; set; }

        [ComVisible(true), DispId(0x60030022)]
        _Events20 CsObject { get; }

        [ComVisible(true), DispId(0x60030055)]
        _Startup Instance { get; }

#region Positions

        [ComVisible(true), DispId(0x60030003)]
        bool Visible { get; set; }

        [ComVisible(true), DispId(0x60030004)]
        int Left { get; set; }
        [ComVisible(true), DispId(0x60030005)]
        int Top { get; set; }

        [ComVisible(true), DispId(0x60030006)]
        int Width { get; set; }
        [ComVisible(true), DispId(0x60030007)]
        int Height { get; set; }

        [ComVisible(true), DispId(0x60030008)]
        string Text { get; set; }

        [ComVisible(true), DispId(0x60030009)]
        string Name { get; }

        [ComVisible(true), DispId(0x60030010)]
        IntPtr Handle { get; }

#endregion

        [ComVisible(true), DispId(0x60030011)]
        bool IsDisposed { get; }

        [ComVisible(true), DispId(0x60030021)]
        bool AlwaysOnTop { get; set; }

        [ComVisible(false)]
        Exception LastError { get; set; }

        //[ComVisible(true), DispId(0x60030020)]
        //WindowsEvents Events { get; }

        //[ComVisible(true), DispId(0x60030022)]
        //MainWindow Form { get; }

        [ComVisible(true), DispId(0x60030023)]
        bool CheckAccess();
    }

    [Guid("c155b373-563f-433f-8fcf-18fd98100003")]
    [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface _Startup
    {
        [DispId(0x60050001)]
        [ComVisible(true)]
        FoxApplication App { get; set; }

        [DispId(0x60050002)]
        _Startup LoadMain(VisualFoxpro.FoxApplication app);

        [DispId(0x60050003)]
        _Form20 Show(VisualFoxpro.FoxApplication app);
    }

    internal interface _Form : _Form20 { }
    internal interface _Events : _Events20 { }

    public static class TypeStatic
    {
        public static object GetObj(string progIdString)
        {
            var type = Type.GetTypeFromProgID(progIdString);
            var obj = Activator.CreateInstance(type);
            return obj;
        }

        //public static Type GetTypeForITypeInfo(IntPtr piTypeInfo) // ITypeInfo
        //{
        //    if (piTypeInfo == IntPtr.Zero)
        //        return null;
        //    var type = Marshal.GetTypeForITypeInfo(piTypeInfo);
        //    return type;
        //}

    }


    public struct ComUnknown : __ComObject
    {
        private IntPtr _ptr;
        public IntPtr Value { get => _ptr; }

        public ComUnknown(IntPtr? ptr = null)
        {
            _ptr = ptr.HasValue ? ptr.Value : IntPtr.Zero;
        }
    }

    public interface __ComObject
    { }

    public static class ComTypeStatic
    {
        //====================================================================
        // This method takes the given COM object and wraps it in an object
        // of the specified type. The type must be derived from __ComObject.
        //====================================================================
        [System.Security.SecurityCritical]  // auto-generated_required
        public static Object CreateWrapperOfType(Object o, Type t = null)
        {
            // Check for the null case.
            if (o == null)
                return null;

            t = t ?? o.GetType();
            if (!t.IsCOMObject) throw new ArgumentException($"Argument_TypeNotComObject {t}");
            if (t.IsGenericType) throw new ArgumentException($"Argument_NeedNonGenericType {t}");
            // Make sure the object is a COM object.
            if (!o.GetType().IsCOMObject) throw new ArgumentException($"Argument_ObjNotComObject {t}");
            // Check to see if the type of the object is the requested type.
            if (o.GetType() == t)
                return o;

            var obj = Marshal.CreateWrapperOfType(o, t);
            // -> private static extern Object InternalCreateWrapperOfType(Object o, Type t)
            return obj;
        }

        [System.Security.SecurityCritical]
        public static TWrapper CreateWrapperOfType<T, TWrapper>(T o)
        {
            return (TWrapper)CreateWrapperOfType(o, typeof(TWrapper));
        }
        public static object GetObjectForIUnknown(ComUnknown sUnk) => GetObjectForIUnknown(sUnk.Value);

        public static object GetObjectForIUnknown(IntPtr pUnk)
            => pUnk == IntPtr.Zero ? null : Marshal.GetObjectForIUnknown(pUnk);

        [System.Security.SecurityCritical]  // auto-generated_required
        public static IntPtr /* IUnknown* */ GetComInterfaceForObject(Object o, Type T)
            => o == null ? IntPtr.Zero : Marshal.GetComInterfaceForObject(o, T);

        [System.Security.SecurityCritical]  // auto-generated
        internal static IntPtr GetIUnknown(object o, out bool fIsURTAggregated)
        {
            fIsURTAggregated = !o.GetType().IsDefined(typeof(ComImportAttribute), false);
            return Marshal.GetIUnknownForObject(o);
        }

        public static UnknownWrapper UnknownWrapper(object o) => new UnknownWrapper(o);

        // public static DispatchWrapper DispatchWrapper(this Object obj)
        public static DispatchWrapper DispatchWrapper(Object obj)
        {
            if (obj != null)
            {
                // Make sure this guy has an IDispatch
#if NET40 || NET20
                IntPtr pdisp = Marshal.GetIDispatchForObject(obj);

                // If we got here without throwing an exception, the QI for IDispatch succeeded.
                Marshal.Release(pdisp);
#endif
            }
            var m_WrappedObject = new DispatchWrapper(obj);
            return m_WrappedObject;
        }

    }

    public class ComType
    {
        public ITypeInfo pTI { get; set; }
        public ITypeLib pTLB { get; set; }
        public Type TypeObj { get; set; }
        public Assembly AsmBldr { get; set; }
        public TypeLibConverter TlbConverter { get; set; }
        public Guid clsid { get; set; }

        public static AppDomain Domain { get => Thread.GetDomain(); }
        public static Assembly[] Assemblies { get => Domain.GetAssemblies(); }

       
        // extern Object GetObjectForIUnknown(IntPtr /* IUnknown* */ pUnk);

        // Wrap the ITypeInfo in a CLR object.
        //pTI = (ITypeInfo) GetObjectForIUnknown(piTypeInfo);

        //public static AssemblyName GetAssemblyNameFromTypelib(ITypeLib pTLB)
        //{
        //    AssemblyName AsmName = TypeLibConverter.GetAssemblyNameFromTypelib(pTLB, null, null, null, null, AssemblyNameFlags.None);
        //    return AsmName;
        //}

    }

}

// More Marshal COM objects
namespace VfpProj.Com
{


    sealed class EmptyCustomTypeDescriptor : System.ComponentModel.CustomTypeDescriptor
    {
    }

    // [System.Security.SuppressUnmanagedCodeSecurity]
    [ComImport]
    [Guid("6EB22871-8A19-11D0-81B6-00A0C9231C29")]
    interface ICatalogObject
    {
        [DispId(0x00000001)]
        Object GetValue([In, MarshalAs(UnmanagedType.BStr)] String propName);

        [DispId(0x00000001)]
        void SetValue([In, MarshalAs(UnmanagedType.BStr)] String propName,
                      [In] Object value);

        [DispId(0x00000002)]
        Object Key();

        [DispId(0x00000003)]
        Object Name();

        [DispId(0x00000004)]
        [return: MarshalAs(UnmanagedType.VariantBool)]
        bool IsPropertyReadOnly([In, MarshalAs(UnmanagedType.BStr)] String bstrPropName);

        bool Valid {
            [DispId(0x00000005)]
            [return: MarshalAs(UnmanagedType.VariantBool)]
            get;
        }

        [DispId(0x00000006)]
        [return: MarshalAs(UnmanagedType.VariantBool)]
        bool IsPropertyWriteOnly([In, MarshalAs(UnmanagedType.BStr)] String bstrPropName);
    }

    [Guid("00020401-0000-0000-C000-000000000046")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]  // UnmanagedType.IUnknown = 0x19,        // COM IUnknown pointer. 
    [ComImport]
    public interface _IUnknown { }

    [Guid("00020401-0000-0000-C000-000000000046")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    [ComImport]
    public interface _ITypeInfo : ITypeInfo { }

    internal static class InterfaceHelper
    {
        // only use this helper to get interfaces that are guaranteed to be supported
        internal static IntPtr GetInterfacePtrForObject(Guid iid, object obj)
        {
            IntPtr pUnk = Marshal.GetIUnknownForObject(obj);
            if (IntPtr.Zero == pUnk)
            {
                throw new InvalidComObjectException("UnableToRetrievepUnk");
            }

            IntPtr ppv = IntPtr.Zero;
            int hr = Marshal.QueryInterface(pUnk, ref iid, out ppv);

            Marshal.Release(pUnk);

            if (hr != HR.S_OK)
            {
                throw new InvalidComObjectException("QueryInterface should succeed");
            }

            return ppv;
        }

        internal static class HR
        {
            internal static readonly int S_OK = 0;
            internal static readonly int S_FALSE = 1;
            internal static readonly int MK_E_SYNTAX = unchecked((int)0x800401e4);
            internal static readonly int E_INVALIDARG = unchecked((int)0x80070057);
            internal static readonly int E_UNEXPECTED = unchecked((int)0x8000ffff);
            internal static readonly int DISP_E_UNKNOWNINTERFACE = unchecked((int)0x80020001);
            internal static readonly int DISP_E_MEMBERNOTFOUND = unchecked((int)0x80020003);
            internal static readonly int DISP_E_PARAMNOTFOUND = unchecked((int)0x80020004);
            internal static readonly int DISP_E_TYPEMISMATCH = unchecked((int)0x80020005);
            internal static readonly int DISP_E_UNKNOWNNAME = unchecked((int)0x80020006);
            internal static readonly int DISP_E_NONAMEDARGS = unchecked((int)0x80020007);
            internal static readonly int DISP_E_BADVARTYPE = unchecked((int)0x80020008);
            internal static readonly int DISP_E_EXCEPTION = unchecked((int)0x80020009);
        }
    }


    internal static class NativeMethods
    {
        // [System.Security.SuppressUnmanagedCodeSecurity]
        [DllImport("oleaut32.dll", PreserveSig = false),
        System.Security.SecurityCritical]
        internal static extern void VariantClear(IntPtr variant);

        // [System.Security.SuppressUnmanagedCodeSecurity]
        [ComImport,
        InterfaceType(ComInterfaceType.InterfaceIsIUnknown),
        Guid("00020400-0000-0000-C000-000000000046")
        ]
        internal interface IDispatch
        {

            [System.Security.SecurityCritical]
            void GetTypeInfoCount(out uint pctinfo);

            [System.Security.SecurityCritical]
            void GetTypeInfo(uint iTInfo, int lcid, out IntPtr info);

            [System.Security.SecurityCritical]
            void GetIDsOfNames(
                ref Guid iid,
                [MarshalAs(UnmanagedType.LPArray, ArraySubType = UnmanagedType.LPWStr, SizeParamIndex = 2)]
                string[] names,
                uint cNames,
                int lcid,
                [Out]
                [MarshalAs(UnmanagedType.LPArray, ArraySubType = UnmanagedType.I4, SizeParamIndex = 2)]
                int[] rgDispId);

            [System.Security.SecurityCritical]
            void Invoke(
                int dispIdMember,
                ref Guid riid,
                int lcid,
                System.Runtime.InteropServices.ComTypes.INVOKEKIND wFlags,
                ref System.Runtime.InteropServices.ComTypes.DISPPARAMS pDispParams,
                IntPtr pvarResult,
                IntPtr pExcepInfo,
                IntPtr puArgErr);
        }
    }

    [Serializable]
    [Flags]
    public enum _INVOKEKIND : int
    {
        INVOKE_FUNC = 0x1,
        INVOKE_PROPERTYGET = 0x2,
        INVOKE_PROPERTYPUT = 0x4,
        INVOKE_PROPERTYPUTREF = 0x8
    }

    [Guid("00020401-0000-0000-C000-000000000046")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    [ComImport]
    // System.Runtime.InteropServices.ComTypes
    public interface IITypeInfo : ITypeInfo
    {
    }

    [Guid("0000000c-0000-0000-C000-000000000046")]
    [InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    [ComImport]
    public interface IIStream : IStream
    {
    }

    public enum ComInterfaceType2
    {
        InterfaceIsDual = 0,
        InterfaceIsIUnknown = 1,
        InterfaceIsIDispatch = 2,
    }

    /// <summary>Defines the contract for Win32 window handles. </summary>
    //public interface IIWin32Window : System.Windows.Forms.IWin32Window
    //{
    //}

    // more:

    //========================================================================
    // Typelib importer callback implementation.
    //========================================================================

    internal class ImporterCallback : ITypeLibImporterNotifySink
    {
        public void ReportEvent(ImporterEventKind EventKind, int EventCode, String EventMsg)
        { }

#if NET40 || NET20
        [System.Security.SecuritySafeCritical] // overrides transparent public member
        public Assembly ResolveRef(Object TypeLib)
        {
            try
            {
                // Create the TypeLibConverter.
                ITypeLibConverter TLBConv = new TypeLibConverter();
                // Convert the typelib.
                return TLBConv.ConvertTypeLibToAssembly(TypeLib,
                                Marshal.GetTypeLibName((ITypeLib)TypeLib) + ".dll",
                                0,
                                new ImporterCallback(),
                                null, null, null, null);
            }
            catch (Exception)
            {
                return null;
            }
        }
#endif

        // Check to see if a class exists with the specified GUID.
        //public static IComponent Server(object obj)
        //{
        //    //IComponentServer server = new IComponentServer.
        //    // var server = (IComponentServer)obj;
        //    var server = obj as IComponent;
        //    return server;
        //}
    }
}

//_Events [Guid("c155b373-563f-433f-8fcf-18fd98100001")]
//_Form [Guid("c155b373-563f-433f-8fcf-18fd98100002")]
//_Startup [Guid("c155b373-563f-433f-8fcf-18fd98100002")]