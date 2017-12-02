using System;
using System.Reflection;
using System.Runtime.InteropServices;
using System.Runtime.InteropServices.ComTypes;
// using System.ServiceModel.Diagnostics;
// using System.ServiceModel.ComIntegration;
using Microsoft.Win32;

namespace VfpProj.Native
{
    class TypeLib
    {
        static Guid GettypeLibraryIDFromIID(Guid iid, bool isServer, out String version)
        {
            // In server we need to open the the User hive for the Process User.
            RegistryKey interfaceKey = null;
            try
            {
                string keyName = null;
                if (isServer)
                {
                    keyName = String.Concat("software\\classes\\interface\\{", iid.ToString(), "}\\typelib");
                    interfaceKey = Registry.LocalMachine.OpenSubKey(keyName, false);
                }
                else
                {
                    keyName = String.Concat("interface\\{", iid.ToString(), "}\\typelib");
                    interfaceKey = Registry.ClassesRoot.OpenSubKey(keyName, false);
                }

                version = null;
                if (interfaceKey == null)
                    return default(Guid); // throw InterfaceNotRegistered

                string typeLibID = interfaceKey.GetValue("").ToString();
                if (string.IsNullOrEmpty(typeLibID))
                    return default(Guid); // throw NoTypeLibraryFoundForInterface)));

                version = interfaceKey.GetValue("Version").ToString();
                if (string.IsNullOrEmpty(version))
                    version = "1.0";

                Guid typeLibraryID;
                if (! // DiagnosticUtility.Utility.
                        TryCreateGuid(typeLibID, out typeLibraryID))
                {
                    return default(Guid); // throw BadInterfaceRegistration)));
                }

                return typeLibraryID;
            }
            finally
            {
                if (interfaceKey != null)
                    interfaceKey.Close();
            }

        }

        internal static bool TryCreateGuid(string guidString, out Guid result)
        {
            bool success = false;
            result = Guid.Empty;
            try
            {
                result = new Guid(guidString);
                success = true;
            }
            catch (ArgumentException) { }
            catch (FormatException) { }
            catch (OverflowException) { }

            return success;
        }

    }
}
