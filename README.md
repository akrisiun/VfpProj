## nuget reinit

```
Update-Package -Reinstall
```

## Open Command Line

parsing "(?<=(^[\s]+))?(rem|::).+|((?<=([\s]+))&(*|::).+)" - Quantifier {x,y} following nothing.

Error

1115 ERROR System.ComponentModel.Composition.CompositionException: The composition produced a single composition error. 
The root cause is provided below. Review the CompositionException.Errors property for more detailed information. 1) The export 
'Microsoft.VisualStudio.Text.Classification.Implementation.ClassificationTypeRegistryService 
(ContractName="Microsoft.VisualStudio.Text.Classification.IClassificationTypeRegistryService")' is not assignable to type 
'Microsoft.VisualStudio.Text.Classification.IClassificationTypeRegistryService'. Resulting in: Cannot set import 
'MadsKristensen.OpenCommandLine.CmdClassifierProvider.Registry (ContractName="Microsoft.VisualStudio.
Text.Classification.IClassificationTypeRegistryService")' on part 'MadsKristensen.OpenCommandLine.CmdClassifierProvider'.
 Element: MadsKristensen.OpenCommandLine.CmdClassifierProvider.Registry
  (ContractName="Microsoft.VisualStudio.Text.Classification.IClassificationTypeRegistryService") --> 
  MadsKristensen.OpenCommandLine.CmdClassifierProvider Resulting in:
   Cannot get export 'MadsKristensen.OpenCommandLine.CmdClassifierProvider 
   (ContractName="Microsoft.VisualStudio.Text.Classification.IClassifierProvider")' 
   from part 'MadsKristensen.OpenCommandLine.CmdClassifierProvider'. Element: 
   MadsKristensen.OpenCommandLine.CmdClassifierProvider
   
    (ContractName="Microsoft.VisualStudio.Text.Classification.IClassifierProvider") 
	--> MadsKristensen.OpenCommandLine.CmdClassifierProvider at System.ComponentModel.
	Composition.Hosting.CompositionServices.GetExportedValueFromComposedPart(
	   ImportEngine engine, ComposablePart part, ExportDefinition definition) 
	    at System.ComponentModel.Composition.Hosting.CatalogExportProvider.GetExportedValue(
			CatalogPart part, ExportDefinition export, Boolean isSharedPart) at System.ComponentModel.
			Composition.Hosting.CatalogExportProvider.CatalogExport.GetExportedValueCore() 
	 at System.ComponentModel.Composition.Primitives.Export.get_Value() at System.ComponentModel
	 .Composition.ExportServices.GetCastedExportedValue[T](Export export) at System.ComponentModel
	 .Composition.ExportServices.<>c__DisplayClass0`2.<CreateStronglyTypedLazyOfTM>b__2() at System.Lazy`1.CreateValue() 
	 at System.Lazy`1.LazyInitValue() at System.Lazy`1.get_Value() at Microsoft.VisualStudio.Text.Utilities
	 .GuardedOperations.InvokeMatchingFactories[TExtensionInstance,TExtensionFactory,TMetadataView](
	  IEnumerable`1 lazyFactories, Func`2 getter, IContentType dataContentType, Object errorSource) 


### A Visual Studio extension

[![Build status](https://ci.appveyor.com/api/projects/status/1jah71aylecjbkeh?svg=true)](https://ci.appveyor.com/project/madskristensen/opencommandline)

Download from the
[Visual Studio Gallery](https://visualstudiogallery.msdn.microsoft.com/4e84e2cf-2d6b-472a-b1e2-b84932511379)
or get the
[nightly build](http://vsixgallery.com/extension/f4ab1e64-5d35-4f06-bad9-bf414f4b3ccc/) original: bbb/)

## Supported consoles

The Open Command Line extension supports all types of consoles like cmd, PowerShell,
Bash and more. You can easily configure which to use by setting the paths and arguments
in the Options.

![Open Command Line](screenshots/options.png)

### How it works

This extension adds a new command to the project context menu that will open
a command prompt on the project's path. If the solution node is selection in Solution
Explorer, then a console will open at the root of the .sln file.

![Open Command Line](screenshots/context-menu.png)

You can access the command by hitting **ALT+Space** as well.

You may change this shortcut in the Options Window under Environment -> Keyboard

Look for the command ProjectAndSolutionContextMenus.Project.OpenCommandLine.Default

### Syntax highlighter

Full colorization for batch files (.cmd and .bat) in the Visual Studio
editor.

![Batch file colorizer](screenshots/classifier.png)

### Intellisense

Intellisense is provided for variables.

![Intellisense keywords](screenshots/intellisense.png)

### Execute batch file

You can easily execute any .cmd or .bat file. For files in your solution,
a context-menu button shows up.

![Execute batch file](screenshots/execute-context-menu.png)

Alternatively, the keyboard shortcut `Shift+Alt+5` can be used when
editing a batch file. This makes it really easy and fast to execute
any batch file - even ones that are not part of your project.

## License
[Apache 2.0](LICENSE)
