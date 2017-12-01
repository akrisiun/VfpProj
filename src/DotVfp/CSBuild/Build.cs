/*
dotnet new classlib 

An MSBuild task can be implemented in C#. MSBuild can load and run any public class that implements Microsoft.Build.Framework.ITask. You can compile against this API by referencing the NuGet package Microsoft.Build.Framework.
There are also helpful abstract classes available by referencing Microsoft.Build.Utilities.Core.

<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <TargetFrameworks>net46</TargetFrameworks>
    <RootNamespace>MSBuildTasks</RootNamespace>
    <AssemblyName>DotBuild</AssemblyName>
  </PropertyGroup>
  <ItemGroup>
    <PackageReference Include="Microsoft.Build.Framework" Version="15.1.1012" />
    <PackageReference Include="Microsoft.Build.Utilities.Core" Version="15.1.1012" />
  </ItemGroup>
</Project>

<!-- <Project DefaultTargets="Build" xmlns="http://schemas.microsoft.com/developer/msbuild/2003" ToolsVersion="12.0"> -->
   <UsingTask TaskName="MSBuildTasks.DotBuild" AssemblyFile="..\DotBuild.dll" />  
   <Target Name="Build">
          <DotBuild />
   </Target>
</Project>

In this example, I’m using Microsoft.Build.Utilities.Task to implement ITask.
This base class provides an API for accessing the MSBuild logger.
*/

// SayHello.cs
using System;
using System.Diagnostics;
using Microsoft.Build.Framework;

namespace MSBuildTasks
{
    public class DotBuild : Microsoft.Build.Utilities.Task
    {
        public override bool Execute()
        {
            Log.LogMessage(MessageImportance.High, "dotnet restore");
            
            var exitCode = Cmd.Execute("dotnet.exe", "restore");

            Log.LogMessage(MessageImportance.High, "dotnet build");
            Log.LogMessage(MessageImportance.High, "not dot rescursion");
            // exitCode = Cmd.Execute("dotnet.exe", "build");
            
            // var filename = "nuget.exe";
            // var arguments = $"pack -Version {version} -OutputDirectory {tempPath} -properties Configuration=Release {projectPath}";
            
            return true;
        }
    }
}
