program PythonOpenCV;

{$I ..\..\..\source\p4p.inc}

uses
  {$IFDEF DELPHI16_UP}
  Vcl.Forms,
  {$ELSE}
  Forms,
  {$ENDIF }
  uMainForm in 'uMainForm.pas' {MainForm},
  uCameraTest in 'uCameraTest.pas';

{$R *.res}

begin
  Application.Initialize;
  {$IFDEF DELPHI11_UP}
  Application.MainFormOnTaskbar := True;
  {$ENDIF}
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
