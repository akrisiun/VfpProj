using System;
using System.Diagnostics;
using System.Runtime.InteropServices;

namespace VfpProj.Native
{
    using System.Diagnostics;
    using System.Native;
    using System.Runtime.InteropServices;
    using System.Runtime.Remoting;
    using ComTypes = System.Runtime.InteropServices.ComTypes;

    class Interopt
    {
        [System.Security.SecurityCritical]
        internal static object UnwrapIfTransparentProxy(object rcw)
        {
            if (RemotingServices.IsTransparentProxy(rcw))
            {
                IntPtr punk = Marshal.GetIUnknownForObject(rcw);
                try
                {
                    rcw = Marshal.GetObjectForIUnknown(punk);
                }
                finally
                {
                    Marshal.Release(punk);
                }
            }
            return rcw;
        }

        static Guid IID_IManagedObject = new Guid("{C3FCC19E-A970-11D2-8B5A-00A0C9B7C9C4}");

        [System.Security.SecurityCritical]
        public static void Combine(object rcw, Guid iid, int dispid, System.Delegate d)
        {

            rcw = UnwrapIfTransparentProxy(rcw);
            /*
            lock (rcw)
            {
                ComEventsInfo eventsInfo = ComEventsInfo.FromObject(rcw);

                ComEventsSink sink = eventsInfo.FindSink(ref iid);
                if (sink == null)
                {
                    sink = eventsInfo.AddSink(ref iid);
                }


                ComEventsMethod method = sink.FindMethod(dispid);
                if (method == null)
                {
                    method = sink.AddMethod(dispid);
                }

                method.AddDelegate(d);
            }
            */
        }

        internal static ComTypes.ITypeInfo GetITypeInfoFromIDispatch(IDispatch dispatch, bool throwIfMissingExpectedTypeInfo)
        {
            uint typeCount;
            int hresult = dispatch.GetTypeInfoCount(out typeCount);

            Marshal.ThrowExceptionForHR(hresult);
            Debug.Assert(typeCount <= 1);

            if (typeCount == 0)
            {
                return null;
            }

            IntPtr typeInfoPtr = IntPtr.Zero;
            hresult = dispatch.GetTypeInfo(0, 0, out typeInfoPtr);

            if (!ComHresults.IsSuccess(hresult))
            {
                // CheckIfMissingTypeInfoIsExpected(hresult, throwIfMissingExpectedTypeInfo);
                return null;

            }

            if (typeInfoPtr == IntPtr.Zero)
            { // be defensive against components that return IntPtr.Zero

                if (throwIfMissingExpectedTypeInfo)
                {
                    // Marshal.ThrowExceptionForHR(ComHresults.E_FAIL);
                }
                return null;
            }

            ComTypes.ITypeInfo typeInfo = null;
            try
            {

                typeInfo = Marshal.GetObjectForIUnknown(typeInfoPtr) as ComTypes.ITypeInfo;
            }
            finally
            {
                Marshal.Release(typeInfoPtr);
            }

            return typeInfo;
        }

    }
}


namespace System.Native
{
    using ComTypes = System.Runtime.InteropServices.ComTypes;

    // The enum of the return value of IQuerable.GetInterface
    //====================================================================
    [Serializable]
    [System.Runtime.InteropServices.ComVisible(false)]
    public enum CustomQueryInterfaceResult
    {
        Handled = 0,
        NotHandled = 1,
        Failed = 2,
    }

    public interface ICustomQueryInterface
    {
        [System.Security.SecurityCritical]
        CustomQueryInterfaceResult GetInterface([In]ref Guid iid, out IntPtr ppv);
    }

    [System.Security.SecurityCritical]
    internal class ComEventsSink : IDispatch, ICustomQueryInterface
    {
        #region private fields

        private Guid _iidSourceItf;
        private ComTypes.IConnectionPoint _connectionPoint;
        private int _cookie;
        // private ComEventsMethod _methods;
        // private ComEventsSink _next;

        #endregion

        internal ComEventsSink(object rcw, Guid iid, Type type)
        {
            _iidSourceItf = iid;
            Type = type;
            this.Advise(rcw);
        }

        public Type Type { get; set; }

        #region ICustomQueryInterface

        [System.Security.SecurityCritical]
        CustomQueryInterfaceResult ICustomQueryInterface.GetInterface([In]ref Guid iid, out IntPtr ppv)
        {
            if (iid == typeof(IDispatch).GUID)
            {
                ppv = Marshal.GetComInterfaceForObject(this, Type);
                return CustomQueryInterfaceResult.Handled;
            }

            ppv = IntPtr.Zero;
            return CustomQueryInterfaceResult.NotHandled;
        }

        #endregion

        private void Advise(object rcw)
        {
            Debug.Assert(_connectionPoint == null, "comevent sink is already advised");

            ComTypes.IConnectionPointContainer cpc = (ComTypes.IConnectionPointContainer)rcw;
            ComTypes.IConnectionPoint cp;
            cpc.FindConnectionPoint(ref _iidSourceItf, out cp);

            object sinkObject = this;
            cp.Advise(sinkObject, out _cookie);
            _connectionPoint = cp;
        }

        [System.Security.SecurityCritical]
        private void Unadvise()
        {
            Debug.Assert(_connectionPoint != null, "can not unadvise from empty connection point");
            try
            {
                _connectionPoint.Unadvise(_cookie);
                Marshal.ReleaseComObject(_connectionPoint);
            }
            catch (System.Exception)
            {
                // swallow all exceptions on unadvise
                // the host may not be available at this point
            }
            finally
            {
                _connectionPoint = null;
            }
        }

