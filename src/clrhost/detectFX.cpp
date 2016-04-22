// https://raw.githubusercontent.com/ProjectHuman/NsisDotNetChecker/master/plugin/detectfx.cpp
// detectFX.cpp

#include <stdio.h>
#include <windows.h>
#include <tchar.h>
#include <strsafe.h>

#include <mscoree.h>
// using namespace mscorlib;

#ifndef defines_section

// In case the machine this is compiled on does not have the most recent platform SDK
// with these values defined, define them here
#ifndef SM_TABLETPC
	#define SM_TABLETPC     86
#endif

#ifndef SM_MEDIACENTER
	#define SM_MEDIACENTER  87
#endif

// Constants that represent registry key names and value names
// to use for detection
const TCHAR *g_szNetfx10RegKeyName = _T("Software\\Microsoft\\.NETFramework\\Policy\\v1.0");
const TCHAR *g_szNetfx10RegKeyValue = _T("3705");
const TCHAR *g_szNetfx10SPxMSIRegKeyName = _T("Software\\Microsoft\\Active Setup\\Installed Components\\{78705f0d-e8db-4b2d-8193-982bdda15ecd}");
const TCHAR *g_szNetfx10SPxOCMRegKeyName = _T("Software\\Microsoft\\Active Setup\\Installed Components\\{FDC11A6F-17D1-48f9-9EA3-9051954BAA24}");
const TCHAR *g_szNetfx11RegKeyName = _T("Software\\Microsoft\\NET Framework Setup\\NDP\\v1.1.4322");
const TCHAR *g_szNetfx20RegKeyName = _T("Software\\Microsoft\\NET Framework Setup\\NDP\\v2.0.50727");
const TCHAR *g_szNetfx30RegKeyName = _T("Software\\Microsoft\\NET Framework Setup\\NDP\\v3.0\\Setup");
const TCHAR *g_szNetfx30SpRegKeyName = _T("Software\\Microsoft\\NET Framework Setup\\NDP\\v3.0");
const TCHAR *g_szNetfx30RegValueName = _T("InstallSuccess");
const TCHAR *g_szNetfx35RegKeyName = _T("Software\\Microsoft\\NET Framework Setup\\NDP\\v3.5");
const TCHAR *g_szNetfx40ClientRegKeyName = _T("Software\\Microsoft\\NET Framework Setup\\NDP\\v4\\Client");
const TCHAR *g_szNetfx40FullRegKeyName = _T("Software\\Microsoft\\NET Framework Setup\\NDP\\v4\\Full");
const TCHAR *g_szNetfx40SPxRegValueName = _T("Servicing");
const TCHAR *g_szNetfx45RegKeyName = _T("Software\\Microsoft\\NET Framework Setup\\NDP\\v4\\Full");
const TCHAR *g_szNetfx45RegValueName = _T("Release");
const TCHAR *g_szNetfxStandardRegValueName = _T("Install");
const TCHAR *g_szNetfxStandardSPxRegValueName = _T("SP");
const TCHAR *g_szNetfxStandardVersionRegValueName = _T("Version");

// Version information for final release of .NET Framework 3.0
const int g_iNetfx30VersionMajor = 3;
const int g_iNetfx30VersionMinor = 0;
const int g_iNetfx30VersionBuild = 4506;
const int g_iNetfx30VersionRevision = 26;

// Version information for final release of .NET Framework 3.5
const int g_iNetfx35VersionMajor = 3;
const int g_iNetfx35VersionMinor = 5;
const int g_iNetfx35VersionBuild = 21022;
const int g_iNetfx35VersionRevision = 8;

// Version information for final release of .NET Framework 4
const int g_iNetfx40VersionMajor = 4;
const int g_iNetfx40VersionMinor = 0;
const int g_iNetfx40VersionBuild = 30319;
const int g_iNetfx40VersionRevision = 0;

// Version information for final release of .NET Framework 4.5
const int g_dwNetfx45ReleaseVersion = 378389;

// Version information for final release of .NET Framework 4.5.1
// The deployment guide says to use value 378758, but the version of the 
// .NET Framework 4.5.1 in Windows 8.1 has value 378675, so we have to use that instead
const int g_dwNetfx451ReleaseVersion = 378675;

// Version information for final release of .NET Framework 4.5.2
const int g_dwNetfx452ReleaseVersion = 379893;

