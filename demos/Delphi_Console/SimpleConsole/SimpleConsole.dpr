program SimpleConsole;

{$APPTYPE CONSOLE}

{$I ..\..\..\source\p4p.inc}

{$R *.res}

uses
  {$IFDEF DELPHI16_UP}
  System.SysUtils,
  {$ELSE}
  SysUtils,
  {$ENDIF}
  uMain in 'uMain.pas',
  uCustomThread in 'uCustomThread.pas';

// This demo shows how to use Python in a console application.
//
// It runs a Python script in a thread that shows the version information and
// waits for the user to press the enter key to exit.

begin
  try
    CreateGlobalP4PEngine;
    CreateCustomThread;
    WaitForMainAppEvent;
    WaitForEnter;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.
