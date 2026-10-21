unit uMainForm;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, SyncObjs,
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyEval, uP4P.PyRun, uP4P.Constants;

type

  { TMainForm }

  TMainForm = class(TForm)
    LogMem: TMemo;
    RunBtn: TButton;
    Splitter1: TSplitter;
    Panel1: TPanel;
    ThreadRunModeRg: TRadioGroup;
    CodeMem: TMemo;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);  
    procedure RunBtnClick(Sender: TObject);

  private
    FPendingMsg : TStringList;
    FPendingCS  : TCriticalSection;    

    function  AppendMessage(const aMessage: string): boolean;
    procedure ShowPendingMessages;
    function  Lock: boolean;
    procedure Unlock;
    procedure Thread_OnTerminate(Sender: TObject);

  public
    procedure GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
  end;

var
  MainForm: TMainForm;

implementation        

// This demo shows how to run Python scripts in a thread.
// It allows you to select 4 ways to run the Python code in a thread but
// Python4Pascal doesn't support all modes in older Python versions.

{$R *.lfm}

uses
  uCustomThread, uP4P.Types;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DestroyGlobalP4PEngine;
  FreeAndNil(FPendingCS);
  FreeAndNil(FPendingMsg);
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  TempBit, TempDrive, TempLibPath : string;
begin
  if not(assigned(GlobalP4PEngine)) then
    begin
      GlobalP4PEngine                 := TP4PEngine.Create;
      GlobalP4PEngine.OnOutputMessage := GlobalP4PEngine_OnOutputMessage;
    end;

  if not(GlobalP4PEngine.Initialized) then
    begin
      GlobalP4PEngine.SetCurrentDir := True;

      {$IFDEF TARGET_32BITS}
      TempBit := 'win32';
      {$ELSE}
      TempBit := 'amd64';
      {$ENDIF}

      TempDrive := 'Q';
      //TempDrive := 'S';

      //TempLibPath := TempDrive + ':\python-3.15.0-embed-' + TempBit + '\python315.dll';
      //TempLibPath := TempDrive + ':\python-3.14.8-embed-' + TempBit + '\python314.dll';
      //TempLibPath := TempDrive + ':\python-3.13.16-embed-' + TempBit + '\python313.dll';
      //TempLibPath := TempDrive + ':\python-3.12.10-embed-' + TempBit + '\python312.dll';
      //TempLibPath := TempDrive + ':\python-3.11.9-embed-' + TempBit + '\python311.dll';
      //TempLibPath := TempDrive + ':\python-3.10.11-embed-' + TempBit + '\python310.dll';
      TempLibPath := '';

      if GlobalP4PEngine.Load(TempLibPath) and
         GlobalP4PEngine.Initialize then
        LogMem.Lines.Add('Python initialized. ' + GlobalP4PEngine.buildinfo)
       else
        begin
          LogMem.Lines.Add('There was an error initializing Python!');
          LogMem.Lines.Add(GlobalP4PEngine.LastErrorMessage);
        end;
    end;
end;

function TMainForm.Lock: boolean;
begin
  Result := False;

  if assigned(FPendingCS) then
    begin
      FPendingCS.Acquire;
      Result := True;
    end;
end;

procedure TMainForm.Unlock;
begin
  if assigned(FPendingCS) then
    FPendingCS.Release;
end;

procedure TMainForm.GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
begin
  if AppendMessage(message_) then
    TThread.Synchronize(nil, ShowPendingMessages);
end;

procedure TMainForm.RunBtnClick(Sender: TObject);
var
  TempThread : TCustomThread;
begin
  if not(assigned(GlobalP4PEngine)) then exit;

  // We *MUST* call SaveThreadState before running Python in a different thread.
  GlobalP4PEngine.SaveThreadState;

  TempThread                   := TCustomThread.Create(True);
  TempThread.Code              := CodeMem.Text;
  TempThread.FreeOnTerminate   := True;
  TempThread.ThreadInit        := TP4PThreadInit(ThreadRunModeRg.ItemIndex);
  TempThread.OnTerminate       := Thread_OnTerminate;
  TempThread.Start;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FPendingCS  := TCriticalSection.Create;
  FPendingMsg := TStringList.Create;
end;

function TMainForm.AppendMessage(const aMessage: string): boolean;
var
  TempMsg : string;
begin
  Result := False;
  if Lock then
    try
      TempMsg := trim(aMessage);

      if (length(TempMsg) > 0) then
        begin
          FPendingMsg.Add(TempMsg);
          Result := True;
        end;
    finally
      Unlock;
    end;
end;

procedure TMainForm.ShowPendingMessages;
begin
  if Lock then
    try
      if (FPendingMsg.Count > 0) then
        begin
          LogMem.Lines.AddStrings(FPendingMsg);
          FPendingMsg.Clear;
        end;
    finally
      Unlock;
    end;
end;

procedure TMainForm.Thread_OnTerminate(Sender: TObject);
begin                                 
  // Restore the state as soon as the thread finishes.
  GlobalP4PEngine.RestoreThreadState;
end;

end.
