unit uP4P.PyModuleDef;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces;

type
  /// <summary>
  /// <para>TPyModuleDef is used to store the information about modules and
  /// it's also a helper class for all PyModuleDef_* methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/extension-modules.html#multi-phase-initialization">See the article about Multi-phase initialization.</see></para>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#c.PyMethodDef">See the article about PyMethodDef.</see></para>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#implementing-functions-and-methods">See the article about Implementing functions and methods.</see></para>
  /// </remarks>
  TPyModuleDef = class(TInterfacedObject, IPyModuleDef)
    protected
      FModuleDef             : PyModuleDef;
      FName                  : AnsiString;
      FDocStrings            : AnsiString;
      FSlotList              : TList;
      FSlots                 : PyModuleDef_SlotArray;
      FMethodList            : TList;
      FMethods               : PyMethodDefArray;
      FInitialized           : boolean;
      FExecFunction          : exec_modulefunc;
      FMultIntprSupport      : TMultIntprSupport;
      FGILUsed               : boolean;
      FCreateModuleFunction  : create_modulefunc;
      FSize                  : integer;
      FTraverse              : traverseproc;
      FClear                 : inquiry;
      FFree                  : freefunc;

      procedure CreateSlotArray;
      procedure CreateMethodArray;

      procedure DestroySlotList;
      procedure DestroySlots;
      procedure DestroyMethodList;
      procedure DestroyMethods;

      function  GetInitialized: boolean;
      function  GetName: AnsiString;
      function  GetDocStrings: AnsiString;
      function  GetCreateModuleFunction: create_modulefunc;
      function  GetExecFunction: exec_modulefunc;
      function  GetMultIntprSupport: TMultIntprSupport;
      function  GetGILUsed: boolean;
      function  GetSize: integer;
      function  GetTraverse: traverseproc;
      function  GetClear: inquiry;
      function  GetFree: freefunc;
      function  GetHasSentinelSlot: boolean;
      function  GetHasSentinelMethod: boolean;
      function  GetModuleDef: PPyModuleDef;

      procedure SetName(const aValue: AnsiString);
      procedure SetDocStrings(const aValue: AnsiString);
      procedure SetCreateModuleFunction(aValue: create_modulefunc);
      procedure SetExecFunction(aValue: exec_modulefunc);
      procedure SetMultIntprSupport(aValue: TMultIntprSupport);
      procedure SetGILUsed(aValue: boolean);
      procedure SetSize(aValue: integer);
      procedure SetTraverse(aValue: traverseproc);
      procedure SetClear(aValue: inquiry);
      procedure SetFree(aValue: freefunc);

      /// <summary>
      /// Override this procedure to add your custom slots.
      /// </summary>
      procedure AddAllSlots; virtual;
      /// <summary>
      /// Override this procedure to add your custom methods.
      /// </summary>
      procedure AddAllMethods; virtual;

      /// <summary>
      /// Add a sentinel method slot.
      /// </summary>
      function  AddSentinelMethod: boolean;
      /// <summary>
      /// Add a sentinel slot.
      /// </summary>
      function  AddSentinelSlot: boolean;
      /// <summary>
      /// Add a generic method.
      /// </summary>
      function  AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
      /// <summary>
      /// Add a generic slot.
      /// </summary>
      function  AddSlot(aSlot: integer; aValue: Pointer): boolean;
      /// <summary>
      /// Add a Py_mod_create slot.
      /// </summary>
      function  AddCreateSlot: boolean;
      /// <summary>
      /// Add a Py_mod_exec slot.
      /// </summary>
      function  AddExecSlot: boolean;
      /// <summary>
      /// Add a Py_mod_multiple_interpreters slot.
      /// </summary>
      function  AddMultipleInterpretersSlot: boolean;
      /// <summary>
      /// Add a Py_mod_gil slot.
      /// </summary>
      function  AddGILSlot: boolean;
      /// <summary>
      /// Create the methods and the slots with all the module information.
      /// </summary>
      procedure BuildMethodsAndSlots; virtual;

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      /// <summary>
      /// Initialize PyModuleDef and set all module information.
      /// </summary>
      function    Initialize: boolean; virtual;
      /// <summary>
      /// <para>Ensure a module definition is a properly initialized Python
      /// object that correctly reports its type and a reference count.</para>
      /// <para>Return def cast to PPyObject, or nil if an error
      /// occurred.</para>
      /// <para>Calling this function is required for Multi-phase
      /// initialization. It should not be used in other contexts.</para>
      /// <para>Note that Python assumes that PyModuleDef structures are
      /// statically allocated. This function may return either a new reference
      /// or a borrowed one; this reference must not be released.</para>
      /// </summary>
      class function Init(const def: PyModuleDef): PPyObject;
      /// <summary>
      /// <para>Returns true if the class is fully initialized.</para>
      /// </summary>
      class function IsInitialized(const aPyModuleDef: IPyModuleDef): boolean; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}
      /// <summary>
      /// Returns true if this class is fully initialized.
      /// </summary>
      property  Initialized            : boolean            read GetInitialized;
      /// <summary>
      /// Name of the new module or data type.
      /// </summary>
      property  Name_                  : AnsiString         read GetName                 write SetName;
      /// <summary>
      /// The docstring of the new module or data type.
      /// </summary>
      property  DocStrings             : AnsiString         read GetDocStrings           write SetDocStrings;
      /// <summary>
      /// Return True if the last slot in the list is a sentinel slot.
      /// </summary>
      property  HasSentinelSlot        : boolean            read GetHasSentinelSlot;
      /// <summary>
      /// Return True if the last method in the list is a sentinel method.
      /// </summary>
      property  HasSentinelMethod      : boolean            read GetHasSentinelMethod;
      /// <summary>
      /// Return a poiter to PyModuleDef.
      /// </summary>
      property  ModuleDef              : PPyModuleDef       read GetModuleDef;
      /// <summary>
      /// <para>Specifies a function that is called to create the module object
      /// itself.</para>
      /// </summary>
      property  CreateModuleFunction   : create_modulefunc  read GetCreateModuleFunction write SetCreateModuleFunction;
      /// <summary>
      /// Function that will execute, or initialize, the module.
      /// </summary>
      property  ExecFunction           : exec_modulefunc    read GetExecFunction         write SetExecFunction;
      /// <summary>
      /// This slot determines whether or not importing this module in a
      /// subinterpreter will fail.
      /// If it's not specified, the import machinery defaults to miSupported.
      /// </summary>
      property  MultIntprSupport       : TMultIntprSupport  read GetMultIntprSupport     write SetMultIntprSupport;
      /// <summary>
      /// The module depends on the presence of the global interpreter lock
      /// (GIL) or it's safe to run without an active GIL.
      /// </summary>
      property  GILUsed                : boolean            read GetGILUsed              write SetGILUsed;
      /// <summary>
      /// Module state size. This value will be used in PyModuleDef.m_size.
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/module.html#c.PyModuleDef">See the article about PyModuleDef.</see></para>
      /// </remarks>
      property  Size_                  : integer            read GetSize                 write SetSize;
      /// <summary>
      /// <para>A traversal function to call during GC traversal of the module
      /// object, or nil if not needed.</para>
      /// <para>This value will be used in PyModuleDef.m_traverse.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/module.html#c.PyModuleDef">See the article about PyModuleDef.</see></para>
      /// </remarks>
      property  Traverse               : traverseproc       read GetTraverse             write SetTraverse;
      /// <summary>
      /// <para>A clear function to call during GC clearing of the module object,
      /// or nil if not needed.</para>
      /// <para>This value will be used in PyModuleDef.m_clear.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/module.html#c.PyModuleDef">See the article about PyModuleDef.</see></para>
      /// </remarks>
      property  Clear_                 : inquiry            read GetClear                write SetClear;
      /// <summary>
      /// <para>A function to call during deallocation of the module object,
      /// or nil if not needed.</para>
      /// <para>This value will be used in PyModuleDef.m_free.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/module.html#c.PyModuleDef">See the article about PyModuleDef.</see></para>
      /// </remarks>
      property  Free_                  : freefunc           read GetFree                 write SetFree;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyModuleDef_Slot, uP4P.PyMethodDef, uP4P.Py_mod,
  uP4P.Engine;

