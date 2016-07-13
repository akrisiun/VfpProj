#define _WIN32_WINNT 0x0400

#include <windows.h>
#include <stdio.h> // sprintf, memcpy and other common C library routines

#include "pro_ext.h" // general FoxPro library header
#include "vfp2c32.h"
#include "vfp2cutil.h"
#include "vfp2cmarshal.h"
#include "vfpmacros.h"

// handle to our default heap which is created at load time
HANDLE ghHeap = 0;

// codepage for Unicode character conversion
UINT gnConvCP = CP_ACP;

// dynamic function pointers
static PHEAPCOMPACT fpHeapCompact = 0;
static PHEAPVALIDATE fpHeapValidate = 0;
static PHEAPWALK fpHeapWalk = 0;

#ifdef _DEBUG
static LPDBGALLOCINFO gpDbgInfo = 0;
static BOOL gbTrackAlloc = FALSE;
#endif

/*
extern HMODULE ghModule;
extern OSVERSIONINFOEX gsOSVerInfo;
DWORD gnFoxVersion;
DWORD gnErrorCount;
VFP2CERROR gaErrorInfo[VFP2C_MAX_ERRORS];
*/


BOOL _stdcall VFP2C_Init_Marshal()
{
	HMODULE hDll;
	int nErrorNo;
	// vars for changing the heap allocation algorithm
	PHEAPSETINFO fpHeapSetInformation;
	HEAP_INFORMATION_CLASS pInfo = HeapCompatibilityInformation;
	ULONG nLFHFlag = 2;

	// create default Heap
	if (!(ghHeap = HeapCreate(0,HEAP_INITIAL_SIZE,0)))
	{
		ADDWIN32ERROR(HeapCreate,GetLastError());
		return FALSE;
	}

	// we can use GetModuleHandle instead of LoadLibrary since kernel32.dll is loaded already by VFP for sure
	hDll = GetModuleHandle("kernel32.dll");
	if (hDll)
	{
		fpHeapSetInformation = (PHEAPSETINFO)GetProcAddress(hDll,"HeapSetInformation");
		// if HeapSetInformation is supported (only on WinXP), call it to make our heap a low-fragmentation heap.
		if (fpHeapSetInformation)
			fpHeapSetInformation(ghHeap,pInfo,&nLFHFlag,sizeof(ULONG));

		fpHeapCompact = (PHEAPCOMPACT)GetProcAddress(hDll,"HeapCompact");
		fpHeapValidate = (PHEAPVALIDATE)GetProcAddress(hDll,"HeapValidate");
		fpHeapWalk = (PHEAPWALK)GetProcAddress(hDll,"HeapWalk");
	}
	else
	{
		ADDWIN32ERROR(GetModuleHandle,GetLastError());
		return FALSE;
	}

	// declare additional functions not nativly exported by the FLL
	// FLLFILENAME is a #define which resolves to either "vfp2c32.fll" or "vfp2c32d.fll" (on debug build)
	// and "somestring ""someotherstring" is truncated by the compiler to "somestring someotherstring" .. 
	// it looks a bit argward .. but is a nice way to overcome a #if _DEBUG ... #else ... #endif ... where 
	// all the DECLARE strings are the same except the fll filename ..
	if (nErrorNo = EXECUTE("DECLARE WriteChar IN "FLLFILENAME" INTEGER, STRING"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WritePChar IN "FLLFILENAME" INTEGER, STRING"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WriteInt8 IN "FLLFILENAME" INTEGER, INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WritePInt8 IN "FLLFILENAME" INTEGER, INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WriteUInt8 IN "FLLFILENAME" INTEGER, INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WritePUInt8 IN "FLLFILENAME" INTEGER, INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WriteShort IN "FLLFILENAME" INTEGER, SHORT"))	
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WritePShort IN "FLLFILENAME" INTEGER, SHORT"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WriteUShort IN "FLLFILENAME" INTEGER, SHORT"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WritePUShort IN "FLLFILENAME" INTEGER, SHORT"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WriteInt IN "FLLFILENAME" INTEGER, INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WritePInt IN "FLLFILENAME" INTEGER, INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WriteUInt IN "FLLFILENAME" INTEGER, INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WritePUInt IN "FLLFILENAME" INTEGER, INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WritePointer IN "FLLFILENAME" INTEGER, INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WritePPointer IN "FLLFILENAME" INTEGER, INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WriteFloat IN "FLLFILENAME" INTEGER, SINGLE"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WritePFloat IN "FLLFILENAME" INTEGER, SINGLE"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WriteDouble IN "FLLFILENAME" INTEGER, DOUBLE"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE WritePDouble IN "FLLFILENAME" INTEGER, DOUBLE"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE SHORT ReadInt8 IN "FLLFILENAME" INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE SHORT ReadPInt8 IN "FLLFILENAME" INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE SHORT ReadUInt8 IN "FLLFILENAME" INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE SHORT ReadPUInt8 IN "FLLFILENAME" INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE SHORT ReadShort IN "FLLFILENAME" INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE SHORT ReadPShort IN "FLLFILENAME" INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE INTEGER ReadUShort IN "FLLFILENAME" INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE INTEGER ReadPUShort IN "FLLFILENAME" INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE INTEGER ReadInt IN "FLLFILENAME" INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE INTEGER ReadPInt IN "FLLFILENAME" INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE SINGLE ReadFloat IN "FLLFILENAME" INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE SINGLE ReadPFloat IN "FLLFILENAME" INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE DOUBLE ReadDouble IN "FLLFILENAME" INTEGER"))
		goto ErrorOut;
	if (nErrorNo = EXECUTE("DECLARE DOUBLE ReadPDouble IN "FLLFILENAME" INTEGER"))
		goto ErrorOut;
	
	return TRUE;

	ErrorOut:
		ADDCUSTOMERROREX("_Execute","Failed to DECLARE function. Error %I",nErrorNo);
		return FALSE;
}

void _stdcall VFP2C_Destroy_Marshal()
{
	if (ghHeap)
		HeapDestroy(ghHeap);

#ifdef _DEBUG
	FreeDebugAlloc();
#endif

	EXECUTE("CLEAR DLLS 'WriteChar','WritePChar','WriteInt8','WritePInt8','WriteUInt8','WritePUInt8','WriteShort',"
	"'WritePShort','WriteUShort','WritePUShort','WriteInt','WritePInt','WriteUInt','WritePUInt','WritePointer','WritePPointer',"
	"'WriteFloat','WritePFloat','WriteDouble','WritePDouble','ReadInt8','ReadPInt8','ReadUInt8','ReadPUInt8','ReadShort',"
	"'ReadPShort','ReadUShort','ReadPUShort','ReadInt','ReadPInt','ReadFloat','ReadPFloat','ReadDouble','ReadPDouble'");
}

int _stdcall Win32HeapExceptionHandler(int nExceptionCode)
{
	gnErrorCount = 0;
	gaErrorInfo[0].nErrorType = VFP2C_ERRORTYPE_WIN32;
	gaErrorInfo[0].nErrorNo = nExceptionCode;
	strcpy(gaErrorInfo[0].aErrorFunction,"HeapAlloc/HeapReAlloc");

	if (nExceptionCode == STATUS_NO_MEMORY)
		strcpy(gaErrorInfo[0].aErrorMessage,"The allocation attempt failed because of a lack of available memory or heap corruption.");
	else if (nExceptionCode == STATUS_ACCESS_VIOLATION)
		strcpy(gaErrorInfo[0].aErrorMessage,"The allocation attempt failed because of heap corruption or improper function parameters.");
	else
		strcpy(gaErrorInfo[0].aErrorMessage,"Unknown exception code.");

	return EXCEPTION_EXECUTE_HANDLER;
}


#ifdef _DEBUG

void _stdcall AddDebugAlloc(void* pPointer, int nSize)
{
	VALUE(vProgInfo);
	LPDBGALLOCINFO pDbg;	
	char *pProgInfo = 0;

	if (pPointer && gbTrackAlloc)
	{
		pDbg = malloc(sizeof(DBGALLOCINFO));
		if (!pDbg)
			return;

		EVALUATE(vProgInfo,"ALLTRIM(STR(LINENO())) + ':' + PROGRAM() + CHR(0)");
		if (IS_STRING(vProgInfo))
		{
			pProgInfo = strdup(HANDTOPTR(vProgInfo));
			FREEHAND(vProgInfo);
		}

		pDbg->pPointer = pPointer;
		pDbg->pProgInfo = pProgInfo;
		pDbg->nSize = nSize;
		pDbg->next = gpDbgInfo;
		gpDbgInfo = pDbg;
	}
}

void _stdcall RemoveDebugAlloc(void* pPointer)
{
	LPDBGALLOCINFO pDbg = gpDbgInfo, pDbgPrev = 0;
    
	if (pPointer && gbTrackAlloc)
	{
		while (pDbg && pDbg->pPointer != pPointer)
		{
			pDbgPrev = pDbg;
			pDbg = pDbg->next;
		}

		if (pDbg)
		{
			if (pDbgPrev)
				pDbgPrev->next = pDbg->next;
			else
				gpDbgInfo = pDbg->next;

			if (pDbg->pProgInfo)
				free(pDbg->pProgInfo);
			free(pDbg);
		}
	}
}

