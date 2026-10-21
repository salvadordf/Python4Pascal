unit uP4P.Engine;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils, System.SyncObjs,
  {$ELSE}
    Classes, SysUtils, SyncObjs,
  {$ENDIF}
  uP4P.Types, uP4P.Interfaces, uP4P.PyObject, uP4P.Loader,
  uP4P.CustomPyModule, uP4P.IOPyModule, uP4P.PyTimeModule,
  uP4P.PyDateTimeModule, uP4P.CustomHeapType;

type
  TOnOutputMessageEvent = procedure(Sender: TObject; const message_: string) of object;
  TOnInputMessageEvent  = procedure(Sender: TObject; var message_: string) of object;

  /// <summary>
  /// <para>TP4PEngine extends the TP4PLoader functionality. It handles the
  /// modules used in the Python initialization and all the imported
  /// modules.</para>
  /// <para>It also exposes the events to capture the output and input, and some
  /// functions used by Python threads.</para>
  /// </summary>
  TP4PEngine = class(TP4PLoader)
    protected
      FModules                   : TList;
      FHeapTypes                 : TList;
      FSyncObj                   : TCriticalSection;
      FIOModule                  : TIOPyModule;
      FTimeModule                : TPyTimeModule;
      FDateTimeModule            : TPyDateTimeModule;
      FInterpreterState          : IPyInterpreterState;
      FThreadState               : IPyThreadState;
      FMainThreadID              : TThreadID;
      FSavedThreadState          : boolean;
      FIDGen                     : cardinal;
      FOnOutputMessage           : TOnOutputMessageEvent;
      FOnInputMessage            : TOnInputMessageEvent;

      function  GetIsMainThread: boolean;
      function  GetSavedThreadState: boolean;
      function  GetInterpreterState: IPyInterpreterState;
      function  GetMainModule: IPyObject;
      function  GetNextID: cardinal;

      procedure SetSavedThreadState(aValue: boolean);

      procedure CreateTimeModule;
      procedure CreateDateTimeModule;

      procedure DestroyIOModule;
      procedure DestroyTimeModule;
      procedure DestroyDateTimeModule;
      procedure DestroyModules;
      procedure DestroyHeapTypes;
      procedure DestroySyncObj;
      procedure DestroyInterpreterState;
      procedure DestroyThreadState;

      function  Lock: boolean;
      procedure UnLock;
      function  RedirectIO: boolean;
      procedure GetCurrentInterpreterState;

    public
      constructor Create; override;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      procedure   BeforeDestruction; override;
      /// <summary>
      /// <para>Add the module to sys.modules.</para>
      /// </summary>
      function    AddToSysModules(const aModule: TCustomPyModule): boolean;
      /// <summary>
      /// <para>Remove the module from sys.modules.</para>
      /// </summary>
      function    RemoveFromSysModules(const aModule: TCustomPyModule): boolean;
      /// <summary>
      /// <para>Add the module to the internal module list.</para>
      /// </summary>
      procedure   AddModule(const aModule: TCustomPyModule);
      /// <summary>
      /// <para>Remove the module from the internal module list.</para>
      /// </summary>
      procedure   RemoveModule(const aModule: TCustomPyModule);
      /// <summary>
      /// <para>Search the module in the internal module list.</para>
      /// </summary>
      function    SearchModule(module: PPyObject; var aResult: TCustomPyModule): boolean;
      /// <summary>
      /// <para>Add the heap type to the internal module list.</para>
      /// </summary>
      procedure   AddHeapType(const aHeapType: TCustomHeapType);
      /// <summary>
      /// <para>Remove the heap type from the internal module list.</para>
      /// </summary>
      procedure   RemoveHeapType(const aHeapType: TCustomHeapType);
      /// <summary>
      /// <para>Search the heap type in the internal heap type list.</para>
      /// </summary>
      function    SearchHeapType(aObject: PPyObject; aAllowSubtypes: boolean; var aResult: TCustomHeapType): boolean;
      /// <summary>
      /// <para>Return True if module is the internal IOModule.</para>
      /// </summary>
      function    IsIOModule(module: PPyObject): boolean;
      /// <summary>
      /// <para>Internal function used by TIOPyModule.Write. Don't use!</para>
      /// </summary>
      procedure   doOnOutputMessage(const aMessage: string);
      /// <summary>
      /// <para>Internal function used by TIOPyModule.Read. Don't use!</para>
      /// </summary>
      function    doOnInputMessage(var aResultObj: IPyObject): boolean;
      /// <summary>
      /// Initialize the Python interpreter.
      /// </summary>
      function    Initialize: boolean; override;
      /// <summary>
      /// <para>Detach the attached thread state and return it. The thread will
      /// have no thread state upon returning.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-attached-thread-state">See the article about attached thread states.</see></para>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-thread-state">See the article about thread states.</see></para>
      /// </remarks>
      procedure   SaveThreadState;
      /// <summary>
      /// <para>Set the attached thread state to tstate. The passed thread
      /// state should not be attached, otherwise deadlock ensues. tstate will
      /// be attached upon returning.</para>
      /// <para>Note Calling this function from a thread when the runtime is
      /// finalizing will hang the thread until the program exits, even if the
      /// thread was not created by Python. Refer to Cautions regarding runtime
      /// finalization for more details.</para>
      /// <para>Changed in version 3.14: Hangs the current thread, rather than
      /// terminating it, if called while the interpreter is finalizing.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-attached-thread-state">See the article about attached thread states.</see></para>
      /// <para><see href="https://docs.python.org/3/glossary.html#term-thread-state">See the article about thread states.</see></para>
      /// </remarks>
      procedure   RestoreThreadState;
      /// <summary>
      /// Update LastErrorMessage with the last raised exception information.
      /// </summary>
      function    GetRaisedException: boolean;

      /// <summary>
      /// IOModule instance used by the interpreter for standard input, output
      /// and errors.
      /// </summary>
      property IOModule                  : TIOPyModule              read FIOModule;
      /// <summary>
      /// <para>The current interpreter.</para>
      /// </summary>
      property InterpreterState          : IPyInterpreterState      read GetInterpreterState;
      /// <summary>
      /// <para>The main module.</para>
      /// </summary>
      property MainModule                : IPyObject                read GetMainModule;
      /// <summary>
      /// <para>ID generator used for modules and heap types.</para>
      /// </summary>
      property NextID                    : cardinal                 read GetNextID;
      /// <summary>
      /// <para>Return True if this property runs in the same thread that
      /// created the TP4PEngine instance.</para>
      /// </summary>
      property IsMainThread              : boolean                  read GetIsMainThread;
      /// <summary>
      /// This property is True after a successfull call to
      /// TP4PEngine.SaveThreadState and before the call to
      /// TP4PEngine.RestoreThreadState.
      /// </summary>
      property SavedThreadState          : boolean                  read GetSavedThreadState            write SetSavedThreadState;
      /// <summary>
      /// TPyTimeModule instance used for DateTime conversions.
      /// </summary>
      property TimeModule                : TPyTimeModule            read FTimeModule;
      /// <summary>
      /// TPyDateTimeModule instance used for DateTime conversions.
      /// </summary>
      property DateTimeModule            : TPyDateTimeModule        read FDateTimeModule;
      /// <summary>
      /// Event triggered when Python outputs a string message.
      /// </summary>
      /// <remarks>
      /// <para>This event will run in the context of a background thread if you use TP4PThread.</para>
      /// <para><see href="https://docs.python.org/3/library/sys.html#sys.stderr">See the article about sys.stdin, sys.stdout and sys.stderr.</see></para>
      /// </remarks>
      property OnOutputMessage           : TOnOutputMessageEvent    read FOnOutputMessage               write FOnOutputMessage;
      /// <summary>
      /// Event triggered in all interactive input including Python calls to
      /// input().
      /// </summary>
      /// <remarks>
      /// <para>This event will run in the context of a background thread if you use TP4PThread.</para>
      /// <para><see href="https://docs.python.org/3/library/sys.html#sys.stderr">See the article about sys.stdin, sys.stdout and sys.stderr.</see></para>
      /// </remarks>
      property OnInputMessage            : TOnInputMessageEvent     read FOnInputMessage                write FOnInputMessage;
  end;

