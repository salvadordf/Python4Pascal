unit uMain;

{$I ..\..\..\source\p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.Classes, System.SyncObjs, System.SysUtils,
  {$ELSE}
  Classes, SyncObjs, SysUtils,
  {$ENDIF}
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyEval, uP4P.PyRun, uP4P.Constants, uP4P.Types;

type
  TMain = class
    public
      class procedure GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
  end;

procedure CreateGlobalP4PEngine;
procedure CreateCustomThread;
procedure WaitForMainAppEvent;
procedure WaitForEnter;
procedure SetMainAppEvent;

implementation

uses
  uCustomThread;

var
  MainAppEvent : TEvent;

class procedure TMain.GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
begin
  WriteLn(message_);
end;

procedure SetMainAppEvent;
begin
  MainAppEvent.SetEvent;
end;

procedure CreateGlobalP4PEngine;
var
  TempBit, TempDrive, TempLibPath : string;
begin
  // Create the engine and using the OnOutputMessage event to show the messages
  // in the console.
  GlobalP4PEngine                 := TP4PEngine.Create;
  GlobalP4PEngine.OnOutputMessage := TMain.GlobalP4PEngine_OnOutputMessage;

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

  // Load the Python library installed in the operating system and initialize it.
  if GlobalP4PEngine.Load(TempLibPath) and
     GlobalP4PEngine.Initialize then
    begin
      WriteLn('Python initialized.');
      // We *MUST* call SaveThreadState before running Python in a different thread.
      GlobalP4PEngine.SaveThreadState;
    end
   else
    begin
      WriteLn('There was an error initializing Python!');
      WriteLn(GlobalP4PEngine.LastErrorMessage);
    end;
end;

procedure CreateCustomThread;
var
  TempThread : TCustomThread;
begin
  TempThread                   := TCustomThread.Create(True);
  TempThread.Code              := 'import sys' + #10 + 'print(sys.version)';
  TempThread.FreeOnTerminate   := True;
  TempThread.Start;
end;

procedure WaitForMainAppEvent;
begin
  // Wait for 1 minute max.
  if (MainAppEvent.WaitFor(60000) = wrTimeout) then
    WriteLn('Timeout expired!');
end;

procedure WaitForEnter;
begin
  WriteLn('Press ENTER...');
  ReadLn;
  DestroyGlobalP4PEngine;
end;

initialization
  MainAppEvent := TEvent.Create;

finalization
  MainAppEvent.Free;

end.
