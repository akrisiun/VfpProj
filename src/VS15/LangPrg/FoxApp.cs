using VisualFoxpro;

namespace VfpLanguage.LangPrg
{
    public class FoxAppObject
    {
        public VisualFoxpro.Application Application {
            get;
            internal set;
        }

        protected FoxAppObject()
        {
        }

        public static FoxAppObject Instance { get; protected set; }

        public static FoxAppObject Load(object app)
        {
            var vfpApp = app as VisualFoxpro.Application;
            var obj = new FoxAppObject { Application = vfpApp };

            Instance = Instance ?? obj;
            return obj;
        }

        public dynamic Eval(string bstrExpr)
        {
            dynamic result = Application?.Eval(bstrExpr);
            return result;
        }

        public void SetVar(string bstrVarName, ref object lpvarNumRows) { Application.SetVar(bstrVarName, ref lpvarNumRows); }
        public dynamic DataToClip(ref object lpvarWrkArea, ref object lpvarNumRows, ref object lpvarClipFormat)
        {
            dynamic result = Application.DataToClip(ref lpvarWrkArea, ref lpvarNumRows, ref lpvarClipFormat);
            return result;
        }

        public void DoCmd(string bstrCmd) { Application.DoCmd(bstrCmd); }
        public void Quit() { Application.Quit(); }
        public dynamic RequestData(ref object lpvarWrkArea, ref object lpvarNumRows)
        {
            dynamic data = Application.RequestData(ref lpvarWrkArea, ref lpvarNumRows);
            return data;
        }

        public int? ProcessId {
            get;
            protected set;
        }

        public IFoxProjects Projects {
            get { return Application?.Projects; }
            set { }
        }
        public string ServerName {
            get; protected set;
        }
        public int? StartMode {
            get { return Application?.StartMode; }
        }

        public string StatusBar {
            get;
            set;
        }
        public int? ThreadId {
            get; protected set;
        }

        public int? Top { get; set; }
        public int? Width { get; set; }

        public string Version { get; }
        public string VFPXMLProgId { get; set; }
        public bool? Visible {
            get { return Application.Visible; }
            set { Application.Visible = value ?? false; }
        }

    }
}

#if VFP

// Decompiled with JetBrains decompiler
// Type: VisualFoxpro.FoxApplicationClass
// Assembly: Interop.VisualFoxpro, Version=8.0.0.0, Culture=neutral, PublicKeyToken=edd8e90038c4334e
// MVID: 6E25841A-1341-4066-8BDF-D39B7BA8899D
// Assembly location: D:\webstack\VSIX\VfpLanguage\bin\Interop.VisualFoxpro.dll

namespace VisualFoxpro
{
    // #region Assembly Interop.VisualFoxpro, Version=8.0.0.0, Culture=neutral, PublicKeyToken=edd8e90038c4334e
    // VfpLanguage\bin\Interop.VisualFoxpro.dll

    [TypeLibType(2)]
    //[ClassInterface(0)]
    //[Guid("00A19610-D8FC-4A3E-A95F-FEA211444BF7")]
    //[ComImport]
    public class FoxApplicationClass : VisualFoxpro.Application, FoxApplication
    {

        // [IndexerName("Name")]
        //[DispId(0)]
        //public virtual string this[int index] {
        //    // [DispId(0), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] 
        //    get { return Name; }
        //    protected set { Name = value; }
        //}

        [DispId(0)]
        public virtual string Name { get; set; }

        [DispId(1)]
        public virtual string FullName { [DispId(1), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(2)]
        public virtual FoxApplication Application { [DispId(2), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(3)]
        public virtual object Parent { [DispId(3), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(4)]
        public virtual bool Visible { [DispId(4), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(4), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(5)]
        public virtual string Version { [DispId(5), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(6)]
        public virtual string Caption { [DispId(6), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(6), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(7)]
        public virtual string DefaultFilePath { [DispId(7), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(7), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(8)]
        public virtual string StatusBar { [DispId(8), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(8), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(9)]
        public virtual int Left { [DispId(9), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(9), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(10)]
        public virtual int Top { [DispId(10), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(10), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(11)]
        public virtual int Width { [DispId(11), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(11), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(12)]
        public virtual int Height { [DispId(12), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(12), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(13)]
        public virtual bool AutoYield { [DispId(13), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(13), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(14)]
        public virtual object ActiveForm { [DispId(14), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(15)]
        public virtual IFoxForms Forms { [DispId(15), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(16)]
        public virtual object Objects { [DispId(16), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(24)]
        public virtual int OLERequestPendingTimeout { [DispId(24), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(24), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(25)]
        public virtual int OLEServerBusyTimeout { [DispId(25), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(25), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(26)]
        public virtual bool OLEServerBusyRaiseError { [DispId(26), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(26), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(27)]
        public virtual int StartMode { [DispId(27), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(28)]
        public virtual IFoxProject ActiveProject { [DispId(28), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(29)]
        public virtual IFoxProjects Projects { [DispId(29), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(30)]
        public virtual string ServerName { [DispId(30), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(31)]
        public virtual int ThreadId { [DispId(31), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(32)]
        public virtual int ProcessId { [DispId(32), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(33)]
        public virtual string EditorOptions { [DispId(33), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(33), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(34)]
        public virtual int LanguageOptions { [DispId(34), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(34), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        [DispId(38)]
        public virtual int hWnd { [DispId(38), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; }

        [DispId(39)]
        public virtual string VFPXMLProgId { [DispId(39), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] get; [DispId(39), MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)] set; }

        // [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        public FoxApplicationClass() { }

        [DispId(17)]
        // [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        public virtual void DoCmd([MarshalAs(UnmanagedType.BStr), In] string bstrCmd) { }

        [DispId(18)]
        // [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        [return: MarshalAs(UnmanagedType.Struct)]
        public virtual object Eval([MarshalAs(UnmanagedType.BStr), In] string bstrExpr)
        {
            return null;
        }

        [DispId(19)]
        // [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        public virtual void Quit() { }

        [DispId(20)]
        // [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        [return: MarshalAs(UnmanagedType.Struct)]
        public virtual object RequestData([MarshalAs(UnmanagedType.Struct), In, Optional] ref object lpvarWrkArea,
            [MarshalAs(UnmanagedType.Struct), In, Optional] ref object lpvarNumRows)
        {
            return null; // TODO
        }

        [DispId(21)]
        // [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        [return: MarshalAs(UnmanagedType.Struct)]
        public virtual object DataToClip(
            [MarshalAs(UnmanagedType.Struct), In, Optional] ref object lpvarWrkArea, 
            [MarshalAs(UnmanagedType.Struct), In, Optional] ref object lpvarNumRows, 
            [MarshalAs(UnmanagedType.Struct), In, Optional] ref object lpvarClipFormat)
        {
            return null; // TODO
        }

        [DispId(22)]
        // [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        public virtual void SetVar([MarshalAs(UnmanagedType.BStr), In] string bstrVarName, 
            [MarshalAs(UnmanagedType.Struct), In] ref object lpvarNumRows) { }

        [DispId(23)]
        // [MethodImpl(MethodImplOptions.InternalCall, MethodCodeType = MethodCodeType.Runtime)]
        public virtual void Help([MarshalAs(UnmanagedType.Struct), In, Optional] ref object lpvarHelpFile, 
            [MarshalAs(UnmanagedType.Struct), In, Optional] ref object lpvarHelpCid, 
            [MarshalAs(UnmanagedType.Struct), In, Optional] ref object lpvarHelpString) { }
    }
}


#endif