void _stdcall ReplaceDebugAlloc(void* pOrig, void* pNew, int nSize)
{
	LPDBGALLOCINFO pDbg = gpDbgInfo;
	VALUE(vProgInfo);
	char* pProgInfo = 0;

	if (!pNew || !gbTrackAlloc)
		return;
    
	while (pDbg && pDbg->pPointer != pOrig)
		pDbg = pDbg->next;

    if (pDbg)
	{
		EVALUATE(vProgInfo,"ALLTRIM(STR(LINENO())) + ':' + PROGRAM() + CHR(0)");
		if (IS_STRING(vProgInfo))
		{
			pProgInfo = strdup(HANDTOPTR(vProgInfo));
			FREEHAND(vProgInfo);
		}

		if (pDbg->pProgInfo)
			free(pDbg->pProgInfo);

		pDbg->pPointer = pNew;
		pDbg->pProgInfo = pProgInfo;
		pDbg->nSize = nSize;
	}
}

void _stdcall FreeDebugAlloc()
{
	LPDBGALLOCINFO pDbg = gpDbgInfo, pDbgEx;
	while (pDbg)
	{
		pDbgEx = pDbg->next;
		if (pDbg->pProgInfo)
			free(pDbg->pProgInfo);
		free(pDbg);
		pDbg = pDbgEx;
	}
	gpDbgInfo = 0;
}

void _fastcall AMemLeaks(ParamBlk *parm)
{
	char *pArrayName;
	Locator lArrayLoc;
	int nErrorNo;
	INTEGER(vMem);
	STRING(vMemInfo);
	char *pMemInfo;
	LPDBGALLOCINFO pDbg = gpDbgInfo;

	if (!pDbg)
	{
		RET_INTEGER(0);
		return;
	}

	if (!NULLTERMINATE(p1))
		RAISEERROR(E_INSUFMEMORY);

	LOCKHAND(p1);	
	pArrayName = HANDTOPTR(p1);

	if (!ALLOCHAND(vMemInfo,VFP2C_ERROR_MESSAGE_LEN))
	{
		nErrorNo = E_INSUFMEMORY;
		goto ErrorOut;
	}
	LOCKHAND(vMemInfo);
	pMemInfo = HANDTOPTR(vMemInfo);

	if (nErrorNo = DimensionEx(pArrayName,&lArrayLoc,1,4))
		goto ErrorOut;

	while (pDbg)
	{
		if (nErrorNo = Dimension(pArrayName,++AROW(lArrayLoc),4))
			goto ErrorOut;

		vMem.ev_long = (int)pDbg->pPointer;
		ADIM(lArrayLoc) = 1;
		if (nErrorNo = STORE(lArrayLoc,vMem))
			goto ErrorOut;

		vMem.ev_long = pDbg->nSize;
        ADIM(lArrayLoc) = 2;
		if (nErrorNo = STORE(lArrayLoc,vMem))
			goto ErrorOut;

		if (pDbg->pProgInfo)
			vMemInfo.ev_length = strncpyex(pMemInfo,pDbg->pProgInfo,VFP2C_ERROR_MESSAGE_LEN);
		else
			vMemInfo.ev_length = 0;
		ADIM(lArrayLoc) = 3;
		if (nErrorNo = STORE(lArrayLoc,vMemInfo))
			goto ErrorOut;

		vMemInfo.ev_length = min(pDbg->nSize,VFP2C_ERROR_MESSAGE_LEN);
		memcpy(pMemInfo,pDbg->pPointer,vMemInfo.ev_length);
		ADIM(lArrayLoc) = 4;
		if (nErrorNo = STORE(lArrayLoc,vMemInfo))
			goto ErrorOut;

		pDbg = pDbg->next;
	}

	UNLOCKHAND(p1);
	UNLOCKHAND(vMemInfo);
	FREEHAND(vMemInfo);
	RET_AROWS(lArrayLoc);
	return;
	
	ErrorOut:
		UNLOCKHAND(p1);
		if (VALIDHAND(vMemInfo))
		{
			UNLOCKHAND(vMemInfo);
			FREEHAND(vMemInfo);
		}
		RAISEERROR(nErrorNo);
}

void _fastcall TrackMem(ParamBlk *parm)
{
	gbTrackAlloc = (BOOL)p1.ev_length;
	if (PCOUNT() == 2 && p2.ev_length)
		FreeDebugAlloc();
}

#endif // DEBUG

// FLL memory allocation functions using FLL's standard heap
void _fastcall AllocMem(ParamBlk *parm)
{
	void *pAlloc = 0;
	__try
	{
		pAlloc = HeapAlloc(ghHeap,HEAP_ZE_FLAG,p1.ev_long);
	}
	__except(SAVEHEAPEXCEPTION()) { }

	ADDDEBUGALLOC(pAlloc,p1.ev_long);

	RET_POINTER(pAlloc);
}

void _fastcall AllocMemTo(ParamBlk *parm)
{
	void *pAlloc = 0;

	if (!p1.ev_long)
		RAISEERROR(E_INVALIDPARAMS);

	__try
	{
		pAlloc = HeapAlloc(ghHeap,HEAP_ZE_FLAG,p2.ev_long);
	}
	__except(SAVEHEAPEXCEPTION()) { }
	
	if (pAlloc)
		*(void**)p1.ev_long = pAlloc;

	ADDDEBUGALLOC(pAlloc,p2.ev_long);

	RET_POINTER(pAlloc);
}

void _fastcall ReAllocMem(ParamBlk *parm)
{
	void *pAlloc = 0;
	__try
	{
		if (p1.ev_long)
		{
			pAlloc = HeapReAlloc(ghHeap,HEAP_ZE_FLAG,(void*)p1.ev_long,p2.ev_long);
			REPLACEDEBUGALLOC(p1.ev_long,pAlloc,p2.ev_long);
		}
		else
		{
			pAlloc = HeapAlloc(ghHeap,HEAP_ZE_FLAG,p2.ev_long);
			ADDDEBUGALLOC(pAlloc,p2.ev_long);
		}
    }
	__except(SAVEHEAPEXCEPTION()) { }

	RET_POINTER(pAlloc);
}

void _fastcall FreeMem(ParamBlk *parm)
{
	if (p1.ev_long)
	{
		if (HeapFree(ghHeap,0,(void*)p1.ev_long))
		{
			REMOVEDEBUGALLOC(p1.ev_long);
			RET_INTEGER(1);
		}
		else
		{
			SAVEWIN32ERROR(HeapFree,GetLastError());
			RAISEERROREX(0);
		}
	}
	else
		RET_INTEGER(1);
}

void _fastcall FreePMem(ParamBlk *parm)
{
	void* pAlloc;
	if (p1.ev_long)
	{
		if ((pAlloc = *(void**)p1.ev_long))
		{
			if (HeapFree(ghHeap,0,pAlloc))
			{
				REMOVEDEBUGALLOC(pAlloc);
				RET_INTEGER(1);
			}
			else
			{
				SAVEWIN32ERROR(HeapFree,GetLastError());
				RAISEERROREX(0);
			}
		}
	}
	else
		RET_INTEGER(1);
}

void _fastcall FreeRefArray(ParamBlk *parm)
{
	void **pAddress;
	int nStartElement, nElements;
	BOOL bApiRet = TRUE;

	if (p2.ev_long < 1 || p2.ev_long > p3.ev_long)
		RAISEERROR(E_INVALIDPARAMS);

	pAddress = (void**)p1.ev_long;
	nStartElement = --p2.ev_long;
	nElements = p3.ev_long;
	pAddress += nStartElement;
	nElements -= nStartElement;
	
	RESETWIN32ERRORS();

	while(nElements--)
	{
		if (*pAddress)
		{
			if (!HeapFree(ghHeap,0,*pAddress))
			{
				ADDWIN32ERROR(HeapFree,GetLastError());
				bApiRet = FALSE;
			}
		}
		pAddress++;
	}
	RET_LOGICAL(bApiRet);
}

void _fastcall SizeOfMem(ParamBlk *parm)
{
	if (p1.ev_long)
		RET_INTEGER(HeapSize(ghHeap,0,(void*)p1.ev_long));
	else
		RET_INTEGER(0);
}

void _fastcall ValidateMem(ParamBlk *parm)
{
	if (fpHeapValidate)
		RET_LOGICAL(fpHeapValidate(ghHeap,0,(void*)p1.ev_long));
	else
		RET_LOGICAL(FALSE);
}

void _fastcall CompactMem(ParamBlk *parm)
{
	if (fpHeapCompact)
		RET_INTEGER(fpHeapCompact(ghHeap,0));
	else
		RET_INTEGER(0);
}

// wrappers around GlobalAlloc, GlobalFree etc .. for movable memory objects ..
void _fastcall AllocHGlobal(ParamBlk *parm)
{
	HGLOBAL hMem;
	hMem = GlobalAlloc(GMEM_MOVEABLE|GMEM_ZEROINIT,(SIZE_T)p1.ev_long);
	if (hMem)
	{
		ADDDEBUGALLOC(hMem,p1.ev_long);
		RET_INTEGER(hMem);
	}
	else
	{
		SAVEWIN32ERROR(GlobalAlloc,GetLastError());
		RAISEERROREX(0);
	}
}

