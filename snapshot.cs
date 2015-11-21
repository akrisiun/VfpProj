https://msdn.microsoft.com/en-us/library/dd373487(v=vs.85).aspx
The following example code is in the WM_PAINT message handler for a subclassed button control. The text for the control is drawn in the visual styles font, but the color is application-defined depending on the state of the control.
C++

// textColor is a COLORREF whose value has been set according to whether the button is "hot".
// paint is the PAINTSTRUCT whose members are filled in by BeginPaint.
HTHEME theme = OpenThemeData(hWnd, L"button");
if (theme)
{
    DTTOPTS opts = { 0 };
    opts.dwSize = sizeof(opts);
    opts.crText = textColor;
    opts.dwFlags |= DTT_TEXTCOLOR;
    WCHAR caption[255];
    size_t cch;
    GetWindowText(hWnd, caption, 255);
    StringCchLength(caption, 255, &cch);
    DrawThemeTextEx(theme, paint.hdc, BP_PUSHBUTTON, CBS_UNCHECKEDNORMAL, 
        caption, cch, DT_CENTER | DT_VCENTER | DT_SINGLELINE, 
        &paint.rcPaint, &opts);
    CloseThemeData(theme);
}
else
{
    // Draw the control without using visual styles.
}

public Bitmap TakeSnapshot(object pUnknown, Rectangle bmpRect)
{
	if (pUnknown == null)
		return null;
	//???com??
	if (!Marshal.IsComObject(pUnknown))
		return null;
	//IViewObject ??
	UnsafeNativeMethods.IViewObject ViewObject = null;
	IntPtr pViewObject = IntPtr.Zero;
	//???
	Bitmap pPicture = new Bitmap(bmpRect.Width, bmpRect.Height);
	using (Graphics hDrawDC = Graphics.FromImage(pPicture))
	{
		//????
		object hret = Marshal.QueryInterface(Marshal.GetIUnknownForObject(pUnknown),
			ref UnsafeNativeMethods.IID_IViewObject, out pViewObject);
		try
		{
			ViewObject = Marshal.GetTypedObjectForIUnknown(pViewObject, typeof(UnsafeNativeMethods.IViewObject)) as UnsafeNativeMethods.IViewObject;
			//??Draw??
			ViewObject.Draw((int)DVASPECT.DVASPECT_CONTENT,
				-1,
				IntPtr.Zero,
				null,
				IntPtr.Zero,
				hDrawDC.GetHdc(),
				new NativeMethods.COMRECT(bmpRect),
				null,
				IntPtr.Zero,
				0);
		}
		catch (Exception ex)
		{
			Console.WriteLine(ex.Message);
			throw ex;
		}
	}
	return pPicture;
}
