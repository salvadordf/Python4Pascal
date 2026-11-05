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
  uP4P.Interfaces, uP4P.PyObject, uP4P.Subprocess;

type
  /// <summary>
  /// <para>TPyPip is a custom class created to use the pip utility which
  /// allows manage the installed packages in Python.</para>
  /// <para>This class uses a TPySubprocess instance to run the pip
  /// utility.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/installing/index.html">See the article about Installing Python modules.</see></para>
  /// </remarks>
  TPyPip = class
    protected
      FSubprocess : TPySubprocess;
      FExecutable : string;

      function  GetInitialized : boolean;
      procedure CreateArgs(var aArgs, aKwargs: IPyObject; const pip_command: string);

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      /// <summary>
      /// <para>Returns a list of installed modules in stdout.</para>
      /// <para>This function runs pip in a subprocess, sets the return code
      /// in returncode and the output in stdout.</para>
      /// </summary>
      function List(var returncode: integer; var stdout: string): boolean;
      /// <summary>
      /// <para>Installs aPackage in the current environment.</para>
      /// <para>This function runs pip in a subprocess, sets the return code
      /// in returncode and the output in stdout.</para>
      /// </summary>
      function Install(const aPackage: string; var returncode: integer; var stdout: string): boolean;
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
  Result := assigned(FSubprocess);
end;

procedure TPyPip.CreateArgs(var aArgs, aKwargs: IPyObject; const pip_command: string);
{$IFDEF MSWINDOWS}
const
  CREATE_NO_WINDOW = $08000000;
{$ENDIF}
var
  TempCmd : IPyObject;
begin
  TempCmd := TPyUnicode.FromString(FExecutable + ' -m pip ' + pip_command);
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

function TPyPip.List(var returncode: integer; var stdout: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';  
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) then exit;

  CreateArgs(TempArgs, TempKwargs, 'list');

  TempResult := FSubprocess.Run(TempArgs, TempKwargs);

  if TPyObject.IsInitialized(TempResult) then
    begin
      returncode := TPySubprocessCompletedProcess.returncode(TempResult);
      stdout     := TPySubprocessCompletedProcess.stdout(TempResult);
      Result     := (returncode = 0);
    end
   else
    TPyErr.Print;
end;

function TPyPip.Install(const aPackage: string; var returncode: integer; var stdout: string): boolean;
var
  TempArgs, TempKwargs, TempResult : IPyObject;
begin
  Result     := False;
  returncode := -1;
  stdout     := '';  
  TempArgs   := nil;
  TempKwargs := nil;

  if not(Initialized) or (length(aPackage) = 0) then exit;

  CreateArgs(TempArgs, TempKwargs, 'install ' + aPackage);

  TempResult := FSubprocess.Run(TempArgs, TempKwargs);

  if TPyObject.IsInitialized(TempResult) then
    begin
      returncode := TPySubprocessCompletedProcess.returncode(TempResult);
      stdout     := TPySubprocessCompletedProcess.stdout(TempResult);
      Result     := (returncode = 0);
    end
   else
    TPyErr.Print;
end;

end.
