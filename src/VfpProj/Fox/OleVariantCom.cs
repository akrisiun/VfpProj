

using System;
using System.Runtime.InteropServices;
using System.Runtime.CompilerServices;
using System.Reflection;
using System.Globalization;

// More Marshal COM objects
namespace VfpProj.Com
{
    // https://referencesource.microsoft.com/#mscorlib/system/variant.cs,a739c142c6e650ca,references
    // cpy of Variant, no internals, just public

    #region Guids, interfaces IReflect

    [Guid("AFBF15E5-C37C-11d2-B88E-00A0C9B471B8")]
    [ComImport]
    internal interface _IReflect : System.Reflection.IReflect
    { }

    [Guid("AFBF15E6-C37C-11d2-B88E-00A0C9B471B8")]
    [ComImport]
    internal interface _IExpando : _IReflect
    {
        FieldInfo AddField(String name);
        PropertyInfo AddProperty(String name);
        MethodInfo AddMethod(String name, Delegate method);
        void RemoveMember(MemberInfo m);
    }

    // NET40
    //public interface IReflectableType
    //{
    //    TypeInfo GetTypeInfo();
    //}

    internal class Variant
    {
        public VariantCom Com { get; set; }

        internal Variant(VariantCom? o = null)
        {
            Com = o ?? VariantCom.Empty;
        }

    }

    #endregion

    [Serializable]
    [StructLayout(LayoutKind.Sequential)]
    public struct VariantCom : _IReflect
    {
        //Do Not change the order of these fields.
        //They are mapped to the native VariantData * data structure.
        private Object m_objref;
        private int m_data1;
        private int m_data2;
        private int m_flags;

        // The following bits have been taken up as follows
        // bits 0-15    - Type code
        // bit  16      - Array
        // bits 19-23   - Enums
        // bits 24-31   - Optional VT code (for roundtrip VT preservation)

        public VarEnum VarEnum { get; set; }

        public static VariantCom Empty = new VariantCom(string.Empty);
        public static VariantCom DBNull = new VariantCom(global::System.DBNull.Value);

        public Type UnderlyingSystemType { get => m_objref.GetType(); }

        [System.Security.SecuritySafeCritical]  // auto-generated
        public VariantCom(Object obj)
        {
            m_data1 = 0;
            m_data2 = 0;

            VarEnum vt = VarEnum.VT_EMPTY;

            if (obj is DateTime)
            {
                m_objref = null;
                m_flags = CV_DATETIME;
                ulong ticks = (ulong)((DateTime)obj).Ticks;
                m_data1 = (int)ticks;
                m_data2 = (int)(ticks >> 32);

                VarEnum = vt;
                return;
            }

            if (obj is String)
            {
                m_flags = CV_STRING;
                m_objref = obj;

                VarEnum = vt;
                return;
            }

            if (obj == null)
            {
                // this = System.Empty;
                this = VariantCom.Empty;
                //m_objref = Variant.Empty;
                //m_flags = CV_EMPTY;
                //VarEnum = vt;
                return;
            }
            if (obj == System.DBNull.Value)
            {
                this = VariantCom.DBNull;
                //m_objref = System.DBNull.Value;
                //m_flags = CV_NULL;
                //vt = VarEnum.VT_NULL;
                //VarEnum = vt;
                return;
            }
            //if (obj == Type.Missing)
            //{
            //    this = Missing;
            //    VarEnum = vt;
            //    return;
            //}

            if (obj is Array)
            {
                m_flags = CV_OBJECT | ArrayBitMask;
                m_objref = obj;
                VarEnum = vt;
                return;
            }

            // Compiler appeasement
            m_flags = CV_EMPTY;
            m_objref = null;

            // Check to see if the object passed in is a wrapper object.
            if (obj is UnknownWrapper)
            {
                vt = VarEnum.VT_UNKNOWN;
                obj = ((UnknownWrapper)obj).WrappedObject;
            }
            else if (obj is DispatchWrapper)
            {
                vt = VarEnum.VT_DISPATCH;
                obj = ((DispatchWrapper)obj).WrappedObject;
            }

            VarEnum = vt;
        }

        //This is never to be exposed externally.
        internal int CVType {
            get {
                return (m_flags & TypeCodeBitMask);
            }
        }

        #region constants, ToObject

        internal const int CV_EMPTY = 0x0;
        internal const int CV_VOID = 0x1;
        internal const int CV_BOOLEAN = 0x2;
        internal const int CV_CHAR = 0x3;
        //internal const int CV_I1 = 0x4;
        //internal const int CV_U1 = 0x5;
        //internal const int CV_I2 = 0x6;
        //internal const int CV_U2 = 0x7;
        internal const int CV_I4 = 0x8;

