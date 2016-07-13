#include <windows.h>
#include <stddef.h>

#include "pro_ext.h"
#include "vfp2c32.h"
#include "vfp2cutil.h"
#include "vfp2ccallback.h"
#include "vfp2cassembly.h"
#include "vfpmacros.h"

static HANDLE ghThunkHeap = 0;
static LPWINDOWSUBCLASS gpWMSubclasses = 0;
static LPCALLBACKFUNC gpCallbackFuncs = 0;

BOOL _stdcall VFP2C_Init_Callback()
{
	if (!(ghThunkHeap = HeapCreate(0,MAX_USHORT,0)))
	{
		ADDWIN32ERROR(HeapCreate,GetLastError());
		return FALSE;
	}
	return TRUE;
}

void _stdcall VFP2C_Destroy_Callback()
{
	ReleaseCallbackFuncs();
	ReleaseWindowSubclasses();

	if (ghThunkHeap)
		HeapDestroy(ghThunkHeap);
}

/* 	BINDEVENT(_VFP.hWnd, WM_USER_SHNOTIFY,this,"HandleMsg") */
void _fastcall BindEventsEx(ParamBlk *parm)
{
	HWND hHwnd = (HWND)p1.ev_long;
	UINT uMsg = (UINT)p2.ev_long;
	LPWINDOWSUBCLASS lpSubclass = 0;
	LPMSGCALLBACK lpMsg = 0;
	DWORD nFlags;
	BOOL bClassProc;
	char *pParmDef = 0;
	int nErrorNo = 0;
	char aObjectName[VFP2C_MAX_FUNCTIONBUFFER];

	RESETWIN32ERRORS();

	if (uMsg < WM_NULL)
		RAISEERROR(E_INVALIDPARAMS);

	if (p4.ev_length > VFP2C_MAX_CALLBACK_FUNCTION)
		RAISEERROR(E_INVALIDPARAMS);

	if (!IS_OBJECT(p3) && !IS_NULL(p3))
		RAISEERROR(E_INVALIDPARAMS);

	if (!NULLTERMINATE(p4))
		RAISEERROR(E_INSUFMEMORY);

	if (PCOUNT() >= 5)
	{
		if (!IS_STRING(p5) && !IS_NULL(p5))
			RAISEERROR(E_INVALIDPARAMS);
		else if (IS_STRING(p5) && !NULLTERMINATE(p5))
			RAISEERROR(E_INSUFMEMORY);
	}

	if (PCOUNT() >= 6 && p6.ev_long)
	{
		nFlags = p6.ev_long;
		if (!(nFlags & (BINDEVENTSEX_CALL_BEFORE | BINDEVENTSEX_CALL_AFTER | BINDEVENTSEX_RETURN_VALUE)))
			nFlags |= BINDEVENTSEX_CALL_BEFORE;
		// check nFlags for invalid combinations
		if (nFlags & BINDEVENTSEX_CALL_BEFORE && nFlags & (BINDEVENTSEX_CALL_AFTER | BINDEVENTSEX_RETURN_VALUE))
			RAISEERROR(E_INVALIDPARAMS);
		else if (nFlags & BINDEVENTSEX_CALL_AFTER && nFlags & (BINDEVENTSEX_CALL_BEFORE | BINDEVENTSEX_RETURN_VALUE))
			RAISEERROR(E_INVALIDPARAMS);
		else if (nFlags & BINDEVENTSEX_RETURN_VALUE && nFlags & (BINDEVENTSEX_CALL_AFTER | BINDEVENTSEX_CALL_BEFORE))
			RAISEERROR(E_INVALIDPARAMS);
	}
	else
		nFlags = BINDEVENTSEX_CALL_BEFORE;

	bClassProc = nFlags & BINDEVENTSEX_CLASSPROC ? TRUE : FALSE;

	// creates either a new struct or returns an existing struct for the passed hWnd
	lpSubclass = NewWindowSubclass(hHwnd,bClassProc);
	if (!lpSubclass)
	{
		nErrorNo = E_INSUFMEMORY;
		goto ErrorOut;
	}

	// subclass window
	if ((nErrorNo = SubclassWindow(lpSubclass)))
		goto ErrorOut;

	// get existing struct for uMsg or create a new one
	lpMsg = AddMsgCallback(lpSubclass,uMsg);
	if (!lpMsg)
	{
		nErrorNo = E_INSUFMEMORY;
		goto ErrorOut;
	}

	if (PCOUNT() >= 5 && IS_STRING(p5))
		pParmDef = HANDTOPTR(p5);

	if ((nErrorNo = CreateSubclassMsgThunkProc(lpSubclass,lpMsg,HANDTOPTR(p4),pParmDef,nFlags,IS_OBJECT(p3))))
		goto ErrorOut;

	// if callback on object, store object reference to public variable
	if (IS_OBJECT(p3))
	{
		sprintfex(aObjectName,BINDEVENTSEX_OBJECT_SCHEME,bClassProc,hHwnd,uMsg);

		if (nErrorNo = StoreObjectRef(aObjectName,&lpMsg->nObject,&p3))
			goto ErrorOut;
	}

	RET_POINTER(lpSubclass->pDefaultWndProc);
	return;

	ErrorOut:
		if (lpMsg)
			RemoveMsgCallback(lpSubclass,uMsg);
		if (lpSubclass && !lpSubclass->pBoundMessages)
		{
			UnsubclassWindow(lpSubclass);
			RemoveWindowSubclass(lpSubclass);
		}
		if (nErrorNo == -1)
			nErrorNo = 0;
		RAISEERROREX(nErrorNo);
}

