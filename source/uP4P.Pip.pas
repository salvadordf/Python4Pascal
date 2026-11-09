unit uP4P.Pip;

{$IFDEF FPC}
  {$MODE Delphi}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils, System.Variants, System.Types,
    {$IFDEF DELPHI22_UP}System.Net.HttpClient, System.Net.URLClient, System.NetConsts,{$ENDIF}
  {$ELSE}
    Classes, SysUtils, Variants, Types,
    {$IFDEF MSWINDOWS}{$IFDEF FPC}fphttpclient, opensslsockets,{$ENDIF}{$ENDIF}
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
      procedure CreateArgs(var aArgs: IPyObject; const aCommand: TStringList);
      procedure CreateKwargs(var aKwargs: IPyObject);

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
      {$IFDEF MSWINDOWS}
      /// <summary>
      /// <para>Download the get-pip.py script to install PIP.</para>
      /// </summary>
      class function DownloadPIPInstallerScript(var aResult: string): boolean;
      /// <summary>
      /// <para>Run the get-pip.py script to install PIP.</para>
      /// </summary>
      class function RunPIPInstallerScript: boolean;
      {$ENDIF}
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
  uP4P.SubprocessCompletedProcess, uP4P.PyDict, uP4P.PyTuple, uP4P.PyList,
  {$IFDEF MSWINDOWS}uP4P.PyRun, uP4P.PyLong,{$ENDIF} uP4P.PyBool, uP4P.PyErr;

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

procedure TPyPip.CreateArgs(var aArgs: IPyObject; const aCommand: TStringList);
var
  TempCmd : IPyObject;
  i : integer;
begin
  try
    TempCmd := TPyList.New(aCommand.Count + 2);
    TPyList.SetItem(TempCmd, 0, FExecutable);
    TPyList.SetItem(TempCmd, 1, '-m');

    for i := 0 to pred(aCommand.Count) do
      TPyList.SetItem(TempCmd, i + 2, aCommand[i]);

    aArgs := TPyTuple.New(1);
    TPyTuple.SetItem(aArgs, 0, TempCmd);
  finally
    TempCmd := nil;
  end;
end;

procedure TPyPip.CreateKwargs(var aKwargs: IPyObject);
{$IFDEF MSWINDOWS}
const
  CREATE_NO_WINDOW = $08000000;
{$ENDIF}
var
  TempCheck, TempCapture, TempText: IPyObject;
  {$IFDEF MSWINDOWS}
  TempFlags: IPyObject;
  {$ENDIF}
begin
  try
    aKwargs     := TPyDict.New;
    TempCheck   := TPyBool.NewFalse;
    TempCapture := TPyBool.NewTrue;
    TempText    := TPyBool.NewTrue;
    {$IFDEF MSWINDOWS}
    TempFlags   := TPyLong.FromLong(CREATE_NO_WINDOW);
    {$ENDIF}

    TPyDict.SetItem(aKwargs, 'check',          TempCheck);
    TPyDict.SetItem(aKwargs, 'capture_output', TempCapture);
    TPyDict.SetItem(aKwargs, 'text',           TempText);
    {$IFDEF MSWINDOWS}
    // Don't create a console window.
    TPyDict.SetItem(aKwargs, 'creationflags',  TempFlags);
    {$ENDIF}
  finally
    TempCheck    := nil;
    TempCapture  := nil;
    TempText     := nil;
    {$IFDEF MSWINDOWS}
    TempFlags    := nil;
    {$ENDIF}
  end;
end;

