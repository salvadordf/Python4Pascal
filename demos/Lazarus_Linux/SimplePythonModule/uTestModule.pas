unit uTestModule;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I ..\..\..\source\p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, Vcl.Forms,
  {$ELSE}
    Classes, Forms,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.CustomPyModule, uP4P.PyNone, uP4P.PyModuleDef, uP4P.PyModuleSlotManager;

const
  TEST_MODULE_NAME = 'mytest';

type                        
  // TCustomPyModule has all the logic to create modules and we only have to
  // override some procedures where we'll create the classes that declare our
  // custom functions: read, write, is_even.
  //
  // In older Python version we would need to create a custom TPyModuleDef class
  // but in Python 3.15 we need to create a custom TPyModuleSlotManager class.
  TTestModule = class(TCustomPyModule)
    protected
      FMainForm : TForm;

      procedure CreateModuleDef; override;
      procedure CreateSlotManager; override;
      function  Write(args: PPyObject): PPyObject;
      function  Read(args: PPyObject): PPyObject;
      function  NumberIsEven(args: PPyObject): PPyObject;

    public
      property MainForm : TForm  read FMainForm  write FMainForm;
  end;
                                            
  // This class will add our custom functions in older Python versions
  TPyTestModuleDef = class(TPyModuleDef)
    protected
      procedure AddAllMethods; override;
  end;
                                          
  // This class will add our custom functions in Python 3.15
  TPyTestSlotManager = class(TPyModuleSlotManager)
    protected
      procedure AddAllMethods; override;
  end;

implementation

uses
  uMainForm,
  uP4P.MiscFunctions, uP4P.Engine, uP4P.PyTuple, uP4P.PyUnicode, uP4P.PyBytes,
  uP4P.PyRun, uP4P.PyBool;      

// This is the callback for the "is_even" function.
// It finds the module instance using GlobalP4PEngine.SearchModule and calls
// TExtensionModule.NumberIsEven
function mytest_is_even(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule: TCustomPyModule;
begin
  TempModule := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchModule(self, TempModule) and
     (TempModule is TTestModule) then
    Result := TTestModule(TempModule).NumberIsEven(args)
   else
    Result := TPyNone.ReturnNone;
end;

// This is the callback for the "write" function.
// It finds the module instance using GlobalP4PEngine.SearchModule and calls
// TExtensionModule.Write
function mytest_write(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule: TCustomPyModule;
begin
  TempModule := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchModule(self, TempModule) and
     (TempModule is TTestModule) then
    Result := TTestModule(TempModule).Write(args)
   else
    Result := TPyNone.ReturnNone;
end;
                           
// This is the callback for the "read" function.
// It finds the module instance using GlobalP4PEngine.SearchModule and calls
// TExtensionModule.Read
function mytest_read(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule: TCustomPyModule;
begin
  TempModule := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchModule(self, TempModule) and
     (TempModule is TTestModule) then
    Result := TTestModule(TempModule).Read(args)
   else
    Result := TPyNone.ReturnNone;
end;

{ TTestModule }

procedure TTestModule.CreateModuleDef;
begin
  FModuleDef := TPyTestModuleDef.Create;
end;

procedure TTestModule.CreateSlotManager;
begin
  FSlotManager := TPyTestSlotManager.Create;
end;

function TTestModule.Write(args: PPyObject): PPyObject;
var
  TempArgs, TempItem : IPyObject;
begin
  TempArgs := TPyObject.Wrap(args, False);

  if TPyTuple.Check(TempArgs) and assigned(FMainForm) then
    begin
      TempItem := TPyTuple.GetItem(TempArgs, 0);
      TMainForm(FMainForm).CustomValue := TempItem.AsString;
    end;

  Result := TPyNone.ReturnNone;
end;

function TTestModule.Read(args: PPyObject): PPyObject;
var
  TempResult : IPyObject;
begin
  if assigned(FMainForm) then
    begin
      TempResult := TPyUnicode.FromString(TMainForm(FMainForm).CustomValue);
      Result     := TempResult.UnWrap;
    end
   else
    Result := TPyNone.ReturnNone;
end;

function TTestModule.NumberIsEven(args: PPyObject): PPyObject;
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

{ TPyTestModuleDef }
                                            
// This procedure adds our custom functions for older Python versions.
// Python will use the mytest_is_even, mytest_read and mytest_write callbacks when it
// needs to call the "is_even", "read" and "write" functions in our extension.
procedure TPyTestModuleDef.AddAllMethods;
begin
  inherited AddAllMethods;

  AddMethod('write', '', @mytest_write, METH_VARARGS);
  AddMethod('read', '', @mytest_read, METH_VARARGS);
  AddMethod('is_even', '', @mytest_is_even, METH_VARARGS);
end;

{ TPyTestSlotManager }
                                  
// This procedure adds our custom functions for Python 3.15
// Python will use the mytest_is_even, mytest_read and mytest_write callbacks when it
// needs to call the "is_even", "read" and "write" functions in our extension.
procedure TPyTestSlotManager.AddAllMethods;
begin
  inherited AddAllMethods;

  AddMethod('write', '', @mytest_write, METH_VARARGS);
  AddMethod('read', '', @mytest_read, METH_VARARGS);
  AddMethod('is_even', '', @mytest_is_even, METH_VARARGS);
end;

end.