var
  /// <summary>
  /// Global instance of TP4PEngine used to simplify the initialization and destruction.
  /// </summary>
  GlobalP4PEngine : TP4PEngine = nil;

procedure DestroyGlobalP4PEngine;

implementation

uses
  {$IFDEF DELPHI16_UP}
    System.Types,
  {$ELSE}
    {$IFNDEF FPC}Types,{$ENDIF}
  {$ENDIF}
  uP4P.MiscFunctions, uP4P.PyImport, uP4P.PyDict, uP4P.PyErr, uP4P.PyUnicode,
  uP4P.PyInterpreterState, uP4P.PyEval, uP4P.PyThreadState, uP4P.Constants;

procedure DestroyGlobalP4PEngine;
begin
  if assigned(GlobalP4PEngine) then
    FreeAndNil(GlobalP4PEngine);
end;

constructor TP4PEngine.Create;
begin
  inherited Create;

  FMainThreadID      := TThreadID(0);
  FSavedThreadState  := False;
  FModules           := nil;
  FHeapTypes         := nil;
  FSyncObj           := nil;
  FIOModule          := nil;
  FInterpreterState  := nil;
  FThreadState       := nil;
  FTimeModule        := nil;
  FDateTimeModule    := nil;
  FIDGen             := 0;
  FOnOutputMessage   := nil;
  FOnInputMessage    := nil;
