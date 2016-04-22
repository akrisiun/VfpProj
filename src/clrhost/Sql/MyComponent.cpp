#include "MyComponent.h"

/*
Calling Native Functions from Managed Code

/clr /MTd incompatible

https://msdn.microsoft.com/en-us/library/ms235282.aspx


marshaling a String * argument: BStr, ANSIBStr, TBStr, LPStr, LPWStr, and LPTStr.The default is LPStr.
In this example, the string is marshaled as a double - byte Unicode character string, LPWStr.The output is the first letter of Hello World!because the second byte of the marshaled string is null, and puts interprets this as the end - of - string marker.
// platform_invocation_services_3.cpp
// compile with: /clr
using namespace System;
using namespace System::Runtime::InteropServices;

[DllImport("msvcrt", EntryPoint = "puts")]
extern "C" int puts([MarshalAs(UnmanagedType::LPWStr)] String ^);

int main() {
    String ^ pStr = "Hello World!";
    puts(pStr);
}

*/