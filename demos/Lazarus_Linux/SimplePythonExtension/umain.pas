unit umain;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,
  uP4P.Interfaces, uP4P.Types, uP4P.Constants, uP4P.PyObject, uP4P.Engine;

function PyInit_simplepythonextension: PPyObject; cdecl;
function PyModExport_simplepythonextension: PPySlot; cdecl;

implementation      

// This demo creates a Python extension module.
//
// This project is configured to use the SimplePythonCodeRunner demo in the
// "Run -> Parameters..." menu option in order to debug the code.
//
// You will need to execute a custom script that appends the directory where
// SimplePythonExtension.pyd is located to the path, import the extension and
// call the extension functions. Set the breakpoints before debugging this
// project. This is an example of the script for the SimplePythonCodeRunner
// demo:
//
//     import sys
//     sys.path.append(R'/home/username/Lazarus/P4P/bin64')
//     import simplepythonextension
//     print(simplepythonextension.uppercase("qwerty"))
//

uses
  uextensionmodule;

var
  GExtension : TExtensionModule = nil;
                                
// Older Python versions initialize extensions with PyInit_<name>.
// https://docs.python.org/3.14/c-api/extension-modules.html
function PyInit_simplepythonextension: PPyObject; cdecl;
begin
  GlobalP4PEngine := TP4PEngine.Create;
                                          
  // First, we load the Python library with this especial function for extension modules
  if GlobalP4PEngine.LoadInExtensionModule then
    begin          
      // then we create the extension and in this case return the ModuleDef pointer.
      GExtension := TExtensionModule.Create;
      Result     := PPyObject(GExtension.ModuleDef);
    end
   else
    Result := nil;
end;
                                  
// Python 3.15 initializes extensions with PyModExport_<name>.
// https://docs.python.org/3.15/c-api/extension-modules.html
function PyModExport_simplepythonextension: PPySlot; cdecl;
begin
  GlobalP4PEngine := TP4PEngine.Create;
                                     
  // First, we load the Python library with this especial function for extension modules
  if GlobalP4PEngine.LoadInExtensionModule then
    begin                         
      // then we create the extension and in this case return the Slots pointer.
      GExtension := TExtensionModule.Create;
      Result     := GExtension.Slots;
    end
   else
    Result := nil;
end;

procedure DestroyExtension;
begin
  if assigned(GExtension) then
    FreeAndNil(GExtension);
end;

procedure FinalizeExtension;
begin
  if assigned(GExtension) then
    GExtension.Finalize;
end;

initialization

finalization
  FinalizeExtension;
  DestroyGlobalP4PEngine;
  DestroyExtension;

end.

