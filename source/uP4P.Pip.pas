unit uP4P.Pip;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils, System.Variants,
  {$ELSE}
    Classes, SysUtils, Variants,
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
      procedure CreateArgs(var aArgs, aKwargs: IPyObject; const module, extra: string);

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
  {$IFDEF MSWINDOWS}uP4P.PyLong,{$ENDIF} uP4P.PyBool, uP4P.PyErr;

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

procedure TPyPip.CreateArgs(var aArgs, aKwargs: IPyObject; const module, extra: string);
{$IFDEF MSWINDOWS}
const
  CREATE_NO_WINDOW = $08000000;
{$ENDIF}
var
  TempCmd : IPyObject;
begin
  TempCmd := TPyUnicode.FromString(FExecutable + ' -m ' + module + ' ' + extra);
  aArgs   := TPyTuple.Pack([TempCmd]);

  aKwargs := TPyDict.New;
  TPyDict.SetItem(aKwargs, 'check',          TPyBool.ReturnTrue);
  TPyDict.SetItem(aKwargs, 'capture_output', TPyBool.ReturnTrue);
  TPyDict.SetItem(aKwargs, 'text',           TPyBool.ReturnTrue);
  {$IFDEF MSWINDOWS}
  // Don't create a console window.
  TPyDict.SetItem(aKwargs, 'creationflags',  TPyLong.FromLong(CREATE_NO_WINDOW));
  {$ENDIF}
end;

function TPyPip.List(format: TPipListFormat; outdated: boolean; var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempExtra : string;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;

  if outdated then
    TempExtra := 'list -o'
   else
    TempExtra := 'list';

  case format of
    plf_freeze : if not(outdated) then TempExtra := TempExtra + ' --format freeze';
    plf_json   : TempExtra := TempExtra + ' --format json';
  end;

  CreateArgs(TempArgs, TempKwargs, 'pip', TempExtra);

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
  TempExtra : string;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) or (length(package_name) = 0) then exit;

  if upgrade then
    TempExtra := 'install --upgrade ' + package_name
   else
    TempExtra := 'install ' + package_name;

  CreateArgs(TempArgs, TempKwargs, 'pip', TempExtra);

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
  TempExtra : string;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) or (length(package_name) = 0) then exit;

  TempExtra := 'uninstall -y ' + package_name;

  CreateArgs(TempArgs, TempKwargs, 'pip', TempExtra);

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
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;

  CreateArgs(TempArgs, TempKwargs, 'pip', '--version');

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
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;

  CreateArgs(TempArgs, TempKwargs, 'ensurepip', '--default-pip');

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
  TempExtra : string;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;

  TempExtra := 'show ' + package_name;

  CreateArgs(TempArgs, TempKwargs, 'pip', TempExtra);

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
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;

  CreateArgs(TempArgs, TempKwargs, 'pip', 'check');

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
  TempExtra : string;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;

  TempExtra := 'index versions ' + package_name;

  CreateArgs(TempArgs, TempKwargs, 'pip', TempExtra);

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
