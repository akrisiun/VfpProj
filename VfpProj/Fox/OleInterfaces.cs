using System;
using System.Runtime.InteropServices;
using VisualFoxpro;

namespace VfpProj
{
    [Guid("c155b373-563f-433f-8fcf-18fd98100001")]
    [InterfaceType(ComInterfaceType.InterfaceIsIDispatch)]
    public interface _Events
    {
        [ComVisible(true), DispId(0x60020000)]
        _Form Form(FoxApplication app);

        [ComVisible(true), DispId(0x60020001)]
        FoxApplication App { get; }

        [ComVisible(true), DispId(0x60020002)]
        IntPtr hWnd { get; set; }

        [ComVisible(true), DispId(0x60020003)]
        string Name { get; }

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
        FoxApplication App { get; set; }

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

        [ComVisible(true), DispId(0x60030011)]
        bool IsDisposed { get; }

        [ComVisible(true), DispId(0x60030021)]
        bool OnTop { get; set; }
    }

}