#endif

// Function prototypes
bool CheckNetfxBuildNumber(const TCHAR*, const TCHAR*, const int, const int, const int, const int);
bool RegistryGetValue(HKEY, const TCHAR*, const TCHAR*, DWORD, LPBYTE, DWORD);
bool IsCurrentOSTabletMedCenter();

// int GetNetfx10SPLevel();
// int GetNetfxSPLevel(const TCHAR*, const TCHAR*);

bool IsNetfx10Installed();
bool IsNetfx11Installed();
bool IsNetfx20Installed();
bool IsNetfx30Installed();
bool IsNetfx35Installed();

bool WINAPI IsNetfx40ClientInstalled(void);
bool WINAPI IsNetfx40FullInstalled(void);
bool WINAPI IsNetfx45Installed(void);
bool WINAPI IsNetfx451Installed(void);
//   bool WINAPI IsNetfx452Installed();

/*  extern "C"
void __declspec(dllexport) IsDotNet45Installed(HWND hwndParent, int string_size, char *variables, stack_t **stacktop, extra_parameters *extra) {
	EXDLL_INIT();
	pushstring((IsNetfx45Installed()) ? "true" : "false");
}*/


/******************************************************************
Function Name:	IsNetfx40ClientInstalled
Description:	Uses the detection method recommended at
                http://msdn.microsoft.com/library/ee942965(v=VS.100).aspx
                to determine whether the .NET Framework 4 Client is
                installed on the machine
Inputs:         NONE
Results:        true if the .NET Framework 4 Client is installed
                false otherwise
******************************************************************/
bool WINAPI IsNetfx40ClientInstalled()
{
	bool bRetValue = false;
	DWORD dwRegValue=0;

	if (RegistryGetValue(HKEY_LOCAL_MACHINE, g_szNetfx40ClientRegKeyName, g_szNetfxStandardRegValueName, NULL, (LPBYTE)&dwRegValue, sizeof(DWORD)))
	{
		if (1 == dwRegValue)
			bRetValue = true;
	}

	// A system with a pre-release version of the .NET Framework 4 can
	// have the Install value.  As an added verification, check the
	// version number listed in the registry
	return (bRetValue 
		&& CheckNetfxBuildNumber(g_szNetfx40ClientRegKeyName, g_szNetfxStandardVersionRegValueName, g_iNetfx40VersionMajor, g_iNetfx40VersionMinor, g_iNetfx40VersionBuild, g_iNetfx40VersionRevision));
}


/******************************************************************
Function Name:	IsNetfx40FullInstalled
Description:	Uses the detection method recommended at
                http://msdn.microsoft.com/library/ee942965(v=VS.100).aspx
                to determine whether the .NET Framework 4 Full is
                installed on the machine
Inputs:         NONE
Results:        true if the .NET Framework 4 Full is installed
                false otherwise
******************************************************************/
bool WINAPI IsNetfx40FullInstalled()
{
	bool bRetValue = false;
	DWORD dwRegValue=0;

	if (RegistryGetValue(HKEY_LOCAL_MACHINE, g_szNetfx40FullRegKeyName, g_szNetfxStandardRegValueName, NULL, (LPBYTE)&dwRegValue, sizeof(DWORD)))
	{
		if (1 == dwRegValue)
			bRetValue = true;
	}

	// A system with a pre-release version of the .NET Framework 4 can
	// have the Install value.  As an added verification, check the
	// version number listed in the registry
	return (bRetValue && CheckNetfxBuildNumber(g_szNetfx40FullRegKeyName, g_szNetfxStandardVersionRegValueName, g_iNetfx40VersionMajor, g_iNetfx40VersionMinor, g_iNetfx40VersionBuild, g_iNetfx40VersionRevision));
}


/******************************************************************
Function Name:	IsNetfx45Installed
Description:	Uses the detection method recommended at
                http://msdn.microsoft.com/en-us/library/ee942965(v=vs.110).aspx
                to determine whether the .NET Framework 4.5 is
                installed on the machine
Inputs:         NONE
Results:        true if the .NET Framework 4.5 is installed
                false otherwise
******************************************************************/
bool WINAPI IsNetfx45Installed()
{
	bool bRetValue = false;
	DWORD dwRegValue=0;

	if (RegistryGetValue(HKEY_LOCAL_MACHINE, g_szNetfx45RegKeyName, g_szNetfx45RegValueName, NULL, (LPBYTE)&dwRegValue, sizeof(DWORD)))
	{
		if (g_dwNetfx45ReleaseVersion <= dwRegValue)
			bRetValue = true;
	}

	return bRetValue;
}


