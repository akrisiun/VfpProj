using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace VfpProj.Native
{
    public static class WindowsTab
    {
        public static void FillList(_Form form)
        {
            // NativeWindow native2 = null;
            try
            {
                // native2 = NativeWindow.FromHandle(FoxCmd.nativeWindow.Handle);
            }
            catch (Exception ex)
            {
                App.Application_ThreadException(form, new ThreadExceptionEventArgs(ex));
            }
            
            return;

            /* if (native2 == null)
                return;

            var winList = NativeMethods.GetWindows();

            if (winList == null || winList.Count == 0)
            {
                if (!FoxCmd.Attach())
                    return;
                FoxCmd.ShowApp();

                if (!form.Visible)
                {
                    form.Show(FoxCmd.nativeWindow);
                    form.Visible = true;
                }
                else
                {
                    FoxCmd.SetVar();
                    form.OnTop = true;
                }

                winList = NativeMethods.GetWindows();
            }

            var list = form.tabWI.TabPages;
            var listWI = form.events.listWI;

            if (winList.Count > 0)
            {
                list.Clear();
                listWI.Clear();

                foreach (IntPtr ptr in winList)
                {

                    NativeWndInfo wi = new NativeWndInfo(ptr);
                    if (wi.text.Length > 0 && NativeMethods.IsWindowVisible(ptr))
                    {
                        listWI.Add(wi);

                        TabPage item = new TabPage(wi.text);
                        item.Tag = wi;
                        list.Add(item);
                    }
                }

            }
             */

        }

    }

}
