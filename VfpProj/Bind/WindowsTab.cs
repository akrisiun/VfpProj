using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Controls;
using VfpInterop;

namespace VfpProj.Native
{
    public static class WindowsTab
    {
        public static void FillList(_Form form, IntPtr mainHandle)
        {
            var winList = NativeMethods.GetWindows(mainHandle);
 
            var formCS = form.Form;
            var tabList = formCS.tabList;
            var listWI = form.Events.listWI;

            if (winList.Count > 0)
            {
                tabList.IsEnabled = false;
                listWI.Clear();

                foreach (IntPtr ptr in winList)
                {
                    NativeWndInfo wi = new NativeWndInfo(ptr);
                    if (wi.text.Length > 0 && NativeMethods.IsWindowVisible(ptr))
                    {
                        listWI.Add(wi);
                    }
                }

                for(int i = 0; i < tabList.Items.Count; i++)
                {
                    TabItem item = tabList.Items[i] as TabItem;
                    int findIndex = -1;
                    var wi = item.Tag as NativeWndInfo;
                    if (wi != null)
                        foreach(var wiItem in listWI)
                            if (wiItem.item == wi.item)
                            {
                                findIndex = listWI.IndexOf(wiItem); break;
                            }

                    if (findIndex == -1)
                        tabList.Items.Remove(item);
                }

                foreach (var wi in listWI)
                {
                    int index = -1;
                    foreach (TabItem item in tabList.Items)
                        if (item.Tag is NativeWndInfo
                            && ((item.Tag as NativeWndInfo).item == wi.item
                                 || (item.Tag as NativeWndInfo).ptr == wi.ptr
                                 || (item.Tag as NativeWndInfo).text == wi.text))
                        {
                            index = tabList.Items.IndexOf(item); break;
                        }

                    if (index >= 0)
                    {
                        var item = tabList.Items[index] as TabItem;
                        item.Header = wi.text;
                        item.Tag = wi;
                    }
                    else
                    {
                        // <TabItem Name="tab1" Header="TabItem1" />
                        TabItem item = new TabItem() { Header = wi.text, MaxWidth=90 };
                        item.Tag = wi;
                        tabList.Items.Add(item);
                    }
                }

                tabList.IsEnabled = true;
            }

        }
    }

}