constructor TPyModuleDef.Create;
begin
  inherited Create;

  FName                  := '';
  FDocStrings            := '';
  FCreateModuleFunction  := nil;
  FExecFunction          := nil;
  FMultIntprSupport      := piUnknown;
  FGILUsed               := {$IFDEF PY_GIL_DISABLED}False{$ELSE}True{$ENDIF};
  FSlotList              := nil;
  FSlots                 := nil;
  FMethodList            := nil;
  FMethods               := nil;
  FInitialized           := False;
  FSize                  := low(integer);
  FTraverse              := nil;
  FClear                 := nil;
  FFree                  := nil;
end;

destructor TPyModuleDef.Destroy;
begin
  try
    DestroySlotList;
    DestroySlots;
    DestroyMethodList;
    DestroyMethods;
  finally
    inherited Destroy;
  end;
end;

procedure TPyModuleDef.AfterConstruction;
begin
  inherited AfterConstruction;

  FSlotList   := TList.Create;
  FMethodList := TList.Create;
end;

procedure TPyModuleDef.BuildMethodsAndSlots;
begin
  AddAllSlots;
  AddAllMethods;

  if not(HasSentinelSlot) then
    AddSentinelSlot;

  if not(HasSentinelMethod) then
    AddSentinelMethod;

  CreateSlotArray;
  CreateMethodArray;

  FModuleDef.m_slots   := @FSlots[0];
  FModuleDef.m_methods := @FMethods[0];

  if (length(FName) > 0)       then FModuleDef.m_name     := PAnsiChar(FName);
  if (length(FDocStrings) > 0) then FModuleDef.m_doc      := PAnsiChar(FDocStrings);
  if (FSize <> low(integer))   then FModuleDef.m_size     := FSize;
  if assigned(FTraverse)       then FModuleDef.m_traverse := FTraverse;
  if assigned(FClear)          then FModuleDef.m_clear    := FClear;
  if assigned(FFree)           then FModuleDef.m_free     := FFree;
