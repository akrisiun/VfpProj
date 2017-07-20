using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using VisualFoxpro;

namespace VfpEdit
{
    public class ProjItem {
        public string Name { get; set; }
        public bool Exclude { get; set; }
        public string Type { get; set; } // "P" - prg
    }
    

    public static class ProjTree
    {
        public static void Load(EditWindow w, VisualFoxpro.IFoxProject proj, string file)
        {
            if (proj == null)
                return;

            string main = null;
            IList<ProjItem> list = null;
            TreeView tree = w.tree;
            try
            {
                main = proj.MainFile;

                list = GetList(proj);

                tree.Items.Clear();
                foreach (var item in list)
                {
                    if (!"P".Equals(item.Type))
                        continue;

                    string filePrg = Path.GetFileName(item.Name);
                    tree.Items.Add(filePrg);
                }
            }
            catch { }
        }

        static IList<ProjItem> GetList(IFoxProject proj)
        {
            var list = new List<ProjItem>();

            IFoxPrjFiles files = proj.Files;
            IEnumerator filesNum =  files.GetEnumerator();
            while (filesNum.MoveNext())
            {
                dynamic elem = filesNum.Current;

                var item = new ProjItem { Name = elem.Name, Exclude = elem.Exclude, Type = elem.Type};
                list.Add(item);
            }

            return list;
        }
    }
}
