unit uP4P.Pip;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils, System.Variants, System.Types,
  {$ELSE}
    Classes, SysUtils, Variants, Types,
  {$ENDIF}
  uP4P.Interfaces, uP4P.PyObject, uP4P.Subprocess, uP4P.Types;

type
  /// <summary>
  /// <para>TPyPip is a custom class created to use the pip utility which
  /// allows manage the installed packages in Python.</para>
  /// <para>This class uses a TPySubprocess instance to run the pip
  /// utility.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/installing/index.html">See the article about Installing Python modules.</see></para>
  /// <para><see href="https://packaging.python.org/en/latest/">See the article about the Python Packaging User Guide.</see></para>
  /// </remarks>
  TPyPip = class
    protected
      FSubprocess : TPySubprocess;
      FExecutable : string;

      function  GetInitialized : boolean;
      procedure CreateArgs(var aArgs, aKwargs: IPyObject; const aCommand: TStringDynArray);

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      /// <summary>
      /// <para>Returns a list of installed modules in stdout.</para>
      /// <para>This function runs python in a subprocess, sets the return code
      /// in returncode, sets the standard output in stdout and the errors in
      /// stderr.</para>
      /// </summary>
      function List(format: TPipListFormat; outdated: boolean; var returncode: integer; var stdout, stderr: string): boolean;
      /// <summary>
      /// <para>Installs package_name in the current environment.</para>
      /// <para>This function runs python in a subprocess, sets the return code
      /// in returncode, sets the standard output in stdout and the errors in
      /// stderr.</para>
      /// </summary>
      function Install(const package_name: string; upgrade: boolean; var returncode: integer; var stdout, stderr: string): boolean;
      /// <summary>
      /// <para>Uninstalls package_name in the current environment.</para>
      /// <para>This function runs python in a subprocess, sets the return code
      /// in returncode, sets the standard output in stdout and the errors in
      /// stderr.</para>
      /// </summary>
      function Uninstall(const package_name: string; var returncode: integer; var stdout, stderr: string): boolean;
      /// <summary>
      /// <para>Return the installed pip version.</para>
      /// <para>This function runs python in a subprocess, sets the return code
      /// in returncode, sets the standard output in stdout and the errors in
      /// stderr.</para>
      /// </summary>
      function Version(var returncode: integer; var stdout, stderr: string): boolean;
      /// <summary>
      /// <para>Install pip.</para>
      /// <para>This function runs python in a subprocess, sets the return code
      /// in returncode, sets the standard output in stdout and the errors in
      /// stderr.</para>
      /// </summary>
      function Ensurepip(var returncode: integer; var stdout, stderr: string): boolean;
      /// <summary>
      /// <para>Show information about a package. The output is in RFC-compliant
      /// mail header format.</para>
      /// <para>This function runs python in a subprocess, sets the return code
      /// in returncode, sets the standard output in stdout and the errors in
      /// stderr.</para>
      /// </summary>
      function Show(const package_name: string; var returncode: integer; var stdout, stderr: string): boolean;
      /// <summary>
      /// <para>Verify installed packages have compatible dependencies.</para>
      /// <para>This function runs python in a subprocess, sets the return code
      /// in returncode, sets the standard output in stdout and the errors in
      /// stderr.</para>
      /// </summary>
      function Check(var returncode: integer; var stdout, stderr: string): boolean;
      /// <summary>
      /// <para>Inspect information available from package indexes.</para>
      /// <para>This function runs python in a subprocess, sets the return code
      /// in returncode, sets the standard output in stdout and the errors in
      /// stderr.</para>
      /// </summary>
      function IndexVersions(const package_name: string; var returncode: integer; var stdout, stderr: string): boolean;
      /// <summary>
      /// Returns true if the class is fully initialized.
      /// </summary>
      property Initialized   : boolean              read GetInitialized;
      /// <summary>
      /// Absolute path to the python3 executable.
      /// </summary>
      property Executable    : string               read FExecutable      write FExecutable;
  end;

implementation