void _fastcall UnBindEventsEx(ParamBlk *parm)
{
	HWND hHwnd = (HWND)p1.ev_long;
	UINT uMsg = (UINT)p2.ev_long;
	LPWINDOWSUBCLASS lpSubclass;
	LPMSGCALLBACK lpMsg = 0;
	BOOL bClassProc = PCOUNT() == 3 && p3.ev_length ? TRUE : FALSE;
	int nErrorNo = 0;

	RESETWIN32ERRORS();

	if (uMsg < WM_NULL)
		RAISEERROR(E_INVALIDPARAMS);

	// get reference to struct for the hWnd, if none is found - the window was not subclassed
	lpSubclass = FindWindowSubclass(hHwnd,bClassProc);
	if (!lpSubclass)
	{
		SAVECUSTOMERROREX("UnBindEventsEx","There are no message bindings for window %I",hHwnd);
		goto ErrorOut;
	}

	// remove a message hook
	if (PCOUNT() >= 2 && uMsg)
	{
		if (!RemoveMsgCallback(lpSubclass,uMsg))
		{
			SAVECUSTOMERROREX("UnBindEventsEx","There is no message binding for message no. %I",uMsg);
			goto ErrorOut;
		}
		// if no more hooks are present, unsubclass window
		if (!lpSubclass->pBoundMessages)
		{
			if (!UnsubclassWindow(lpSubclass))
				goto ErrorOut;
			RemoveWindowSubclass(lpSubclass);
		}
	}
	else // unsubclass window and free all hooks
	{
		if (!UnsubclassWindow(lpSubclass))
			goto ErrorOut;
		RemoveWindowSubclass(lpSubclass);
	}

	RET_INTEGER(1);
	return;

	ErrorOut:
		RAISEERROREX(nErrorNo);
}

LPWINDOWSUBCLASS _stdcall NewWindowSubclass(HWND hHwnd, BOOL bClassProc)
{
	LPWINDOWSUBCLASS lpSubclass = FindWindowSubclass(hHwnd,bClassProc);

	if (lpSubclass)
		return lpSubclass;

	lpSubclass = (LPWINDOWSUBCLASS)malloc(sizeof(WINDOWSUBCLASS));
	if (lpSubclass)
	{
		ZeroMemory(lpSubclass,sizeof(WINDOWSUBCLASS));
		lpSubclass->hHwnd = hHwnd;
		lpSubclass->bClassProc = bClassProc;
		lpSubclass->next = gpWMSubclasses;
		gpWMSubclasses = lpSubclass;
	}

	return lpSubclass;
}

void _stdcall FreeWindowSubclass(LPWINDOWSUBCLASS lpSubclass)
{
	LPMSGCALLBACK lpMsg = lpSubclass->pBoundMessages, lpNext;

	while (lpMsg)
	{
		lpNext = lpMsg->next;
		FreeMsgCallback(lpSubclass,lpMsg);
		lpMsg = lpNext;
	}

	if (lpSubclass->pWindowThunk)
		FreeThunk(lpSubclass->pWindowThunk);
	free(lpSubclass);
}

void _stdcall RemoveWindowSubclass(LPWINDOWSUBCLASS lpSubclass)
{
	LPWINDOWSUBCLASS lpClass = gpWMSubclasses, lpNext;
	LPWINDOWSUBCLASS *lpPrev = &gpWMSubclasses;

	while (lpClass)
	{
		lpNext = lpClass->next;
		if (lpClass == lpSubclass)
		{
			FreeWindowSubclass(lpClass);
			*lpPrev = lpNext;
			return;
		}
		else
		{
			lpPrev = &lpClass->next;
			lpClass = lpNext;
		}
	}
}

LPWINDOWSUBCLASS _stdcall FindWindowSubclass(HWND hHwnd, BOOL bClassProc)
{
	LPWINDOWSUBCLASS lpSubclass = gpWMSubclasses;

	while (lpSubclass)
	{
		if (lpSubclass->hHwnd == hHwnd && lpSubclass->bClassProc == bClassProc)
			break;
		lpSubclass = lpSubclass->next;
	}
	return lpSubclass;
}

LPMSGCALLBACK NewMsgCallback(UINT uMsg)
{
	LPMSGCALLBACK lpMsg;

	lpMsg = (LPMSGCALLBACK)malloc(sizeof(MSGCALLBACK));
	if (!lpMsg)
		return 0;

	lpMsg->uMsg = uMsg;
	lpMsg->nObject = 0;
	lpMsg->next = 0;
	lpMsg->pCallbackThunk = 0;

	lpMsg->pCallbackFunction = (char*)malloc(VFP2C_MAX_CALLBACKBUFFER);
	if (!lpMsg->pCallbackFunction)
	{
		free(lpMsg);
		return 0;
	}
	
	return lpMsg;
}

