using System;
using System.Runtime.InteropServices;
using System.Windows.Interop;
using System.ComponentModel;
using System.Xml.Linq;
using VfpProj.Native;
using VisualFoxpro;

namespace VfpProj
{
    [Guid("c155b373-563f-433f-8fcf-18fd98100001")]
    [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface _Events
    {
        [ComVisible(true), DispId(0x60020000)]
        _Form Form(FoxApplication app);

        [ComVisible(true), DispId(0x60030000)]
        FoxApplication App { get; }

        [ComVisible(true), DispId(0x60030001)]
        CsObj GetInstance();

        [ComVisible(true), DispId(0x60020001)]
        bool IsLockForm { get; set; }

        [ComVisible(true), DispId(0x60020002)]
        IntPtr hWnd { get; set; }

        [ComVisible(true), DispId(0x60020003)]
        string Name { get; }

        //[ComVisible(true), DispId(0x60020004)]
        //_Form CmdForm { get; }

        [ComVisible(true), DispId(0x60020030)]
        _Form Show(FoxApplication app);

        [ComVisible(true), DispId(0x60020011)]
        string DoCmd(string cmd);

        [ComVisible(true), DispId(0x60020012)]
        string Eval(string expr);

        [ComVisible(true), DispId(0x60020013)]
        IntPtr EvalPtr(string expr);

        [ComVisible(true), DispId(0x60020014)]
        string SetPtr(dynamic ptr);

        [ComVisible(true), DispId(0x60020020)]
        string SetIntPtr(IntPtr ptr);

        [ComVisible(true), DispId(0x60020021)]
        string SetFoxObj(IFoxObjects ptr);

        [ComVisible(true), DispId(0x60020022)]
        string SetFoxForms(IFoxForms ptr);

        [ComVisible(true), DispId(0x60020023)]
        string SetProjects(IFoxProjects ptr);

        [ComVisible(true), DispId(0x60020024)]
        string GetXml(string command);

        [ComVisible(true), DispId(0x60020025)]
        XElement LoadXml(string command);

        [ComVisible(true), DispId(0x60020026)]
        string SetProperty(IntPtr ptr, string property);

    }

    [Guid("c155b373-563f-433f-8fcf-18fd98100002")]
    [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface _Form
    {
        [DispId(0x60030001)]
        [ComVisible(true)]
        string Directory { get; set; }

        [DispId(0x60030002)]
        [ComVisible(true)]
        // FoxApplication
        dynamic App { get; set; }

        [ComVisible(true), DispId(0x60030022)]
        _Events CsObject { get; }

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

        [ComVisible(true), DispId(0x60030020)]
        WindowsEvents Events { get; }

        [ComVisible(true), DispId(0x60030021)]
        bool AlwaysOnTop { get; set; }

        [ComVisible(true), DispId(0x60030022)]
        MainWindow Form { get; }

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
        _Startup LoadMain(FoxApplication app);

        [DispId(0x60050003)]
        _Form Show(FoxApplication app);
    }


    public static class TypeStatic
    {
        public static object GetObj(string progIdString)
        {
            var type = Type.GetTypeFromProgID(progIdString);
            var obj = Activator.CreateInstance(type);
            return obj;
        }

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