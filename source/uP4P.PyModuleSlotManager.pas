unit uP4P.PyModuleSlotManager;

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
  uP4P.Types, uP4P.Constants, uP4P.Interfaces;

type
  /// <summary>
  /// <para>TPyCustomModuleSlotManager is used to store the information about
  /// the module and to manage the method and slot lists.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/extension-modules.html#multi-phase-initialization">See the article about Multi-phase initialization.</see></para>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#c.PyMethodDef">See the article about PyMethodDef.</see></para>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#implementing-functions-and-methods">See the article about Implementing functions and methods.</see></para>
  /// </remarks>
  TPyModuleSlotManager = class(TInterfacedObject, IPyModuleSlotManager)
    protected
      FName                  : AnsiString;
      FDocStrings            : AnsiString;
      FSlotList              : TList;
      FSlots                 : PySlotArray;
      FMethodList            : TList;
      FMethods               : PyMethodDefArray;
      FToken                 : pointer;
      FABIInfo               : PyAbiInfo;
      FCreateModuleFunction  : create_modulefunc;
      FExecFunction          : exec_modulefunc;
      FMultIntprSupport      : TMultIntprSupport;
      FGILUsed               : boolean;
      FStateSize             : integer;
      FStateTraverse         : traverseproc;
      FStateClear            : inquiry;
      FStateFree             : inquiry;

      function  GetName: AnsiString;
      function  GetDocStrings: AnsiString;
      function  GetToken: pointer;
      function  GetHasSentinelSlot: boolean;
      function  GetHasSentinelMethod: boolean;
      function  GetSlots: PPySlot;
      function  GetCreateModuleFunction: create_modulefunc;
      function  GetExecFunction: exec_modulefunc;
      function  GetMultIntprSupport: TMultIntprSupport;
      function  GetGILUsed: boolean;
      function  GetABIInfo: PPyAbiInfo;
      function  GetStateSize: integer;
      function  GetStateTraverse: traverseproc;
      function  GetStateClear: inquiry;
      function  GetStateFree: inquiry;

      procedure SetName(const aValue: AnsiString);
      procedure SetDocStrings(const aValue: AnsiString);
      procedure SetToken(aValue: pointer);
      procedure SetCreateModuleFunction(aValue: create_modulefunc);
      procedure SetExecFunction(aValue: exec_modulefunc);
      procedure SetMultIntprSupport(aValue: TMultIntprSupport);
      procedure SetGILUsed(aValue: boolean);
      procedure SetStateSize(aValue: integer);
      procedure setStateTraverse(aValue: traverseproc);
      procedure SetStateClear(aValue: inquiry);
      procedure SetStateFree(aValue: inquiry);

      procedure DestroySlotList;
      procedure DestroySlots;
      procedure DestroyMethodList;
      procedure DestroyMethods;

      procedure CreateSlotArray;
      procedure CreateMethodArray;

      /// <summary>
      /// Add a method.
      /// </summary>
      function  AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
      /// <summary>
      /// Add a sentinel method slot.
      /// </summary>
      function  AddSentinelMethod: boolean;
      /// <summary>
      /// Add a sentinel slot.
      /// </summary>
      function  AddSentinelSlot: boolean;
      /// <summary>
      /// Adds a Py_mod_name slot.
      /// </summary>
      function  AddNameSlot: boolean;
      /// <summary>
      /// Adds a Py_mod_doc slot.
      /// </summary>
      function  AddDocStringsSlot: boolean;
      /// <summary>
      /// Adds a Py_mod_token slot.
      /// </summary>
      function  AddTokenSlot: boolean;
      /// <summary>
      /// Adds a Py_mod_methods slot.
      /// </summary>
      function  AddMethodsSlot: boolean;
      /// <summary>
      /// Adds a Py_mod_create slot.
      /// </summary>
      function  AddCreateSlot: boolean;
      /// <summary>
      /// Adds a Py_mod_exec slot.
      /// </summary>
      function  AddExecSlot: boolean;
      /// <summary>
      /// Adds a Py_mod_multiple_interpreters slot.
      /// </summary>
      function  AddMultipleInterpretersSlot: boolean;
      /// <summary>
      /// Adds a Py_mod_gil slot.
      /// </summary>
      function  AddGILSlot: boolean;
      /// <summary>
      /// Adds a Py_mod_abi slot.
      /// </summary>
      function  AddABIInfoSlot: boolean;
      /// <summary>
      /// Adds a Py_mod_state_size slot.
      /// </summary>
      function  AddStateSizeSlot: boolean;
      /// <summary>
      /// Adds a Py_mod_state_traverse slot.
      /// </summary>
      function  AddStateTraverseSlot: boolean;
      /// <summary>
      /// Adds a Py_mod_state_clear slot.
      /// </summary>
      function  AddStateClearSlot: boolean;
      /// <summary>
      /// Adds a Py_mod_state_free slot.
      /// </summary>
      function  AddStateFreeSlot: boolean;

      /// <summary>
      /// Override this procedure to add your custom slots.
      /// </summary>
      procedure AddAllSlots; virtual;
      /// <summary>
      /// Override this procedure to add your custom methods.
      /// </summary>
      procedure AddAllMethods; virtual;

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      /// <summary>
      /// Create the slots with the methods and all the module information.
      /// </summary>
      procedure   Initialize; virtual;

      /// <summary>
      /// Name of the new module or data type.
      /// </summary>
      property  Name_                  : AnsiString                   read GetName                 write SetName;
      /// <summary>
      /// The docstring of the new module or data type.
      /// </summary>
      property  DocStrings             : AnsiString                   read GetDocStrings           write SetDocStrings;
      /// <summary>
      /// Return True if the last slot has a Py_slot_end value in the
      /// sl_id field.
      /// </summary>
      property  HasSentinelSlot        : boolean                      read GetHasSentinelSlot;
      /// <summary>
      /// Return True if the last method in the list is a sentinel method.
      /// </summary>
      property  HasSentinelMethod      : boolean                      read GetHasSentinelMethod;
      /// <summary>
      /// Return a pointer to the first slot.
      /// </summary>
      property  Slots                  : PPySlot                      read GetSlots;
      /// <summary>
      /// The associated token is a pointer-sized value intended to identify
      /// this object.
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#ext-module-token">See the article about Module token.</see></para>
      /// <para>Added in version 3.15.</para>
      /// </remarks>
      property  Token                  : pointer                      read GetToken                write SetToken;
      /// <summary>
      /// Return a pointer to the ABI info record.
      /// </summary>
      property  ABIInfo                : PPyAbiInfo                   read GetABIInfo;
      /// <summary>
      /// <para>Specifies a function that is called to create the module object
      /// itself.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_create">See the article about Py_mod_create.</see></para>
      /// </remarks>
      property  CreateModuleFunction   : create_modulefunc            read GetCreateModuleFunction write SetCreateModuleFunction;
      /// <summary>
      /// <para>Specifies a function that is called to execute the module. This is
      /// equivalent to executing the code of a Python module: typically, this
      /// function adds classes and constants to the module.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_exec">See the article about Py_mod_exec.</see></para>
      /// </remarks>
      property  ExecFunction           : exec_modulefunc              read GetExecFunction         write SetExecFunction;
      /// <summary>
      /// This slot determines whether or not importing this module in a
      /// subinterpreter will fail.
      /// If it's not specified, the import machinery defaults to miSupported.
      /// </summary>
      property  MultIntprSupport       : TMultIntprSupport            read GetMultIntprSupport     write SetMultIntprSupport;
      /// <summary>
      /// The module depends on the presence of the global interpreter lock
      /// (GIL) or it's safe to run without an active GIL.
      /// </summary>
      property  GILUsed                : boolean                      read GetGILUsed              write SetGILUsed;
      /// <summary>
      /// Size of the module state, in bytes.
      /// </summary>
      property  StateSize              : integer                      read GetStateSize            write SetStateSize;
      /// <summary>
      /// Traversal function to call during GC traversal of the module object.
      /// </summary>
      property  StateTraverse          : traverseproc                 read GetStateTraverse        write SetStateTraverse;
      /// <summary>
      /// Clear function to call during GC clearing of the module object.
      /// </summary>
      property  StateClear             : inquiry                      read GetStateClear           write SetStateClear;
      /// <summary>
      /// Function to call during deallocation of the module object.
      /// </summary>
      property  StateFree              : inquiry                      read GetStateFree            write SetStateFree;
  end;

