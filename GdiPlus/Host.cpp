// ClrHost.cpp

//#include <atlbase.h>
#include <mscoree.h>

//#import "mscorlib.tlb" raw_interfaces_only	no_smart_pointers high_property_prefixes("_get","_put","_putref") 

//using namespace mscorlib;
using namespace System;

//CComPtr<ICorRuntimeHost>	spRuntimeHost = NULL;
//CComPtr<_AppDomain>			spDefAppDomain = NULL;
//CComPtr<_Object>            spDefObject = NULL;
BSTR ClrVersion = NULL;

//EXPORTS
//DllMain              @1

 
/// Assigns an error message
DWORD WINAPI SetError(HRESULT hr, char *ErrorMessage)
{
	if (ErrorMessage && hr != NULL)
	{
		size_t len = strlen(ErrorMessage);

		// LoadStringRC deprecated
		// DEPRECATED_CLR_STDAPI LoadStringRCEx(LCID lcid, UINT iResouceID, __out_ecount_z(iMax) LPWSTR szBuffer, int iMax, int bQuiet, int *pcwchUsed);
		//LoadStringRC(hr & 0xffff, (LPWSTR)ErrorMessage, len / 2, 0);
		
		/*__out LPWSTR,
			__in __format_string LPCWSTR,*/
		//wsprintf((char *)ErrorMessage, "%ws", ErrorMessage);

		// _In_ wint_t _
		// iswprint((char *)ErrorMessage, len, "%ws", ErrorMessage);

		//#include <vcclr.h>
		//System::String/* * str = S"Hello world\n";
		//const __wchar_*/t __pin * str1 = PtrToStringChars(str);
		//wprintf(str1);

		return strlen(ErrorMessage);
	}

	//[DllImport("kernel32.dll")]
	//static extern ErrorModes  SetErrorMode(ErrorModes uMode);

	strcpy_s(ErrorMessage, 1, "");
	return 0;
}

// Interop.VisualFoxpro
// Visual Foxpro 8.0 Type Library
// {00A19611-D8FC-4A3E-A95F-FEA211444BF7}\8.0\0\tlbimp


/*
	/OUT:"..\lib\GdiPlus.dll" /MANIFEST /PDB:"..\lib\GdiPlus.pdb"
    /DYNAMICBASE:NO "odbc32.lib" "odbccp32.lib" "wsock32.lib" "wininet.lib" "gdiplus.lib" "mscoree.lib" "kernel32.lib"
			"user32.lib" "gdi32.lib" "winspool.lib" "comdlg32.lib" "advapi32.lib" "shell32.lib" "ole32.lib" "oleaut32.lib" "uuid.lib" 
    /DEF:".\GdiPlusHost.def" /FIXED:NO /DEBUG /DLL /MACHINE:X86 /SAFESEH /INCREMENTAL /PGD:"..\lib\GdiPlus.pgd" 
	/SUBSYSTEM:WINDOWS",5.01" /MANIFESTUAC:"level='highestAvailable' uiAccess='false'" 
	/ManifestFile:"..\lib\GdiPlusDebug\GdiPlus.dll.intermediate.manifest" /ERRORREPORT:PROMPT /NOLOGO /TLBID:1 

	[DllImport("kernel32.dll")]
	static extern ErrorModes  SetErrorMode(ErrorModes uMode);

	http://stackoverflow.com/questions/6080605/can-i-use-seterrormode-in-c-sharp-process
	DEPRECATED_CLR_STDAPI LoadStringRC

	timer = new Stopwatch();
	timer.Reset();

	submitProg = new Process();
	submitProg.StartInfo.FileName = outputFile;
	submitProg.StartInfo.UseShellExecute = false;
	submitProg.StartInfo.CreateNoWindow = true;
	submitProg.StartInfo.RedirectStandardInput = true;
	submitProg.StartInfo.RedirectStandardOutput = true;
	submitProg.StartInfo.RedirectStandardError = true;
	submitProg.StartInfo.ErrorDialog = false;
	submitProg.StartInfo.WindowStyle = ProcessWindowStyle.Hidden;
	submitProg.EnableRaisingEvents = true;

	submitProg.Start();
	timer.Start();

	progInput = submitProg.StandardInput;
	progOutput = submitProg.StandardOutput;

	progInput.Write(inputStream.ReadToEnd());
	submitProg.StandardInput.Close();
	while (!submitProg.HasExited)
	{
	peakPagedMem = submitProg.PeakPagedMemorySize64;
	peakVirtualMem = submitProg.PeakVirtualMemorySize64;
	peakWorkingSet = submitProg.PeakWorkingSet64;
	if (peakPagedMem > memLimit)
	{
	submitProg.Kill();
	}
	if (timer.ElapsedMilliseconds > timeLimit)
	{
	timeLimitExceed = true;
	submitProg.Kill();
	}
	}

	timeUsed = timer.ElapsedMilliseconds;
	timer.Stop();

	if(submitProg.ExitCode!=0)systemRuntimeError = true;
*/