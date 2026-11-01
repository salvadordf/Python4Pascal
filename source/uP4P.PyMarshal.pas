unit uP4P.PyMarshal;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class for PyMarshal_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/marshal.html">See the article about Data marshalling support.</see></para>
  /// </remarks>
  TPyMarshal = class
    public
      /// <summary>
      /// <para>Return a Python object from the data stream.</para>
      /// <para>On error, sets the appropriate exception (EOFError, ValueError
      /// or TypeError) and returns nil.</para>
      /// </summary>
      class function ReadObjectFromStream(const data: TMemoryStream): IPyObject;
      /// <summary>
      /// <para>Return a Python object from the data stream in a byte buffer
      /// containing len bytes pointed to by data.</para>
      /// <para>On error, sets the appropriate exception (EOFError, ValueError
      /// or TypeError) and returns nil.</para>
      /// </summary>
      class function ReadObjectFromString(const data: PByte; len: Py_ssize_t): IPyObject; overload;
      /// <summary>
      /// <para>Return a Python object from the data stream in a string.</para>
      /// <para>On error, sets the appropriate exception (EOFError, ValueError
      /// or TypeError) and returns nil.</para>
      /// </summary>
      class function ReadObjectFromString(const data: string): IPyObject; overload;
      {$IFDEF DELPHI12_UP}
      /// <summary>
      /// <para>Return a Python object from the data stream in an ansi
      /// string.</para>
      /// <para>On error, sets the appropriate exception (EOFError, ValueError
      /// or TypeError) and returns nil.</para>
      /// </summary>
      class function ReadObjectFromString(const data: AnsiString): IPyObject; overload;
      {$ENDIF}
      /// <summary>
      /// <para>Return a bytes object containing the marshalled representation
      /// of value. version indicates the file format.</para>
      /// </summary>
      class function WriteObjectToString(const value: IPyObject; version: integer): IPyObject;
      /// <summary>
      /// <para>Return a C long from the data stream in a PFILE opened for
      /// reading. Only a 32-bit value can be read in using this function,
      /// regardless of the native size of long.</para>
      /// <para>On error, sets the appropriate exception (EOFError) and
      /// returns -1.</para>
      /// </summary>
      class function ReadLongFromFile(file_: PFILE): C_Long;
      /// <summary>
      /// <para>Return a C short from the data stream in a PFILE opened for
      /// reading. Only a 16-bit value can be read in using this function,
      /// regardless of the native size of short.</para>
      /// <para>On error, sets the appropriate exception (EOFError) and
      /// returns -1.</para>
      /// </summary>
      class function ReadShortFromFile(file_: PFILE): integer;
      /// <summary>
      /// <para>Return a Python object from the data stream in a PFILE opened
      /// for reading.</para>
      /// <para>On error, sets the appropriate exception (EOFError, ValueError
      /// or TypeError) and returns nil.</para>
      /// </summary>
      class function ReadObjectFromFile(file_: PFILE): IPyObject;
      /// <summary>
      /// <para>Return a Python object from the data stream in a PFILE opened
      /// for reading. Unlike TPyMarshal.ReadObjectFromFile(), this function
      /// assumes that no further objects will be read from the file, allowing
      /// it to aggressively load file data into memory so that the
      /// de-serialization can operate from data in memory rather than reading
      /// a byte at a time from the file. Only use this variant if you are
      /// certain that you won't be reading anything else from the file.</para>
      /// <para>On error, sets the appropriate exception (EOFError, ValueError
      /// or TypeError) and returns nil.</para>
      /// </summary>
      class function ReadLastObjectFromFile(file_: PFILE): IPyObject;
      /// <summary>
      /// <para>Marshal a long integer, value, to file. This will only write
      /// the least-significant 32 bits of value; regardless of the size of the
      /// native long type. version indicates the file format.</para>
      /// <para>This function can fail, in which case it sets the error
      /// indicator. Use TPyErr.Occurred() to check for that.</para>
      /// <para>Note: In Python 3.15 and earlier, this function does not set
      /// the error indicator if writing to file fails. The same caveat applies
      /// as for TPyMarshal.WriteObjectToFile().</para>
      /// </summary>
      class procedure WriteLongToFile(value: C_Long; file_: PFILE; version: integer);
      /// <summary>
      /// <para>Marshal a Python object, value, to file. version indicates the
      /// file format.</para>
      /// <para>This function can fail, in which case it sets the error
      /// indicator. Use TPyErr.Occurred() to check for that.</para>
      /// <para>Note: In Python 3.15 and earlier, this function can write only
      /// part of the data to file and return without setting the error
      /// indicator, for example if value contains an object which cannot be
      /// marshalled or if writing to file fails (see gh-155907). Code which
      /// has to support these versions cannot rely on TPyErr.Occurred() alone
      /// to know that all the data was written. It can use
      /// TPyMarshal.WriteObjectToString() and write the result itself, or
      /// validate what was written.</para>
      /// </summary>
      class procedure WriteObjectToFile(const value: IPyObject; file_: PFILE; version: integer);
  end;