implementation

uses
  uP4P.PyMethodDef, uP4P.Py_mod, uP4P.PyABIInfo, uP4P.PySlot;

constructor TPyModuleSlotManager.Create;
begin
  inherited Create;

  FName                  := '';
  FDocStrings            := '';
  FSlotList              := nil;
  FSlots                 := nil;
  FMethodList            := nil;
  FMethods               := nil;
  FToken                 := nil;
  FExecFunction          := nil;
  FCreateModuleFunction  := nil;
  FMultIntprSupport      := piUnknown;
  FGILUsed               := {$IFDEF PY_GIL_DISABLED}False{$ELSE}True{$ENDIF};
  FStateSize             := low(integer);
  FStateTraverse         := nil;
  FStateClear            := nil;
  FStateFree             := nil;

  TPyABIInfo.VAR_(FABIInfo);
end;

destructor TPyModuleSlotManager.Destroy;
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

procedure TPyModuleSlotManager.AfterConstruction;
begin
  inherited AfterConstruction;

  FSlotList   := TList.Create;
  FMethodList := TList.Create;
end;

procedure TPyModuleSlotManager.DestroySlotList;
var
  i : integer;
begin
  if assigned(FSlotList) then
    try
      i := pred(FSlotList.Count);
      while (i >= 0) do
        begin
          TPySlot(FSlotList[i]).Free;
          FSlotList[i] := nil;
          dec(i);
        end;
    finally
      FreeAndNil(FSlotList);
    end;
