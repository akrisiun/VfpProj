#if NET46

using Microsoft.Build.Utilities;
using Microsoft.Build.Framework;
using System;

namespace VfpLanguage.Helpers
{
    public class VfpBuildTask : Task
    {
        public const string TargetTypeExecutable = "executable";
        public const string TargetTypeScript = "script";

        private static readonly string[] _targetTypes = { TargetTypeExecutable, TargetTypeScript };
        public const string ExecuteInConsole = "console";
        public const string ExecuteInConsolePause = "consolepause";

        private static readonly string[] _executeIns = { ExecuteInConsole, ExecuteInConsolePause };

        public IBuildEngine BuildEngineObj { get; set; }
        public ITaskHost HostObjectObj { get; set; }

        internal VfpBuildTask(string projectPath, IBuildEngine buildEngine)
        {
            BuildEngine = buildEngine;
            ProjectPath = projectPath;

            HostObjectObj = base.HostObject;
            BuildEngineObj = BuildEngine ?? buildEngine;
        }

        protected string ProjectPath { get; private set; }

        public override bool Execute()
        {
            //throw new NotImplementedException();
            return false;
        }
    }
}

#endif