unit uP4P.Interfaces;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.Types,
  {$ELSE}
    Classes, Types,
  {$ENDIF}
  uP4P.Types;

type
  IPyObject = interface;
  IPyStatus = interface;
  IPyInitConfig = interface;
  IPyPreConfig = interface;
  IPyConfig = interface;
  IPyMutex = interface;
  IPyCriticalSection = interface;
  IPyCriticalSection2 = interface;
  IPyLongExport = interface;
  IPyLongWriter = interface;
  IPyInterpreterConfig = interface;
  IPyInterpreterState = interface;
  IPyThreadState = interface;
  IPyGILState = interface;
  IPyThreadLock = interface;
  IPyThreadTSS = interface;

  /// <summary>
  /// Custom IPyObject open array type.
  /// </summary>
  IPyObjectArray = array of IPyObject;

  /// <summary>
  /// <para>All object types are extensions of this type. This is a type which
  /// contains the information Python needs to treat a pointer to an object as
  /// an object. In a normal "release" build, it contains only the object's
  /// reference count and a pointer to the corresponding type object. Nothing
  /// is actually declared to be a PyObject, but every pointer to a Python
  /// object can be cast to a PPyObject.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#c.PyObject">See the article about PyObject.</see></para>
  /// </remarks>
  IPyObject = interface
    ['{22FC7944-7F88-4638-ADD4-F029A356D81B}']
    function  GetPyObject: PPyObject;
    function  GetInitialized: boolean;
    function  GetRefCnt: Py_ssize_t;
    function  GetObjRefOwner: boolean;
    function  GetPyTypeObject: PPyTypeObject;
    /// <summary>
    /// <para>Get a pointer to subclass-specific data reserved for cls.</para>
    /// <para>The object o must be an instance of cls, and cls must have been
    /// created using negative PyType_Spec.basicsize. Python does not check
    /// this.</para>
    /// <para>On error, set an exception and return nil.</para>
    /// <para>Added in version 3.12.</para>
    /// </summary>
    function  GetTypeData(const cls: PyTypeObject): Pointer;
    /// <summary>
    /// <para>The following function should only be used in a tp_traverse
    /// handler; calling them in other contexts may have unintended
    /// consequences.</para>
    /// <para>This function act like their counterpart without the _DuringGC
    /// suffix, but it's guaranteed to not have side effects, it doesn't set
    /// an exception on failure, and it returns/sets borrowed references as
    /// detailed in the individual documentation.</para>
    /// <para>Note that this function may fail, but as it doesn't set an
    /// exception, no error information is available. In some cases, failure
    /// is not distinguishable from a successful nil result.</para>
    /// <para>Added in version 3.15.</para>
    /// </summary>
    function  GetTypeData_DuringGC(const cls: PyTypeObject): Pointer;
    function  GetAsString: string;
    function  GetAsAnsiString: AnsiString;
    function  GetAsWideString: WideString;
    function  GetAsInteger: C_Long;
    function  GetAsCardinal: C_ULong;
    function  GetAsInt64: Int64;
    function  GetAsUInt64: uint64;
    function  GetAsDouble: double;
    function  GetAsDateTime: TDateTime;
    function  GetAsVariant: Variant;
    function  GetIsCallable: boolean;
    function  GetIsTuple: boolean;
    function  GetIsList: boolean;
    function  GetIsSequence: boolean;
    function  GetIsMapping: boolean;
    function  GetIsFloat: boolean;
    function  GetIsLong: boolean;
    function  GetIsBool: boolean;
    function  GetIsUnicode: boolean;
    function  GetIsBytes: boolean;
    procedure SetObjRefOwner(aValue: boolean);
    procedure SetRefCnt(aValue: Py_ssize_t);
    procedure SetPyObject(aValue: PPyObject);
    /// <summary>
    /// <para>Test if this object is the True singleton, the same as x is True
    /// in Python.</para>
    /// <para>Added in version 3.10.</para>
    /// </summary>
    function  IsTrueSingleton: boolean;
    /// <summary>
    /// <para>Test if this object is the False singleton, the same as x is False
    /// in Python.</para>
    /// <para>Added in version 3.10.</para>
    /// </summary>
    function  IsFalseSingleton: boolean;
    /// <summary>
    /// <para>Test if this object is the None singleton, the same as x is None
    /// in Python.</para>
    /// <para>Added in version 3.10.</para>
    /// </summary>
    function  IsNoneSingleton: boolean;
    /// <summary>
    /// <para>Indicate taking a new strong reference to this object,
    /// indicating it is in use and should not be destroyed.</para>
    /// <para>This function has no effect on immortal objects.</para>
    /// </summary>
    procedure IncRef;
    /// <summary>
    /// <para>Release a strong reference to this object aPyObject, indicating
    /// the reference is no longer used.</para>
    /// <para>This function has no effect on immortal objects.</para>
    /// </summary>
    procedure DecRef;
    /// <summary>
    /// <para>Create a new strong reference to this object.</para>
    /// </summary>
    function  NewRef: Pointer;
    /// <summary>
    /// <para>Test if this object is the same as the "other" object.</para>
    /// </summary>
    function  SameAs(const other: IPyObject): boolean; overload;
    /// <summary>
    /// <para>Test if this object is the same as the "other" object.</para>
    /// </summary>
    function  SameAs(const other: PPyObject): boolean; overload;
    /// <summary>
    /// <para>Return True if the PyObject is a type of aPyTypeObject.</para>
    /// </summary>
    function  IsType(aPyTypeObject: PPyTypeObject): boolean;
    /// <summary>
    /// <para>Return True if the PyObject is a type or subtype of aPyTypeObject.</para>
    /// </summary>
    function  TypeCheck(aPyTypeObject: PPyTypeObject): boolean;
    /// <summary>
    /// <para>Set the internal PyObject to nil.</para>
    /// </summary>
    procedure InitPyObject;
    /// <summary>
    /// <para>Return 1 if inst is an instance of the class cls or a subclass
    /// of cls, or 0 if not. On error, returns -1 and sets an
    /// exception.</para>
    /// <para>If cls is a tuple, the check will be done against every entry in
    /// cls. The result will be 1 when at least one of the checks returns 1,
    /// otherwise it will be 0.</para>
    /// <para>If cls has a __instancecheck__() method, it will be called to
    /// determine the subclass status as described in PEP 3119. Otherwise,
    /// inst is an instance of cls if its class is a subclass of cls.</para>
    /// <para>An instance inst can override what is considered its class by
    /// having a __class__ attribute.</para>
    /// <para>An object cls can override if it is considered a class, and what
    /// its base classes are, by having a __bases__ attribute (which must be a
    /// tuple of base classes).</para>
    /// </summary>
    function  IsInstance(const cls: IPyObject): integer;
    /// <summary>
    /// <para>Return 1 if the class derived is identical to or derived from
    /// the class cls, otherwise return 0. In case of an error,
    /// return -1.</para>
    /// <para>If cls is a tuple, the check will be done against every entry
    /// in cls. The result will be 1 when at least one of the checks
    /// returns 1, otherwise it will be 0.</para>
    /// <para>If cls has a __subclasscheck__() method, it will be called to
    /// determine the subclass status as described in PEP 3119. Otherwise,
    /// derived is a subclass of cls if it is a direct or indirect subclass,
    /// i.e. contained in cls.__mro__.</para>
    /// <para>Normally only class objects, i.e. instances of type or a
    /// derived class, are considered classes. However, objects can override
    /// this by having a __bases__ attribute (which must be a tuple of base
    /// classes).</para>
    /// </summary>
    function  IsSubclass(const cls: IPyObject): integer;
    /// <summary>
    /// <para>A generic implementation for the getter of a __dict__
    /// descriptor. It creates the dictionary if necessary.</para>
    /// <para>This function may also be called to get the __dict__ of this
    /// object. Pass nil for context when calling it. Since this function may
    /// need to allocate memory for the dictionary, it may be more efficient
    /// to call PyObject_GetAttr() when accessing an attribute on the
    /// object.</para>
    /// <para>On failure, returns nil with an exception set.</para>
    /// <para>Added in version 3.3.</para>
    /// </summary>
    function  GenericGetDict(context: Pointer): IPyObject;
    /// <summary>
    /// <para>Return True if obj supports the buffer interface otherwise
    /// False. When True is returned, it doesn't guarantee that
    /// TPyObject.GetBuffer() will succeed. This function always
    /// succeeds.</para>
    /// </summary>
    function  CheckBuffer: boolean;
    /// <summary>
    /// <para>Send a request to this object to fill in view as specified by
    /// flags. If this object cannot provide a buffer of the exact type, it
    /// MUST raise BufferError, set view->obj to nil and return False.</para>
    /// <para>On success, fill in view, set view->obj to a new reference to
    /// this object and return True. In the case of chained buffer providers that
    /// redirect requests to a single object, view->obj MAY refer to this
    /// object instead of this object (See Buffer Object Structures).</para>
    /// <para>Successful calls to TPyObject.GetBuffer() must be paired with
    /// calls to TPyBuffer.Release(), similar to malloc() and free().
    /// Thus, after the consumer is done with the buffer, TPyBuffer.Release()
    /// must be called exactly once.</para>
    /// </summary>
    function  GetBuffer(view: PPy_buffer; flags: Integer): boolean;
    /// <summary>
    /// <para>Copy data from src to dest buffer. Can convert between C-style
    /// and or Fortran-style buffers.</para>
    /// <para>True is returned on success, False on error.</para>
    /// </summary>
    function  CopyData(const src: IPyObject): boolean;
    /// <summary>
    /// <para>Compute a string representation of this object. Returns the
    /// string representation on success, nil on failure. This is the
    /// equivalent of the Python expression repr(o). Called by the repr()
    /// built-in function.</para>
    /// <para>Changed in version 3.4: This function now includes a debug
    /// assertion to help ensure that it does not silently discard an active
    /// exception.</para>
    /// </summary>
    function  Repr: IPyObject;
    /// <summary>
    /// <para>Compute a string representation of this object. Returns the
    /// string representation on success, nil on failure. This is the
    /// equivalent of the Python expression str(o). Called by the str()
    /// built-in function and, therefore, by the print() function.</para>
    /// <para>Changed in version 3.4: This function now includes a debug
    /// assertion to help ensure that it does not silently discard an active
    /// exception.</para>
    /// </summary>
    function  Str: IPyObject;
    /// <summary>
    /// <para>As TPyObject.Repr(), compute a string representation of this
    /// object, but escape the non-ASCII characters in the string returned by
    /// TPyObject.Repr() with \x, \u or \U escapes. This generates a string
    /// similar to that returned by TPyObject.Repr() in Python 2.
    /// Called by the ascii() built-in function.</para>
    /// </summary>
    function  ASCII: IPyObject;
    /// <summary>
    /// <para>Compute a bytes representation of this object. nil is returned
    /// on failure and a bytes object on success. This is equivalent to the
    /// Python expression bytes(o), when o is not an integer. Unlike bytes(o),
    /// a TypeError is raised when o is an integer instead of a
    /// zero-initialized bytes object.</para>
    /// </summary>
    function  Bytes: IPyObject;
    /// <summary>
    /// <para>Compare the values of this object and obj using the operation
    /// specified by opid, which must be one of Py_LT, Py_LE, Py_EQ, Py_NE,
    /// Py_GT, or Py_GE, corresponding to <, <=, ==, !=, >, or >=
    /// respectively. This is the equivalent of the Python expression
    /// o1 op o2, where op is the operator corresponding to opid. Returns the
    /// value of the comparison on success, or nil on failure.</para>
    /// </summary>
    function  RichCompare(const obj: IPyObject; opid: integer): IPyObject;
    /// <summary>
    /// <para>Compare the values of this object and obj using the operation
    /// specified by opid, like TPyObject.RichCompare(), but returns -1 on
    /// error, 0 if the result is false, 1 otherwise.</para>
    /// <para>Note If o1 and o2 are the same object,
    /// TPyObject.RichCompareBool() will always return 1 for Py_EQ and 0 for
    /// Py_NE.</para>
    /// </summary>
    function  RichCompareBool(const obj: IPyObject; opid: integer): integer;
    /// <summary>
    /// <para>This is the same as TPyObject.GetAttr(), but attr_name is
    /// specified as a string, rather than a IPyObject.</para>
    /// <para>If the missing attribute should not be treated as a failure,
    /// you can use TPyObject.GetOptionalAttrString() instead.</para>
    /// <para>This function returns a IPyObject instance.</para>
    /// </summary>
    function  GetAttrString(const attr_name: string): IPyObject;
    /// <summary>
    /// <para>This is the same as TPyObject.GetAttr(), but attr_name is
    /// specified as a string, rather than a IPyObject.</para>
    /// <para>If the missing attribute should not be treated as a failure,
    /// you can use TPyObject.GetOptionalAttrString() instead.</para>
    /// <para>This function returns a PPyObject pointer.</para>
    /// </summary>
    function  GetAttrString2(const attr_name: string): Pointer;
    /// <summary>
    /// <para>This is the same as TPyObject.SetAttr(), but attr_name is
    /// specified as a string, rather than a IPyObject.</para>
    /// <para>If value is nil, the attribute is deleted, but this feature is
    /// deprecated in favour of using TPyObject.DelAttrString().</para>
    /// <para>The function must not be called with a nil value and an
    /// exception set. This case can arise from forgetting nil checks and
    /// would delete the attribute.</para>
    /// <para>The number of different attribute names passed to this function
    /// should be kept small, usually by using a statically allocated string
    /// as attr_name. For attribute names that aren't known at compile time,
    /// prefer calling TPyUnicode.FromString() and TPyObject.SetAttr()
    /// directly. For more details, see TPyUnicode.InternFromString(), which
    /// may be used internally to create a key object.</para>
    /// <para>This function uses a IPyObject for the value parameter.</para>
    /// <para>Changed in version 3.15: Must not be called with nil value if
    /// an exception is set.</para>
    /// </summary>
    function  SetAttrString(const attr_name: string; const value: IPyObject): boolean;
    /// <summary>
    /// <para>This is the same as TPyObject.SetAttr(), but attr_name is
    /// specified as a string, rather than a IPyObject.</para>
    /// <para>If value is nil, the attribute is deleted, but this feature is
    /// deprecated in favour of using TPyObject.DelAttrString().</para>
    /// <para>The function must not be called with a nil value and an
    /// exception set. This case can arise from forgetting nil checks and
    /// would delete the attribute.</para>
    /// <para>The number of different attribute names passed to this function
    /// should be kept small, usually by using a statically allocated string
    /// as attr_name. For attribute names that aren't known at compile time,
    /// prefer calling TPyUnicode.FromString() and TPyObject.SetAttr()
    /// directly. For more details, see TPyUnicode.InternFromString(), which
    /// may be used internally to create a key object.</para>
    /// <para>This function uses a PPyObject pointer for the value
    /// parameter.</para>
    /// <para>Changed in version 3.15: Must not be called with nil value if
    /// an exception is set.</para>
    /// </summary>
    function  SetAttrString2(const attr_name: string; value: Pointer): boolean;
    /// <summary>
    /// <para>This is the same as TPyObject.DelAttr(), but attr_name is
    /// specified as a string, rather than a IPyObject.</para>
    /// <para>The number of different attribute names passed to this function
    /// should be kept small, usually by using a statically allocated string
    /// as attr_name. For attribute names that areni't known at compile time,
    /// prefer calling TPyUnicode.FromString() and TPyObject.DelAttr()
    /// directly. For more details, see TPyUnicode.InternFromString(), which
    /// may be used internally to create a key object for lookup.</para>
    /// </summary>
    function  DelAttrString(const attr_name: string): boolean;
    /// <summary>
    /// <para>This is the same as TPyObject.HasAttr(), but attr_name is
    /// specified as a string, rather than a IPyObject.</para>
    /// <para>Note Exceptions that occur when this calls __getattr__() and
    /// __getattribute__() methods or while creating the temporary str object
    /// are silently ignored. For proper error handling, use
    /// TPyObject.HasAttrStringWithError(), TPyObject.GetOptionalAttrString()
    /// or TPyObject.GetAttrString() instead.</para>
    /// </summary>
    function  HasAttrString(const attr_name: string): boolean;
    /// <summary>
    /// <para>Retrieve an attribute named attr_name from this object. Returns
    /// the attribute value on success, or nil on failure. This is the
    /// equivalent of the Python expression o.attr_name.</para>
    /// <para>If the missing attribute should not be treated as a failure, you
    /// can use TPyObject.GetOptionalAttr() instead.</para>
    /// <para>This function returns a IPyObject instance.</para>
    /// </summary>
    function  GetAttr(const attr_name: IPyObject): IPyObject;
    /// <summary>
    /// <para>Retrieve an attribute named attr_name from this object. Returns
    /// the attribute value on success, or nil on failure. This is the
    /// equivalent of the Python expression o.attr_name.</para>
    /// <para>If the missing attribute should not be treated as a failure, you
    /// can use TPyObject.GetOptionalAttr() instead.</para>
    /// <para>This function returns a PPyObject pointer.</para>
    /// </summary>
    function  GetAttr2(const attr_name: IPyObject): Pointer;
    /// <summary>
    /// <para>Variant of TPyObject.GetAttr() which doesn't raise
    /// AttributeError if the attribute is not found.</para>
    /// <para>If the attribute is found, return True and set result_ to a new
    /// strong reference to the attribute. If the attribute is not found,
    /// return False and set result_ to nil; the AttributeError is silenced.
    /// If an error other than AttributeError is raised, return False and set
    /// result_ to nil.</para>
    /// <para>Added in version 3.13.</para>
    /// <para>This function returns a IPyObject instance.</para>
    /// </summary>
    function  GetOptionalAttr(const attr_name: IPyObject; out result_: IPyObject): boolean;
    /// <summary>
    /// <para>Variant of TPyObject.GetAttr() which doesn't raise
    /// AttributeError if the attribute is not found.</para>
    /// <para>If the attribute is found, return True and set result_ to a new
    /// strong reference to the attribute. If the attribute is not found,
    /// return False and set result_ to nil; the AttributeError is silenced.
    /// If an error other than AttributeError is raised, return False and set
    /// result_ to nil.</para>
    /// <para>Added in version 3.13.</para>
    /// <para>This function returns a PPyObject pointer.</para>
    /// </summary>
    function  GetOptionalAttr2(const attr_name: IPyObject; out result_: Pointer): boolean;
    /// <summary>
    /// <para>This is the same as TPyObject.GetOptionalAttr(), but attr_name
    /// is specified as a string, rather than a IPyObject.</para>
    /// <para>Added in version 3.13.</para>
    /// <para>This function returns a IPyObject instance.</para>
    /// </summary>
    function  GetOptionalAttrString(const attr_name: string; out result_: IPyObject): boolean;
    /// <summary>
    /// <para>This is the same as TPyObject.GetOptionalAttr(), but attr_name
    /// is specified as a string, rather than a IPyObject.</para>
    /// <para>Added in version 3.13.</para>
    /// <para>This function returns a PPyObject pointer.</para>
    /// </summary>
    function  GetOptionalAttrString2(const attr_name: string; out result_: Pointer): boolean;
    /// <summary>
    /// <para>This is the same as TPyObject.GetAttrString but result_ is
    /// converted to integer.</para>
    /// </summary>
    function  GetAttrAsInteger(const attr_name: string; out result_: integer): boolean;
    /// <summary>
    /// <para>This is the same as TPyObject.GetAttrString but result_ is
    /// converted to string.</para>
    /// </summary>
    function  GetAttrAsString(const attr_name: string; out result_: string): boolean;
    /// <summary>
    /// <para>Set the value of the attribute named attr_name, for this object,
    /// to the value. Raise an exception and return False on failure; return
    /// True on success. This is the equivalent of the Python statement
    /// o.attr_name = v.</para>
    /// <para>If value is nil, the attribute is deleted. This behaviour is
    /// deprecated in favour of using TPyObject.DelAttr(), but there are
    /// currently no plans to remove it.</para>
    /// <para>The function must not be called with a nil value and an
    /// exception set. This case can arise from forgetting nil checks and
    /// would delete the attribute.</para>
    /// <para>Changed in version 3.15: Must not be called with nil value if
    /// an exception is set.</para>
    /// </summary>
    function  SetAttr(const attr_name, value: IPyObject): boolean;
    /// <summary>
    /// <para>Set the value of the attribute named attr_name, for this object,
    /// to the value. Raise an exception and return False on failure; return
    /// True on success. This is the equivalent of the Python statement
    /// o.attr_name = v.</para>
    /// <para>If value is nil, the attribute is deleted. This behaviour is
    /// deprecated in favour of using TPyObject.DelAttr(), but there are
    /// currently no plans to remove it.</para>
    /// <para>The function must not be called with a nil value and an
    /// exception set. This case can arise from forgetting nil checks and
    /// would delete the attribute.</para>
    /// <para>Changed in version 3.15: Must not be called with nil value if
    /// an exception is set.</para>
    /// <para>This function uses a PPyObject pointer in the value.</para>
    /// </summary>
    function  SetAttr2(const attr_name: IPyObject; value: Pointer): boolean;
    /// <summary>
    /// <para>Delete attribute named attr_name, for this object. Returns
    /// False on failure. This is the equivalent of the Python statement
    /// del o.attr_name.</para>
    /// </summary>
    function  DelAttr(const attr_name: IPyObject): boolean;
    /// <summary>
    /// <para>Returns True if o has the attribute attr_name, and False
    /// otherwise. This function always succeeds.</para>
    /// <para>Note Exceptions that occur when this calls __getattr__() and
    /// __getattribute__() methods aren't propagated, but instead given to
    /// sys.unraisablehook(). For proper error handling, use
    /// TPyObject.HasAttrWithError(), TPyObject.GetOptionalAttr() or
    /// TPyObject.GetAttr() instead.</para>
    /// </summary>
    function  HasAttr(const attr_name: IPyObject): boolean;
    /// <summary>
    /// <para>Returns 1 if o has the attribute attr_name, and 0 otherwise.
    /// This is equivalent to the Python expression hasattr(o, attr_name).
    /// On failure, return -1.</para>
    /// <para>Added in version 3.13.</para>
    /// </summary>
    function  HasAttrWithError(const attr_name: IPyObject): integer;
    /// <summary>
    /// <para>This is the same as TPyObject.HasAttrWithError(), but attr_name
    /// is specified as a string, rather than a IPyObject.</para>
    /// <para>Added in version 3.13.</para>
    /// </summary>
    function  HasAttrStringWithError(const attr_name: string): integer;
    /// <summary>
    /// <para>This is equivalent to the Python __iter__(self): return self
    /// method. It is intended for iterator types, to be used in the
    /// PyTypeObject.tp_iter slot.</para>
    /// </summary>
    function  SelfIter: IPyObject;
    /// <summary>
    /// <para>Generic attribute getter function that is meant to be put into
    /// a type object's tp_getattro slot. It looks for a descriptor in the
    /// dictionary of classes in the object's MRO as well as an attribute in
    /// the object's __dict__ (if present). As outlined in Implementing
    /// Descriptors, data descriptors take preference over instance
    /// attributes, while non-data descriptors don't. Otherwise, an
    /// AttributeError is raised.</para>
    /// <para>This function returns a IPyObject instance.</para>
    /// </summary>
    function  GenericGetAttr(const name_: IPyObject): IPyObject;
    /// <summary>
    /// <para>Generic attribute getter function that is meant to be put into
    /// a type object's tp_getattro slot. It looks for a descriptor in the
    /// dictionary of classes in the object's MRO as well as an attribute in
    /// the object's __dict__ (if present). As outlined in Implementing
    /// Descriptors, data descriptors take preference over instance
    /// attributes, while non-data descriptors don't. Otherwise, an
    /// AttributeError is raised.</para>
    /// <para>This function returns a PPyObject pointer.</para>
    /// </summary>
    function  GenericGetAttr2(const name_: IPyObject): Pointer;
    /// <summary>
    /// <para>Generic attribute setter and deleter function that is meant to
    /// be put into a type object's tp_setattro slot. It looks for a data
    /// descriptor in the dictionary of classes in the object's MRO, and if
    /// found it takes preference over setting or deleting the attribute in
    /// the instance dictionary. Otherwise, the attribute is set or deleted
    /// in the object's __dict__ (if present). On success, True is returned,
    /// otherwise an AttributeError is raised and False is returned.</para>
    /// <para>This function uses a IPyObject value.</para>
    /// </summary>
    function  GenericSetAttr(const name_, value: IPyObject): boolean;
    /// <summary>
    /// <para>Generic attribute setter and deleter function that is meant to
    /// be put into a type object's tp_setattro slot. It looks for a data
    /// descriptor in the dictionary of classes in the object's MRO, and if
    /// found it takes preference over setting or deleting the attribute in
    /// the instance dictionary. Otherwise, the attribute is set or deleted
    /// in the object's __dict__ (if present). On success, True is returned,
    /// otherwise an AttributeError is raised and False is returned.</para>
    /// <para>This function uses a PPyObject pointer in the value.</para>
    /// </summary>
    function  GenericSetAttr2(const name_: IPyObject; value: Pointer): boolean;
    /// <summary>
    /// <para>A generic implementation for the setter of a __dict__
    /// descriptor. This implementation does not allow the dictionary to be
    /// deleted.</para>
    /// <para>Added in version 3.3.</para>
    /// </summary>
    function  GenericSetDict(const value: IPyObject; context: Pointer): boolean;
    /// <summary>
    /// <para>Compute and return the hash value of this object. On failure,
    /// return False. This is the equivalent of the Python expression
    /// hash(o).</para>
    /// </summary>
    function  Hash: Py_hash_t;
    /// <summary>
    /// <para>Set a TypeError indicating that type(o) is not hashable and
    /// return -1. This function receives special treatment when stored in a
    /// tp_hash slot, allowing a type to explicitly indicate to the
    /// interpreter that it is not hashable.</para>
    /// </summary>
    function  HashNotImplemented: Py_hash_t;
    /// <summary>
    /// <para>Returns 1 if this object is considered to be true, and 0
    /// otherwise. This is equivalent to the Python expression not not o.
    /// On failure, return -1.</para>
    /// </summary>
    function  IsTrue: integer;
    /// <summary>
    /// <para>Returns 0 if this object is considered to be true, and 1
    /// otherwise. This is equivalent to the Python expression not o.
    /// On failure, return -1.</para>
    /// </summary>
    function  Not_: integer;
    /// <summary>
    /// <para>This function is called by the tp_dealloc handler to clear weak
    /// references.</para>
    /// <para>This iterates through the weak references for this object and
    /// calls callbacks for those references which have one. It returns when
    /// all callbacks have been attempted.</para>
    /// </summary>
    procedure ClearWeakRefs;
    /// <summary>
    /// <para>This is equivalent to the Python expression dir(o), returning a
    /// (possibly empty) list of strings appropriate for the object argument,
    /// or nil if there was an error. If the argument is nil, this is like
    /// the Python dir(), returning the names of the current locals; in this
    /// case, if no execution frame is active then nil is returned but
    /// TPyErr.Occurred() will return false.</para>
    /// </summary>
    function  Dir: IPyObject;
    /// <summary>
    /// <para>Called at the beginning of the tp_repr implementation to detect
    /// cycles.</para>
    /// <para>If this object has already been processed, the function returns
    /// a positive integer. In that case the tp_repr implementation should
    /// return a string object indicating a cycle. As examples, dict objects
    /// return {...} and list objects return [...].</para>
    /// <para>The function will return a negative integer if the recursion
    /// limit is reached. In that case the tp_repr implementation should
    /// typically return nil.</para>
    /// <para>Otherwise, the function returns zero and the tp_repr
    /// implementation can continue normally.</para>
    /// </summary>
    function  ReprEnter: integer;
    /// <summary>
    /// <para>Ends a ReprEnter(). Must be called once for each invocation of
    /// ReprEnter() that returns zero.</para>
    /// </summary>
    procedure ReprLeave;
    /// <summary>
    /// <para>Print this object, on file fp. Returns False on error. The flags
    /// argument is used to enable certain printing options. The only option
    /// currently supported is Py_PRINT_RAW; if given, the str() of this
    /// object is written instead of the repr().</para>
    /// </summary>
    function  Print(file_: PFILE; flags: integer): boolean;
    /// <summary>
    /// <para>Finalizes this object as described in tp_finalize. Call this
    /// function (or TPyObject.CallFinalizerFromDealloc()) instead of calling
    /// tp_finalize directly because this function may deduplicate multiple
    /// calls to tp_finalize. Currently, calls are only deduplicated if the
    /// type supports garbage collection (i.e., the Py_TPFLAGS_HAVE_GC flag
    /// is set); this may change in the future.</para>
    /// <para>Added in version 3.4.</para>
    /// </summary>
    procedure CallFinalizer;
    /// <summary>
    /// <para>Same as TPyObject.CallFinalizer() but meant to be called at the
    /// beginning of the object's destructor (tp_dealloc). There must not be
    /// any references to the object. If the object's finalizer resurrects
    /// the object, this function returns False; no further destruction should
    /// happen. Otherwise, this function returns True and destruction can
    /// continue normally.</para>
    /// <para>Added in version 3.4.</para>
    /// </summary>
    function  CallFinalizerFromDealloc: boolean;
    /// <summary>
    /// <para>Get a pointer to per-item data for a class with
    /// Py_TPFLAGS_ITEMS_AT_END.</para>
    /// <para>On error, set an exception and return nil. TypeError is raised
    /// if this object does not have Py_TPFLAGS_ITEMS_AT_END set.</para>
    /// <para>Added in version 3.12.</para>
    /// </summary>
    function  GetItemData: Pointer;
    /// <summary>
    /// <para>Visit the managed dictionary of this object.</para>
    /// <para>This function must only be called in a traverse function of the
    /// type which has the Py_TPFLAGS_MANAGED_DICT flag set.</para>
    /// <para>Added in version 3.13.</para>
    /// </summary>
    function  VisitManagedDict(visit: visitproc; arg: Pointer): integer;
    /// <summary>
    /// <para>Clear the managed dictionary of this object.</para>
    /// <para>This function must only be called in a clear function of the
    /// type which has the Py_TPFLAGS_MANAGED_DICT flag set.</para>
    /// <para>Added in version 3.13.</para>
    /// </summary>
    procedure ClearManagedDict;
    /// <summary>
    /// <para>Adds the object op to the set of container objects tracked by
    /// the collector. The collector can run at unexpected times so objects
    /// must be valid while being tracked. This should be called once all the
    /// fields followed by the tp_traverse handler become valid, usually near
    /// the end of the constructor.</para>
    /// </summary>
    procedure GC_Track;
    /// <summary>
    /// <para>Remove the object op from the set of container objects tracked
    /// by the collector. Note that TPyObject.GC_Track() can be called again
    /// on this object to add it back to the set of tracked objects.
    /// The deallocator (tp_dealloc handler) should call this for the object
    /// before any of the fields used by the tp_traverse handler become
    /// invalid.</para>
    /// </summary>
    procedure GC_UnTrack;
    /// <summary>
    /// <para>Returns True if the object type of op implements the GC protocol
    /// and op is being currently tracked by the garbage collector and False
    /// otherwise.</para>
    /// <para>This is analogous to the Python function gc.is_tracked().</para>
    /// </summary>
    function  GC_IsTracked: boolean;
    /// <summary>
    /// <para>Returns True if the object type of op implements the GC protocol
    /// and op has been already finalized by the garbage collector and False
    /// otherwise.</para>
    /// <para>This is analogous to the Python function gc.is_finalized().</para>
    /// </summary>
    function  GC_IsFinalized: boolean;
    /// <summary>
    /// <para>Returns True if the object implements the garbage collector
    /// protocol, otherwise returns False.</para>
    /// <para>The object cannot be tracked by the garbage collector if this
    /// function returns False.</para>
    /// </summary>
    function  IS_GC: boolean;
    /// <summary>
    /// <para>Generic hashing function that is meant to be put into a type
    /// object's tp_hash slot. Its result only depends on the object's
    /// identity.</para>
    /// <para>CPython implementation detail: In CPython, it is equivalent to
    /// TPy.HashPointer().</para>
    /// <para>Added in version 3.13.</para>
    /// </summary>
    function  GenericHash: Py_hash_t;
    /// <summary>
    /// <para>Return the file descriptor associated with p as an int. If the
    /// object is an integer, its value is returned. If not, the object's
    /// fileno() method is called if it exists; the method must return an
    /// integer, which is returned as the file descriptor value. Sets an
    /// exception and returns -1 on failure.</para>
    /// </summary>
    function  AsFileDescriptor: integer;
    /// <summary>
    /// <para>Returns a type object corresponding to the object type of this
    /// object. On failure, raises SystemError and returns nil.
    /// This is equivalent to the Python expression type(o).
    /// This function creates a new strong reference to the return value.
    /// There's really no reason to use this function instead of the
    /// TPy.Type_() function, which returns a pointer of type PPyTypeObject,
    /// except when a new strong reference is needed.</para>
    /// </summary>
    function  Type_: IPyObject;
    /// <summary>
    /// <para>Return the Size of this object. If this object provides either
    /// the sequence and mapping protocols, the sequence length is returned.
    /// On error, -1 is returned. This is the equivalent to the Python
    /// expression len(o).</para>
    /// </summary>
    function  Size: Py_ssize_t;
    /// <summary>
    /// <para>Return the length of this object. If this object provides either
    /// the sequence and mapping protocols, the sequence length is returned.
    /// On error, -1 is returned. This is the equivalent to the Python
    /// expression len(o).</para>
    /// </summary>
    function  Length: Py_ssize_t;
    /// <summary>
    /// <para>Return element of this object corresponding to the key
    /// or nil on failure. This is the equivalent of the Python expression
    /// o[key].</para>
    /// </summary>
    function  GetItem(const key: IPyObject): IPyObject; overload;
    /// <summary>
    /// <para>Return element of this object corresponding to the key
    /// or nil on failure. This is the equivalent of the Python expression
    /// o[key].</para>
    /// </summary>
    function  GetItem(const key: TVarData): IPyObject; overload;
    /// <summary>
    /// <para>Map the key to the value v. Raise an exception and
    /// return False on failure; return 0 on success. This is the equivalent
    /// of the Python statement o[key] = v. This function does not steal a
    /// reference to v.</para>
    /// </summary>
    function  SetItem(const key, v: IPyObject): boolean; overload;
    /// <summary>
    /// <para>Map the key to the value v. Raise an exception and
    /// return False on failure; return 0 on success. This is the equivalent
    /// of the Python statement o[key] = v. This function does not steal a
    /// reference to v.</para>
    /// </summary>
    function  SetItem(const key, v: TVarData): boolean; overload;
    /// <summary>
    /// <para>This is the same as TPyObject.DelItem(), but key is specified
    /// as a string, rather than a IPyObject.</para>
    /// </summary>
    function  DelItemString(const key: string): boolean;
    /// <summary>
    /// <para>Remove the mapping for the key from this object. Return False
    /// on failure. This is equivalent to the Python statement
    /// del o[key].</para>
    /// </summary>
    function  DelItem(const key: IPyObject): boolean; overload;
    /// <summary>
    /// <para>Remove the mapping for the key from this object. Return False
    /// on failure. This is equivalent to the Python statement
    /// del o[key].</para>
    /// </summary>
    function  DelItem(const key: TVarData): boolean; overload;
    /// <summary>
    /// <para>Format this object using format_spec. This is equivalent to the
    /// Python expression format(obj, format_spec).</para>
    /// <para>format_spec may be nil. In this case the call is equivalent to
    /// format(obj). Returns the formatted string on success, nil on
    /// failure.</para>
    /// </summary>
    function  Format(const format_spec: IPyObject): IPyObject;
    /// <summary>
    /// <para>This is equivalent to the Python expression iter(o). It
    /// returns a new iterator for the object argument, or the object itself
    /// if the object is already an iterator. Raises TypeError and returns
    /// nil if the object cannot be iterated.</para>
    /// </summary>
    function  GetIter: IPyObject;
    /// <summary>
    /// <para>This is the equivalent to the Python expression aiter(o).
    /// Takes an AsyncIterable object and returns an AsyncIterator for it.
    /// This is typically a new iterator but if the argument is an
    /// AsyncIterator, this returns itself. Raises TypeError and returns nil
    /// if the object cannot be iterated.</para>
    /// </summary>
    function  GetAIter: IPyObject;
    /// <summary>
    /// <para>Return an estimated length for this object. First try to return
    /// its actual length, then an estimate using __length_hint__(), and
    /// finally return the default value. On error return -1. This is the
    /// equivalent to the Python expression
    /// operator.length_hint(o, defaultvalue).</para>
    /// </summary>
    function  LengthHint(defaultvalue: Py_ssize_t): Py_ssize_t;
    /// <summary>
    /// <para>Call a callable Python object callable without any
    /// arguments.</para>
    /// <para>It is the most efficient way to call a callable Python object
    /// without any argument.</para>
    /// <para>Return the result of the call on success, or raise an exception
    /// and return nil on failure.</para>
    /// </summary>
    function  CallNoArgs: IPyObject;
    /// <summary>
    /// <para>Call a callable Python object callable, with arguments given by
    /// the tuple args, and named arguments given by the dictionary
    /// kwargs.</para>
    /// <para>args must not be nil; use an empty tuple if no arguments are
    /// needed. If no named arguments are needed, kwargs can be nil.</para>
    /// <para>Return the result of the call on success, or raise an exception
    /// and return nil on failure.</para>
    /// <para>This is the equivalent of the Python expression:
    /// callable(*args, **kwargs).</para>
    /// </summary>
    function  Call(const args, kwargs: IPyObject): IPyObject;
    /// <summary>
    /// <para>Call a callable Python object callable, with arguments given by
    /// the tuple args. If no arguments are needed, then args can be
    /// nil.</para>
    /// <para>Return the result of the call on success, or raise an exception
    /// and return nil on failure.</para>
    /// <para>This is the equivalent of the Python expression:
    /// callable(*args).</para>
    /// </summary>
    function  CallObject(const args: IPyObject): IPyObject;
    /// <summary>
    /// <para>Call a callable Python object callable. The arguments are the
    /// same as for vectorcallfunc. If callable supports vectorcall, this
    /// directly calls the vectorcall function stored in callable.</para>
    /// <para>Return the result of the call on success, or raise an exception
    /// and return nil on failure.</para>
    /// </summary>
    function  Vectorcall(const args: IPyObjectArray; const kwnames: IPyObject): IPyObject;
    /// <summary>
    /// <para>Call callable with positional arguments passed exactly as in
    /// the vectorcall protocol, but with keyword arguments passed as a
    /// dictionary kwdict. The args array contains only the positional
    /// arguments.</para>
    /// <para>Regardless of which protocol is used internally, a conversion
    /// of arguments needs to be done. Therefore, this function should only
    /// be used if the caller already has a dictionary ready to use for the
    /// keyword arguments, but not a tuple for the positional
    /// arguments.</para>
    /// </summary>
    function  VectorcallDict(const args: IPyObjectArray; const kwargs: IPyObject): IPyObject;
    /// <summary>
    /// <para>Call a callable Python object callable with exactly 1
    /// positional argument arg and no keyword arguments.</para>
    /// <para>Return the result of the call on success, or raise an
    /// exception and return nil on failure.</para>
    /// </summary>
    function  CallOneArg(const arg: IPyObject): IPyObject;
    /// <summary>
    /// <para>Cast the value of this object as a Variant.</para>
    /// </summary>
    function  CastValueAsVariant: Variant;
    /// <summary>
    /// <para>Return the PyObject pointer that was handled by this
    /// TPyObject instance.</para>
    /// <para>This function must be used when passing a PyObject pointer
    /// to a function that steals the PyObject reference.</para>
    /// </summary>
    function  UnWrap: Pointer;
    /// <summary>
    /// <para>Dump this object to stderr. This should only be used for
    /// debugging.</para>
    /// <para>The output is intended to try dumping objects even after memory
    /// corruption:</para>
    /// <code>
    /// - Information is written starting with fields that are the least
    ///   likely to crash when accessed.
    /// - This function can be called without an attached thread state, but
    ///   it's not recommended to do so: it can cause deadlocks.
    /// - An object that does not belong to the current interpreter may be
    ///   dumped, but this may also cause crashes or unintended behavior.
    /// - Implement a heuristic to detect if the object memory has been
    ///   freed. Don't display the object contents in this case, only its
    ///   memory address.
    /// - The output format may change at any time.
    /// </code>
    /// <para>Example of output:</para>
    /// <code>
    /// object address  : 0x7f80124702c0
    /// object refcount : 2
    /// object type     : 0x9902e0
    /// object type name: str
    /// object repr     : 'abcdef'
    /// </code>
    /// <para>Added in version 3.15.</para>
    /// </summary>
    procedure Dump;
    /// <summary>
    /// <para>The following function should only be used in a tp_traverse
    /// handler; calling them in other contexts may have unintended
    /// consequences.</para>
    /// <para>This function act like their counterpart without the _DuringGC
    /// suffix, but it's guaranteed to not have side effects, it doesn't set
    /// an exception on failure, and it returns/sets borrowed references as
    /// detailed in the individual documentation.</para>
    /// <para>Note that this function may fail, but as it doesn't set an
    /// exception, no error information is available. In some cases, failure
    /// is not distinguishable from a successful nil result.</para>
    /// <para>Added in version 3.15.</para>
    /// </summary>
    function  GetItemData_DuringGC: Pointer;

    /// <summary>
    /// Returns true if this class is fully initialized.
    /// </summary>
    property Initialized   : boolean         read GetInitialized;
    /// <summary>
    /// <para>Pointer to the PyObject record.</para>
    /// </summary>
    property PyObject      : PPyObject       read GetPyObject        write SetPyObject;
    /// <summary>
    /// <para>Returns True if this TPyObkect instance is the owner of the PyObject reference.</para>
    /// </summary>
    property ObjRefOwner   : boolean         read GetObjRefOwner     write SetObjRefOwner;
    /// <summary>
    /// <para>Returns the reference count of the PyObject reference.</para>
    /// </summary>
    /// <remarks>
    /// <para>See the TPy.RefCnt function for more details.</see></para>
    /// </remarks>
    property RefCnt        : Py_ssize_t      read GetRefCnt          write SetRefCnt;
    /// <summary>
    /// <para>Get the type of the Python object.</para>
    /// </summary>
    /// <remarks>
    /// <para>See the TPy.Type_ function for more details.</see></para>
    /// </remarks>
    property PyTypeObject  : PPyTypeObject   read GetPyTypeObject;
    /// <summary>
    /// <para>Convert this object as a string.</para>
    /// </summary>
    property AsString      : string          read GetAsString;
    /// <summary>
    /// <para>Convert this object as an AnsiString.</para>
    /// </summary>
    property AsAnsiString  : AnsiString      read GetAsAnsiString;
    /// <summary>
    /// <para>Convert this object as a WideString.</para>
    /// </summary>
    property AsWideString  : WideString      read GetAsWideString;
    /// <summary>
    /// <para>Convert this object as an integer.</para>
    /// </summary>
    property AsInteger     : C_Long          read GetAsInteger;
    /// <summary>
    /// <para>Convert this object as a cardinal.</para>
    /// </summary>
    property AsCardinal    : C_ULong         read GetAsCardinal;
    /// <summary>
    /// <para>Convert this object as an int64.</para>
    /// </summary>
    property AsInt64       : int64           read GetAsInt64;
    /// <summary>
    /// <para>Convert this object as a uint64.</para>
    /// </summary>
    property AsUInt64      : uint64          read GetAsUInt64;
    /// <summary>
    /// <para>Convert this object as a double.</para>
    /// </summary>
    property AsDouble      : double          read GetAsDouble;
    /// <summary>
    /// <para>Convert this object as a TDateTime.</para>
    /// </summary>
    property AsDateTime    : TDateTime       read GetAsDateTime;
    /// <summary>
    /// <para>Convert this object as a Variant.</para>
    /// </summary>
    property AsVariant     : Variant         read GetAsVariant;
    /// <summary>
    /// <para>Return true if this object is callable.</para>
    /// </summary>
    property IsCallable    : boolean         read GetIsCallable;
    /// <summary>
    /// <para>Return true if this object is a tuple object or an instance of
    /// a subtype of the tuple type.</para>
    /// </summary>
    property IsTuple       : boolean         read GetIsTuple;
    /// <summary>
    /// <para>Return true if this object is a list object or an instance of
    /// a subtype of the list type.</para>
    /// </summary>
    property IsList        : boolean         read GetIsList;
    /// <summary>
    /// <para>Return True if this object provides the sequence protocol, and
    /// False otherwise.</para>
    /// </summary>
    property IsSequence    : boolean         read GetIsSequence;
    /// <summary>
    /// <para>Return True if this object provides the mapping protocol or
    /// supports slicing, and False otherwise.</para>
    /// </summary>
    property IsMapping     : boolean         read GetIsMapping;
    /// <summary>
    /// <para>Return true if this object is a PyFloatObject or a subtype of
    /// PyFloatObject.</para>
    /// </summary>
    property IsFloat       : boolean         read GetIsFloat;
    /// <summary>
    /// <para>Return true if this object is a PyLongObject or a subtype of
    /// PyLongObject.</para>
    /// </summary>
    property IsLong        : boolean         read GetIsLong;
    /// <summary>
    /// <para>Return true if this object is of type PyBool_Type.</para>
    /// </summary>
    property IsBool        : boolean         read GetIsBool;
    /// <summary>
    /// <para>Return true if this object is a Unicode object or an instance of
    /// a Unicode subtype.</para>
    /// </summary>
    property IsUnicode     : boolean         read GetIsUnicode;
    /// <summary>
    /// <para>Return true if this object is a bytes object or an instance of a
    /// subtype of the bytes type.</para>
    /// </summary>
    property IsBytes       : boolean         read GetIsBytes;
  end;

  /// <summary>
  /// Export of a Python int object. There are two cases: If digits is nil,
  /// only use the value member. If digits is not nil, use negative, ndigits
  /// and digits members.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/long.html#c.PyLongExport">See the article about PyLongExport.</see></para>
  /// </remarks>
  IPyLongExport = interface
    ['{D4A8D7E9-4297-4363-A17B-A60F892E6DB8}']
    function GetLongExport: PPyLongExport;
    function GetValue: int64;
    function GetNegative: byte;
    function GetNdigits: Py_ssize_t;
    function GetDigits: Pointer;

    /// <summary>
    /// Pointer to the PyLongExport record.
    /// </summary>
    property LongExport : PPyLongExport read GetLongExport;
    /// <summary>
    /// The native integer value of the exported int object. Only valid if digits is nil.
    /// </summary>
    property Value      : int64         read GetValue;
    /// <summary>
    /// 1 if the number is negative, 0 otherwise. Only valid if digits is not nil.
    /// </summary>
    property Negative   : byte          read GetNegative;
    /// <summary>
    ///  Number of digits in digits array. Only valid if digits is not nil.
    /// </summary>
    property Ndigits    : Py_ssize_t    read GetNdigits;
    /// <summary>
    /// Read-only array of unsigned digits. Can be nil.
    /// </summary>
    property Digits     : Pointer       read GetDigits;
  end;

  /// <summary>
  /// A Python int writer instance.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/long.html#c.PyLongWriter">See the article about PyLongWriter.</see></para>
  /// </remarks>
  IPyLongWriter = interface
    ['{AB597432-E9BD-44E7-A8ED-9ECAAC43C811}']
    function GetInitialized: boolean;
    /// <summary>
    /// <para>Finish a PyLongWriter created by TPyLongWriter.Create().</para>
    /// <para>On success, return a Python int object. On error, set an
    /// exception and return nil.</para>
    /// <para>The function takes care of normalizing the digits and converts
    /// the object to a compact integer if needed.</para>
    /// <para>The writer instance and the digits array are invalid after the
    /// call.</para>
    /// </summary>
    function Finish: IPyObject;
    /// <summary>
    /// <para>Discard a PyLongWriter created by TPyLongWriter.Create().</para>
    /// <para>If writer is nil, no operation is performed.</para>
    /// <para>The writer instance and the digits array are invalid after the
    /// call.</para>
    /// </summary>
    procedure Discard;
    /// <summary>
    /// Returns true if this class is fully initialized.
    /// </summary>
    property Initialized : boolean read GetInitialized;
  end;

  /// <summary>
  /// A Unicode writer instance.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/unicode.html#c.PyUnicodeWriter">See the article about PyUnicodeWriter.</see></para>
  /// </remarks>
  IPyUnicodeWriter = interface
    ['{BA3439F6-DE14-4561-AAE8-A638BCBEA809}']
    function  GetWriter: PPyUnicodeWriter;
    function  GetInitialized: boolean;
    /// <summary>
    /// <para>Discard the internal Unicode buffer and destroy the writer
    /// instance.</para>
    /// <para>The writer instance is invalid after this call.</para>
    /// </summary>
    procedure Discard;
    /// <summary>
    /// <para>Return the final Python str object and destroy the writer
    /// instance.</para>
    /// <para>Set an exception and return nil on error.</para>
    /// <para>The writer instance is invalid after this call.</para>
    /// </summary>
    function  Finish: IPyObject;
    /// <summary>
    /// <para>Write the single Unicode character ch into writer.</para>
    /// <para>On success, return True. On error, set an exception, leave the
    /// writer unchanged, and return False.</para>
    /// </summary>
    function  WriteChar(ch: Py_UCS4): boolean;
    /// <summary>
    /// <para>Decode the string str from UTF-8 in strict mode and write the
    /// output into writer.</para>
    /// <para>size_ is the string length in bytes. If size is equal to -1,
    /// call strlen(str) to get the string length.</para>
    /// <para>On success, return True. On error, set an exception, leave the
    /// writer unchanged, and return False.</para>
    /// <para>See also DecodeUTF8Stateful().</para>
    /// </summary>
    function  WriteUTF8(const str: PAnsiChar; size_: Py_ssize_t): boolean;
    /// <summary>
    /// <para>Write the ASCII string str into writer.</para>
    /// <para>size_ is the string length in bytes. If size_ is equal to -1,
    /// call strlen(str) to get the string length.</para>
    /// <para>str must only contain ASCII characters. The behavior is
    /// undefined if str contains non-ASCII characters.</para>
    /// <para>On success, return True. On error, set an exception, leave the
    /// writer unchanged, and return False.</para>
    /// </summary>
    function  WriteASCII(const str: PAnsiChar; size_: Py_ssize_t): boolean;
    /// <summary>
    /// <para>Write the wide string str into writer.</para>
    /// <para>size_ is a number of wide characters. If size_ is equal to -1,
    /// call wcslen(str) to get the string length.</para>
    /// <para>On success, return True. On error, set an exception, leave the
    /// writer unchanged, and return False.</para>
    /// </summary>
    function  WriteWideChar(const str: PWCharT; size_: Py_ssize_t): boolean;
    /// <summary>
    /// <para>Writer the UCS4 string str into writer.</para>
    /// <para>size_ is a number of UCS4 characters.</para>
    /// <para>On success, return True. On error, set an exception, leave the
    /// writer unchanged, and return False.</para>
    /// </summary>
    function  WriteUCS4(const str: PPy_UCS4; size_: Py_ssize_t): boolean;
    /// <summary>
    /// <para>Call TPyObject.Str() on obj and write the output into
    /// writer.</para>
    /// <para>On success, return True. On error, set an exception, leave the
    /// writer unchanged, and return False.</para>
    /// <para>To write a str subclass which overrides the __str__() method,
    /// TPyUnicode.FromObject() can be used to get the original string.</para>
    /// </summary>
    function  WriteStr(const obj: IPyObject): boolean;
    /// <summary>
    /// <para>Call TPyObject.Repr() on obj and write the output into
    /// writer.</para>
    /// <para>If obj is nil, write the string "<NULL>" into writer.</para>
    /// <para>On success, return True. On error, set an exception, leave the
    /// writer unchanged, and return False.</para>
    /// <para>Changed in version 3.14.4: Added support for nil.</para>
    /// </summary>
    function  WriteRepr(const obj: IPyObject): boolean;
    /// <summary>
    /// <para>Write the substring str[start:end] into writer.</para>
    /// <para>str must be Python str object. start must be greater than or
    /// equal to 0, and less than or equal to end. end must be less than or
    /// equal to str length.</para>
    /// <para>On success, return True. On error, set an exception, leave the
    /// writer unchanged, and return False.</para>
    /// </summary>
    function  WriteSubstring(str: PPyObject; start, end_: Py_ssize_t): boolean;
    /// <summary>
    /// <para>Decode string_ from UTF-8 with errors error handler and
    /// write the output into writer.</para>
    /// <para>size_ is the string length in bytes. If size_ is equal to -1,
    /// call strlen(string_) to get the string length.</para>
    /// <para>errors is an error handler name, such as "replace". If errors is
    /// nil, use the strict error handler.</para>
    /// <para>If consumed is not nil, set *consumed to the number of decoded
    /// bytes on success. If consumed is nil, treat trailing incomplete UTF-8
    /// byte sequences as an error.</para>
    /// <para>On success, return True. On error, set an exception, leave the
    /// writer unchanged, and return False.</para>
    /// <para>See also WriteUTF8().</para>
    /// </summary>
    function  DecodeUTF8Stateful(const string_: PAnsiChar; length: Py_ssize_t; errors: TPyCodecErrors; var consumed: Py_ssize_t): boolean;
    /// <summary>
    /// Returns true if this class is fully initialized.
    /// </summary>
    property Initialized  : boolean           read GetInitialized;
    /// <summary>
    /// Pointer to the PyUnicodeWriter record.
    /// </summary>
    property Writer       : PPyUnicodeWriter  read GetWriter;
  end;

  /// <summary>
  /// <para>Interface to store an initialization function status: success, error
  /// or exit.</para>
  /// <para>For an error, it can store the function name which created the
  /// error.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/init_config.html#c.PyStatus">See the article about PyStatus.</see></para>
  /// </remarks>
  IPyStatus = interface
    ['{C7582FA6-89AA-49E9-84E3-B100E272D872}']
    function  GetStatus: PyStatus;
    function  GetFunc: string;
    function  GetErrMsg: string;
    function  GetExitCode: integer;
    function  GetIsException: boolean;
    function  GetIsError: boolean;
    function  GetIsExit: boolean;
    /// <summary>
    /// <para>Call exit(exitcode) if status is an exit. Print the error
    /// message and exit with a non-zero exit code if status is an error.
    /// Must only be called if PyStatus_Exception(status) is non-zero.</para>
    /// </summary>
    procedure ExitStatusException;

    /// <summary>
    /// Name of the function which created an error, can be nil.
    /// </summary>
    property func        : string    read GetFunc;
    /// <summary>
    /// Error message.
    /// </summary>
    property ErrMsg      : string    read GetErrMsg;
    /// <summary>
    /// Exit code. Argument passed to exit().
    /// </summary>
    property ExitCode    : integer   read GetExitCode;
    /// <summary>
    /// <para>Is the status an error or an exit? If true, the exception must
    /// be handled; by calling Py_ExitStatusException() for example.</para>
    /// </summary>
    property IsException : boolean   read GetIsException;
    /// <summary>
    /// <para>Is the result an error?</para>
    /// </summary>
    property IsError     : boolean   read GetIsError;
    /// <summary>
    /// <para>Is the result an exit?</para>
    /// </summary>
    property IsExit      : boolean   read GetIsExit;
    /// <summary>
    /// <para>Pointer to the PyStatus record.</para>
    /// </summary>
    property Status      : PyStatus  read GetStatus;
  end;

  /// <summary>
  /// <para>Interface containing most parameters to configure a
  /// sub-interpreter.</para>
  /// <para>Its values are used only in TPy.NewInterpreterFromConfig() and never
  /// modified by the runtime.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/subinterpreters.html">See the Multiple interpreters in a Python process article.</see></para>
  /// </remarks>
  IPyInterpreterConfig = interface
    ['{E188197E-2A57-4466-9018-DF0534D96BD1}']
    function GetConfig: Pointer;
    function Get_use_main_obmalloc: boolean;
    function Get_allow_fork: boolean;
    function Get_allow_exec: boolean;
    function Get_allow_threads: boolean;
    function Get_allow_daemon_threads: boolean;
    function Get_check_multi_interp_extensions: boolean;
    function Get_gil: TPyInterpreterCfgGIL;
    procedure Set_use_main_obmalloc(aValue: boolean);
    procedure Set_allow_fork(aValue: boolean);
    procedure Set_allow_exec(aValue: boolean);
    procedure Set_allow_threads(aValue: boolean);
    procedure Set_allow_daemon_threads(aValue: boolean);
    procedure Set_check_multi_interp_extensions(aValue: boolean);
    procedure Set_gil(aValue: TPyInterpreterCfgGIL);
    /// <summary>
    /// <para>Initial configuration values defined by the
    /// _PyInterpreterConfig_INIT macro.</para>
    /// </summary>
    procedure Init;
    /// <summary>
    /// <para>Pointer to PyInterpreterConfig.</para>
    /// </summary>
    property Config                        : Pointer                  read GetConfig;
    /// <summary>
    /// <para>If this is False then the sub-interpreter will use its own
    /// "object" allocator state.</para>
    /// <para>Otherwise it will use (share) the main interpreter's.</para>
    /// <para>If this is False then check_multi_interp_extensions must be True.
    /// If this is True then gil must not be gilOwn.</para>
    /// </summary>
    property use_main_obmalloc             : boolean                  read Get_use_main_obmalloc              write Set_use_main_obmalloc;
    /// <summary>
    /// <para>If this is False then the runtime will not support forking the
    /// process in any thread where the sub-interpreter is currently
    /// active.</para>
    /// <para>Otherwise fork is unrestricted.</para>
    /// <para>Note that the subprocess module still works when fork is
    /// disallowed.</para>
    /// </summary>
    property allow_fork                    : boolean                  read Get_allow_fork                     write Set_allow_fork;
    /// <summary>
    /// <para>If this is False then the runtime will not support replacing the
    /// current process via exec (e.g. os.execv()) in any thread where the
    /// sub-interpreter is currently active.</para>
    /// <para>Otherwise exec is unrestricted.</para>
    /// <para>Note that the subprocess module still works when exec is
    /// disallowed.</para>
    /// </summary>
    property allow_exec                    : boolean                  read Get_allow_exec                     write Set_allow_exec;
    /// <summary>
    /// <para>If this is False then the sub-interpreter's threading module won't
    /// create threads.</para>
    /// <para>Otherwise threads are allowed.</para>
    /// </summary>
    property allow_threads                 : boolean                  read Get_allow_threads                  write Set_allow_threads;
    /// <summary>
    /// <para>If this is False then the sub-interpreter's threading module won't
    /// create daemon threads.</para>
    /// <para>Otherwise daemon threads are allowed (as long as allow_threads is
    /// non-zero).</para>
    /// </summary>
    property allow_daemon_threads          : boolean                  read Get_allow_daemon_threads           write Set_allow_daemon_threads;
    /// <summary>
    /// <para>If this is False then all extension modules may be imported,
    /// including legacy (single-phase init) modules, in any thread where the
    /// sub-interpreter is currently active.</para>
    /// <para>Otherwise only multi-phase init extension modules (see PEP 489)
    /// may be imported. (Also see Py_mod_multiple_interpreters.)</para>
    /// <para>This must be True if use_main_obmalloc is True.</para>
    /// </summary>
    property check_multi_interp_extensions : boolean                  read Get_check_multi_interp_extensions  write Set_check_multi_interp_extensions;
    /// <summary>
    /// <para>This determines the operation of the GIL for the sub-interpreter.
    /// It may be one of the following:</para>
    /// <code>
    /// - gilDefault: Use the default selection (gilShared).
    /// - gilShared: Use (share) the main interpreter's GIL.
    /// - gilOwn: Use the sub-interpreter's own GIL.
    /// </code>
    /// <para>If this is gilOwn then use_main_obmalloc must be False.</para>
    /// </summary>
    property gil                           : TPyInterpreterCfgGIL     read Get_gil                            write Set_gil;
  end;

  /// <summary>
  /// <para>This interface represents the state shared by a number of
  /// cooperating threads. Threads belonging to the same interpreter share
  /// their module administration and a few other internal items. There are no
  /// public members in this structure.</para>
  /// <para>Threads belonging to different interpreters initially share nothing,
  /// except process state like available memory, open file descriptors and
  /// such. The global interpreter lock is also shared by all threads,
  /// regardless of to which interpreter they belong.</para>
  /// <para>Changed in version 3.12: PEP 684 introduced the possibility of a
  /// per-interpreter GIL. See TPy.NewInterpreterFromConfig().</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/subinterpreters.html">See the Multiple interpreters in a Python process article.</see></para>
  /// </remarks>
  IPyInterpreterState = interface
    ['{26733A3F-135C-4889-BBA0-84B78764EA94}']
    function  GetInitialized: boolean;
    function  GetState: PPyInterpreterState;
    function  GetID: int64;
    function  GetDict: IPyObject;
    procedure SetState(aState: PPyInterpreterState);
    /// <summary>
    /// <para>Reset all information in an interpreter state object. There must
    /// be an attached thread state for the interpreter.</para>
    /// <para>Raises an auditing event cpython.PyInterpreterState_Clear with
    /// no arguments.</para>
    /// </summary>
    procedure Clear;
    /// <summary>
    /// <para>Destroy an interpreter state object. There should not be an
    /// attached thread state for the target interpreter. The interpreter
    /// state must have been reset with a previous call to Clear().</para>
    /// </summary>
    procedure Delete;
    /// <summary>
    /// <para>Return the next interpreter state object after interp from the
    /// list of all such objects.</para>
    /// </summary>
    function  Next: IPyInterpreterState;
    /// <summary>
    /// <para>Return the pointer to the first PyThreadState object in the list
    /// of threads associated with the interpreter interp.</para>
    /// </summary>
    function  ThreadHead: IPyThreadState;

    /// <summary>
    /// <para>Returns true if the class is fully initialized.</para>
    /// </summary>
    property Initialized  : boolean               read GetInitialized;
    /// <summary>
    /// <para>Pointer to PyInterpreterState</para>
    /// </summary>
    property State        : PPyInterpreterState   read GetState         write SetState;
    /// <summary>
    /// <para>Return the interpreter's unique ID. If there was any error in
    /// doing so then -1 is returned and an error is set.</para>
    /// <para>The caller must have an attached thread state.</para>
    /// <para>Added in version 3.7.</para>
    /// </summary>
    property ID           : int64                 read GetID;
    /// <summary>
    /// <para>Return a dictionary in which interpreter-specific data may be
    /// stored. If this function returns nil then no exception has been
    /// raised and the caller should assume no interpreter-specific dict is
    /// available.</para>
    /// <para>This is not a replacement for TPyModule.GetState(), which
    /// extensions should use to store interpreter-specific state
    /// information.</para>
    /// <para>The returned dictionary is borrowed from the interpreter and is
    /// valid until interpreter shutdown.</para>
    /// <para>Added in version 3.8.</para>
    /// </summary>
    property Dict         : IPyObject             read GetDict;
  end;

  /// <summary>
  /// <para>An interpreter guard class.</para>
  /// <para>By holding an interpreter guard, the caller can ensure that the
  /// interpreter will not finalize until the guard is closed (through
  /// TPyInterpreterGuard.Close()).</para>
  /// <para>When a guard is held, a thread attempting to finalize the
  /// interpreter will block until the guard is closed before starting
  /// finalization. After finalization has started, threads are forever unable
  /// to acquire guards for that interpreter. This means that if you forget to
  /// close an interpreter guard, the process will permanently hang during
  /// finalization!</para>
  /// <para>Holding a guard for an interpreter is similar to holding a strong reference to a Python object, except finalization does not happen automatically after all guards are released: it requires an explicit Py_EndInterpreter() call.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/interp-lifecycle.html#cautions-regarding-interpreter-finalization">See the Python article about Cautions regarding interpreter finalization.</see></para>
  /// <para>Added in version 3.15.</para>
  /// </remarks>
  IPyInterpreterGuard = interface
    ['{71EB6F44-DA48-4F86-81E4-5DECA9620DCA}']
    function  GetInitialized: boolean;
    function  GetGuard: PPyInterpreterGuard;
    procedure SetGuard(aValue: PPyInterpreterGuard);
    /// <summary>
    /// <para>Close an interpreter guard, allowing the interpreter to start
    /// finalization if no other guards remain. If an interpreter guard is
    /// never closed, the interpreter will infinitely wait when trying to
    /// enter finalization!</para>
    /// <para>After an interpreter guard is closed, it may not be used in
    /// TPyThreadState.Ensure(). Doing so will result in undefined
    /// behavior.</para>
    /// <para>This function cannot fail, and the caller doesn't need to hold
    /// an attached thread state.</para>
    /// <para>Added in version 3.15.</para>
    /// </summary>
    procedure Close;
    /// <summary>
    /// <para>Returns true if the class is fully initialized.</para>
    /// </summary>
    property Initialized  : boolean               read GetInitialized;
    /// <summary>
    /// <para>Pointer to PyInterpreterGuard</para>
    /// </summary>
    property Guard        : PPyInterpreterGuard   read GetGuard         write SetGuard;
  end;

  /// <summary>
  /// <para>A view of an interpreter.</para>
  /// <para>In some cases, it may be necessary to access an interpreter that
  /// may have been deleted. This can be done using interpreter views.</para>
  /// <para>This is a thread-safe way to access an interpreter that may have
  /// be finalizing or already destroyed.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/interp-lifecycle.html#cautions-regarding-interpreter-finalization">See the Python article about Cautions regarding interpreter finalization.</see></para>
  /// <para>Added in version 3.15.</para>
  /// </remarks>
  IPyInterpreterView = interface
    ['{C10F577D-3290-4C2A-91E3-9D41A67C7AFB}']
    function  GetInitialized: boolean;
    function  GetView: PPyInterpreterView;
    procedure SetView(aValue: PPyInterpreterView);
    /// <summary>
    /// <para>Close an interpreter view.</para>
    /// <para>If an interpreter view is never closed, the view's memory will
    /// never be freed, but there are no other consequences. (In contrast,
    /// forgetting to close a guard will infinitely hang the main thread
    /// during finalization.)</para>
    /// <para>This function cannot fail, and the caller doesn't need to hold
    /// an attached thread state.</para>
    /// <para>Added in version 3.15.</para>
    /// </summary>
    procedure Close;
    /// <summary>
    /// <para>Returns true if the class is fully initialized.</para>
    /// </summary>
    property Initialized  : boolean               read GetInitialized;
    /// <summary>
    /// <para>Pointer to PyInterpreterView</para>
    /// </summary>
    property View         : PPyInterpreterView    read GetView         write SetView;
  end;

  /// <summary>
  /// This interface represents the state of a single thread.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/threads.html#c.PyThreadState">See the article about PyThreadState.</see></para>
  /// </remarks>
  IPyThreadState = interface
    ['{0C8502D8-C0EF-4F8E-A7B3-42AB050BA121}']
    function  GetInitialized: boolean;
    function  GetThreadState: PPyThreadState;
    function  GetID: int64;
    function  GetDict: IPyObject;
    function  GetInterpreter: IPyInterpreterState;
    function  GetFrame: IPyObject;
    procedure SetThreadState(aThreadState: PPyThreadState);
    /// <summary>
    /// <para>Reset all information in a thread state object.
    /// IPyThreadState.ThreadState must be attached</para>
    /// <para>Changed in version 3.9: This function now calls the
    /// PyThreadState.on_delete callback. Previously, that happened in
    /// TPyThreadState.Delete().</para>
    /// <para>Changed in version 3.13: The PyThreadState.on_delete callback
    /// was removed.</para>
    /// </summary>
    procedure Clear;
    /// <summary>
    /// <para>Destroy a thread state object. IPyThreadState.ThreadState should
    /// not be attached to any thread. IPyThreadState.ThreadState must have been
    /// reset with a previous call to TPyThreadState.Clear().</para>
    /// </summary>
    procedure Delete;
    /// <summary>
    /// <para>Asynchronously raise an exception in a thread. The id argument
    /// is the thread id of the target thread; exc is the exception object to
    /// be raised. This function does not steal any references to exc.
    /// To prevent naive misuse, you must write your own C extension to call
    /// this. Must be called with an attached thread state. Returns the number
    /// of thread states modified; this is normally one, but will be zero if
    /// the thread id isn't found. If exc is nil, the pending exception
    /// (if any) for the thread is cleared. This raises no exceptions.</para>
    /// <para>Changed in version 3.7: The type of the id parameter changed
    /// from long to unsigned long.</para>
    /// </summary>
    function  SetAsyncExc(id: C_ULong; const exc: IPyObject): integer;
    /// <summary>
    /// <para>Suspend tracing and profiling in the Python thread state
    /// IPyThreadState.ThreadState.</para>
    /// <para>Resume them using the TPyThreadState.LeaveTracing()
    /// function.</para>
    /// <para>Added in version 3.11.</para>
    /// </summary>
    procedure EnterTracing;
    /// <summary>
    /// <para>Resume tracing and profiling in the Python thread state
    /// IPyThreadState.ThreadState suspended by the
    /// TPyThreadState.EnterTracing() function.</para>
    /// <para>See also TPyEval.SetTrace() and TPyEval.SetProfile()
    /// functions.</para>
    /// <para>Added in version 3.11.</para>
    /// </summary>
    procedure LeaveTracing;
    /// <summary>
    /// <para>Set the attached thread state to IPyThreadState.ThreadState,
    /// and return the thread state that was attached prior to calling.</para>
    /// <para>This function is safe to call without an attached thread state;
    /// it will simply return nil indicating that there was no prior thread
    /// state.</para>
    /// <para>See also TPyEval.ReleaseThread()</para>
    /// <para>Note Similar to TPyGILState.Ensure(), this function will hang
    /// the thread if the runtime is finalizing.</para>
    /// </summary>
    function  Swap: IPyThreadState;
    /// <summary>
    /// <para>Return the next thread state object after
    /// IPyThreadState.ThreadState from the list
    /// of all such objects belonging to the same PyInterpreterState
    /// object.</para>
    /// </summary>
    function  Next: IPyThreadState;
    /// <summary>
    /// <para>Return the PyThreadState pointer that was handled by this
    /// TPyThreadState instance.</para>
    /// <para>This function must be used when passing a PyThreadState pointer
    /// to a function that steals the PyThreadState reference.</para>
    /// </summary>
    function  UnWrap: Pointer;

    /// <summary>
    /// <para>Returns true if the class is fully initialized.</para>
    /// </summary>
    property Initialized  : boolean               read GetInitialized;
    /// <summary>
    /// <para>Pointer to PyThreadState</para>
    /// </summary>
    property ThreadState  : PPyThreadState        read GetThreadState         write SetThreadState;
    /// <summary>
    /// <para>Get the unique thread state identifier of the Python thread
    /// state tstate.</para>
    /// <para>tstate must not be nil, and must be attached.</para>
    /// <para>Added in version 3.9.</para>
    /// </summary>
    property ID           : int64                 read GetID;
    /// <summary>
    /// <para>Return a dictionary in which extensions can store
    /// thread-specific state information. Each extension should use a unique
    /// key to use to store state in the dictionary. It is okay to call this
    /// function when no thread state is attached. If this function returns
    /// nil, no exception has been raised and the caller should assume no
    /// thread state is attached.</para>
    /// </summary>
    property Dict         : IPyObject             read GetDict;
    /// <summary>
    /// <para>Get the interpreter of the Python thread state tstate.</para>
    /// <para>tstate must not be nil, and must be attached.</para>
    /// </summary>
    property Interpreter  : IPyInterpreterState   read GetInterpreter;
    /// <para>Get the current frame of the Python thread state tstate.</para>
    /// <para>Return a strong reference. Return nil if no frame is currently
    /// executing.</para>
    /// <para>See also TPyEval.GetFrame().</para>
    /// <para>tstate must not be nil, and must be attached.</para>
    /// <para>Added in version 3.9.</para>
    /// </summary>
    property Frame        : IPyObject             read GetFrame;
  end;

  /// <summary>
  /// The interface represents the GIL state.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/threads.html#c.PyGILState_STATE">See the article about PyGILState_STATE.</see></para>
  /// </remarks>
  IPyGILState = interface
    ['{FA7CC9AD-C157-4070-B577-8C08DFAB41C4}']
    function  GetInitialized: boolean;
    function  GetState: PyGILState_STATE;
    procedure SetInitialized(aValue: boolean);
    procedure SetState(aState: PyGILState_STATE);
    /// <summary>
    /// <para>Release any resources previously acquired. After this call,
    /// Python's state will be the same as it was prior to the corresponding
    /// TPyGILState.Ensure() call (but generally this state will be unknown
    /// to the caller, hence the use of the GILState API).</para>
    /// <para>Every call to TPyGILState.Ensure() must be matched by a call to
    /// TPyGILState.Release() on the same thread.</para>
    /// </summary>
    procedure Release;

    /// <summary>
    /// <para>Returns true if the class is fully initialized.</para>
    /// </summary>
    property Initialized  : boolean           read GetInitialized   write SetInitialized;
    /// <summary>
    /// <para>GIL state</para>
    /// </summary>
    property State        : PyGILState_STATE  read GetState         write SetState;
  end;

  /// <summary>
  /// A mutual exclusion lock.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/synchronization.html#c.PyThread_type_lock">See the article about PyThread_type_lock.</see></para>
  /// </remarks>
  IPyThreadLock = interface
    ['{A39E9504-264D-4648-92D6-F6FD54F16FA5}']
    function  GetInitialized: boolean;
    function  GetLock: PyThread_type_lock;
    /// <summary>
    /// <para>Allocate a new lock.</para>
    /// <para>On success, this function returns a lock; on failure, this
    /// function returns nil without an exception set.</para>
    /// <para>The caller does not need to hold an attached thread state.</para>
    /// </summary>
    procedure AllocateLock;
    /// <summary>
    /// <para>Destroy lock. The lock should not be held by any thread when
    /// calling this.</para>
    /// <para>The caller does not need to hold an attached thread state.</para>
    /// </summary>
    procedure FreeLock;
    /// <summary>
    /// <para>Acquire lock.</para>
    /// <para>If waitflag is True and another thread currently holds the lock,
    /// this function will wait until the lock can be acquired and will always
    /// return PY_LOCK_ACQUIRED.</para>
    /// <para>If waitflag is False and another thread holds the lock, this
    /// function will not wait and instead return PY_LOCK_FAILURE. If the
    /// lock is not held by any other thread, then this function will acquire
    /// it and return PY_LOCK_ACQUIRED.</para>
    /// <para>Unlike AcquireLockTimed(), acquiring the lock cannot
    /// be interrupted by a signal.</para>
    /// <para>The caller does not need to hold an attached thread state.</para>
    /// </summary>
    function AcquireLock(waitflag: boolean): PyLockStatus;
    /// <summary>
    /// <para>Acquire lock with a timeout.</para>
    /// <para>This will wait for microseconds microseconds to acquire the
    /// lock. If the timeout expires, this function returns PY_LOCK_FAILURE.
    /// If microseconds is -1, this will wait indefinitely until the lock has
    /// been released.</para>
    /// <para>If intr_flag is True, acquiring the lock may be interrupted by a
    /// signal, in which case this function returns PY_LOCK_INTR. Upon
    /// interruption, it's generally expected that the caller makes a call to
    /// TPy.MakePendingCalls() to propagate an exception to Python code.</para>
    /// <para>If the lock is successfully acquired, this function returns
    /// PY_LOCK_ACQUIRED.</para>
    /// <para>The caller does not need to hold an attached thread state.</para>
    /// </summary>
    function AcquireLockTimed(microseconds: PY_TIMEOUT_T; intr_flag: boolean): PyLockStatus;
    /// <summary>
    /// <para>Release lock. If lock is not held, then this function issues a
    /// fatal error.</para>
    /// <para>The caller does not need to hold an attached thread state.</para>
    /// </summary>
    procedure ReleaseLock;
    /// <summary>
    /// <para>Returns true if the class is fully initialized.</para>
    /// </summary>
    property Initialized : boolean              read GetInitialized;
    /// <summary>
    /// <para>The mutual exclusion lock</para>
    /// </summary>
    property Lock        : PyThread_type_lock   read GetLock;
  end;

  /// <summary>
  /// <para>This interface represents the state of a thread key, the
  /// definition of which may depend on the underlying TLS implementation,
  /// and it has an internal field representing the key's initialization
  /// state.</para>
  /// <para>When Py_LIMITED_API is not defined, static allocation of this type
  /// by Py_tss_NEEDS_INIT is allowed.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/tls.html#c.Py_tss_t">See the article about Py_tss_t.</see></para>
  /// </remarks>
  IPyThreadTSS = interface
    ['{5F88B7E1-C685-492E-A829-35EF92288C9E}']
    function  GetInitialized: boolean;
    function  GetKey: PPy_tss_t;
    function  GetIsCreated: boolean;
    function  GetValue: pointer;
    procedure SetValue(value: pointer);
    /// <summary>
    /// <para>Return a value which is the same state as a value initialized
    /// with Py_tss_NEEDS_INIT, or nil in the case of dynamic allocation
    /// failure.</para>
    /// </summary>
    procedure TSSAlloc;
    /// <summary>
    /// <para>Free the given key allocated by TSSAlloc(), after first calling
    /// TSSDelete() to ensure any associated thread locals have been
    /// unassigned. This is a no-op if the key argument is nil.</para>
    /// <para>Note A freed key becomes a dangling pointer. You should reset
    /// the key to nil.</para>
    /// </summary>
    procedure TSSFree;
    /// <summary>
    /// <para>Return True on successful initialization of a TSS key.</para>
    /// <para>The behavior is undefined if the value pointed to by the key
    /// argument is not initialized by Py_tss_NEEDS_INIT. This function can
    /// be called repeatedly on the same key - calling it on an already
    /// initialized key is a no-op and immediately returns success.</para>
    /// </summary>
    function    TSSCreate: boolean;
    /// <summary>
    /// <para>Destroy a TSS key to forget the values associated with the key
    /// across all threads, and change the key's initialization state to
    /// uninitialized. A destroyed key is able to be initialized again by
    /// TSSCreate(). This function can be called repeatedly on the same
    /// key - calling it on an already destroyed key is a no-op.</para>
    /// </summary>
    procedure   TSSDelete;

    /// <summary>
    /// <para>Returns true if the class is fully initialized.</para>
    /// </summary>
    property Initialized : boolean     read GetInitialized;
    /// <summary>
    /// <para>The state of a thread key</para>
    /// </summary>
    property Key         : PPy_tss_t   read GetKey;
    /// <summary>
    /// <para>Return True if the given Py_tss_t has been initialized by
    /// TSSCreate().</para>
    /// </summary>
    property IsCreated   : boolean     read GetIsCreated;
    /// <summary>
    /// <para></para>
    /// </summary>
    property Value       : pointer     read GetValue        write SetValue;
  end;

  /// <summary>
  /// Interface to configure the Python initialization.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/init_config.html#c.PyInitConfig">See the article about PyInitConfig.</see></para>
  /// </remarks>
  IPyInitConfig = interface
    ['{7978019A-332B-433C-9376-1C35A737B47D}']
    function GetConfig: Pointer;
    function GetInitialized: boolean;
    function GetError: string;
    function GetExitCode: integer;
    function Get_allocator: PyMemAllocatorName;
    function Get_argv: TStringDynArray;
    function Get_base_exec_prefix: string;
    function Get_base_executable: string;
    function Get_base_prefix: string;
    function Get_buffered_stdio: boolean;
    function Get_bytes_warning: int64;
    function Get_check_hash_pycs_mode: string;
    function Get_code_debug_ranges: boolean;
    function Get_coerce_c_locale: integer;
    function Get_coerce_c_locale_warn: boolean;
    function Get_configure_c_stdio: boolean;
    function Get_configure_locale: boolean;
    function Get_cpu_count: int64;
    function Get_dev_mode: boolean;
    function Get_dump_refs: boolean;
    function Get_dump_refs_file: string;
    function Get_exec_prefix: string;
    function Get_executable: string;
    function Get_faulthandler: boolean;
    function Get_filesystem_encoding: string;
    function Get_filesystem_errors: string;
    function Get_hash_seed: int64;
    function Get_home: string;
    function Get_import_time: int64;
    function Get_inspect: boolean;
    function Get_install_signal_handlers: boolean;
    function Get_int_max_str_digits: int64;
    function Get_interactive: boolean;
    function Get_isolated: boolean;
    function Get_lazy_imports: PyImport_LazyImportsMode;       //****** 3.15.0
    {$IFDEF MSWINDOWS}
    function Get_legacy_windows_fs_encoding: boolean;
    function Get_legacy_windows_stdio: boolean;
    {$ENDIF}
    function Get_malloc_stats: boolean;
    function Get_module_search_paths: string;
    function Get_optimization_level: TPyOptimizationLevel;
    function Get_orig_argv: TStringDynArray;
    function Get_parse_argv: boolean;
    function Get_parser_debug: boolean;
    function Get_pathconfig_warnings: boolean;
    function Get_perf_profiling: int64;
    function Get_platlibdir: string;
    function Get_prefix: string;
    function Get_program_name: string;
    function Get_pycache_prefix: string;
    function Get_pymalloc_hugepages: boolean;                  //****** 3.15.0
    function Get_quiet: boolean;
    function Get_run_command: string;
    function Get_run_filename: string;
    function Get_run_module: string;
    function Get_run_presite: string;
    function Get_safe_path: boolean;
    function Get_show_ref_count: boolean;
    function Get_site_import: boolean;
    function Get_skip_source_first_line: boolean;
    function Get_stdio_encoding: string;
    function Get_stdio_errors: string;
    function Get_stdlib_dir: string;
    function Get_tracemalloc: int64;
    function Get_use_environment: boolean;
    function Get_use_frozen_modules: boolean;
    function Get_use_hash_seed: boolean;
    function Get_use_system_logger: boolean;
    function Get_user_site_directory: boolean;
    function Get_utf8_mode: integer;
    function Get_verbose: TPyVerboseMode;
    function Get_warn_default_encoding: boolean;
    function Get_warnoptions: TStringDynArray;
    function Get_write_bytecode: boolean;
    function Get_xoptions: TStringDynArray;

    procedure Set_allocator(aValue: PyMemAllocatorName);
    procedure Set_argv(const aValue: TStringDynArray);
    procedure Set_base_exec_prefix(const aValue: string);
    procedure Set_base_executable(const aValue: string);
    procedure Set_base_prefix(const aValue: string);
    procedure Set_buffered_stdio(aValue: boolean);
    procedure Set_bytes_warning(aValue: int64);
    procedure Set_check_hash_pycs_mode(const aValue: string);
    procedure Set_code_debug_ranges(aValue: boolean);
    procedure Set_coerce_c_locale(aValue: integer);
    procedure Set_coerce_c_locale_warn(aValue: boolean);
    procedure Set_configure_c_stdio(aValue: boolean);
    procedure Set_configure_locale(aValue: boolean);
    procedure Set_cpu_count(aValue: int64);
    procedure Set_dev_mode(aValue: boolean);
    procedure Set_dump_refs(aValue: boolean);
    procedure Set_dump_refs_file(const aValue: string);
    procedure Set_exec_prefix(const aValue: string);
    procedure Set_executable(const aValue: string);
    procedure Set_faulthandler(aValue: boolean);
    procedure Set_filesystem_encoding(const aValue: string);
    procedure Set_filesystem_errors(const aValue: string);
    procedure Set_hash_seed(aValue: int64);
    procedure Set_home(const aValue: string);
    procedure Set_import_time(aValue: int64);
    procedure Set_inspect(aValue: boolean);
    procedure Set_install_signal_handlers(aValue: boolean);
    procedure Set_int_max_str_digits(aValue: int64);
    procedure Set_interactive(aValue: boolean);
    procedure Set_isolated(aValue: boolean);
    procedure Set_lazy_imports(aValue: PyImport_LazyImportsMode);        //****** 3.15.0
    {$IFDEF MSWINDOWS}
    procedure Set_legacy_windows_fs_encoding(aValue: boolean);
    procedure Set_legacy_windows_stdio(aValue: boolean);
    {$ENDIF}
    procedure Set_malloc_stats(aValue: boolean);
    procedure Set_module_search_paths(const aValue: string);
    procedure Set_optimization_level(aValue: TPyOptimizationLevel);
    procedure Set_orig_argv(const aValue: TStringDynArray);
    procedure Set_parse_argv(aValue: boolean);
    procedure Set_parser_debug(aValue: boolean);
    procedure Set_pathconfig_warnings(aValue: boolean);
    procedure Set_perf_profiling(aValue: int64);
    procedure Set_platlibdir(const aValue: string);
    procedure Set_prefix(const aValue: string);
    procedure Set_program_name(const aValue: string);
    procedure Set_pycache_prefix(const aValue: string);
    procedure Set_pymalloc_hugepages(aValue: boolean);                   //****** 3.15.0
    procedure Set_quiet(aValue: boolean);
    procedure Set_run_command(const aValue: string);
    procedure Set_run_filename(const aValue: string);
    procedure Set_run_module(const aValue: string);
    procedure Set_run_presite(const aValue: string);
    procedure Set_safe_path(aValue: boolean);
    procedure Set_show_ref_count(aValue: boolean);
    procedure Set_site_import(aValue: boolean);
    procedure Set_skip_source_first_line(aValue: boolean);
    procedure Set_stdio_encoding(const aValue: string);
    procedure Set_stdio_errors(const aValue: string);
    procedure Set_stdlib_dir(const aValue: string);
    procedure Set_tracemalloc(aValue: int64);
    procedure Set_use_environment(aValue: boolean);
    procedure Set_use_frozen_modules(aValue: boolean);
    procedure Set_use_hash_seed(aValue: boolean);
    procedure Set_use_system_logger(aValue: boolean);
    procedure Set_user_site_directory(aValue: boolean);
    procedure Set_utf8_mode(aValue: integer);
    procedure Set_verbose(aValue: TPyVerboseMode);
    procedure Set_warn_default_encoding(aValue: boolean);
    procedure Set_warnoptions(const aValue: TStringDynArray);
    procedure Set_write_bytecode(aValue: boolean);
    procedure Set_xoptions(const aValue: TStringDynArray);

    /// <summary>
    /// <para>Test if the configuration has an option called name.</para>
    /// <para>Return True if the option exists, or return False otherwise.</para>
    /// </summary>
    function HasOption(const aOption: string): boolean;
    /// <summary>
    /// <para>Get an integer configuration option.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// </summary>
    function GetInt(const aName: string; var aValue: int64): boolean;
    /// <summary>
    /// <para>Get a string configuration option as string.</para>
    /// <para>Set aValue, and return True on success.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// </summary>
    function GetStr(const aName: string; var aValue: string): boolean;
    /// <summary>
    /// <para>Get a string list configuration option as a TStringList.</para>
    /// <para>Set aValue, and return True on success.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// </summary>
    function GetStrList(const aName: string; var aItems: TStringList): boolean; overload;
    /// <summary>
    /// <para>Get a string list configuration option as a TStringDynArray.</para>
    /// <para>Set aValue, and return True on success.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// </summary>
    function GetStrList(const aName: string; var aItems: TStringDynArray): boolean; overload;
    /// <summary>
    /// <para>Set an integer configuration option.</para>
    /// <para>Return True on success.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// </summary>
    function SetInt(const aName: string; aValue: int64): boolean;
    /// <summary>
    /// <para>Set a string configuration option.</para>
    /// <para>Return True on success.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// </summary>
    function SetStr(const aName, aValue: string): boolean;
    /// <summary>
    /// <para>Set a string list configuration option from a TStringList.</para>
    /// <para>Return True on success.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// </summary>
    function SetStrList(const aName: string; const aItems: TStringList): boolean; overload;
    /// <summary>
    /// <para>Set a string list configuration option from a TStringDynArray.</para>
    /// <para>Return True on success.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// </summary>
    function SetStrList(const aName: string; const aItems: TStringDynArray): boolean; overload;
    /// <summary>
    /// <para>Add a built-in extension module to the table of built-in
    /// modules.</para>
    /// <para>The new module can be imported by the name name, and uses the
    /// function initfunc as the initialization function called on the first
    /// attempted import.</para>
    /// <para>Return True on success.</para>
    /// <para>Set an error in config and return False on error.</para>
    /// <para>If Python is initialized multiple times,
    /// AddModule() must be called at each Python initialization.</para>
    /// <para>Similar to the TPyImport.AppendInittab() function.</para>
    /// </summary>
    function AddModule(const aName: string; initfunc_: initfunc): boolean;

    /// <summary>
    /// Returns true if this class is fully initialized.
    /// </summary>
    property Initialized     : boolean      read GetInitialized;
    /// <summary>
    /// Pointer to the PyInitConfig record.
    /// </summary>
    property Config          : Pointer      read GetConfig;
    /// <summary>
    /// <para>Get the config error message.</para>
    /// <para>If config has an exit code, format the exit code as an error
    /// message.</para>
    /// <para>The error message remains valid until another PyInitConfig
    /// function is called with config. The caller doesn't have to free the
    /// error message.</para>
    /// </summary>
    property Error                      : string                   read GetError;
    /// <summary>
    /// <para>Get the config exit code.</para>
    /// <para>Set *exitcode and return 1 if config has an exit code set.</para>
    /// <para>Return 0 if config has no exit code set.</para>
    /// <para>Only the Py_InitializeFromInitConfig() function can set an exit
    /// code if the parse_argv option is non-zero.</para>
    /// <para>An exit code can be set when parsing the command line failed
    /// (exit code 2) or when a command line option asks to display the
    /// command line help (exit code 0).</para>
    /// </summary>
    property ExitCode                   : integer                  read GetExitCode;
    /// <summary>
    /// Name of the Python memory allocator.
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/memory.html#memory">See the Memory Management article.</see></para>
    /// <para>See PyMemAllocatorName.</para>
    /// </remarks>
    property allocator                  : PyMemAllocatorName       read Get_allocator                      write Set_allocator;
    /// <summary>
    /// <para>Set sys.argv command line arguments based on argv. These
    /// parameters are similar to those passed to the program's main()
    /// function with the difference that the first entry should refer to the
    /// script file to be executed rather than the executable hosting the
    /// Python interpreter. If there isn't a script that will be run, the
    /// first entry in argv can be an empty string.</para>
    /// <para>Set parse_argv to True to parse argv the same way the regular
    /// Python parses Python command line arguments and then to strip Python
    /// arguments from argv.</para>
    /// <para>If argv is empty, an empty string is added to ensure that
    /// sys.argv always exists and is never empty.</para>
    /// </summary>
    /// <remarks>
    /// <para>See also the orig_argv member.</para>
    /// </remarks>
    property argv                       : TStringDynArray          read Get_argv                           write Set_argv;
    /// <summary>
    /// <para>Equivalent to exec_prefix, but referring to the base Python
    /// installation.</para>
    /// <para>When running under Virtual Environments, exec_prefix gets
    /// overwritten to the virtual environment prefix. base_exec_prefix,
    /// conversely, does not change, and always points to the base Python
    /// installation.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sys_path_init.html#sys-path-init-virtual-environments">Refer to Virtual Environments for more information.</see></para>
    /// <para>See also PyConfig.exec_prefix.</para>
    /// </remarks>
    property base_exec_prefix           : string                   read Get_base_exec_prefix               write Set_base_exec_prefix;
    /// <summary>
    /// <para>Python base executable: sys._base_executable.</para>
    /// <para>Set by the __PYVENV_LAUNCHER__ environment variable.</para>
    /// <para>Set from PyConfig.executable if empty.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para>See also PyConfig.executable.</para>
    /// </remarks>
    property base_executable            : string                   read Get_base_executable                write Set_base_executable;
    /// <summary>
    /// <para>Equivalent to prefix, but referring to the base Python
    /// installation.</para>
    /// <para>When running under virtual environment, prefix gets overwritten
    /// to the virtual environment prefix. base_prefix, conversely, does not
    /// change, and always points to the base Python installation.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sys_path_init.html#sys-path-init-virtual-environments">Refer to Virtual Environments for more information.</see></para>
    /// <para>See also PyConfig.prefix.</para>
    /// </remarks>
    property base_prefix                : string                   read Get_base_prefix                    write Set_base_prefix;
    /// <summary>
    /// <para>If equals to False and configure_c_stdio is True, disable
    /// buffering on the C streams stdout and stderr.</para>
    /// <para>Set to False by the -u command line option and the
    /// PYTHONUNBUFFERED environment variable.</para>
    /// <para>stdin is always opened in buffered mode.</para>
    /// <para>Default: True.</para>
    /// </summary>
    property buffered_stdio             : boolean                  read Get_buffered_stdio                 write Set_buffered_stdio;
    /// <summary>
    /// <para>If equals to 1, issue a warning when comparing bytes or
    /// bytearray with str, or comparing bytes with int.</para>
    /// <para>If equal or greater to 2, raise a BytesWarning exception in
    /// these cases.</para>
    /// <para>Incremented by the -b command line option.</para>
    /// <para>Default: 0.</para>
    /// </summary>
    property bytes_warning              : int64                    read Get_bytes_warning                  write Set_bytes_warning;
    /// <summary>
    /// <para>Control the validation behavior of hash-based .pyc files: value
    /// of the --check-hash-based-pycs command line option.</para>
    /// <para>Valid values:</para>
    /// <code>
    /// - "always": Hash the source file for invalidation regardless of value
    ///   of the 'check_source' flag.
    /// - "never": Assume that hash-based pycs always are valid.
    /// - "default": The 'check_source' flag in hash-based pycs determines
    ///   invalidation.
    /// </code>
    /// <para>Default: "default".</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://peps.python.org/pep-0552/">See also PEP 552 "Deterministic pycs".</see></para>
    /// </remarks>
    property check_hash_pycs_mode       : string                   read Get_check_hash_pycs_mode           write Set_check_hash_pycs_mode;
    /// <summary>
    /// <para>If equals to False, disables the inclusion of the end line and
    /// column mappings in code objects. Also disables traceback printing
    /// carets to specific error locations.</para>
    /// <para>Set to False by the PYTHONNODEBUGRANGES environment variable
    /// and by the -X no_debug_ranges command line option.</para>
    /// <para>Default: True.</para>
    /// </summary>
    property code_debug_ranges          : boolean                  read Get_code_debug_ranges              write Set_code_debug_ranges;
    /// <summary>
    /// <para>If equals to 2, coerce the C locale.</para>
    /// <para>If equals to 1, read the LC_CTYPE locale to decide if it should
    /// be coerced.</para>
    /// <para>See the locale encoding.</para>
    /// <para>Default: -1 in Python config, 0 in isolated config.</para>
    /// </summary>
    property coerce_c_locale            : integer                  read Get_coerce_c_locale                write Set_coerce_c_locale;
    /// <summary>
    /// <para>If True, emit a warning if the C locale is coerced.</para>
    /// <para>Default: True in Python config, False in isolated config.</para>
    /// </summary>
    property coerce_c_locale_warn       : boolean                  read Get_coerce_c_locale_warn           write Set_coerce_c_locale_warn;
    /// <summary>
    /// <para>If True, configure C standard streams:</para>
    /// <code>
    /// - On Windows, set the binary mode (O_BINARY) on stdin, stdout and
    ///   stderr.
    /// - If buffered_stdio equals zero, disable buffering of stdin, stdout
    ///   and stderr streams.
    /// - If interactive is non-zero, enable stream buffering on stdin and
    ///   stdout (only stdout on Windows).
    /// </code>
    /// <para>Default: True in Python config, False in isolated config.</para>
    /// </summary>
    property configure_c_stdio          : boolean                  read Get_configure_c_stdio              write Set_configure_c_stdio;
    /// <summary>
    /// <para>Set the LC_CTYPE locale to the user preferred locale.</para>
    /// <para>If equals to False, set coerce_c_locale and coerce_c_locale_warn
    /// members to 0 and False.</para>
    /// <para>See the locale encoding.</para>
    /// <para>Default: True in Python config, False in isolated config.</para>
    /// </summary>
    property configure_locale           : boolean                  read Get_configure_locale               write Set_configure_locale;
    /// <summary>
    /// <para>If the value of cpu_count is not -1 then it will override the
    /// return values of os.cpu_count(), os.process_cpu_count(), and
    /// multiprocessing.cpu_count().</para>
    /// <para>Configured by the -X cpu_count=n|default command line flag or
    /// the PYTHON_CPU_COUNT environment variable.</para>
    /// <para>Default: -1.</para>
    /// </summary>
    property cpu_count                  : int64                    read Get_cpu_count                      write Set_cpu_count;
    /// <summary>
    /// <para>If True, enable the Python Development Mode.</para>
    /// <para>Set to True by the -X dev option and the PYTHONDEVMODE
    /// environment variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/library/devmode.html#devmode">See the article about Python Development Mode.</see></para>
    /// </remarks>
    property dev_mode                   : boolean                  read Get_dev_mode                       write Set_dev_mode;
    /// <summary>
    /// <para>Dump Python references?</para>
    /// <para>If True, dump all objects which are still alive at exit.</para>
    /// <para>Set to True by the PYTHONDUMPREFS environment variable.</para>
    /// <para>Needs a special build of Python with the Py_TRACE_REFS macro
    /// defined: see the configure --with-trace-refs option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property dump_refs                  : boolean                  read Get_dump_refs                      write Set_dump_refs;
    /// <summary>
    /// <para>Filename where to dump Python references. Set by the
    /// PYTHONDUMPREFSFILE environment variable.</para>
    /// </summary>
    property dump_refs_file             : string                   read Get_dump_refs_file                 write Set_dump_refs_file;
    /// <summary>
    /// <para>The site-specific directory prefix where the platform-dependent
    /// Python files are installed: sys.exec_prefix.</para>
    /// <para>Part of the Python Path Configuration output.</para>
    /// <para>See also PyConfig.base_exec_prefix.</para>
    /// </summary>
    property exec_prefix                : string                   read Get_exec_prefix                    write Set_exec_prefix;
    /// <summary>
    /// <para>The absolute path of the executable binary for the Python
    /// interpreter: sys.executable.</para>
    /// <para>Part of the Python Path Configuration output.</para>
    /// <para>See also PyConfig.base_executable.</para>
    /// </summary>
    property executable                 : string                   read Get_executable                     write Set_executable;
    /// <summary>
    /// <para>Enable faulthandler?</para>
    /// <para>If True, call faulthandler.enable() at startup.</para>
    /// <para>Set to True by -X faulthandler and the PYTHONFAULTHANDLER
    /// environment variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    property faulthandler               : boolean                  read Get_faulthandler                   write Set_faulthandler;
    /// <summary>
    /// <para>Filesystem encoding: sys.getfilesystemencoding().</para>
    /// <para>On macOS, Android and VxWorks: use "utf-8" by default.</para>
    /// <para>On Windows: use "utf-8" by default, or "mbcs" if
    /// legacy_windows_fs_encoding of PyPreConfig is non-zero.</para>
    /// <para>Default encoding on other platforms:</para>
    /// <code>
    /// - "utf-8" if PyPreConfig.utf8_mode is non-zero.
    /// - "ascii" if Python detects that nl_langinfo(CODESET) announces the
    ///   ASCII encoding, whereas the mbstowcs() function decodes from a
    ///   different encoding (usually Latin1).
    /// - "utf-8" if nl_langinfo(CODESET) returns an empty string.
    /// </code>
    /// <para>Otherwise, use the locale encoding: nl_langinfo(CODESET)
    /// result.</para>
    /// <para>At Python startup, the encoding name is normalized to the Python
    /// codec name. For example, "ANSI_X3.4-1968" is replaced with
    /// "ascii".</para>
    /// <para>See also the filesystem_errors member.</para>
    /// </summary>
    property filesystem_encoding        : string                   read Get_filesystem_encoding            write Set_filesystem_encoding;
    /// <summary>
    /// <para>Filesystem error handler: sys.getfilesystemencodeerrors().</para>
    /// <para>On Windows: use "surrogatepass" by default, or "replace" if
    /// legacy_windows_fs_encoding of PyPreConfig is non-zero.</para>
    /// <para>On other platforms: use "surrogateescape" by default.</para>
    /// <para>Supported error handlers:</para>
    /// <code>
    /// - "strict"
    /// - "surrogateescape"
    /// - "surrogatepass" (only supported with the UTF-8 encoding)
    /// </code>
    /// <para>See also the filesystem_encoding member.</para>
    /// </summary>
    property filesystem_errors          : string                   read Get_filesystem_errors              write Set_filesystem_errors;
    /// <summary>
    /// <para>Hash seed</para>
    /// </summary>
    property hash_seed                  : int64                    read Get_hash_seed                      write Set_hash_seed;
    /// <summary>
    /// <para>Set the default Python "home" directory, that is, the location
    /// of the standard Python libraries.</para>
    /// <para>Set by the PYTHONHOME environment variable.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONHOME">See the article about PYTHONHOME.</see></para>
    /// </remarks>
    property home                       : string                   read Get_home                           write Set_home;
    /// <summary>
    /// <para>If 1, profile import time. If 2, include additional output that
    /// indicates when an imported module has already been loaded.</para>
    /// <para>Set by the -X importtime option and the PYTHONPROFILEIMPORTTIME
    /// environment variable.</para>
    /// <para>Default: 0.</para>
    /// <para>Changed in version 3.14: Added support for import_time = 2</para>
    /// </summary>
    property import_time                : int64                    read Get_import_time                    write Set_import_time;
    /// <summary>
    /// <para>Enter interactive mode after executing a script or a
    /// command.</para>
    /// <para>If True, enable inspect: when a script is passed as first
    /// argument or the -c option is used, enter interactive mode after
    /// executing the script or the command, even when sys.stdin does not
    /// appear to be a terminal.</para>
    /// <para>Enabled by the -i command line option. Set to True if the
    /// PYTHONINSPECT environment variable is non-empty.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property inspect                    : boolean                  read Get_inspect                        write Set_inspect;
    /// <summary>
    /// <para>Install Python signal handlers?</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    property install_signal_handlers    : boolean                  read Get_install_signal_handlers        write Set_install_signal_handlers;
    /// <summary>
    /// <para>Configures the integer string conversion length limitation. An
    /// initial value of -1 means the value will be taken from the command
    /// line or environment or otherwise default to 4300
    /// (sys.int_info.default_max_str_digits). A value of 0 disables the
    /// limitation. Values greater than zero but less than 640
    /// (sys.int_info.str_digits_check_threshold) are unsupported and will
    /// produce an error.</para>
    /// <para>Configured by the -X int_max_str_digits command line flag or the
    /// PYTHONINTMAXSTRDIGITS environment variable.</para>
    /// <para>Default: -1 in Python mode. 4300
    /// (sys.int_info.default_max_str_digits) in isolated mode.</para>
    /// <para>Added in version 3.12.</para>
    /// </summary>
    property int_max_str_digits         : int64                    read Get_int_max_str_digits             write Set_int_max_str_digits;
    /// <summary>
    /// <para>If True, enable the interactive mode (REPL).</para>
    /// <para>Enabled by the -i command line option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property interactive                : boolean                  read Get_interactive                    write Set_interactive;
    /// <summary>
    /// <para>If True, enable isolated mode:</para>
    /// <code>
    /// - Set safe_path to True: don't prepend a potentially unsafe path to
    ///   sys.path at Python startup, such as the current directory, the
    ///   script's directory or an empty string.
    /// - Set use_environment to False: ignore PYTHON environment variables.
    /// - Set user_site_directory to False: don't add the user site directory
    ///   to sys.path.
    /// - Python REPL doesn't import readline nor enable default readline
    ///   configuration on interactive prompts.
    /// </code>
    /// <para>Set to True by the -I command line option.</para>
    /// <para>Default: False in Python mode, True in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#isolated-configuration">See the article about Isolated Configuration.</see></para>
    /// </remarks>
    property isolated                   : boolean                  read Get_isolated                       write Set_isolated;
    /// <summary>
    /// <para>Controls lazy import behavior. Accepts two values:</para>
    /// <code>
    /// - li_all makes all imports lazy by default.
    /// - li_normal (the default) respects the lazy keyword in source code.
    /// </code>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3.15/using/cmdline.html#envvar-PYTHON_LAZY_IMPORTS">See the article about PYTHON_LAZY_IMPORTS.</see></para>
    /// <para>Added in version 3.15.</para>
    /// </remarks>
    property lazy_imports              : PyImport_LazyImportsMode  read Get_lazy_imports                   write Set_lazy_imports;
    {$IFDEF MSWINDOWS}
    /// <summary>
    /// <para>If True:</para>
    /// <code>
    /// - Set PyPreConfig.utf8_mode to False,
    /// - Set PyConfig.filesystem_encoding to "mbcs",
    /// - Set PyConfig.filesystem_errors to "replace".
    /// </code>
    /// <para>Initialized from the PYTHONLEGACYWINDOWSFSENCODING environment
    /// variable value. Only available on Windows.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property legacy_windows_fs_encoding : boolean                  read Get_legacy_windows_fs_encoding     write Set_legacy_windows_fs_encoding;
    /// <summary>
    /// <para>If True, use io.FileIO instead of io._WindowsConsoleIO for
    /// sys.stdin, sys.stdout and sys.stderr.</para>
    /// <para>Set to True if the PYTHONLEGACYWINDOWSSTDIO environment variable
    /// is set to a non-empty string.</para>
    /// <para>Only available on Windows. #ifdef MS_WINDOWS macro can be used
    /// for Windows specific code.</para>
    /// <para>Default: False.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://peps.python.org/pep-0528/">See also the PEP 528 (Change Windows console encoding to UTF-8).</see></para>
    /// </remarks>
    property legacy_windows_stdio       : boolean                  read Get_legacy_windows_stdio           write Set_legacy_windows_stdio;
    {$ENDIF}
    /// <summary>
    /// <para>If True, dump statistics on Python pymalloc memory allocator at
    /// exit.</para>
    /// <para>Set to True by the PYTHONMALLOCSTATS environment variable.</para>
    /// <para>The option is ignored if Python is configured using the
    /// --without-pymalloc option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property malloc_stats               : boolean                  read Get_malloc_stats                   write Set_malloc_stats;
    /// <summary>
    /// <para>A list of strings that specifies the search path for
    /// modules.</para>
    /// <para>Initialized from the environment variable PYTHONPATH, plus an
    /// installation-dependent default.</para>
    /// <para>If module_search_paths_set is False, TPy.InitializeFromConfig()
    /// will replace module_search_paths and sets module_search_paths_set to
    /// True.</para>
    /// <para>Default: empty list (module_search_paths) and False
    /// (module_search_paths_set).</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sys.html#sys.path">See the article about sys.path.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH">See the article about PYTHONPATH.</see></para>
    /// </remarks>
    property module_search_paths        : string                   read Get_module_search_paths            write Set_module_search_paths;
    /// <summary>
    /// <para>Compilation optimization level:</para>
    /// <code>
    /// - polDebug (0) : Peephole optimizer, set __debug__ to True.
    /// - polRelease (1) : Level 0, remove assertions, set __debug__ to False.
    /// - polReleaseNoDocStrings (2) : Level 1, strip docstrings.
    /// </code>
    /// <para>Incremented by the -O command line option. Set to the
    /// PYTHONOPTIMIZE environment variable value.</para>
    /// <para>Default: polDebug (0).</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONOPTIMIZE">See the article about PYTHONOPTIMIZE.</see></para>
    /// </remarks>
    property optimization_level         : TPyOptimizationLevel     read Get_optimization_level             write Set_optimization_level;
    /// <summary>
    /// <para>The list of the original command line arguments passed to the
    /// Python executable: sys.orig_argv.</para>
    /// <para>If orig_argv list is empty and argv is not a list only
    /// containing an empty string, TPyConfig.Read() copies argv into
    /// orig_argv before modifying argv (if parse_argv is non-zero).</para>
    /// <para>See also the argv member and the TPy.GetArgcArgv()
    /// function.</para>
    /// <para>Default: empty list.</para>
    /// <para>Added in version 3.10.</para>
    /// </summary>
    property orig_argv                  : TStringDynArray          read Get_orig_argv                      write Set_orig_argv;
    /// <summary>
    /// <para>Parse command line arguments?</para>
    /// <para>If True, parse argv the same way the regular Python parses
    /// command line arguments, and strip Python arguments from argv.</para>
    /// <para>The TPyConfig.Read() function only parses PyConfig.argv arguments
    /// once: PyConfig.parse_argv is set to True after arguments are parsed.
    /// Since Python arguments are stripped from PyConfig.argv, parsing
    /// arguments twice would parse the application options as Python
    /// options.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// <para>Changed in version 3.10: The PyConfig.argv arguments are now
    /// only parsed once.</para>
    /// </summary>
    property parse_argv                 : boolean                  read Get_parse_argv                     write Set_parse_argv;
    /// <summary>
    /// <para>Parser debug mode. If True, turn on parser debugging output
    /// (for expert only, depending on compilation options).</para>
    /// <para>Enabled by the -d command line option. Set to the PYTHONDEBUG
    /// environment variable value.</para>
    /// <para>Needs a debug build of Python (the Py_DEBUG macro must be
    /// defined).</para>
    /// <para>Default: False.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONDEBUG">See the article about PYTHONDEBUG.</see></para>
    /// </remarks>
    property parser_debug               : boolean                  read Get_parser_debug                   write Set_parser_debug;
    /// <summary>
    /// <para>If True, calculation of path configuration is allowed to log
    /// warnings into stderr. If False, suppress these warnings.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// <para>Changed in version 3.11: Now also applies on Windows.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// </remarks>
    property pathconfig_warnings        : boolean                  read Get_pathconfig_warnings            write Set_pathconfig_warnings;
    /// <summary>
    /// <para>Enable the Linux perf profiler support?</para>
    /// <para>If equals to 1, enable support for the Linux perf
    /// profiler.</para>
    /// <para>If equals to 2, enable support for the Linux perf profiler with
    /// DWARF JIT support.</para>
    /// <para>Set to 1 by -X perf command-line option and the
    /// PYTHONPERFSUPPORT environment variable.</para>
    /// <para>Set to 2 by the -X perf_jit command-line option and the
    /// PYTHON_PERF_JIT_SUPPORT environment variable.</para>
    /// <para>Default: -1.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/howto/perf_profiling.html#perf-profiling">See Python support for the Linux perf profiler for more information.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPERFSUPPORT">See the article about PYTHONPERFSUPPORT.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHON_PERF_JIT_SUPPORT">See the article about PYTHON_PERF_JIT_SUPPORT.</see></para>
    /// </remarks>
    property perf_profiling             : int64                    read Get_perf_profiling                 write Set_perf_profiling;
    /// <summary>
    /// <para>Platform library directory name: sys.platlibdir.</para>
    /// <para>Name of the platform-specific library directory. It is used to
    /// build the path of standard library and the paths of installed
    /// extension modules.</para>
    /// <para>Set by the PYTHONPLATLIBDIR environment variable.</para>
    /// <para>Default: value of the PLATLIBDIR macro which is set by the
    /// configure --with-platlibdir option (default: "lib", or "DLLs" on
    /// Windows).</para>
    /// <para>Added in version 3.9.</para>
    /// <para>Changed in version 3.11: This macro is now used on Windows to
    /// locate the standard library extension modules, typically under DLLs.
    /// However, for compatibility, note that this value is ignored for any
    /// non-standard layouts, including in-tree builds and virtual
    /// environments.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPLATLIBDIR">See the article about PYTHONPLATLIBDIR.</see></para>
    /// </remarks>
    property platlibdir                 : string                   read Get_platlibdir                     write Set_platlibdir;
    /// <summary>
    /// <para>The site-specific directory prefix where the platform
    /// independent Python files are installed: sys.prefix.</para>
    /// <para>A string giving the site-specific directory prefix where the
    /// platform independent Python files are installed; on Unix, the default
    /// is /usr/local. This can be set at build time with the --prefix
    /// argument to the configure script.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para>See also PyConfig.base_prefix.</para>
    /// <para><see href="https://docs.python.org/3/library/sys.html#sys.prefix">See the article about sys.prefix.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sysconfig.html#installation-paths">See Installation paths for derived paths.</see></para>
    /// </remarks>
    property prefix                     : string                   read Get_prefix                         write Set_prefix;
    /// <summary>
    /// <para>Program name used to initialize executable and in early error
    /// messages during Python initialization.</para>
    /// <para>On macOS, use PYTHONEXECUTABLE environment variable if
    /// set.</para>
    /// <para>If the WITH_NEXT_FRAMEWORK macro is defined, use
    /// __PYVENV_LAUNCHER__ environment variable if set.</para>
    /// <para>Use argv[0] of argv if available and non-empty.</para>
    /// <para>Otherwise, use "python" on Windows, or "python3" on other
    /// platforms.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONEXECUTABLE">See the article about PYTHONEXECUTABLE.</see></para>
    /// <para>See PyConfig.executable and PyConfig.base_executable.</para>
    /// </remarks>
    property program_name               : string                   read Get_program_name                   write Set_program_name;
    /// <summary>
    /// <para>Directory where cached .pyc files are written:
    /// sys.pycache_prefix.</para>
    /// <para>Set by the -X pycache_prefix=PATH command line option and the
    /// PYTHONPYCACHEPREFIX environment variable. The command-line option
    /// takes precedence.</para>
    /// <para>If empty, sys.pycache_prefix is set to None.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPYCACHEPREFIX">See the article about PYTHONPYCACHEPREFIX.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sys.html#sys.pycache_prefix">See the article about sys.pycache_prefix.</see></para>
    /// </remarks>
    property pycache_prefix             : string                   read Get_pycache_prefix                 write Set_pycache_prefix;
    /// <summary>
    /// <para>Enable huge page support for pymalloc arenas (disabled by
    /// default). When enabled, the arena size on 64-bit platforms is increased
    /// to 2 MiB and arena allocation uses MAP_HUGETLB (Linux) or
    /// MEM_LARGE_PAGES (Windows) with automatic fallback to regular
    /// pages.</para>
    /// <para>Even when compiled with this option, huge pages are not used at
    /// runtime unless the PYTHON_PYMALLOC_HUGEPAGES environment variable is set
    /// to 1. This opt-in is required because huge pages</para>
    /// <code>
    /// - carry risks on Linux: if the huge-page pool is exhausted, page faults
    /// (including copy-on-write faults after os.fork()) deliver SIGBUS and kill
    /// the process.
    /// - need a special privilege on Windows. See the Windows documentation for
    /// large pages for details. Python will fail on startup if the required
    /// privilege SeLockMemoryPrivilege is not held by the user.
    /// </code>
    /// <para>The configure script checks that the platform supports MAP_HUGETLB
    /// and emits a warning if it is not available.</para>
    /// <para>On Windows, use the --pymalloc-hugepages flag with build.bat or
    /// set the UsePymallocHugepages MSBuild property.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3.15/using/configure.html#cmdoption-with-pymalloc-hugepages">See the article about --with-pymalloc-hugepages.</see></para>
    /// <para>Added in version 3.15.</para>
    /// </remarks>
    property pymalloc_hugepages         : boolean                  read Get_pymalloc_hugepages            write Set_pymalloc_hugepages;
    /// <summary>
    /// <para>Quiet mode. If True, don't display the copyright and version at
    /// Python startup in interactive mode.</para>
    /// <para>Enabled by the -q command line option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property quiet                      : boolean                  read Get_quiet                          write Set_quiet;
    /// <summary>
    /// <para>Value of the -c command line option.</para>
    /// <para>Used by TPy.RunMain().</para>
    /// <para>Default: Empty.</para>
    /// </summary>
    property run_command                : string                   read Get_run_command                    write Set_run_command;
    /// <summary>
    /// <para>Filename passed on the command line: trailing command line
    /// argument without -c or -m. It is used by the TPy.RunMain()
    /// function.</para>
    /// <para>For example, it is set to script.py by the python3 script.py
    /// arg command line.</para>
    /// <para>Default: Empty.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#c.PyConfig.skip_source_first_line">See also the PyConfig.skip_source_first_line option.</see></para>
    /// </remarks>
    property run_filename               : string                   read Get_run_filename                   write Set_run_filename;
    /// <summary>
    /// <para>Value of the -m command line option.</para>
    /// <para>Used by TPy.RunMain().</para>
    /// <para>Default: Empty.</para>
    /// </summary>
    property run_module                 : string                   read Get_run_module                     write Set_run_module;
    /// <summary>
    /// <para>package.module path to module that should be imported before
    /// site.py is run.</para>
    /// <para>Set by the -X presite=package.module command-line option and the
    /// PYTHON_PRESITE environment variable. The command-line option takes
    /// precedence.</para>
    /// <para>Needs a debug build of Python (the Py_DEBUG macro must be
    /// defined).</para>
    /// <para>Default: Empty.</para>
    /// </summary>
    property run_presite                : string                   read Get_run_presite                    write Set_run_presite;
    /// <summary>
    /// <para>If equals to zero, TPy.RunMain() prepends a potentially unsafe
    /// path to sys.path at startup:</para>
    /// <code>
    /// - If argv[0] is equal to "-m" (python -m module), prepend the current
    ///   working directory.
    /// - If running a script (python script.py), prepend the script's
    ///   directory. If it's a symbolic link, resolve symbolic links.
    /// - Otherwise (python -c code and python), prepend an empty string,
    ///   which means the current working directory.
    /// </code>
    /// <para>Set to 1 by the -P command line option and the PYTHONSAFEPATH
    /// environment variable.</para>
    /// <para>Default: False in Python config, True in isolated config.</para>
    /// <para>Added in version 3.11.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONSAFEPATH">See the article about PYTHONSAFEPATH.</see></para>
    /// </remarks>
    property safe_path                  : boolean                  read Get_safe_path                      write Set_safe_path;
    /// <summary>
    /// <para>Show total reference count at exit (excluding immortal
    /// objects)?</para>
    /// <para>Set to True by -X showrefcount command line option.</para>
    /// <para>Needs a debug build of Python (the Py_REF_DEBUG macro must be
    /// defined).</para>
    /// <para>Default: False.</para>
    /// </summary>
    property show_ref_count             : boolean                  read Get_show_ref_count                 write Set_show_ref_count;
    /// <summary>
    /// <para>Import the site module at startup?</para>
    /// <para>If equal to zero, disable the import of the module site and the
    /// site-dependent manipulations of sys.path that it entails.</para>
    /// <para>Also disable these manipulations if the site module is
    /// explicitly imported later (call site.main() if you want them to be
    /// triggered).</para>
    /// <para>Set to False by the -S command line option.</para>
    /// <para>sys.flags.no_site is set to the inverted value of
    /// site_import.</para>
    /// <para>Default: True.</para>
    /// </summary>
    property site_import                : boolean                  read Get_site_import                    write Set_site_import;
    /// <summary>
    /// <para>If non-zero, skip the first line of the PyConfig.run_filename
    /// source.</para>
    /// <para>It allows the usage of non-Unix forms of #!cmd. This is intended
    /// for a DOS specific hack only.</para>
    /// <para>Set to True by the -x command line option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property skip_source_first_line     : boolean                  read Get_skip_source_first_line         write Set_skip_source_first_line;
    /// <summary>
    /// <para>Encoding of sys.stdin, sys.stdout and sys.stderr (but sys.stderr
    /// always uses "backslashreplace" error handler).</para>
    /// <para>Use the PYTHONIOENCODING environment variable if it is
    /// non-empty.</para>
    /// <para>Default encoding:</para>
    /// <code>
    /// - "UTF-8" if PyPreConfig.utf8_mode is non-zero.
    /// - Otherwise, use the locale encoding.
    /// </code>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONIOENCODING">See the article about PYTHONIOENCODING.</see></para>
    /// <para>See also PyConfig.legacy_windows_stdio.</para>
    /// </remarks>
    property stdio_encoding             : string                   read Get_stdio_encoding                 write Set_stdio_encoding;
    /// <summary>
    /// <para>Encoding errors of sys.stdin, sys.stdout and sys.stderr (but
    /// sys.stderr always uses "backslashreplace" error handler).</para>
    /// <para>Use the PYTHONIOENCODING environment variable if it is
    /// non-empty.</para>
    /// <para>Default error handler:</para>
    /// <code>
    /// - On Windows: use "surrogateescape".
    /// - "surrogateescape" if PyPreConfig.utf8_mode is non-zero, or if the
    ///   LC_CTYPE locale is "C" or "POSIX".
    /// - "strict" otherwise.
    /// </code>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONIOENCODING">See the article about PYTHONIOENCODING.</see></para>
    /// <para>See also PyConfig.legacy_windows_stdio.</para>
    /// </remarks>
    property stdio_errors               : string                   read Get_stdio_errors                   write Set_stdio_errors;
    /// <summary>
    /// <para>Directory of the Python standard library.</para>
    /// <para>Default: Empty.</para>
    /// <para>Added in version 3.11.</para>
    /// </summary>
    property stdlib_dir                 : string                   read Get_stdlib_dir                     write Set_stdlib_dir;
    /// <summary>
    /// <para>Enable tracemalloc?</para>
    /// <para>If True, call tracemalloc.start() at startup.</para>
    /// <para>Set by -X tracemalloc=N command line option and by the
    /// PYTHONTRACEMALLOC environment variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONTRACEMALLOC">See the article about PYTHONTRACEMALLOC.</see></para>
    /// <para>See also PyConfig.legacy_windows_stdio.</para>
    /// </remarks>
    property tracemalloc                : int64                    read Get_tracemalloc                    write Set_tracemalloc;
    /// <summary>
    /// <para>Use environment variables?</para>
    /// <para>If False, ignore the environment variables.</para>
    /// <para>Set to False by the -E environment variable.</para>
    /// <para>Default: True in Python config and False in isolated
    /// config.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#using-on-envvars">See the article about environment variables.</see></para>
    /// </remarks>
    property use_environment            : boolean                  read Get_use_environment                write Set_use_environment;
    /// <summary>
    /// <para>If True, use frozen modules.</para>
    /// <para>Set by the PYTHON_FROZEN_MODULES environment variable.</para>
    /// <para>Default: True in a release build, or False in a debug
    /// build.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHON_FROZEN_MODULES">See the article about PYTHON_FROZEN_MODULES.</see></para>
    /// </remarks>
    property use_frozen_modules         : boolean                  read Get_use_frozen_modules             write Set_use_frozen_modules;
    /// <summary>
    /// <para>Randomized hash function seed.</para>
    /// <para>If use_hash_seed is zero, a seed is chosen randomly at Python
    /// startup, and hash_seed is ignored.</para>
    /// <para>Set by the PYTHONHASHSEED environment variable.</para>
    /// <para>Default use_hash_seed value: True in Python mode, False in
    /// isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONHASHSEED">See the article about PYTHONHASHSEED.</see></para>
    /// </remarks>
    property use_hash_seed              : boolean                  read Get_use_hash_seed                  write Set_use_hash_seed;
    /// <summary>
    /// <para>If non-zero, stdout and stderr will be redirected to the system
    /// log.</para>
    /// <para>Only available on macOS 10.12 and later, and on iOS.</para>
    /// <para>Default: False (don't use the system log) on macOS; True on iOS
    /// (use the system log).</para>
    /// <para>Added in version 3.14.</para>
    /// </summary>
    property use_system_logger          : boolean                  read Get_use_system_logger              write Set_use_system_logger;
    /// <summary>
    /// <para>If True, add the user site directory to sys.path.</para>
    /// <para>Set to False by the -s and -I command line options.</para>
    /// <para>Set to False by the PYTHONNOUSERSITE environment variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONNOUSERSITE">See the article about PYTHONNOUSERSITE.</see></para>
    /// </remarks>
    property user_site_directory        : boolean                  read Get_user_site_directory            write Set_user_site_directory;
    /// <summary>
    /// <para>If True, enable the Python UTF-8 Mode.</para>
    /// <para>Set to False or True by the -X utf8 command line option and the
    /// PYTHONUTF8 environment variable.</para>
    /// <para>Also set to True if the LC_CTYPE locale is C or POSIX.</para>
    /// <para>Default: True in Python config and False in isolated
    /// config.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONUTF8">See the article about PYTHONUTF8.</see></para>
    /// <para><see href="https://docs.python.org/3/library/os.html#utf8-mode">See the article about Python UTF-8 Mode.</see></para>
    /// </remarks>
    property utf8_mode                  : integer                  read Get_utf8_mode                      write Set_utf8_mode;
    /// <summary>
    /// <para>Verbose mode. If pvmModule or pvmFull, print a message each time
    /// a module is imported, showing the place (filename or built-in module)
    /// from which it is loaded.</para>
    /// <para>If pvmFull, print a message for each file
    /// that is checked for when searching for a module. Also provides
    /// information on module cleanup at exit.</para>
    /// <para>Enabled by the -v command line option.</para>
    /// <para>Set by the PYTHONVERBOSE environment variable value.</para>
    /// <para>Default: pvmDisabled.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONVERBOSE">See the article about PYTHONVERBOSE.</see></para>
    /// </remarks>
    property verbose                    : TPyVerboseMode           read Get_verbose                        write Set_verbose;
    /// <summary>
    /// <para>If non-zero, emit a EncodingWarning warning when
    /// io.TextIOWrapper uses its default encoding.</para>
    /// <para>Default: False.</para>
    /// <para>Added in version 3.10.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/library/io.html#io-encoding-warning">See Opt-in EncodingWarning for details.</see></para>
    /// </remarks>
    property warn_default_encoding      : boolean                  read Get_warn_default_encoding          write Set_warn_default_encoding;
    /// <summary>
    /// <para>Options of the warnings module to build warnings filters, lowest
    /// to highest priority: sys.warnoptions.</para>
    /// <para>The warnings module adds sys.warnoptions in the reverse order:
    /// the last PyConfig.warnoptions item becomes the first item of
    /// warnings.filters which is checked first (highest priority).</para>
    /// <para>The -W command line options adds its value to warnoptions, it
    /// can be used multiple times.</para>
    /// <para>The PYTHONWARNINGS environment variable can also be used to add
    /// warning options. Multiple options can be specified, separated by
    /// commas (,).</para>
    /// <para>Default: empty list.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONWARNINGS">See the article about PYTHONWARNINGS.</see></para>
    /// </remarks>
    property warnoptions                : TStringDynArray          read Get_warnoptions                    write Set_warnoptions;
    /// <summary>
    /// <para>If False, Python won't try to write .pyc files on the import of
    /// source modules.</para>
    /// <para>Set to False by the -B command line option and the
    /// PYTHONDONTWRITEBYTECODE environment variable.</para>
    /// <para>sys.dont_write_bytecode is initialized to the inverted value of
    /// write_bytecode.</para>
    /// <para>Default: True.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONDONTWRITEBYTECODE">See the article about PYTHONDONTWRITEBYTECODE.</see></para>
    /// </remarks>
    property write_bytecode             : boolean                  read Get_write_bytecode                 write Set_write_bytecode;
    /// <summary>
    /// <para>Values of the -X command line options: sys._xoptions.</para>
    /// <para>Default: empty list.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/library/sys.html#sys._xoptions">See the article about sys._xoptions.</see></para>
    /// </remarks>
    property xoptions                   : TStringDynArray          read Get_xoptions                       write Set_xoptions;
  end;

  /// <summary>
  /// Interface used to preinitialize Python.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/init_config.html#pypreconfig">See the article about PyPreConfig.</see></para>
  /// </remarks>
  IPyPreConfig = interface
    ['{53194E16-1452-46CF-AA81-11E7D2F179A1}']
    function GetConfig: Pointer;
    function GetInitialized: boolean;
    function Get_parse_argv: boolean;
    function Get_isolated: boolean;
    function Get_use_environment: boolean;
    function Get_configure_locale: boolean;
    function Get_coerce_c_locale: integer;
    function Get_coerce_c_locale_warn: boolean;
    {$IFDEF MSWINDOWS}
    function Get_legacy_windows_fs_encoding: boolean;
    {$ENDIF}
    function Get_utf8_mode: integer;
    function Get_dev_mode: boolean;
    function Get_allocator: PyMemAllocatorName;

    procedure Set_parse_argv(aValue: boolean);
    procedure Set_isolated(aValue: boolean);
    procedure Set_use_environment(aValue: boolean);
    procedure Set_configure_locale(aValue: boolean);
    procedure Set_coerce_c_locale(aValue: integer);
    procedure Set_coerce_c_locale_warn(aValue: boolean);
    {$IFDEF MSWINDOWS}
    procedure Set_legacy_windows_fs_encoding(aValue: boolean);
    {$ENDIF}
    procedure Set_utf8_mode(aValue: integer);
    procedure Set_dev_mode(aValue: boolean);
    procedure Set_allocator(aValue: PyMemAllocatorName);

    /// <summary>
    /// Initialize the preconfiguration with Python Configuration.
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-python-config">See the Python Configuration article.</see></para>
    /// </remarks>
    procedure InitPythonConfig;
    /// <summary>
    /// Initialize the preconfiguration with Isolated Configuration.
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-isolated-conf">See the Isolated Configuration article.</see></para>
    /// </remarks>
    procedure InitIsolatedConfig;
    /// <summary>
    /// Pointer to the PyPreConfig record.
    /// </summary>
    property Config                      : Pointer            read GetConfig;
    /// <summary>
    /// Returns true if this class is fully initialized.
    /// </summary>
    property Initialized                 : boolean            read GetInitialized;
    /// <summary>
    /// <para>If True, TPy.PreInitializeFromArgs() and
    /// TPy.PreInitializeFromBytesArgs() parse their argv argument the same way
    /// the regular Python parses command line arguments: see Command Line
    /// Arguments.</para>
    /// <para>Default: True in Python config, False in isolated config.</para>
    /// </summary>
    property parse_argv                  : boolean            read Get_parse_argv                           write Set_parse_argv;
    /// <summary>
    /// <para>If True, enable isolated mode:</para>
    /// <code>
    /// - Set safe_path to True: don't prepend a potentially unsafe path to
    ///   sys.path at Python startup, such as the current directory, the
    ///   script's directory or an empty string.
    /// - Set use_environment to False: ignore PYTHON environment variables.
    /// - Set user_site_directory to False: don't add the user site directory
    ///   to sys.path.
    /// - Python REPL doesn't import readline nor enable default readline
    ///   configuration on interactive prompts.
    /// </code>
    /// <para>Set to True by the -I command line option.</para>
    /// <para>Default: False in Python mode, True in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#isolated-configuration">See the article about Isolated Configuration.</see></para>
    /// </remarks>
    property isolated                    : boolean            read Get_isolated                             write Set_isolated;
    /// <summary>
    /// <para>Use environment variables?</para>
    /// <para>If False, ignore the environment variables.</para>
    /// <para>Set to False by the -E environment variable.</para>
    /// <para>Default: True in Python config and False in isolated
    /// config.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#using-on-envvars">See the article about environment variables.</see></para>
    /// </remarks>
    property use_environment             : boolean            read Get_use_environment                      write Set_use_environment;
    /// <summary>
    /// <para>Set the LC_CTYPE locale to the user preferred locale.</para>
    /// <para>If False, set coerce_c_locale and coerce_c_locale_warn members
    /// to False.</para>
    /// <para>See the locale encoding.</para>
    /// <para>Default: True in Python config, False in isolated config.</para>
    /// </summary>
    property configure_locale            : boolean            read Get_configure_locale                     write Set_configure_locale;
    /// <summary>
    /// <para>If equals to 2, coerce the C locale.</para>
    /// <para>If equals to 1, read the LC_CTYPE locale to decide if it should
    /// be coerced.</para>
    /// <para>See the locale encoding.</para>
    /// <para>Default: -1 in Python config, 0 in isolated config.</para>
    /// </summary>
    property coerce_c_locale             : integer            read Get_coerce_c_locale                      write Set_coerce_c_locale;
    /// <summary>
    /// <para>If True, emit a warning if the C locale is coerced.</para>
    /// <para>Default: True in Python config, False in isolated config.</para>
    /// </summary>
    property coerce_c_locale_warn        : boolean            read Get_coerce_c_locale_warn                 write Set_coerce_c_locale_warn;
    {$IFDEF MSWINDOWS}
    /// <summary>
    /// <para>If True:</para>
    /// <code>
    /// - Set PyPreConfig.utf8_mode to False,
    /// - Set PyConfig.filesystem_encoding to "mbcs",
    /// - Set PyConfig.filesystem_errors to "replace".
    /// </code>
    /// <para>Initialized from the PYTHONLEGACYWINDOWSFSENCODING environment
    /// variable value. Only available on Windows.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property legacy_windows_fs_encoding  : boolean            read Get_legacy_windows_fs_encoding           write Set_legacy_windows_fs_encoding;
    {$ENDIF}
    /// <summary>
    /// <para>If True, enable the Python UTF-8 Mode.</para>
    /// <para>Set to False or True by the -X utf8 command line option and the
    /// PYTHONUTF8 environment variable.</para>
    /// <para>Also set to True if the LC_CTYPE locale is C or POSIX.</para>
    /// <para>Default: True in Python config and False in isolated
    /// config.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONUTF8">See the article about PYTHONUTF8.</see></para>
    /// <para><see href="https://docs.python.org/3/library/os.html#utf8-mode">See the article about Python UTF-8 Mode.</see></para>
    /// </remarks>
    property utf8_mode                   : integer            read Get_utf8_mode                            write Set_utf8_mode;
    /// <summary>
    /// <para>If True, enable the Python Development Mode.</para>
    /// <para>Set to True by the -X dev option and the PYTHONDEVMODE environment
    /// variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/library/devmode.html#devmode">See the article about Python Development Mode.</see></para>
    /// </remarks>
    property dev_mode                    : boolean            read Get_dev_mode                             write Set_dev_mode;
    /// <summary>
    /// Name of the Python memory allocator.
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/memory.html#memory">See the Memory Management article.</see></para>
    /// <para>See PyMemAllocatorName.</para>
    /// </remarks>
    property allocator                   : PyMemAllocatorName read Get_allocator                            write Set_allocator;
  end;

  /// <summary>
  /// Record containing most parameters to configure Python.
  /// When done, the PyConfig_Clear() function must be used to release the configuration memory.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/init_config.html#pyconfig">See the article about PyConfig.</see></para>
  /// </remarks>
  IPyConfig = interface
    ['{1BA914A8-FFF7-4F49-AA5A-95808CCF8AFB}']
    function GetConfig: Pointer;
    function Get_argv: TStringDynArray;
    function Get_base_exec_prefix: string;
    function Get_base_executable: string;
    function Get_base_prefix: string;
    function Get_buffered_stdio: boolean;
    function Get_bytes_warning: integer;
    function Get_check_hash_pycs_mode: string;
    function Get_code_debug_ranges: boolean;
    function Get_configure_c_stdio: boolean;
    function Get_context_aware_warnings: boolean;
    {$IFDEF APPLE}
    function Get_use_system_logger: boolean;
    {$ENDIF}
    function Get_cpu_count: integer;
    function Get_dev_mode: boolean;
    function Get_dump_refs: boolean;
    function Get_dump_refs_file: string;
    function Get_exec_prefix: string;
    function Get_executable: string;
    function Get_faulthandler: integer;
    function Get_filesystem_encoding: string;
    function Get_filesystem_errors: string;
    function Get_hash_seed: uint64;
    function Get_home: string;
    function Get_import_time: integer;
    function Get_inspect: boolean;
    function Get_install_signal_handlers: boolean;
    function Get_int_max_str_digits: integer;
    function Get_interactive: boolean;
    function Get_isolated: boolean;
    function Get_lazy_imports: PyImport_LazyImportsMode;                   //****** 3.15.0
    {$IFDEF MSWINDOWS}
    function Get_legacy_windows_stdio: boolean;
    {$ENDIF}
    function Get_malloc_stats: boolean;
    function Get_module_search_paths: string;
    function Get_module_search_paths_set: boolean;
    function Get_optimization_level: TPyOptimizationLevel;
    function Get_orig_argv: TStringDynArray;
    function Get_parse_argv: boolean;
    function Get_parser_debug: boolean;
    function Get_pathconfig_warnings: boolean;
    function Get_perf_profiling: integer;
    function Get_platlibdir: string;
    function Get_prefix: string;
    function Get_program_name: string;
    function Get_pycache_prefix: string;
    function Get_pymalloc_hugepages: boolean;                              //****** 3.15.0
    function Get_pythonpath_env: string;
    function Get_quiet: boolean;
    function Get_remote_debug: boolean;
    function Get_run_command: string;
    function Get_run_filename: string;
    function Get_run_module: string;
    function Get_safe_path: boolean;
    function Get_show_ref_count: boolean;
    function Get_site_import: boolean;
    function Get_skip_source_first_line: boolean;
    function Get_stdio_encoding: string;
    function Get_stdio_errors: string;
    function Get_stdlib_dir: string;
    function Get_sys_path_0: string;
    function Get_thread_inherit_context: boolean;
    function Get_tracemalloc: boolean;
    function Get_use_environment: boolean;
    function Get_use_frozen_modules: boolean;
    function Get_use_hash_seed: boolean;
    function Get_user_site_directory: boolean;
    function Get_verbose: TPyVerboseMode;
    function Get_warn_default_encoding: boolean;
    function Get_warnoptions: TStringDynArray;
    function Get_write_bytecode: boolean;
    function Get_xoptions: TStringDynArray;

    procedure Set_argv(const aValue: TStringDynArray);
    procedure Set_base_exec_prefix(const aValue: string);
    procedure Set_base_executable(const aValue: string);
    procedure Set_base_prefix(const aValue: string);
    procedure Set_buffered_stdio(aValue: boolean);
    procedure Set_bytes_warning(aValue: integer);
    procedure Set_check_hash_pycs_mode(const aValue: string);
    procedure Set_code_debug_ranges(aValue: boolean);
    procedure Set_configure_c_stdio(aValue: boolean);
    procedure Set_context_aware_warnings(aValue: boolean);
    {$IFDEF APPLE}
    procedure Set_use_system_logger(aValue: boolean);
    {$ENDIF}
    procedure Set_cpu_count(aValue: integer);
    procedure Set_dev_mode(aValue: boolean);
    procedure Set_dump_refs(aValue: boolean);
    procedure Set_dump_refs_file(const aValue: string);
    procedure Set_exec_prefix(const aValue: string);
    procedure Set_executable(const aValue: string);
    procedure Set_faulthandler(aValue: integer);
    procedure Set_filesystem_encoding(const aValue: string);
    procedure Set_filesystem_errors(const aValue: string);
    procedure Set_hash_seed(aValue: uint64);
    procedure Set_home(const aValue: string);
    procedure Set_import_time(aValue: integer);
    procedure Set_inspect(aValue: boolean);
    procedure Set_install_signal_handlers(aValue: boolean);
    procedure Set_int_max_str_digits(aValue: integer);
    procedure Set_interactive(aValue: boolean);
    procedure Set_isolated(aValue: boolean);
    procedure Set_lazy_imports(aValue: PyImport_LazyImportsMode);          //****** 3.15.0
    {$IFDEF MSWINDOWS}
    procedure Set_legacy_windows_stdio(aValue: boolean);
    {$ENDIF}
    procedure Set_malloc_stats(aValue: boolean);
    procedure Set_module_search_paths(const aValue: string);
    procedure Set_module_search_paths_set(aValue: boolean);
    procedure Set_optimization_level(aValue: TPyOptimizationLevel);
    procedure Set_orig_argv(const aValue: TStringDynArray);
    procedure Set_parse_argv(aValue: boolean);
    procedure Set_parser_debug(aValue: boolean);
    procedure Set_pathconfig_warnings(aValue: boolean);
    procedure Set_perf_profiling(aValue: integer);
    procedure Set_platlibdir(const aValue: string);
    procedure Set_prefix(const aValue: string);
    procedure Set_program_name(const aValue: string);
    procedure Set_pycache_prefix(const aValue: string);
    procedure Set_pymalloc_hugepages(aValue: boolean);                      //****** 3.15.0
    procedure Set_pythonpath_env(const aValue: string);
    procedure Set_quiet(aValue: boolean);
    procedure Set_remote_debug(aValue: boolean);
    procedure Set_run_command(const aValue: string);
    procedure Set_run_filename(const aValue: string);
    procedure Set_run_module(const aValue: string);
    procedure Set_safe_path(aValue: boolean);
    procedure Set_show_ref_count(aValue: boolean);
    procedure Set_site_import(aValue: boolean);
    procedure Set_skip_source_first_line(aValue: boolean);
    procedure Set_stdio_encoding(const aValue: string);
    procedure Set_stdio_errors(const aValue: string);
    procedure Set_stdlib_dir(const aValue: string);
    procedure Set_sys_path_0(const aValue: string);
    procedure Set_thread_inherit_context(aValue: boolean);
    procedure Set_tracemalloc(aValue: boolean);
    procedure Set_use_environment(aValue: boolean);
    procedure Set_use_frozen_modules(aValue: boolean);
    procedure Set_use_hash_seed(aValue: boolean);
    procedure Set_user_site_directory(aValue: boolean);
    procedure Set_verbose(aValue: TPyVerboseMode);
    procedure Set_warn_default_encoding(aValue: boolean);
    procedure Set_warnoptions(const aValue: TStringDynArray);
    procedure Set_write_bytecode(aValue: boolean);
    procedure Set_xoptions(const aValue: TStringDynArray);

    /// <summary>
    /// Copy the string SrcString into DstString.
    /// </summary>
    function SetWCharT(var DstString: PWCharT; const SrcString: string): boolean;
    /// <summary>
    /// Copy the wide character string SrcString into DstString.
    /// </summary>
    function SetString(var DstString: PWCharT; SrcString: WCharTString): IPyStatus;
    /// <summary>
    /// Decode SrcString using Py_DecodeLocale() and set the result into
    /// DstString.
    /// </summary>
    function SetBytesString(var DstString: PWCharT; SrcString: AnsiString): IPyStatus;
    /// <summary>
    /// Set command line arguments (argv member of config) from the argv array
    /// of wide character strings.
    /// </summary>
    function SetArgv(argc: integer; const argv: array of PWCharT): IPyStatus; overload;
    /// <summary>
    /// Set command line arguments (argv member of config) from a TStringList.
    /// </summary>
    function SetArgv(const items: TStringList): boolean; overload;
    /// <summary>
    /// Set command line arguments (argv member of config) from a
    /// TStringDynArray.
    /// </summary>
    function SetArgv(const items: TStringDynArray): boolean; overload;
    /// <summary>
    /// Set command line arguments (argv member of config) from the argv array
    /// of bytes strings. Decode bytes using TPy.DecodeLocale().
    /// </summary>
    function SetBytesArgv(argc: integer; const argv: array of PAnsiChar): IPyStatus;
    /// <summary>
    /// Set the list of wide strings "list" to "length" and "items".
    /// </summary>
    function SetWideStringList(var list: PyWideStringList; length: integer; items: array of PWCharT): IPyStatus; overload;
    /// <summary>
    /// Set the list of wide strings "list" to the "items" TStringList.
    /// </summary>
    function SetWideStringList(var list: PyWideStringList; const items: TStringList): boolean; overload;
    /// <summary>
    /// Set the list of wide strings "list" to the "items" TStringDynArray.
    /// </summary>
    function SetWideStringList(var list: PyWideStringList; const items: TStringDynArray): boolean; overload;

    /// <summary>
    /// Initialize configuration with the "Python Configuration".
    /// </summary>
    procedure   InitPythonConfig;
    /// <summary>
    /// Initialize configuration with the "Isolated Configuration".
    /// </summary>
    procedure   InitIsolatedConfig;
    /// <summary>
    /// <para>Read all Python configuration.</para>
    /// <para>Fields which are already initialized are left unchanged.</para>
    /// <para>Fields for path configuration are no longer calculated or modified
    /// when calling this function, as of Python 3.11.</para>
    /// <para>The TPyConfig.Read() function only parses PyConfig.argv arguments
    /// once: PyConfig.parse_argv is set to 2 after arguments are parsed. Since
    /// Python arguments are stripped from PyConfig.argv, parsing arguments
    /// twice would parse the application options as Python options.</para>
    /// <para>Changed in version 3.10: The PyConfig.argv arguments are now only
    /// parsed once, PyConfig.parse_argv is set to 2 after arguments are parsed,
    /// and arguments are only parsed if PyConfig.parse_argv equals 1.</para>
    /// <para>Changed in version 3.11: TPyConfig.Read() no longer calculates all
    /// paths, and so fields listed under Python Path Configuration may no
    /// longer be updated until TPy.InitializeFromConfig() is called.</para>
    /// </summary>
    function    Read: IPyStatus;
    /// <summary>
    /// Pointer to the PyConfig record.
    /// </summary>
    property Config                    : Pointer                  read GetConfig;
    /// <summary>
    /// <para>Set sys.argv command line arguments based on argv. These
    /// parameters are similar to those passed to the program's main()
    /// function with the difference that the first entry should refer to the
    /// script file to be executed rather than the executable hosting the
    /// Python interpreter. If there isn't a script that will be run, the
    /// first entry in argv can be an empty string.</para>
    /// <para>Set parse_argv to True to parse argv the same way the regular
    /// Python parses Python command line arguments and then to strip Python
    /// arguments from argv.</para>
    /// <para>If argv is empty, an empty string is added to ensure that
    /// sys.argv always exists and is never empty.</para>
    /// </summary>
    /// <remarks>
    /// <para>See also the orig_argv member.</para>
    /// </remarks>
    property argv                      : TStringDynArray          read Get_argv                         write Set_argv;
    /// <summary>
    /// <para>Equivalent to exec_prefix, but referring to the base Python
    /// installation.</para>
    /// <para>When running under Virtual Environments, exec_prefix gets
    /// overwritten to the virtual environment prefix. base_exec_prefix,
    /// conversely, does not change, and always points to the base Python
    /// installation.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sys_path_init.html#sys-path-init-virtual-environments">Refer to Virtual Environments for more information.</see></para>
    /// <para>See also PyConfig.exec_prefix.</para>
    /// </remarks>
    property base_exec_prefix          : string                   read Get_base_exec_prefix             write Set_base_exec_prefix;
    /// <summary>
    /// <para>Python base executable: sys._base_executable.</para>
    /// <para>Set by the __PYVENV_LAUNCHER__ environment variable.</para>
    /// <para>Set from PyConfig.executable if empty.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para>See also PyConfig.executable.</para>
    /// </remarks>
    property base_executable           : string                   read Get_base_executable              write Set_base_executable;
    /// <summary>
    /// <para>Equivalent to prefix, but referring to the base Python
    /// installation.</para>
    /// <para>When running under virtual environment, prefix gets overwritten
    /// to the virtual environment prefix. base_prefix, conversely, does not
    /// change, and always points to the base Python installation.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sys_path_init.html#sys-path-init-virtual-environments">Refer to Virtual Environments for more information.</see></para>
    /// <para>See also PyConfig.prefix.</para>
    /// </remarks>
    property base_prefix               : string                   read Get_base_prefix                  write Set_base_prefix;
    /// <summary>
    /// <para>If equals to False and configure_c_stdio is True, disable
    /// buffering on the C streams stdout and stderr.</para>
    /// <para>Set to False by the -u command line option and the
    /// PYTHONUNBUFFERED environment variable.</para>
    /// <para>stdin is always opened in buffered mode.</para>
    /// <para>Default: True.</para>
    /// </summary>
    property buffered_stdio            : boolean                  read Get_buffered_stdio               write Set_buffered_stdio;
    /// <summary>
    /// <para>If equals to 1, issue a warning when comparing bytes or
    /// bytearray with str, or comparing bytes with int.</para>
    /// <para>If equal or greater to 2, raise a BytesWarning exception in
    /// these cases.</para>
    /// <para>Incremented by the -b command line option.</para>
    /// <para>Default: 0.</para>
    /// </summary>
    property bytes_warning             : integer                  read Get_bytes_warning                write Set_bytes_warning;
    /// <summary>
    /// <para>Control the validation behavior of hash-based .pyc files: value
    /// of the --check-hash-based-pycs command line option.</para>
    /// <para>Valid values:</para>
    /// <code>
    /// - "always": Hash the source file for invalidation regardless of value
    ///   of the 'check_source' flag.
    /// - "never": Assume that hash-based pycs always are valid.
    /// - "default": The 'check_source' flag in hash-based pycs determines
    ///   invalidation.
    /// </code>
    /// <para>Default: "default".</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://peps.python.org/pep-0552/">See also PEP 552 "Deterministic pycs".</see></para>
    /// </remarks>
    property check_hash_pycs_mode      : string                   read Get_check_hash_pycs_mode         write Set_check_hash_pycs_mode;
    /// <summary>
    /// <para>If equals to False, disables the inclusion of the end line and
    /// column mappings in code objects. Also disables traceback printing
    /// carets to specific error locations.</para>
    /// <para>Set to False by the PYTHONNODEBUGRANGES environment variable
    /// and by the -X no_debug_ranges command line option.</para>
    /// <para>Default: True.</para>
    /// </summary>
    property code_debug_ranges         : boolean                  read Get_code_debug_ranges            write Set_code_debug_ranges;
    /// <summary>
    /// <para>If True, configure C standard streams:</para>
    /// <code>
    /// - On Windows, set the binary mode (O_BINARY) on stdin, stdout and
    ///   stderr.
    /// - If buffered_stdio equals zero, disable buffering of stdin, stdout
    ///   and stderr streams.
    /// - If interactive is non-zero, enable stream buffering on stdin and
    ///   stdout (only stdout on Windows).
    /// </code>
    /// <para>Default: True in Python config, False in isolated config.</para>
    /// </summary>
    property configure_c_stdio         : boolean                  read Get_configure_c_stdio            write Set_configure_c_stdio;
    /// <summary>
    /// <para>The 'context_aware_warnings' field exists to control whether the
    /// 'warnings.catch_warnings()' context manager behaves
    /// *concurrently safely*.</para>
    /// <code>
    /// - When 'context_aware_warnings' is **true**, 'catch_warnings' uses a
    ///   'ContextVar' to store the temporarily-established warning filter
    ///   state, so using it is safe across **threads and asyncio tasks**.
    /// - When 'context_aware_warnings' is **false**, 'catch_warnings' falls
    ///   back to modifying **global state** in the 'warnings' module, which
    ///   is **not safe** in concurrent programs (thread/async behavior can
    ///   become undefined).
    /// </code>
    /// <para>It can also be set via the '-X context_aware_warnings'
    /// command-line option or the 'PYTHON_CONTEXT_AWARE_WARNINGS' environment
    /// variable. '<citation src="1"></citation>'</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHON_CONTEXT_AWARE_WARNINGS">See the article about PYTHON_CONTEXT_AWARE_WARNINGS.</see></para>
    /// </remarks>
    property context_aware_warnings    : boolean                  read Get_context_aware_warnings       write Set_context_aware_warnings;
    {$IFDEF APPLE}
    /// <summary>
    /// <para>If non-zero, stdout and stderr will be redirected to the system
    /// log.</para>
    /// <para>Only available on macOS 10.12 and later, and on iOS.</para>
    /// <para>Default: False (don't use the system log) on macOS; True on iOS
    /// (use the system log).</para>
    /// <para>Added in version 3.14.</para>
    /// </summary>
    property use_system_logger         : boolean                  read Get_use_system_logger            write Set_use_system_logger;
    {$ENDIF}
    /// <summary>
    /// <para>If the value of cpu_count is not -1 then it will override the
    /// return values of os.cpu_count(), os.process_cpu_count(), and
    /// multiprocessing.cpu_count().</para>
    /// <para>Configured by the -X cpu_count=n|default command line flag or
    /// the PYTHON_CPU_COUNT environment variable.</para>
    /// <para>Default: -1.</para>
    /// </summary>
    property cpu_count                 : integer                  read Get_cpu_count                    write Set_cpu_count;
    /// <summary>
    /// <para>If True, enable the Python Development Mode.</para>
    /// <para>Set to True by the -X dev option and the PYTHONDEVMODE
    /// environment variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/library/devmode.html#devmode">See the article about Python Development Mode.</see></para>
    /// </remarks>
    property dev_mode                  : boolean                  read Get_dev_mode                     write Set_dev_mode;
    /// <summary>
    /// <para>Dump Python references?</para>
    /// <para>If True, dump all objects which are still alive at exit.</para>
    /// <para>Set to True by the PYTHONDUMPREFS environment variable.</para>
    /// <para>Needs a special build of Python with the Py_TRACE_REFS macro
    /// defined: see the configure --with-trace-refs option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property dump_refs                 : boolean                  read Get_dump_refs                    write Set_dump_refs;
    /// <summary>
    /// <para>Filename where to dump Python references. Set by the
    /// PYTHONDUMPREFSFILE environment variable.</para>
    /// </summary>
    property dump_refs_file            : string                   read Get_dump_refs_file               write Set_dump_refs_file;
    /// <summary>
    /// <para>The site-specific directory prefix where the platform-dependent
    /// Python files are installed: sys.exec_prefix.</para>
    /// <para>Part of the Python Path Configuration output.</para>
    /// <para>See also PyConfig.base_exec_prefix.</para>
    /// </summary>
    property exec_prefix               : string                   read Get_exec_prefix                  write Set_exec_prefix;
    /// <summary>
    /// <para>The absolute path of the executable binary for the Python
    /// interpreter: sys.executable.</para>
    /// <para>Part of the Python Path Configuration output.</para>
    /// <para>See also PyConfig.base_executable.</para>
    /// </summary>
    property executable                : string                   read Get_executable                   write Set_executable;
    /// <summary>
    /// <para>Enable faulthandler?</para>
    /// <para>If True, call faulthandler.enable() at startup.</para>
    /// <para>Set to True by -X faulthandler and the PYTHONFAULTHANDLER
    /// environment variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    property faulthandler              : integer                  read Get_faulthandler                 write Set_faulthandler;
    /// <summary>
    /// <para>Filesystem encoding: sys.getfilesystemencoding().</para>
    /// <para>On macOS, Android and VxWorks: use "utf-8" by default.</para>
    /// <para>On Windows: use "utf-8" by default, or "mbcs" if
    /// legacy_windows_fs_encoding of PyPreConfig is non-zero.</para>
    /// <para>Default encoding on other platforms:</para>
    /// <code>
    /// - "utf-8" if PyPreConfig.utf8_mode is non-zero.
    /// - "ascii" if Python detects that nl_langinfo(CODESET) announces the
    ///   ASCII encoding, whereas the mbstowcs() function decodes from a
    ///   different encoding (usually Latin1).
    /// - "utf-8" if nl_langinfo(CODESET) returns an empty string.
    /// </code>
    /// <para>Otherwise, use the locale encoding: nl_langinfo(CODESET)
    /// result.</para>
    /// <para>At Python startup, the encoding name is normalized to the Python
    /// codec name. For example, "ANSI_X3.4-1968" is replaced with
    /// "ascii".</para>
    /// <para>See also the filesystem_errors member.</para>
    /// </summary>
    property filesystem_encoding       : string                   read Get_filesystem_encoding          write Set_filesystem_encoding;
    /// <summary>
    /// <para>Filesystem error handler: sys.getfilesystemencodeerrors().</para>
    /// <para>On Windows: use "surrogatepass" by default, or "replace" if
    /// legacy_windows_fs_encoding of PyPreConfig is non-zero.</para>
    /// <para>On other platforms: use "surrogateescape" by default.</para>
    /// <para>Supported error handlers:</para>
    /// <code>
    /// - "strict"
    /// - "surrogateescape"
    /// - "surrogatepass" (only supported with the UTF-8 encoding)
    /// </code>
    /// <para>See also the filesystem_encoding member.</para>
    /// </summary>
    property filesystem_errors         : string                   read Get_filesystem_errors            write Set_filesystem_errors;
    /// <summary>
    /// <para>Hash seed</para>
    /// </summary>
    property hash_seed                 : uint64                   read Get_hash_seed                    write Set_hash_seed;
    /// <summary>
    /// <para>Set the default Python "home" directory, that is, the location
    /// of the standard Python libraries.</para>
    /// <para>Set by the PYTHONHOME environment variable.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONHOME">See the article about PYTHONHOME.</see></para>
    /// </remarks>
    property home                      : string                   read Get_home                         write Set_home;
    /// <summary>
    /// <para>If 1, profile import time. If 2, include additional output that
    /// indicates when an imported module has already been loaded.</para>
    /// <para>Set by the -X importtime option and the PYTHONPROFILEIMPORTTIME
    /// environment variable.</para>
    /// <para>Default: 0.</para>
    /// <para>Changed in version 3.14: Added support for import_time = 2</para>
    /// </summary>
    property import_time               : integer                  read Get_import_time                  write Set_import_time;
    /// <summary>
    /// <para>Enter interactive mode after executing a script or a
    /// command.</para>
    /// <para>If True, enable inspect: when a script is passed as first
    /// argument or the -c option is used, enter interactive mode after
    /// executing the script or the command, even when sys.stdin does not
    /// appear to be a terminal.</para>
    /// <para>Enabled by the -i command line option. Set to True if the
    /// PYTHONINSPECT environment variable is non-empty.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property inspect                   : boolean                  read Get_inspect                      write Set_inspect;
    /// <summary>
    /// <para>Install Python signal handlers?</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    property install_signal_handlers   : boolean                  read Get_install_signal_handlers      write Set_install_signal_handlers;
    /// <summary>
    /// <para>Configures the integer string conversion length limitation. An
    /// initial value of -1 means the value will be taken from the command
    /// line or environment or otherwise default to 4300
    /// (sys.int_info.default_max_str_digits). A value of 0 disables the
    /// limitation. Values greater than zero but less than 640
    /// (sys.int_info.str_digits_check_threshold) are unsupported and will
    /// produce an error.</para>
    /// <para>Configured by the -X int_max_str_digits command line flag or the
    /// PYTHONINTMAXSTRDIGITS environment variable.</para>
    /// <para>Default: -1 in Python mode. 4300
    /// (sys.int_info.default_max_str_digits) in isolated mode.</para>
    /// <para>Added in version 3.12.</para>
    /// </summary>
    property int_max_str_digits        : integer                  read Get_int_max_str_digits           write Set_int_max_str_digits;
    /// <summary>
    /// <para>If True, enable the interactive mode (REPL).</para>
    /// <para>Enabled by the -i command line option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property interactive               : boolean                  read Get_interactive                  write Set_interactive;
    /// <summary>
    /// <para>If True, enable isolated mode:</para>
    /// <code>
    /// - Set safe_path to True: don't prepend a potentially unsafe path to
    ///   sys.path at Python startup, such as the current directory, the
    ///   script's directory or an empty string.
    /// - Set use_environment to False: ignore PYTHON environment variables.
    /// - Set user_site_directory to False: don't add the user site directory
    ///   to sys.path.
    /// - Python REPL doesn't import readline nor enable default readline
    ///   configuration on interactive prompts.
    /// </code>
    /// <para>Set to True by the -I command line option.</para>
    /// <para>Default: False in Python mode, True in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#isolated-configuration">See the article about Isolated Configuration.</see></para>
    /// </remarks>
    property isolated                  : boolean                  read Get_isolated                     write Set_isolated;
    /// <summary>
    /// <para>Controls lazy import behavior. Accepts two values:</para>
    /// <code>
    /// - li_all makes all imports lazy by default.
    /// - li_normal (the default) respects the lazy keyword in source code.
    /// </code>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3.15/using/cmdline.html#envvar-PYTHON_LAZY_IMPORTS">See the article about PYTHON_LAZY_IMPORTS.</see></para>
    /// <para>Added in version 3.15.</para>
    /// </remarks>
    property lazy_imports              : PyImport_LazyImportsMode read Get_lazy_imports                 write Set_lazy_imports;
    {$IFDEF MSWINDOWS}
    /// <summary>
    /// <para>If True, use io.FileIO instead of io._WindowsConsoleIO for
    /// sys.stdin, sys.stdout and sys.stderr.</para>
    /// <para>Set to True if the PYTHONLEGACYWINDOWSSTDIO environment variable
    /// is set to a non-empty string.</para>
    /// <para>Only available on Windows. #ifdef MS_WINDOWS macro can be used
    /// for Windows specific code.</para>
    /// <para>Default: False.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://peps.python.org/pep-0528/">See also the PEP 528 (Change Windows console encoding to UTF-8).</see></para>
    /// </remarks>
    property legacy_windows_stdio      : boolean                  read Get_legacy_windows_stdio         write Set_legacy_windows_stdio;
    {$ENDIF}
    /// <summary>
    /// <para>If True, dump statistics on Python pymalloc memory allocator at
    /// exit.</para>
    /// <para>Set to True by the PYTHONMALLOCSTATS environment variable.</para>
    /// <para>The option is ignored if Python is configured using the
    /// --without-pymalloc option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property malloc_stats              : boolean                  read Get_malloc_stats                 write Set_malloc_stats;
    /// <summary>
    /// <para>A list of strings that specifies the search path for
    /// modules.</para>
    /// <para>Initialized from the environment variable PYTHONPATH, plus an
    /// installation-dependent default.</para>
    /// <para>If module_search_paths_set is False, Py_InitializeFromConfig()
    /// will replace module_search_paths and sets module_search_paths_set to
    /// True.</para>
    /// <para>Default: empty list.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sys.html#sys.path">See the article about sys.path.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH">See the article about PYTHONPATH.</see></para>
    /// </remarks>
    property module_search_paths       : string                   read Get_module_search_paths          write Set_module_search_paths;
    /// <summary>
    /// <para>If module_search_paths_set is False, Py_InitializeFromConfig()
    /// will replace module_search_paths and sets module_search_paths_set to
    /// True.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property module_search_paths_set   : boolean                  read Get_module_search_paths_set      write Set_module_search_paths_set;
    /// <summary>
    /// <para>Compilation optimization level:</para>
    /// <code>
    /// - polDebug (0) : Peephole optimizer, set __debug__ to True.
    /// - polRelease (1) : Level 0, remove assertions, set __debug__ to False.
    /// - polReleaseNoDocStrings (2) : Level 1, strip docstrings.
    /// </code>
    /// <para>Incremented by the -O command line option. Set to the
    /// PYTHONOPTIMIZE environment variable value.</para>
    /// <para>Default: polDebug (0).</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONOPTIMIZE">See the article about PYTHONOPTIMIZE.</see></para>
    /// </remarks>
    property optimization_level        : TPyOptimizationLevel     read Get_optimization_level           write Set_optimization_level;
    /// <summary>
    /// <para>The list of the original command line arguments passed to the
    /// Python executable: sys.orig_argv.</para>
    /// <para>If orig_argv list is empty and argv is not a list only
    /// containing an empty string, TPyConfig.Read() copies argv into orig_argv
    /// before modifying argv (if parse_argv is non-zero).</para>
    /// <para>See also the argv member and the Py_GetArgcArgv()
    /// function.</para>
    /// <para>Default: empty list.</para>
    /// <para>Added in version 3.10.</para>
    /// </summary>
    property orig_argv                 : TStringDynArray          read Get_orig_argv                    write Set_orig_argv;
    /// <summary>
    /// <para>Parse command line arguments?</para>
    /// <para>If True, parse argv the same way the regular Python parses
    /// command line arguments, and strip Python arguments from argv.</para>
    /// <para>The PyConfig_Read() function only parses PyConfig.argv arguments
    /// once: PyConfig.parse_argv is set to True after arguments are parsed.
    /// Since Python arguments are stripped from PyConfig.argv, parsing
    /// arguments twice would parse the application options as Python
    /// options.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// <para>Changed in version 3.10: The PyConfig.argv arguments are now
    /// only parsed once.</para>
    /// </summary>
    property parse_argv                : boolean                  read Get_parse_argv                   write Set_parse_argv;
    /// <summary>
    /// <para>Parser debug mode. If True, turn on parser debugging output
    /// (for expert only, depending on compilation options).</para>
    /// <para>Enabled by the -d command line option. Set to the PYTHONDEBUG
    /// environment variable value.</para>
    /// <para>Needs a debug build of Python (the Py_DEBUG macro must be
    /// defined).</para>
    /// <para>Default: False.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONDEBUG">See the article about PYTHONDEBUG.</see></para>
    /// </remarks>
    property parser_debug              : boolean                  read Get_parser_debug                 write Set_parser_debug;
    /// <summary>
    /// <para>If True, calculation of path configuration is allowed to log
    /// warnings into stderr. If False, suppress these warnings.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// <para>Changed in version 3.11: Now also applies on Windows.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// </remarks>
    property pathconfig_warnings       : boolean                  read Get_pathconfig_warnings          write Set_pathconfig_warnings;
    /// <summary>
    /// <para>Enable the Linux perf profiler support?</para>
    /// <para>If equals to 1, enable support for the Linux perf
    /// profiler.</para>
    /// <para>If equals to 2, enable support for the Linux perf profiler with
    /// DWARF JIT support.</para>
    /// <para>Set to 1 by -X perf command-line option and the
    /// PYTHONPERFSUPPORT environment variable.</para>
    /// <para>Set to 2 by the -X perf_jit command-line option and the
    /// PYTHON_PERF_JIT_SUPPORT environment variable.</para>
    /// <para>Default: -1.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/howto/perf_profiling.html#perf-profiling">See Python support for the Linux perf profiler for more information.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPERFSUPPORT">See the article about PYTHONPERFSUPPORT.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHON_PERF_JIT_SUPPORT">See the article about PYTHON_PERF_JIT_SUPPORT.</see></para>
    /// </remarks>
    property perf_profiling            : integer                  read Get_perf_profiling               write Set_perf_profiling;
    /// <summary>
    /// <para>Platform library directory name: sys.platlibdir.</para>
    /// <para>Name of the platform-specific library directory. It is used to
    /// build the path of standard library and the paths of installed
    /// extension modules.</para>
    /// <para>Set by the PYTHONPLATLIBDIR environment variable.</para>
    /// <para>Default: value of the PLATLIBDIR macro which is set by the
    /// configure --with-platlibdir option (default: "lib", or "DLLs" on
    /// Windows).</para>
    /// <para>Added in version 3.9.</para>
    /// <para>Changed in version 3.11: This macro is now used on Windows to
    /// locate the standard library extension modules, typically under DLLs.
    /// However, for compatibility, note that this value is ignored for any
    /// non-standard layouts, including in-tree builds and virtual
    /// environments.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPLATLIBDIR">See the article about PYTHONPLATLIBDIR.</see></para>
    /// </remarks>
    property platlibdir                : string                   read Get_platlibdir                   write Set_platlibdir;
    /// <summary>
    /// <para>The site-specific directory prefix where the platform
    /// independent Python files are installed: sys.prefix.</para>
    /// <para>A string giving the site-specific directory prefix where the
    /// platform independent Python files are installed; on Unix, the default
    /// is /usr/local. This can be set at build time with the --prefix
    /// argument to the configure script.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
    /// <para>See also PyConfig.base_prefix.</para>
    /// <para><see href="https://docs.python.org/3/library/sys.html#sys.prefix">See the article about sys.prefix.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sysconfig.html#installation-paths">See Installation paths for derived paths.</see></para>
    /// </remarks>
    property prefix                    : string                   read Get_prefix                       write Set_prefix;
    /// <summary>
    /// <para>Program name used to initialize executable and in early error
    /// messages during Python initialization.</para>
    /// <para>On macOS, use PYTHONEXECUTABLE environment variable if
    /// set.</para>
    /// <para>If the WITH_NEXT_FRAMEWORK macro is defined, use
    /// __PYVENV_LAUNCHER__ environment variable if set.</para>
    /// <para>Use argv[0] of argv if available and non-empty.</para>
    /// <para>Otherwise, use "python" on Windows, or "python3" on other
    /// platforms.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONEXECUTABLE">See the article about PYTHONEXECUTABLE.</see></para>
    /// <para>See PyConfig.executable and PyConfig.base_executable.</para>
    /// </remarks>
    property program_name              : string                   read Get_program_name                 write Set_program_name;
    /// <summary>
    /// <para>Directory where cached .pyc files are written:
    /// sys.pycache_prefix.</para>
    /// <para>Set by the -X pycache_prefix=PATH command line option and the
    /// PYTHONPYCACHEPREFIX environment variable. The command-line option
    /// takes precedence.</para>
    /// <para>If empty, sys.pycache_prefix is set to None.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPYCACHEPREFIX">See the article about PYTHONPYCACHEPREFIX.</see></para>
    /// <para><see href="https://docs.python.org/3/library/sys.html#sys.pycache_prefix">See the article about sys.pycache_prefix.</see></para>
    /// </remarks>
    property pycache_prefix            : string                   read Get_pycache_prefix               write Set_pycache_prefix;
    /// <summary>
    /// <para>Enable huge page support for pymalloc arenas (disabled by
    /// default). When enabled, the arena size on 64-bit platforms is increased
    /// to 2 MiB and arena allocation uses MAP_HUGETLB (Linux) or
    /// MEM_LARGE_PAGES (Windows) with automatic fallback to regular
    /// pages.</para>
    /// <para>Even when compiled with this option, huge pages are not used at
    /// runtime unless the PYTHON_PYMALLOC_HUGEPAGES environment variable is set
    /// to 1. This opt-in is required because huge pages</para>
    /// <code>
    /// - carry risks on Linux: if the huge-page pool is exhausted, page faults
    /// (including copy-on-write faults after os.fork()) deliver SIGBUS and kill
    /// the process.
    /// - need a special privilege on Windows. See the Windows documentation for
    /// large pages for details. Python will fail on startup if the required
    /// privilege SeLockMemoryPrivilege is not held by the user.
    /// </code>
    /// <para>The configure script checks that the platform supports MAP_HUGETLB
    /// and emits a warning if it is not available.</para>
    /// <para>On Windows, use the --pymalloc-hugepages flag with build.bat or
    /// set the UsePymallocHugepages MSBuild property.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3.15/using/configure.html#cmdoption-with-pymalloc-hugepages">See the article about --with-pymalloc-hugepages.</see></para>
    /// <para>Added in version 3.15.</para>
    /// </remarks>
    property pymalloc_hugepages         : boolean                 read Get_pymalloc_hugepages           write Set_pymalloc_hugepages;
    /// <summary>
    /// <para>Set by the PYTHONPATH environment variable.</para>
    /// <para>Default: Empty.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH">See the article about PYTHONPATH.</see></para>
    /// </remarks>
    property pythonpath_env            : string                   read Get_pythonpath_env               write Set_pythonpath_env;
    /// <summary>
    /// <para>Quiet mode. If True, don't display the copyright and version at
    /// Python startup in interactive mode.</para>
    /// <para>Enabled by the -q command line option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property quiet                     : boolean                  read Get_quiet                        write Set_quiet;
    /// <summary>
    /// <para>Safe external debugger interface for CPython.</para>
    /// <para>Default: True.</para>
    /// <para>Added in version 3.14.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/configure.html#cmdoption-without-remote-debug">See the article about --without-remote-debug</see></para>
    /// <para><see href="https://peps.python.org/pep-0768/">See the PEP 768.</see></para>
    /// </remarks>
    property remote_debug              : boolean                  read Get_remote_debug                 write Set_remote_debug;
    /// <summary>
    /// <para>Value of the -c command line option.</para>
    /// <para>Used by TPy.RunMain().</para>
    /// <para>Default: Empty.</para>
    /// </summary>
    property run_command               : string                   read Get_run_command                  write Set_run_command;
    /// <summary>
    /// <para>Filename passed on the command line: trailing command line
    /// argument without -c or -m. It is used by the TPy.RunMain()
    /// function.</para>
    /// <para>For example, it is set to script.py by the python3 script.py
    /// arg command line.</para>
    /// <para>Default: Empty.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/init_config.html#c.PyConfig.skip_source_first_line">See also the PyConfig.skip_source_first_line option.</see></para>
    /// </remarks>
    property run_filename              : string                   read Get_run_filename                 write Set_run_filename;
    /// <summary>
    /// <para>Value of the -m command line option.</para>
    /// <para>Used by TPy.RunMain().</para>
    /// <para>Default: Empty.</para>
    /// </summary>
    property run_module                : string                   read Get_run_module                   write Set_run_module;
    /// <summary>
    /// <para>If equals to zero, TPy.RunMain() prepends a potentially unsafe
    /// path to sys.path at startup:</para>
    /// <code>
    /// - If argv[0] is equal to "-m" (python -m module), prepend the current
    ///   working directory.
    /// - If running a script (python script.py), prepend the script's
    ///   directory. If it's a symbolic link, resolve symbolic links.
    /// - Otherwise (python -c code and python), prepend an empty string,
    ///   which means the current working directory.
    /// </code>
    /// <para>Set to 1 by the -P command line option and the PYTHONSAFEPATH
    /// environment variable.</para>
    /// <para>Default: False in Python config, True in isolated config.</para>
    /// <para>Added in version 3.11.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONSAFEPATH">See the article about PYTHONSAFEPATH.</see></para>
    /// </remarks>
    property safe_path                 : boolean                  read Get_safe_path                    write Set_safe_path;
    /// <summary>
    /// <para>Show total reference count at exit (excluding immortal
    /// objects)?</para>
    /// <para>Set to True by -X showrefcount command line option.</para>
    /// <para>Needs a debug build of Python (the Py_REF_DEBUG macro must be
    /// defined).</para>
    /// <para>Default: False.</para>
    /// </summary>
    property show_ref_count            : boolean                  read Get_show_ref_count               write Set_show_ref_count;
    /// <summary>
    /// <para>Import the site module at startup?</para>
    /// <para>If equal to zero, disable the import of the module site and the
    /// site-dependent manipulations of sys.path that it entails.</para>
    /// <para>Also disable these manipulations if the site module is
    /// explicitly imported later (call site.main() if you want them to be
    /// triggered).</para>
    /// <para>Set to False by the -S command line option.</para>
    /// <para>sys.flags.no_site is set to the inverted value of
    /// site_import.</para>
    /// <para>Default: True.</para>
    /// </summary>
    property site_import               : boolean                  read Get_site_import                  write Set_site_import;
    /// <summary>
    /// <para>If non-zero, skip the first line of the PyConfig.run_filename
    /// source.</para>
    /// <para>It allows the usage of non-Unix forms of #!cmd. This is intended
    /// for a DOS specific hack only.</para>
    /// <para>Set to True by the -x command line option.</para>
    /// <para>Default: False.</para>
    /// </summary>
    property skip_source_first_line    : boolean                  read Get_skip_source_first_line       write Set_skip_source_first_line;
    /// <summary>
    /// <para>Encoding of sys.stdin, sys.stdout and sys.stderr (but sys.stderr
    /// always uses "backslashreplace" error handler).</para>
    /// <para>Use the PYTHONIOENCODING environment variable if it is
    /// non-empty.</para>
    /// <para>Default encoding:</para>
    /// <code>
    /// - "UTF-8" if PyPreConfig.utf8_mode is non-zero.
    /// - Otherwise, use the locale encoding.
    /// </code>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONIOENCODING">See the article about PYTHONIOENCODING.</see></para>
    /// <para>See also PyConfig.legacy_windows_stdio.</para>
    /// </remarks>
    property stdio_encoding            : string                   read Get_stdio_encoding               write Set_stdio_encoding;
    /// <summary>
    /// <para>Encoding errors of sys.stdin, sys.stdout and sys.stderr (but
    /// sys.stderr always uses "backslashreplace" error handler).</para>
    /// <para>Use the PYTHONIOENCODING environment variable if it is
    /// non-empty.</para>
    /// <para>Default error handler:</para>
    /// <code>
    /// - On Windows: use "surrogateescape".
    /// - "surrogateescape" if PyPreConfig.utf8_mode is non-zero, or if the
    ///   LC_CTYPE locale is "C" or "POSIX".
    /// - "strict" otherwise.
    /// </code>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONIOENCODING">See the article about PYTHONIOENCODING.</see></para>
    /// <para>See also PyConfig.legacy_windows_stdio.</para>
    /// </remarks>
    property stdio_errors              : string                   read Get_stdio_errors                 write Set_stdio_errors;
    /// <summary>
    /// <para>Directory of the Python standard library.</para>
    /// <para>Default: Empty.</para>
    /// <para>Added in version 3.11.</para>
    /// </summary>
    property stdlib_dir                : string                   read Get_stdlib_dir                   write Set_stdlib_dir;
    /// <summary>
    /// <para>PyConfig.sys_path_0 is the value that Python uses as the first
    /// entry in sys.path (sys.path[0]) when the interpreter runs.</para>
    /// <para>In particular, it determines what sys.path[0] becomes for
    /// different invocation styles, for example:</para>
    /// <code>
    /// - for python -m module, sys.path[0] is set to include the current
    ///   working directory,
    /// - for python script.py, it's set to the script's directory,
    /// - for python -c code / plain python, it's set to an "empty string"
    ///   meaning the current working directory.
    /// </code>
    /// <para>So, when embedding Python via the C-API, setting
    /// PyConfig.sys_path_0 lets you control that first sys.path entry
    /// explicitly (instead of letting Python compute it).</para>
    /// </summary>
    property sys_path_0                : string                   read Get_sys_path_0                   write Set_sys_path_0;
    /// <summary>
    /// <para>Whether the new thread should inherit the current "execution
    /// context" from the thread that created it.</para>
    /// <para>If thread_inherit_context is true, the new thread starts with
    /// that same context (so things like trace IDs, user IDs, request-scoped
    /// metadata, etc. propagate).</para>
    /// <para>If it's false, the new thread runs with a fresh/default context
    /// (so context doesn't automatically carry over).</para>
    /// </summary>
    property thread_inherit_context    : boolean                  read Get_thread_inherit_context       write Set_thread_inherit_context;
    /// <summary>
    /// <para>Enable tracemalloc?</para>
    /// <para>If True, call tracemalloc.start() at startup.</para>
    /// <para>Set by -X tracemalloc=N command line option and by the
    /// PYTHONTRACEMALLOC environment variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONTRACEMALLOC">See the article about PYTHONTRACEMALLOC.</see></para>
    /// <para>See also PyConfig.legacy_windows_stdio.</para>
    /// </remarks>
    property tracemalloc               : boolean                  read Get_tracemalloc                  write Set_tracemalloc;
    /// <summary>
    /// <para>Use environment variables?</para>
    /// <para>If False, ignore the environment variables.</para>
    /// <para>Set to False by the -E environment variable.</para>
    /// <para>Default: True in Python config and False in isolated
    /// config.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#using-on-envvars">See the article about environment variables.</see></para>
    /// </remarks>
    property use_environment           : boolean                  read Get_use_environment              write Set_use_environment;
    /// <summary>
    /// <para>If True, use frozen modules.</para>
    /// <para>Set by the PYTHON_FROZEN_MODULES environment variable.</para>
    /// <para>Default: True in a release build, or False in a debug
    /// build.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHON_FROZEN_MODULES">See the article about PYTHON_FROZEN_MODULES.</see></para>
    /// </remarks>
    property use_frozen_modules        : boolean                  read Get_use_frozen_modules           write Set_use_frozen_modules;
    /// <summary>
    /// <para>Randomized hash function seed.</para>
    /// <para>If use_hash_seed is zero, a seed is chosen randomly at Python
    /// startup, and hash_seed is ignored.</para>
    /// <para>Set by the PYTHONHASHSEED environment variable.</para>
    /// <para>Default use_hash_seed value: True in Python mode, False in
    /// isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONHASHSEED">See the article about PYTHONHASHSEED.</see></para>
    /// </remarks>
    property use_hash_seed             : boolean                  read Get_use_hash_seed                write Set_use_hash_seed;
    /// <summary>
    /// <para>If True, add the user site directory to sys.path.</para>
    /// <para>Set to False by the -s and -I command line options.</para>
    /// <para>Set to False by the PYTHONNOUSERSITE environment variable.</para>
    /// <para>Default: True in Python mode, False in isolated mode.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONNOUSERSITE">See the article about PYTHONNOUSERSITE.</see></para>
    /// </remarks>
    property user_site_directory       : boolean                  read Get_user_site_directory          write Set_user_site_directory;
    /// <summary>
    /// <para>Verbose mode. If pvmModule or pvmFull, print a message each time
    /// a module is imported, showing the place (filename or built-in module)
    /// from which it is loaded.</para>
    /// <para>If pvmFull, print a message for each file
    /// that is checked for when searching for a module. Also provides
    /// information on module cleanup at exit.</para>
    /// <para>Enabled by the -v command line option.</para>
    /// <para>Set by the PYTHONVERBOSE environment variable value.</para>
    /// <para>Default: pvmDisabled.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONVERBOSE">See the article about PYTHONVERBOSE.</see></para>
    /// </remarks>
    property verbose                   : TPyVerboseMode           read Get_verbose                      write Set_verbose;
    /// <summary>
    /// <para>If non-zero, emit a EncodingWarning warning when
    /// io.TextIOWrapper uses its default encoding.</para>
    /// <para>Default: False.</para>
    /// <para>Added in version 3.10.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/library/io.html#io-encoding-warning">See Opt-in EncodingWarning for details.</see></para>
    /// </remarks>
    property warn_default_encoding     : boolean                  read Get_warn_default_encoding        write Set_warn_default_encoding;
    /// <summary>
    /// <para>Options of the warnings module to build warnings filters, lowest
    /// to highest priority: sys.warnoptions.</para>
    /// <para>The warnings module adds sys.warnoptions in the reverse order:
    /// the last PyConfig.warnoptions item becomes the first item of
    /// warnings.filters which is checked first (highest priority).</para>
    /// <para>The -W command line options adds its value to warnoptions, it
    /// can be used multiple times.</para>
    /// <para>The PYTHONWARNINGS environment variable can also be used to add
    /// warning options. Multiple options can be specified, separated by
    /// commas (,).</para>
    /// <para>Default: empty list.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONWARNINGS">See the article about PYTHONWARNINGS.</see></para>
    /// </remarks>
    property warnoptions               : TStringDynArray          read Get_warnoptions                  write Set_warnoptions;
    /// <summary>
    /// <para>If False, Python won't try to write .pyc files on the import of
    /// source modules.</para>
    /// <para>Set to False by the -B command line option and the
    /// PYTHONDONTWRITEBYTECODE environment variable.</para>
    /// <para>sys.dont_write_bytecode is initialized to the inverted value of
    /// write_bytecode.</para>
    /// <para>Default: True.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONDONTWRITEBYTECODE">See the article about PYTHONDONTWRITEBYTECODE.</see></para>
    /// </remarks>
    property write_bytecode            : boolean                  read Get_write_bytecode               write Set_write_bytecode;
    /// <summary>
    /// <para>Values of the -X command line options: sys._xoptions.</para>
    /// <para>Default: empty list.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/library/sys.html#sys._xoptions">See the article about sys._xoptions.</see></para>
    /// </remarks>
    property xoptions                  : TStringDynArray          read Get_xoptions                     write Set_xoptions;
  end;

  /// <summary>
  /// <para>A mutual exclusion lock. The PyMutex should be initialized to zero
  /// to represent the unlocked state. For example:</para>
  /// <code>PyMutex mutex = {0};</code>
  /// <para>Instances of PyMutex should not be copied or moved. Both the
  /// contents and address of a PyMutex are meaningful, and it must remain at a
  /// fixed, writable location in memory.</para>
  /// <para>Note A PyMutex currently occupies one byte, but the size should be
  /// considered unstable. The size may change in future Python releases without
  /// a deprecation period.</para>
  /// <para>Added in version 3.13.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/synchronization.html#c.PyMutex">See the article about PyMutex.</see></para>
  /// </remarks>
  IPyMutex = interface
    ['{FFDECD81-E7B4-4952-97C2-49DA65AB65A6}']
    function GetPyMutex: Pointer;
    /// <summary>
    /// <para>Lock mutex. If another thread has already locked it, the
    /// calling thread will block until the mutex is unlocked. While blocked,
    /// the thread will temporarily detach the thread state if one
    /// exists.</para>
    /// <para>Added in version 3.13.</para>
    /// </summary>
    procedure Lock;
    /// <summary>
    /// <para>Unlock mutex. The mutex must be locked - otherwise, the
    /// function will issue a fatal error.</para>
    /// <para>Added in version 3.13.</para>
    /// </summary>
    procedure Unlock;
    /// <summary>
    /// <para>Returns True if the mutex is currently locked, False
    /// otherwise.</para>
    /// <para>Note This function is intended for use in assertions and
    /// debugging only and should not be used to make concurrency control
    /// decisions, as the lock state may change immediately after the
    /// check.</para>
    /// </summary>
    function  IsLocked: boolean;
    /// <summary>
    /// <para>Pointer to the PyMutex record.</para>
    /// </summary>
    property PyMutex : Pointer read GetPyMutex;
  end;

  /// <summary>
  /// <para>A critical section protected by one mutex. You *CANNOT* use nested
  /// critical sections to lock more than one object at once.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/synchronization.html#python-critical-section-api">See the Python critical section API article.</see></para>
  /// </remarks>
  IPyCriticalSection = interface
    ['{5BDB099E-F443-4A46-BDCD-DBF10BC34811}']
    function GetPyCriticalSection: Pointer;
    /// <summary>
    /// <para>Acquires the per-object lock for the object op and begins a
    /// critical section.</para>
    /// <para>Added in version 3.13.</para>
    /// </summary>
    procedure Begin_(const op: IPyObject);
    /// <summary>
    /// <para>Locks the mutex m and begins a critical section.</para>
    /// <para>Added in version 3.14.</para>
    /// </summary>
    procedure BeginMutex(const m: IPyMutex);
    /// <summary>
    /// <para>Ends the critical section and releases the per-object lock.</para>
    /// <para>Added in version 3.13.</para>
    /// </summary>
    procedure End_;
    /// <summary>
    /// <para>Pointer to the PyCriticalSection record.</para>
    /// </summary>
    property PyCriticalSection : Pointer read GetPyCriticalSection;
  end;

  /// <summary>
  /// <para>A critical section protected by two mutexes. You *CANNOT* use nested
  /// critical sections to lock more than one object at once.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/synchronization.html#python-critical-section-api">See the Python critical section API article.</see></para>
  /// </remarks>
  IPyCriticalSection2 = interface
    ['{9CE03389-AA78-438B-A1FD-08E9CB14A4DB}']
    function GetPyCriticalSection: Pointer;
    /// <summary>
    /// <para>Acquires the per-object locks for the objects a and b and begins
    /// a critical section. The locks are acquired in a consistent order
    /// (lowest address first) to avoid lock ordering deadlocks.</para>
    /// <para>Added in version 3.13.</para>
    /// </summary>
    procedure Begin_(const a, b: IPyObject);
    /// <summary>
    /// <para>Locks the mutexes m1 and m2 and begins a critical section.</para>
    /// <para>Added in version 3.14.</para>
    /// </summary>
    procedure BeginMutex(const m1, m2: IPyMutex);
    /// <summary>
    /// <para>Ends the critical section and releases the per-object locks.</para>
    /// <para>Added in version 3.13.</para>
    /// </summary>
    procedure End_;
    /// <summary>
    /// <para>Pointer to the PyCriticalSection2 record.</para>
    /// </summary>
    property PyCriticalSection : Pointer read GetPyCriticalSection;
  end;

  IPyBytesWriter = interface
    ['{ACD94E97-8235-4D53-B61B-166D0B1228A9}']
    function  GetInitialized: boolean;
    function  GetWriter: PPyBytesWriter;
    /// <summary>
    /// <para>Get the writer data: start of the internal buffer.</para>
    /// <para>The pointer remains valid until a PyBytesWriter function
    /// other than TPyBytesWriter.GetData() or TPyBytesWriter.GetSize()
    /// is called on writer.</para>
    /// <para>The function cannot fail.</para>
    /// </summary>
    function GetData: Pointer;
    /// <summary>
    /// <para>Get the writer size.</para>
    /// <para>The function does not invalidate pointers returned by
    /// TPyBytesWriter.GetData().</para>
    /// <para>The function cannot fail.</para>
    /// </summary>
    function GetSize: Py_ssize_t;
    procedure SetWriter(aValue: PPyBytesWriter);
    /// <summary>
    /// <para>Discard a PyBytesWriter created by
    /// TPyBytesWriter.Create().</para>
    /// <para>Do nothing if writer is nil.</para>
    /// <para>The writer instance is invalid after the call. No API can
    /// be called on the writer after TPyBytesWriter.Discard().</para>
    /// </summary>
    procedure Discard;
    /// <summary>
    /// <para>Finish a PyBytesWriter created by
    /// TPyBytesWriter.Create().</para>
    /// <para>On success, return a Python bytes object. On error, set an
    /// exception and return nil.</para>
    /// <para>The writer instance is invalid after the call in any
    /// case.</para>
    /// <para>No API can be called on the writer after
    /// TPyBytesWriter.Finish().</para>
    /// </summary>
    function Finish: IPyObject;
    /// <summary>
    /// <para>Similar to TPyBytesWriter.Finish(), but resize the writer
    /// to size bytes before creating the bytes object.</para>
    /// </summary>
    function FinishWithSize(size_: Py_ssize_t): IPyObject;
    /// <summary>
    /// <para>Similar to TPyBytesWriter.Finish(), but resize the writer
    /// using buf pointer before creating the bytes object.</para>
    /// <para>Set an exception and return nil if buf pointer is outside
    /// the internal buffer bounds.</para>
    /// <para>Function pseudo-code:</para>
    /// <code>
    /// Py_ssize_t size = (char*)buf - (char*)PyBytesWriter_GetData(writer);
    /// return PyBytesWriter_FinishWithSize(writer, size);</para>
    /// </code>
    /// </summary>
    function FinishWithPointer(buf: Pointer): IPyObject;
    /// <summary>
    /// <para>Grow the writer internal buffer by size_ bytes, write size_
    /// bytes of bytes_ at the writer end, and add size_ to the writer
    /// size.</para>
    /// <para>If size is equal to -1, call strlen(bytes) to get the
    /// string length.</para>
    /// <para>On success, return True. On error, set an exception and
    /// return False.</para>
    /// </summary>
    function WriteBytes(const bytes_: Pointer; size_: Py_ssize_t): boolean; overload;
    /// <summary>
    /// <para>Grow the writer internal buffer by aStreamsize.size bytes,
    /// write aStream.size bytes at the writer end, and add
    /// aStreamsize.size to the writer size.</para>
    /// <para>On success, return True. On error, set an exception and
    /// return False.</para>
    /// </summary>
    function WriteBytes(const aStream: TMemoryStream): boolean; overload;
    /// <summary>
    /// <para>Resize the writer to size bytes. It can be used to enlarge
    /// or to shrink the writer. This function typically overallocates
    /// to achieve amortized performance when resizing multiple
    /// times.</para>
    /// <para>Newly allocated bytes are left uninitialized.</para>
    /// <para>On success, return True. On error, set an exception
    /// and return False.</para>
    /// <para>size must be positive or zero.</para>
    /// </summary>
    function Resize(size_: Py_ssize_t): boolean;
    /// <summary>
    /// <para>Resize the writer by adding grow bytes to the current
    /// writer size. This function typically overallocates to achieve
    /// amortized performance when resizing multiple times.</para>
    /// <para>Newly allocated bytes are left uninitialized.</para>
    /// <para>On success, return True. On error, set an exception
    /// and return False.</para>
    /// <para>size can be negative to shrink the writer.</para>
    /// </summary>
    function Grow(size_: Py_ssize_t): boolean;
    /// <summary>
    /// <para>Similar to TPyBytesWriter.Grow(), but update also the
    /// buf pointer.</para>
    /// <para>The buf pointer is moved if the internal buffer is moved
    /// in memory. The buf relative position within the internal buffer
    /// is left unchanged.</para>
    /// <para>On error, set an exception and return nil.</para>
    /// <para>buf must not be nil.</para>
    /// <para>Function pseudo-code:</para>
    /// <code>
    /// Py_ssize_t pos = (char*)buf - (char*)PyBytesWriter_GetData(writer);
    /// if (PyBytesWriter_Grow(writer, size) < 0) {
    ///     return NULL;
    /// }
    /// return (char*)PyBytesWriter_GetData(writer) + pos;
    /// </code>
    /// </summary>
    function GrowAndUpdatePointer(size_: Py_ssize_t; buf: Pointer): Pointer;
    /// <summary>
    /// <para>Returns true if the class is fully initialized.</para>
    /// </summary>
    property Initialized  : boolean               read GetInitialized;
    /// <summary>
    /// <para>Pointer to PyBytesWriter</para>
    /// </summary>
    property Writer       : PPyBytesWriter        read GetWriter         write SetWriter;
    /// <summary>
    /// <para>Get the writer data: start of the internal buffer.</para>
    /// <para>The pointer remains valid until a PyBytesWriter function
    /// other than TPyBytesWriter.GetData() or TPyBytesWriter.GetSize()
    /// is called on writer.</para>
    /// <para>The function cannot fail.</para>
    /// </summary>
    property Data         : Pointer               read GetData;
    /// <summary>
    /// <para>Get the writer size.</para>
    /// <para>The function does not invalidate pointers returned by
    /// TPyBytesWriter.GetData().</para>
    /// <para>The function cannot fail.</para>
    /// </summary>
    property Size         : Py_ssize_t            read GetSize;
  end;

  /// <summary>
  /// <para>IPyModuleDef is used to store the information about modules.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/extension-modules.html#multi-phase-initialization">See the article about Multi-phase initialization.</see></para>
  /// <para><see href="https://docs.python.org/3/c-api/structures.html#c.PyMethodDef">See the article about PyMethodDef.</see></para>
  /// </remarks>
  IPyModuleDef = interface
    ['{2AE205A2-DAC8-40F8-8662-3A8850F2B72D}']
    function  GetInitialized: boolean;
    function  GetName: AnsiString;
    function  GetDocStrings: AnsiString;
    function  GetCreateModuleFunction: create_modulefunc;
    function  GetExecFunction: exec_modulefunc;
    function  GetMultIntprSupport: TMultIntprSupport;
    function  GetGILUsed: boolean;
    function  GetHasSentinelSlot: boolean;
    function  GetHasSentinelMethod: boolean;
    function  GetModuleDef: PPyModuleDef;
    function  GetSize: integer;
    function  GetTraverse: traverseproc;
    function  GetClear: inquiry;
    function  GetFree: freefunc;

    procedure SetName(const aValue: AnsiString);
    procedure SetDocStrings(const aValue: AnsiString);
    procedure SetCreateModuleFunction(aValue: create_modulefunc);
    procedure SetExecFunction(aValue: exec_modulefunc);
    procedure SetMultIntprSupport(aValue: TMultIntprSupport);
    procedure SetGILUsed(aValue: boolean);
    procedure SetSize(aValue: integer);
    procedure SetTraverse(aValue: traverseproc);
    procedure SetClear(aValue: inquiry);
    procedure SetFree(aValue: freefunc);
    /// <summary>
    /// Initialize PyModuleDef and set the name and docstrings.
    /// </summary>
    function  Initialize: boolean;
    /// <summary>
    /// Override this procedure to add your custom slots.
    /// </summary>
    procedure AddAllSlots;
    /// <summary>
    /// Override this procedure to add your custom methods.
    /// </summary>
    procedure AddAllMethods;
    function  AddSentinelMethod: boolean;
    function  AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
    function  AddSentinelSlot: boolean;
    function  AddSlot(aSlot: integer; aValue: Pointer): boolean;
    function  AddCreateSlot: boolean;
    function  AddExecSlot: boolean;
    function  AddMultipleInterpretersSlot: boolean;
    function  AddGILSlot: boolean;
    /// <summary>
    /// Create the methods and the slots with all the module information.
    /// </summary>
    procedure BuildMethodsAndSlots;
    /// <summary>
    /// Returns true if this class is fully initialized.
    /// </summary>
    property  Initialized            : boolean            read GetInitialized;
    /// <summary>
    /// Name of the new module or data type.
    /// </summary>
    property  Name_                  : AnsiString         read GetName                 write SetName;
    /// <summary>
    /// The docstring of the new module or data type.
    /// </summary>
    property  DocStrings             : AnsiString         read GetDocStrings           write SetDocStrings;
    /// <summary>
    /// Return True if the last slot in the list is a sentinel slot.
    /// </summary>
    property  HasSentinelSlot        : boolean            read GetHasSentinelSlot;
    /// <summary>
    /// Return True if the last method in the list is a sentinel method.
    /// </summary>
    property  HasSentinelMethod      : boolean            read GetHasSentinelMethod;
    /// <summary>
    /// Return a poiter to PyModuleDef.
    /// </summary>
    property  ModuleDef              : PPyModuleDef       read GetModuleDef;
    /// <summary>
    /// <para>Specifies a function that is called to create the module object
    /// itself.</para>
    /// </summary>
    property  CreateModuleFunction   : create_modulefunc  read GetCreateModuleFunction write SetCreateModuleFunction;
    /// <summary>
    /// Function that will execute, or initialize, the module.
    /// </summary>
    property  ExecFunction           : exec_modulefunc    read GetExecFunction         write SetExecFunction;
    /// <summary>
    /// This slot determines whether or not importing this module in a
    /// subinterpreter will fail.
    /// If it's not specified, the import machinery defaults to miSupported.
    /// </summary>
    property  MultIntprSupport       : TMultIntprSupport  read GetMultIntprSupport     write SetMultIntprSupport;
    /// <summary>
    /// The module depends on the presence of the global interpreter lock
    /// (GIL) or it's safe to run without an active GIL.
    /// </summary>
    property  GILUsed                : boolean            read GetGILUsed              write SetGILUsed;
    /// <summary>
    /// Module state size. This value will be used in PyModuleDef.m_size.
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/module.html#c.PyModuleDef">See the article about PyModuleDef.</see></para>
    /// </remarks>
    property  Size_                  : integer            read GetSize                 write SetSize;
    /// <summary>
    /// <para>A traversal function to call during GC traversal of the module
    /// object, or nil if not needed.</para>
    /// <para>This value will be used in PyModuleDef.m_traverse.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/module.html#c.PyModuleDef">See the article about PyModuleDef.</see></para>
    /// </remarks>
    property  Traverse               : traverseproc       read GetTraverse             write SetTraverse;
    /// <summary>
    /// <para>A clear function to call during GC clearing of the module object,
    /// or nil if not needed.</para>
    /// <para>This value will be used in PyModuleDef.m_clear.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/module.html#c.PyModuleDef">See the article about PyModuleDef.</see></para>
    /// </remarks>
    property  Clear_                 : inquiry            read GetClear                write SetClear;
    /// <summary>
    /// <para>A function to call during deallocation of the module object,
    /// or nil if not needed.</para>
    /// <para>This value will be used in PyModuleDef.m_free.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3/c-api/module.html#c.PyModuleDef">See the article about PyModuleDef.</see></para>
    /// </remarks>
    property  Free_                  : freefunc           read GetFree                 write SetFree;
  end;

  /// <summary>
  /// <para>IPyModuleSlotManager is used to store the information about the
  /// module and to manage the method and slot lists.</para>
  /// </summary>
  IPyModuleSlotManager = interface
    ['{999AF3C1-4CB8-480F-82A5-60703372FA47}']
    function  GetName: AnsiString;
    function  GetDocStrings: AnsiString;
    function  GetToken: pointer;
    function  GetHasSentinelSlot: boolean;
    function  GetHasSentinelMethod: boolean;
    function  GetSlots: PPySlot;
    function  GetCreateModuleFunction: create_modulefunc;
    function  GetExecFunction: exec_modulefunc;
    function  GetMultIntprSupport: TMultIntprSupport;
    function  GetGILUsed: boolean;
    function  GetABIInfo: PPyAbiInfo;
    function  GetStateSize: integer;
    function  GetStateTraverse: traverseproc;
    function  GetStateClear: inquiry;
    function  GetStateFree: inquiry;

    procedure SetName(const aValue: AnsiString);
    procedure SetDocStrings(const aValue: AnsiString);
    procedure SetToken(aValue: pointer);
    procedure SetCreateModuleFunction(aValue: create_modulefunc);
    procedure SetExecFunction(aValue: exec_modulefunc);
    procedure SetMultIntprSupport(aValue: TMultIntprSupport);
    procedure SetGILUsed(aValue: boolean);
    procedure SetStateSize(aValue: integer);
    procedure setStateTraverse(aValue: traverseproc);
    procedure SetStateClear(aValue: inquiry);
    procedure SetStateFree(aValue: inquiry);

    function  AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
    function  AddSentinelMethod: boolean;
    function  AddSentinelSlot: boolean;
    function  AddNameSlot: boolean;
    function  AddDocStringsSlot: boolean;
    function  AddTokenSlot: boolean;
    function  AddMethodsSlot: boolean;
    function  AddABIInfoSlot: boolean;
    function  AddCreateSlot: boolean;
    function  AddExecSlot: boolean;
    function  AddMultipleInterpretersSlot: boolean;
    function  AddGILSlot: boolean;
    function  AddStateSizeSlot: boolean;
    function  AddStateTraverseSlot: boolean;
    function  AddStateClearSlot: boolean;
    function  AddStateFreeSlot: boolean;

    /// <summary>
    /// Override this procedure to add your custom slots.
    /// </summary>
    procedure AddAllSlots;
    /// <summary>
    /// Override this procedure to add your custom methods.
    /// </summary>
    procedure AddAllMethods;
    /// <summary>
    /// Create the slots with the methods and all the module information.
    /// </summary>
    procedure Initialize;

    /// <summary>
    /// Name of the new module.
    /// </summary>
    property  Name_                  : AnsiString                   read GetName                 write SetName;
    /// <summary>
    /// The docstring of the new module.
    /// </summary>
    property  DocStrings             : AnsiString                   read GetDocStrings           write SetDocStrings;
    /// <summary>
    /// Return True if the last slot has a Py_slot_end value in the
    /// sl_id field.
    /// </summary>
    property  HasSentinelSlot        : boolean                      read GetHasSentinelSlot;
    /// <summary>
    /// Return True if the last method in the list is a sentinel method.
    /// </summary>
    property  HasSentinelMethod      : boolean                      read GetHasSentinelMethod;
    /// <summary>
    /// Return a pointer to the first slot.
    /// </summary>
    property  Slots                  : PPySlot                      read GetSlots;
    /// <summary>
    /// The associated token is a pointer-sized value intended to identify
    /// this object.
    /// </summary>
    property  Token                  : pointer                      read GetToken                write SetToken;
    /// <summary>
    /// <para>Specifies a function that is called to create the module object
    /// itself.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_create">See the article about Py_mod_create.</see></para>
    /// </remarks>
    property  CreateModuleFunction   : create_modulefunc            read GetCreateModuleFunction write SetCreateModuleFunction;
    /// <summary>
    /// <para>Specifies a function that is called to execute the module. This is
    /// equivalent to executing the code of a Python module: typically, this
    /// function adds classes and constants to the module.</para>
    /// </summary>
    /// <remarks>
    /// <para><see href="https://docs.python.org/3.15/c-api/module.html#c.Py_mod_exec">See the article about Py_mod_exec.</see></para>
    /// </remarks>
    property  ExecFunction           : exec_modulefunc              read GetExecFunction         write SetExecFunction;
    /// <summary>
    /// This slot determines whether or not importing this module in a
    /// subinterpreter will fail.
    /// If it's not specified, the import machinery defaults to miSupported.
    /// </summary>
    property  MultIntprSupport       : TMultIntprSupport            read GetMultIntprSupport     write SetMultIntprSupport;
    /// <summary>
    /// The module depends on the presence of the global interpreter lock
    /// (GIL) or it's safe to run without an active GIL.
    /// </summary>
    property  GILUsed                : boolean                      read GetGILUsed              write SetGILUsed;
    /// <summary>
    /// Return a pointer to the ABI info record.
    /// </summary>
    property  ABIInfo                : PPyAbiInfo                   read GetABIInfo;
    /// <summary>
    /// Size of the module state, in bytes.
    /// </summary>
    property  StateSize              : integer                      read GetStateSize            write SetStateSize;
    /// <summary>
    /// Traversal function to call during GC traversal of the module object.
    /// </summary>
    property  StateTraverse          : traverseproc                 read GetStateTraverse        write SetStateTraverse;
    /// <summary>
    /// Clear function to call during GC clearing of the module object.
    /// </summary>
    property  StateClear             : inquiry                      read GetStateClear           write SetStateClear;
    /// <summary>
    /// Function to call during deallocation of the module object.
    /// </summary>
    property  StateFree              : inquiry                      read GetStateFree            write SetStateFree;
  end;

  /// <summary>
  /// <para>IPyHeapTypeSlotManager is used to store the information about the
  /// heap type and to manage the method and slot lists.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/type.html#creating-heap-allocated-types">See the article about Creating Heap-Allocated Types.</see></para>
  /// <para><see href="https://docs.python.org/3/c-api/type.html#c.PyTypeObject">See the article about PyTypeObject.</see></para>
  /// </remarks>
  IPyHeapTypeSlotManager = interface
    ['{93297C49-56B5-40CD-B4AB-310194E65DEA}']
    function  GetName: AnsiString;
    function  GetDocStrings: AnsiString;
    function  GetToken: pointer;
    function  GetHasSentinelSlot: boolean;
    function  GetHasSentinelMethod: boolean;
    function  GetHasSentinelMember: boolean;
    function  GetHasSentinelGetSet: boolean;
    function  GetSlots: PPySlot;
    function  GetMetaclass: PPyTypeObject;
    function  GetModule: IPyObject;
    function  GetBases: IPyObject;
    function  GetBasicsize: Py_ssize_t;
    function  GetExtraBasicsize: Py_ssize_t;
    function  GetItemsize: Py_ssize_t;
    function  GetFlags: NativeUInt;

    procedure SetName(const aValue: AnsiString);
    procedure SetDocStrings(const aValue: AnsiString);
    procedure SetToken(aValue: pointer);
    procedure SetMetaclass(aValue: PPyTypeObject);
    procedure SetModule(const aValue: IPyObject);
    procedure SetBases(const aValue: IPyObject);
    procedure SetBasicSize(aValue: Py_ssize_t);
    procedure SetExtraBasicSize(aValue: Py_ssize_t);
    procedure SetItemSize(aValue: Py_ssize_t);
    procedure SetFlags(aValue: NativeUInt);

    procedure CreateSlotArray;
    procedure CreateMethodArray;
    procedure CreateMemberArray;
    procedure CreateGetSetArray;

    procedure DestroySlotList;
    procedure DestroySlots;
    procedure DestroyMethodList;
    procedure DestroyMethods;
    procedure DestroyMemberList;
    procedure DestroyMembers;
    procedure DestroyGetSetList;
    procedure DestroyGetSets;

    /// <summary>
    /// Add a method.
    /// </summary>
    function  AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
    /// <summary>
    /// Add a member.
    /// </summary>
    function  AddMember(const aName, aDocStrings: string; aType, aFlags: integer; aOffset: Py_ssize_t): boolean;
    /// <summary>
    /// Add a getset.
    /// </summary>
    function  AddGetSet(const aName, aDocStrings: string; const aGet: getter; const aSet: setter; aClosure: pointer): boolean;

    /// <summary>
    /// Add a sentinel method slot.
    /// </summary>
    function  AddSentinelMethod: boolean;
    /// <summary>
    /// Add a sentinel member slot.
    /// </summary>
    function  AddSentinelMember: boolean;
    /// <summary>
    /// Add a sentinel getset slot.
    /// </summary>
    function  AddSentinelGetSet: boolean;
    /// <summary>
    /// Add a sentinel slot.
    /// </summary>
    function  AddSentinelSlot: boolean;

    /// <summary>
    /// Add a Py_tp_alloc slot.
    /// </summary>
    function  AddAllocSlot(const aFunc: allocfunc): boolean;
    /// <summary>
    /// Add a Py_tp_base(s) slot.
    /// </summary>
    function  AddBasesSlot: boolean;
    /// <summary>
    /// Add a Py_tp_basicsize slot.
    /// </summary>
    function  AddBasicsizeSlot: boolean;
    /// <summary>
    /// Add a Py_tp_call slot.
    /// </summary>
    function  AddCallSlot(const aFunc: ternaryfunc): boolean;
    /// <summary>
    /// Add a Py_tp_clear slot.
    /// </summary>
    function  AddClearSlot(const aFunc: inquiry): boolean;
    /// <summary>
    /// Add a Py_tp_dealloc slot.
    /// </summary>
    function  AddDeallocSlot(const aFunc: destructor_): boolean;
    /// <summary>
    /// Add a Py_tp_del slot.
    /// </summary>
    function  AddDelSlot(const aFunc: destructor_): boolean;
    /// <summary>
    /// Add a Py_tp_descr_get slot.
    /// </summary>
    function  AddDescrGetSlot(const aFunc: descrgetfunc): boolean;
    /// <summary>
    /// Add a Py_tp_descr_set slot.
    /// </summary>
    function  AddDescrSetSlot(const aFunc: descrsetfunc): boolean;
    /// <summary>
    /// Add a Py_tp_doc slot.
    /// </summary>
    function  AddDocSlot: boolean;
    /// <summary>
    /// Add a Py_tp_extra_basicsize slot.
    /// </summary>
    function  AddExtraBasicsizeSlot: boolean;
    /// <summary>
    /// Add a Py_tp_finalize slot.
    /// </summary>
    function  AddFinalizeSlot(const aFunc: destructor_): boolean;
    /// <summary>
    /// Add a Py_tp_flags slot.
    /// </summary>
    function  AddFlagsSlot: boolean;
    /// <summary>
    /// Add a Py_tp_free slot.
    /// </summary>
    function  AddFreeSlot(const aFunc: freefunc): boolean;
    /// <summary>
    /// Add a Py_tp_getattr slot.
    /// </summary>
    function  AddGetAttrSlot(const aFunc: getattrfunc): boolean;
    /// <summary>
    /// Add a Py_tp_getattro slot.
    /// </summary>
    function  AddGetAttroSlot(const aFunc: getattrofunc): boolean;
    /// <summary>
    /// Add a Py_tp_getset slot.
    /// </summary>
    function  AddGetSetsSlot: boolean;
    /// <summary>
    /// Add a Py_tp_hash slot.
    /// </summary>
    function  AddHashSlot(const aFunc: hashfunc): boolean;
    /// <summary>
    /// Add a Py_tp_init slot.
    /// </summary>
    function  AddInitSlot(const aFunc: initproc): boolean;
    /// <summary>
    /// Add a Py_tp_is_gc slot.
    /// </summary>
    function  AddIsGCSlot(const aFunc: inquiry): boolean;
    /// <summary>
    /// Add a Py_tp_itemsize slot.
    /// </summary>
    function  AddItemsizeSlot: boolean;
    /// <summary>
    /// Add a Py_tp_iter slot.
    /// </summary>
    function  AddIterSlot(const aFunc: getiterfunc): boolean;
    /// <summary>
    /// Add a Py_tp_iternext slot.
    /// </summary>
    function  AddIterNextSlot(const aFunc: iternextfunc): boolean;
    /// <summary>
    /// Add a Py_tp_members slot.
    /// </summary>
    function  AddMembersSlot: boolean;
    /// <summary>
    /// Add a Py_tp_metaclass slot.
    /// </summary>
    function  AddMetaclassSlot: boolean;
    /// <summary>
    /// Add a Py_tp_methods slot.
    /// </summary>
    function  AddMethodsSlot: boolean;
    /// <summary>
    /// Add a Py_tp_module slot.
    /// </summary>
    function  AddModuleSlot: boolean;
    /// <summary>
    /// Add a Py_tp_name slot.
    /// </summary>
    function  AddNameSlot: boolean;
    /// <summary>
    /// Add a Py_tp_new slot.
    /// </summary>
    function  AddNewSlot(const aFunc: newfunc): boolean;
    /// <summary>
    /// Add a Py_tp_repr slot.
    /// </summary>
    function  AddReprSlot(const aFunc: reprfunc): boolean;
    /// <summary>
    /// Add a Py_tp_richcompare slot.
    /// </summary>
    function  AddRichCompareSlot(const aFunc: richcmpfunc): boolean;
    /// <summary>
    /// Add a Py_tp_setattr slot.
    /// </summary>
    function  AddSetAttrSlot(const aFunc: setattrfunc): boolean;
    /// <summary>
    /// Add a Py_tp_setattro slot.
    /// </summary>
    function  AddSetAttroSlot(const aFunc: setattrofunc): boolean;
    /// <summary>
    /// Add a Py_tp_slots slot.
    /// </summary>
    function  AddSlotsSlot(const aSlots: PPyType_Slot): boolean;
    /// <summary>
    /// Add a Py_tp_str slot.
    /// </summary>
    function  AddStrSlot(const aFunc: reprfunc): boolean;
    /// <summary>
    /// Add a Py_slot_subslots slot.
    /// </summary>
    function  AddSubslotsSlot(const aSlots: PPySlot): boolean;
    /// <summary>
    /// Add a Py_tp_token slot.
    /// </summary>
    function  AddTokenSlot: boolean;
    /// <summary>
    /// Add a Py_tp_traverse slot.
    /// </summary>
    function  AddTraverseSlot(const aFunc: traverseproc): boolean;
    /// <summary>
    /// Add a Py_tp_vectorcall slot.
    /// </summary>
    function  AddVectorcallSlot(const aFunc: vectorcallfunc): boolean;

    /// <summary>
    /// Override this procedure to add your custom slots.
    /// </summary>
    procedure AddAllSlots;
    /// <summary>
    /// Override this procedure to add your custom methods.
    /// </summary>
    procedure AddAllMethods;
    /// <summary>
    /// Override this procedure to add your custom members.
    /// </summary>
    procedure AddAllMembers;
    /// <summary>
    /// Override this procedure to add your custom getsets.
    /// </summary>
    procedure AddAllGetSets;

    /// <summary>
    /// Create the slots with the methods and all the heap type information.
    /// </summary>
    procedure Initialize;

    /// <summary>
    /// Name of the new data type.
    /// </summary>
    property  Name_                  : AnsiString         read GetName                 write SetName;
    /// <summary>
    /// The docstring of the new data type.
    /// </summary>
    property  DocStrings             : AnsiString         read GetDocStrings           write SetDocStrings;
    /// <summary>
    /// Return True if the last slot has a Py_slot_end value in the
    /// sl_id field.
    /// </summary>
    property  HasSentinelSlot        : boolean            read GetHasSentinelSlot;
    /// <summary>
    /// Return True if the last method in the list is a sentinel method.
    /// </summary>
    property  HasSentinelMethod      : boolean            read GetHasSentinelMethod;
    /// <summary>
    /// Return True if the last method in the list is a sentinel member.
    /// </summary>
    property  HasSentinelMember      : boolean            read GetHasSentinelMember;
    /// <summary>
    /// Return True if the last method in the list is a sentinel getsetter.
    /// </summary>
    property  HasSentinelGetSet      : boolean            read GetHasSentinelGetSet;
    /// <summary>
    /// Return a pointer to the first slot.
    /// </summary>
    property  Slots                  : PPySlot            read GetSlots;
    /// <summary>
    /// The associated token is a pointer-sized value intended to identify
    /// this object.
    /// </summary>
    property  Token                  : pointer            read GetToken                write SetToken;
    /// <summary>
    /// <para>Metaclass is used to construct the resulting type object.</para>
    /// <para>When metaclass is nil, the metaclass is derived from bases
    /// (or Py_tp_base[s] slots if bases is nil, see below).</para>
    /// <para>Metaclasses that override tp_new are not supported, except if
    /// tp_new is nil.</para>
    /// </summary>
    property  Metaclass              : PPyTypeObject       read GetMetaclass           write SetMetaclass;
    /// <summary>
    /// <para>Module can be used to record the module in which the new class
    /// is defined. It must be a module object or nil. If not nil, the module
    /// is associated with the new type and can later be retrieved with
    /// TPyType.GetModule(). The associated module is not inherited by
    /// subclasses; it must be specified for each class individually.</para>
    /// </summary>
    property  Module                 : IPyObject           read GetModule              write SetModule;
    /// <summary>
    /// <para>Bases can be used to specify base classes; it can either be only
    /// one class or a tuple of classes. If bases is nil, the Py_tp_bases slot
    /// is used instead. If that also is nil, the Py_tp_base slot is used
    /// instead. If that also is nil, the new type derives from object.</para>
    /// </summary>
    property  Bases                  : IPyObject           read GetBases               write SetBases;
    /// <summary>
    /// <para>The size of the instance in bytes. It is used to set
    /// PyTypeObject.tp_basicsize.</para>
    /// <para>The value must be positive.</para>
    /// <para>This may not be used in PyType_Spec.slots. Use
    /// PyType_Spec.basicsize instead.</para>
    /// <para>This slot may not be used with TPyType.GetSlot(). Use
    /// PyTypeObject.tp_basicsize instead if needed, but be aware that a
    /// type's size is often considered an implementation detail.</para>
    /// <para>Added in version 3.15.</para>
    /// </summary>
    property  Basicsize              : Py_ssize_t          read GetBasicsize           write SetBasicsize;
    /// <summary>
    /// <para>Type data size in bytes, that is, how much space instances of
    /// the class need in addition to space needed for superclasses.</para>
    /// <para>The value is used, together with the size of superclasses, to
    /// set PyTypeObject.tp_basicsize. Python will insert padding as needed
    /// to meet tp_basicsize's alignment requirements.</para>
    /// <para>Use TPyObject.GetTypeData() to get a pointer to
    /// subclass-specific memory reserved this way.</para>
    /// <para>The value must be positive. To specify that instances need no
    /// additional size (that is, size should be inherited), omit the
    /// Py_tp_extra_basicsize slot rather than set it to zero.</para>
    /// <para>Specifying both Py_tp_basicsize and Py_tp_extra_basicsize is
    /// an error.</para>
    /// <para>This may not be used in PyType_Spec.slots. Use negative
    /// PyType_Spec.basicsize instead.</para>
    /// <para>This slot may not be used with TPyType.GetSlot().</para>
    /// <para>Added in version 3.15.</para>
    /// </summary>
    property  ExtraBasicsize         : Py_ssize_t          read GetExtraBasicsize      write SetExtraBasicsize;
    /// <summary>
    /// <para>The size of one element of a variable-size type, in bytes.
    /// Used to set PyTypeObject.tp_itemsize. See tp_itemsize documentation
    /// for caveats.</para>
    /// <para>The value must be positive.</para>
    /// <para>If this slot is missing, tp_itemsize is inherited. Extending
    /// arbitrary variable-sized classes is dangerous, since some types use
    /// a fixed offset for variable-sized memory, which can then overlap
    /// fixed-sized memory used by a subclass. To help prevent mistakes,
    /// inheriting itemsize is only possible in the following
    /// situations:</para>
    /// <code>
    /// - The base is not variable-sized (its tp_itemsize is zero).
    /// - The requested PyType_Spec.basicsize is positive, suggesting that
    ///   the memory layout of the base class is known.
    /// - The requested PyType_Spec.basicsize is zero, suggesting that the
    ///   subclass does not access the instance's memory directly.
    /// </code>
    /// <para>With the Py_TPFLAGS_ITEMS_AT_END flag.</para>
    /// <para>This may not be used in PyType_Spec.slots. Use
    /// PyType_Spec.itemsize instead.</para>
    /// <para>This slot may not be used with TPyType.GetSlot().</para>
    /// <para>Added in version 3.15.</para>
    /// </summary>
    property  Itemsize               : Py_ssize_t          read GetItemsize            write SetItemsize;
    /// <summary>
    /// <para>Type flags, used to set PyTypeObject.tp_flags.</para>
    /// <para>The Py_TPFLAGS_HEAPTYPE flag is not set,
    /// TPyType.FromSpecWithBases() sets it automatically.</para>
    /// <para>This may not be used in PyType_Spec.slots. Use negative
    /// PyType_Spec.basicsize instead.</para>
    /// <para>This slot may not be used with TPyType.GetSlot().
    /// Use TPyType.GetFlags() instead.</para>
    /// <para>Added in version 3.15.</para>
    /// </summary>
    property  Flags                  : NativeUInt          read GetFlags               write SetFlags;
  end;

  /// <summary>
  /// Interface defining a type's behavior.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/type.html#c.PyType_Spec">See the article about PyType_Spec.</see></para>
  /// </remarks>
  IPyType_Spec = interface
    ['{F55ADD9F-9ABD-4DF2-BD4A-1FDE6235826A}']
    function  GetName: AnsiString;
    function  GetDocStrings: AnsiString;
    function  GetBasicsize: integer;
    function  GetItemsize: integer;
    function  GetFlags: cardinal;
    function  GetHasSentinelSlot: boolean;
    function  GetHasSentinelMethod: boolean;
    function  GetHasSentinelMember: boolean;
    function  GetHasSentinelGetSet: boolean;
    function  GetSlots: PPyType_Slot;
    function  GetTypeSpec: PPyType_Spec;
    function  GetToken: pointer;

    procedure SetName(const aValue: AnsiString);
    procedure SetDocStrings(const aValue: AnsiString);
    procedure SetBasicsize(aValue: integer);
    procedure SetItemsize(aValue: integer);
    procedure SetFlags(aValue: cardinal);
    procedure SetToken(aValue: pointer);

    procedure CreateSlotArray;
    procedure CreateMethodArray;
    procedure CreateMemberArray;
    procedure CreateGetSetArray;

    procedure DestroySlotList;
    procedure DestroySlots;
    procedure DestroyMethodList;
    procedure DestroyMethods;
    procedure DestroyMemberList;
    procedure DestroyMembers;
    procedure DestroyGetSetList;
    procedure DestroyGetSets;

    /// <summary>
    /// Add a generic slot.
    /// </summary>
    function  AddSlot(aSlot: integer; aPfunc: Pointer): boolean;
    /// <summary>
    /// Add a method.
    /// </summary>
    function  AddMethod(const aName, aDocStrings: string; const aMethod: PyCFunction; aFlags: integer): boolean;
    /// <summary>
    /// Add a member.
    /// </summary>
    function  AddMember(const aName, aDocStrings: string; aType, aFlags: integer; aOffset: Py_ssize_t): boolean;
    /// <summary>
    /// Add a getset.
    /// </summary>
    function  AddGetSet(const aName, aDocStrings: string; const aGet: getter; const aSet: setter; aClosure: pointer): boolean;

    /// <summary>
    /// Add a sentinel method slot.
    /// </summary>
    function  AddSentinelMethod: boolean;
    /// <summary>
    /// Add a sentinel member slot.
    /// </summary>
    function  AddSentinelMember: boolean;
    /// <summary>
    /// Add a sentinel getset slot.
    /// </summary>
    function  AddSentinelGetSet: boolean;
    /// <summary>
    /// Add a sentinel slot.
    /// </summary>
    function  AddSentinelSlot: boolean;

    /// <summary>
    /// Add a Py_tp_alloc slot.
    /// </summary>
    procedure AddAllocSlot(const aFunc: allocfunc);
    /// <summary>
    /// Add a Py_tp_call slot.
    /// </summary>
    procedure AddCallSlot(const aFunc: ternaryfunc);
    /// <summary>
    /// Add a Py_tp_clear slot.
    /// </summary>
    procedure AddClearSlot(const aFunc: inquiry);
    /// <summary>
    /// Add a Py_tp_dealloc slot.
    /// </summary>
    procedure AddDeallocSlot(const aFunc: destructor_);
    /// <summary>
    /// Add a Py_tp_del slot.
    /// </summary>
    procedure AddDelSlot(const aFunc: destructor_);
    /// <summary>
    /// Add a Py_tp_descr_get slot.
    /// </summary>
    procedure AddDescrGetSlot(const aFunc: descrgetfunc);
    /// <summary>
    /// Add a Py_tp_descr_set slot.
    /// </summary>
    procedure AddDescrSetSlot(const aFunc: descrsetfunc);
    /// <summary>
    /// Add a Py_tp_doc slot.
    /// </summary>
    procedure AddDocSlot;
    /// <summary>
    /// Add a Py_tp_finalize slot.
    /// </summary>
    procedure AddFinalizeSlot(const aFunc: destructor_);
    /// <summary>
    /// Add a Py_tp_free slot.
    /// </summary>
    procedure AddFreeSlot(const aFunc: freefunc);
    /// <summary>
    /// Add a Py_tp_getattr slot.
    /// </summary>
    procedure AddGetAttrSlot(const aFunc: getattrfunc);
    /// <summary>
    /// Add a Py_tp_getattro slot.
    /// </summary>
    procedure AddGetAttroSlot(const aFunc: getattrofunc);
    /// <summary>
    /// Add a Py_tp_getset slot.
    /// </summary>
    procedure AddGetSetsSlot;
    /// <summary>
    /// Add a Py_tp_hash slot.
    /// </summary>
    procedure AddHashSlot(const aFunc: hashfunc);
    /// <summary>
    /// Add a Py_tp_init slot.
    /// </summary>
    procedure AddInitSlot(const aFunc: initproc);
    /// <summary>
    /// Add a Py_tp_is_gc slot.
    /// </summary>
    procedure AddIsGCSlot(const aFunc: inquiry);
    /// <summary>
    /// Add a Py_tp_iter slot.
    /// </summary>
    procedure AddIterSlot(const aFunc: getiterfunc);
    /// <summary>
    /// Add a Py_tp_iternext slot.
    /// </summary>
    procedure AddIterNextSlot(const aFunc: iternextfunc);
    /// <summary>
    /// Add a Py_tp_members slot.
    /// </summary>
    procedure AddMembersSlot;
    /// <summary>
    /// Add a Py_tp_methods slot.
    /// </summary>
    procedure AddMethodsSlot;
    /// <summary>
    /// Add a Py_tp_new slot.
    /// </summary>
    procedure AddNewSlot(const aFunc: newfunc);
    /// <summary>
    /// Add a Py_tp_repr slot.
    /// </summary>
    procedure AddReprSlot(const aFunc: reprfunc);
    /// <summary>
    /// Add a Py_tp_richcompare slot.
    /// </summary>
    procedure AddRichCompareSlot(const aFunc: richcmpfunc);
    /// <summary>
    /// Add a Py_tp_setattr slot.
    /// </summary>
    procedure AddSetAttrSlot(const aFunc: setattrfunc);
    /// <summary>
    /// Add a Py_tp_setattro slot.
    /// </summary>
    procedure AddSetAttroSlot(const aFunc: setattrofunc);
    /// <summary>
    /// Add a Py_tp_slots slot.
    /// </summary>
    procedure AddSlotsSlot(const aSlots: PPyType_Slot);
    /// <summary>
    /// Add a Py_tp_str slot.
    /// </summary>
    procedure AddStrSlot(const aFunc: reprfunc);
    /// <summary>
    /// Add a Py_slot_subslots slot.
    /// </summary>
    procedure AddSubslotsSlot(const aSlots: PPySlot);
    /// <summary>
    /// Add a Py_tp_token slot.
    /// </summary>
    procedure AddTokenSlot;
    /// <summary>
    /// Add a Py_tp_traverse slot.
    /// </summary>
    procedure AddTraverseSlot(const aFunc: traverseproc);
    /// <summary>
    /// Add a Py_tp_vectorcall slot.
    /// </summary>
    procedure AddVectorcallSlot(const aFunc: vectorcallfunc);

    /// <summary>
    /// Override this procedure to add your custom slots.
    /// </summary>
    procedure AddAllSlots;
    /// <summary>
    /// Override this procedure to add your custom methods.
    /// </summary>
    procedure AddAllMethods;
    /// <summary>
    /// Override this procedure to add your custom members.
    /// </summary>
    procedure AddAllMembers;
    /// <summary>
    /// Override this procedure to add your custom getsets.
    /// </summary>
    procedure AddAllGetSets;
    /// <summary>
    /// Create the methods and the slots with all the heap type information.
    /// </summary>
    procedure Initialize;
    /// <summary>
    /// Name of the type, used to set PyTypeObject.tp_name.
    /// </summary>
    property Name_                   : AnsiString        read GetName              write SetName;
    /// <summary>
    /// <para>The docstring for this type object. This is exposed as the
    /// __doc__ attribute on the type and instances of the type.</para>
    /// </summary>
    property DocStrings              : AnsiString        read GetDocStrings        write SetDocStrings;
    /// <summary>
    /// <para>If positive, specifies the size of the instance in bytes. It is
    /// used to set PyTypeObject.tp_basicsize.</para>
    /// <para>If zero, specifies that tp_basicsize should be inherited.</para>
    /// <para>If negative, the absolute value specifies how much space
    /// instances of the class need in addition to the superclass.</para>
    /// <para>Use TPyObject.GetTypeData to get a pointer to subclass-specific
    /// memory reserved this way.</para>
    /// <para>For negative basicsize, Python will insert padding when needed
    /// to meet tp_basicsize's alignment requirements.</para>
    /// </summary>
    property Basicsize               : integer           read GetBasicsize         write SetBasicsize;
    /// <summary>
    /// Size of one element of a variable-size type, in bytes. Used to set
    /// PyTypeObject.tp_itemsize. See tp_itemsize documentation for caveats.
    /// </summary>
    property Itemsize                : integer           read GetItemsize          write SetItemsize;
    /// <summary>
    /// <para>Type flags, used to set PyTypeObject.tp_flags.</para>
    /// <para>Use the Py_TPFLAGS_* constants.</para>
    /// </summary>
    property Flags                   : cardinal          read GetFlags             write SetFlags;
    /// <summary>
    /// Return True if the last slot has a {0, nil} value.
    /// </summary>
    property HasSentinelSlot         : boolean           read GetHasSentinelSlot;
    /// <summary>
    /// Return True if the last method in the list is a sentinel method.
    /// </summary>
    property HasSentinelMethod       : boolean           read GetHasSentinelMethod;
    /// <summary>
    /// Return True if the last method in the list is a sentinel member.
    /// </summary>
    property HasSentinelMember       : boolean           read GetHasSentinelMember;
    /// <summary>
    /// Return True if the last method in the list is a sentinel getsetter.
    /// </summary>
    property HasSentinelGetSet       : boolean           read GetHasSentinelGetSet;
    /// <summary>
    /// Return a pointer to the first slot.
    /// </summary>
    property Slots                   : PPyType_Slot      read GetSlots;
    /// <summary>
    /// Return a pointer to the PyType_Spec record.
    /// </summary>
    property TypeSpec                : PPyType_Spec      read GetTypeSpec;
    /// <summary>
    /// <para>The associated token records a static memory layout ID for a
    /// class.</para>
    /// <para>Useg the special value Py_TP_USE_SPEC to set the token to the
    /// class's PyType_Spec.</para>
    /// <para>Added in version 3.14.</para>
    /// </summary>
    property  Token                  : pointer           read GetToken             write SetToken;
  end;

  /// <summary>
  /// TPyBuffer wraps a Py_buffer record and it's also a
  /// helper class for all PyBuffer_* methods.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/buffer.html">See the article about the Buffer Protocol.</see></para>
  /// </remarks>
  IPyBuffer = interface
    ['{4A6FD0D1-42C6-4B28-8B1A-F5FC48100A3F}']

    function GetInitialized: boolean;
    function GetBuffer: PPy_buffer;
    /// <summary>
    /// <para>Get the memory area pointed to by the indices inside the
    /// view. indices must point to an array of view->ndim indices.</para>
    /// </summary>
    function GetPointer(const indices: Py_ssize_t_array): Pointer;
    /// <summary>
    /// <para>Copy contiguous len bytes from buf to view. fort can be 'C' or
    /// 'F' (for C-style or Fortran-style ordering). True is returned on
    /// success, False on error.</para>
    /// </summary>
    function FromContiguous(const buf: Pointer; len: Py_ssize_t; fort: TPyBufferOrder): boolean;
    /// <summary>
    /// <para>Return True if the memory defined by the view is C-style
    /// (order is 'C') or Fortran-style (order is 'F') contiguous or
    /// either one (order is 'A'). Return False otherwise. This function
    /// always succeeds.</para>
    /// </summary>
    function IsContiguous(order: TPyBufferOrder): boolean;
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
    function FillInfo(const exporter: IPyObject; buf: Pointer; len: Py_ssize_t; readonly, flags: Integer): boolean;
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

end.
