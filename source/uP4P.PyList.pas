unit uP4P.PyList;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.Variants, System.Types,
  {$ELSE}
    Classes, Variants, Types,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// Helper class for all PyList_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/list.html#list-objects">See the article about List Objects.</see></para>
  /// </remarks>
  TPyList = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is a list object or an instance of a
      /// subtype of the list type. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if aPyObject is a list object, but not an instance
      /// of a subtype of the list type. This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return a new list of length len on success, or nil on
      /// failure.</para>
      /// <para>Note: If len is greater than zero, the returned list
      /// object's items are set to nil. Thus you cannot use abstract API
      /// functions such as TPySequence.SetItem() or expose the object to
      /// Python code before setting all items to a real object with
      /// TPyList.SetItem(). The following APIs are safe APIs before the list
      /// is fully initialized: TPyList.SetItem().</para>
      /// </summary>
      class function New(len: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Return the length of the list object in list; this is equivalent
      /// to len(list) on a list object.</para>
      /// </summary>
      class function Size(const list: IPyObject): Py_ssize_t;
      /// <summary>
      /// <para>Like TPyList.GetItemRef(), but returns a borrowed reference
      /// instead of a strong reference.</para>
      /// <para>Note: In the free-threaded build, the returned borrowed
      /// reference may become invalid if another thread modifies the list
      /// concurrently. Prefer TPyList.GetItemRef(), which returns a strong
      /// reference.</para>
      /// </summary>
      class function GetItem(const list: IPyObject; index: Py_ssize_t): IPyObject; overload;
      /// <summary>
      /// <para>Like TPyList.GetItemRef(), but returns a borrowed reference
      /// instead of a strong reference.</para>
      /// <para>Note: In the free-threaded build, the returned borrowed
      /// reference may become invalid if another thread modifies the list
      /// concurrently. Prefer TPyList.GetItemRef(), which returns a strong
      /// reference.</para>
      /// </summary>
      class function GetItem(const list: IPyObject; const index: TVarData): IPyObject; overload;
      /// <summary>
      /// <para>Return the object at position index in the list pointed to by
      /// list. The position must be non-negative; indexing from the end of the
      /// list is not supported. If index is out of bounds (<0 or >=len(list)),
      /// return nil and set an IndexError exception.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function GetItemRef(const list: IPyObject; index: Py_ssize_t): IPyObject; overload;
      /// <summary>
      /// <para>Return the object at position index in the list pointed to by
      /// list. The position must be non-negative; indexing from the end of the
      /// list is not supported. If index is out of bounds (<0 or >=len(list)),
      /// return nil and set an IndexError exception.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function GetItemRef(const list: IPyObject; const index: TVarData): IPyObject; overload;
      /// <summary>
      /// <para>Set the item at index index in list to item. Return True on
      /// success. If index is out of bounds, return False and set an
      /// IndexError exception.</para>
      /// <para>Note: This function "steals" a reference to item, even on error.
      /// On success, it discards a reference to an item already in the list at
      /// the affected position (unless it was nil).</para>
      /// </summary>
      class function SetItem(const list: IPyObject; index: Py_ssize_t; const item: IPyObject): boolean; overload;
      /// <summary>
      /// <para>Set the item at index index in list to item. Return True on
      /// success. If index is out of bounds, return False and set an
      /// IndexError exception.</para>
      /// <para>Note: This function "steals" a reference to item, even on error.
      /// On success, it discards a reference to an item already in the list at
      /// the affected position (unless it was nil).</para>
      /// </summary>
      class function SetItem(const list: IPyObject; index: Py_ssize_t; const item: string): boolean; overload;
      /// <summary>
      /// <para>Set the item at index index in list to item. Return True on
      /// success. If index is out of bounds, return False and set an
      /// IndexError exception.</para>
      /// <para>Note: This function "steals" a reference to item, even on error.
      /// On success, it discards a reference to an item already in the list at
      /// the affected position (unless it was nil).</para>
      /// </summary>
      class function SetItem(const list: IPyObject; index: Py_ssize_t; const item: C_Long): boolean; overload;
      /// <summary>
      /// <para>Set the item at index index in list to item. Return True on
      /// success. If index is out of bounds, return False and set an
      /// IndexError exception.</para>
      /// <para>Note: This function "steals" a reference to item, even on error.
      /// On success, it discards a reference to an item already in the list at
      /// the affected position (unless it was nil).</para>
      /// </summary>
      class function SetItem(const list: IPyObject; const index, item: TVarData): boolean; overload;
      /// <summary>
      /// <para>Insert the item item into list list in front of index index.
      /// Return True if successful; return False and set an exception if
      /// unsuccessful. Analogous to list.insert(index, item).</para>
      /// </summary>
      class function Insert(const list: IPyObject; index: Py_ssize_t; const item: IPyObject): boolean;
      /// <summary>
      /// <para>Append the object item at the end of list list. Return True if
      /// successful; return False and set an exception if unsuccessful.
      /// Analogous to list.append(item).</para>
      /// </summary>
      class function Append(const list, item: IPyObject): boolean;
      /// <summary>
      /// <para>Return a list of the objects in list containing the objects
      /// between low and high. Return nil and set an exception if unsuccessful.
      /// Analogous to list[low:high]. Indexing from the end of the list is not
      /// supported.</para>
      /// </summary>
      class function GetSlice(const list: IPyObject; low, high: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Set the slice of list between low and high to the contents of
      /// itemlist. Analogous to list[low:high] = itemlist. The itemlist may be
      /// nil, indicating the assignment of an empty list (slice deletion).
      /// Return True on success, False on failure. Indexing from the end of
      /// the list is not supported.</para>
      /// <para>Note: In the free-threaded build, when itemlist is a list, both
      /// list and itemlist are locked for the duration of the operation.
      /// For other iterables (or nil), only list is locked.</para>
      /// </summary>
      class function SetSlice(const list: IPyObject; low, high: Py_ssize_t; const itemlist: IPyObject): boolean;
      /// <summary>
      /// <para>Sort the items of list in place. Return True on success, False
      /// on failure. This is equivalent to list.sort().</para>
      /// <para>Note: In the free-threaded build, element comparison via
      /// __lt__() can execute arbitrary Python code, during which the
      /// per-object lock may be temporarily released. For built-in types
      /// (str, int, float), the lock is not released during comparison.</para>
      /// </summary>
      class function Sort(const list: IPyObject): boolean;
      /// <summary>
      /// <para>Reverse the items of list in place. Return True on success,
      /// False on failure. This is the equivalent of list.reverse().</para>
      /// </summary>
      class function Reverse(const list: IPyObject): boolean;
      /// <summary>
      /// <para>Return a new tuple object containing the contents of list;
      /// equivalent to tuple(list).</para>
      /// </summary>
      class function AsTuple(const list: IPyObject): IPyObject;
      /// <summary>
      /// <para>Extend list with the contents of iterable. This is the same as
      /// TPyList.SetSlice(list, PY_SSIZE_T_MAX, PY_SSIZE_T_MAX, iterable) and
      /// analogous to list.extend(iterable) or list += iterable.</para>
      /// <para>Raise an exception and return False if list is not a list
      /// object. Return True on success.</para>
      /// <para>Added in version 3.13.</para>
      /// <para>Note: In the free-threaded build, when iterable is a list, set,
      /// dict, or dict view, both list and iterable (or its underlying dict)
      /// are locked for the duration of the operation. For other iterables,
      /// only list is locked; iterable may be concurrently modified by another
      /// thread.</para>
      /// </summary>
      class function Extend(const self_, iterable: IPyObject): boolean;
      /// <summary>
      /// <para>Remove all items from list. This is the same as
      /// TPyList.SetSlice(list, 0, PY_SSIZE_T_MAX, nil) and analogous to
      /// list.clear() or del list[:].</para>
      /// <para>Raise an exception and return False if list is not a list
      /// object. Return True on success.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function Clear(const self_: IPyObject): boolean;
      /// <summary>
      /// <para>Custom function that creates a new list object and populates
      /// the new list with the aItems array.</para>
      /// </summary>
      class function FromArray(const aItems: array of const) : IPyObject;
      /// <summary>
      /// <para>Custom function that creates a new list object and populates
      /// the new list with the aStringList string list.</para>
      /// </summary>
      class function FromStrings(const aStringList: TStringList) : IPyObject;
      /// <summary>
      /// <para>Custom function that creates a new list object and populates
      /// the new list with the aStrings string array.</para>
      /// </summary>
      class function FromStringDynArray(const aStrings: TStringDynArray) : IPyObject;
      /// <summary>
      /// <para>Custom function that creates a new list object and populates
      /// the new list with the objects array.</para>
      /// </summary>
      class function FromObjects(const objects: IPyObjectArray): IPyObject;
      /// <summary>
      /// <para>Wrap a Variant with a python list object.</para>
      /// </summary>
      class function FromVariant(const aVariant: Variant): IPyObject; overload;
      /// <summary>
      /// <para>Wrap a Variant with a python list object.</para>
      /// </summary>
      class function FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject; overload;
      /// <summary>
      /// <para>Custom function used to copy the list items in a string
      /// list.</para>
      /// </summary>
      class function AsStrings(const aPyObject: IPyObject; var aStringList: TStringList): boolean;
      /// <summary>
      /// <para>Custom function that creates a new list object and populates
      /// the new list with the aVariant array</para>
      /// </summary>
      class function FromVariantArray(const aVariant: Variant; dim, totaldim: integer; var indices: TCustomIntArray): IPyObject;
  end;

implementation

uses
  uP4P.PyType, uP4P.PyUnicode, uP4P.PyLong;

class function TPyList.New(len: Py_ssize_t): IPyObject;
begin
  if assigned(PyList_New) then
    Result := TPyObject.Wrap(PyList_New(len))
   else
    Result := nil;
end;

class function TPyList.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            TPyType.FastSubclass(aPyObject.PyTypeObject, C_ULong(Py_TPFLAGS_LIST_SUBCLASS));
end;

class function TPyList.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyList_Type);
end;

class function TPyList.Size(const list: IPyObject): Py_ssize_t;
begin
  if assigned(PyList_Size) and
     TPyObject.IsInitialized(list) then
    Result := PyList_Size(list.PyObject)
   else
    Result := -1;
end;

class function TPyList.GetItem(const list: IPyObject; index: Py_ssize_t): IPyObject;
begin
  if assigned(PyList_GetItem) then
    Result := TPyObject.Wrap(PyList_GetItem(list.PyObject, index), False)
   else
    Result := nil;
end;

class function TPyList.GetItem(const list: IPyObject; const index: TVarData): IPyObject;
var
  TempIndex : integer;
begin
  TempIndex := Variant(index);
  Result    := GetItem(list, TempIndex);
end;

class function TPyList.GetItemRef(const list: IPyObject; index: Py_ssize_t): IPyObject;
begin
  if assigned(PyList_GetItemRef) then
    Result := TPyObject.Wrap(PyList_GetItemRef(list.PyObject, index))
   else
    Result := nil;
end;

class function TPyList.GetItemRef(const list: IPyObject; const index: TVarData): IPyObject;
var
  TempIndex : integer;
begin
  TempIndex := Variant(index);
  Result    := GetItemRef(list, TempIndex);
end;

class function TPyList.SetItem(const list: IPyObject; index: Py_ssize_t; const item: IPyObject): boolean;
begin
  Result := assigned(PyList_SetItem) and
            TPyObject.IsInitialized(list) and
            TPyObject.IsInitialized(item) and
            (PyList_SetItem(list.PyObject, index, item.UnWrap) = 0);
end;

class function TPyList.SetItem(const list: IPyObject; index: Py_ssize_t; const item: string): boolean;
var
  TempItem: IPyObject;
begin
  TempItem := TPyUnicode.FromString(item);
  Result   := SetItem(list, index, TempItem);
  TempItem := nil;
end;

class function TPyList.SetItem(const list: IPyObject; index: Py_ssize_t; const item: C_Long): boolean;
var
  TempItem: IPyObject;
begin
  TempItem := TPyLong.FromLong(item);
  Result   := SetItem(list, index, TempItem);
  TempItem := nil;
end;

class function TPyList.SetItem(const list: IPyObject; const index, item: TVarData): boolean;
var
  TempIndex : integer;
  TempItem  : IPyObject;
begin
  try
    TempIndex := Variant(index);
    TempItem  := TPyObject.FromVarData(item);
    Result    := SetItem(list, TempIndex, TempItem);
  finally
    TempItem  := nil;
  end;
end;

class function TPyList.Insert(const list: IPyObject; index: Py_ssize_t; const item: IPyObject): boolean;
begin
  Result := assigned(PyList_Insert) and
            TPyObject.IsInitialized(list) and
            TPyObject.IsInitialized(item) and
            (PyList_Insert(list.PyObject, index, item.PyObject) = 0);
end;

class function TPyList.Append(const list, item: IPyObject): boolean;
begin
  Result := assigned(PyList_Append) and
            TPyObject.IsInitialized(list) and
            TPyObject.IsInitialized(item) and
            (PyList_Append(list.PyObject, item.PyObject) = 0);
end;

class function TPyList.GetSlice(const list: IPyObject; low, high: Py_ssize_t): IPyObject;
begin
  if assigned(PyList_GetSlice) and
     TPyObject.IsInitialized(list) then
    Result := TPyObject.Wrap(PyList_GetSlice(list.PyObject, low, high))
   else
    Result := nil;
end;

class function TPyList.SetSlice(const list: IPyObject; low, high: Py_ssize_t; const itemlist: IPyObject): boolean;
begin
  Result := assigned(PyList_SetSlice) and
            TPyObject.IsInitialized(list) and
            TPyObject.IsInitialized(itemlist) and
            (PyList_SetSlice(list.PyObject, low, high, itemlist.PyObject) = 0);
end;

class function TPyList.Sort(const list: IPyObject): boolean;
begin
  Result := assigned(PyList_Sort) and
            TPyObject.IsInitialized(list) and
            (PyList_Sort(list.PyObject) = 0);
end;

class function TPyList.Reverse(const list: IPyObject): boolean;
begin
  Result := assigned(PyList_Reverse) and
            TPyObject.IsInitialized(list) and
            (PyList_Reverse(list.PyObject) = 0);
end;

class function TPyList.AsTuple(const list: IPyObject): IPyObject;
begin
  if assigned(PyList_AsTuple) and
     TPyObject.IsInitialized(list) then
    Result := TPyObject.Wrap(PyList_AsTuple(list.PyObject))
   else
    Result := nil;
end;

class function TPyList.Extend(const self_, iterable: IPyObject): boolean;
begin
  Result := assigned(PyList_Extend) and
            TPyObject.IsInitialized(self_) and
            TPyObject.IsInitialized(iterable) and
            (PyList_Extend(self_.PyObject, iterable.PyObject) = 0);
end;

class function TPyList.Clear(const self_: IPyObject): boolean;
begin
  Result := assigned(PyList_Clear) and
            TPyObject.IsInitialized(self_) and
            (PyList_Clear(self_.PyObject) = 0);
end;

class function TPyList.FromArray(const aItems: array of const): IPyObject;
var
  i, TempLen : integer;
begin
  Result  := nil;
  TempLen := length(aItems);

  if (TempLen > 0) then
    begin
      Result := TPyList.New(TempLen);

      for i := 0 to pred(TempLen) do
        TPyList.SetItem(Result, i, TPyObject.FromVarRec(aItems[i]));
    end;
end;

class function TPyList.FromStrings(const aStringList: TStringList): IPyObject;
var
  i, TempLen : integer;
begin
  Result  := nil;
  TempLen := aStringList.Count;

  if (TempLen > 0) then
    begin
      Result := TPyList.New(TempLen);

      for i := 0 to pred(TempLen) do
        TPyList.SetItem(Result, i, TPyUnicode.FromString(aStringList[i]));
    end;
end;

class function TPyList.FromStringDynArray(const aStrings: TStringDynArray) : IPyObject;
var
  i, TempLen : integer;
begin
  Result  := nil;
  TempLen := length(aStrings);

  if (TempLen > 0) then
    begin
      Result := TPyList.New(TempLen);

      for i := 0 to pred(TempLen) do
        TPyList.SetItem(Result, i, TPyUnicode.FromString(aStrings[i]));
    end;
end;

class function TPyList.FromObjects(const objects: IPyObjectArray): IPyObject;
var
  i, TempLen : integer;
begin
  Result  := nil;
  TempLen := length(objects);

  if (TempLen > 0) then
    begin
      Result := TPyList.New(TempLen);

      for i := 0 to pred(TempLen) do
        TPyList.SetItem(Result, i, objects[i]);
    end;
end;

class function TPyList.FromVariantArray(const aVariant: Variant; dim, totaldim: integer; var indices: TCustomIntArray): IPyObject;
var
  i, j, TempHigh, TempLow : integer;
begin
  TempHigh := VarArrayHighBound(aVariant, dim);
  TempLow  := VarArrayLowBound(aVariant, dim);
  Result   := TPyList.New(TempHigh - TempLow + 1);

  j := 0;
  for i := TempLow to TempHigh do
    begin
      indices[dim] := i;

      if (dim < totaldim - 1) then
        TPyList.SetItem(Result, j, FromVariantArray(aVariant, dim + 1, totaldim, indices))
       else
        TPyList.SetItem(Result, j, TPyObject.FromVariant(VarArrayGet(aVariant, indices)));

      inc(j);
    end;
end;

class function TPyList.FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject;
var
  TempDimCount : integer;
  TempIdxArr   : TCustomIntArray;
begin
  Result := nil;

  if (aVarType = varArray) then
    begin
      TempDimCount := VarArrayDimCount(aVariant);
      TempIdxArr   := nil;

      if (TempDimCount > 0) then
        begin
          SetLength(TempIdxArr, TempDimCount);
          Result := FromVariantArray(aVariant, 0, TempDimCount, TempIdxArr);
        end;
    end;
end;

class function TPyList.FromVariant(const aVariant: Variant): IPyObject;
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

class function TPyList.AsStrings(const aPyObject: IPyObject; var aStringList: TStringList): boolean;
var
  i, TempLen : integer;
  TempItem : IPyObject;
begin
  Result  := False;
  TempLen := TPyList.Size(aPyObject);

  if (TempLen > 0) then
    begin
      if not(assigned(aStringList)) then
        aStringList := TStringList.Create
       else
        aStringList.Clear;

      for i := 0 to pred(TempLen) do
        begin
          TempItem := TPyList.GetItem(aPyObject, i);

          if TPyObject.IsInitialized(TempItem) then
            aStringList.Add(TempItem.AsString);
        end;

      Result := (aStringList.Count > 0);
    end;
end;

end.
