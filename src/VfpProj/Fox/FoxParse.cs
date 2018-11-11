using System;
using System.Collections.Generic;
// using System.Dynamic;
using System.Runtime.InteropServices;

namespace VfpProj.Fox
{
    using ExpandoObject = Dictionary<string, object>;

    public class FoxParse
    {
        public static ExpandoObject GetMethods(object obj)
        {
            var type = obj.GetType();
            var meths = type.GetMethods();
            IDictionary<string, object> result = new ExpandoObject();

            foreach (var m in meths)
            {
                result[m.Name] = $"void {m.Name}();";
            }

            return result as ExpandoObject;
        }

        public static ExpandoObject GetFields(object obj)
        {
            var type = obj.GetType();
            var fields = type.GetFields();

            IDictionary<string, object> result = new ExpandoObject();

            foreach (var f in fields)
            {
                result[f.Name] = $"{f.Name} = {f.GetValue(obj)};";
            }

            return result as ExpandoObject;

            // Exception GetExceptionForHR(int errorCode);
            // public static Exception GetExceptionForHR(int errorCode, IntPtr errorInfo);
        }

        public static object GetComObjectData(object obj, object key)
        {
            return Marshal.GetComObjectData(obj, key);
        }
    }
}