end;

procedure TPyModuleDef.AddAllSlots;
begin
  AddCreateSlot;
  AddExecSlot;
  AddMultipleInterpretersSlot;
  AddGILSlot;
end;

procedure TPyModuleDef.AddAllMethods;
begin
  //
end;

function TPyModuleDef.AddSentinelMethod: boolean;
begin
  Result := AddMethod('', '', nil, 0);
end;

function TPyModuleDef.AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
var
  TempMethod : TPyMethodDef;
begin
  Result := False;

  if assigned(FMethodList) then
    begin
      TempMethod := TPyMethodDef.Create(aName, aDocStrings, aMethod, aFlags);

      if (FMethodList.Add(TempMethod) >= 0) then
        Result := True
       else
        TempMethod.Free;
    end;
end;

function TPyModuleDef.AddSentinelSlot: boolean;
begin
  Result := AddSlot(0, nil);
end;

function TPyModuleDef.AddSlot(aSlot: integer; aValue: Pointer): boolean;
var
  TempSlot : TPyModuleDef_Slot;
begin
  Result := False;

  if assigned(FSlotList) then
    begin
      TempSlot := TPyModuleDef_Slot.Create(aSlot, aValue);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyModuleDef.AddCreateSlot: boolean;
begin
  Result := False;

  if assigned(FCreateModuleFunction) then
    begin
      {$IFDEF FPC}
      Result := AddSlot(TPy_mod.create, Pointer(FCreateModuleFunction));
      {$ELSE}
      Result := AddSlot(TPy_mod.create, @FCreateModuleFunction);
      {$ENDIF}
    end;
end;

function TPyModuleDef.AddExecSlot: boolean;
begin
  Result := False;

  if assigned(FExecFunction) then
    begin
      {$IFDEF FPC}
      Result := AddSlot(TPy_mod.exec, Pointer(FExecFunction));
      {$ELSE}
      Result := AddSlot(TPy_mod.exec, @FExecFunction);
      {$ENDIF}
    end;
end;

function TPyModuleDef.AddMultipleInterpretersSlot: boolean;
begin
  Result := False;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    case FMultIntprSupport of
      miUnsupported  : Result := AddSlot(TPy_mod.multiple_interpreters, Py_MOD_MULTIPLE_INTERPRETERS_NOT_SUPPORTED);
      piGilSupported : Result := AddSlot(TPy_mod.multiple_interpreters, Py_MOD_PER_INTERPRETER_GIL_SUPPORTED);
      miSupported    : Result := AddSlot(TPy_mod.multiple_interpreters, Py_MOD_MULTIPLE_INTERPRETERS_SUPPORTED);
    end;
end;

function TPyModuleDef.AddGILSlot: boolean;
begin
  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.PythonLibIsGreaterOrEqualThan(3, 13, 0) then
    begin
      if FGILUsed then
        Result := AddSlot(TPy_mod.gil, Py_MOD_GIL_USED)
       else
        Result := AddSlot(TPy_mod.gil, Py_MOD_GIL_NOT_USED);
    end
   else
    Result := False;
end;

function TPyModuleDef.Initialize: boolean;
begin
  Result := False;

  try
    FillChar(FModuleDef, SizeOf(FModuleDef), 0);

    if assigned(Init(FModuleDef)) then
      begin
        BuildMethodsAndSlots;

        FInitialized := True;
        Result       := True;
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TPyModuleDef.Initialize', e) then raise;
  end;
end;

procedure TPyModuleDef.CreateSlotArray;
var
  i : integer;
begin
  DestroySlots;

  if assigned(FSlotList) and (FSlotList.Count > 0) then
    begin
      SetLength(FSlots, FSlotList.Count);

      i := 0;
      while (i < FSlotList.Count) do
        begin
          FSlots[i] := TPyModuleDef_Slot(FSlotList[i]).Slot;
          inc(i);
        end;
    end;
end;

procedure TPyModuleDef.CreateMethodArray;
var
  i : integer;
begin
  DestroyMethods;

  if assigned(FMethodList) and (FMethodList.Count > 0) then
    begin
      SetLength(FMethods, FMethodList.Count);

      i := 0;
      while (i < FMethodList.Count) do
        begin
          FMethods[i] := TPyMethodDef(FMethodList[i]).Method;
          inc(i);
        end;
    end;
