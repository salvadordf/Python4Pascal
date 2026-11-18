program PythonOpenCV;

{$MODE Delphi}

uses
  Forms,
  uMainForm in 'uMainForm.pas' {MainForm},
  uCameraTest in 'uCameraTest.pas', Interfaces;

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
