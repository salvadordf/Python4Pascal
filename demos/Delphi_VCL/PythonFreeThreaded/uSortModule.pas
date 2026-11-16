unit uSortModule;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.CustomPyModule, uP4P.PyNone, uP4P.PyModuleDef, uP4P.PyModuleSlotManager,
  uInterfaces;

type
  // TCustomPyModule has all the logic to create modules and we only have to
  // override some procedures where we'll create the classes that declare our
  // custom functions: read, write, is_even.
  //
  // In older Python version we would need to create a custom TPyModuleDef class
  // but in Python 3.15 we need to create a custom TPyModuleSlotManager class.
  TSortModule = class(TCustomPyModule)
    protected
      FMainForm : IMainForm;
      FIdx      : integer;

      procedure CreateModuleDef; override;
      procedure CreateSlotManager; override;
      function  GetValue(args: PPyObject): PPyObject;
      function  Swap(args: PPyObject): PPyObject;

    public
      procedure AfterConstruction; override;
      procedure BeforeDestruction; override;

      property Idx      : integer    read FIdx        write FIdx;
      property MainForm : IMainForm  read FMainForm   write FMainForm;
  end;

  // This class will add our custom functions in older Python versions
  TPySortModuleDef = class(TPyModuleDef)
    protected
      procedure AddAllMethods; override;
  end;

  // This class will add our custom function in Python 3.15
  TPySortSlotManager = class(TPyModuleSlotManager)
    protected
      procedure AddAllMethods; override;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.Engine, uP4P.PyTuple, uP4P.PyUnicode, uP4P.PyBytes,
  uP4P.PyRun, uP4P.PyBool, uP4P.PyLong;

// This is the callback for the "getvalue" function.
// It finds the module instance using GlobalP4PEngine.SearchModule and calls
// TSortModule.GetValue
function sortmodule_getvalue(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule: TCustomPyModule;
begin
  TempModule := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchModule(self, TempModule) and
     (TempModule is TSortModule) then
    Result := TSortModule(TempModule).GetValue(args)
   else
    Result := TPyNone.ReturnNone;
end;

// This is the callback for the "swap" function.
// It finds the module instance using GlobalP4PEngine.SearchModule and calls
// TSortModule.Swap
function sortmodule_swap(self, args: PPyObject): PPyObject; cdecl;
var
  TempModule: TCustomPyModule;
begin
  TempModule := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchModule(self, TempModule) and
     (TempModule is TSortModule) then
    Result := TSortModule(TempModule).Swap(args)
   else
    Result := TPyNone.ReturnNone;
end;

{ TSortModule }

procedure TSortModule.AfterConstruction;
begin
  inherited AfterConstruction;
  FMainForm := nil;
end;

procedure TSortModule.BeforeDestruction;
begin
  FMainForm := nil;
  inherited BeforeDestruction;
end;

procedure TSortModule.CreateModuleDef;
begin
  FModuleDef := TPySortModuleDef.Create;
end;

procedure TSortModule.CreateSlotManager;
begin
  FSlotManager := TPySortSlotManager.Create;
end;

function TSortModule.GetValue(args: PPyObject): PPyObject;
var
  TempArgs, TempValue, TempResult : IPyObject;
begin
  TempArgs := TPyObject.Wrap(args, False);

  if assigned(FMainForm) and TPyTuple.Check(TempArgs) then
    try
      TempValue  := TPyTuple.GetItem(TempArgs, 0);
      TempResult := TPyLong.FromLong(FMainForm.GetValue(FIdx, TempValue.AsInteger));
      Result     := TempResult.UnWrap;
    finally
      TempValue  := nil;
      TempResult := nil;
      TempArgs   := nil;
    end
   else
    Result := TPyNone.ReturnNone;
end;

function TSortModule.Swap(args: PPyObject): PPyObject;
var
  TempArgs, TempI, TempJ : IPyObject;
begin
  TempArgs := TPyObject.Wrap(args, False);

  if assigned(FMainForm) and TPyTuple.Check(TempArgs) then
    try
      TempI := TPyTuple.GetItem(TempArgs, 0);
      TempJ := TPyTuple.GetItem(TempArgs, 1);

      if FMainForm.Swap(FIdx, TempI.AsInteger, TempJ.AsInteger) then
        Result := TPyBool.ReturnTrue
       else
        Result := TPyBool.ReturnFalse;
    finally
      TempI    := nil;
      TempJ    := nil;
      TempArgs := nil;
    end
   else
    Result := TPyNone.ReturnNone;
end;

{ TPySortModuleDef }

// This procedure adds our custom functions for older Python versions.
procedure TPySortModuleDef.AddAllMethods;
begin
  inherited AddAllMethods;

  AddMethod('getvalue', '', @sortmodule_getvalue, METH_VARARGS);
  AddMethod('swap',     '', @sortmodule_swap,     METH_VARARGS);
end;

{ TPySortSlotManager }

// This procedure adds our custom functions for Python 3.15
procedure TPySortSlotManager.AddAllMethods;
begin
  inherited AddAllMethods;

  AddMethod('getvalue', '', @sortmodule_getvalue, METH_VARARGS);
  AddMethod('swap',     '', @sortmodule_swap,     METH_VARARGS);
end;

end.