end;

destructor TP4PEngine.Destroy;
begin
  try
    DestroyModules;
    DestroyHeapTypes;
    DestroySyncObj;
  finally
    inherited Destroy;
  end;
end;

procedure TP4PEngine.AfterConstruction;
begin
  inherited AfterConstruction;

  FMainThreadID := CustomGetCurrentThreadId;
  FModules      := TList.Create;
  FHeapTypes    := TList.Create;
  FSyncObj      := TCriticalSection.Create;
end;

procedure TP4PEngine.BeforeDestruction;
begin
  try
    DestroyIOModule;
    DestroyTimeModule;
    DestroyDateTimeModule;
    DestroyInterpreterState;
    DestroyThreadState;
  finally
    inherited BeforeDestruction;
  end;
end;

procedure TP4PEngine.DestroyModules;
begin
  if Lock then
    try
      if assigned(FModules) then
        FreeAndNil(FModules);
    finally
      UnLock;
    end;
end;

procedure TP4PEngine.DestroyHeapTypes;
begin
  if Lock then
    try
      if assigned(FHeapTypes) then
        FreeAndNil(FHeapTypes);
    finally
      UnLock;
    end;
end;

procedure TP4PEngine.DestroySyncObj;
begin
  if assigned(FSyncObj) then
    FreeAndNil(FSyncObj);
end;

procedure TP4PEngine.DestroyIOModule;
begin
  if assigned(FIOModule) then
    FreeAndNil(FIOModule);
end;

procedure TP4PEngine.DestroyInterpreterState;
begin
  if Lock then
    try
      FInterpreterState := nil;
    finally
      UnLock;
    end;
end;

procedure TP4PEngine.DestroyThreadState;
begin
  if Lock then
    try
      FThreadState := nil;
    finally
      UnLock;
    end;
end;

procedure TP4PEngine.DestroyTimeModule;
begin
  if assigned(FTimeModule) then
    FreeAndNil(FTimeModule);
end;

procedure TP4PEngine.DestroyDateTimeModule;
begin
  if assigned(FDateTimeModule) then
    FreeAndNil(FDateTimeModule);
end;

procedure TP4PEngine.CreateTimeModule;
begin
  if not(assigned(FTimeModule)) then
    begin
      FTimeModule                   := TPyTimeModule.Create;
      FTimeModule.InExtensionModule := InExtensionModule;
    end;
