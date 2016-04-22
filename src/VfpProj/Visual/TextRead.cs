using ICSharpCode.AvalonEdit.Folding;
using ICSharpCode.AvalonEdit.Utils;
using System;
using System.IO;
using System.Text;
using System.Windows;
using VfpProj; 

namespace VfpProj
{
    public struct VfpFileInfo
    {
        public VisualFoxpro.IFoxProject vfpProj;
        public FileInfo f;

        public bool Success { get { return f != null && f.Exists && vfpProj != null; } } 
        public string Ext {get {return f == null ? null : Path.GetExtension(f.Name).ToLower(); }}

        public override string ToString()
        {
            return f.Name;
        }
    }

    public static class TextRead
    {
        public static void Open(this EditWindow w)
        { 
            string fileName = w.txtPath.Text;
            var info = new VfpFileInfo();
            var editor = w.editor;

            ReadVfpInfo(ref info, ref fileName, Open: (FileName) => 
                {
                    w.Title = Path.GetFileName(FileName) + " " + Path.GetDirectoryName(FileName);
                    using (var stream = FileReader.OpenFile(FileName, Encoding.GetEncoding(1257)))
                    {
                        editor.Text = stream.ReadToEnd();
                    }
                }
            );

            if (!info.Success)
                return; 

            var foldManager = w.foldManager;
            if (foldManager != null)
                FoldingManager.Uninstall(foldManager);

            var ext = info.Ext;
            if (ext == ".PJX" || ext.Length == 0 || fileName == null)
            {
                if (info.vfpProj != null)
                {
                    string projName = info.vfpProj.Name;
                    Tree.LoadPrj(w, w.tree, info.vfpProj, projName);
                }
                if (editor.Text.Length == 0)
                   return;
            }
            if (fileName == null || ext == null)
                return;

            ext = Path.GetExtension(fileName);
            editor.SyntaxHighlighting = w.defManager.GetDefinitionByExtension(ext);
            var doc = editor.Document;
            var area = editor.TextArea;
            foldManager = FoldingManager.Install(area);

            if (ext.Contains(".x") || ext.Contains(".a") || ext.Contains(".csproj"))
                w.xmlStrategy.UpdateFoldings(foldManager, doc);
            else
                w.csStrategy.UpdateFoldings(foldManager, doc);

            // int firstError = -1;
            // foldManager.UpdateFoldings(this.foldStrategy.CreateNewFoldings(doc, out firstError), firstError);
        }

        public static void ReadVfpInfo(ref VfpFileInfo info, ref string fileName, Action<String> Open)
        {
            VisualFoxpro.IFoxProject vfpProj = null;
            FileInfo f = null;

            try
            {
                vfpProj = FoxCmd.App.ActiveProject;
            }
            catch { }
            try
            {
                f = new FileInfo(fileName);
                if (!f.Exists && vfpProj == null)
                    return;
            }
            catch { }

            string ext = "";

            try
            {
                fileName = fileName ?? vfpProj.Name;

                Directory.SetCurrentDirectory(Path.GetDirectoryName(fileName));
                ext = Path.GetExtension(fileName).ToUpperInvariant();

                Open(fileName);

            }
            catch (Exception ex)
            {
                if (ext.Length > 0 && ext != ".PJX")
                    MessageBox.Show("File " + fileName + " error\n" + ex);
            }
        }
    }
}
