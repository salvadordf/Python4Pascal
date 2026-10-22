unit uMain;

{$mode ObjFPC}{$H+}

interface

uses
  Classes, SyncObjs, SysUtils,
  uP4P.Engine;

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
  MainAppEvent : TSimpleEvent;

class procedure TMain.GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
begin
  WriteLn(message_);
end;

procedure SetMainAppEvent;
begin
  MainAppEvent.SetEvent;
end;

procedure CreateGlobalP4PEngine;
begin                   
  // Create the engine and using the OnOutputMessage event to show the messages
  // in the console.
  GlobalP4PEngine                 := TP4PEngine.Create;
  GlobalP4PEngine.OnOutputMessage := @TMain.GlobalP4PEngine_OnOutputMessage;
                     
  // Load the Python library installed in the operating system and initialize it.
  if GlobalP4PEngine.Load and
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
  MainAppEvent := TSimpleEvent.Create;

finalization
  MainAppEvent.Free;

end.
