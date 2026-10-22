program SimpleConsole;

{$mode ObjFPC}{$H+}

{$APPTYPE CONSOLE}

{$R *.res}

uses
  SysUtils,
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