end;

procedure TPyModuleSlotManager.DestroySlots;
begin
  if assigned(FSlots) then
    begin
      SetLength(FSlots, 0);
      FSlots := nil;
    end;
end;

procedure TPyModuleSlotManager.DestroyMethodList;
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

procedure TPyModuleSlotManager.DestroyMethods;
begin
  if assigned(FMethods) then
    begin
      SetLength(FMethods, 0);
      FMethods := nil;
    end;
end;

procedure TPyModuleSlotManager.CreateSlotArray;
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
          FSlots[i] := TPySlot(FSlotList[i]).Slot;
          inc(i);
        end;
    end;
end;

procedure TPyModuleSlotManager.CreateMethodArray;
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

function TPyModuleSlotManager.GetName: AnsiString;
begin
  Result := FName;
end;

function TPyModuleSlotManager.GetDocStrings: AnsiString;
begin
  Result := FDocStrings;
end;

function TPyModuleSlotManager.GetToken: pointer;
begin
  Result := FToken;
end;

function TPyModuleSlotManager.GetHasSentinelSlot: boolean;
begin
  Result := assigned(FSlotList) and
            (FSlotList.Count > 0) and
            TPySlot(FSlotList[FSlotList.Count - 1]).IsEnd;
end;

function TPyModuleSlotManager.GetHasSentinelMethod: boolean;
begin
  Result := assigned(FMethodList) and
            (FMethodList.Count > 0) and
            TPyMethodDef(FMethodList[FMethodList.Count - 1]).IsSentinel;
end;

function TPyModuleSlotManager.GetSlots: PPySlot;
begin
  if (Length(FSlots) > 0) then
    Result := @FSlots[0]
   else
    Result := nil;
end;

function TPyModuleSlotManager.GetCreateModuleFunction: create_modulefunc;
begin
  Result := FCreateModuleFunction;
