#include <atlbase.h>
#include <mscoree.h>

#import "mscorlib.tlb" raw_interfaces_only	no_smart_pointers high_property_prefixes("_get","_put","_putref") 

using namespace mscorlib;

// https://github.com/FenixTX2/project-helix/blob/master/CLRBootstrap/dllmain.cpp
ICLRRuntimeHost *pClrHost = NULL;
HANDLE hThread;

DWORD __stdcall StartRuntime(LPVOID lpParam)
{
	HRESULT hr = CorBindToRuntimeEx(NULL, L"wks", 0, CLSID_CLRRuntimeHost, IID_ICLRRuntimeHost, (PVOID*)&pClrHost);
	hr = pClrHost->Start();
	MessageBox(0, "Dll Injection Successful! ", "Dll Injector", MB_ICONEXCLAMATION | MB_OK);

	//DWORD dwRet = 0;
	//hr = pClrHost->ExecuteInDefaultAppDomain(L"ClassLibrary2.dll",L"ClassLibrary2.Class1", L"Test", L"MyParameter", &dwRet);   
	//hr = pClrHost->Stop();    
	//pClrHost->Release();
	return 0;
}

BOOL APIENTRY _DllMain(HANDLE hModule, DWORD ul_reason_for_call, LPVOID lpReserved)
{

	switch (ul_reason_for_call)
	{
	case DLL_PROCESS_ATTACH:
		hThread = CreateThread(NULL, 0, (LPTHREAD_START_ROUTINE)&StartRuntime, 0, 0, NULL);
		break;

	case DLL_THREAD_ATTACH:  break;
	case DLL_THREAD_DETACH:  break;
	case DLL_PROCESS_DETACH:

		pClrHost->Stop();
		pClrHost->Release();
		TerminateThread(hThread, 0);
		//MessageBox(0, "Dll Detatch Successful! ", "Dll Injector", MB_ICONEXCLAMATION | MB_OK); 
		break;
	}

	return TRUE;
}

// #if defined (_M_CEE) || defined (MRTDLL)

static int GetDomain(DWORD *pDomain)
{
	*pDomain = 0;
	ICLRRuntimeHost *pClrHost = NULL;

	HRESULT hr = CorBindToRuntimeEx(
		NULL,                       // version of the runtime to request
		NULL,                       // flavor of the runtime to request
		0,                          // runtime startup flags
		CLSID_CLRRuntimeHost,       // clsid of ICLRRuntimeHost
		IID_ICLRRuntimeHost,        // IID of ICLRRuntimeHost
		(PVOID*)&pClrHost);         // a pointer to our punk that we get back

	if (FAILED(hr))
	{
		if (pClrHost != NULL)
		{
			pClrHost->Release();
		}
		return false;
	}

	DWORD domain = 0;
	hr = pClrHost->GetCurrentAppDomainId(&domain);
	pClrHost->Release();
	pClrHost = NULL;
	if (FAILED(hr))
	{
		return false;
	}
	*pDomain = domain;
	return true;
}

// #endif  /* defined (_M_CEE) || defined (MRTDLL) */