void _fastcall FreeHGlobal(ParamBlk *parm)
{
	if (!GlobalFree((HGLOBAL)p1.ev_long)) /* returns NULL on success */
	{
		REMOVEDEBUGALLOC(p1.ev_long);
		RET_INTEGER(1);
	}
	else
	{
		SAVEWIN32ERROR(GlobalFree,GetLastError());
		RAISEERROREX(0);
	}
}

void _fastcall ReAllocHGlobal(ParamBlk *parm)
{
	HGLOBAL hMem;
	hMem = GlobalReAlloc((HGLOBAL)p1.ev_long,(SIZE_T)p2.ev_long,GMEM_MOVEABLE|GMEM_ZEROINIT);
	if (hMem)
	{
		REPLACEDEBUGALLOC(p1.ev_long,hMem,p2.ev_long);		
		RET_INTEGER(hMem);
	}
	else
	{
		SAVEWIN32ERROR(GlobalReAlloc,GetLastError());
		RAISEERROREX(0);
	}
}

void _fastcall LockHGlobal(ParamBlk *parm)
{
	LPVOID pMem;
	pMem = GlobalLock((HGLOBAL)p1.ev_long);
	if (pMem)
		RET_POINTER(pMem);
	else
	{
		SAVEWIN32ERROR(GlobalLock,GetLastError());
		RAISEERROREX(0);
	}
}

void _fastcall UnlockHGlobal(ParamBlk *parm)
{
	BOOL bRet;
	DWORD nLastError;
	
	bRet = GlobalUnlock((HGLOBAL)p1.ev_long);

	if (!bRet)
	{
		nLastError = GetLastError();
		if (nLastError == NO_ERROR)
			RET_INTEGER(1);
		else
		{
			SAVEWIN32ERROR(GlobalUnlock,nLastError);
			RAISEERROREX(0);
		}
	}
	else
		RET_INTEGER(2);
}

void _fastcall AMemBlocks(ParamBlk *parm)
{
	char *pArrayName;
	Locator lArrayLoc;
	int nErrorNo;
	PROCESS_HEAP_ENTRY pEntry;
	INTEGER(vAddress);
	INTEGER(vSize);
	INTEGER(vOverhead);
	DWORD nLastError;

	if (!fpHeapWalk)
		RAISEERROR(E_NOENTRYPOINT);

	if (!NULLTERMINATE(p1))
		RAISEERROR(E_INSUFMEMORY);

	LOCKHAND(p1);	
	pArrayName = HANDTOPTR(p1);

	if (nErrorNo = DimensionEx(pArrayName,&lArrayLoc,1,3))
		goto ErrorOut;

	pEntry.lpData = NULL;

	if (!fpHeapWalk(ghHeap,&pEntry))
	{
		nLastError = GetLastError();
		UNLOCKHAND(p1);
		if (nLastError == ERROR_NO_MORE_ITEMS)
		{
			RET_INTEGER(0);
			return;
		}
		else
		{
			SAVEWIN32ERROR(HeapWalk,nLastError);
			RET_INTEGER(-1);
		}
	}

	do 
	{
		AROW(lArrayLoc)++;

		if ((nErrorNo = Dimension(pArrayName,AROW(lArrayLoc),3)))
			break;

		ADIM(lArrayLoc) = 1;
		vAddress.ev_long = (long)pEntry.lpData;
		if (nErrorNo = STORE(lArrayLoc,vAddress))
			break;

		ADIM(lArrayLoc) = 2;
		vSize.ev_long = pEntry.cbData;
		if (nErrorNo = STORE(lArrayLoc,vSize))
			break;

		ADIM(lArrayLoc) = 3;
		vOverhead.ev_long = pEntry.cbOverhead;
		if (nErrorNo = STORE(lArrayLoc,vOverhead))
			break;

	} while (fpHeapWalk(ghHeap,&pEntry));
	
	nLastError = GetLastError();

	if (nErrorNo)
		goto ErrorOut;

	UNLOCKHAND(p1);

    if (nLastError == ERROR_NO_MORE_ITEMS)
	{
		RET_AROWS(lArrayLoc);
		return;
	}
	else
	{
		SAVEWIN32ERROR(HeapWalk,nLastError);
		RET_INTEGER(-1);
		return;
	}

	ErrorOut:
		UNLOCKHAND(p1);
		RAISEERROR(nErrorNo);
}

void _stdcall WriteChar(char *pAddress, char* nNewVal)
{
	*pAddress = *nNewVal;
}

void _stdcall WritePChar(char **pAddress, char* nNewVal)
{
	**pAddress = *nNewVal;
}

void _fastcall WriteWChar(ParamBlk *parm)
{
	if (p2.ev_length)
	{
		MultiByteToWideChar(PCOUNT() == 2 ? gnConvCP : (UINT)p3.ev_long,0,HANDTOPTR(p2),1,(wchar_t*)p1.ev_long,1);
	}
	else
		*(wchar_t*)p1.ev_long = L'\0';
}

void _fastcall WritePWChar(ParamBlk *parm)
{
	if (p2.ev_length)
	{
		MultiByteToWideChar(PCOUNT() == 2 ? gnConvCP : (UINT)p3.ev_long,0,HANDTOPTR(p2),1,*(wchar_t**)p1.ev_long,1);
	}
	else
		**(wchar_t**)p1.ev_long = L'\0';
}

void _stdcall WriteInt8(__int8 *pAddress, int nNewVal)
{
	*pAddress = (__int8)nNewVal;
}

void _stdcall WritePInt8(__int8 **pAddress, int nNewVal)
{
	**pAddress = (__int8)nNewVal;
}

void _stdcall WriteUInt8(unsigned __int8 *pAddress, unsigned int nNewVal)
{
	*pAddress = (unsigned __int8)nNewVal;
}

void _stdcall WritePUInt8(unsigned __int8 **pAddress, unsigned int nNewVal)
{
	**pAddress = (unsigned __int8)nNewVal;
}

void _stdcall WriteShort(short *pAddress, short nNewVal)
{
	*pAddress = nNewVal;
}

void _stdcall WritePShort(short **pAddress, short nNewVal)
{
	**pAddress = nNewVal;
}

void _stdcall WriteUShort(unsigned short *pAddress, unsigned short nNewVal)
{
	*pAddress = nNewVal;
}

void _stdcall WritePUShort(unsigned short **pAddress, unsigned short nNewVal)
{
	**pAddress = nNewVal;
}

void _stdcall WriteInt(int *pAddress, int nNewVal)
{
	*pAddress = nNewVal;
}

void _stdcall WritePInt(int **pAddress, int nNewVal)
{
	**pAddress = nNewVal;
}

void _stdcall WriteUInt(unsigned int *pAddress, unsigned int nNewVal)
{
	*pAddress = nNewVal;
}

void _stdcall WritePUInt(unsigned int **pAddress, unsigned int nNewVal)
{
	**pAddress = nNewVal;
}

void _stdcall WritePointer(void **pAddress, void *nNewVal)
{
	*pAddress = nNewVal;
}

void _stdcall WritePPointer(void ***pAddress, void *nNewVal)
{
	**pAddress = nNewVal;
}

void _stdcall WriteFloat(float *pAddress, float nNewVal)
{
	*pAddress = nNewVal;
}

void _stdcall WritePFloat(float **pAddress, float nNewVal)
{
	**pAddress = nNewVal;
}

void _stdcall WriteDouble(double *pAddress, double nNewVal)
{
	*pAddress = nNewVal;
}

void _stdcall WritePDouble(double **pAddress, double nNewVal)
{
	**pAddress = nNewVal;
}

void _fastcall WriteCString(ParamBlk *parm)
{
	char *pNewAddress = 0;

	__try
	{
		if (p1.ev_long)
		{
			pNewAddress = HeapReAlloc(ghHeap,HEAP_E_FLAG,(void*)p1.ev_long,p2.ev_length+1);
			REPLACEDEBUGALLOC(p1.ev_long,pNewAddress,p2.ev_length+1);
		}
		else
		{
			pNewAddress = HeapAlloc(ghHeap,HEAP_E_FLAG,p2.ev_length+1);
			ADDDEBUGALLOC(pNewAddress,p2.ev_length+1);
		}
	}
	__except(SAVEHEAPEXCEPTION()) { }

	if (pNewAddress)
	{
		LOCKHAND(p2);
		memcpy(pNewAddress,HANDTOPTR(p2),p2.ev_length);
		pNewAddress[p2.ev_length] = '\0';
		UNLOCKHAND(p2);
		RET_POINTER(pNewAddress);
	}
	else
		RAISEERROREX(0);
}

/*
void _fastcall WriteGCString(ParamBlk *parm)
{
	HGLOBAL hHandle;
	char *pAddress, *pString;

	if (!EXPANDHAND(p2,1))
		RAISEERROR(E_E_INSUFMEMORY);

	if (p1.ev_long)
		hHandle = GlobalAlloc(GMEM_MOVEABLE,p2.ev_length+1);
	else
		hHandle = GlobalReAlloc((HGLOBAL)p1.ev_long,p2.ev_length+1,GMEM_MOVEABLE); 

	if (hHandle)
	{
		pAddress = GlobalLock(hHandle);
		memcpy(pAddress,HANDTOPTR(p2),p2.ev_length);
		pAddress[p2.ev_length] = '\0';
		GlobalUnlock(hHandle);
		RET_POINTER(hHandle);
	}
	else 
		RAISEWIN32ERROR(p1.ev_long ? "GlobalAlloc" : "GlobalReAlloc");
}
*/

