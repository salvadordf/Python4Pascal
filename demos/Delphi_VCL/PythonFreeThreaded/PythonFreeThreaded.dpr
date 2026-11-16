program PythonFreeThreaded;

{$I ..\..\..\source\p4p.inc}

uses
  {$IFDEF DELPHI16_UP}
  Vcl.Forms,
  {$ELSE}
  Forms,
  {$ENDIF }
  uMainForm in 'uMainForm.pas' {MainForm},
  uSortThread in 'uSortThread.pas',
  uSortModule in 'uSortModule.pas',
  uInterfaces in 'uInterfaces.pas';

{$R *.res}

begin
  Application.Initialize;
  {$IFDEF DELPHI11_UP}
  Application.MainFormOnTaskbar := True;
  {$ENDIF}
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
