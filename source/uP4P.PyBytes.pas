unit uP4P.PyBytes;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.Variants,
  {$ELSE}
    Classes, Variants,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class for all PyBytes_* methods used to handle bytearray
  /// objects.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/bytes.html#bytes-objects">See the article about Bytes Objects.</see></para>
  /// </remarks>
  TPyBytes = class
    public
      /// <summary>
      /// <para>Return the length of the bytes in bytes object ob.</para>
      /// </summary>
      class function Size(const ob: IPyObject): Py_ssize_t;
      /// <summary>
      /// <para>Return a pointer to the contents of ob converted to
      /// string.</para>
      /// </summary>
      class function AsString(const ob: IPyObject): string;
      /// <summary>
      /// <para>Return a pointer to the contents of ob converted to
      /// AnsiString.</para>
      /// </summary>
      class function AsAnsiString(const ob: IPyObject): AnsiString;
      /// <summary>
      /// <para>Return a pointer to the contents of ob converted to
      /// WideString.</para>
      /// </summary>
      class function AsWideString(const ob: IPyObject): WideString;
      /// <summary>
      /// <para>Return a pointer to the contents of ob.</para>
      /// <para>The pointer refers to the internal buffer of ob, which consists
      /// of len(ob) + 1 bytes.</para>
      /// <para>The last byte in the buffer is always nil, regardless of whether
      /// there are any other nil bytes.</para>
      /// <para>The data must not be modified in any way, unless the object was
      /// just created using TPyBytes.FromStringAndSize(nil, size).</para>
      /// <para>It must not be deallocated. If o is not a bytes object at all,
      /// returns nil and raises TypeError.</para>
      /// <para>soft-deprecated:: 3.15 Use the PyBytesWriter API instead of
      /// TPyBytes.FromStringAndSize(nil, len).</para>
      /// </summary>
      class function AsBuffer(const ob: IPyObject): PByte;
      /// <summary>
      /// <para>Get the string representation of bytes. This function is
      /// currently used to implement bytes.__repr__() in Python.</para>
      /// <para>This function does not do type checking; it is undefined
      /// behavior to pass bytes as a non-bytes object or nil.</para>
      /// <para>If smartquotes is true, the representation will use a
      /// double-quoted string instead of single-quoted string when
      /// single-quotes are present in bytes. For example, the byte string
      /// 'Python' would be represented as b"'Python'" when smartquotes is true,
      /// or b'\'Python\'' when it is false.</para>
      /// <para>On success, this function returns a strong reference to a str
      /// object containing the representation. On failure, this returns nil
      /// with an exception set.</para>
      /// </summary>
      class function Repr(const ob: IPyObject; smartquotes: boolean): IPyObject;
      /// <summary>
      /// <para>Create a new bytes object in bytes_ containing the contents of
      /// newpart appended to bytes_; the caller will own the new
      /// reference.</para>
      /// <para>The reference to the old value of bytes_ will be "stolen".
      /// If the new object cannot be created, the old reference to bytes_
      /// will still be "stolen", the value of bytes_ will be set to nil, and
      /// the appropriate exception will be set.</para>
      /// <para>Note: If newpart implements the buffer protocol, then the buffer
      /// must not be mutated while the new bytes_ object is being
      /// created.</para>
      /// </summary>
      class procedure Concat(const bytes_, newpart: IPyObject);
      /// <summary>
      /// <para>Create a new bytes object in bytes_ containing the contents of
      /// newpart appended to bytes.</para>
      /// <para>This version releases the strong reference to newpart
      /// (i.e. decrements its reference count).</para>
      /// <para>Note: If newpart implements the buffer protocol, then the buffer
      /// must not be mutated while the new bytes_ object is being
      /// created.</para>
      /// </summary>
      class procedure ConcatAndDel(const bytes_, newpart: IPyObject);
      /// <summary>
      /// <para>Return the contents of the object ob through the output
      /// variables buffer and length. Returns True on success.</para>
      /// <para>If ob is not a bytes object at all, TPyBytes.AsStringAndSize()
      /// returns False and raises TypeError.</para>
      /// </summary>
      class function AsStringAndSize(const ob: IPyObject; var buffer: string; var length: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Return the contents of the object ob through the output
      /// variables buffer and length. Returns True on success.</para>
      /// <para>The buffer refers to an internal buffer of obj, which includes
      /// an additional nil byte at the end (not counted in length). The data
      /// must not be modified in any way, unless the object was just created
      /// using TPyBytes.FromStringAndSize(nil, size). It must not be
      /// deallocated. If ob is not a bytes object at all,
      /// TPyBytes.AsBufferAndSize() returns False and raises TypeError.</para>
      /// </summary>
      class function AsBufferAndSize(const ob: IPyObject; var buffer: PByte; var length: Py_ssize_t): boolean;
      /// <summary>
      /// <para>Return the contents of the object ob through the aStream
      /// variable. Returns True on success.</para>
      /// <para>If ob is not a bytes object at all, TPyBytes.AsBufferAndSize()
      /// returns False and raises TypeError.</para>
      /// </summary>
      class function AsStream(const ob: IPyObject; var aStream: TStream): boolean;
      /// <summary>
      /// <para>Similar to sep.join(iterable) in Python.</para>
      /// <para>sep must be Python bytes object. (Note that TPyUnicode.Join()
      /// accepts nil separator and treats it as a space, whereas
      /// TPyBytes.Join() doesn't accept nil separator.)</para>
      /// <para>iterable must be an iterable object yielding objects that
      /// implement the buffer protocol.</para>
      /// <para>On success, return a new bytes object. On error, set an
      /// exception and return nil.</para>
      /// <para>Added in version 3.14.</para>
      /// <para>Note: If iterable objects implement the buffer protocol, then
      /// the buffers must not be mutated while the new bytes object is being
      /// created.</para>
      /// </summary>
      class function Join(const sep, iterable: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return a new bytes object with a copy of the string str as
      /// value and length len on success, and nil on failure. If str is nil,
      /// the contents of the bytes object are uninitialized.</para>
      /// </summary>
      class function FromStringAndSize(const str: string; len: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Return a new bytes object with a copy of buffer as
      /// value and length len on success, and nil on failure. If buffer is nil,
      /// the contents of the bytes object are uninitialized.</para>
      /// </summary>
      class function FromBufferAndSize(const buffer: PByte; len: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Return a new bytes object with a copy of the string str as
      /// value on success, and nil on failure. The parameter str must not
      /// be nil; it will not be checked.</para>
      /// </summary>
      class function FromString(const str: string): IPyObject;
      /// <summary>
      /// <para>Return a new bytes object with a copy of buffer as
      /// value on success, and nil on failure. The parameter buffer must not
      /// be nil; it will not be checked.</para>
      /// </summary>
      class function FromBuffer(const buffer: PByte): IPyObject;
      /// <summary>
      /// <para>Return the bytes representation of object o that implements the
      /// buffer protocol.</para>
      /// <para>Note: If the object implements the buffer protocol, then the
      /// buffer must not be mutated while the bytes object is being
      /// created.</para>
      /// </summary>
      class function FromObject(const ob: IPyObject): IPyObject;
      /// <summary>
      /// <para>Wrap a Variant with a Python bytes object.</para>
      /// </summary>
      class function FromVariant(const aVariant: Variant): IPyObject; overload;
      /// <summary>
      /// <para>Wrap a Variant with a Python bytes object.</para>
      /// </summary>
      class function FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject; overload;
      /// <summary>
      /// <para>Unescape a backslash-escaped string s. s must not be nil.</para>
      /// <para>errors must be one of "strict", "replace", or "ignore".
      /// "strict" is used by default.</para>
      /// <para>On success, this function returns a strong reference to a Python
      /// bytes object containing the unescaped string. On failure, this
      /// function returns nil with an exception set.</para>
      /// </summary>
      class function DecodeEscape(const s: string; errors: TPyCodecErrors): IPyObject;
      /// <summary>
      /// <para>Return true if aPyObject is a bytes object or an instance of a
      /// subtype of the bytes type. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if the object o is a bytes object, but not an
      /// instance of a subtype of the bytes type. This function always
      /// succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyType;

class function TPyBytes.FromStringAndSize(const str: string; len: Py_ssize_t): IPyObject;
var
  TempString: AnsiString;
begin
  if assigned(PyBytes_FromStringAndSize) then
    begin
      TempString := StringToPyUTF8(str);
      Result     := TPyObject.Wrap(PyBytes_FromStringAndSize(PAnsiChar(TempString), len))
    end
   else
    Result := nil;
end;

class function TPyBytes.FromBufferAndSize(const buffer: PByte; len: Py_ssize_t): IPyObject;
begin
  if assigned(PyBytes_FromStringAndSize) then
    Result := TPyObject.Wrap(PyBytes_FromStringAndSize(PAnsiChar(buffer), len))
   else
    Result := nil;
end;

class function TPyBytes.FromString(const str: string): IPyObject;
var
  TempString: AnsiString;
begin
  if assigned(PyBytes_FromString) then
    begin
      TempString := StringToPyUTF8(str);
      Result     := TPyObject.Wrap(PyBytes_FromString(PAnsiChar(TempString)))
    end
   else
    Result := nil;
end;

class function TPyBytes.FromBuffer(const buffer: PByte): IPyObject;
begin
  if assigned(PyBytes_FromString) then
    Result := TPyObject.Wrap(PyBytes_FromString(PAnsiChar(buffer)))
   else
    Result := nil;
end;

class function TPyBytes.FromObject(const ob: IPyObject): IPyObject;
begin
  if assigned(PyBytes_FromObject) and TPyObject.IsInitialized(ob) then
    Result := TPyObject.Wrap(PyBytes_FromObject(ob.PyObject))
   else
    Result := nil;
end;

class function TPyBytes.FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject;
begin
  case aVarType of
    varOleStr,
    {$IFDEF SUPPORTS_VARUSTRING}
    varUString,
    {$ENDIF}
    varString  : Result := FromString(string(aVariant))
    else         Result := nil;
  end;
end;

class function TPyBytes.FromVariant(const aVariant: Variant): IPyObject;
var
  TempType    : TVarType;
  TempVariant : Variant;
begin
  TempVariant := aVariant;
  TempType    := varByRef or varVariant;

  while VarType(TempVariant) = TempType do
    TempVariant := Variant(PVarData(TVarData(TempVariant).VPointer)^);

  Result := FromVariant(TempVariant, VarType(TempVariant) and (VarTypeMask or VarArray));
end;

class function TPyBytes.DecodeEscape(const s: string; errors: TPyCodecErrors): IPyObject;
var
  TempString, TempErrors : AnsiString;
begin
  if assigned(PyBytes_DecodeEscape) then
    begin
      TempErrors := ErrorToAnsiString(errors);
      TempString := StringToPyUTF8(s);
      // Changed in version 3.9: unicode and recode_encoding are now unused.
      Result     := TPyObject.Wrap(PyBytes_DecodeEscape(PAnsiChar(TempString), length(TempString), PAnsiChar(TempErrors), 0, nil));
    end
   else
    Result := nil;
end;

class function TPyBytes.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            TPyType.FastSubclass(aPyObject.PyTypeObject, C_ULong(Py_TPFLAGS_BYTES_SUBCLASS));
end;

class function TPyBytes.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyBytes_Type);
end;

class function TPyBytes.Size(const ob: IPyObject): Py_ssize_t;
begin
  if assigned(PyBytes_Size) and TPyObject.IsInitialized(ob) then
    Result := PyBytes_Size(ob.PyObject)
   else
    Result := 0;
end;

class function TPyBytes.AsString(const ob: IPyObject): string;
begin
  if assigned(PyBytes_AsString) and TPyObject.IsInitialized(ob) then
    Result := PyUTF8ToString(PyBytes_AsString(ob.PyObject))
   else
    Result := '';
end;

class function TPyBytes.AsAnsiString(const ob: IPyObject): AnsiString;
begin
  if assigned(PyBytes_AsString) and TPyObject.IsInitialized(ob) then
    Result := PyBytes_AsString(ob.PyObject)
   else
    Result := '';
end;

class function TPyBytes.AsWideString(const ob: IPyObject): WideString;
begin
  if assigned(PyBytes_AsString) and TPyObject.IsInitialized(ob) then
    Result := PyUTF8ToWideString(PyBytes_AsString(ob.PyObject))
   else
    Result := '';
end;

class function TPyBytes.AsBuffer(const ob: IPyObject): PByte;
begin
  if assigned(PyBytes_AsString) and TPyObject.IsInitialized(ob) then
    Result := PByte(PyBytes_AsString(ob.PyObject))
   else
    Result := nil;
end;

class function TPyBytes.Repr(const ob: IPyObject; smartquotes: boolean): IPyObject;
begin
  if assigned(PyBytes_AsString) and TPyObject.IsInitialized(ob) then
    Result := TPyObject.Wrap(PyBytes_Repr(ob.PyObject, ord(smartquotes)))
   else
    Result := nil;
end;

class procedure TPyBytes.Concat(const bytes_, newpart: IPyObject);
var
  TempBytes : PPyObject;
begin
  if assigned(PyBytes_Concat) and
     TPyObject.IsInitialized(bytes_) and
     TPyObject.IsInitialized(newpart) then
    begin
      TempBytes := bytes_.UnWrap;

      PyBytes_Concat(@TempBytes, newpart.PyObject);

      if assigned(TempBytes) then
        begin
          bytes_.PyObject    := TempBytes;
          bytes_.ObjRefOwner := True;
        end;
    end;
end;

class procedure TPyBytes.ConcatAndDel(const bytes_, newpart: IPyObject);
var
  TempBytes : PPyObject;
begin
  if assigned(PyBytes_ConcatAndDel) and
     TPyObject.IsInitialized(bytes_) and
     TPyObject.IsInitialized(newpart) then
    begin
      TempBytes := bytes_.UnWrap;

      PyBytes_ConcatAndDel(@TempBytes, newpart.UnWrap);

      if assigned(TempBytes) then
        begin
          bytes_.PyObject    := TempBytes;
          bytes_.ObjRefOwner := True;
        end;
    end;
end;

class function TPyBytes.AsStringAndSize(const ob: IPyObject; var buffer: string; var length: Py_ssize_t): boolean;
var
  TempBuffer : PAnsiChar;
begin
  TempBuffer := nil;

  if assigned(PyBytes_AsStringAndSize) and
     TPyObject.IsInitialized(ob) and
     (PyBytes_AsStringAndSize(ob.PyObject, TempBuffer, length) = 0) then
    begin
      buffer := PyUTF8ToString(TempBuffer);
      Result := True;
    end
   else
    Result := False;
end;

class function TPyBytes.AsBufferAndSize(const ob: IPyObject; var buffer: PByte; var length: Py_ssize_t): boolean;
begin
  Result := assigned(PyBytes_AsStringAndSize) and
            TPyObject.IsInitialized(ob) and
            (PyBytes_AsStringAndSize(ob.PyObject, PAnsiChar(buffer), length) = 0);
end;

class function TPyBytes.AsStream(const ob: IPyObject; var aStream: TStream): boolean;
var
  TempBuffer : PAnsiChar;
  TempLen    : Py_ssize_t;
begin
  TempBuffer := nil;
  TempLen    := 0;

  if assigned(PyBytes_AsStringAndSize) and
     assigned(aStream) and
     TPyObject.IsInitialized(ob) and
     (PyBytes_AsStringAndSize(ob.PyObject, TempBuffer, TempLen) = 0) then
    begin
      aStream.WriteBuffer(TempBuffer^, TempLen);
      Result := True;
    end
   else
    Result := False;
end;

class function TPyBytes.Join(const sep, iterable: IPyObject): IPyObject;
begin
  if assigned(PyBytes_Join) and
     TPyObject.IsInitialized(sep) and
     TPyObject.IsInitialized(iterable) then
    Result := TPyObject.Wrap(PyBytes_Join(sep.PyObject, iterable.PyObject))
   else
    Result := nil;
end;

end.
