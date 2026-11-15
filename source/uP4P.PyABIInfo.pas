unit uP4P.PyABIInfo;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants;

type
  /// <summary>
  /// Helper class for all PyABIInfo_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/stable.html#abi-checking">See the article about ABI Checking.</see></para>
  /// <para>Added in version 3.15.</para>
  /// </remarks>
  TPyABIInfo = class
    public
      /// <summary>
      /// <para>Verify that the given info is compatible with the currently
      /// running interpreter.</para>
      /// <para>Return True on success. On failure, raise an exception and
      /// return False.</para>
      /// <para>If the ABI is incompatible, the raised exception will be
      /// ImportError.</para>
      /// <para>The module_name argument can be nil, or point to a
      /// NUL-terminated UTF-8-encoded string used for error messages.</para>
      /// <para>Note that if info describes the ABI that the current code uses
      /// (as defined by PyABIInfo_VAR, for example), using any other Python
      /// C API may lead to crashes. In particular, it is not safe to examine
      /// the raised exception.</para>
      /// </summary>
      class function Check(const info: PyABIInfo; const module_name: string): boolean;
      /// <summary>
      /// Default flags, based on current values of macros such as Py_LIMITED_API
      /// and Py_GIL_DISABLED.
      /// </summary>
      class function DEFAULT_FLAGS: word;
      /// <summary>
      /// <para>The value that should be used for PyABIInfo.abi_version, based
      /// on current values of macros such as Py_LIMITED_API, TPy.VERSION_HEX
      /// and Py_GIL_DISABLED.</para>
      /// </summary>
      class function DEFAULT_ABI_VERSION: cardinal;
      /// <summary>
      /// <para>Define a PyABIInfo variable that describes the ABI that the
      /// current code will use.</para>
      /// </summary>
      class procedure VAR_(var info: PyABIInfo);
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.Py;

class function TPyABIInfo.Check(const info: PyABIInfo; const module_name: string): boolean;
var
  TempModuleName : AnsiString;
begin
  Result := False;
  if not(assigned(PyABIInfo_Check)) then exit;

  if (length(module_name) > 0) then
    begin
      TempModuleName := StringToPyUTF8(module_name);
      Result := (PyABIInfo_Check(@info, PAnsiChar(TempModuleName)) = 0);
    end
   else
    Result := (PyABIInfo_Check(@info, nil) = 0);
end;

class function TPyABIInfo.DEFAULT_FLAGS: word;
const
  _PyABIInfo_DEFAULT_FLAG_STABLE   = 0;
  {$IFDEF PY_GIL_DISABLED}
  _PyABIInfo_DEFAULT_FLAG_FT       = PyABIInfo_FREETHREADED;
  {$ELSE}
  _PyABIInfo_DEFAULT_FLAG_FT       = PyABIInfo_GIL;
  {$ENDIF}
  _PyABIInfo_DEFAULT_FLAG_INTERNAL = 0;
begin
  Result := _PyABIInfo_DEFAULT_FLAG_STABLE or
            _PyABIInfo_DEFAULT_FLAG_FT or
            _PyABIInfo_DEFAULT_FLAG_INTERNAL;
end;

class function TPyABIInfo.DEFAULT_ABI_VERSION: cardinal;
begin
  Result := TPy.VERSION_HEX;
end;

class procedure TPyABIInfo.VAR_(var info: PyABIInfo);
begin
  info.abiinfo_major_version := 1;
  info.abiinfo_minor_version := 0;
  info.flags                 := DEFAULT_FLAGS;
  info.build_version         := TPy.VERSION_HEX;
  info.abi_version           := DEFAULT_ABI_VERSION;
end;

end.
