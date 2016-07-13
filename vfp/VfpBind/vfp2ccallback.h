#ifndef _VFP2CCALLBACK_H__
#define _VFP2CCALLBACK_H__

#define VFP2C_MAX_TYPE_LEN 32

#define VFP2C_MAX_CALLBACK_FUNCTION		768
#define VFP2C_MAX_CALLBACK_FUNCTION_EX	1024
#define VFP2C_MAX_CALLBACK_BUFFER		4096
#define VFP2C_MAX_CALLBACK_PARAMETERS	27

#define BINDEVENTSEX_CALL_BEFORE		0x0001
#define BINDEVENTSEX_CALL_AFTER			0x0002
#define BINDEVENTSEX_RETURN_VALUE		0x0004
#define BINDEVENTSEX_NO_RECURSION		0x0008
#define BINDEVENTSEX_CLASSPROC			0x0010

#define BINDEVENTSEX_OBJECT_SCHEME	"__VFP2C_WCBO%U_%U_%U"
#define CALLBACKFUNC_OBJECT_SCHEME	"__VFP2C_CBO_%U"

typedef struct _MSGCALLBACK {
	UINT uMsg;
	NTI nObject;
	void* pCallbackThunk;
	char* pCallbackFunction;
	struct _MSGCALLBACK *next;
} MSGCALLBACK, *LPMSGCALLBACK;

typedef struct _WINDOWSUBCLASS {
	HWND hHwnd;
	BOOL bClassProc;
	WNDPROC pDefaultWndProc;
	void* pWindowThunk;
	void* pHookWndRetCall;
	void* pHookWndRetEax;
	LPMSGCALLBACK pBoundMessages;
	char aCallbackBuffer[VFP2C_MAX_CALLBACK_BUFFER];
	struct _WINDOWSUBCLASS *next;
} WINDOWSUBCLASS, *LPWINDOWSUBCLASS;

typedef struct _CALLBACKFUNC {
	char aCallbackBuffer[VFP2C_MAX_CALLBACK_BUFFER];
	NTI nObject;
	void *pFuncAddress;
	struct _CALLBACKFUNC *next;
} CALLBACKFUNC, *LPCALLBACKFUNC;

#ifdef __cplusplus
extern "C" {
#endif

BOOL _stdcall VFP2C_Init_Callback();
void _stdcall VFP2C_Destroy_Callback();

void _fastcall CreateCallbackFunc(ParamBlk *parm);
void _fastcall DestroyCallbackFunc(ParamBlk *parm);

void _fastcall BindEventsEx(ParamBlk *parm);
void _fastcall UnBindEventsEx(ParamBlk *parm);

#ifdef __cplusplus
} // extern C
#endif

BOOL _stdcall SubclassWindow(LPWINDOWSUBCLASS lpSubclass);
BOOL _stdcall UnsubclassWindow(LPWINDOWSUBCLASS lpSubclass);
BOOL _stdcall UnsubclassWindowEx(LPWINDOWSUBCLASS lpSubclass);
BOOL _stdcall UnsubclassWindowExCallback(HWND hHwnd, LPARAM lParam);
BOOL _stdcall UnsubclassWindowExCallbackChild(HWND hHwnd, LPARAM lParam);

int _stdcall CreateSubclassThunkProc(LPWINDOWSUBCLASS lpSubclass);
int _stdcall CreateSubclassMsgThunkProc(LPWINDOWSUBCLASS lpSubclass, LPMSGCALLBACK lpMsg, char *pCallback, char *pParmDef, DWORD nFlags, BOOL bObjectCall);

LPWINDOWSUBCLASS _stdcall NewWindowSubclass(HWND hHwnd, BOOL bClassProc);
void _stdcall FreeWindowSubclass(LPWINDOWSUBCLASS lpSubclass);
void _stdcall RemoveWindowSubclass(LPWINDOWSUBCLASS lpSubclass);
LPWINDOWSUBCLASS _stdcall FindWindowSubclass(HWND hHwnd, BOOL bClassProc);
void _stdcall ReleaseWindowSubclasses();

LPMSGCALLBACK _stdcall NewMsgCallback(UINT uMsg);
void _stdcall FreeMsgCallback(LPWINDOWSUBCLASS pSubclass, LPMSGCALLBACK lpMsg);
LPMSGCALLBACK AddMsgCallback(LPWINDOWSUBCLASS pSubclass, UINT uMsg);
BOOL _stdcall RemoveMsgCallback(LPWINDOWSUBCLASS pSubclass, UINT uMsg);
void* _stdcall FindMsgCallbackThunk(LPWINDOWSUBCLASS pSubclass, UINT uMsg);

LPCALLBACKFUNC _stdcall NewCallbackFunc();
BOOL _stdcall DeleteCallbackFunc(void *pFuncAddress);
void _stdcall ReleaseCallbackFuncs();

int _stdcall AllocThunk(int nSize, void **lpAddress);
BOOL _stdcall FreeThunk(void *lpAddress);

#endif // _VFP2CCALLBACK_H__