void _fastcall WritePCString(ParamBlk *parm)
{
	char *pNewAddress = 0;
	char **pOldAddress = (char**)p1.ev_long;

	if (IS_STRING(p2) && pOldAddress)
	{
		__try
		{
			if ((*pOldAddress))
			{
				pNewAddress = HeapReAlloc(ghHeap,HEAP_E_FLAG,(*pOldAddress),p2.ev_length+1);
				REPLACEDEBUGALLOC(*pOldAddress,pNewAddress,p2.ev_length);
			}
			else
			{
				pNewAddress = HeapAlloc(ghHeap,HEAP_E_FLAG,p2.ev_length+1);
				ADDDEBUGALLOC(pNewAddress,p2.ev_length);
			}
		}
		__except(SAVEHEAPEXCEPTION()) { }

		if (pNewAddress)
		{
			*pOldAddress = pNewAddress;
			LOCKHAND(p2);
			memcpy(pNewAddress,HANDTOPTR(p2),p2.ev_length);
			pNewAddress[p2.ev_length] = '\0';		
			UNLOCKHAND(p2);
			RET_POINTER(pNewAddress);
			return;
		}
		else
			RAISEERROREX(0);
	}
	else if (IS_NULL(p2) && pOldAddress)
	{
		if ((*pOldAddress))
		{
			if (HeapFree(ghHeap,0,*pOldAddress))
			{
				REMOVEDEBUGALLOC(*pOldAddress);
				*pOldAddress = 0;
				RET_INTEGER(1);
			}
			else
			{
				SAVEWIN32ERROR(HeapFree,GetLastError());
				RAISEERROREX(0);
			}
		}
		else
			RET_INTEGER(1);
	}
	else
		RAISEERROR(E_INVALIDPARAMS);
}

void _fastcall WriteWString(ParamBlk *parm)
{
	int nStringLen, nBytesNeeded, nBytesWritten;
    wchar_t *pDest = 0;
	
	nStringLen = (int)p2.ev_length;
	nBytesNeeded = nStringLen * sizeof(wchar_t) + sizeof(wchar_t);

	__try
	{
		if (p1.ev_long)
		{
			pDest = HeapReAlloc(ghHeap,HEAP_E_FLAG,(wchar_t*)p1.ev_long,nBytesNeeded);
			REPLACEDEBUGALLOC(p1.ev_long,pDest,nBytesNeeded);
		}
		else
		{
			pDest = HeapAlloc(ghHeap,HEAP_E_FLAG,nBytesNeeded);
			ADDDEBUGALLOC(pDest,nBytesNeeded);
		}
	}
	__except(SAVEHEAPEXCEPTION()) { }

	if (pDest)
	{
		if (nStringLen)
		{
			LOCKHAND(p2);
			nBytesWritten = MultiByteToWideChar(PCOUNT() == 2 ? gnConvCP : (UINT)p3.ev_long,0,HANDTOPTR(p2),nStringLen,pDest,nBytesNeeded);
			UNLOCKHAND(p2);
			if (nBytesWritten)
				pDest[nBytesWritten] = L'\0';
			else
				RAISEWIN32ERROR(MultiByteToWideChar,GetLastError());
		}
		else
			pDest[0] = L'\0';
		RET_POINTER(pDest);
	}
	else
		RAISEERROREX(0);
}

void _fastcall WritePWString(ParamBlk *parm)
{
	int nStringLen, nBytesNeeded, nBytesWritten;
	wchar_t *pDest = 0;
	wchar_t **pOld = (wchar_t**)p1.ev_long;

	if (IS_STRING(p2) && pOld)
	{
		nStringLen = (int)p2.ev_length;
		nBytesNeeded = nStringLen * sizeof(wchar_t) + sizeof(wchar_t);

		__try
		{
			if ((*pOld))
			{
				pDest = HeapReAlloc(ghHeap,HEAP_ZE_FLAG,*pOld,nBytesNeeded);
				REPLACEDEBUGALLOC(*pOld,pDest,nBytesNeeded);
			}
			else
			{
				pDest = HeapAlloc(ghHeap,HEAP_ZE_FLAG,nBytesNeeded);
				ADDDEBUGALLOC(pDest,nBytesNeeded);
			}
		}
		__except(SAVEHEAPEXCEPTION()) { }

		if (pDest)
		{
			LOCKHAND(p2);
			nBytesWritten = MultiByteToWideChar(PCOUNT() == 2 ? gnConvCP : (UINT)p3.ev_long,0,HANDTOPTR(p2),nStringLen,pDest,nBytesNeeded);
			UNLOCKHAND(p2);
			if (nBytesWritten)
			{
				pDest[nBytesWritten] = L'\0';
				*pOld = pDest;
			}
			else
				RAISEWIN32ERROR(MultiByteToWideChar,GetLastError());
		}
		else
			RAISEERROREX(0);
	}
	else if (IS_NULL(p2) && pOld)
	{
		if ((*pOld))
		{
			if (HeapFree(ghHeap,0,*pOld))
			{
				REMOVEDEBUGALLOC(*pOld);
				*pOld = 0;
				RET_INTEGER(0);
			}
			else
			{
				SAVEWIN32ERROR(HeapFree,GetLastError());
				RAISEERROREX(0);
			}
		}
		else
			RET_INTEGER(0);
	}
	else
		RAISEERROR(E_INVALIDPARAMS);
}

void _fastcall WriteCharArray(ParamBlk *parm)
{
	char *pDest = (char*)p1.ev_long;

	LOCKHAND(p2);
	if (PCOUNT() == 2 || (long)p2.ev_length < p3.ev_long)
	{
		memcpy(pDest,HANDTOPTR(p2),p2.ev_length);
		pDest[p2.ev_length] = '\0';
	}
	else
	{
		memcpy(pDest,HANDTOPTR(p2),p3.ev_long);
		pDest[p3.ev_long-1] = '\0';
	}
	UNLOCKHAND(p2);
}

void _fastcall WriteWCharArray(ParamBlk *parm)
{
	int nBytesWritten, nArrayWidth, nStringLen;
	wchar_t *pDest = (wchar_t*)p1.ev_long;
	nArrayWidth = p3.ev_long - 1; // -1 for null terminator
	nStringLen = (int)p2.ev_length;

	if (nStringLen)
	{
		LOCKHAND(p2);
		nBytesWritten = MultiByteToWideChar(PCOUNT() == 3 ? gnConvCP : (UINT)p4.ev_long,0,HANDTOPTR(p2),min(nStringLen,nArrayWidth),pDest,nArrayWidth);
		UNLOCKHAND(p2);
		if (nBytesWritten)
			pDest[nBytesWritten] = L'\0';
		else
			RAISEWIN32ERROR(MultiByteToWideChar,GetLastError());
	}
	else
		*pDest = L'\0';
}

void _fastcall WriteBytes(ParamBlk *parm)
{
	LOCKHAND(p2);
	memcpy((void*)p1.ev_long,HANDTOPTR(p2),PCOUNT() == 3 ? min(p2.ev_length,(UINT)p3.ev_long) : p2.ev_length);
	UNLOCKHAND(p2);
}

void _fastcall WriteLogical(ParamBlk *parm)
{
	*(unsigned int*)p1.ev_long = p2.ev_length;
}

void _fastcall WritePLogical(ParamBlk *parm)
{
	**(unsigned int**)p1.ev_long = p2.ev_length;
}

void _fastcall ReadChar(ParamBlk *parm)
{
	char *pChar;
	STRINGN(cChar,1);
	if (ALLOCHAND(cChar,1))
	{
		pChar = HANDTOPTR(cChar);
		if (p1.ev_long)
			*pChar = *(char*)p1.ev_long;
		else
			*pChar = '\0';
		
		RET_VALUE(cChar);
		return;
	}
	else
		RAISEERROR(E_INSUFMEMORY);
}

void _fastcall ReadPChar(ParamBlk *parm)
{
	char *pChar;
	STRINGN(cChar,1);

	if (ALLOCHAND(cChar,1))
	{
		pChar = HANDTOPTR(cChar);
		if (p1.ev_long && *(char**)p1.ev_long)
			*pChar = **(char**)p1.ev_long;
		else
			*pChar = '\0';

		RET_VALUE(cChar);
		return;
	}
	else
		RAISEERROR(E_INSUFMEMORY);
}

short _stdcall ReadInt8(__int8 *pAddress)
{
	return (short)*pAddress;
}

short _stdcall ReadPInt8(__int8 **pAddress)
{
	return (short)**pAddress;
}

unsigned short _stdcall ReadUInt8(unsigned __int8 *pAddress)
{
	return (unsigned short)*pAddress;
}

unsigned short _stdcall ReadPUInt8(unsigned __int8 **pAddress)
{
	return (unsigned short)**pAddress;
}

short _stdcall ReadShort(short *pAddress)
{
	return *pAddress;
}

short _stdcall ReadPShort(short **pAddress)
{
	return **pAddress;
}

