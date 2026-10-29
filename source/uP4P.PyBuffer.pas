unit uP4P.PyBuffer;

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
  /// TPyBuffer wraps a Py_buffer record and it's also a
  /// helper class for all PyBuffer_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/buffer.html">See the article about the Buffer Protocol.</see></para>
  /// </remarks>
  TPyBuffer = class(TInterfacedObject, IPyBuffer)
    protected
      FBuffer : Py_buffer;

      function GetInitialized: boolean;
      function GetBuffer: PPy_buffer;

    public
      constructor Create; overload;
      constructor Create(const aBuffer: Py_buffer); overload;
      destructor  Destroy; override;

      /// <summary>
      /// <para>Get the memory area pointed to by the indices inside the
      /// view. indices must point to an array of view->ndim indices.</para>
      /// </summary>
      function GetPointer(const indices: Py_ssize_t_array): Pointer; overload;
      /// <summary>
      /// <para>Copy contiguous len bytes from buf to view. fort can be 'C' or
      /// 'F' (for C-style or Fortran-style ordering). True is returned on
      /// success, False on error.</para>
      /// </summary>
      function FromContiguous(const buf: Pointer; len: Py_ssize_t; fort: TPyBufferOrder): boolean; overload;
      /// <summary>
      /// <para>Return True if the memory defined by the view is C-style
      /// (order is 'C') or Fortran-style (order is 'F') contiguous or
      /// either one (order is 'A'). Return False otherwise. This function
      /// always succeeds.</para>
      /// </summary>
      function IsContiguous(order: TPyBufferOrder): boolean; overload;
      /// <summary>
      /// <para>Handle buffer requests for an exporter that wants to expose buf
      /// of size len with writability set according to readonly. buf is
      /// interpreted as a sequence of unsigned bytes.</para>
      /// <para>The flags argument indicates the request type. This function
      /// always fills in view as specified by flags, unless buf has been
      /// designated as read-only and PyBUF_WRITABLE is set in flags.</para>
      /// <para>On success, set view->obj to a new reference to exporter and
      /// return True. Otherwise, raise BufferError, set view->obj to nil and
      /// return False;</para>
      /// <para>If this function is used as part of a getbufferproc, exporter
      /// MUST be set to the exporting object and flags must be passed
      /// unmodified. Otherwise, exporter MUST be nil.</para>
      /// </summary>
      function FillInfo(const exporter: IPyObject; buf: Pointer; len: Py_ssize_t; readonly, flags: Integer): boolean; overload;

      /// <summary>
      /// <para>Get the memory area pointed to by the indices inside the given
      /// view. indices must point to an array of view->ndim indices.</para>
      /// </summary>
      class function GetPointer(view: PPy_buffer; const indices: Py_ssize_t_array): Pointer; overload;
      /// <summary>
      /// <para>Return the implied itemsize from format. On error, raise an
      /// exception and return -1.</para>
      /// </summary>
      class function SizeFromFormat(const format: PAnsiChar): Py_ssize_t;
      /// <summary>
      /// <para>Copy len bytes from src to its contiguous representation in buf.
      /// order can be 'C' or 'F' or 'A' (for C-style or Fortran-style ordering
      /// or either one). True is returned on success, False on error.</para>
      /// <para>This function fails if len != src->len.</para>
      /// </summary>
      class function ToContiguous(buf: Pointer; src: PPy_buffer; len: Py_ssize_t; order: TPyBufferOrder): boolean;
      /// <summary>
      /// <para>Copy contiguous len bytes from buf to view. fort can be 'C' or
      /// 'F' (for C-style or Fortran-style ordering). True is returned on
      /// success, False on error.</para>
      /// </summary>
      class function FromContiguous(view: PPy_buffer; const buf: Pointer; len: Py_ssize_t; fort: TPyBufferOrder): boolean; overload;
      /// <summary>
      /// <para>Return True if the memory defined by the view is C-style
      /// (order is 'C') or Fortran-style (order is 'F') contiguous or
      /// either one (order is 'A'). Return False otherwise. This function
      /// always succeeds.</para>
      /// </summary>
      class function IsContiguous(view: PPy_buffer; order: TPyBufferOrder): boolean; overload;
      /// <summary>
      /// <para>Fill the strides array with byte-strides of a contiguous
      /// (C-style if order is 'C' or Fortran-style if order is 'F') array of
      /// the given shape with the given number of bytes per element.</para>
      /// </summary>
      class procedure FillContiguousStrides(ndims: Integer; shape, strides: PPy_ssize_t; itemsize: Integer; order: TPyBufferOrder);
      /// <summary>
      /// <para>Handle buffer requests for an exporter that wants to expose buf
      /// of size len with writability set according to readonly. buf is
      /// interpreted as a sequence of unsigned bytes.</para>
      /// <para>The flags argument indicates the request type. This function
      /// always fills in view as specified by flags, unless buf has been
      /// designated as read-only and PyBUF_WRITABLE is set in flags.</para>
      /// <para>On success, set view->obj to a new reference to exporter and
      /// return True. Otherwise, raise BufferError, set view->obj to nil and
      /// return False;</para>
      /// <para>If this function is used as part of a getbufferproc, exporter
      /// MUST be set to the exporting object and flags must be passed
      /// unmodified. Otherwise, exporter MUST be nil.</para>
      /// </summary>
      class function FillInfo(view: PPy_buffer; const exporter: IPyObject; buf: Pointer; len: Py_ssize_t; readonly, flags: Integer): boolean; overload;
      /// <summary>
      /// <para>Release the buffer view and release the strong reference
      /// (i.e. decrement the reference count) to the view's supporting object,
      /// view->obj. This function MUST be called when the buffer is no longer
      /// being used, otherwise reference leaks may occur.</para>
      /// <para>It is an error to call this function on a buffer that was not
      /// obtained via TPyObject.GetBuffer().</para>
      /// </summary>
      class procedure Release(view: PPy_buffer);

      /// <summary>
      /// <para>Returns true if the class is fully initialized.</para>
      /// </summary>
      property Initialized  : boolean               read GetInitialized;
      /// <summary>
      /// <para>Pointer to the Py_buffer record.</para>
      /// </summary>
      property Buffer       : PPy_buffer            read  GetBuffer;
  end;

