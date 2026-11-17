program PythonFreeThreaded;

{$mode objfpc}{$H+}

uses
  {$IFDEF UNIX}
  cthreads,
  {$ENDIF}
  {$IFDEF HASAMIGA}
  athreads,
  {$ENDIF}
  Interfaces, // this includes the LCL widgetset
  Forms,
  uMainForm in 'uMainForm.pas' {MainForm},
  uSortThread in 'uSortThread.pas',
  uSortModule in 'uSortModule.pas',
  uInterfaces in 'uInterfaces.pas';

{$R *.res}

begin                   
  RequireDerivedFormResource:=True;
  {$PUSH}{$WARN 5044 OFF}
  Application.MainFormOnTaskbar:=True;
  {$POP}
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