void _stdcall FreeMsgCallback(LPWINDOWSUBCLASS pSubclass, LPMSGCALLBACK lpMsg)
{
	char aObjectName[VFP2C_MAX_FUNCTIONBUFFER];

	if (lpMsg->pCallbackThunk)
		FreeThunk(lpMsg->pCallbackThunk);
	if (lpMsg->pCallbackFunction)
		free(lpMsg->pCallbackFunction);

	sprintfex(aObjectName,BINDEVENTSEX_OBJECT_SCHEME,pSubclass->bClassProc,pSubclass->hHwnd,lpMsg->uMsg);
	ReleaseObjectRef(aObjectName,lpMsg->nObject);
	free(lpMsg);
}

LPMSGCALLBACK AddMsgCallback(LPWINDOWSUBCLASS pSubclass, UINT uMsg)
{
	LPMSGCALLBACK lpMsg = pSubclass->pBoundMessages, lpNewMsg;

	if (!lpMsg)
	{
		lpNewMsg = NewMsgCallback(uMsg);
		if (!lpNewMsg)
			return 0;
		pSubclass->pBoundMessages = lpNewMsg;
		return lpNewMsg;
	}

	while (1)
	{
		if (lpMsg->uMsg == uMsg)
			return lpMsg;
		else if (lpMsg->next)
			lpMsg = lpMsg->next;
		else
		{
			lpNewMsg = NewMsgCallback(uMsg);
			if (!lpNewMsg)
				return 0;
			lpMsg->next = lpNewMsg;
			return lpNewMsg;
		}
	}
	return 0;
}

BOOL _stdcall RemoveMsgCallback(LPWINDOWSUBCLASS pSubclass, UINT uMsg)
{
	LPMSGCALLBACK lpMsg = pSubclass->pBoundMessages, lpNext;
	LPMSGCALLBACK *lpPrev = &pSubclass->pBoundMessages;

	while (lpMsg)
	{
		lpNext = lpMsg->next;
		if (lpMsg->uMsg == uMsg)
		{
			FreeMsgCallback(pSubclass,lpMsg);
			*lpPrev = lpNext;
			return TRUE;
		}
		else
		{
			lpPrev = &lpMsg->next;
			lpMsg = lpNext;
		}
	}
	return FALSE;
}

void* _stdcall FindMsgCallbackThunk(LPWINDOWSUBCLASS pSubclass, UINT uMsg)
{
	LPMSGCALLBACK lpMsg = pSubclass->pBoundMessages;
	while (lpMsg)
	{
		if (lpMsg->uMsg == uMsg)
			return lpMsg->pCallbackThunk;
		lpMsg = lpMsg->next;
	}
	return 0;
}

int _stdcall SubclassWindow(LPWINDOWSUBCLASS lpSubclass)
{
	int nErrorNo;

	// window/class already subclassed?
	if (lpSubclass->pDefaultWndProc)
		return 0;

	if (!lpSubclass->bClassProc)
	{
		lpSubclass->pDefaultWndProc = (WNDPROC)GetWindowLong(lpSubclass->hHwnd,GWL_WNDPROC);
		if (!lpSubclass->pDefaultWndProc)
		{
			SAVEWIN32ERROR(GetWindowLong,GetLastError());
			return -1;
		}
		
		if ((nErrorNo = CreateSubclassThunkProc(lpSubclass)))
			return nErrorNo;

		if (!SetWindowLong(lpSubclass->hHwnd,GWL_WNDPROC,(LONG)lpSubclass->pWindowThunk))
		{
			SAVEWIN32ERROR(SetWindowLong,GetLastError());
			return -1;
		}
	}
	else
	{
		lpSubclass->pDefaultWndProc = (WNDPROC)GetClassLong(lpSubclass->hHwnd,GCL_WNDPROC);
		if (!lpSubclass->pDefaultWndProc)
		{
			SAVEWIN32ERROR(GetClassLong,GetLastError());
			return -1;
		}
		
		if ((nErrorNo = CreateSubclassThunkProc(lpSubclass)))
			return nErrorNo;

		if (!SetClassLong(lpSubclass->hHwnd,GCL_WNDPROC,(LONG)lpSubclass->pWindowThunk))
		{
			SAVEWIN32ERROR(SetClassLong,GetLastError());
			return -1;
		}
	}
	return 0;
}

BOOL _stdcall UnsubclassWindow(LPWINDOWSUBCLASS lpSubclass)
{
	if (!lpSubclass->bClassProc)
	{
		if (!SetWindowLong(lpSubclass->hHwnd,GWL_WNDPROC,(LONG)lpSubclass->pDefaultWndProc))
		{
			SAVEWIN32ERROR(SetWindowLong,GetLastError());
			return FALSE;
		}
	}
	else
	{
		if (!SetClassLong(lpSubclass->hHwnd,GCL_WNDPROC,(LONG)lpSubclass->pDefaultWndProc))
		{
			SAVEWIN32ERROR(SetClassLong,GetLastError());
			return FALSE;
		}
		if (!UnsubclassWindowEx(lpSubclass))
			return FALSE;
	}
	return TRUE;
}

BOOL _stdcall UnsubclassWindowEx(LPWINDOWSUBCLASS lpSubclass)
{
	return EnumThreadWindows(GetCurrentThreadId(),UnsubclassWindowExCallback,(LPARAM)lpSubclass);
}