implementation

constructor TPyBuffer.Create;
begin
  inherited Create;

  FillChar(FBuffer, SizeOf(FBuffer), #0);
end;

constructor TPyBuffer.Create(const aBuffer: Py_buffer);
begin
  inherited Create;

  FBuffer := aBuffer;
end;

destructor TPyBuffer.Destroy;
begin
  try
    if Initialized then
      Release(@FBuffer);
  finally
    inherited Destroy;
  end;
end;

function TPyBuffer.GetInitialized: boolean;
begin
  Result := assigned(FBuffer.buf);
end;

function TPyBuffer.GetBuffer: PPy_buffer;
begin
  Result := @FBuffer;
end;

function TPyBuffer.GetPointer(const indices: Py_ssize_t_array): Pointer;
begin
  Result := GetPointer(@FBuffer, indices);
end;

function TPyBuffer.FromContiguous(const buf: Pointer; len: Py_ssize_t; fort: TPyBufferOrder): boolean;
begin
  Result := FromContiguous(@FBuffer, buf, len, fort);
end;

function TPyBuffer.IsContiguous(order: TPyBufferOrder): boolean;
begin
  Result := IsContiguous(@FBuffer, order);
end;

function TPyBuffer.FillInfo(const exporter: IPyObject; buf: Pointer; len: Py_ssize_t; readonly, flags: Integer): boolean;
begin
  Result := FillInfo(@FBuffer, exporter, buf, len, readonly, flags);
end;

class function TPyBuffer.GetPointer(view: PPy_buffer; const indices: Py_ssize_t_array): Pointer;
begin
  if assigned(PyBuffer_GetPointer) and (length(indices) > 0) then
    Result := PyBuffer_GetPointer(view, @indices[0])
   else
    Result := nil;
end;

class function TPyBuffer.SizeFromFormat(const format: PAnsiChar): Py_ssize_t;
begin
  if assigned(PyBuffer_SizeFromFormat) then
    Result := PyBuffer_SizeFromFormat(format)
   else
    Result := -1;
end;

class function TPyBuffer.ToContiguous(buf: Pointer; src: PPy_buffer; len: Py_ssize_t; order: TPyBufferOrder): boolean;
var
  TempOrder : AnsiChar;
begin
  case order of
    pboC         : TempOrder := 'C';
    pboFortran   : TempOrder := 'F';
    else           TempOrder := 'A'; // pboEitherOne
  end;

  Result := assigned(PyBuffer_ToContiguous) and
            (PyBuffer_ToContiguous(buf, src, len, TempOrder) = 0);
end;

class function TPyBuffer.FromContiguous(view: PPy_buffer; const buf: Pointer; len: Py_ssize_t; fort: TPyBufferOrder): boolean;
var
  TempFort : AnsiChar;
begin
  Result := False;

  case fort of
    pboC       : TempFort := 'C';
    pboFortran : TempFort := 'F';
    else         exit;            // pboEitherOne
  end;

  Result := assigned(PyBuffer_FromContiguous) and
            (PyBuffer_FromContiguous(view, buf, len, TempFort) = 0);
end;

class function TPyBuffer.IsContiguous(view: PPy_buffer; order: TPyBufferOrder): boolean;
var
  TempOrder : AnsiChar;
begin
  case order of
    pboC         : TempOrder := 'C';
    pboFortran   : TempOrder := 'F';
    else           TempOrder := 'A'; // pboEitherOne
  end;

  Result := assigned(PyBuffer_IsContiguous) and
            (PyBuffer_IsContiguous(view, TempOrder) <> 0);
end;

class procedure TPyBuffer.FillContiguousStrides(ndims: Integer; shape, strides: PPy_ssize_t; itemsize: Integer; order: TPyBufferOrder);
var
  TempOrder : AnsiChar;
begin
  if assigned(PyBuffer_FillContiguousStrides) then
    begin
      case order of
        pboC       : TempOrder := 'C';
        pboFortran : TempOrder := 'F';
        else         exit;            // pboEitherOne
      end;

      PyBuffer_FillContiguousStrides(ndims, shape, strides, itemsize, TempOrder);
    end;
end;

class function TPyBuffer.FillInfo(view: PPy_buffer; const exporter: IPyObject; buf: Pointer; len: Py_ssize_t; readonly, flags: Integer): boolean;
begin
  Result := assigned(PyBuffer_FillInfo) and
            TPyObject.IsInitialized(exporter) and
            (PyBuffer_FillInfo(view, exporter.PyObject, buf, len, readonly, flags) = 0);
end;

class procedure TPyBuffer.Release(view: PPy_buffer);
begin
  if assigned(PyBuffer_Release) then
    PyBuffer_Release(view);
end;

end.
