program PythonPackageInstaller;

{$MODE Delphi}

uses
  {$IFDEF UNIX}{$IFDEF UseCThreads}
  cthreads,
  {$ENDIF}{$ENDIF}
  // "Interfaces" is a custom unit used to initialize the LCL WidgetSet
  // We keep the same name to avoid a Lazarus warning.
  Interfaces, // this includes the LCL widgetset
  Forms,
  uMainForm in 'uMainForm.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
