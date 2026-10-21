unit uextensionmodule;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SysUtils,
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.CustomPyModule, uP4P.PyNone, uP4P.PyModuleDef, uP4P.PyCustomModuleSlotManager;

type                                   
  // TCustomPyModule has all the logic to create modules and we only have to
  // override some procedures where we'll create the classes that declare our
  // custom functions: is_even, uppercase.
  //
  // In older Python version we would need to create a custom TPyModuleDef class
  // but in Python 3.15 we need to create a custom TPyModuleSlotManager class.
  TExtensionModule = class(TCustomPyModule)
    protected
      procedure CreateModuleDef; override;
      procedure CreateSlotManager; override;
      function  NumberIsEven(args: PPyObject): PPyObject;
      function  CustomUppercase(args: PPyObject): PPyObject;

    public
      constructor Create; reintroduce;
      procedure   AfterConstruction; override;
  end;
                                               
  // This class will add our custom functions in older Python versions
  TExtensionPyModuleDef = class(TPyModuleDef)
    protected
      procedure AddAllMethods; override;
  end;
                                                      
  // This class will add out custom function in Python 3.15
  TExtensionPySlotManager = class(TPyCustomModuleSlotManager)
    protected
      procedure AddAllMethods; override;
  end;

implementation

uses
  uP4P.Engine, uP4P.PyTuple, uP4P.PyBool, uP4P.PyUnicode;
                                                   
// This is the callback for the "is_even" function.
// It finds the module instance using GlobalP4PEngine.SearchModule and calls
// TExtensionModule.NumberIsEven
function extmod_is_even(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule: TCustomPyModule;
begin
  TempModule := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchModule(self, TempModule) and
     (TempModule is TExtensionModule) then
    Result := TExtensionModule(TempModule).NumberIsEven(args)
   else
    Result := TPyNone.ReturnNone;
end;
                                            
// This is the callback for the "uppercase" function
// It finds the module instance using GlobalP4PEngine.SearchModule and calls
// TExtensionModule.CustomUppercase
function extmod_uppercase(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule: TCustomPyModule;
begin
  TempModule := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchModule(self, TempModule) and
     (TempModule is TExtensionModule) then
    Result := TExtensionModule(TempModule).CustomUppercase(args)
   else
    Result := TPyNone.ReturnNone;
end;

{ TExtensionModule }

constructor TExtensionModule.Create;
begin
  inherited Create('simplepythonextension', True);

  FMultIntprSupport := piGilSupported;
end;

procedure TExtensionModule.AfterConstruction;
begin
  inherited AfterConstruction;

  Initialize;
end;

procedure TExtensionModule.CreateModuleDef;
begin
  FModuleDef := TExtensionPyModuleDef.Create;
end;

procedure TExtensionModule.CreateSlotManager;
begin
  FSlotManager := TExtensionPySlotManager.Create;
end;

function TExtensionModule.NumberIsEven(args: PPyObject): PPyObject;
var
  TempArgs, TempNumber : IPyObject;
begin
  TempArgs := TPyObject.Wrap(args, False);

  if TPyTuple.Check(TempArgs) then
    begin
      TempNumber := TPyTuple.GetItem(TempArgs, 0);

      if (TempNumber.AsInteger mod 2 = 0) then
        Result := TPyBool.ReturnTrue
       else
        Result := TPyBool.ReturnFalse;
    end
   else
    Result := TPyNone.ReturnNone;
end;

function TExtensionModule.CustomUppercase(args: PPyObject): PPyObject;
var
  TempArgs, TempString, TempResult : IPyObject;
begin
  TempArgs := TPyObject.Wrap(args, False);

  if TPyTuple.Check(TempArgs) then
    begin
      TempString := TPyTuple.GetItem(TempArgs, 0);
      TempResult := TPyUnicode.FromString(uppercase(TempString.AsString));
      Result     := TempResult.UnWrap;
    end
   else
    Result := TPyNone.ReturnNone;
end;

{ TExtensionPyModuleDef }
                                          
// This procedure adds our custom functions for older Python versions.
// Python will use the extmod_is_even and extmod_uppercase callbacks when it
// needs to call the "is_even" and "uppercase" functions in our extension.
procedure TExtensionPyModuleDef.AddAllMethods;
begin
  AddMethod('is_even', '', @extmod_is_even, METH_VARARGS);
  AddMethod('uppercase', '', @extmod_uppercase, METH_VARARGS);
end;

{ TExtensionPySlotManager }
                                                 
// This procedure adds our custom functions for Python 3.15
// Python will use the extmod_is_even and extmod_uppercase callbacks when it
// needs to call the "is_even" and "uppercase" functions in our extension.
procedure TExtensionPySlotManager.AddAllMethods;
begin
  AddMethod('is_even', '', @extmod_is_even, METH_VARARGS);
  AddMethod('uppercase', '', @extmod_uppercase, METH_VARARGS);
end;

end.