// Cast unsigned short's to next bigger type cause "DECLARE SHORT .." in VFP is limited to signed short's
// this problem only occurs when returning unsigned values from C to VFP not when they are set
// e.g "DECLARE WriteUShort INTERGER, SHORT" works nicely cause VFP converts the value correctly to an
// unsigned short. But when returning values back to VFP it always assumes them to be signed, which
// makes this workaround neccessary. (the same is true for INTEGER/LONG) 
unsigned int _stdcall ReadUShort(unsigned short *pAddress)
{
	return (unsigned int)*pAddress;
}

unsigned int _stdcall ReadPUShort(unsigned short **pAddress)
{
	return (unsigned int)**pAddress;
}

int _stdcall ReadInt(int *pAddress)
{
	return *pAddress;
}

int _stdcall ReadPInt(int **pAddress)
{
	return **pAddress;
}

// Cast to double (float is not big enough to hold an unsigned long)
// cause of sign problem (see ReadUShort for an explanation)
void _fastcall ReadUInt(ParamBlk *parm)
{
	if (*(int*)p1.ev_long >= 0)
		RET_INTEGER(*(int*)p1.ev_long);
	else
		RET_UINTEGER(*(unsigned int*)p1.ev_long);
}

void _fastcall ReadPUInt(ParamBlk *parm)
{
	if (**(int**)p1.ev_long >= 0)
		RET_INTEGER(**(int**)p1.ev_long);
	else
		RET_UINTEGER(**(unsigned int**)p1.ev_long);
}

void _fastcall ReadInt64AsDouble(ParamBlk *parm)
{
	RET_INT64(*(__int64*)p1.ev_long);
}

void _fastcall ReadUInt64AsDouble(ParamBlk *parm)
{
	RET_INT64(*(unsigned __int64*)p1.ev_long);
}

float _stdcall ReadFloat(float *pAddress)
{
	return *pAddress;
}

float _stdcall ReadPFloat(float **pAddress)
{
	return **pAddress;
}

double _stdcall ReadDouble(double *pAddress)
{
	return *pAddress;
}

double _stdcall ReadPDouble(double **pAddress)
{
	return **pAddress;
}

void _fastcall ReadCString(ParamBlk *parm)
{
	char aNothing[1];
	if (p1.ev_long)
	{
		_RetChar((char*)p1.ev_long);
		return;
	}
	else
	{
		aNothing[0] = '\0';
		_RetChar((char*)aNothing);
	}
}

void _fastcall ReadCharArray(ParamBlk *parm)
{
	STRING(cBuffer);
	char* pDest;

	if (ALLOCHAND(cBuffer,p2.ev_long))
	{
		LOCKHAND(cBuffer);
		pDest = HANDTOPTR(cBuffer);
		cBuffer.ev_length = strncpyex(pDest,(const char*)p1.ev_long,p2.ev_long);
		UNLOCKHAND(cBuffer);
		RET_VALUE(cBuffer);
	}
	else
		RAISEERROR(E_INSUFMEMORY);
}

void _fastcall ReadPCString(ParamBlk *parm)
{
	char aNothing[1];
	if (*(char**)p1.ev_long)
		_RetChar(*(char**)p1.ev_long);
	else
	{
		aNothing[0] = '\0';
		_RetChar((char*)aNothing);
	}
}

void _fastcall ReadWString(ParamBlk *parm)
{
	STRING(cBuffer);
	int nStringLen, nBufferLen;

	nStringLen = lstrlenW((wchar_t*)p1.ev_long);
	if (nStringLen)
	{
		nBufferLen = nStringLen * sizeof(wchar_t);
		if (ALLOCHAND(cBuffer,nBufferLen))
		{
			LOCKHAND(cBuffer);
			nBufferLen = WideCharToMultiByte(PCOUNT() == 1 ? gnConvCP : (UINT)p2.ev_long,0,(wchar_t*)p1.ev_long,nStringLen,HANDTOPTR(cBuffer),nBufferLen,0,0);
			UNLOCKHAND(cBuffer);
			if (nBufferLen)
			{
				cBuffer.ev_length = (unsigned int)nBufferLen;
				RET_VALUE(cBuffer);
				return;
			}
			else
				RAISEWIN32ERROR(WideCharToMultiByte,GetLastError());
		}
		else
			RAISEERROR(E_INSUFMEMORY);
	}
	cBuffer.ev_length = 0;
	RET_VALUE(cBuffer);
}

void _fastcall ReadPWString(ParamBlk *parm)
{
	STRING(cBuffer);
	int nStringLen, nBufferLen;

	if (*(wchar_t**)p1.ev_long)
	{
		nStringLen = lstrlenW(*(wchar_t**)p1.ev_long);
		if (nStringLen)
		{
			nBufferLen = nStringLen * sizeof(wchar_t);
			if (ALLOCHAND(cBuffer,nBufferLen))
			{
				LOCKHAND(cBuffer);
				nBufferLen = WideCharToMultiByte(PCOUNT() == 1 ? gnConvCP : (UINT)p2.ev_long,0,*(wchar_t**)p1.ev_long,nStringLen,HANDTOPTR(cBuffer),nBufferLen,0,0);
				UNLOCKHAND(cBuffer);
				if (nBufferLen)
				{
					cBuffer.ev_length = (unsigned int)nBufferLen;
					RET_VALUE(cBuffer);
					return;
				}
				else
					RAISEWIN32ERROR(WideCharToMultiByte,GetLastError());
			}
			else
				RAISEERROR(E_INSUFMEMORY);
		}
	}
	cBuffer.ev_length = 0;
	RET_VALUE(cBuffer);
}

void _fastcall ReadWCharArray(ParamBlk *parm)
{
	STRING(cBuffer);
	int nBufferLen, nStringLen;
	nBufferLen = p2.ev_long * sizeof(wchar_t);

	if (ALLOCHAND(cBuffer,nBufferLen))
	{
		nStringLen = wstrnlen((wchar_t*)p1.ev_long,p2.ev_long);
		if (nStringLen)
		{
			LOCKHAND(cBuffer);
			nBufferLen = WideCharToMultiByte(PCOUNT() == 2 ? gnConvCP : (UINT)p3.ev_long,0,(wchar_t*)p1.ev_long,nStringLen,HANDTOPTR(cBuffer),nBufferLen,0,0);
			UNLOCKHAND(cBuffer);
			if (nBufferLen)
			{
				cBuffer.ev_length = (unsigned int)nBufferLen;
				RET_VALUE(cBuffer);
				return;
			}
			else
				RAISEWIN32ERROR(WideCharToMultiByte,GetLastError());
		}
		else
		{
			cBuffer.ev_length = 0;
			RET_VALUE(cBuffer);
			return;
		}
	}
	else
		RAISEERROR(E_INSUFMEMORY);
}

void _fastcall ReadLogical(ParamBlk *parm)
{
	_RetLogical(*(int*)p1.ev_long);
}

void _fastcall ReadPLogical(ParamBlk *parm)
{
	_RetLogical(**(int**)p1.ev_long);
}

void _fastcall ReadBytes(ParamBlk *parm)
{
	STRINGN(cBuffer,p2.ev_long);
	if (ALLOCHAND(cBuffer,p2.ev_long))
	{
		LOCKHAND(cBuffer);
		memcpy(HANDTOPTR(cBuffer),(void*)p1.ev_long,p2.ev_long);
		UNLOCKHAND(cBuffer);
		RET_VALUE(cBuffer);
		return;
	}
	else
		RAISEERROR(E_INSUFMEMORY);
}

void _fastcall UnMarshalArrayShort(ParamBlk *parm)
{
	SHORT(tmpValue);
	ARRAYLOCALS(short*)

	BEGIN_ARRAYGET()
		tmpValue.ev_long = (long)*pAddress;
	END_ARRAYGET(++)
}

void _fastcall UnMarshalArrayUShort(ParamBlk *parm)
{
	SHORT(tmpValue);
	ARRAYLOCALS(unsigned short*)

	BEGIN_ARRAYGET()
		tmpValue.ev_long = (long)*pAddress;
	END_ARRAYGET(++)
}

void _fastcall UnMarshalArrayInt(ParamBlk *parm)
{
	INTEGER(tmpValue);
	ARRAYLOCALS(long*)

	BEGIN_ARRAYGET()
		tmpValue.ev_long = *pAddress;
	END_ARRAYGET(++)
}

void _fastcall UnMarshalArrayUInt(ParamBlk *parm)
{
	UINTEGER(tmpValue);
	ARRAYLOCALS(unsigned long*)
	
	BEGIN_ARRAYGET()
		tmpValue.ev_real = (double)*pAddress;
	END_ARRAYGET(++)
}

void _fastcall UnMarshalArrayFloat(ParamBlk *parm)
{
	FLOAT(tmpValue);
	ARRAYLOCALS(float*)
	
	BEGIN_ARRAYGET()
		tmpValue.ev_real = (double)*pAddress;
	END_ARRAYGET(++)
}

void _fastcall UnMarshalArrayDouble(ParamBlk *parm)
{
	DOUBLE(tmpValue);
	ARRAYLOCALS(double*)

	BEGIN_ARRAYGET()
		tmpValue.ev_real = *pAddress;
	END_ARRAYGET(++)
}