end;

procedure TP4PEngine.CreateDateTimeModule;
begin
  if not(assigned(FDateTimeModule)) then
    begin
      FDateTimeModule                   := TPyDateTimeModule.Create;
      FDateTimeModule.InExtensionModule := InExtensionModule;
    end;
end;

function TP4PEngine.GetIsMainThread: boolean;
begin
  Result := (FMainThreadID = CustomGetCurrentThreadId);
end;

function TP4PEngine.GetSavedThreadState: boolean;
begin
  Result := False;

  if Lock then
    try
      Result := FSavedThreadState;
    finally
      Unlock;
    end;
end;

function TP4PEngine.GetInterpreterState: IPyInterpreterState;
begin
  Result := nil;

  if Lock then
    try
      Result := FInterpreterState;
    finally
      Unlock;
    end;
end;

function TP4PEngine.GetNextID: cardinal;
begin
  Result := 0;

  if Lock then
    try
      if (FIDGen < pred(high(cardinal))) then
        inc(FIDGen)
       else
        FIDGen := 1;

      Result := FIDGen;
    finally
      UnLock;
    end;
end;

function TP4PEngine.GetMainModule: IPyObject;
begin
  Result := nil;

  if Initialized then
    begin
      Result := TPyImport.AddModuleRef(MAIN_MODULE_NAME);

      if not(assigned(Result)) then
        Result := TPyImport.AddModule(MAIN_MODULE_NAME);
    end;
end;

procedure TP4PEngine.SetSavedThreadState(aValue: boolean);
begin
  if Lock then
    try
      FSavedThreadState := aValue;
    finally
      Unlock;
    end;
end;

function TP4PEngine.Lock: boolean;
begin
  Result := False;

  if assigned(FSyncObj) then
    begin
      FSyncObj.Acquire;
      Result := True;
    end;
end;

procedure TP4PEngine.UnLock;
begin
  if assigned(FSyncObj) then
    FSyncObj.Release;
end;

function TP4PEngine.AddToSysModules(const aModule: TCustomPyModule): boolean;
var
  TempModuleDict : IPyObject;
begin
  TempModuleDict := TPyImport.GetModuleDict;
  Result         := TPyDict.SetItemString(TempModuleDict, aModule.Name_, aModule.Module);
  TempModuleDict := nil;
end;

function TP4PEngine.RemoveFromSysModules(const aModule: TCustomPyModule): boolean;
var
  TempModuleDict : IPyObject;
begin
  TempModuleDict := TPyImport.GetModuleDict;
  Result         := TPyDict.DelItemString(TempModuleDict, aModule.Name_);
  TempModuleDict := nil;
end;

procedure TP4PEngine.AddModule(const aModule: TCustomPyModule);
begin
  if Lock then
    try
      if assigned(FModules) then
        FModules.Add(aModule);
    finally
      UnLock;
    end;
end;

procedure TP4PEngine.RemoveModule(const aModule: TCustomPyModule);
begin
  if Lock then
    try
      if assigned(FModules) then
        FModules.Remove(aModule);
    finally
      UnLock;
    end;
end;

function TP4PEngine.SearchModule(module: PPyObject; var aResult: TCustomPyModule): boolean;
var
  i: integer;
  TempModule : TCustomPyModule;
begin
  Result  := False;
  aResult := nil;

  if Lock then
    try
      if assigned(FModules) then
        for i := 0 to pred(FModules.Count) do
          begin
            TempModule := TCustomPyModule(FModules[i]);

            if TempModule.SameAs(module) then
              begin
                aResult := TempModule;
                Result  := True;
                break;
              end;
          end;
    finally
      UnLock;
    end;
end;

procedure TP4PEngine.AddHeapType(const aHeapType: TCustomHeapType);
begin
  if Lock then
    try
      if assigned(FHeapTypes) then
        FHeapTypes.Add(aHeapType);
    finally
      UnLock;
    end;
end;

