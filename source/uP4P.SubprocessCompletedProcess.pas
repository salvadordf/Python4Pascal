unit uP4P.SubprocessCompletedProcess;

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
  /// <para>TPySubprocessCompletedProcess is a class that wraps the
  /// subprocess.CompletedProcess Python class.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/library/subprocess.html#subprocess.CompletedProcess">See the article about the subprocess.CompletedProcess class.</see></para>
  /// </remarks>
  TPySubprocessCompletedProcess = class
    public
      /// <summary>
      /// <para>Exit status of the child process. Typically, an exit status of
      /// 0 indicates that it ran successfully.</para>
      /// <para>A negative value -N indicates that the child was terminated by
      /// signal N (POSIX only).</para>
      /// </summary>
      class function returncode(const aPyObject: IPyObject): integer;
      /// <summary>
      /// <para>Captured stdout from the child process. A bytes sequence, or a
      /// string if run() was called with an encoding, errors, or text=True.
      /// None if stdout was not captured.</para>
      /// <para>If you ran the process with stderr=subprocess.STDOUT, stdout
      /// and stderr will be combined in this attribute, and stderr will be
      /// None.</para>
      /// </summary>
      class function stdout(const aPyObject: IPyObject): string;
      /// <summary>
      /// <para>Captured stderr from the child process. A bytes sequence, or a
      /// string if run() was called with an encoding, errors, or text=True.
      /// None if stderr was not captured.</para>
      /// </summary>
      class function stderr(const aPyObject: IPyObject): string;
  end;

implementation

class function TPySubprocessCompletedProcess.returncode(const aPyObject: IPyObject): integer;
var
  TempReturnCode : IPyObject;
begin
  if TPyObject.IsInitialized(aPyObject) and
     aPyObject.GetOptionalAttrString('returncode', TempReturnCode) then
    Result := TempReturnCode.AsInteger
   else
    Result := 0;
end;

class function TPySubprocessCompletedProcess.stderr(const aPyObject: IPyObject): string;
var
  TempStderr : IPyObject;
begin
  if TPyObject.IsInitialized(aPyObject) and
     aPyObject.GetOptionalAttrString('stderr', TempStderr) then
    Result := TempStderr.AsString
   else
    Result := '';
end;

class function TPySubprocessCompletedProcess.stdout(const aPyObject: IPyObject): string;
var
  TempStdout : IPyObject;
begin
  if TPyObject.IsInitialized(aPyObject) and
     aPyObject.GetOptionalAttrString('stdout', TempStdout) then
    Result := TempStdout.AsString
   else
    Result := '';
end;

end.
