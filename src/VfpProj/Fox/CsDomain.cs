using System;
using System.Runtime.InteropServices;
using System.Text;

namespace VfpProj
{
    // Custom c# AppDomain manager  http://mode19.net/Posts/ClrHostingRight

    [ComImport, Guid("A15DDC00-53EF-4776-8DA2-E87399C6654D"), InterfaceType(ComInterfaceType.InterfaceIsIUnknown)]
    public interface ICsDomain
    {
        [return: MarshalAs(UnmanagedType.LPWStr)]
        string toString();

        // string HelloWorld([MarshalAs(UnmanagedType.LPWStr)] string name);
    }

    public class CsDomainManager : AppDomainManager, ICsDomain
    {
        public CsDomainManager() { }
 
        public override void InitializeNewDomain(AppDomainSetup appDomainInfo)
        {
            base.InitializationFlags = AppDomainManagerInitializationOptions.RegisterWithHost;
        }

        [return: MarshalAs(UnmanagedType.LPWStr)]
        public string toString()
        {
            return typeof(CsDomainManager).Name;
        }
    }
}

/*
//When the .NET DLL is built, we want it to show up in the same place as the Win32 application. Go to the project properties, Build tab, and set the output path to ..\Debug
//That's it for the managed assembly side so let's go back to main and set this AppDomainManager on our hosted runtime.
ICLRControl *clrControl = NULL;
hr = runtimeHost->GetCLRControl(&clrControl);
 
hr = clrControl->SetAppDomainManagerType(L"FunProject1", L"VfpProj.CsDomainManager");
hr = runtimeHost->Start();
 
LPWSTR text;
_FooInterface* appDomainManager = hostControl->GetFooInterface();
hr = appDomainManager->HelloWorld(L"Player One", &text);
 
hr = runtimeHost->Stop();
 
wprintf(text);

*/