        internal const int CV_STRING = 0xe;
        internal const int CV_PTR = 0xf;
        internal const int CV_DATETIME = 0x10;
        internal const int CV_TIMESPAN = 0x11;
        internal const int CV_OBJECT = 0x12;
        internal const int CV_DECIMAL = 0x13;
        internal const int CV_ENUM = 0x15;
        internal const int CV_MISSING = 0x16;
        internal const int CV_NULL = 0x17;
        internal const int CV_LAST = 0x18;

        internal const int TypeCodeBitMask = 0xffff;
        internal const int ArrayBitMask = 0x10000;

        [System.Security.SecurityCritical]  // auto-generated
                                            // [ResourceExposure(ResourceScope.None)]        
        [MethodImpl(MethodImplOptions.InternalCall)]
        internal extern void SetFieldsObject(Object val);

        [System.Security.SecuritySafeCritical]  // auto-generated
        public Object ToObject()
        {
            switch (CVType)
            {
                case CV_EMPTY:
                    return null;
                case CV_BOOLEAN:
                    return (Object)(m_data1 != 0);
                // TODO:
                //case CV_I1:
                //    return (Object)((sbyte)m_data1);
                //case CV_U1:
                //    return (Object)((byte)m_data1);
                //case CV_CHAR:
                //    return (Object)((char)m_data1);
                //case CV_I2:
                //    return (Object)((short)m_data1);
                //case CV_U2:
                //    return (Object)((ushort)m_data1);
                //case CV_I4:
                //    return (Object)(m_data1);
                //case CV_U4:
                //    return (Object)((uint)m_data1);
                //case CV_I8:
                //    return (Object)(GetI8FromVar());
                //case CV_U8:
                //    return (Object)((ulong)GetI8FromVar());
                //case CV_R4:
                //    return (Object)(GetR4FromVar());
                //case CV_R8:
                //    return (Object)(GetR8FromVar());
                //case CV_DATETIME:
                //    return new DateTime(GetI8FromVar());
                //case CV_TIMESPAN:
                //    return new TimeSpan(GetI8FromVar());
                //case CV_ENUM:
                //    return BoxEnum();
                case CV_MISSING:
                    return Type.Missing;
                case CV_NULL:
                    return System.DBNull.Value;
                case CV_DECIMAL:
                case CV_STRING:
                case CV_OBJECT:
                default:
                    return m_objref;
            }
        }

        #endregion

        public MethodInfo[] Methods { get => GetMethods(BindingFlags.Public); }
        public PropertyInfo[] Properties { get => GetProperties(BindingFlags.Public); }

        public MethodInfo[] GetMethods(BindingFlags bindingAttr)
            => new ObjType(this).Type?.GetMethods(bindingAttr);
        public PropertyInfo[] GetProperties(BindingFlags bindingAttr)
            => new ObjType(this).Type?.GetProperties(bindingAttr);
        public FieldInfo[] GetFields(BindingFlags bindingAttr)
            => new ObjType(this).Type?.GetFields(bindingAttr);

        public MethodInfo GetMethod(string name, BindingFlags bindingAttr)
            => new ObjType(this).Type?.GetMethod(name, bindingAttr);
        public MethodInfo GetMethod(string name, BindingFlags bindingAttr, Binder binder, Type[] types, ParameterModifier[] modifiers)
            => new ObjType(this).Type?.GetMethod(name, bindingAttr, binder, types, modifiers);

        public FieldInfo GetField(string name, BindingFlags bindingAttr)
            => new ObjType(this).Type?.GetField(name, bindingAttr);
        public PropertyInfo GetProperty(string name, BindingFlags bindingAttr)
            => new ObjType(this).Type?.GetProperty(name, bindingAttr);
        public PropertyInfo GetProperty(string name, BindingFlags bindingAttr, Binder binder, Type returnType,
            Type[] types, ParameterModifier[] modifiers)
            => new ObjType(this).Type?.GetProperty(name, bindingAttr, binder, returnType, types, modifiers);
        public MemberInfo[] GetMember(string name, BindingFlags bindingAttr)
            => new ObjType(this).Type?.GetMember(name, bindingAttr);
        public MemberInfo[] GetMembers(BindingFlags bindingAttr)
            => new ObjType(this).Type?.GetMembers(bindingAttr);

        public object InvokeMember(string name, BindingFlags invokeAttr, Binder binder, object target, object[] args,
            ParameterModifier[] modifiers, CultureInfo culture, string[] namedParameters)
        {
            object obj = ToObject();
            var type = obj.GetType();
            var result = type.InvokeMember(name, invokeAttr, binder, target, args, modifiers, culture, namedParameters);
            return result;
        }

        public struct ObjType
        {
            public Object obj;
            public Type Type;

            public ObjType(VariantCom com)
            {
                obj = com.ToObject();
                Type = obj?.GetType();
            }
        }
    }

}