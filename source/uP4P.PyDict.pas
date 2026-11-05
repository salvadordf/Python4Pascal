unit uP4P.PyDict;

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
  /// Helper class for all PyDict_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/dict.html#dictionary-objects">See the article about the Dictionary Objects.</see></para>
  /// </remarks>
  TPyDict = class
    public
      /// <summary>
      /// <para>Return true if aPyObject is a dict object or an instance of a
      /// subtype of the dict type. This function always succeeds.</para>
      /// </summary>
      class function Check(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if aPyObject is a dict object, but not an instance
      /// of a subtype of the dict type. This function always succeeds.</para>
      /// </summary>
      class function CheckExact(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return a new empty dictionary, or nil on failure.</para>
      /// </summary>
      class function New: IPyObject;
      /// <summary>
      /// <para>Return a borrowed reference to the object from dictionary mp
      /// which has a key key. Return nil if the key key is missing without
      /// setting an exception.</para>
      /// <para>The first argument can be a dict or a frozendict.</para>
      /// <para>Note: Exceptions that occur while this calls __hash__() and
      /// __eq__() methods are silently ignored. Prefer the
      /// TPyDict.GetItemWithError() function instead.</para>
      /// <para>Note: In the free-threaded build, the returned borrowed
      /// reference may become invalid if another thread modifies the dictionary
      /// concurrently. Prefer TPyDict.GetItemRef(), which returns a strong
      /// reference.</para>
      /// <para>Changed in version 3.10: Calling this API without an attached
      /// thread state had been allowed for historical reason. It is no longer
      /// allowed.</para>
      /// <para>Changed in version 3.15: Also accept frozendict.</para>
      /// </summary>
      class function GetItem(const mp, key: IPyObject): IPyObject;
      /// <summary>
      /// <para>Variant of TPyDict.GetItem() that does not suppress exceptions.
      /// Return nil with an exception set if an exception occurred.
      /// Return nil without an exception set if the key wasn't present.</para>
      /// <para>Note: In the free-threaded build, the returned borrowed
      /// reference may become invalid if another thread modifies the dictionary
      /// concurrently. Prefer TPyDict.GetItemRef(), which returns a strong
      /// reference.</para>
      /// <para>Changed in version 3.15: Also accept frozendict.</para>
      /// </summary>
      class function GetItemWithError(const mp, key: IPyObject): IPyObject;
      /// <summary>
      /// <para>Insert val into the dictionary mp with a key of key. key must be
      /// hashable; if it isn't, TypeError will be raised. Return True on
      /// success or False on failure. This function does not "steal" a
      /// reference to val.</para>
      /// <para>Note: The operation is atomic on free threading when key is str,
      /// int, float, bool or bytes.</para>
      /// </summary>
      class function SetItem(const mp, key, val: IPyObject): boolean; overload;
      /// <summary>
      /// <para>Insert val into the dictionary mp with a key of key. key must be
      /// hashable; if it isn't, TypeError will be raised. Return True on
      /// success or False on failure. This function does not "steal" a
      /// reference to val.</para>
      /// <para>Note: The operation is atomic on free threading when key is str,
      /// int, float, bool or bytes.</para>
      /// </summary>
      class function SetItem(const mp, key, val: PPyObject): boolean; overload;
      /// <summary>
      /// <para>Insert val into the dictionary mp with a key of key. key must be
      /// hashable; if it isn't, TypeError will be raised. Return True on
      /// success or False on failure. This function does not "steal" a
      /// reference to val.</para>
      /// <para>Note: The operation is atomic on free threading when key is str,
      /// int, float, bool or bytes.</para>
      /// </summary>
      class function SetItem(const mp: IPyObject; const key: string; const val: IPyObject): boolean; overload;
      /// <summary>
      /// <para>Insert val into the dictionary mp with a key of key. key must be
      /// hashable; if it isn't, TypeError will be raised. Return True on
      /// success or False on failure. This function does not "steal" a
      /// reference to val.</para>
      /// <para>Note: The operation is atomic on free threading when key is str,
      /// int, float, bool or bytes.</para>
      /// </summary>
      class function SetItem(const mp: IPyObject; const key: string; val: PPyObject): boolean; overload;
      /// <summary>
      /// <para>Remove the entry in dictionary mp with key key. key must be
      /// hashable; if it isn't, TypeError is raised. If key is not in the
      /// dictionary, KeyError is raised. Return True on success or False on
      /// failure.</para>
      /// <para>Note: The operation is atomic on free threading when key is str,
      /// int, float, bool or bytes.</para>
      /// </summary>
      class function DelItem(const mp, key: IPyObject): boolean;
      /// <summary>
      /// <para>Empty an existing dictionary of all key-value pairs.</para>
      /// <para>Do nothing if the argument is not a dict or a dict
      /// subclass.</para>
      /// </summary>
      class procedure Clear(const mp: IPyObject);
      /// <summary>
      /// <para>Iterate over all key-value pairs in the dictionary p.
      /// The Py_ssize_t referred to by ppos must be initialized to 0 prior to
      /// the first call to this function to start the iteration; the function
      /// returns true for each pair in the dictionary, and false once all
      /// pairs have been reported. The parameters pkey and pvalue should
      /// either point to PyObject variables that will be filled in with each
      /// key and value, respectively, or may be nil. Any references returned
      /// through them are borrowed. ppos should not be altered during
      /// iteration. Its value represents offsets within the internal dictionary
      /// structure, and since the structure is sparse, the offsets are not
      /// consecutive.</para>
      /// <para>The first argument can be a dict or a frozendict.</para>
      /// <para>For example:</para>
      /// <code>
      /// PyObject *key, *value;
      /// Py_ssize_t pos = 0;
      ///
      /// while (PyDict_Next(self->dict, &pos, &key, &value)) {
      ///     /* do something interesting with the values... */
      ///     ...
      /// }
      /// </code>
      /// <para>The dictionary p should not be mutated during iteration.
      /// It is safe to modify the values of the keys as you iterate over the
      /// dictionary, but only so long as the set of keys does not change.
      /// For example:</para>
      /// <code>
      /// PyObject *key, *value;
      /// Py_ssize_t pos = 0;
      ///
      /// while (PyDict_Next(self->dict, &pos, &key, &value)) {
      ///     long i = PyLong_AsLong(value);
      ///     if (i == -1 && PyErr_Occurred()) {
      ///         return -1;
      ///     }
      ///     PyObject *o = PyLong_FromLong(i + 1);
      ///     if (o == NULL)
      ///         return -1;
      ///     if (PyDict_SetItem(self->dict, key, o) < 0) {
      ///         Py_DECREF(o);
      ///         return -1;
      ///     }
      ///     Py_DECREF(o);
      /// }
      /// </code>
      /// <para>The function is not thread-safe in the free-threaded build
      /// without external synchronization for a mutable dict. You can use
      /// Py_BEGIN_CRITICAL_SECTION to lock the dictionary while iterating
      /// over it:</para>
      /// <code>
      /// Py_BEGIN_CRITICAL_SECTION(self->dict);
      /// while (PyDict_Next(self->dict, &pos, &key, &value)) {
      ///     ...
      /// }
      /// Py_END_CRITICAL_SECTION();
      /// </code>
      /// <para>The function is thread-safe on a frozendict.</para>
      /// <para>Note On the free-threaded build, this function can be used
      /// safely inside a critical section. However, the references returned for
      /// pkey and pvalue are borrowed and are only valid while the critical
      /// section is held. If you need to use these objects outside the critical
      /// section or when the critical section can be suspended, create a strong
      /// reference (for example, using TPy.NewRef()).</para>
      /// <para>Changed in version 3.15: Also accept frozendict.</para>
      /// </summary>
      class function Next(const p: IPyObject; var pos: Py_ssize_t; out key, val: IPyObject): boolean;
      /// <summary>
      /// <para>Return a PyListObject containing all the keys from the
      /// dictionary.</para>
      /// <para>The first argument can be a dict or a frozendict.</para>
      /// <para>Changed in version 3.15: Also accept frozendict.</para>
      /// </summary>
      class function Keys(const mp: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return a PyListObject containing all the values from the
      /// dictionary mp.</para>
      /// <para>The first argument can be a dict or a frozendict.</para>
      /// <para>Changed in version 3.15: Also accept frozendict.</para>
      /// </summary>
      class function Values(const mp: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return a PyListObject containing all the items from the
      /// dictionary.</para>
      /// <para>The first argument can be a dict or a frozendict.</para>
      /// <para>Changed in version 3.15: Also accept frozendict.</para>
      /// </summary>
      class function Items(const mp: IPyObject): IPyObject;
      /// <summary>
      /// <para>Return the number of items in the dictionary. This is equivalent
      /// to len(mp) on a dictionary.</para>
      /// <para>The first argument can be a dict or a frozendict.</para>
      /// <para>Changed in version 3.15: Also accept frozendict.</para>
      /// </summary>
      class function Size(const mp: IPyObject): Py_ssize_t;
      /// <summary>
      /// <para>Return a new dictionary that contains the same key-value pairs
      /// as mp.</para>
      /// </summary>
      class function Copy(const mp: IPyObject): IPyObject;
      /// <summary>
      /// <para>Determine if dictionary p contains key. If an item in p matches
      /// key, return 1, otherwise return 0. On error, return -1. This is
      /// equivalent to the Python expression key in p.</para>
      /// <para>Note: The operation is atomic on free threading when key is
      /// str, int, float, bool or bytes.</para>
      /// <para>The first argument can be a dict or a frozendict.</para>
      /// <para>Changed in version 3.15: Also accept frozendict.</para>
      /// </summary>
      class function Contains(const p, key: IPyObject): integer; overload;
      /// <summary>
      /// <para>Determine if dictionary p contains key. If an item in p matches
      /// key, return 1, otherwise return 0. On error, return -1. This is
      /// equivalent to the Python expression key in p.</para>
      /// <para>Note: The operation is atomic on free threading when key is
      /// str, int, float, bool or bytes.</para>
      /// <para>The first argument can be a dict or a frozendict.</para>
      /// <para>Changed in version 3.15: Also accept frozendict.</para>
      /// </summary>
      class function Contains(const p: IPyObject; const key: string): integer; overload;
      /// <summary>
      /// <para>This is the same as TPyDict.Merge(a, b, 1), and is similar to
      /// a.update(b) in Python except that TPyDict.Update() doesn't fall back
      /// to the iterating over a sequence of key value pairs if the second
      /// argument has no "keys" attribute. Return True on success or False if
      /// an exception was raised.</para>
      /// <para>Note In the free-threaded build, when b is a dict (with the
      /// standard iterator), both a and b are locked for the duration of the
      /// operation. When b is a non-dict mapping, only a is locked; b may be
      /// concurrently modified by another thread.</para>
      /// </summary>
      class function Update(const mp, other: IPyObject): boolean;
      /// <summary>
      /// <para>Iterate over mapping object b adding key-value pairs to
      /// dictionary a. b may be a dictionary, or any object supporting
      /// TPyMapping.Keys() and TPyObject.GetItem(). If override is true,
      /// existing pairs in a will be replaced if a matching key is found in b,
      /// otherwise pairs will only be added if there is not a matching key in a.
      /// Return True on success or False if an exception was raised.</para>
      /// <para>Note: In the free-threaded build, when b is a dict
      /// (with the standard iterator), both a and b are locked for the duration
      /// of the operation. When b is a non-dict mapping, only a is locked;
      /// b may be concurrently modified by another thread.</para>
      /// </summary>
      class function Merge(const a, b: IPyObject; override_: boolean): boolean;
      /// <summary>
      /// <para>Update or merge into dictionary a, from the key-value pairs in
      /// seq2. seq2 must be an iterable object producing iterable objects of
      /// length 2, viewed as key-value pairs. In case of duplicate keys, the
      /// last wins if override is true, else the first wins. Return True on
      /// success or False if an exception was raised.
      /// Equivalent Python (except for the return value):</para>
      /// <code>
      /// def PyDict_MergeFromSeq2(a, seq2, override):
      ///     for key, value in seq2:
      ///         if override or key not in a:
      ///             a[key] = value
      /// </code>
      /// <para>Note: In the free-threaded build, only a is locked.
      /// The iteration over seq2 is not synchronized; seq2 may be concurrently
      /// modified by another thread.</para>
      /// </summary>
      class function MergeFromSeq2(const a, seq2: IPyObject; override_: boolean): boolean;
      /// <summary>
      /// <para>This is the same as TPyDict.GetItem(), but key is specified as
      /// a string, rather than a IPyObject.</para>
      /// <para>Note: Exceptions that occur while this calls __hash__() and
      /// __eq__() methods or while creating the temporary str object are
      /// silently ignored. Prefer using the TPyDict.GetItemWithError() function
      /// with your own TPyUnicode.FromString() key instead.</para>
      /// <para>Note: In the free-threaded build, the returned borrowed
      /// reference may become invalid if another thread modifies the dictionary
      /// concurrently. Prefer TPyDict.GetItemStringRef(), which returns a
      /// strong reference.</para>
      /// <para>Changed in version 3.15: Also accept frozendict.</para>
      /// </summary>
      class function GetItemString(const dp: IPyObject; const key: string): IPyObject; overload;
      {$IFDEF DELPHI12_UP}
      /// <summary>
      /// <para>This is the same as TPyDict.GetItem(), but key is specified as
      /// a AnsiString, rather than a IPyObject.</para>
      /// <para>Note: Exceptions that occur while this calls __hash__() and
      /// __eq__() methods or while creating the temporary str object are
      /// silently ignored. Prefer using the TPyDict.GetItemWithError() function
      /// with your own TPyUnicode.FromString() key instead.</para>
      /// <para>Note: In the free-threaded build, the returned borrowed
      /// reference may become invalid if another thread modifies the dictionary
      /// concurrently. Prefer TPyDict.GetItemStringRef(), which returns a
      /// strong reference.</para>
      /// <para>Changed in version 3.15: Also accept frozendict.</para>
      /// </summary>
      class function GetItemString(const dp: IPyObject; const key: AnsiString): IPyObject; overload;
      {$ENDIF}
      /// <summary>
      /// <para>This is the same as TPyDict.SetItem(), but key is specified as
      /// a string, rather than a IPyObject.</para>
      /// </summary>
      class function SetItemString(const dp: IPyObject; const key: string; const item: IPyObject): boolean; overload;
      {$IFDEF DELPHI12_UP}
      /// <summary>
      /// <para>This is the same as TPyDict.SetItem(), but key is specified as
      /// an AnsiString, rather than a IPyObject.</para>
      /// </summary>
      class function SetItemString(const dp: IPyObject; const key: AnsiString; const item: IPyObject): boolean; overload;
      {$ENDIF}
      /// <summary>
      /// <para>This is the same as TPyDict.DelItem(), but key is specified as
      /// a string, rather than a IPyObject.</para>
      /// </summary>
      class function DelItemString(const dp: IPyObject; const key: string): boolean; overload;
      {$IFDEF DELPHI12_UP}
      /// <summary>
      /// <para>This is the same as TPyDict.DelItem(), but key is specified as
      /// an AnsiString, rather than a IPyObject.</para>
      /// </summary>
      class function DelItemString(const dp: IPyObject; const key: AnsiString): boolean; overload;
      {$ENDIF}
      /// <summary>
      /// <para>Return a new strong reference to the object from dictionary p
      /// which has a key key:</para>
      /// <code>
      /// - If the key is present, set result_ to a new strong reference to the
      ///   value and return 1.
      /// - If the key is missing, set result_ to nil and return 0.
      /// - On error, raise an exception, set result_ to nil and return -1.
      /// </code>
      /// <para>The first argument can be a dict or a frozendict.</para>
      /// <para>Note: The operation is atomic on free threading when key is str,
      /// int, float, bool or bytes.</para>
      /// <para>Added in version 3.13.</para>
      /// <para>Changed in version 3.15: Also accept frozendict.</para>
      /// <para>See also the TPyObject.GetItem() function.</para>
      /// </summary>
      class function GetItemRef(const p, key: IPyObject; out result_: IPyObject): integer;
      /// <summary>
      /// <para>Similar to TPyDict.GetItemRef(), but key is specified as a
      /// string, rather than a IPyObject.</para>
      /// <para>Added in version 3.13.</para>
      /// <para>Changed in version 3.15: Also accept frozendict.</para>
      /// </summary>
      class function GetItemStringRef(const mp: IPyObject; const key: string; out result_: IPyObject): integer;
      /// <summary>
      /// <para>This is the same as the Python-level dict.setdefault().
      /// If present, it returns the value corresponding to key from the
      /// dictionary p. If the key is not in the dict, it is inserted with value
      /// defaultobj and defaultobj is returned. This function evaluates the
      /// hash function of key only once, instead of evaluating it independently
      /// for the lookup and the insertion.</para>
      /// <para>Added in version 3.4.</para>
      /// <para>Note: In the free-threaded build, the returned borrowed
      /// reference may become invalid if another thread modifies the dictionary
      /// concurrently. Prefer TPyDict.SetDefaultRef(), which returns a strong
      /// reference.</para>
      /// </summary>
      class function SetDefault(const p, key, defaultobj: IPyObject): IPyObject;
      /// <summary>
      /// <para>Inserts default_value into the dictionary p with a key of key
      /// if the key is not already present in the dictionary. If result is
      /// not nil, then result_ is set to a strong reference to either
      /// default_value, if the key was not present, or the existing value,
      /// if key was already present in the dictionary. Returns 1 if the key
      /// was present and default_value was not inserted, or 0 if the key was
      /// not present and default_value was inserted. On failure, returns -1,
      /// sets an exception, and sets result_ to nil.</para>
      /// <para>For clarity: if you have a strong reference to default_value
      /// before calling this function, then after it returns, you hold a
      /// strong reference to both default_value and result_ (if it's not nil).
      /// These may refer to the same object: in that case you hold two separate
      /// references to it.</para>
      /// <para>Note: The operation is atomic on free threading when key is str,
      /// int, float, bool or bytes.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function SetDefaultRef(const p, key, default_value: IPyObject; out result_: IPyObject): integer;
      /// <summary>
      /// <para>This is the same as TPyDict.Contains(), but key is specified
      /// as a string, rather than a IPyObject.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function ContainsString(const p: IPyObject; const key: string): integer;
      /// <summary>
      /// <para>Remove key from dictionary p and optionally return the removed
      /// value. Do not raise KeyError if the key is missing.</para>
      /// <code>
      /// - If the key is present, set result_ to a new reference to the removed
      ///   value if result is not nil, and return 1.
      /// - If the key is missing, set result_ to nil if result is not nil,
      ///   and return 0.
      /// - On error, raise an exception and return -1.
      /// </code>
      /// <para>Similar to dict.pop(), but without the default value and not
      /// raising KeyError if the key is missing.</para>
      /// <para>Note: The operation is atomic on free threading when key is str,
      /// int, float, bool or bytes.</para>
      /// <para>The first argument can be a dict or a frozendict.</para>
      /// <para>Added in version 3.13.</para>
      /// <para>Changed in version 3.15: Also accept frozendict.</para>
      /// </summary>
      class function Pop(const p, key: IPyObject; out result_: IPyObject): integer;
      /// <summary>
      /// <para>Similar to TPyDict.Pop(), but key is specified as a string,
      /// rather than a IPyObject.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function PopString(const p: IPyObject; const key: string; out result_: IPyObject): integer;
      /// <summary>
      /// <para>Register callback as a dictionary watcher. Return a non-negative
      /// integer id which must be passed to future calls to TPyDict.Watch().
      /// In case of error (e.g. no more watcher IDs available), return -1 and
      /// set an exception.</para>
      /// <para>Note: This function is not internally synchronized. In the
      /// free-threaded build, callers should ensure no concurrent calls to
      /// TPyDict.AddWatcher() or TPyDict.ClearWatcher() are in progress.</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      class function AddWatcher(callback: PyDict_WatchCallback): integer;
      /// <summary>
      /// <para>Clear watcher identified by watcher_id previously returned from
      /// TPyDict.AddWatcher(). Return True on success, False on error
      /// (e.g. if the given watcher_id was never registered.)</para>
      /// <para>Note: This function is not internally synchronized. In the
      /// free-threaded build, callers should ensure no concurrent calls to
      /// TPyDict.AddWatcher() or TPyDict.ClearWatcher() are in progress.</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      class function ClearWatcher(watcher_id: integer): boolean;
      /// <summary>
      /// <para>Mark dictionary dict as watched. The callback granted watcher_id
      /// by TPyDict.AddWatcher() will be called when dict is modified or
      /// deallocated. Return True on success or False on error.</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      class function Watch(watcher_id: integer; const dict: IPyObject): boolean;
      /// <summary>
      /// <para>Mark dictionary dict as no longer watched. The callback granted
      /// watcher_id by TPyDict.AddWatcher() will no longer be called when dict
      /// is modified or deallocated. The dict must previously have been watched
      /// by this watcher. Return True on success or False on error.</para>
      /// <para>Added in version 3.12.</para>
      /// </summary>
      class function Unwatch(watcher_id: integer; const dict: IPyObject): boolean;
      /// <summary>
      /// <para>Helper function that creates a PyDict and sets all the values
      /// from aValues.</para>
      /// </summary>
      class function FromStringsArray(const aKeys: TStringList; const aValues: array of const): IPyObject;
      /// <summary>
      /// <para>Helper function that creates a PyDict and sets all the values
      /// from NamedParamArray and Arguments.</para>
      /// </summary>
      class function FromNamedParamArray(const NamedParamArray: TNamedParamArray; const Arguments: TVarDataArray): IPyObject;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyType, uP4P.PyUnicode;

class function TPyDict.New: IPyObject;
begin
  if assigned(PyDict_New) then
    Result := TPyObject.Wrap(PyDict_New())
   else
    Result := nil;
end;

class function TPyDict.Check(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            TPyType.FastSubclass(aPyObject.PyTypeObject, C_ULong(Py_TPFLAGS_DICT_SUBCLASS));
end;

class function TPyDict.CheckExact(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(PyDict_Type);
end;

class function TPyDict.GetItem(const mp, key: IPyObject): IPyObject;
begin
  if assigned(PyDict_GetItem) and
     TPyObject.IsInitialized(mp) and
     TPyObject.IsInitialized(key) then
    Result := TPyObject.Wrap(PyDict_GetItem(mp.PyObject, key.PyObject), False)
   else
    Result := nil;
end;

class function TPyDict.GetItemWithError(const mp, key: IPyObject): IPyObject;
begin
  if assigned(PyDict_GetItemWithError) and
     TPyObject.IsInitialized(mp) and
     TPyObject.IsInitialized(key) then
    Result := TPyObject.Wrap(PyDict_GetItemWithError(mp.PyObject, key.PyObject), False)
   else
    Result := nil;
end;

class function TPyDict.SetItem(const mp, key, val: IPyObject): boolean;
begin
  Result := assigned(mp) and
            assigned(val) and
            assigned(key) and
            SetItem(mp.PyObject, key.PyObject, val.PyObject);
end;

class function TPyDict.SetItem(const mp, key, val: PPyObject): boolean;
begin
  Result := assigned(PyDict_SetItem) and
            assigned(mp) and
            assigned(key) and
            assigned(val) and
            (PyDict_SetItem(mp, key, val) = 0);
end;

class function TPyDict.SetItem(const mp: IPyObject; const key: string; const val: IPyObject): boolean;
var
  TempKey : IPyObject;
begin
  try
    TempKey := TPyUnicode.FromString(key);
    Result  := SetItem(mp, TempKey, val);
  finally
    TempKey := nil;
  end;
end;

class function TPyDict.SetItem(const mp: IPyObject; const key: string; val: PPyObject): boolean;
var
  TempKey : IPyObject;
begin
  Result := False;

  try
    if TPyObject.IsInitialized(mp) then
      begin
        TempKey := TPyUnicode.FromString(key);
        Result  := SetItem(mp.PyObject, TempKey.PyObject, val);
      end;
  finally
    TempKey := nil;
  end;
end;

class function TPyDict.DelItem(const mp, key: IPyObject): boolean;
begin
  Result := assigned(PyDict_DelItem) and
            TPyObject.IsInitialized(mp) and
            TPyObject.IsInitialized(key) and
            (PyDict_DelItem(mp.PyObject, key.PyObject) = 0);
end;

class procedure TPyDict.Clear(const mp: IPyObject);
begin
  if assigned(PyDict_Clear) and
     TPyObject.IsInitialized(mp) then
    PyDict_Clear(mp.PyObject);
end;

class function TPyDict.Next(const p: IPyObject; var pos: Py_ssize_t; out key, val: IPyObject): boolean;
var
  TempKey, TempVal: PPyObject;
begin
  Result := False;
  key    := nil;
  val    := nil;

  if assigned(PyDict_Next) and
     TPyObject.IsInitialized(p) and
     (PyDict_Next(p.PyObject, @pos, TempKey, TempVal) <> 0) and
     assigned(TempKey) and
     assigned(TempVal) then
    begin
      key    := TPyObject.Wrap(TempKey, False);
      val    := TPyObject.Wrap(TempVal, False);
      Result := True;
    end;
end;

class function TPyDict.Keys(const mp: IPyObject): IPyObject;
begin
  if assigned(PyDict_Keys) and TPyObject.IsInitialized(mp) then
    Result := TPyObject.Wrap(PyDict_Keys(mp.PyObject))
   else
    Result := nil;
end;

class function TPyDict.Values(const mp: IPyObject): IPyObject;
begin
  if assigned(PyDict_Values) and TPyObject.IsInitialized(mp) then
    Result := TPyObject.Wrap(PyDict_Values(mp.PyObject))
   else
    Result := nil;
end;

class function TPyDict.Items(const mp: IPyObject): IPyObject;
begin
  if assigned(PyDict_Items) and TPyObject.IsInitialized(mp) then
    Result := TPyObject.Wrap(PyDict_Items(mp.PyObject))
   else
    Result := nil;
end;

class function TPyDict.Size(const mp: IPyObject): Py_ssize_t;
begin
  if assigned(PyDict_Size) and TPyObject.IsInitialized(mp) then
    Result := PyDict_Size(mp.PyObject)
   else
    Result := -1;
end;

class function TPyDict.Copy(const mp: IPyObject): IPyObject;
begin
  if assigned(PyDict_Copy) and TPyObject.IsInitialized(mp) then
    Result := TPyObject.Wrap(PyDict_Copy(mp.PyObject))
   else
    Result := nil;
end;

class function TPyDict.Contains(const p, key: IPyObject): integer;
begin
  if assigned(PyDict_Contains) and
     TPyObject.IsInitialized(p) and
     TPyObject.IsInitialized(key) then
    Result := PyDict_Contains(p.PyObject, key.PyObject)
   else
    Result := -1;
end;

class function TPyDict.Contains(const p: IPyObject; const key: string): integer;
begin
  Result := Contains(p, TPyUnicode.FromString(key));
end;

class function TPyDict.Update(const mp, other: IPyObject): boolean;
begin
  Result := assigned(PyDict_Update) and
            TPyObject.IsInitialized(mp) and
            TPyObject.IsInitialized(other) and
            (PyDict_Update(mp.PyObject, other.PyObject) = 0);
end;

class function TPyDict.Merge(const a, b: IPyObject; override_: boolean): boolean;
begin
  Result := assigned(PyDict_Merge) and
            TPyObject.IsInitialized(a) and
            TPyObject.IsInitialized(b) and
            (PyDict_Merge(a.PyObject, b.PyObject, ord(override_)) = 0);
end;

class function TPyDict.MergeFromSeq2(const a, seq2: IPyObject; override_: boolean): boolean;
begin
  Result := assigned(PyDict_MergeFromSeq2) and
            TPyObject.IsInitialized(a) and
            TPyObject.IsInitialized(seq2) and
            (PyDict_MergeFromSeq2(a.PyObject, seq2.PyObject, ord(override_)) = 0);
end;

class function TPyDict.GetItemString(const dp: IPyObject; const key: string): IPyObject;
var
  TempKey : AnsiString;
begin
  if assigned(PyDict_GetItemString) and TPyObject.IsInitialized(dp) then
    begin
      TempKey := StringToPyUTF8(key);
      Result  := TPyObject.Wrap(PyDict_GetItemString(dp.PyObject, PAnsiChar(TempKey)), False);
    end
   else
    Result := nil;
end;

{$IFDEF DELPHI12_UP}
class function TPyDict.GetItemString(const dp: IPyObject; const key: AnsiString): IPyObject;
begin
  if assigned(PyDict_GetItemString) and TPyObject.IsInitialized(dp) then
    Result := TPyObject.Wrap(PyDict_GetItemString(dp.PyObject, PAnsiChar(key)), False)
   else
    Result := nil;
end;
{$ENDIF}

class function TPyDict.SetItemString(const dp: IPyObject; const key: string; const item: IPyObject): boolean;   
var
  TempKey : AnsiString;
begin
  if assigned(PyDict_SetItemString) and
     TPyObject.IsInitialized(dp) and
     TPyObject.IsInitialized(item) then
    begin           
      TempKey := StringToPyUTF8(key);
      Result  := (PyDict_SetItemString(dp.PyObject, PAnsiChar(TempKey), item.PyObject) = 0);
    end
   else
    Result := False;
end;

{$IFDEF DELPHI12_UP}
class function TPyDict.SetItemString(const dp: IPyObject; const key: AnsiString; const item: IPyObject): boolean;
begin
  if assigned(PyDict_SetItemString) and
     TPyObject.IsInitialized(dp) and
     TPyObject.IsInitialized(item) then
    Result := (PyDict_SetItemString(dp.PyObject, PAnsiChar(key), item.PyObject) = 0)
   else
    Result := False;
end;  
{$ENDIF}

class function TPyDict.DelItemString(const dp: IPyObject; const key: string): boolean;
var
  TempString: AnsiString;
begin
  if assigned(PyDict_DelItemString) and
     TPyObject.IsInitialized(dp) then
    begin
      TempString := StringToPyUTF8(key);
      Result     := (PyDict_DelItemString(dp.PyObject, PAnsiChar(TempString)) = 0)
    end
   else
    Result := False;
end;

{$IFDEF DELPHI12_UP}
class function TPyDict.DelItemString(const dp: IPyObject; const key: AnsiString): boolean;
begin
  if assigned(PyDict_DelItemString) and
     TPyObject.IsInitialized(dp) then
    Result := (PyDict_DelItemString(dp.PyObject, PAnsiChar(key)) = 0)
   else
    Result := False;
end;
{$ENDIF}

class function TPyDict.GetItemRef(const p, key: IPyObject; out result_: IPyObject): integer;
var
  TempResult : PPyObject;
begin
  if assigned(PyDict_GetItemRef) and
     TPyObject.IsInitialized(p) and
     TPyObject.IsInitialized(key) then
    begin
      TempResult := nil;
      Result     := PyDict_GetItemRef(p.PyObject, key.PyObject, @TempResult);
      result_    := TPyObject.Wrap(TempResult);
    end
   else
    begin
      result_ := nil;
      Result  := 0;
    end;
end;

class function TPyDict.GetItemStringRef(const mp: IPyObject; const key: string; out result_: IPyObject): integer;
var
  TempString : AnsiString;
  TempResult : PPyObject;
begin
  if assigned(PyDict_GetItemStringRef) and
     TPyObject.IsInitialized(mp) then
    begin
      TempResult := nil;
      TempString := StringToPyUTF8(key);
      Result     := PyDict_GetItemStringRef(mp.PyObject, PAnsiChar(TempString), @TempResult);
      result_    := TPyObject.Wrap(TempResult);
    end
   else
    begin
      result_ := nil;
      Result  := 0;
    end;
end;

class function TPyDict.SetDefault(const p, key, defaultobj: IPyObject): IPyObject;
begin
  if assigned(PyDict_SetDefault) and
     TPyObject.IsInitialized(p) and
     TPyObject.IsInitialized(key) and
     TPyObject.IsInitialized(defaultobj) then
    Result := TPyObject.Wrap(PyDict_SetDefault(p.PyObject, key.PyObject, defaultobj.PyObject), False)
   else
    Result := nil;
end;

class function TPyDict.SetDefaultRef(const p, key, default_value: IPyObject; out result_: IPyObject): integer;
var
  TempResult : PPyObject;
begin
  if assigned(PyDict_SetDefaultRef) and
     TPyObject.IsInitialized(p) and
     TPyObject.IsInitialized(key) and
     TPyObject.IsInitialized(default_value) then
    begin
      Result  := PyDict_SetDefaultRef(p.PyObject, key.PyObject, default_value.PyObject, @TempResult);
      result_ := TPyObject.Wrap(TempResult);
    end
   else
    begin
      Result  := -1;
      result_ := nil;
    end;
end;

class function TPyDict.ContainsString(const p: IPyObject; const key: string): integer;
var
  TempString : AnsiString;
begin
  if assigned(PyDict_ContainsString) and
     TPyObject.IsInitialized(p) then
    begin
      TempString := StringToPyUTF8(key);
      Result     := PyDict_ContainsString(p.PyObject, PAnsiChar(TempString))
    end
   else
    Result := -1;
end;

class function TPyDict.Pop(const p, key: IPyObject; out result_: IPyObject): integer;
var
  TempResult : PPyObject;
begin
  if assigned(PyDict_Pop) and
     TPyObject.IsInitialized(p) and
     TPyObject.IsInitialized(key) then
    begin
      Result  := PyDict_Pop(p.PyObject, key.PyObject, @TempResult);
      result_ := TPyObject.Wrap(TempResult);
    end
   else
    begin
      Result  := -1;
      result_ := nil;
    end;
end;

class function TPyDict.PopString(const p: IPyObject; const key: string; out result_: IPyObject): integer;
var
  TempResult : PPyObject;
  TempString : AnsiString;
begin
  if assigned(PyDict_PopString) and
     TPyObject.IsInitialized(p) then
    begin
      TempString := StringToPyUTF8(key);
      Result     := PyDict_PopString(p.PyObject, PAnsiChar(TempString), @TempResult);
      result_    := TPyObject.Wrap(TempResult);
    end
   else
    begin
      Result  := -1;
      result_ := nil;
    end;
end;

class function TPyDict.AddWatcher(callback: PyDict_WatchCallback): integer;
begin
  if assigned(PyDict_AddWatcher) then
    Result := PyDict_AddWatcher(callback)
   else
    Result := -1;
end;

class function TPyDict.ClearWatcher(watcher_id: integer): boolean;
begin
  Result := assigned(PyDict_ClearWatcher) and
            (PyDict_ClearWatcher(watcher_id) = 0);
end;

class function TPyDict.Watch(watcher_id: integer; const dict: IPyObject): boolean;
begin
  Result := assigned(PyDict_Watch) and
            TPyObject.IsInitialized(dict) and
            (PyDict_Watch(watcher_id, dict.PyObject) = 0);
end;

class function TPyDict.Unwatch(watcher_id: integer; const dict: IPyObject): boolean;
begin
  Result := assigned(PyDict_Unwatch) and
            TPyObject.IsInitialized(dict) and
            (PyDict_Unwatch(watcher_id, dict.PyObject) = 0);
end;

class function TPyDict.FromStringsArray(const aKeys: TStringList; const aValues: array of const): IPyObject;
var
  i, TempLen : integer;
begin
  Result := nil;

  if not(assigned(aKeys)) then exit;

  TempLen := aKeys.Count;

  if (TempLen > 0) and (TempLen = length(aValues)) then
    begin
      Result := TPyDict.New;

      for i := 0 to pred(TempLen) do
        TPyDict.SetItem(Result, aKeys[i], TPyObject.FromVarRec(aValues[i]));
    end;
end;

class function TPyDict.FromNamedParamArray(const NamedParamArray: TNamedParamArray; const Arguments: TVarDataArray): IPyObject;
var
  i, TempLen, TempArgLen : integer;
begin
  Result     := nil;
  TempLen    := length(NamedParamArray);
  TempArgLen := length(Arguments);

  if (TempLen > 0) then
    begin
      Result := TPyDict.New;

      for i := 0 to pred(TempLen) do
        if (NamedParamArray[i].Index >= 0) and (NamedParamArray[i].Index < TempArgLen) then
          TPyDict.SetItemString(Result, NamedParamArray[i].Name, TPyObject.FromVarData(Arguments[NamedParamArray[i].Index]));
    end;
end;

end.