uses
  uP4P.SubprocessCompletedProcess, uP4P.PyDict, uP4P.PyTuple, uP4P.PyUnicode,
  {$IFDEF MSWINDOWS}uP4P.PyLong,{$ENDIF} uP4P.PyBool, uP4P.PyErr, uP4P.PyList;

constructor TPyPip.Create;
begin
  inherited Create;

  FSubprocess := nil;
end;

destructor TPyPip.Destroy;
begin
  if assigned(FSubprocess) then
    FreeAndNil(FSubprocess);

  inherited Destroy;
end;

procedure TPyPip.AfterConstruction;
begin
  inherited AfterConstruction;

  FSubprocess := TPySubprocess.Create;
end;

function TPyPip.GetInitialized: boolean;
begin
  Result := assigned(FSubprocess) and
            (length(FExecutable) > 0) and
            FileExists(FExecutable);
end;

procedure TPyPip.CreateArgs(var aArgs, aKwargs: IPyObject; const aCommand: TStringDynArray);
{$IFDEF MSWINDOWS}
const
  CREATE_NO_WINDOW = $08000000;
{$ENDIF}
var
  TempCmd : IPyObject;
  i : integer;
begin
  TempCmd := TPyList.New(length(aCommand) + 2);
  TPyList.SetItem(TempCmd, 0, FExecutable);
  TPyList.SetItem(TempCmd, 1, '-m');

  for i := 0 to pred(length(aCommand)) do
    TPyList.SetItem(TempCmd, i + 2, aCommand[i]);

  aArgs   := TPyTuple.Pack([TempCmd]);
  aKwargs := TPyDict.New;
  TPyDict.SetItem(aKwargs, 'check',          TPyBool.NewTrue);
  TPyDict.SetItem(aKwargs, 'capture_output', TPyBool.NewTrue);
  TPyDict.SetItem(aKwargs, 'text',           TPyBool.NewTrue);
  {$IFDEF MSWINDOWS}
  // Don't create a console window.
  TPyDict.SetItem(aKwargs, 'creationflags',  TPyLong.FromLong(CREATE_NO_WINDOW));
  {$ENDIF}
end;

