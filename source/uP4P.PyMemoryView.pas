unit uP4P.PyMemoryView;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class for all PyMemoryView_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/memoryview.html">See the article about MemoryView objects.</see></para>
  /// </remarks>
  TPyMemoryView = class
    public
      /// <summary>
      /// <para>Return true if the object obj is a memoryview object. It is not
      /// currently allowed to create subclasses of memoryview. This function
      /// always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Create a memoryview object to a contiguous chunk of memory
      /// (in either C or Fortran order) from an object that defines the
      /// buffer interface. If memory is contiguous, the memoryview object
      /// points to the original memory. Otherwise, a copy is made and the
      /// memoryview points to a new bytes object.</para>
      /// <para>buffertype can be one of PyBUF_READ or PyBUF_WRITE.</para>
      /// </summary>
      class function GetContiguous(const obj: IPyObject; buffertype: integer; order: TPyMemoryViewOrder): IPyObject;
      /// <summary>
      /// <para>Create a memoryview object from an object that provides the
      /// buffer interface. If obj supports writable buffer exports, the
      /// memoryview object will be read/write, otherwise it may be either
      /// read-only or read/write at the discretion of the exporter.</para>
      /// </summary>
      class function FromObject(const obj: IPyObject): IPyObject;
      /// <summary>
      /// <para>Create a memoryview object using mem as the underlying buffer.
      /// flags can be one of PyBUF_READ or PyBUF_WRITE.</para>
      /// </summary>
      class function FromMemory(mem: Pointer; size_: Py_ssize_t; flags: integer): IPyObject;
      /// <summary>
      /// <para>Create a memoryview object wrapping the given buffer structure
      /// view. For simple byte buffers, TPyMemoryView.FromMemory() is the
      /// preferred function.</para>
      /// </summary>
      class function FromBuffer(const view: PPy_buffer): IPyObject; overload;
      /// <summary>
      /// <para>Create a memoryview object wrapping the given buffer structure
      /// view. For simple byte buffers, TPyMemoryView.FromMemory() is the
      /// preferred function.</para>
      /// </summary>
      class function FromBuffer(const view: IPyBuffer): IPyObject; overload;
  end;

implementation

class function TPyMemoryView.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyMemoryView_Type);
end;

class function TPyMemoryView.FromObject(const obj: IPyObject): IPyObject;
begin
  if assigned(PyMemoryView_FromObject) and TPyObject.IsInitialized(obj) then
    Result := TPyObject.Wrap(PyMemoryView_FromObject(obj.PyObject))
   else
    Result := nil;
end;

class function TPyMemoryView.FromMemory(mem: Pointer; size_: Py_ssize_t; flags: integer): IPyObject;
begin
  if assigned(PyMemoryView_FromMemory) then
    Result := TPyObject.Wrap(PyMemoryView_FromMemory(mem, size_, flags))
   else
    Result := nil;
end;

class function TPyMemoryView.FromBuffer(const view: PPy_buffer): IPyObject;
begin
  if assigned(PyMemoryView_FromBuffer) then
    Result := TPyObject.Wrap(PyMemoryView_FromBuffer(view))
   else
    Result := nil;
end;

class function TPyMemoryView.FromBuffer(const view: IPyBuffer): IPyObject;
begin
  if assigned(view) and view.Initialized then
    Result := FromBuffer(view.Buffer)
   else
    Result := nil;
end;

class function TPyMemoryView.GetContiguous(const obj: IPyObject; buffertype: integer; order: TPyMemoryViewOrder): IPyObject;
var
  TempOrder : AnsiChar;
begin
  case order of
    pmvoFortran : TempOrder := 'F';
    else          TempOrder := 'C';   // pmvoC
  end;

  if assigned(PyMemoryView_GetContiguous) and
     TPyObject.IsInitialized(obj) and
     ((buffertype = PyBUF_READ) or (buffertype = PyBUF_WRITE)) then
    Result := TPyObject.Wrap(PyMemoryView_GetContiguous(obj.PyObject, buffertype, TempOrder))
   else
    Result := nil;
end;

end.