procedure TP4PEngine.RemoveHeapType(const aHeapType: TCustomHeapType);
begin
  if Lock then
    try
      if assigned(FHeapTypes) then
        FHeapTypes.Remove(aHeapType);
    finally
      UnLock;
    end;
end;

function TP4PEngine.SearchHeapType(aObject: PPyObject; aAllowSubtypes: boolean; var aResult: TCustomHeapType): boolean;
var
  i            : integer;
  TempHeapType : TCustomHeapType;
begin
  Result  := False;
  aResult := nil;

  if Lock then
    try
      if assigned(FHeapTypes) then
        for i := 0 to pred(FHeapTypes.Count) do
          begin
            TempHeapType := TCustomHeapType(FHeapTypes[i]);

            if (aAllowSubtypes and TempHeapType.Check(aObject)) or
               (not(aAllowSubtypes) and TempHeapType.CheckExact(aObject)) then
              begin
                aResult := TempHeapType;
                Result  := True;
                break;
              end;
          end;
    finally
      UnLock;
    end;
end;

function TP4PEngine.IsIOModule(module: PPyObject): boolean;
begin
  Result := assigned(FIOModule) and
            TPyObject.IsInitialized(FIOModule.Module) and
            FIOModule.Module.SameAs(module);
end;

procedure TP4PEngine.doOnOutputMessage(const aMessage: string);
begin
  if assigned(FOnOutputMessage) then
    FOnOutputMessage(self, aMessage);
end;

function TP4PEngine.doOnInputMessage(var aResultObj: IPyObject): boolean;
var
  TempMessage: string;
begin
  Result := False;

  if assigned(FOnInputMessage) then
    begin
      TempMessage := '';
      FOnInputMessage(self, TempMessage);
      aResultObj  := TPyUnicode.FromString(TempMessage);
      Result      := True;
    end;
end;

function TP4PEngine.RedirectIO: boolean;
begin
  Result := False;

  if FInExtensionModule then
    Result := True
   else
    begin
      if not(assigned(FIOModule)) then
        begin
          FIOModule := TIOPyModule.Create(IOPyModuleName);
          if not(FIOModule.Initialize) then exit;
        end;

      Result := TIOPyModule.RunInitCode;
    end;
end;

procedure TP4PEngine.GetCurrentInterpreterState;
begin
  if Lock then
    try
      FInterpreterState := TPyInterpreterState.Get();
    finally
      UnLock;
    end;
end;

function TP4PEngine.Initialize: boolean;
begin
  Result := False;

  if inherited Initialize and RedirectIO then
    begin
      GetCurrentInterpreterState;
      CreateTimeModule;
      CreateDateTimeModule;

      Result := True;
    end;
end;

procedure TP4PEngine.SaveThreadState;
begin
  if IsMainThread and Lock then
    try
      if not(TPyThreadState.IsInitialized(FThreadState)) then
        begin
          FThreadState      := TPyEval.SaveThread();
          FSavedThreadState := TPyThreadState.IsInitialized(FThreadState);
        end;
    finally
      Unlock;
    end;
end;

procedure TP4PEngine.RestoreThreadState;
begin
  if IsMainThread and Lock then
    try
      TPyEval.RestoreThread(FThreadState);
      FThreadState      := nil;
      FSavedThreadState := False;
    finally
      Unlock;
    end;
end;

function TP4PEngine.GetRaisedException: boolean;
var
  TempType : PPyObject;
  TempValue, TempTraceback : IPyObject;
begin
  Result := False;

  if PythonLibIsGreaterOrEqualThan(3, 12, 0) then
    TempValue := TPyErr.GetRaisedException()
   else
    TPyErr.Fetch(TempType, TempValue, TempTraceback);

  if TPyObject.IsInitialized(TempValue) then
    begin
      FLastErrorMessage := TempValue.AsString;
      Result            := (length(FLastErrorMessage) > 0);

      if PythonLibIsGreaterOrEqualThan(3, 12, 0) then
        TPyErr.SetRaisedException(TempValue)
       else
        TPyErr.Restore(TempType, TempValue, TempTraceback);
    end;
end;

end.