end;

function TPyModuleSlotManager.GetExecFunction: exec_modulefunc;
begin
  Result := FExecFunction;
end;

function TPyModuleSlotManager.GetMultIntprSupport: TMultIntprSupport;
begin
  Result := FMultIntprSupport;
end;

function TPyModuleSlotManager.GetGILUsed: boolean;
begin
  Result := FGILUsed;
end;

function TPyModuleSlotManager.GetABIInfo: PPyAbiInfo;
begin
  Result := @FABIInfo;
end;

function TPyModuleSlotManager.GetStateSize: integer;
begin
  Result := FStateSize;
end;

function TPyModuleSlotManager.GetStateTraverse: traverseproc;
begin
  Result := FStateTraverse;
end;

function TPyModuleSlotManager.GetStateClear: inquiry;
begin
  Result := FStateClear;
end;

function TPyModuleSlotManager.GetStateFree: inquiry;
begin
  Result := FStateFree;
end;

procedure TPyModuleSlotManager.SetName(const aValue: AnsiString);
begin
  FName := aValue;
end;

procedure TPyModuleSlotManager.SetDocStrings(const aValue: AnsiString);
begin
  FDocStrings := aValue;
end;

procedure TPyModuleSlotManager.SetToken(aValue: pointer);
begin
  FToken := aValue;
end;

procedure TPyModuleSlotManager.SetCreateModuleFunction(aValue: create_modulefunc);
begin
  FCreateModuleFunction := aValue;
end;

procedure TPyModuleSlotManager.SetExecFunction(aValue: exec_modulefunc);
begin
  FExecFunction := aValue;
end;

procedure TPyModuleSlotManager.SetMultIntprSupport(aValue: TMultIntprSupport);
begin
  FMultIntprSupport := aValue;
end;

procedure TPyModuleSlotManager.SetGILUsed(aValue: boolean);
begin
  FGILUsed := aValue;
end;

procedure TPyModuleSlotManager.SetStateSize(aValue: integer);
begin
  FStateSize := aValue;
end;

procedure TPyModuleSlotManager.SetStateTraverse(aValue: traverseproc);
begin
  FStateTraverse := aValue;
end;

procedure TPyModuleSlotManager.SetStateClear(aValue: inquiry);
begin
  FStateClear := aValue;
end;

procedure TPyModuleSlotManager.SetStateFree(aValue: inquiry);
begin
  FStateFree := aValue;
end;

function TPyModuleSlotManager.AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
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

function TPyModuleSlotManager.AddSentinelMethod: boolean;
begin
  Result := AddMethod('', '', nil, 0);
end;

