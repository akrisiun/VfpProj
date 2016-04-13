using System;
using System.IO;
using System.Windows;

namespace VfpEdit
{
    public static class TextDrop
    {
        public static void Bind(this EditWindow w)
        {
            w.editor.Tag = w;
            w.editor.AllowDrop = true;
            w.editor.PreviewDragOver += (s, e) => EhDragOver(s, e);
            w.editor.PreviewDrop += (s, e) => EhDrop(s, e);
        }

        static void EhDragOver(object sender, DragEventArgs args)
        {
            args.Effects = DragDropEffects.Copy; // IsSingleFile(args) != null ?  : DragDropEffects.None;

            // Mark the event as handled, so TextBox's native DragOver handler is not called.
            args.Handled = true;
        }

        static void EhDrop(object sender, DragEventArgs args)
        {
            args.Handled = true;

            var fileName = IsSingleFile(args);
            if (fileName == null) return;

            //var fileNames = args.Data.GetData(DataFormats.FileDrop, true) as string[];
            //// Check fo a single file or folder.
            //if (fileNames.Length >= 1)

            var fileToLoad = new StreamReader(fileName);

            EditWindow w = (sender as FrameworkElement).Tag as EditWindow;
            if (w == null)
                return;

            w.txtPath.Text = fileName;
            try
            {
                w.editor.Text = fileToLoad.ReadToEnd();
                fileToLoad.Close();
            }
            catch (Exception ex) { MessageBox.Show(ex.Message); }
        }

        // If the data object in args is a single file, this method will return the filename. Otherwise, it returns null.
        static string IsSingleFile(DragEventArgs args)
        {
            // Check for files in the hovering data object.
            if (!args.Data.GetDataPresent(DataFormats.FileDrop, true))
                return null;

            var fileNames = args.Data.GetData(DataFormats.FileDrop, true) as string[];
            // Check fo a single file or folder.
            if (fileNames.Length >= 1 && File.Exists(fileNames[0]))
            {
                // At this point we know there single or more files. returns first
                return fileNames[0];
            }
            return null;
        }
    }
}
