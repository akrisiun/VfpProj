using IOFile;
using System;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Windows;
using System.Windows.Controls;
using VfpProj.Native;
using VisualFoxpro;
using FolderWindow = VfpProj.PrjWindow;

namespace VfpProj
{
    public static class Tree
    {
        public static void Bind(this FolderWindow w)
        {
            w.txtPath = w.hostPath.Child as System.Windows.Forms.TextBox;
            w.txtPath.Text = FileSystem.CurrentDirectory;
            NativeAutocomplete.SetFileAutoComplete(w.txtPath);

            var treeView = w.tree;
            treeView.MouseMove += TreeViewDrag.treeView_MouseMove;
            treeView.MouseLeftButtonUp += TreeViewDrag.treeView_MouseDown;
            treeView.DragOver += TreeViewDrag.treeView_DragOver;
        }

        public static void LoadPrj(this Window w, TreeView tree, VisualFoxpro.IFoxProject vfpProj, string projName)
        {
            ProjTree.Load(w, tree, vfpProj, projName);
        }

        public static void LoadFolder(this FolderWindow w, string dir)
        {
            if (File.Exists(dir))
            {
                // project file
                var info = new VfpFileInfo();

                TextRead.ReadVfpInfo(ref info, ref dir, (f) =>
                    {
                    }
                );
                return;
            }
            else if (Directory.Exists(dir))
                FileSystem.CurrentDirectory = dir;

            string projName = FileSystem.CurrentDirectory;

            FolderTree.LoadDir(w, w.tree, projName);
        }

    }

    public static class FolderTree
    {
        public static void LoadDir(Window w, TreeView tree, string dir)
        {
            IEnumerable<IOFile.DirectoryEnum.FileDataInfo> list = null;
            try
            {
                list = DirectoryEnum.ReadFilesInfo(dir, searchOption: SearchOption.TopDirectoryOnly);
                var num = list.GetEnumerator();
                if (num.MoveNext())
                { 
                    tree.Items.Clear();
                    tree.Items.Add("..");
                    do
                    {
                        var item = num.Current;
                        if (IsIgnore(item.cFileName))
                            continue;

                        string filePrg = Path.GetFileName(item.cFileName);
                        tree.Items.Add(filePrg);

                    } while (num.MoveNext());
                }
            }
            catch { }
        }

        public static bool IsIgnore (string fileName)
        {
           if (fileName.StartsWith("."))
               return true;
           var ext = Path.GetExtension(fileName);
           if (ext.Length == 0)
               return false;

            ext = ext.ToLower();
            if (ext == ".exe" || ext == ".dll" || ext == ".metagen" 
                || ext == ".fxp" || ext == ".obj"
                || ext == ".bsc" || ext == ".lib" || ext == ".exp"
                || ext == ".sdf" || ext == ".suo"
                || ext == ".pdb" || fileName.Contains(".vshost."))
                return true;

            return false;
        }

    }

    public static class ProjTree
    {
        public static void Load(Window w, TreeView tree, VisualFoxpro.IFoxProject proj, string file)
        {
            if (proj == null)
                return;

            string main = null;
            IList<ProjItem> list = null;
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
                // dynamic 
                var elem = filesNum.Current as IFoxPrjFile;
                var elemName = "";
                elemName = elem["Name"] as string;
                // elemName = elem.Name; // elem["Name"] as string,
                if (elem != null) {
                    var item = new ProjItem {
                        Name = elemName,
                        Exclude = elem.Exclude, Type = elem.Type };
                    list.Add(item);
                }
            }

            return list;
        }
    }
}