function TPyModuleSlotManager.AddSentinelSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_END;

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyModuleSlotManager.AddNameSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and (length(FName) > 0) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_STATIC_STRING(TPy_mod.name, FName);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyModuleSlotManager.AddDocStringsSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and (length(FDocStrings) > 0) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_STRING(TPy_mod.doc, FDocStrings);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyModuleSlotManager.AddABIInfoSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_DATA(TPy_mod.abi, ABIInfo);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyModuleSlotManager.AddStateSizeSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and (FStateSize <> low(integer)) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_SIZE(TPy_mod.state_size, FStateSize);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyModuleSlotManager.AddStateTraverseSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and assigned(FStateTraverse) then
    begin
      TempSlot := TPySlot.Create;
      {$IFDEF FPC}
      TempSlot.Set_FUNC(TPy_mod.state_traverse, _Py_funcptr_t(FStateTraverse));
      {$ELSE}
      TempSlot.Set_FUNC(TPy_mod.state_traverse, @FStateTraverse);
      {$ENDIF}

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyModuleSlotManager.AddStateClearSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and assigned(FStateClear) then
    begin
      TempSlot := TPySlot.Create;
      {$IFDEF FPC}
      TempSlot.Set_FUNC(TPy_mod.state_clear, _Py_funcptr_t(FStateClear));
      {$ELSE}
      TempSlot.Set_FUNC(TPy_mod.state_clear, @FStateClear);
      {$ENDIF}

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyModuleSlotManager.AddStateFreeSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and assigned(FStateFree) then
    begin
      TempSlot := TPySlot.Create;
      {$IFDEF FPC}
      TempSlot.Set_FUNC(TPy_mod.state_free, _Py_funcptr_t(FStateFree));
      {$ELSE}
      TempSlot.Set_FUNC(TPy_mod.state_free, @FStateFree);
      {$ENDIF}

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyModuleSlotManager.AddCreateSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and assigned(FCreateModuleFunction) then
    begin
      TempSlot := TPySlot.Create;
      {$IFDEF FPC}
      TempSlot.Set_FUNC(TPy_mod.create, _Py_funcptr_t(FCreateModuleFunction));
      {$ELSE}
      TempSlot.Set_FUNC(TPy_mod.create, @FCreateModuleFunction);
      {$ENDIF}

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyModuleSlotManager.AddExecSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and assigned(FExecFunction) then
    begin
      TempSlot := TPySlot.Create;
      {$IFDEF FPC}
      TempSlot.Set_FUNC(TPy_mod.exec, _Py_funcptr_t(FExecFunction));
      {$ELSE}
      TempSlot.Set_FUNC(TPy_mod.exec, @FExecFunction);
      {$ENDIF}

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyModuleSlotManager.AddMultipleInterpretersSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and (FMultIntprSupport <> piUnknown) then
    begin
      TempSlot := TPySlot.Create;

      case FMultIntprSupport of
        miUnsupported  : TempSlot.Set_DATA(TPy_mod.multiple_interpreters, Py_MOD_MULTIPLE_INTERPRETERS_NOT_SUPPORTED);
        piGilSupported : TempSlot.Set_DATA(TPy_mod.multiple_interpreters, Py_MOD_PER_INTERPRETER_GIL_SUPPORTED);
        miSupported    : TempSlot.Set_DATA(TPy_mod.multiple_interpreters, Py_MOD_MULTIPLE_INTERPRETERS_SUPPORTED);
      end;

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyModuleSlotManager.AddGILSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) then
    begin
      TempSlot := TPySlot.Create;

      if FGILUsed then
        TempSlot.Set_DATA(TPy_mod.gil, Py_MOD_GIL_USED)
       else
        TempSlot.Set_DATA(TPy_mod.gil, Py_MOD_GIL_NOT_USED);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyModuleSlotManager.AddTokenSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and assigned(FToken) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_DATA(TPy_mod.token, FToken);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

function TPyModuleSlotManager.AddMethodsSlot: boolean;
var
  TempSlot : TPySlot;
begin
  Result := False;

  if assigned(FSlotList) and assigned(FMethods) and (length(FMethods) > 0) then
    begin
      TempSlot := TPySlot.Create;
      TempSlot.Set_STATIC_DATA(TPy_mod.methods, @FMethods[0]);

      if (FSlotList.Add(TempSlot) >= 0) then
        Result := True
       else
        TempSlot.Free;
    end;
end;

procedure TPyModuleSlotManager.AddAllSlots;
begin
  AddNameSlot;
  AddDocStringsSlot;
  AddABIInfoSlot;
  AddCreateSlot;
  AddExecSlot;
  AddMultipleInterpretersSlot;
  AddGILSlot;
  AddTokenSlot;
  AddStateSizeSlot;
  AddStateTraverseSlot;
  AddStateClearSlot;
  AddStateFreeSlot;
end;

procedure TPyModuleSlotManager.AddAllMethods;
begin
  //
end;

procedure TPyModuleSlotManager.Initialize;
begin
  AddAllSlots;
  AddAllMethods;

  if not(HasSentinelMethod) then
    AddSentinelMethod;

  CreateMethodArray;
  AddMethodsSlot;

  if not(HasSentinelSlot) then
    AddSentinelSlot;

  CreateSlotArray;
end;

end.