function TPyPip.List(format: TPipListFormat; outdated: boolean; var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempCmd : TStringList;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;

  TempCmd := TStringList.Create;
  try
    TempCmd.Add('pip');
    TempCmd.Add('list');

    if outdated then
      TempCmd.Add('-o');

    case format of
      plf_freeze :
        if not(outdated) then
          begin
            TempCmd.Add('--format');
            TempCmd.Add('freeze');
          end;

      plf_json :
        begin
          TempCmd.Add('--format');
          TempCmd.Add('json');
        end;
    end;

    CreateArgs(TempArgs, TempCmd);
    CreateKwargs(TempKwargs);

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
  finally
    TempCmd.Free;
    TempArgs   := nil;
    TempKwargs := nil;
    TempResult := nil;
  end;
end;

function TPyPip.Install(const package_name: string; upgrade: boolean; var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempCmd : TStringList;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) or (length(package_name) = 0) then exit;

  TempCmd := TStringList.Create;
  try
    TempCmd.Add('pip');
    TempCmd.Add('install');

    if upgrade then
      TempCmd.Add('--upgrade');

    TempCmd.Add(package_name);

    CreateArgs(TempArgs, TempCmd);
    CreateKwargs(TempKwargs);

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
  finally
    TempCmd.Free;
    TempArgs   := nil;
    TempKwargs := nil;
    TempResult := nil;
  end;
end;

function TPyPip.Uninstall(const package_name: string; var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempCmd : TStringList;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) or (length(package_name) = 0) then exit;

  TempCmd := TStringList.Create;
  try
    TempCmd.Add('pip');
    TempCmd.Add('uninstall');
    TempCmd.Add('-y');
    TempCmd.Add(package_name);

    CreateArgs(TempArgs, TempCmd);
    CreateKwargs(TempKwargs);

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
  finally
    TempCmd.Free;
    TempArgs   := nil;
    TempKwargs := nil;
    TempResult := nil;
  end;
end;

function TPyPip.Version(var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempCmd : TStringList;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;

  TempCmd := TStringList.Create;
  try
    TempCmd.Add('pip');
    TempCmd.Add('--version');

    CreateArgs(TempArgs, TempCmd);
    CreateKwargs(TempKwargs);

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
  finally
    TempCmd.Free;
    TempArgs   := nil;
    TempKwargs := nil;
    TempResult := nil;
  end;
end;

function TPyPip.Ensurepip(var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempCmd : TStringList;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;     

  TempCmd := TStringList.Create;
  try
    TempCmd.Add('ensurepip');
    TempCmd.Add('--default-pip');

    CreateArgs(TempArgs, TempCmd);
    CreateKwargs(TempKwargs);

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
  finally
    TempCmd.Free;
    TempArgs   := nil;
    TempKwargs := nil;
    TempResult := nil;
  end;
end;

function TPyPip.Show(const package_name: string; var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempCmd : TStringList;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;        

  TempCmd := TStringList.Create;
  try
    TempCmd.Add('pip');
    TempCmd.Add('show');
    TempCmd.Add(package_name);

    CreateArgs(TempArgs, TempCmd);
    CreateKwargs(TempKwargs);

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
  finally
    TempCmd.Free;
    TempArgs   := nil;
    TempKwargs := nil;
    TempResult := nil;
  end;
end;

function TPyPip.Check(var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempCmd : TStringList;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;        

  TempCmd := TStringList.Create;
  try
    TempCmd.Add('pip');
    TempCmd.Add('check');

    CreateArgs(TempArgs, TempCmd);
    CreateKwargs(TempKwargs);

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
  finally
    TempCmd.Free;
    TempArgs   := nil;
    TempKwargs := nil;
    TempResult := nil;
  end;
end;

function TPyPip.IndexVersions(const package_name: string; var returncode: integer; var stdout, stderr: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
  TempCmd : TStringList;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';
  stderr     := '';
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;     

  TempCmd := TStringList.Create;
  try
    TempCmd.Add('pip');
    TempCmd.Add('index');
    TempCmd.Add('versions');
    TempCmd.Add(package_name);

    CreateArgs(TempArgs, TempCmd);
    CreateKwargs(TempKwargs);

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
  finally
    TempCmd.Free;
    TempArgs   := nil;
    TempKwargs := nil;
    TempResult := nil;
  end;
end;

{$IFDEF MSWINDOWS}
class function TPyPip.DownloadPIPInstallerScript(var aResult: string): boolean;
const
  SCRIPT_URL = 'https://bootstrap.pypa.io/get-pip.py';
{$IFDEF DELPHI22_UP}
var
  TempClient   : THTTPClient;
  TempResponse : IHTTPResponse;
{$ENDIF}
{$IFDEF FPC}
var
  TempClient : TFPHTTPClient;
  TempResult : string;
{$ENDIF}
begin
  Result  := False;
  aResult := '';

{$IFDEF DELPHI22_UP}
  TempClient := THTTPClient.Create;
  TempClient.AcceptCharSet := 'utf-8';
  try
    TempResponse := TempClient.Get(SCRIPT_URL);

    if (TempResponse.StatusCode = 200) then
      begin
        aResult := TempResponse.ContentAsString(TEncoding.UTF8);
        Result  := (length(aResult) > 0);
      end;
  finally
    TempClient.Free;
  end;
{$ENDIF}

{$IFDEF FPC}
  TempClient := TFPHTTPClient.Create(nil);
  try
    TempResult := TempClient.Get(SCRIPT_URL);

    if (TempClient.ResponseStatusCode = 200) then
      begin
        aResult := TempResult;
        Result  := (length(aResult) > 0);
      end;
  finally
    TempClient.Free;
  end;
{$ENDIF}
end;

class function TPyPip.RunPIPInstallerScript: boolean;
var
  TempScript: string;
begin
  TempScript := '';
  Result := DownloadPIPInstallerScript(TempScript) and
            TPyRun.SimpleString(TempScript);
end;
{$ENDIF}

end.