BOOL _stdcall UnsubclassWindowExCallback(HWND hHwnd, LPARAM lParam)
{
	LPWINDOWSUBCLASS lpSubclass = (LPWINDOWSUBCLASS)lParam;
	void* nProc;
	
	nProc = (void*)GetWindowLong(hHwnd,GWL_WNDPROC);
	if (nProc == lpSubclass->pWindowThunk)
	{
		if (!SetWindowLong(hHwnd,GWL_WNDPROC,(LONG)lpSubclass->pDefaultWndProc))
		{
			SAVEWIN32ERROR(SetWindowLong,GetLastError());
			return FALSE;
		}
	}

	if (!EnumChildWindows(hHwnd,UnsubclassWindowExCallbackChild,(LPARAM)lpSubclass))
	{
		if (GetLastError() != NO_ERROR)
		{
			SAVEWIN32ERROR(EnumChildWindows,GetLastError());
			return FALSE;
		}
	}
	return TRUE;
}

BOOL _stdcall UnsubclassWindowExCallbackChild(HWND hHwnd, LPARAM lParam)
{
	LPWINDOWSUBCLASS lpSubclass = (LPWINDOWSUBCLASS)lParam;
	void* nProc;
	
	nProc = (void*)GetWindowLong(hHwnd,GWL_WNDPROC);
	if (nProc == lpSubclass->pWindowThunk)
	{
		if (!SetWindowLong(hHwnd,GWL_WNDPROC,(LONG)lpSubclass->pDefaultWndProc))
		{
			SAVEWIN32ERROR(SetWindowLong,GetLastError());
			return FALSE;
		}
	}
	return TRUE;
}

int _stdcall CreateSubclassThunkProc(LPWINDOWSUBCLASS lpSubclass)
{
	int nErrorNo = 0;

	Emit_Init();

	Emit_Parameter("hWnd",T_INT);
	Emit_Parameter("uMsg",T_UINT);
    Emit_Parameter("wParam",T_UINT);
    Emit_Parameter("lParam",T_INT);

	Emit_LocalVar("vRetVal",sizeof(Value),__alignof(Value));
	Emit_LocalVar("vAutoYield",sizeof(Value),__alignof(Value));

	// Function Prolog
	Emit_Prolog();
	// save common registers
	Push(EBX);
	Push(ECX);
	Push(EDX);

	Push("uMsg");
	Push((AVALUE)lpSubclass);
	Call((FUNCPTR)FindMsgCallbackThunk);

	Cmp(EAX,0); // msg was subclassed?
	Je("CallWindowProc");
	
	Jmp(EAX); // jump to thunk
	
	Emit_Label("CallWindowProc");
	//  return CallWindowProc(lpSubclass->pDefaultWndProc,hHwnd,uMsg,wParam,lParam);
	Push("lParam");
	Push("wParam");
	Push("uMsg");
	Push("hWnd");
	Push((AVALUE)lpSubclass->pDefaultWndProc);
	Call((FUNCPTR)CallWindowProc);

	Emit_Label("End");

	// restore registers
	Pop(EDX);
	Pop(ECX);
	Pop(EBX);
	// Function Epilog
	Emit_Epilog();
	
	// backpatch jump instructions
	Emit_Patch();
	
	if ((nErrorNo = AllocThunk(Emit_CodeSize(),&lpSubclass->pWindowThunk)))
		return nErrorNo;

	Emit_Write(lpSubclass->pWindowThunk);

	lpSubclass->pHookWndRetCall = Emit_LabelAddress("CallWindowProc");
	lpSubclass->pHookWndRetEax = Emit_LabelAddress("End");

	return 0;
}