        [System.Security.SecurityCritical]
        // NativeMethods.IDispatch.
        public unsafe int TryInvoke(
            int dispIdMember,
            ref Guid riid,
            int lcid,
            ComTypes.INVOKEKIND wFlags,
            ref ComTypes.DISPPARAMS pDispParams,
            out object VarResult,
            out ComTypes.EXCEPINFO pExcepInfo,
            out uint puArgErr)
        {

            //ComEventsMethod method = FindMethod(dispid);
            //if (method == null)
            //    return;
            VarResult = null;
            puArgErr = 0;
            pExcepInfo = default(ComTypes.EXCEPINFO);

            return 0;
        }

        [System.Security.SecurityCritical]
        public int GetTypeInfoCount(out uint pctinfo)
        {
            pctinfo = 0;
            return ComHresults.S_OK;
        }

        [System.Security.SecurityCritical]
        public int GetTypeInfo(uint iTInfo, int lcid, out IntPtr info)
        {
            throw new NotImplementedException();
            // return ComHresults.S_OK;
        }

        [System.Security.SecurityCritical]
        public void GetIDsOfNames(ref Guid iid, string[] names, uint cNames, int lcid, int[] rgDispId)
        {
            throw new NotImplementedException();
        }

    }


    [
      ComImport,
      InterfaceType(ComInterfaceType.InterfaceIsIDispatch),
      Guid("00020400-0000-0000-C000-000000000046")
    ]
    internal interface IDispatchForReflection
    {
    }

    [
    System.Security.SuppressUnmanagedCodeSecurity,
    ComImport,
    InterfaceType(ComInterfaceType.InterfaceIsIUnknown),
    Guid("00020400-0000-0000-C000-000000000046"),
    ]
    internal interface IDispatch
    {
        //[PreserveSig]
        //int TryGetTypeInfoCount(out uint pctinfo);
        // TryGetTypeInfoCount(out typeCount);
        //[PreserveSig]
        //int TryGetTypeInfo(uint iTInfo, int lcid, out IntPtr info);

        [PreserveSig]
        int GetTypeInfoCount(out uint pctinfo);
        [PreserveSig]
        int GetTypeInfo(uint iTInfo, int lcid, out IntPtr info);

        //[PreserveSig]
        //int TryGetIDsOfNames(
        //    ref Guid iid,
        //    [MarshalAs(UnmanagedType.LPArray, ArraySubType = UnmanagedType.LPWStr, SizeParamIndex = 2)]
        //    string[] names, uint cNames,
        //    int lcid,
        //    [Out]
        //    [MarshalAs(UnmanagedType.LPArray, ArraySubType = UnmanagedType.I4, SizeParamIndex = 2)]
        //    int[] rgDispId);

        [PreserveSig]
        int TryInvoke(
            int dispIdMember,
            ref Guid riid,
            int lcid,
            ComTypes.INVOKEKIND wFlags,
            ref ComTypes.DISPPARAMS pDispParams,
            out object VarResult,
            out ComTypes.EXCEPINFO pExcepInfo,
            out uint puArgErr);

    }

    // Layout of the IDispatch vtable
    internal enum IDispatchMethodIndices
    {
        IUnknown_QueryInterface,
        IUnknown_AddRef,
        IUnknown_Release,

        IDispatch_GetTypeInfoCount,
        IDispatch_GetTypeInfo,
        IDispatch_GetIDsOfNames,
        IDispatch_Invoke
    }

    [
    ComImport,
    InterfaceType(ComInterfaceType.InterfaceIsIUnknown),
    Guid("B196B283-BAB4-101A-B69C-00AA00341D07")
    ]
    internal interface IProvideClassInfo
    {
        void GetClassInfo(out IntPtr info);

    }


    internal static class ComHresults
    {
        internal const int S_OK = 0;

        internal const int CONNECT_E_NOCONNECTION = unchecked((int)0x80040200);
        internal const int DISP_E_UNKNOWNINTERFACE = unchecked((int)0x80020001);
        internal const int DISP_E_MEMBERNOTFOUND = unchecked((int)0x80020003);
        internal const int DISP_E_PARAMNOTFOUND = unchecked((int)0x80020004);
        internal const int DISP_E_TYPEMISMATCH = unchecked((int)0x80020005);
        internal const int DISP_E_UNKNOWNNAME = unchecked((int)0x80020006); // GetIDsOfName
        internal const int DISP_E_NONAMEDARGS = unchecked((int)0x80020007);

        internal const int DISP_E_BADVARTYPE = unchecked((int)0x80020008);
        internal const int DISP_E_EXCEPTION = unchecked((int)0x80020009);
        internal const int DISP_E_OVERFLOW = unchecked((int)0x8002000A);
        internal const int DISP_E_BADINDEX = unchecked((int)0x8002000B); // GetTypeInfo
        internal const int DISP_E_UNKNOWNLCID = unchecked((int)0x8002000C);
        internal const int DISP_E_ARRAYISLOCKED = unchecked((int)0x8002000D); // VariantClear
        internal const int DISP_E_BADPARAMCOUNT = unchecked((int)0x8002000E);
        internal const int DISP_E_PARAMNOTOPTIONAL = unchecked((int)0x8002000F);

        internal const int E_NOINTERFACE = unchecked((int)0x80004002);
        internal const int E_FAIL = unchecked((int)0x80004005);
        internal const int TYPE_E_LIBNOTREGISTERED = unchecked((int)0x8002801D);

        internal static bool IsSuccess(int hresult)
        {
            return hresult >= 0;
        }
    }
}
