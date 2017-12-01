using System;
using System.Diagnostics;

namespace MSBuildTasks
{
    // https://stackoverflow.com/questions/44445018/net-core-command-line-app-process-start-runs-on-some-machines-but-not-other

    public static class Cmd
    {
        public static int Timeout = 30000;
        
        public static int Execute(string filename, string arguments)
        {
            var startInfo = new ProcessStartInfo
            {
                // CreateNoWindow = true,
                FileName = filename,
                Arguments = arguments,
            };
            
            startInfo.UseShellExecute = false;

            using (var process = new Process { StartInfo = startInfo })
            {
                try
                {
                    process.Start();
                    process.WaitForExit(Timeout);
                    return process.ExitCode;
                }

                catch (Exception exception)
                {
                    if (!process.HasExited)
                    {
                        process.Kill();
                    }

                    Console.WriteLine($"Cmd could not execute command {filename} {arguments}:\n{exception.Message}");
                    // return (int)ExitCode.Exception;
                    return Environment.ExitCode;
                }
            }
        }
    }
}