int _stdcall CreateSubclassMsgThunkProc(LPWINDOWSUBCLASS lpSubclass, LPMSGCALLBACK lpMsg, char *pCallback, char *pParmDef, DWORD nFlags, BOOL bObjectCall)
{
	int nParmCount = 6, xj, nErrorNo;
	char aParmValue[VFP2C_MAX_TYPE_LEN];
	char aConvertFlags[VFP2C_MAX_TYPE_LEN] = {0};
	char *pConvertFlags = aConvertFlags;
	char *pCallbackTmp;
	REGISTER nReg = EAX;

	Emit_Init();

	Emit_Parameter("hWnd",T_INT);
	Emit_Parameter("uMsg",T_UINT);
    Emit_Parameter("wParam",T_UINT);
	Emit_Parameter("lParam",T_UINT);

	Emit_LocalVar("vRetVal",sizeof(Value),__alignof(Value));
	Emit_LocalVar("vAutoYield",sizeof(Value),__alignof(Value));

	if (bObjectCall)
		sprintfex(lpMsg->pCallbackFunction,BINDEVENTSEX_OBJECT_SCHEME".",lpSubclass->bClassProc,lpSubclass->hHwnd,lpMsg->uMsg);
	else
		*lpMsg->pCallbackFunction = '\0';

	strcat(lpMsg->pCallbackFunction,pCallback);

	if (nFlags & BINDEVENTSEX_CALL_AFTER)
	{
		Push("lParam");
		Push("wParam");
		Push("uMsg");
		Push("hWnd");
		Push((AVALUE)lpSubclass->pDefaultWndProc);
		Call((FUNCPTR)CallWindowProc);	
	}

	if (nFlags & BINDEVENTSEX_NO_RECURSION)
	{
		// _Evaluate(&vAutoYield,"_VFP.AutoYield");
		Lea(ECX,"vAutoYield",0);
		Mov(EDX,(AVALUE)"_VFP.AutoYield");
		Call((FUNCPTR)_Evaluate);

		// if (vAutoYield.ev_length)
		//  _Execute("_VFP.AutoYield = .F.")
		Mov(EAX,"vAutoYield",T_UINT,offsetof(Value,ev_length));
		Cmp(EAX,0);
		Je("AutoYieldFalse");
		Mov(ECX,(AVALUE)"_VFP.AutoYield = .F.");
		Call((FUNCPTR)_Execute);
		Emit_Label("AutoYieldFalse");
	}

	if (!pParmDef)
	{
		strcat(lpMsg->pCallbackFunction,"(%U,%U,%I,%I)");
		Push("lParam");
		Push("wParam");
		Push("uMsg");
		Push("hWnd");
	}
	else
	{
		nParmCount = GetWordCount(pParmDef,',');
		
		if (nParmCount > VFP2C_MAX_TYPE_LEN)
			return E_INVALIDPARAMS;

		for (xj = nParmCount; xj; xj--)
		{
			GetWordNumN(aParmValue,pParmDef,',',xj,VFP2C_MAX_TYPE_LEN);
           	Alltrim(aParmValue);

			if (STRIEQUAL("wParam",aParmValue))
			{
				*pConvertFlags++ = 'I';
				Push("wParam");
			}
			else if (STRIEQUAL("lParam",aParmValue))
			{
				*pConvertFlags++ = 'I';
				Push("lParam");
			}
			else if (STRIEQUAL("uMsg",aParmValue))
			{
				*pConvertFlags++ = 'U';
				Push("uMsg");
			}
			else if (STRIEQUAL("hWnd",aParmValue))
			{
				*pConvertFlags++ = 'U';
				Push("hWnd");
			}
			else if (STRIEQUAL("UNSIGNED(wParam)",aParmValue))
			{
				*pConvertFlags++ = 'U';
				Push("wParam");
			}
			else if (STRIEQUAL("UNSIGNED(lParam)",aParmValue))
			{
				*pConvertFlags++ = 'U';
				Push("lParam");
			}
			else if (STRIEQUAL("HIWORD(wParam)",aParmValue))
			{
				*pConvertFlags++ = 'i';
				Mov(nReg,"wParam");
				Shr(nReg,16);
				Push(nReg);
			}
			else if (STRIEQUAL("LOWORD(wParam)",aParmValue))
			{
				*pConvertFlags++ = 'i';
				Mov(nReg,"wParam");
				And(nReg,MAX_USHORT);
				Push(nReg);
			}
			else if (STRIEQUAL("HIWORD(lParam)",aParmValue))
			{
				*pConvertFlags++ = 'i';
				Mov(nReg,"lParam");
				Shr(nReg,16);
				Push(nReg);
			}
			else if (STRIEQUAL("LOWORD(lParam)",aParmValue))
			{
				*pConvertFlags++ = 'i';
				Mov(nReg,"lParam");
				And(nReg,MAX_USHORT);
				Push(nReg);
			}
			else if (STRIEQUAL("UNSIGNED(HIWORD(wParam))",aParmValue))
			{
				*pConvertFlags++ = 'u';
				Mov(nReg,"wParam");
				Shr(nReg,16);
				Push(nReg);
			}
			else if (STRIEQUAL("UNSIGNED(LOWORD(wParam))",aParmValue))
			{
				*pConvertFlags++ = 'u';
				Mov(nReg,"wParam");
				And(nReg,MAX_USHORT);
				Push(nReg);
			}
			else if (STRIEQUAL("UNSIGNED(HIWORD(lParam))",aParmValue))
			{
				*pConvertFlags++ = 'u';
				Mov(nReg,"lParam");
				Shr(nReg,16);
				Push(nReg);
			}
			else if (STRIEQUAL("UNSIGNED(LOWORD(lParam))",aParmValue))
			{
				*pConvertFlags++ = 'u';
				Mov(nReg,"lParam");
				And(nReg,MAX_USHORT);
				Push(nReg);
			}
			else if (STRIEQUAL("BOOL(wParam)",aParmValue))
			{
				*pConvertFlags++ = 'L';
				Push("wParam");
			}
			else if (STRIEQUAL("BOOL(lParam)",aParmValue))
			{
				*pConvertFlags++ = 'L';
				Push("lParam");
			}
			else
				return E_INVALIDPARAMS;

			if (nReg == EAX)
				nReg = EBX;
			else if (nReg == EBX)
				nReg = ECX;
			else if (nReg == ECX)
				nReg = EDX;
			else
				nReg = EAX;
		}

		// build format string
		pCallbackTmp = strend(lpMsg->pCallbackFunction);
		*pCallbackTmp++ = '(';
		for (xj = nParmCount; xj; xj--)
		{
			*pCallbackTmp++ = '%';
			*pCallbackTmp++ = aConvertFlags[xj-1];
			if (xj > 1)
				*pCallbackTmp++ = ',';
		}
		*pCallbackTmp++ = ')';
		*pCallbackTmp = '\0';

		// two parameters are always passed to sprintfex ..
		nParmCount += 2;
	}

	// if any parameters should be passed we need to call sprintfex
	if (nParmCount > 2)
	{
		Push((AVALUE)lpMsg->pCallbackFunction);
		Push((AVALUE)lpSubclass->aCallbackBuffer);
		Call((FUNCPTR)sprintfex);
		Add(ESP,nParmCount*sizeof(int));	// add esp, no of parameters * sizeof stack increment
	}

	if (nFlags & BINDEVENTSEX_CALL_BEFORE)
	{
		if (nParmCount > 2)
			Mov(ECX,(AVALUE)lpSubclass->aCallbackBuffer);
		else
			Mov(ECX,(AVALUE)lpMsg->pCallbackFunction);

		Call((FUNCPTR)_Execute);
		
		if (nFlags & BINDEVENTSEX_NO_RECURSION)
		{
			Mov(EAX,"vAutoYield",T_UINT,offsetof(Value,ev_length));
			Cmp(EAX,0);
			Je("AutoYieldBack");
			// set autoyield to .T. again 
			Mov(ECX,(AVALUE)"_VFP.AutoYield = .T.");
			Call((FUNCPTR)_Execute);
			Emit_Label("AutoYieldBack");
		}
		Jmp(EBX,(AVALUE)lpSubclass->pHookWndRetCall); // jump back
	}
	else if (nFlags & (BINDEVENTSEX_CALL_AFTER | BINDEVENTSEX_RETURN_VALUE))
	{
		Lea(ECX,"vRetVal");
		if (nParmCount > 2)
			Mov(EDX,(AVALUE)lpSubclass->aCallbackBuffer);
		else
			Mov(EDX,(AVALUE)lpMsg->pCallbackFunction);

		Call((FUNCPTR)_Evaluate);

		if (nFlags & BINDEVENTSEX_NO_RECURSION)
		{
			Mov(EAX,"vAutoYield",T_UINT,offsetof(Value,ev_length));
			// if autoyield was .F. before we don't need to set it
			Cmp(EAX,0);
			Je("AutoYieldBack");
			// set autoyield to .T. again 
			Mov(ECX,(AVALUE)"_VFP.AutoYield = .T.");
			Call((FUNCPTR)_Execute);
			Emit_Label("AutoYieldBack");
		}
		Mov(EAX,"vRetVal",T_INT,offsetof(Value,ev_long));
		Jmp(EBX,(AVALUE)lpSubclass->pHookWndRetEax); // jump back
	}

	if (lpMsg->pCallbackThunk)
	{
		FreeThunk(lpMsg->pCallbackThunk);
		lpMsg->pCallbackThunk = 0;
	}

	Emit_Patch();

	if (nErrorNo = AllocThunk(Emit_CodeSize(),&lpMsg->pCallbackThunk))
		return nErrorNo;

	Emit_Write(lpMsg->pCallbackThunk);

	return 0;
}