void _fastcall UnMarshalArrayLogical(ParamBlk *parm)
{
	LOGICAL(tmpValue);
	ARRAYLOCALS(BOOL*)

	BEGIN_ARRAYGET()
		tmpValue.ev_length = *pAddress;
	END_ARRAYGET(++)
}

void _fastcall UnMarshalArrayCString(ParamBlk *parm)
{
	void* pDest;
	int nStringLen, nBufferLen = 256;
	STRING(tmpValue);
	ARRAYLOCALS(char**)

	if (!ALLOCHAND(tmpValue,nBufferLen))
		RAISEERROR(E_INSUFMEMORY);

	LOCKHAND(tmpValue);
	pDest = HANDTOPTR(tmpValue);

	BEGIN_ARRAYGET()
		if (*pAddress)
		{
			nStringLen = lstrlen(*pAddress);
			if (nStringLen > nBufferLen)
			{
				UNLOCKHAND(tmpValue);
				if (!SETHANDSIZE(tmpValue,nStringLen))
				{
					FREEHAND(tmpValue);
					RAISEERROR(E_INSUFMEMORY);
				}
				else
				{
					LOCKHAND(tmpValue);
					pDest = HANDTOPTR(tmpValue);
					nBufferLen = nStringLen;
				}
			}
			if (nStringLen)
			{
				tmpValue.ev_length = nStringLen;
				memcpy(pDest,*pAddress,nStringLen);
			}
			else
				tmpValue.ev_length = 0;
		}
		else
			tmpValue.ev_length = 0;
	END_ARRAYGET(++)

	UNLOCKHAND(tmpValue);
	FREEHAND(tmpValue);
}

void _fastcall UnMarshalArrayWString(ParamBlk *parm)
{
	char* pDest;
	int nByteCount, nWCharCount, nCharsWritten, nBufferLen = 256;
	UINT nCodePage;
	STRING(tmpValue);
	ARRAYLOCALS(wchar_t**)
	
	nCodePage = PCOUNT() == 2 ? gnConvCP : (UINT)p4.ev_long;

	if (!ALLOCHAND(tmpValue,nBufferLen))
		RAISEERROR(E_INSUFMEMORY);

	LOCKHAND(tmpValue);
	pDest = HANDTOPTR(tmpValue);

	BEGIN_ARRAYGET()
		if (*pAddress)
		{
			nWCharCount = lstrlenW(*pAddress);
			nByteCount = nWCharCount * sizeof(wchar_t);
			if (nByteCount > nBufferLen)
			{
				UNLOCKHAND(tmpValue);
				if (!SETHANDSIZE(tmpValue,nByteCount))
				{
					FREEHAND(tmpValue);
					RAISEERROR(E_INSUFMEMORY); // "Insufficient memory"
				}
				else
				{
					LOCKHAND(tmpValue);
					pDest = (char*)HANDTOPTR(tmpValue);
					nBufferLen = nByteCount;
				}
			}
            if (nByteCount)
			{
				nCharsWritten = WideCharToMultiByte(nCodePage,0,*pAddress,nWCharCount,pDest,nBufferLen,0,0);
				if (nCharsWritten)
					tmpValue.ev_length = nCharsWritten;
				else
				{
					FREEHAND(tmpValue);
					RAISEWIN32ERROR(WideCharToMultiByte,GetLastError());
				}
			}
			else
				tmpValue.ev_length = 0;
		}
		else
			tmpValue.ev_length = 0;
	END_ARRAYGET(++)

	UNLOCKHAND(tmpValue);
	FREEHAND(tmpValue);
}

void _fastcall UnMarshalArrayCharArray(ParamBlk *parm)
{
	char* pDest;
	STRING(tmpValue);
	ARRAYLOCALS(char*)

	if (!ALLOCHAND(tmpValue,p3.ev_long))
		RAISEERROR(E_INSUFMEMORY);

	LOCKHAND(tmpValue);
	pDest = HANDTOPTR(tmpValue);

	BEGIN_ARRAYGET()
		tmpValue.ev_length = strncpyex(pDest,pAddress,p3.ev_long);
	END_ARRAYGET(+= p3.ev_long)

	UNLOCKHAND(tmpValue);
	FREEHAND(tmpValue);
}

void _fastcall UnMarshalArrayWCharArray(ParamBlk *parm)
{
	char* pDest;
	int nCharCount, nLength;
	UINT nCodePage;
	STRING(tmpValue);
	ARRAYLOCALS(wchar_t*)
	nLength = (unsigned int)p3.ev_long / sizeof(wchar_t);
	
	nCodePage = PCOUNT() == 3 ? gnConvCP : (UINT)p4.ev_long;

	if (!ALLOCHAND(tmpValue,p3.ev_long))
		RAISEERROR(E_INSUFMEMORY);

	LOCKHAND(tmpValue);
	pDest = HANDTOPTR(tmpValue);

	BEGIN_ARRAYGET()
		nCharCount = WideCharToMultiByte(nCodePage,0,pAddress,-1,pDest,p3.ev_long,0,0);
		if (nCharCount)
    		tmpValue.ev_length = nCharCount;
		else
		{
			FREEHAND(tmpValue);
			RAISEWIN32ERROR(WideCharToMultiByte,GetLastError());
		}
	END_ARRAYGET(+= nLength)

	UNLOCKHAND(tmpValue);
	FREEHAND(tmpValue);
}

void _fastcall MarshalArrayShort(ParamBlk *parm)
{
	VALUE(tmpValue);
	ARRAYLOCALS(short*)

	BEGIN_ARRAYSET()
		if (IS_NUMERIC(tmpValue))
			*pAddress = (short)tmpValue.ev_long;
		else if (IS_STRING(tmpValue))
			FREEHAND(tmpValue);
	END_ARRAYSET(++)
}

void _fastcall MarshalArrayUShort(ParamBlk *parm)
{
	VALUE(tmpValue);
	ARRAYLOCALS(unsigned short*)

	BEGIN_ARRAYSET()
		if (IS_NUMERIC(tmpValue))
			*pAddress = (unsigned short)tmpValue.ev_long;
		else if (IS_STRING(tmpValue))
			FREEHAND(tmpValue);
	END_ARRAYSET(++)
}
void _fastcall MarshalArrayInt(ParamBlk *parm)
{
	VALUE(tmpValue);
	ARRAYLOCALS(long*)

	BEGIN_ARRAYSET()
		if (IS_NUMERIC(tmpValue))
			*pAddress = tmpValue.ev_long;
		else if (IS_STRING(tmpValue))
			FREEHAND(tmpValue);
	END_ARRAYSET(++)
}
void _fastcall MarshalArrayUInt(ParamBlk *parm)
{
	VALUE(tmpValue);
	ARRAYLOCALS(unsigned long*)

	BEGIN_ARRAYSET()
		if (IS_NUMERIC(tmpValue))
			*pAddress = (unsigned long)tmpValue.ev_real;
		else if (IS_STRING(tmpValue))
			FREEHAND(tmpValue);
	END_ARRAYSET(++)
}

void _fastcall MarshalArrayFloat(ParamBlk *parm)
{
	VALUE(tmpValue);
	ARRAYLOCALS(float*)

	BEGIN_ARRAYSET()
		if (IS_NUMERIC(tmpValue))
			*pAddress = (float)tmpValue.ev_real;
		else if (IS_STRING(tmpValue))
			FREEHAND(tmpValue);
	END_ARRAYSET(++)
}

void _fastcall MarshalArrayDouble(ParamBlk *parm)
{
	VALUE(tmpValue);
	ARRAYLOCALS(double*)

	BEGIN_ARRAYSET()
		if (IS_NUMERIC(tmpValue))
			*pAddress = tmpValue.ev_real;
		else if (IS_STRING(tmpValue))
			FREEHAND(tmpValue);
	END_ARRAYSET(++)
}

void _fastcall MarshalArrayLogical(ParamBlk *parm)
{
	VALUE(tmpValue);
	ARRAYLOCALS(BOOL*)

	BEGIN_ARRAYSET()
		if (IS_LOGICAL(tmpValue))
			*pAddress = (BOOL)tmpValue.ev_length;
		else if (IS_STRING(tmpValue))
			FREEHAND(tmpValue);
	END_ARRAYSET(++)
}

void _fastcall MarshalArrayCString(ParamBlk *parm)
{
	VALUE(tmpValue);
	ARRAYLOCALS(char**)

	BEGIN_ARRAYSET()
		if (VALID_STRING(tmpValue))
		{
			if (*pAddress)
				*pAddress = HeapReAlloc(ghHeap,HEAP_FLAG,*pAddress,tmpValue.ev_length+sizeof(char));
			else
				*pAddress = HeapAlloc(ghHeap,HEAP_FLAG,tmpValue.ev_length+sizeof(char));

			if (*pAddress)
			{
				LOCKHAND(tmpValue);
				memcpy(*pAddress,HANDTOPTR(tmpValue),tmpValue.ev_length);
				UNLOCKHAND(tmpValue);
				(*pAddress)[tmpValue.ev_length] = '\0';
			}
			else
			{
				FREEHAND(tmpValue);
				RAISEERROR(E_INSUFMEMORY);
			}
		}
		else if (*pAddress)
		{
			HeapFree(ghHeap,HEAP_FLAG,*pAddress);
			*pAddress = 0;
		}
		if (IS_STRING(tmpValue))
			FREEHAND(tmpValue);
	END_ARRAYSET(++)
}