end;

procedure TPyModuleDef.DestroySlotList;
var
  i : integer;
begin
  if assigned(FSlotList) then
    try
      i := pred(FSlotList.Count);
      while (i >= 0) do
        begin
          TPyModuleDef_Slot(FSlotList[i]).Free;
          FSlotList[i] := nil;
          dec(i);
        end;
    finally
      FreeAndNil(FSlotList);
    end;
end;

procedure TPyModuleDef.DestroySlots;
begin
  if assigned(FSlots) then
    begin
      SetLength(FSlots, 0);
      FSlots := nil;
    end;
end;

procedure TPyModuleDef.DestroyMethodList;
var
  i : integer;
begin
  if assigned(FMethodList) then
    try
      i := pred(FMethodList.Count);
      while (i >= 0) do
        begin
          TPyMethodDef(FMethodList[i]).Free;
          FMethodList[i] := nil;
          dec(i);
        end;
    finally
      FreeAndNil(FMethodList);
    end;
end;

procedure TPyModuleDef.DestroyMethods;
begin
  if assigned(FMethods) then
    begin
      SetLength(FMethods, 0);
      FMethods := nil;
    end;
end;

function TPyModuleDef.GetInitialized: boolean;
begin
  Result := FInitialized;
end;

function TPyModuleDef.GetName: AnsiString;
begin
  Result := FName;
end;

function TPyModuleDef.GetDocStrings: AnsiString;
begin
  Result := FDocStrings;
end;

function TPyModuleDef.GetExecFunction: exec_modulefunc;
begin
  Result := FExecFunction;
end;

function TPyModuleDef.GetMultIntprSupport: TMultIntprSupport;
begin
  Result := FMultIntprSupport;
end;

function TPyModuleDef.GetGILUsed: boolean;
begin
  Result := FGILUsed;
end;

function TPyModuleDef.GetHasSentinelSlot: boolean;
begin
  Result := assigned(FSlotList) and
            (FSlotList.Count > 0) and
            TPyModuleDef_Slot(FSlotList[FSlotList.Count - 1]).IsSentinel;
end;

function TPyModuleDef.GetHasSentinelMethod: boolean;
begin
  Result := assigned(FMethodList) and
            (FMethodList.Count > 0) and
            TPyMethodDef(FMethodList[FMethodList.Count - 1]).IsSentinel;
end;

function TPyModuleDef.GetModuleDef: PPyModuleDef;
begin
  if FInitialized then
    Result := @FModuleDef
   else
    Result := nil;
end;

function TPyModuleDef.GetSize: integer;
begin
  Result := FSize;
end;

function TPyModuleDef.GetTraverse: traverseproc;
begin
  Result := FTraverse;
end;

function TPyModuleDef.GetClear: inquiry;
begin
  Result := FClear;
end;

function TPyModuleDef.GetFree: freefunc;
begin
  Result := FFree;
end;

procedure TPyModuleDef.SetName(const aValue: AnsiString);
begin
  FName := aValue;
end;

procedure TPyModuleDef.SetDocStrings(const aValue: AnsiString);
begin
  FDocStrings := aValue;
end;

function TPyModuleDef.GetCreateModuleFunction: create_modulefunc;
begin
  Result := FCreateModuleFunction;
end;

procedure TPyModuleDef.SetCreateModuleFunction(aValue: create_modulefunc);
begin
  FCreateModuleFunction := aValue;
end;

procedure TPyModuleDef.SetExecFunction(aValue: exec_modulefunc);
begin
  FExecFunction := aValue;
end;

procedure TPyModuleDef.SetMultIntprSupport(aValue: TMultIntprSupport);
begin
  FMultIntprSupport := aValue;
end;

procedure TPyModuleDef.SetGILUsed(aValue: boolean);
begin
  FGILUsed := aValue;
end;

procedure TPyModuleDef.SetSize(aValue: integer);
begin
  FSize := aValue;
end;

procedure TPyModuleDef.SetTraverse(aValue: traverseproc);
begin
  FTraverse := aValue;
end;

procedure TPyModuleDef.SetClear(aValue: inquiry);
begin
  FClear := aValue;
end;

procedure TPyModuleDef.SetFree(aValue: freefunc);
begin
  FFree := aValue;
end;


class function TPyModuleDef.Init(const def: PyModuleDef): PPyObject;
begin
  if assigned(PyModuleDef_Init) then
    Result := PyModuleDef_Init(@def)
   else
    Result := nil;
end;

class function TPyModuleDef.IsInitialized(const aPyModuleDef: IPyModuleDef): boolean;
begin
  Result := (aPyModuleDef <> nil) and aPyModuleDef.Initialized;
end;

end.
