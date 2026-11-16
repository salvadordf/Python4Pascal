unit uSortThread;

{$I ..\..\..\source\p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  uP4P.Thread, uP4P.PyModule, uSortModule, uInterfaces;

type
  // TP4PThread has all the code needed to run Python in a thread and all
  // we have to do is override doOnExecutePython or implement the
  // TP4PThread.OnExecutePython event.
  // This demo creates a custom module and a heap type so it's also necessary to
  // override doOnFinalizeModules and doOnDestroyModules.
  TSortThread = class(TP4PThread)
    protected
      FModName  : string;
      FCode     : string;
      FModule   : TSortModule;
      FMainForm : IMainForm;
      FIdx      : integer;

      procedure doOnExecutePython; override;
      procedure doOnFinalizeModules; override;
      procedure doOnDestroyModules; override;

      function  CreateModule: boolean;

    public
      procedure AfterConstruction; override;
      procedure BeforeDestruction; override;

      property Idx      : integer    read FIdx        write FIdx;
      property ModName  : string     read FModName    write FModName;
      property Code     : string     read FCode       write FCode;
      property MainForm : IMainForm  read FMainForm   write FMainForm;
  end;

implementation

uses
  uP4P.PyRun, uP4P.Types;

procedure TSortThread.AfterConstruction;
begin
  inherited AfterConstruction;
  FMainForm := nil;
end;

procedure TSortThread.BeforeDestruction;
begin
  FMainForm := nil;
  inherited BeforeDestruction;
end;

// We create the module and the heap type before running the Python code.
procedure TSortThread.doOnExecutePython;
begin
  if CreateModule then
    TPyRun.SimpleString(FCode);
end;

// This procedure will be executed before the TPy.EndInterpreter call and it's
// used to finalize the modules and types.
procedure TSortThread.doOnFinalizeModules;
begin
  if assigned(FModule) then
    FModule.Finalize;
end;

// This procedure will be executed after the TPy.EndInterpreter call and it's
// used to destroy the modules and types.
procedure TSortThread.doOnDestroyModules;
begin
  if assigned(FModule) then
    FreeAndnil(FModule);
end;

// This function creates our custom module
function TSortThread.CreateModule: boolean;
begin
  FModule                  := TSortModule.Create(FModName);
  FModule.MultIntprSupport := piGilSupported;
  FModule.MainForm         := FMainForm;
  FModule.Idx              := FIdx;
  Result                   := FModule.Initialize;
end;

end.
