#pragma once

// #include <sqlncli.h>
// #include "sqlncli.h"
#include <C:\\Program Files\\Microsoft SQL Server\\110\\SDK\\Include\\sqlncli.h>
// sqlncli.h sdk

/// OUT:"..\..\lib\ClrHost.dll" / MANIFEST / PDB : "..\..\lib\ClrHost.pdb"
/// DYNAMICBASE : NO "odbc32.lib" "odbccp32.lib" "wsock32.lib" "wininet.lib" "gdiplus.lib" "mscoree.lib"
//"kernel32.lib" "user32.lib" "gdi32.lib" "winspool.lib" "comdlg32.lib" "advapi32.lib" "shell32.lib" "ole32.lib" "oleaut32.lib" "uuid.lib
//" / DEF : ".\ClrHost.def" / IMPLIB : "..\..\lib\ClrHost.lib" / DEBUG / DLL / MACHINE : X86 / SAFESEH / INCREMENTAL / PGD : "..\..\lib\ClrHost.pgd" 
/// SUBSYSTEM : WINDOWS",5.01" / MANIFESTUAC : "level='highestAvailable' uiAccess='false'" 
/// ManifestFile : "..\..\lib\Debug\ClrHost.dll.intermediate.manifest" / ERRORREPORT : PROMPT / NOLOGO / TLBID : 1


// Registry: HKLM\SOFTWARE\Microsoft\Sqlncli10
// File : Check for sqlncli10.dll in \System32

class SqlOpenRowset
{
	public:
	SqlOpenRowset();
	~SqlOpenRowset();

	HRESULT OpenRowset();
};