/******************************************************************
Function Name:	IsNetfx451Installed
Description:	Uses the detection method recommended at
                http://msdn.microsoft.com/en-us/library/ee942965(v=vs.110).aspx
                to determine whether the .NET Framework 4.5.1 is
                installed on the machine
Inputs:         NONE
Results:        true if the .NET Framework 4.5.1 is installed
                false otherwise
******************************************************************/
bool WINAPI IsNetfx451Installed()
{
	bool bRetValue = false;
	DWORD dwRegValue=0;

	if (RegistryGetValue(HKEY_LOCAL_MACHINE, g_szNetfx45RegKeyName, g_szNetfx45RegValueName, NULL, (LPBYTE)&dwRegValue, sizeof(DWORD)))
	{
		if (g_dwNetfx451ReleaseVersion <= dwRegValue)
			bRetValue = true;
	}

	return bRetValue;
}


// CheckNetfxBuildNumber

/******************************************************************
Function Name:	CheckNetfxBuildNumber
Description:	Retrieves the .NET Framework build number from
the registry and validates that it is not a pre-release
version number
Inputs:         NONE
Results:        true if the build number in the registry is greater
than or equal to the passed in version; false otherwise
******************************************************************/
bool CheckNetfxBuildNumber(const TCHAR *pszNetfxRegKeyName, const TCHAR *pszNetfxRegKeyValue, const int iRequestedVersionMajor, const int iRequestedVersionMinor, const int iRequestedVersionBuild, const int iRequestedVersionRevision)
{
	TCHAR szRegValue[MAX_PATH];
	TCHAR *pszToken = NULL;
	TCHAR *pszNextToken = NULL;
	int iVersionPartCounter = 0;
	int iRegistryVersionMajor = 0;
	int iRegistryVersionMinor = 0;
	int iRegistryVersionBuild = 0;
	int iRegistryVersionRevision = 0;
	bool bRegistryRetVal = false;

	// Attempt to retrieve the build number registry value
	bRegistryRetVal = RegistryGetValue(HKEY_LOCAL_MACHINE, pszNetfxRegKeyName, pszNetfxRegKeyValue, NULL, (LPBYTE)szRegValue, MAX_PATH);

	if (bRegistryRetVal)
	{
		// This registry value should be of the format
		// #.#.#####.##.  Try to parse the 4 parts of
		// the version here
		pszToken = _tcstok_s(szRegValue, _T("."), &pszNextToken);
		while (NULL != pszToken)
		{
			iVersionPartCounter++;

			switch (iVersionPartCounter)
			{
			case 1:
				// Convert the major version value to an integer
				iRegistryVersionMajor = _tstoi(pszToken);
				break;
			case 2:
				// Convert the minor version value to an integer
				iRegistryVersionMinor = _tstoi(pszToken);
				break;
			case 3:
				// Convert the build number value to an integer
				iRegistryVersionBuild = _tstoi(pszToken);
				break;
			case 4:
				// Convert the revision number value to an integer
				iRegistryVersionRevision = _tstoi(pszToken);
				break;
			default:
				break;

			}

			// Get the next part of the version number
			pszToken = _tcstok_s(NULL, _T("."), &pszNextToken);
		}
	}

	// Compare the version number retrieved from the registry with
	// the version number of the final release of the .NET Framework
	// that we are checking
	if (iRegistryVersionMajor > iRequestedVersionMajor)
	{
		return true;
	}
	else if (iRegistryVersionMajor == iRequestedVersionMajor)
	{
		if (iRegistryVersionMinor > iRequestedVersionMinor)
		{
			return true;
		}
		else if (iRegistryVersionMinor == iRequestedVersionMinor)
		{
			if (iRegistryVersionBuild > iRequestedVersionBuild)
			{
				return true;
			}
			else if (iRegistryVersionBuild == iRequestedVersionBuild)
			{
				if (iRegistryVersionRevision >= iRequestedVersionRevision)
				{
					return true;
				}
			}
		}
	}

	// If we get here, the version in the registry must be less than the
	// version of the final release of the .NET Framework we are checking,
	// so return false
	return false;
}


