#pragma once

// These are the standard includes for using GDI + :
#include <windows.h>
#include <objidl.h>
#include <gdiplus.h>

using namespace Gdiplus;
#pragma comment (lib,"Gdiplus.lib")


class GdiPlus
{
public:
	GdiPlus();
	~GdiPlus();
};

//Severity	Code	Description	Project	File	Line
//Warning	LNK4075	ignoring '/EDITANDCONTINUE' due to '/SAFESEH' specification	Clr(clr\Clr) ClrHost.obj

/* 
odbc32.lib
odbccp32.lib
sqlncli11.lib
wsock32.lib
wininet.lib
gdiplus.lib
mscoree.lib
*/