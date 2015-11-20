// ClrHost.cpp

#include <atlbase.h>
#include <mscoree.h>

#import "mscorlib.tlb" raw_interfaces_only	no_smart_pointers high_property_prefixes("_get","_put","_putref") 

using namespace mscorlib; 

CComPtr<ICorRuntimeHost>	spRuntimeHost = NULL;
CComPtr<_AppDomain>			spDefAppDomain = NULL;
CComPtr<_Object>            spDefObject = NULL;

BSTR ClrVersion = NULL;

//EXPORTS
//DllMain				  @1
//ClrLoad				  @105
//ClrUnload				  @106
//ClrCreateInstanceFrom   @109
//SetClrVersion			  @110

DWORD WINAPI SetClrVersion(char *version);
DWORD WINAPI ClrLoad(char *ErrorMessage, DWORD *dwErrorSize);
DWORD WINAPI ClrCreateInstance(char *AssemblyName, char *className, char *ErrorMessage, DWORD *dwErrorSize);
DWORD WINAPI ClrCreateInstanceFrom(char *AssemblyFileName, char *className, char *ErrorMessage, DWORD *dwErrorSize);

#define WIN32_LEAN_AND_MEAN
// #include <windows.h>
// #include "resource.h"

// http ://stackoverflow.com/questions/8206736/c-sharp-equivalent-of-dllmain-in-c-winapi

DWORD WINAPI launcher(void* h);

extern "C" BOOL APIENTRY DllMain(HMODULE h, DWORD reasonForCall, void* resv)
{
	if (reasonForCall == DLL_PROCESS_ATTACH)
	{
		CreateThread(0, 0, launcher, h, 0, 0);
	}
	return TRUE;
}

static DWORD WINAPI launcher(void* h)
{
	/*
	HRSRC res = ::FindResourceA(static_cast<HMODULE>(h), MAKEINTRESOURCEA(IDR_DLLENCLOSED), "DLL");
	if (res)
	{
	HGLOBAL dat = ::LoadResource(static_cast<HMODULE>(h), res);
	if (dat)
	{
	unsigned char *dll =
	static_cast<unsigned char*>(::LockResource(dat));
	if (dll)
	{
	size_t len = SizeofResource(static_cast<HMODULE>(h), res);
	LaunchDll(dll, len, "MyNamespace.MyClass", "DllMain");
	}
	}
	}
	*/
	return 0;
}


DWORD WINAPI SetClrVersion(char *version)
{
	ClrVersion = CComBSTR(version);
	return 1;
}

/// Assigns an error message
DWORD WINAPI SetError(HRESULT hr, char *ErrorMessage)
{
	if (ErrorMessage && hr != NULL)
	{
		// size_t: _W64 unsigned int
		size_t len = strlen(ErrorMessage);

		LoadStringRC(hr & 0xffff, (LPWSTR)ErrorMessage, len / 2, 0);

		// c:\Program Files(x86)\Microsoft Visual Studio 12.0\VC\include\stdio.h  sprintf_s
		// sprintf((char *)ErrorMessage,"%ws",ErrorMessage);
		sprintf_s((char *)ErrorMessage, len, "%ws", ErrorMessage);

		// Error	C2664	'int sprintf_s(char *,size_t,const char *,...)'

		return strlen(ErrorMessage);
	}

	strcpy_s(ErrorMessage, 1, "");
	return 0;
}