void _fastcall MarshalArrayWString(ParamBlk *parm)
{
	VALUE(tmpValue);
	int nCharsWritten;
	UINT nCodePage;
	ARRAYLOCALS(wchar_t**)

	nCodePage = PCOUNT() == 2 ? gnConvCP : (UINT)p3.ev_long;

	BEGIN_ARRAYSET()
		if (VALID_STRING(tmpValue))
		{
			if (*pAddress)
                *pAddress = HeapReAlloc(ghHeap,HEAP_FLAG,*pAddress,tmpValue.ev_length*sizeof(wchar_t)+sizeof(wchar_t));
			else
				*pAddress = HeapAlloc(ghHeap,HEAP_FLAG,tmpValue.ev_length*sizeof(wchar_t)+sizeof(wchar_t));

			if (*pAddress)
			{
				LOCKHAND(tmpValue);
				nCharsWritten = MultiByteToWideChar(nCodePage,0,HANDTOPTR(tmpValue),tmpValue.ev_length,*pAddress,tmpValue.ev_length);
				UNLOCKHAND(tmpValue);
				if (nCharsWritten)
				{
					(*pAddress)[nCharsWritten] = L'\0';
				}
				else
				{
					FREEHAND(tmpValue);
					RAISEWIN32ERROR(MultiByteToWideChar,GetLastError());
				}
			}
			else
			{
				FREEHAND(tmpValue);
				RAISEERROR(E_INSUFMEMORY);
			}
		}
		else if (*pAddress)
		{
			HeapFree(ghHeap,HEAP_FLAG,*pAddress);
			*pAddress = 0;
		}
		if (IS_STRING(tmpValue))
			FREEHAND(tmpValue);
	END_ARRAYSET(++)
}

void _fastcall MarshalArrayCharArray(ParamBlk *parm)
{
	VALUE(tmpValue);
	SIZE_T nLength, nCharCount;
	ARRAYLOCALS(char*)
	nLength = (unsigned int)p3.ev_long - 1;

	BEGIN_ARRAYSET()
		if (VALID_STRING(tmpValue))
		{
			nCharCount = min(tmpValue.ev_length,nLength);
			if (nCharCount)
			{
				LOCKHAND(tmpValue);
				memcpy(pAddress,HANDTOPTR(tmpValue),nCharCount);
				UNLOCKHAND(tmpValue);
			}
			pAddress[nCharCount] = '\0';
		}
		else
			*pAddress = '\0';
		if (IS_STRING(tmpValue))
			FREEHAND(tmpValue);
	END_ARRAYSET(+= nLength)
}

void _fastcall MarshalArrayWCharArray(ParamBlk *parm)
{
	VALUE(tmpValue);
	int nCharsWritten;
	UINT nCodePage;
	ARRAYLOCALS(wchar_t*)

	nCodePage = PCOUNT() == 3 ? gnConvCP : (UINT)p4.ev_long;
	
	BEGIN_ARRAYSET()
		if (VALID_STRING(tmpValue))
		{
			LOCKHAND(tmpValue);
			nCharsWritten = MultiByteToWideChar(nCodePage,0,HANDTOPTR(tmpValue),min((int)tmpValue.ev_length,p3.ev_long),pAddress,p3.ev_long);
			UNLOCKHAND(tmpValue);
			if (nCharsWritten)
			{
				pAddress[nCharsWritten] = L'\0';
			}
			else
			{
				FREEHAND(tmpValue);
				RAISEWIN32ERROR(MultiByteToWideChar,GetLastError());
			}
		}
		else
			*pAddress = L'\0';
		if (IS_STRING(tmpValue))
			FREEHAND(tmpValue);
	END_ARRAYSET(+= p3.ev_long)
}

void _fastcall UnMarshalCursorShort(ParamBlk *parm)
{
	SHORT(tmpValue);
	COLUMNGETLOCALS(short*)

	BEGIN_COLUMNGET()
		tmpValue.ev_long = (long)*pAddress;
	END_COLUMNGET(++)
}

void _fastcall UnMarshalCursorUShort(ParamBlk *parm)
{
	SHORT(tmpValue);
	COLUMNGETLOCALS(unsigned short*)

	BEGIN_COLUMNGET()
		tmpValue.ev_long = (long)*pAddress;
	END_COLUMNGET(++)
}

void _fastcall UnMarshalCursorInt(ParamBlk *parm)
{
	INTEGER(tmpValue);
	COLUMNGETLOCALS(long*)

	BEGIN_COLUMNGET()
		tmpValue.ev_long = *pAddress;
	END_COLUMNGET(++)
}

void _fastcall UnMarshalCursorUInt(ParamBlk *parm)
{
	UINTEGER(tmpValue);
	COLUMNGETLOCALS(unsigned long*)

	BEGIN_COLUMNGET()
		tmpValue.ev_real = (double)*pAddress;
	END_COLUMNGET(++)
}

void _fastcall UnMarshalCursorFloat(ParamBlk *parm)
{
	FLOAT(tmpValue);
	COLUMNGETLOCALS(float*)
	
	BEGIN_COLUMNGET()
		tmpValue.ev_real = (double)*pAddress;
	END_COLUMNGET(++)
}

void _fastcall UnMarshalCursorDouble(ParamBlk *parm)
{
	DOUBLE(tmpValue);
	COLUMNGETLOCALS(double*)

	BEGIN_COLUMNGET()
		tmpValue.ev_real = *pAddress;
	END_COLUMNGET(++)
}

void _fastcall UnMarshalCursorLogical(ParamBlk *parm)
{
	LOGICAL(tmpValue);
	COLUMNGETLOCALS(BOOL*)

	BEGIN_COLUMNGET()
		tmpValue.ev_length = *pAddress;
	END_COLUMNGET(++)
}

void _fastcall UnMarshalCursorCString(ParamBlk *parm)
{
	STRING(tmpValue);
	COLUMNGETLOCALS(char**)

	BEGIN_COLUMNGET()
		
	END_COLUMNGET(++)
}

void _fastcall UnMarshalCursorWString(ParamBlk *parm)
{
	STRING(tmpValue);
	COLUMNGETLOCALS(wchar_t**)

	BEGIN_COLUMNGET()
		
	END_COLUMNGET(++)
}

void _fastcall UnMarshalCursorCharArray(ParamBlk *parm)
{
	STRING(tmpValue);
	COLUMNGETLOCALS(char*)

	BEGIN_COLUMNGET()

	END_COLUMNGET(++)
}

void _fastcall UnMarshalCursorWCharArray(ParamBlk *parm)
{
	char *pDest;
	int nCharCount, nLength;
	UINT nCodePage;
	STRING(tmpValue);
	COLUMNGETLOCALS(wchar_t*)
	
	nLength = (UINT)p4.ev_long / sizeof(wchar_t);
	nCodePage = PCOUNT() == 4 ? gnConvCP : (UINT)p5.ev_long;

	if (!ALLOCHAND(tmpValue,p3.ev_long))
		RAISEERROR(E_INSUFMEMORY);

	LOCKHAND(tmpValue);
	pDest = HANDTOPTR(tmpValue);

	BEGIN_COLUMNGET()
		nCharCount = wstrnlen(pAddress,nLength);
		if (nCharCount)
		{
			nCharCount = WideCharToMultiByte(nCodePage,0,pAddress,-1,pDest,p3.ev_long,0,0);
			if (nCharCount)
    			tmpValue.ev_length = nCharCount;
			else
			{
				UNLOCKHAND(tmpValue);
				FREEHAND(tmpValue);
				RAISEWIN32ERROR(WideCharToMultiByte,GetLastError());
			}
		}
		else
			tmpValue.ev_length = 0;
	END_COLUMNGET(+= nLength)

	UNLOCKHAND(tmpValue);
	FREEHAND(tmpValue);
}

void _fastcall MarshalCursorShort(ParamBlk *parm)
{
	COLUMNSETLOCALS(short*)

	BEGIN_COLUMNSET()
		if (IS_NUMERIC(tmpValue))
			*pAddress = (short)tmpValue.ev_real;
	END_COLUMNSET(++)
}

void _fastcall MarshalCursorUShort(ParamBlk *parm)
{
	COLUMNSETLOCALS(unsigned short*)

	BEGIN_COLUMNSET()
		if (IS_NUMERIC(tmpValue))
			*pAddress = (unsigned short)tmpValue.ev_real;
	END_COLUMNSET(++)
}

void _fastcall MarshalCursorInt(ParamBlk *parm)
{
	COLUMNSETLOCALS(long*)

	BEGIN_COLUMNSET()
		if (IS_NUMERIC(tmpValue))
			*pAddress = (long)tmpValue.ev_real;
	END_COLUMNSET(++)
}

void _fastcall MarshalCursorUInt(ParamBlk *parm)
{
	COLUMNSETLOCALS(unsigned long*)
	BEGIN_COLUMNSET()
		if (IS_NUMERIC(tmpValue))
			*pAddress = (unsigned long)tmpValue.ev_real;
	END_COLUMNSET(++)
}