void _stdcall ReleaseWindowSubclasses()
{
	LPWINDOWSUBCLASS lpSubclass = gpWMSubclasses, lpNext;

	while (lpSubclass)
	{
		lpNext = lpSubclass->next;
		UnsubclassWindow(lpSubclass);
		FreeWindowSubclass(lpSubclass);
		lpSubclass = lpNext;
	}
}

LPCALLBACKFUNC NewCallbackFunc()
{
	LPCALLBACKFUNC pFunc = (LPCALLBACKFUNC)malloc(sizeof(CALLBACKFUNC));
	if (pFunc)
	{
		ZeroMemory(pFunc,sizeof(CALLBACKFUNC));
		pFunc->next = gpCallbackFuncs;
		gpCallbackFuncs = pFunc;
	}
	return pFunc;
}

BOOL DeleteCallbackFunc(void *pFuncAddress)
{
	LPCALLBACKFUNC pFunc = gpCallbackFuncs, pFuncPrev = 0;
    char aObjectName[VFP2C_MAX_FUNCTIONBUFFER];

	while (pFunc && pFunc->pFuncAddress != pFuncAddress)
	{
		pFuncPrev = pFunc;
		pFunc = pFunc->next;
	}

	if (pFunc)
	{
		if (pFuncPrev)
			pFuncPrev->next = pFunc->next;
		else
			gpCallbackFuncs = pFunc->next;

		sprintfex(aObjectName,CALLBACKFUNC_OBJECT_SCHEME,pFunc);
		ReleaseObjectRef(aObjectName,pFunc->nObject);
		
		FreeThunk(pFuncAddress);
		free(pFunc);
		return TRUE;
	}
	return FALSE;
}

void _stdcall ReleaseCallbackFuncs()
{
	LPCALLBACKFUNC pFunc = gpCallbackFuncs, pFuncNext;
    char aObjectName[VFP2C_MAX_FUNCTIONBUFFER];
  
	while (pFunc)
	{
		pFuncNext = pFunc->next;
		sprintfex(aObjectName,CALLBACKFUNC_OBJECT_SCHEME,pFunc);
		ReleaseObjectRef(aObjectName,pFunc->nObject);
		FreeThunk(pFunc->pFuncAddress);
		free(pFunc);
		pFunc = pFuncNext;
	}
}

