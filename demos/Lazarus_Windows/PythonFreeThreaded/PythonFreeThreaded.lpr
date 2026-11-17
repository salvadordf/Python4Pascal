program PythonFreeThreaded;

{$MODE Delphi}

uses
  Forms, Interfaces,
  uMainForm in 'uMainForm.pas' {MainForm},
  uSortThread in 'uSortThread.pas',
  uSortModule in 'uSortModule.pas',
  uInterfaces in 'uInterfaces.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