void _fastcall MarshalCursorFloat(ParamBlk *parm)
{
	COLUMNSETLOCALS(float*)
	BEGIN_COLUMNSET()
		if (IS_NUMERIC(tmpValue))
			*pAddress = (float)tmpValue.ev_real;
	END_COLUMNSET(++)
}

void _fastcall MarshalCursorDouble(ParamBlk *parm)
{
	COLUMNSETLOCALS(double*)
	BEGIN_COLUMNSET()
		if (IS_NUMERIC(tmpValue))
			*pAddress = tmpValue.ev_real;
	END_COLUMNSET(++)
}

void _fastcall MarshalCursorLogical(ParamBlk *parm)
{
	COLUMNSETLOCALS(BOOL*)
	BEGIN_COLUMNSET()
		if (IS_LOGICAL(tmpValue))
			*pAddress = (BOOL)tmpValue.ev_length;
		else if (IS_NUMERIC(tmpValue))
			*pAddress = (BOOL)tmpValue.ev_real;
		else if (IS_INTEGER(tmpValue))
			*pAddress = (BOOL)tmpValue.ev_long;
	END_COLUMNSET(++)
}

void _fastcall MarshalCursorCString(ParamBlk *parm)
{
	char *pNewAddress;
	COLUMNSETLOCALS(char**)
	BEGIN_COLUMNSET()
		if (VALID_STRING(tmpValue))
		{
			if (*pAddress)
			{
				pNewAddress = HeapReAlloc(ghHeap,HEAP_FLAG,*pAddress,tmpValue.ev_length+sizeof(char));
				if (pNewAddress)
				{
					REPLACEDEBUGALLOC(*pAddress,pNewAddress,tmpValue.ev_length);
					*pAddress = pNewAddress;
				}
				else
				{
					nErrorNo = E_INSUFMEMORY;
					goto ErrorOut;
				}
			}
			else
			{
				pNewAddress = HeapAlloc(ghHeap,HEAP_FLAG,tmpValue.ev_length+sizeof(char));
				if (pNewAddress)
				{
					ADDDEBUGALLOC(*pAddress,tmpValue.ev_length);
					*pAddress = pNewAddress;
				}
				else
				{
					nErrorNo = E_INSUFMEMORY;
					goto ErrorOut;
				}
			}

			memcpy(pNewAddress,HANDTOPTR(tmpValue),tmpValue.ev_length);
			pNewAddress[tmpValue.ev_length] = '\0';
		}
		else if (*pAddress)
		{
			HeapFree(ghHeap,HEAP_FLAG,*pAddress);
			*pAddress = 0;
		}
		if (IS_STRING(tmpValue))
			FREEHAND(tmpValue);
	END_COLUMNSET(++)
	RET_LOGICAL(TRUE);
	return;

	ErrorOut:
		if (IS_STRING(tmpValue))
			FREEHAND(tmpValue);
		RAISEERROR(nErrorNo);
}

void _fastcall MarshalCursorWString(ParamBlk *parm)
{
	int nCharsWritten;
	UINT nCodePage;
	COLUMNSETLOCALS(wchar_t**)

	nCodePage = PCOUNT() == 3 ? gnConvCP : (UINT)p4.ev_long;

	BEGIN_COLUMNSET()
		if (VALID_STRING(tmpValue))
		{
			if (*pAddress)
				*pAddress = HeapReAlloc(ghHeap,HEAP_FLAG,*pAddress,tmpValue.ev_length+sizeof(wchar_t)+sizeof(wchar_t));
			else
				*pAddress = HeapAlloc(ghHeap,HEAP_FLAG,tmpValue.ev_length*sizeof(wchar_t)+sizeof(wchar_t));

			if (*pAddress)
			{
				nCharsWritten = MultiByteToWideChar(nCodePage,0,HANDTOPTR(tmpValue),tmpValue.ev_length,*pAddress,tmpValue.ev_length);
				if (nCharsWritten)
				{
					(*pAddress)[tmpValue.ev_length] = L'\0';
				}
				else
				{
					FREEHAND(tmpValue);
					RAISEWIN32ERROR(MultiByteToWideChar,GetLastError());
				}
			}
			else
			{
				FREEHAND(tmpValue);
				RAISEERROR(E_INSUFMEMORY);
			}
		}
		else
		{
			if (IS_STRING(tmpValue))
				FREEHAND(tmpValue);
			HeapFree(ghHeap,HEAP_FLAG,*pAddress);
			*pAddress = 0;
		}
	END_COLUMNSET(++)
}

void _fastcall MarshalCursorCharArray(ParamBlk *parm)
{
	unsigned int nLength, nCharCount;
	COLUMNSETLOCALS(char*)
	nLength = (unsigned int)p4.ev_long - 1;
	BEGIN_COLUMNSET()
		if (VALID_STRING(tmpValue))
		{
			nCharCount = min(tmpValue.ev_length,nLength);
			if (nCharCount)
				memcpy(pAddress,HANDTOPTR(tmpValue),nCharCount);
			pAddress[nCharCount] = '\0';
		}
		else
			*pAddress = '\0';
		if (IS_STRING(tmpValue))
			FREEHAND(tmpValue);
	END_COLUMNSET(++)
}

void _fastcall MarshalCursorWCharArray(ParamBlk *parm)
{
	COLUMNSETLOCALS(wchar_t*)
	BEGIN_COLUMNSET()

	END_COLUMNSET(++)
}

void _fastcall Str2Short(ParamBlk *parm)
{
	short *pString;
	pString = HANDTOPTR(p1);
	RET_INTEGER(*pString);
}

void _fastcall Short2Str(ParamBlk *parm)
{
	STRINGN(vRetVal,sizeof(short));
	short *pRetVal;
	
	if (!ALLOCHAND(vRetVal,sizeof(short)))
		RAISEERROR(E_INSUFMEMORY);

	pRetVal = HANDTOPTR(vRetVal);
	*pRetVal = (short)p1.ev_long;

	RET_VALUE(vRetVal);
}

void _fastcall Str2UShort(ParamBlk *parm)
{
	unsigned short *pString;
	pString = HANDTOPTR(p1);
	RET_INTEGER(*pString);
}

void _fastcall UShort2Str(ParamBlk *parm)
{
	STRINGN(vRetVal,sizeof(unsigned short));
	unsigned short *pRetVal;
	
	if (!ALLOCHAND(vRetVal,sizeof(unsigned short)))
		RAISEERROR(E_INSUFMEMORY);

	pRetVal = HANDTOPTR(vRetVal);
	*pRetVal = (unsigned short)p1.ev_long;

	RET_VALUE(vRetVal);
}

void _fastcall Str2Long(ParamBlk *parm)
{
	long *pString;
	pString = HANDTOPTR(p1);
	RET_INTEGER(*pString);
}

void _fastcall Long2Str(ParamBlk *parm)
{
	STRINGN(vRetVal,sizeof(long));
	long *pRetVal;
	
	if (!ALLOCHAND(vRetVal,sizeof(long)))
		RAISEERROR(E_INSUFMEMORY);

	pRetVal = HANDTOPTR(vRetVal);
	*pRetVal = p1.ev_long;

	RET_VALUE(vRetVal);
}

void _fastcall Str2ULong(ParamBlk *parm)
{
	unsigned long *pString;
	pString = HANDTOPTR(p1);
	RET_UINTEGER(*pString);
}

void _fastcall ULong2Str(ParamBlk *parm)
{
	STRINGN(vRetVal,sizeof(unsigned long));
	unsigned long *pRetVal;
	
	if (!ALLOCHAND(vRetVal,sizeof(unsigned long)))
		RAISEERROR(E_INSUFMEMORY);

	pRetVal = HANDTOPTR(vRetVal);
	
	if (IS_INTEGER(p1))
		*pRetVal = p1.ev_long;
	else if (IS_NUMERIC(p1))
		*pRetVal = (unsigned long)p1.ev_real;
	else
	{
		FREEHAND(vRetVal);
		RAISEERROR(E_INVALIDPARAMS);
	}

	RET_VALUE(vRetVal);
}

void _fastcall Str2Double(ParamBlk *parm)
{
	double *pDouble;
	pDouble = HANDTOPTR(p1);
	RET_DOUBLE(*pDouble);
}

void _fastcall Double2Str(ParamBlk *parm)
{
	STRINGN(vRetVal,sizeof(double));
	double *pRetVal;
	
	if (!ALLOCHAND(vRetVal,sizeof(double)))
		RAISEERROR(E_INSUFMEMORY);

	pRetVal = HANDTOPTR(vRetVal);
	*pRetVal = p1.ev_real;

	RET_VALUE(vRetVal);	
}

void _fastcall Str2Float(ParamBlk *parm)
{
	float *pFloat;
	pFloat = HANDTOPTR(p1);
	RET_FLOAT(*pFloat);
}

void _fastcall Float2Str(ParamBlk *parm)
{
	STRINGN(vRetVal,sizeof(float));
	float *pRetVal;
	
	if (!ALLOCHAND(vRetVal,sizeof(float)))
		RAISEERROR(E_INSUFMEMORY);

	pRetVal = HANDTOPTR(vRetVal);
	*pRetVal = (float)p1.ev_real;

	RET_VALUE(vRetVal);	
}