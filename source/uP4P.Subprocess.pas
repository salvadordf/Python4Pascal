unit uP4P.Subprocess;

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
  uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// <para>TPySubprocess is a custom module created to import the subprocess
  /// module which allows you to spawn new processes, connect to their
  /// input/output/error pipes, and obtain their return codes.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/library/subprocess.html">See the article about the subprocess module.</see></para>
  /// </remarks>
  TPySubprocess = class
    protected
      FRun : IPyObject;

      function  GetInitialized : boolean;

      procedure Import;
      procedure Initialize;

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;

      /// <summary>
      /// <para>Run the command described by args. Wait for command to complete,
      /// then return a CompletedProcess instance.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/library/subprocess.html#using-the-subprocess-module">See the article about Using the subprocess Module.</see></para>
      /// </remarks>
      function Run(const args, kwargs: IPyObject): IPyObject;

      /// <summary>
      /// Returns true if the class is fully initialized.
      /// </summary>
      property Initialized   : boolean              read GetInitialized;
  end;

implementation

uses
  uP4P.PyImport;

constructor TPySubprocess.Create;
begin
  inherited Create;

  Initialize;
end;

destructor TPySubprocess.Destroy;
begin
  Initialize;
  inherited Destroy;
end;

procedure TPySubprocess.AfterConstruction;
begin
  inherited AfterConstruction;

  Import;
end;

procedure TPySubprocess.Initialize;
begin
  FRun := nil;
end;

procedure TPySubprocess.Import;
var
  TempModule : IPyObject;
begin
  TempModule := TPyImport.ImportModule('subprocess');

  if TPyObject.IsInitialized(TempModule) then
    TempModule.GetOptionalAttrString('run', FRun);
end;

function TPySubprocess.GetInitialized: boolean;
begin
  Result := TPyObject.IsInitialized(FRun);
end;

function TPySubprocess.Run(const args, kwargs: IPyObject): IPyObject;
begin
  if Initialized then
    Result := FRun.Call(args, kwargs)
   else
    Result := nil;
end;

end.