void _fastcall CreateCallbackFunc(ParamBlk *parm)
{
	char *pCallback, *pRetVal, *pParams;
	int nParmCount, nParmLen, nPrecision, xj, nErrorNo = 0;
	LPCALLBACKFUNC pFunc = 0;
	char aParmFormat[128] = {0};
	char aParmType[VFP2C_MAX_TYPE_LEN];
	char aParmPrec[VFP2C_MAX_TYPE_LEN];
	char aObjectName[VFP2C_MAX_FUNCTIONBUFFER];

	if (!NULLTERMINATE(p1) || !NULLTERMINATE(p2) || !NULLTERMINATE(p3))
		RAISEERROR(E_INSUFMEMORY);

	if (p1.ev_length > VFP2C_MAX_CALLBACK_FUNCTION)
		RAISEERROR(E_INVALIDPARAMS);

	LOCKHAND(p1);
	LOCKHAND(p2);
	LOCKHAND(p3);

	pCallback = HANDTOPTR(p1);
	pRetVal = HANDTOPTR(p2);
	pParams = HANDTOPTR(p3);

	pFunc = NewCallbackFunc();
	if (!pFunc)
	{
		nErrorNo = E_INSUFMEMORY;
		goto ErrorOut;
	}

	if (PCOUNT() >= 4 && IS_OBJECT(p4))
	{
		sprintfex(aObjectName,CALLBACKFUNC_OBJECT_SCHEME,pFunc);

		if (nErrorNo = StoreObjectRef(aObjectName,&pFunc->nObject,&p4))
			goto ErrorOut;

		strcpy(pFunc->aCallbackBuffer,aObjectName);
		strcat(pFunc->aCallbackBuffer,".");
	}
 
	nParmCount = GetWordCount(pParams,',');
	if (nParmCount > VFP2C_MAX_CALLBACK_PARAMETERS)
	{
		nErrorNo = E_INVALIDPARAMS;
		goto ErrorOut;
	}

	Emit_Init();
	
	// return value needed?
	if (!(STRIEQUAL(pRetVal,"VOID") || STRIEQUAL(pRetVal,"")))
		Emit_LocalVar("vRetVal",sizeof(Value),__alignof(Value));

	Emit_Prolog();
	Push(EBX);
	Push(ECX);
	Push(EDX);

	if (nParmCount)
	{
		// fill static part of buffer
		strcat(pFunc->aCallbackBuffer,pCallback);
		strcat(pFunc->aCallbackBuffer,"(");
		Mov(EAX,(AVALUE)(pFunc->aCallbackBuffer+strlen(pFunc->aCallbackBuffer)));
	}
	else
	{
		strcat(pFunc->aCallbackBuffer,pCallback);
		strcat(pFunc->aCallbackBuffer,"()");
	}

	for (xj = 1; xj <= nParmCount; xj++)
	{
		GetWordNumN(aParmType,pParams,',',xj,VFP2C_MAX_TYPE_LEN);
		Alltrim(aParmType);

		nParmLen = GetWordCount(aParmType,' ');
		if (nParmLen == 2)
		{
			GetWordNumN(aParmPrec,aParmType,' ',2,VFP2C_MAX_TYPE_LEN);
			GetWordNumN(aParmType,aParmType,' ',1,VFP2C_MAX_TYPE_LEN);
		}
		else if (nParmLen > 2)
		{
			nErrorNo = E_INVALIDPARAMS;
			goto ErrorOut;
		}

		if (xj > 1)
		{
			Mov(REAX,sizeof(char),',');
			Add(EAX,1);
		}

		if (STRIEQUAL(aParmType,"INTEGER") || STRIEQUAL(aParmType,"LONG"))
		{
			Emit_Parameter(T_INT);
			Push((PARAMNO)xj);
			Push(EAX);
			Call(EBX,(FUNCPTR)IntToStr);
		}
		else if (STRIEQUAL(aParmType,"UINTEGER") || STRIEQUAL(aParmType,"ULONG") || STRIEQUAL(aParmType,"STRING"))
		{
			Emit_Parameter(T_UINT);
			Push((PARAMNO)xj);
			Push(EAX);
			Call(EBX,(FUNCPTR)UIntToStr);
		}
		else if (STRIEQUAL(aParmType,"SHORT"))
		{
			Emit_Parameter(T_SHORT);
			Push((PARAMNO)xj);
			Push(EAX);
			Call(EBX,(FUNCPTR)IntToStr);
		}
		else if (STRIEQUAL(aParmType,"USHORT"))
		{
			Emit_Parameter(T_USHORT);
			Push((PARAMNO)xj);
			Push(EAX);
			Call(EBX,(FUNCPTR)UIntToStr);
		}
		else if (STRIEQUAL(aParmType,"BOOL"))
		{
			Emit_Parameter(T_INT);
			Push((PARAMNO)xj);
			Push(EAX);
			Call(EBX,(FUNCPTR)BoolToStr);
		}
		else if (STRIEQUAL(aParmType,"SINGLE"))
		{
			Emit_Parameter(T_FLOAT);

			if (nParmLen == 2)
			{
				nPrecision = atoi(aParmPrec);
				if (nPrecision < 0 || nPrecision > 6)
				{
					nErrorNo = E_INVALIDPARAMS;
					goto ErrorOut;
				}
			}
			else
				nPrecision = 6;

			Push((AVALUE)nPrecision);
			Push((PARAMNO)xj);
			Push(EAX);
			Call(EBX,(FUNCPTR)FloatToStr);
		}
		else if (STRIEQUAL(aParmType,"DOUBLE"))
		{
			Emit_Parameter(T_DOUBLE);

			if (nParmLen == 2)
			{
				nPrecision = atoi(aParmPrec);
				if (nPrecision < 0 || nPrecision > 16)
				{
					nErrorNo = E_INVALIDPARAMS;
					goto ErrorOut;
				}
			}
			else
				nPrecision = 6;

			Push((AVALUE)nPrecision);
			Push((PARAMNO)xj);			
			Push(EAX);
			Call(EBX,(FUNCPTR)DoubleToStr);
		}
		else
		{
			nErrorNo = E_INVALIDPARAMS;
			goto ErrorOut;
		}
	}

	if (nParmCount)
	{
		Mov(REAX,sizeof(char),')');
		Add(EAX,1);
		Mov(REAX,sizeof(char),'\0');
	}

	if (STRIEQUAL(pRetVal,"") || STRIEQUAL(pRetVal,"VOID"))
	{
		/* EXECUTE(pFunc->aCallbackBuffer); */
		Mov(ECX,(AVALUE)pFunc->aCallbackBuffer);
		Call((FUNCPTR)_Execute);
	}
	else
	{
		/* EVALUATE(vRetVal,pFunc->aCallbackBuffer) */
		Lea(ECX,"vRetVal");
		Mov(EDX,(AVALUE)pFunc->aCallbackBuffer);
		Call((FUNCPTR)_Evaluate);

		// return value
		if (STRIEQUAL(pRetVal,"INTEGER") || STRIEQUAL(pRetVal,"LONG"))
			Mov(EAX,"vRetVal",T_INT,offsetof(Value,ev_long));
		else if (STRIEQUAL(pRetVal,"UINTEGER") || STRIEQUAL(pRetVal,"ULONG"))
		{
			Mov(AL,"vRetVal",T_CHAR,offsetof(Value,ev_type));
			Cmp(AL,'N');
			Je("DConv");
			Mov(EAX,"vRetVal",T_UINT,offsetof(Value,ev_long));
			Jmp("End");
			Emit_Label("DConv");
			Push("vRetVal",T_DOUBLE,offsetof(Value,ev_real));
			Call((FUNCPTR)DoubleToUInt);
			Emit_Label("End");
		}
		else if (STRIEQUAL(pRetVal,"SHORT"))
			Mov(AX,"vRetVal",T_INT,offsetof(Value,ev_long));
		else if (STRIEQUAL(pRetVal,"USHORT"))
			Mov(AX,"vRetVal",T_UINT,offsetof(Value,ev_long));
		else if (STRIEQUAL(pRetVal,"SINGLE") || STRIEQUAL(pRetVal,"DOUBLE"))
			Fld("vRetVal",T_DOUBLE,offsetof(Value,ev_real));
		else if (STRIEQUAL(pRetVal,"BOOL"))
			Mov(EAX,"vRetVal",T_UINT,offsetof(Value,ev_length));
	}

	Pop(EDX);
	Pop(ECX);
	Pop(EBX);
	Emit_Epilog();

	Emit_Patch();

	if ((nErrorNo = AllocThunk(Emit_CodeSize(),&pFunc->pFuncAddress)))
		goto ErrorOut;

	Emit_Write(pFunc->pFuncAddress);

	UNLOCKHAND(p1);
	UNLOCKHAND(p2);
	UNLOCKHAND(p3);
	RET_POINTER(pFunc->pFuncAddress);
	return;

	ErrorOut:
		if (pFunc)
			DeleteCallbackFunc(pFunc);
		UNLOCKHAND(p1);
		UNLOCKHAND(p2);
		UNLOCKHAND(p3);
		if (nErrorNo == -1)
			nErrorNo = 0;
		RAISEERROREX(nErrorNo);
}

void _fastcall DestroyCallbackFunc(ParamBlk *parm)
{
	RET_LOGICAL(DeleteCallbackFunc((void*)p1.ev_long));
}

int _stdcall AllocThunk(int nSize, void **lpAddress)
{
	void *pThunk;
	DWORD dwProtect;

	pThunk = HeapAlloc(ghThunkHeap,0,nSize);
	if (pThunk)
	{
		if (VirtualProtect(pThunk,nSize,PAGE_EXECUTE_READWRITE,&dwProtect))
		{
			*lpAddress = pThunk;
			return 0;
		}
		else
		{
			SAVEWIN32ERROR(VirtualProtect,GetLastError());
			HeapFree(ghThunkHeap,0,pThunk);
			return -1;
		}
	}
	else
		return E_INSUFMEMORY;
}

BOOL _stdcall FreeThunk(void *lpAddress)
{
	return HeapFree(ghThunkHeap,0,lpAddress);
}