/// Starts up the CLR and creates a Default AppDomain
DWORD WINAPI ClrLoad(char *ErrorMessage, DWORD *dwErrorSize)
{
	strcpy_s(ErrorMessage, 50, "loading...");
	if (spDefAppDomain)
		return 1;

	
	//Retrieve a pointer to the ICorRuntimeHost interface
	HRESULT hr = CorBindToRuntimeEx(
		ClrVersion,	//Retrieve latest version by default
		L"wks",	//Request a WorkStation build of the CLR
		STARTUP_LOADER_OPTIMIZATION_MULTI_DOMAIN | STARTUP_CONCURRENT_GC,
		CLSID_CorRuntimeHost,
		IID_ICorRuntimeHost,
		(void**)&spRuntimeHost
		);

	if (FAILED(hr))
	{
		*dwErrorSize = SetError(hr, ErrorMessage);
		return hr;
	}

	// Start the CLR
	strcpy_s(ErrorMessage, 50, "spRuntimeHost->Start");
	hr = spRuntimeHost->Start();

	if (FAILED(hr))
		return hr;

	CComPtr<IUnknown> pUnk1 = NULL;
	//Retrieve the IUnknown default AppDomain
	strcpy_s(ErrorMessage, 50, "spRuntimeHost->GetDefaultDomain");
	hr = spRuntimeHost->GetDefaultDomain(&pUnk1);
	if (FAILED(hr)) 
		return hr;

	// swprintf(domainId,L"%s_%i",L"wwDotNetBridge",GetTickCount());
	// swprintf': swprintf has been changed to conform with the ISO C standard, adding an extra character count parameter

	WCHAR domainId[50];
	const size_t maxLen = 49;
	swprintf(domainId, maxLen, L"%s_%i", L"VfpSystem", GetTickCount());

	CComPtr<IUnknown> pUnk = NULL;
	strcpy_s(ErrorMessage, 50, "spRuntimeHost->CreateDomain");
	hr = spRuntimeHost->CreateDomain(domainId, NULL, &pUnk);

	// strcpy_s(ErrorMessage, 50, "spRuntimeHost->CreateDomainSetup");
	// spRuntimeHost->CreateDomainSetup(&pUnk);

	strcpy_s(ErrorMessage, 50, "pUnk->QueryInterface");
	hr = pUnk->QueryInterface(&spDefAppDomain.p);
	if (FAILED(hr))
		return hr;

	strcpy_s(ErrorMessage, 50, "success");
	return 1;
}

// *** Unloads the CLR from the process
DWORD WINAPI ClrUnload()
{
	if (spDefAppDomain)
	{
		spRuntimeHost->UnloadDomain(spDefAppDomain.p);
		spDefAppDomain.Release();
		spDefAppDomain = NULL;

		spRuntimeHost->Stop();
		spRuntimeHost.Release();
		spRuntimeHost = NULL;
	}

	return 1;
}

// *** Creates an instance by Name (ie. local path assembly without extension or GAC'd FullName of any signed assemblies.
DWORD WINAPI ClrCreateInstance(char *AssemblyName, char *className, char *ErrorMessage, DWORD *dwErrorSize)
{
	CComPtr<_ObjectHandle> spObjectHandle;

	if (!spDefAppDomain)
	{
		if (ClrLoad(ErrorMessage, dwErrorSize) != 1)
			return -1;
	}

	DWORD hr;

	//Creates an instance of the type specified in the Assembly
	hr = spDefAppDomain->CreateInstance(
		_bstr_t(AssemblyName),
		_bstr_t(className),
		&spObjectHandle
		);

	*dwErrorSize = 0;
	if (FAILED(hr))
	{
		*dwErrorSize = SetError(hr, ErrorMessage);
		return -1;
	}

	CComVariant VntUnwrapped;
	hr = spObjectHandle->Unwrap(&VntUnwrapped);
	if (FAILED(hr))
		return -1;


	CComPtr<IDispatch> pDisp;
	pDisp = VntUnwrapped.pdispVal;

	return (DWORD)pDisp.p;
}

/// *** Creates an instance of a class from an assembly referenced through it's disk path
DWORD WINAPI ClrCreateInstanceFrom(char *AssemblyFileName, char *className, char *ErrorMessage, DWORD *dwErrorSize)
{
	CComPtr<_ObjectHandle> spObjectHandle;

	if (!spDefAppDomain)
	{
		if (ClrLoad(ErrorMessage, dwErrorSize) != 1)
			return -1;
	}

	DWORD hr;

	//Creates an instance of the type specified in the Assembly
	hr = spDefAppDomain->CreateInstanceFrom(
		_bstr_t(AssemblyFileName),
		_bstr_t(className),
		&spObjectHandle
		);

	*dwErrorSize = 0;

	if (FAILED(hr))
	{
		*dwErrorSize = SetError(hr, ErrorMessage);
		return -1;
	}

	CComVariant VntUnwrapped;
	hr = spObjectHandle->Unwrap(&VntUnwrapped);
	if (FAILED(hr))
		return -1;

	CComPtr<IDispatch> pDisp;
	pDisp = VntUnwrapped.pdispVal;

	// *** pass the raw COM pointer back
	return (DWORD)pDisp.p;
}