/******************************************************************
Function Name:  IsCurrentOSTabletMedCenter
Description:    Determine if the current OS is a Windows XP
Tablet PC Edition or Windows XP Media Center
Edition system
Inputs:         NONE
Results:        true if the OS is Tablet PC or Media Center
false otherwise
******************************************************************/
bool IsCurrentOSTabletMedCenter()
{
	// Use GetSystemMetrics to detect if we are on a Tablet PC or Media Center OS  
	return ((GetSystemMetrics(SM_TABLETPC) != 0) || (GetSystemMetrics(SM_MEDIACENTER) != 0));
}


/******************************************************************
Function Name:  RegistryGetValue
Description:    Get the value of a reg key
Inputs:         HKEY hk - The hk of the key to retrieve
TCHAR *pszKey - Name of the key to retrieve
TCHAR *pszValue - The value that will be retrieved
DWORD dwType - The type of the value that will be retrieved
LPBYTE data - A buffer to save the retrieved data
DWORD dwSize - The size of the data retrieved
Results:        true if successful, false otherwise
******************************************************************/
bool RegistryGetValue(HKEY hk, const TCHAR * pszKey, const TCHAR * pszValue, DWORD dwType, LPBYTE data, DWORD dwSize)
{
	HKEY hkOpened;

	// Try to open the key
	if (RegOpenKeyEx(hk, pszKey, 0, KEY_READ, &hkOpened) != ERROR_SUCCESS)
	{
		return false;
	}

	// If the key was opened, try to retrieve the value
	if (RegQueryValueEx(hkOpened, pszValue, 0, &dwType, (LPBYTE)data, &dwSize) != ERROR_SUCCESS)
	{
		RegCloseKey(hkOpened);
		return false;
	}

	// Clean up
	RegCloseKey(hkOpened);

	return true;
}


/******************************************************************
Function Name : GetProcessorArchitectureFlag
Description : Determine the processor architecture of the
	system(x86, x64, ia64)
	Inputs : NONE
	Results : DWORD processor architecture flag
***************************************************************** */
DWORD GetProcessorArchitectureFlag()
{
	HMODULE hmodKernel32 = NULL;
	typedef void (WINAPI *PFnGetNativeSystemInfo) (LPSYSTEM_INFO);
	PFnGetNativeSystemInfo pfnGetNativeSystemInfo;

	SYSTEM_INFO sSystemInfo;
	memset(&sSystemInfo, 0, sizeof(sSystemInfo));

	bool bRetrievedSystemInfo = false;

	// Attempt to load kernel32.dll
	hmodKernel32 = LoadLibrary(_T("Kernel32.dll"));
	if (NULL != hmodKernel32)
	{
		// If the DLL loaded correctly, get the proc address for GetNativeSystemInfo
		pfnGetNativeSystemInfo = (PFnGetNativeSystemInfo)GetProcAddress(hmodKernel32, "GetNativeSystemInfo");
		if (NULL != pfnGetNativeSystemInfo)
		{
			// Call GetNativeSystemInfo if it exists
			(*pfnGetNativeSystemInfo)(&sSystemInfo);
			bRetrievedSystemInfo = true;
		}
		FreeLibrary(hmodKernel32);
	}

	if (!bRetrievedSystemInfo)
	{
		// Fallback to calling GetSystemInfo if the above failed
		GetSystemInfo(&sSystemInfo);
		bRetrievedSystemInfo = true;
	}

	if (bRetrievedSystemInfo)
	{
		switch (sSystemInfo.wProcessorArchitecture)
		{
		case PROCESSOR_ARCHITECTURE_INTEL:
			return RUNTIME_INFO_REQUEST_X86;
		case PROCESSOR_ARCHITECTURE_IA64:
			return RUNTIME_INFO_REQUEST_IA64;
		case PROCESSOR_ARCHITECTURE_AMD64:
			return RUNTIME_INFO_REQUEST_AMD64;
		default:
			return 0;
		}
	}

	return 0;
}



#define CountOf(x) sizeof(x)/sizeof(*x)

// Constants for known .NET Framework versions used with the GetRequestedRuntimeInfo API
const TCHAR *g_szNetfx20VersionString = _T("v2.0.50727");
const TCHAR *g_szNetfx40VersionString = _T("v4.0.30319");