function TPyPip.List(format: TPipListFormat; outdated: boolean; var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempCmd : TStringDynArray;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;

  if outdated then
    TempCmd := ['pip', 'list', '-o']
   else
    TempCmd := ['pip', 'list'];

  case format of
    plf_freeze : if not(outdated) then TempCmd := TempCmd + ['--format', 'freeze'];
    plf_json   : TempCmd := TempCmd + ['--format', 'json'];
  end;

  CreateArgs(TempArgs, TempKwargs, TempCmd);

  TempResult := FSubprocess.Run(TempArgs, TempKwargs);

  if TPyObject.IsInitialized(TempResult) then
    begin
      returncode := TPySubprocessCompletedProcess.returncode(TempResult);
      stdout     := TPySubprocessCompletedProcess.stdout(TempResult);
      stderr     := TPySubprocessCompletedProcess.stderr(TempResult);
      Result     := (returncode = 0);
    end
   else
    TPyErr.Print;
end;

function TPyPip.Install(const package_name: string; upgrade: boolean; var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempCmd : TStringDynArray;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) or (length(package_name) = 0) then exit;

  if upgrade then
    TempCmd := ['pip', 'install', '--upgrade', package_name]
   else
    TempCmd := ['pip', 'install', package_name];

  CreateArgs(TempArgs, TempKwargs, TempCmd);

  TempResult := FSubprocess.Run(TempArgs, TempKwargs);

  if TPyObject.IsInitialized(TempResult) then
    begin
      returncode := TPySubprocessCompletedProcess.returncode(TempResult);
      stdout     := TPySubprocessCompletedProcess.stdout(TempResult);
      stderr     := TPySubprocessCompletedProcess.stderr(TempResult);
      Result     := (returncode = 0);
    end
   else
    TPyErr.Print;
end;

function TPyPip.Uninstall(const package_name: string; var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempCmd : TStringDynArray;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) or (length(package_name) = 0) then exit;

  TempCmd := ['pip', 'uninstall', '-y', package_name];

  CreateArgs(TempArgs, TempKwargs, TempCmd);

  TempResult := FSubprocess.Run(TempArgs, TempKwargs);

  if TPyObject.IsInitialized(TempResult) then
    begin
      returncode := TPySubprocessCompletedProcess.returncode(TempResult);
      stdout     := TPySubprocessCompletedProcess.stdout(TempResult);
      stderr     := TPySubprocessCompletedProcess.stderr(TempResult);
      Result     := (returncode = 0);
    end
   else
    TPyErr.Print;
end;

function TPyPip.Version(var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempCmd : TStringDynArray;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;

  TempCmd := ['pip', '--version'];

  CreateArgs(TempArgs, TempKwargs, TempCmd);

  TempResult := FSubprocess.Run(TempArgs, TempKwargs);

  if TPyObject.IsInitialized(TempResult) then
    begin
      returncode := TPySubprocessCompletedProcess.returncode(TempResult);
      stdout     := TPySubprocessCompletedProcess.stdout(TempResult);
      stderr     := TPySubprocessCompletedProcess.stderr(TempResult);
      Result     := (returncode = 0);
    end
   else
    TPyErr.Print;
end;

function TPyPip.Ensurepip(var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempCmd : TStringDynArray;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;

  TempCmd := ['ensurepip', '--default-pip'];

  CreateArgs(TempArgs, TempKwargs, TempCmd);

  TempResult := FSubprocess.Run(TempArgs, TempKwargs);

  if TPyObject.IsInitialized(TempResult) then
    begin
      returncode := TPySubprocessCompletedProcess.returncode(TempResult);
      stdout     := TPySubprocessCompletedProcess.stdout(TempResult);
      stderr     := TPySubprocessCompletedProcess.stderr(TempResult);
      Result     := (returncode = 0);
    end
   else
    TPyErr.Print;
end;

function TPyPip.Show(const package_name: string; var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempCmd : TStringDynArray;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;

  TempCmd := ['pip', 'show', package_name];

  CreateArgs(TempArgs, TempKwargs, TempCmd);

  TempResult := FSubprocess.Run(TempArgs, TempKwargs);

  if TPyObject.IsInitialized(TempResult) then
    begin
      returncode := TPySubprocessCompletedProcess.returncode(TempResult);
      stdout     := TPySubprocessCompletedProcess.stdout(TempResult);
      stderr     := TPySubprocessCompletedProcess.stderr(TempResult);
      Result     := (returncode = 0);
    end
   else
    TPyErr.Print;
end;

function TPyPip.Check(var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempCmd : TStringDynArray;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;

  TempCmd := ['pip', 'check'];

  CreateArgs(TempArgs, TempKwargs, TempCmd);

  TempResult := FSubprocess.Run(TempArgs, TempKwargs);

  if TPyObject.IsInitialized(TempResult) then
    begin
      returncode := TPySubprocessCompletedProcess.returncode(TempResult);
      stdout     := TPySubprocessCompletedProcess.stdout(TempResult);
      stderr     := TPySubprocessCompletedProcess.stderr(TempResult);
      Result     := (returncode = 0);
    end
   else
    TPyErr.Print;
end;

function TPyPip.IndexVersions(const package_name: string; var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempCmd : TStringDynArray;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;

  TempCmd := ['pip', 'index', 'versions', package_name];

  CreateArgs(TempArgs, TempKwargs, TempCmd);

  TempResult := FSubprocess.Run(TempArgs, TempKwargs);

  if TPyObject.IsInitialized(TempResult) then
    begin
      returncode := TPySubprocessCompletedProcess.returncode(TempResult);
      stdout     := TPySubprocessCompletedProcess.stdout(TempResult);
      stderr     := TPySubprocessCompletedProcess.stderr(TempResult);
      Result     := (returncode = 0);
    end
   else
    TPyErr.Print;
end;

end.
