using System;

namespace VfpProj
{
    public static class FileSystem
    {
        public static string CurrentDirectory { get { return Environment.CurrentDirectory; } set { System.IO.Directory.SetCurrentDirectory(value); } }


    }
}