implementation

uses
  uP4P.MiscFunctions;

class function TPyMarshal.ReadObjectFromStream(const data: TMemoryStream): IPyObject;
begin
  if assigned(PyMarshal_ReadObjectFromString) then
    Result := TPyObject.Wrap(PyMarshal_ReadObjectFromString(PAnsiChar(data.Memory), data.size))
   else
    Result := nil;
end;

class function TPyMarshal.ReadObjectFromString(const data: PByte; len: Py_ssize_t): IPyObject;
begin
  if assigned(PyMarshal_ReadObjectFromString) then
    Result := TPyObject.Wrap(PyMarshal_ReadObjectFromString(PAnsiChar(data), len))
   else
    Result := nil;
end;

class function TPyMarshal.ReadObjectFromString(const data: string): IPyObject;
var
  TempData: AnsiString;
begin
  if assigned(PyMarshal_ReadObjectFromString) then
    begin
      TempData := StringToPyUTF8(data);
      Result   := TPyObject.Wrap(PyMarshal_ReadObjectFromString(PAnsiChar(TempData), length(TempData)));
    end
   else
    Result := nil;
end;

{$IFDEF DELPHI12_UP}
class function TPyMarshal.ReadObjectFromString(const data: AnsiString): IPyObject;
begin
  if assigned(PyMarshal_ReadObjectFromString) then
    Result := TPyObject.Wrap(PyMarshal_ReadObjectFromString(PAnsiChar(data), length(data)))
   else
    Result := nil;
end;
{$ENDIF}

class function TPyMarshal.WriteObjectToString(const value: IPyObject; version: integer): IPyObject;
begin
  if assigned(PyMarshal_WriteObjectToString) and
     TPyObject.IsInitialized(value) then
    Result := TPyObject.Wrap(PyMarshal_WriteObjectToString(value.PyObject, version))
   else
    Result := nil;
end;

class function TPyMarshal.ReadLongFromFile(file_: PFILE): C_Long;
begin
  if assigned(PyMarshal_ReadLongFromFile) then
    Result := PyMarshal_ReadLongFromFile(file_)
   else
    Result := -1;
end;

class function TPyMarshal.ReadShortFromFile(file_: PFILE): integer;
begin
  if assigned(PyMarshal_ReadShortFromFile) then
    Result := PyMarshal_ReadShortFromFile(file_)
   else
    Result := -1;
end;

class function TPyMarshal.ReadObjectFromFile(file_: PFILE): IPyObject;
begin
  if assigned(PyMarshal_ReadObjectFromFile) then
    Result := TPyObject.Wrap(PyMarshal_ReadObjectFromFile(file_))
   else
    Result := nil;
end;

class function TPyMarshal.ReadLastObjectFromFile(file_: PFILE): IPyObject;
begin
  if assigned(PyMarshal_ReadLastObjectFromFile) then
    Result := TPyObject.Wrap(PyMarshal_ReadLastObjectFromFile(file_))
   else
    Result := nil;
end;

class procedure TPyMarshal.WriteLongToFile(value: C_Long; file_: PFILE; version: integer);
begin
  if assigned(PyMarshal_WriteLongToFile) then
    PyMarshal_WriteLongToFile(value, file_, version);
end;

class procedure TPyMarshal.WriteObjectToFile(const value: IPyObject; file_: PFILE; version: integer);
begin
  if assigned(PyMarshal_WriteObjectToFile) and
     TPyObject.IsInitialized(value) then
    PyMarshal_WriteObjectToFile(value.PyObject, file_, version);
end;

end.
