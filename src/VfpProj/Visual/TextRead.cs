using ICSharpCode.AvalonEdit.Folding;
using ICSharpCode.AvalonEdit.Utils;
using System;
using System.IO;
using System.Text;
using System.Windows;
using VfpProj; 

namespace VfpEdit
{
    public static class TextRead
    {
        public static void Open(this EditWindow w)
        { 
            string fileName = w.txtPath.Text;

            VisualFoxpro.IFoxProject vfpProj = null;
            FileInfo f = null;
            var editor = w.editor;
            var foldManager = w.foldManager;
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
            if (foldManager != null)
                FoldingManager.Uninstall(foldManager);

            try
            {
                fileName = fileName ?? vfpProj.Name;
                w.Title = Path.GetFileName(fileName) + " " + Path.GetDirectoryName(fileName);

                Directory.SetCurrentDirectory(Path.GetDirectoryName(fileName));
                ext = Path.GetExtension(fileName).ToUpperInvariant();
                
                using (var stream = FileReader.OpenFile(fileName, Encoding.GetEncoding(1257)))
                {
                    editor.Text = stream.ReadToEnd();
                }
            }
            catch (Exception ex)
            {
                if (ext.Length > 0 && ext != ".PJX")
                   MessageBox.Show("File " + fileName + " error\n" + ex);
            }

            if (ext == ".PJX" || ext.Length == 0 || fileName == null)
            {
                if (vfpProj != null)
                {
                    string projName = vfpProj.Name;
                    ProjTree.Load(w, vfpProj, projName);
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
    }
}
