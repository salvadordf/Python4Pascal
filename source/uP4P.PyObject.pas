unit uP4P.PyObject;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces;

type
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
  /// <para><see href="https://docs.python.org/3/c-api/object.html#object-protocol">See the article about the Object Protocol.</see></para>
  /// </remarks>
  TPyObject = class(TInterfacedObject, IPyObject)
    protected
      FPyObject    : PPyObject;
      FObjRefOwner : boolean;

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

    public
      constructor Create(aPyObject: Pointer; aObjRefOwner, aUseNewRef: boolean); overload;
      destructor  Destroy; override;

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
      /// <para>This procedure is used when the ownership of the current
      /// PyObject reference was transferred to another method and the current
      /// instance is not allowed to keep using the PyObject reference.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/intro.html#reference-count-details">See the article about Reference Count Details.</see></para>
      /// <para><see href="https://docs.python.org/3.15/glossary.html#term-steal">See the definition of "steal".</see></para>
      /// <para><see href="https://docs.python.org/3.15/glossary.html#term-borrowed-reference">See the definition of "borrowed reference".</see></para>
      /// <para><see href="https://docs.python.org/3.15/glossary.html#term-strong-reference">See the definition of "strong reference".</see></para>
      /// </remarks>
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
      /// <para>Call this Python object without any arguments.</para>
      /// <para>It is the most efficient way to call a callable Python object
      /// without any argument.</para>
      /// <para>Return the result of the call on success, or raise an exception
      /// and return nil on failure.</para>
      /// </summary>
      function  CallNoArgs: IPyObject;
      /// <summary>
      /// <para>Call this Python object, with arguments given by
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
      /// <para>Call this object, with arguments given by
      /// the tuple args. If no arguments are needed, then args can be
      /// nil.</para>
      /// <para>Return the result of the call on success, or raise an exception
      /// and return nil on failure.</para>
      /// <para>This is the equivalent of the Python expression:
      /// callable(*args).</para>
      /// </summary>
      function  CallObject(const args: IPyObject): IPyObject;
      /// <summary>
      /// <para>Call this object. The arguments are the
      /// same as for vectorcallfunc. If callable supports vectorcall, this
      /// directly calls the vectorcall function stored in callable.</para>
      /// <para>Return the result of the call on success, or raise an exception
      /// and return nil on failure.</para>
      /// </summary>
      function  Vectorcall(const args: IPyObjectArray; const kwnames: IPyObject): IPyObject;
      /// <summary>
      /// <para>Call this object with positional arguments passed exactly as in
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
      /// <para>Call this object callable with exactly 1
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
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/intro.html#reference-count-details">See the article about Reference Count Details.</see></para>
      /// <para><see href="https://docs.python.org/3.15/glossary.html#term-steal">See the definition of "steal".</see></para>
      /// <para><see href="https://docs.python.org/3.15/glossary.html#term-borrowed-reference">See the definition of "borrowed reference".</see></para>
      /// <para><see href="https://docs.python.org/3.15/glossary.html#term-strong-reference">See the definition of "strong reference".</see></para>
      /// </remarks>
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
      /// <para>Helper function used to wrap a PyObject pointer with a
      /// TPyObject instance.</para>
      /// </summary>
      /// <param name="aPyObject">The PyObject pointer.</param>
      /// <param name="aObjRefOwner">Set to True if this TPyObject instance is the owner of the PyObject reference. Set to False if PyObject is a borrowed reference.</param>
      /// <param name="aUseNewRef">Use a new reference of aPyObject in this TPyObject instance.</param>
      class function  Wrap(aPyObject: Pointer; aObjRefOwner: boolean = True; aUseNewRef: boolean = False): IPyObject; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}
      /// <summary>
      /// <para>Returns true if the class is fully initialized.</para>
      /// </summary>
      class function  IsInitialized(const aPyObject: IPyObject): boolean; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}
      /// <summary>
      /// <para>Allocates n bytes and returns a pointer to the allocated memory,
      /// or nil if the request fails.</para>
      /// <para>Requesting zero bytes returns a distinct non-nil pointer if
      /// possible, as if TPyObject.Malloc(1) had been called instead.
      /// The memory will not have been initialized in any way.</para>
      /// </summary>
      class function  Malloc(size_: NativeUInt): pointer;
      /// <summary>
      /// <para>Allocates nelem elements each of size elsize bytes and returns
      /// a pointer to the allocated memory, or nil if the request fails.
      /// The memory is initialized to zeros.</para>
      /// <para>Requesting zero elements or elements of size zero bytes returns
      /// a distinct non-nil pointer if possible, as if TPyObject.Calloc(1, 1)
      /// had been called instead.</para>
      /// </summary>
      class function  Calloc(nelem, elsize: NativeUInt): pointer;
      /// <summary>
      /// <para>Resizes the memory block pointed to by p to n bytes.
      /// The contents will be unchanged to the minimum of the old and the
      /// new sizes.</para>
      /// <para>If p is nil, the call is equivalent to TPyObject.Malloc(n);
      /// else if n is equal to zero, the memory block is resized but is not
      /// freed, and the returned pointer is non-nil.</para>
      /// <para>Unless p is nil, it must have been returned by a previous
      /// call to TPyObject.Malloc(), TPyObject.Realloc() or
      /// TPyObject.Calloc().</para>
      /// <para>If the request fails, TPyObject.Realloc() returns nil and p
      /// remains a valid pointer to the previous memory area.</para>
      /// </summary>
      class function  Realloc(p: pointer; n: NativeUInt): pointer;
      /// <summary>
      /// <para>Frees the memory block pointed to by p, which must have been
      /// returned by a previous call to TPyObject.Malloc(),
      /// TPyObject.Realloc() or TPyObject.Calloc(). Otherwise, or if
      /// TPyObject.Free(p) has been called before, undefined behavior
      /// occurs.</para>
      /// <para>If p is nil, no operation is performed.</para>
      /// <para>Do not call this directly to free an object's memory; call the
      /// type's tp_free slot instead.</para>
      /// <para>Do not use this for memory allocated by TPyObject.GC_New or
      /// TPyObject.GC_NewVar; use TPyObject.GC_Del() instead.</para>
      /// </summary>
      class procedure Free_(p: pointer);
      /// <summary>
      /// <para>Initialize a newly allocated object op with its type and
      /// initial reference. Returns the initialized object. Other fields of
      /// the object are not initialized. Despite its name, this function is
      /// unrelated to the object's __init__() method (tp_init slot).
      /// Specifically, this function does not call the object's __init__()
      /// method.</para>
      /// <para>In general, consider this function to be a low-level routine.
      /// Use tp_alloc where possible. For implementing tp_alloc for your type,
      /// prefer TPyType.GenericAlloc() or TPyObject.New().</para>
      /// <para>Note This function only initializes the object's memory
      /// corresponding to the initial PyObject structure. It does not zero
      /// the rest.</para>
      /// </summary>
      class function  Init(const ob: IPyObject; typeobj: PPyTypeObject): IPyObject;
      /// <summary>
      /// <para>This does everything TPyObject.Init() does, and also
      /// initializes the length information for a variable-size object.</para>
      /// <para>Note This function only initializes some of the object's
      /// memory. It does not zero the rest.</para>
      /// </summary>
      class function  InitVar(const ob: IPyObject; typeobj: PPyTypeObject; size_: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Allocates a new Python object using the Python type object
      /// typeobj (PPyTypeObject) by calling TPyObject.Malloc() to allocate
      /// memory and initializing it like TPyObject.Init(). The caller will own
      /// the only reference to the object (i.e. its reference count will be
      /// one).</para>
      /// <para>Avoid calling this directly to allocate memory for an object;
      /// call the type's tp_alloc slot instead.</para>
      /// <para>When populating a type's tp_alloc slot,
      /// TPyType.GenericAlloc() is preferred over a custom function that
      /// simply calls this function.</para>
      /// <para>This function does not call tp_alloc, tp_new (__new__()), or
      /// tp_init (__init__()).</para>
      /// <para>This cannot be used for objects with Py_TPFLAGS_HAVE_GC set in
      /// tp_flags; use TPyObject.GC_New instead.</para>
      /// <para>Memory allocated by this macro must be freed with
      /// TPyObject.Free() (usually called via the object's tp_free
      /// slot).</para>
      /// <para>Note The returned memory is not guaranteed to have been
      /// completely zeroed before it was initialized.</para>
      /// <para>Note This macro does not construct a fully initialized object
      /// of the given type; it merely allocates memory and prepares it for
      /// further initialization by tp_init. To construct a fully initialized
      /// object, call typeobj instead.</para>
      /// </summary>
      class function  New(typeobj: PPyTypeObject): Pointer;
      /// <summary>
      /// <para>TPyObject.New2 is the same as TPyObject.New but it wraps the
      /// result as a TPyObject.</para>
      /// </summary>
      class function  New2(typeobj: PPyTypeObject): IPyObject;
      /// <summary>
      /// <para>Like TPyObject.New except:</para>
      /// <code>
      /// - It allocates enough memory for the TYPE structure plus size
      ///   (Py_ssize_t) fields of the size given by the tp_itemsize field of
      ///   typeobj.
      /// - The memory is initialized like TPyObject.InitVar().
      /// </code>
      /// <para>This is useful for implementing objects like tuples, which are
      /// able to determine their size at construction time. Embedding the
      /// array of fields into the same allocation decreases the number of
      /// allocations, improving the memory management efficiency.</para>
      /// <para>Avoid calling this directly to allocate memory for an object;
      /// call the type's tp_alloc slot instead.</para>
      /// <para>When populating a type's tp_alloc slot,
      /// TPyType.GenericAlloc() is preferred over a custom function that
      /// simply calls this macro.</para>
      /// <para>This cannot be used for objects with Py_TPFLAGS_HAVE_GC set in
      /// tp_flags; use PyObject_GC_NewVar instead.</para>
      /// <para>Memory allocated by this function must be freed with
      /// TPyObject.Free() (usually called via the object's tp_free
      /// slot).</para>
      /// <para>Note The returned memory is not guaranteed to have been
      /// completely zeroed before it was initialized.</para>
      /// <para>Note This macro does not construct a fully initialized object
      /// of the given type; it merely allocates memory and prepares it for
      /// further initialization by tp_init. To construct a fully initialized
      /// object, call typeobj instead.</para>
      /// </summary>
      class function  NewVar(typeobj: PPyTypeObject; size_: Py_ssize_t): IPyObject;
      /// <summary>
      /// <para>Call a method using the vectorcall calling convention. The name
      /// of the method is given as a Python string name. The object whose
      /// method is called is args[0], and the args array starting at args[1]
      /// represents the arguments of the call. There must be at least one
      /// positional argument. nargsf is the number of positional arguments
      /// including args[0], plus PY_VECTORCALL_ARGUMENTS_OFFSET if the value
      /// of args[0] may temporarily be changed. Keyword arguments can be
      /// passed just like in TPyObject.Vectorcall().</para>
      /// <para>If the object has the Py_TPFLAGS_METHOD_DESCRIPTOR feature,
      /// this will call the unbound method object with the full args vector
      /// as arguments.</para>
      /// <para>Return the result of the call on success, or raise an
      /// exception and return nil on failure.</para>
      /// </summary>
      class function  VectorcallMethod(const name: IPyObject; const args: IPyObjectArray; const kwnames: IPyObject): IPyObject;
      /// <summary>
      /// <para>Resize an object allocated by TPyObject.NewVar. Returns the
      /// resized object of type PPyVarObject or nil on failure.</para>
      /// <para>varobj must be of type PPyVarObject and must not be tracked by
      /// the collector yet. size_ must be of type Py_ssize_t.</para>
      /// </summary>
      class function  GC_Resize(varobj: PPyVarObject; size_: Py_ssize_t): PPyVarObject;
      /// <summary>
      /// <para>Analogous to PyObject_New but for container objects with the
      /// Py_TPFLAGS_HAVE_GC flag set.</para>
      /// <para>Do not call this directly to allocate memory for an object;
      /// call the type's tp_alloc slot instead.</para>
      /// <para>When populating a type's tp_alloc slot,
      /// TPyType.GenericAlloc() is preferred over a custom function
      /// that simply calls this macro.</para>
      /// <para>Memory allocated by this macro must be freed with
      /// TPyObject.GC_Del() (usually called via the object's tp_free
      /// slot).</para>
      /// </summary>
      class function  GC_New(typeobj: PPyTypeObject): IPyObject;
      /// <summary>
      /// <para>Analogous to PyObject_NewVar but for container objects with the
      /// Py_TPFLAGS_HAVE_GC flag set.</para>
      /// <para>Do not call this directly to allocate memory for an object;
      /// call the type's tp_alloc slot instead.</para>
      /// <para>When populating a type's tp_alloc slot,
      /// TPyType.GenericAlloc() is preferred over a custom function that
      /// simply calls this macro.</para>
      /// <para>Memory allocated by this macro must be freed with
      /// TPyObject.GC_Del() (usually called via the object's tp_free
      /// slot).</para>
      /// </summary>
      class function  GC_NewVar(typeobj: PPyTypeObject; size_: Py_ssize_t): PPyVarObject;
      /// <summary>
      /// <para>Releases memory allocated to an object using TPyObject.GC_New
      /// or TPyObject.GC_NewVar.</para>
      /// <para>Do not call this directly to free an object's memory;
      /// call the type's tp_free slot instead.</para>
      /// <para>Do not use this for memory allocated by TPyObject.New,
      /// TPyObject.NewVar, or related allocation functions; use
      /// TPyObject.Free() instead.</para>
      /// </summary>
      class procedure GC_Del(ptr: pointer);
      /// <summary>
      /// <para>Get the arena allocator.</para>
      /// </summary>
      class procedure GetArenaAllocator(allocator: PPyObjectArenaAllocator);
      /// <summary>
      /// <para>Set the arena allocator.</para>
      /// </summary>
      class procedure SetArenaAllocator(allocator: PPyObjectArenaAllocator);
      /// <summary>
      /// <para>Wrap a Variant with the corresponding PyObject type.</para>
      /// </summary>
      /// <param name="aVariant">The Variant variable that will be wrapped in a TPyObject type.</param>
      /// <param name="aUseDateTuple">When True, use a TPyTuple to wrap the Variant. If False, use a TPyDateTime to wrap the Variant.</param>
      /// <param name="aUseBytesString">When True, use a TPyBytes to wrap the Variant. If False, use a TPyUnicode to wrap the Variant.</param>
      class function  FromVariant(const aVariant: Variant; aUseDateTuple: boolean = False; aUseBytesString: boolean = False): IPyObject;
      /// <summary>
      /// <para>Wrap a TVarRec with the corresponding PyObject type.</para>
      /// </summary>
      class function  FromVarRec(const aVarRec: TVarRec): IPyObject;
      /// <summary>
      /// <para>Wrap a TVarData with a TPyObject.</para>
      /// </summary>
      class function  FromVarData(const aVarData: TVarData): IPyObject;

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

implementation

uses
  uP4P.MiscFunctions, uP4P.PyType, uP4P.Py, uP4P.PyUnicode, uP4P.PyBytes,
  uP4P.PyLong, uP4P.PyFloat, uP4P.PyBool, uP4P.PyTimeStruct, uP4P.PyDateTimeModule,
  uP4P.PySequence, uP4P.PyList, uP4P.PyTuple, uP4P.PyNone,
  uP4P.PyObjectVariantType, uP4P.PyCallable, uP4P.PyMapping;

constructor TPyObject.Create(aPyObject: Pointer; aObjRefOwner, aUseNewRef: boolean);
begin
  inherited Create;

  if aUseNewRef and assigned(aPyObject) then
    begin
      FPyObject    := TPy.NewRef(aPyObject);
      FObjRefOwner := assigned(FPyObject);
    end
   else
    begin
      FPyObject    := aPyObject;
      FObjRefOwner := aObjRefOwner;
    end;
end;

destructor TPyObject.Destroy;
begin
  try
    if FObjRefOwner then
      DecRef;
  finally
    inherited Destroy;
  end;
end;

class function TPyObject.Wrap(aPyObject: Pointer; aObjRefOwner, aUseNewRef: boolean): IPyObject;
begin
  if assigned(aPyObject) then
    Result := TPyObject.Create(aPyObject, aObjRefOwner, aUseNewRef)
   else
    Result := nil;
end;

class function TPyObject.IsInitialized(const aPyObject: IPyObject): boolean;
begin
  Result := (aPyObject <> nil) and aPyObject.Initialized;
end;

class function TPyObject.Malloc(size_: NativeUInt): pointer;
begin
  if assigned(PyObject_Malloc) then
    Result := PyObject_Malloc(size_)
   else
    Result := nil;
end;

class function TPyObject.Calloc(nelem, elsize: NativeUInt): pointer;
begin
  if assigned(PyObject_Calloc) then
    Result := PyObject_Calloc(nelem, elsize)
   else
    Result := nil;
end;

class function TPyObject.Realloc(p: pointer; n: NativeUInt): pointer;
begin
  if assigned(PyObject_Realloc) then
    Result := PyObject_Realloc(p, n)
   else
    Result := nil;
end;

class procedure TPyObject.Free_(p: pointer);
begin
  if assigned(PyObject_Free) then
    PyObject_Free(p);
end;

class function TPyObject.Init(const ob: IPyObject; typeobj: PPyTypeObject): IPyObject;
begin
  if assigned(PyObject_Init) and
     TPyObject.IsInitialized(ob) and
     assigned(typeobj) then
    Result := TPyObject.Wrap(PyObject_Init(ob.PyObject, typeobj), False)
   else
    Result := nil;
end;

class function TPyObject.InitVar(const ob: IPyObject; typeobj: PPyTypeObject; size_: Py_ssize_t): IPyObject;
begin
  if assigned(PyObject_InitVar) and
     TPyObject.IsInitialized(ob) and
     assigned(typeobj) then
    Result := TPyObject.Wrap(PyObject_InitVar(PPyVarObject(ob.PyObject), typeobj, size_), False)
   else
    Result := nil;
end;

class function TPyObject.New(typeobj: PPyTypeObject): Pointer;
begin
  if assigned(PyObject_New) and
     assigned(typeobj) then
    Result := PyObject_New(typeobj)
   else
    Result := nil;
end;

class function TPyObject.New2(typeobj: PPyTypeObject): IPyObject;
begin
  Result := TPyObject.Wrap(TPyObject.New(typeobj));
end;

class function TPyObject.NewVar(typeobj: PPyTypeObject; size_: Py_ssize_t): IPyObject;
begin
  if assigned(PyObject_NewVar) and
     assigned(typeobj) then
    Result := TPyObject.Wrap(PyObject_NewVar(typeobj, size_))
   else
    Result := nil;
end;

function TPyObject.CallNoArgs: IPyObject;
begin
  if Initialized and
     assigned(PyObject_CallNoArgs) then
    Result := TPyObject.Wrap(PyObject_CallNoArgs(PyObject))
   else
    Result := nil;
end;

function TPyObject.Call(const args, kwargs: IPyObject): IPyObject;
begin
  if Initialized and
     assigned(PyObject_Call) and
     TPyObject.IsInitialized(args) then
    begin
      if TPyObject.IsInitialized(kwargs) then
        Result := TPyObject.Wrap(PyObject_Call(PyObject, args.PyObject, kwargs.PyObject))
       else
        Result := TPyObject.Wrap(PyObject_Call(PyObject, args.PyObject, nil));
    end
   else
    Result := nil;
end;

function TPyObject.CallObject(const args: IPyObject): IPyObject;
begin
  if Initialized and
     assigned(PyObject_CallObject) then
    begin
      if TPyObject.IsInitialized(args) then
        Result := TPyObject.Wrap(PyObject_CallObject(PyObject, args.PyObject))
       else
        Result := TPyObject.Wrap(PyObject_CallObject(PyObject, nil));
    end
   else
    Result := nil;
end;

function TPyObject.Vectorcall(const args: IPyObjectArray; const kwnames: IPyObject): IPyObject;
var
  TempArgs : PPyObjectArray;
  TempArgsPtr : PPPyObject;
  TempArgsLen, i : integer;
  TempKwnames : PPyObject;
begin
  Result   := nil;
  TempArgs := nil;

  if Initialized and
     assigned(PyObject_Vectorcall) then
    begin
      TempArgsLen := System.length(args);
      if (TempArgsLen > 0) then
        begin
          SetLength(TempArgs, TempArgsLen);

          for i := 0 to pred(TempArgsLen) do
            TempArgs[i] := args[i].PyObject;

          TempArgsPtr := @TempArgs[0];
        end
       else
        TempArgsPtr := nil;

      if TPyObject.IsInitialized(kwnames) then
        TempKwnames := kwnames.PyObject
       else
        TempKwnames := nil;

      Result := TPyObject.Wrap(PyObject_Vectorcall(PyObject, TempArgsPtr, TempArgsLen, TempKwnames));
    end;
end;

class function TPyObject.VectorcallMethod(const name: IPyObject; const args: IPyObjectArray; const kwnames: IPyObject): IPyObject;
var
  TempArgs : PPyObjectArray;
  TempArgsPtr : PPPyObject;
  TempArgsLen, i : integer;
  TempKwnames : PPyObject;
begin
  Result   := nil;
  TempArgs := nil;

  if assigned(PyObject_VectorcallMethod) and
     TPyObject.IsInitialized(name) then
    begin
      TempArgsLen := System.length(args);
      if (TempArgsLen > 0) then
        begin
          SetLength(TempArgs, TempArgsLen);

          for i := 0 to pred(TempArgsLen) do
            TempArgs[i] := args[i].PyObject;

          TempArgsPtr := @TempArgs[0];
        end
       else
        TempArgsPtr := nil;

      if TPyObject.IsInitialized(kwnames) then
        TempKwnames := kwnames.PyObject
       else
        TempKwnames := nil;

      Result := TPyObject.Wrap(PyObject_VectorcallMethod(name.PyObject, TempArgsPtr, TempArgsLen, TempKwnames));
    end;
end;

function TPyObject.UnWrap: Pointer;
begin
  Result       := PyObject;
  FObjRefOwner := False;
end;

procedure TPyObject.Dump;
begin
  if Initialized and assigned(PyObject_Dump) then
    PyObject_Dump(PyObject);
end;

function TPyObject.GetItemData_DuringGC: Pointer;
begin
  if Initialized and assigned(PyObject_GetItemData_DuringGC) then
    Result := PyObject_GetItemData_DuringGC(PyObject)
   else
    Result := nil;
end;

function TPyObject.IsType(aPyTypeObject: PPyTypeObject): boolean;
begin
  Result := TPy.IsType(self, aPyTypeObject);
end;

function TPyObject.TypeCheck(aPyTypeObject: PPyTypeObject): boolean;
begin
  Result := IsType(aPyTypeObject) or
            TPyType.IsSubtype(GetPyTypeObject, aPyTypeObject);
end;

procedure TPyObject.InitPyObject;
begin
  PyObject     := nil;
  FObjRefOwner := False;
end;

function TPyObject.IsInstance(const cls: IPyObject): integer;
begin
  if Initialized and
     assigned(PyObject_IsInstance) and
     TPyObject.IsInitialized(cls) then
    Result := PyObject_IsInstance(PyObject, cls.PyObject)
   else
    Result := -1;
end;

function TPyObject.IsSubclass(const cls: IPyObject): integer;
begin
  if Initialized and
     assigned(PyObject_IsSubclass) and
     TPyObject.IsInitialized(cls) then
    Result := PyObject_IsSubclass(PyObject, cls.PyObject)
   else
    Result := -1;
end;

function TPyObject.GenericGetDict(context: Pointer): IPyObject;
begin
  if initialized and
     assigned(PyObject_GenericGetDict) then
    Result := Wrap(PyObject_GenericGetDict(PyObject, context))
   else
    Result := nil;
end;

function TPyObject.CheckBuffer: boolean;
begin
  Result := Initialized and
            assigned(PyObject_CheckBuffer) and
            (PyObject_CheckBuffer(PyObject) <> 0);
end;

function TPyObject.GetBuffer(view: PPy_buffer; flags: Integer): boolean;
begin
  Result := Initialized and
            assigned(PyObject_GetBuffer) and
            (PyObject_GetBuffer(PyObject, view, flags) = 0);
end;

function TPyObject.CopyData(const src: IPyObject): boolean;
begin
  Result := Initialized and
            IsInitialized(src) and
            assigned(PyObject_CopyData) and
            (PyObject_CopyData(PyObject, src.PyObject) = 0);
end;

function TPyObject.Repr: IPyObject;
begin
  if initialized and
     assigned(PyObject_Repr) then
    Result := Wrap(PyObject_Repr(PyObject))
   else
    Result := nil;
end;

function TPyObject.Str: IPyObject;
begin
  if initialized and
     assigned(PyObject_Str) then
    Result := Wrap(PyObject_Str(PyObject))
   else
    Result := nil;
end;

function TPyObject.ASCII: IPyObject;
begin
  if initialized and
     assigned(PyObject_ASCII) then
    Result := Wrap(PyObject_ASCII(PyObject))
   else
    Result := nil;
end;

function TPyObject.Bytes: IPyObject;
begin
  if initialized and
     assigned(PyObject_Bytes) then
    Result := Wrap(PyObject_Bytes(PyObject))
   else
    Result := nil;
end;

function TPyObject.RichCompare(const obj: IPyObject; opid: integer): IPyObject;
begin
  if Initialized and
     assigned(PyObject_RichCompare) and
     IsInitialized(obj) and
     (opid in [Py_LT..Py_GE]) then
    Result := Wrap(PyObject_RichCompare(PyObject, obj.PyObject, opid))
   else
    Result := nil;
end;

function TPyObject.RichCompareBool(const obj: IPyObject; opid: integer): integer;
begin
  if Initialized and
     assigned(PyObject_RichCompareBool) and
     IsInitialized(obj) and
     (opid in [Py_LT..Py_GE]) then
    Result := PyObject_RichCompareBool(PyObject, obj.PyObject, opid)
   else
    Result := -1;
end;

function TPyObject.GetAttrString(const attr_name: string): IPyObject;
begin
  Result := Wrap(GetAttrString2(attr_name));
end;

function TPyObject.GetAttrString2(const attr_name: string): Pointer;
var
  TempName : AnsiString;
begin
  if Initialized and assigned(PyObject_GetAttrString) then
    begin
      TempName := StringToPyUTF8(attr_name);
      Result   := PyObject_GetAttrString(PyObject, PAnsiChar(TempName))
    end
   else
    Result := nil;
end;

function TPyObject.SetAttrString(const attr_name: string; const value: IPyObject): boolean;
begin
  if IsInitialized(value) then
    Result := SetAttrString2(attr_name, value.PyObject)
   else
    Result := SetAttrString2(attr_name, nil);
end;

function TPyObject.SetAttrString2(const attr_name: string; value: Pointer): boolean;
var
  TempName : AnsiString;
begin
  if Initialized and
     assigned(PyObject_SetAttrString) then
    begin
      TempName := StringToPyUTF8(attr_name);
      Result   := (PyObject_SetAttrString(PyObject, PAnsiChar(TempName), value) = 0)
    end
   else
    Result := False;
end;

function TPyObject.DelAttrString(const attr_name: string): boolean;
var
  TempName : AnsiString;
begin
  if Initialized and assigned(PyObject_DelAttrString) then
    begin
      TempName := StringToPyUTF8(attr_name);
      Result   := (PyObject_DelAttrString(PyObject, PAnsiChar(TempName)) = 0)
    end
   else
    Result := False;
end;

function TPyObject.HasAttrString(const attr_name: string): boolean;
var
  TempName : AnsiString;
begin
  if Initialized and assigned(PyObject_HasAttrString) then
    begin
      TempName := StringToPyUTF8(attr_name);
      Result   := (PyObject_HasAttrString(PyObject, PAnsiChar(TempName)) <> 0)
    end
   else
    Result := False;
end;

function TPyObject.GetAttr(const attr_name: IPyObject): IPyObject;
begin
  Result := Wrap(GetAttr2(attr_name));
end;

function TPyObject.GetAttr2(const attr_name: IPyObject): Pointer;
begin
  if Initialized and
     assigned(PyObject_GetAttr) and
     IsInitialized(attr_name) then
    Result := PyObject_GetAttr(PyObject, attr_name.PyObject)
   else
    Result := nil;
end;

function TPyObject.GetOptionalAttr(const attr_name: IPyObject; out result_: IPyObject): boolean;
var
  TempPointer : Pointer;
begin
  Result  := False;
  result_ := nil;

  if GetOptionalAttr2(attr_name, TempPointer) then
    begin
      result_ := Wrap(TempPointer);
      Result  := True;
    end;
end;

function TPyObject.GetOptionalAttr2(const attr_name: IPyObject; out result_: Pointer): boolean;
var
  TempObj : PPyObject;
begin
  Result  := False;
  result_ := nil;

  if assigned(PyObject_GetOptionalAttr) then
    begin
      if Initialized and
         IsInitialized(attr_name) then
        begin
          Result  := (PyObject_GetOptionalAttr(PyObject, attr_name.PyObject, @TempObj) <> 0);
          result_ := TempObj;
        end;
    end
   else
    if HasAttr(attr_name) then
      begin
        Result  := True;
        result_ := GetAttr2(attr_name);
      end;
end;

function TPyObject.GetOptionalAttrString(const attr_name: string; out result_: IPyObject): boolean;
var
  TempPointer : Pointer;
begin
  Result  := False;
  result_ := nil;

  if GetOptionalAttrString2(attr_name, TempPointer) then
    begin
      Result  := True;
      result_ := Wrap(TempPointer);
    end;
end;

function TPyObject.GetOptionalAttrString2(const attr_name: string; out result_: Pointer): boolean;
var
  TempObj  : PPyObject;
  TempName : AnsiString;
begin
  Result  := False;
  result_ := nil;

  if assigned(PyObject_GetOptionalAttrString) then
    begin
      if Initialized then
        begin
          TempName := StringToPyUTF8(attr_name);
          Result   := (PyObject_GetOptionalAttrString(PyObject, PAnsiChar(TempName), @TempObj) <> 0);
          result_  := TempObj;
        end;
    end
   else
    if HasAttrString(attr_name) then
      begin
        result_ := GetAttrString2(attr_name);
        Result  := True;
      end;
end;

function TPyObject.GetAttrAsInteger(const attr_name: string; out result_: integer): boolean;
var
  TempObj : IPyObject;
begin
  if GetOptionalAttrString(attr_name, TempObj) then
    begin
      result_ := TempObj.AsInteger;
      Result  := True;
    end
   else
    begin
      result_ := 0;
      Result  := False;
    end;
end;

function TPyObject.GetAttrAsString(const attr_name: string; out result_: string): boolean;
var
  TempObj : IPyObject;
begin
  if GetOptionalAttrString(attr_name, TempObj) then
    begin
      result_ := TempObj.AsString;
      Result  := True;
    end
   else
    begin
      result_ := '';
      Result  := False;
    end;
end;

function TPyObject.SetAttr(const attr_name, value: IPyObject): boolean;
begin
  if IsInitialized(value) then
    Result := SetAttr2(attr_name, value.PyObject)
   else
    Result := SetAttr2(attr_name, nil);
end;

function TPyObject.SetAttr2(const attr_name: IPyObject; value: Pointer): boolean;
begin
  Result := Initialized and
            assigned(PyObject_SetAttr) and
            IsInitialized(attr_name) and
            (PyObject_SetAttr(PyObject, attr_name.PyObject, value) = 0);
end;

function TPyObject.DelAttr(const attr_name: IPyObject): boolean;
begin
  if Initialized and
     assigned(PyObject_DelAttr) and
     IsInitialized(attr_name) then
    Result := (PyObject_DelAttr(PyObject, attr_name.PyObject) = 0)
   else
    Result := False;
end;

function TPyObject.HasAttr(const attr_name: IPyObject): boolean;
begin
  if Initialized and
     assigned(PyObject_HasAttr) and
     IsInitialized(attr_name) then
    Result := (PyObject_HasAttr(PyObject, attr_name.PyObject) <> 0)
   else
    Result := False;
end;

function TPyObject.HasAttrWithError(const attr_name: IPyObject): integer;
begin
  if Initialized and
     assigned(PyObject_HasAttrWithError) and
     IsInitialized(attr_name) then
    Result := PyObject_HasAttrWithError(PyObject, attr_name.PyObject)
   else
    Result := -1;
end;

function TPyObject.HasAttrStringWithError(const attr_name: string): integer;
var
  TempName : AnsiString;
begin
  if Initialized and assigned(PyObject_HasAttrStringWithError) then
    begin
      TempName := StringToPyUTF8(attr_name);
      Result   := PyObject_HasAttrStringWithError(PyObject, PAnsiChar(TempName))
    end
   else
    Result := -1;
end;

function TPyObject.SelfIter: IPyObject;
begin
  if Initialized and
     assigned(PyObject_SelfIter) then
    Result := Wrap(PyObject_SelfIter(PyObject))
   else
    Result := nil;
end;

function TPyObject.GenericGetAttr(const name_: IPyObject): IPyObject;
begin
  Result := Wrap(GenericGetAttr2(name_));
end;

function TPyObject.GenericGetAttr2(const name_: IPyObject): Pointer;
begin
  if Initialized and
     assigned(PyObject_GenericGetAttr) and
     IsInitialized(name_) then
    Result := PyObject_GenericGetAttr(PyObject, name_.PyObject)
   else
    Result := nil;
end;

function TPyObject.GenericSetAttr(const name_, value: IPyObject): boolean;
begin
  Result := assigned(value) and
            GenericSetAttr2(name_, value.PyObject);
end;

function TPyObject.GenericSetAttr2(const name_: IPyObject; value: Pointer): boolean;
begin
  if Initialized and
     assigned(PyObject_GenericSetAttr) and
     IsInitialized(name_) and
     assigned(value) then
    Result := (PyObject_GenericSetAttr(PyObject, name_.PyObject, value) = 0)
   else
    Result := False;
end;

function TPyObject.GenericSetDict(const value: IPyObject; context: Pointer): boolean;
begin
  if Initialized and
     assigned(PyObject_GenericSetDict) and
     IsInitialized(value) then
    Result := (PyObject_GenericSetDict(PyObject, value.PyObject, context) = 0)
   else
    Result := False;
end;

function TPyObject.Hash: Py_hash_t;
begin
  if Initialized and assigned(PyObject_Hash) then
    Result := PyObject_Hash(PyObject)
   else
    Result := -1;
end;

function TPyObject.HashNotImplemented: Py_hash_t;
begin
  if Initialized and assigned(PyObject_HashNotImplemented) then
    Result := PyObject_HashNotImplemented(PyObject)
   else
    Result := -1;
end;

function TPyObject.IsTrue: integer;
begin
  if Initialized and assigned(PyObject_IsTrue) then
    Result := PyObject_IsTrue(PyObject)
   else
    Result := -1;
end;

function TPyObject.Not_: integer;
begin
  if Initialized and assigned(PyObject_Not) then
    Result := PyObject_Not(PyObject)
   else
    Result := -1;
end;

procedure TPyObject.ClearWeakRefs;
begin
  if Initialized and assigned(PyObject_ClearWeakRefs) then
    PyObject_ClearWeakRefs(PyObject);
end;

function TPyObject.Dir: IPyObject;
begin
  if assigned(PyObject_Dir) then
    begin
      if Initialized then
        Result := Wrap(PyObject_Dir(PyObject))
       else
        Result := Wrap(PyObject_Dir(nil));
    end
   else
    Result := nil;
end;

function TPyObject.ReprEnter: integer;
begin
  Result := TPy.ReprEnter(self);
end;

procedure TPyObject.ReprLeave;
begin
  TPy.ReprLeave(self);
end;

function TPyObject.Print(file_: PFILE; flags: integer): boolean;
begin
  Result := Initialized and
            assigned(PyObject_Print) and
            assigned(file_) and
            (PyObject_Print(PyObject, file_, flags) = 0);
end;

procedure TPyObject.CallFinalizer;
begin
  if Initialized and assigned(PyObject_CallFinalizer) then
    PyObject_CallFinalizer(PyObject);
end;

function TPyObject.CallFinalizerFromDealloc: boolean;
begin
  Result := Initialized and
            assigned(PyObject_CallFinalizerFromDealloc) and
            (PyObject_CallFinalizerFromDealloc(PyObject) = 0);
end;

function TPyObject.GetItemData: Pointer;
begin
  if Initialized and assigned(PyObject_GetItemData) then
    Result := PyObject_GetItemData(PyObject)
   else
    Result := nil;
end;

function TPyObject.VisitManagedDict(visit: visitproc; arg: Pointer): integer;
begin
  if Initialized and assigned(PyObject_VisitManagedDict) then
    Result := PyObject_VisitManagedDict(PyObject, visit, arg)
   else
    Result := 0;
end;

procedure TPyObject.ClearManagedDict;
begin
  if Initialized and assigned(PyObject_ClearManagedDict) then
    PyObject_ClearManagedDict(PyObject);
end;

procedure TPyObject.GC_Track;
begin
  if Initialized and assigned(PyObject_GC_Track) then
    PyObject_GC_Track(PyObject);
end;

procedure TPyObject.GC_UnTrack;
begin
  if Initialized and assigned(PyObject_GC_UnTrack) then
    PyObject_GC_UnTrack(PyObject);
end;

function TPyObject.GC_IsTracked: boolean;
begin
  Result := Initialized and
            assigned(PyObject_GC_IsTracked) and
            (PyObject_GC_IsTracked(PyObject) <> 0);
end;

function TPyObject.GC_IsFinalized: boolean;
begin
  Result := Initialized and
            assigned(PyObject_GC_IsFinalized) and
            (PyObject_GC_IsFinalized(PyObject) <> 0);
end;

function TPyObject.IS_GC: boolean;
begin
  Result := Initialized and
            assigned(PyObject_IS_GC) and
            (PyObject_IS_GC(PyObject) <> 0);
end;

function TPyObject.GenericHash: Py_hash_t;
begin
  if Initialized and assigned(PyObject_GenericHash) then
    Result := PyObject_GenericHash(PyObject)
   else
    Result := -1;
end;

function TPyObject.AsFileDescriptor: integer;
begin
  if Initialized and assigned(PyObject_AsFileDescriptor) then
    Result := PyObject_AsFileDescriptor(PyObject)
   else
    Result := -1;
end;

function TPyObject.Type_: IPyObject;
begin
  if Initialized and assigned(PyObject_Type) then
    Result := TPyObject.Wrap(PyObject_Type(FPyObject))
   else
    Result := nil;
end;

function TPyObject.Size: Py_ssize_t;
begin
  if Initialized and assigned(PyObject_Size) then
    Result := PyObject_Size(FPyObject)
   else
    Result := -1;
end;

function TPyObject.Length: Py_ssize_t;
begin
  if Initialized and assigned(PyObject_Length) then
    Result := PyObject_Length(FPyObject)
   else
    Result := -1;
end;

function TPyObject.GetItem(const key: IPyObject): IPyObject;
begin
  if Initialized and
     assigned(PyObject_GetItem) and
     TPyObject.IsInitialized(key) then
    Result := TPyObject.Wrap(PyObject_GetItem(FPyObject, key.PyObject))
   else
    Result := nil;
end;

function TPyObject.GetItem(const key: TVarData): IPyObject;
var
  TempKey : IPyObject;
begin
  try
    TempKey := FromVarData(key);
    Result  := GetItem(TempKey);
  finally
    TempKey := nil;
  end;
end;

function TPyObject.SetItem(const key, v: IPyObject): boolean;
begin
  Result := Initialized and
            assigned(PyObject_SetItem) and
            TPyObject.IsInitialized(key) and
            TPyObject.IsInitialized(v) and
            (PyObject_SetItem(FPyObject, key.PyObject, v.PyObject) = 0);
end;

function TPyObject.SetItem(const key, v: TVarData): boolean;
var
  TempKey, TempValue : IPyObject;
begin
  try
    TempKey   := FromVarData(key);
    TempValue := FromVarData(v);
    Result    := SetItem(TempKey, TempValue);
  finally
    TempKey   := nil;
    TempValue := nil;
  end;
end;

function TPyObject.DelItemString(const key: string): boolean;
var
  TempKey : AnsiString;
begin
  if Initialized and
     assigned(PyObject_DelItemString) then
    begin
      TempKey := StringToPyUTF8(key);
      Result  := (PyObject_DelItemString(FPyObject, PAnsiChar(TempKey)) <> -1);
    end
   else
    Result := False;
end;

function TPyObject.DelItem(const key: IPyObject): boolean;
begin
  Result := Initialized and
            assigned(PyObject_DelItem) and
            TPyObject.IsInitialized(key) and
            (PyObject_DelItem(FPyObject, key.PyObject) <> -1);
end;

function TPyObject.DelItem(const key: TVarData): boolean;
var
  TempKey : IPyObject;
begin
  try
    TempKey := FromVarData(key);
    Result  := DelItem(TempKey);
  finally
    TempKey := nil;
  end;
end;

function TPyObject.Format(const format_spec: IPyObject): IPyObject;
begin
  Result := nil;

  if Initialized and
     assigned(PyObject_Format) then
    begin
      if TPyObject.IsInitialized(format_spec) then
        Result := TPyObject.Wrap(PyObject_Format(FPyObject, format_spec.PyObject))
       else
        Result := TPyObject.Wrap(PyObject_Format(FPyObject, nil));
    end;
end;

function TPyObject.GetIter: IPyObject;
begin
  if Initialized and
     assigned(PyObject_GetIter) then
    Result := TPyObject.Wrap(PyObject_GetIter(FPyObject))
   else
    Result := nil;
end;

function TPyObject.GetAIter: IPyObject;
begin
  if Initialized and
     assigned(PyObject_GetAIter) then
    Result := TPyObject.Wrap(PyObject_GetAIter(FPyObject))
   else
    Result := nil;
end;

function TPyObject.LengthHint(defaultvalue: Py_ssize_t): Py_ssize_t;
begin
  if Initialized and
     assigned(PyObject_LengthHint) then
    Result := PyObject_LengthHint(FPyObject, defaultvalue)
   else
    Result := -1;
end;

function TPyObject.VectorcallDict(const args: IPyObjectArray; const kwargs: IPyObject): IPyObject;
var
  TempArgs : PPyObjectArray;
  TempArgsPtr : PPPyObject;
  TempArgsLen, i : integer;
  TempKwargsPtr : PPyObject;
begin
  Result   := nil;
  TempArgs := nil;

  if Initialized and
     assigned(PyObject_VectorcallDict) then
    begin
      TempArgsLen := System.length(args);

      if (TempArgsLen > 0) then
        begin
          SetLength(TempArgs, TempArgsLen);

          for i := 0 to pred(TempArgsLen) do
            TempArgs[i] := args[i].PyObject;

          TempArgsPtr := @TempArgs[0];
        end
       else
        TempArgsPtr := nil;

      if TPyObject.IsInitialized(kwargs) then
        TempKwargsPtr := kwargs.PyObject
       else
        TempKwargsPtr := nil;

      Result := TPyObject.Wrap(PyObject_VectorcallDict(PyObject, TempArgsPtr, TempArgsLen, TempKwargsPtr));
    end;
end;

function TPyObject.CallOneArg(const arg: IPyObject): IPyObject;
begin
  if Initialized and
     assigned(PyObject_CallOneArg) and
     TPyObject.IsInitialized(arg) then
    Result := TPyObject.Wrap(PyObject_CallOneArg(PyObject, arg.PyObject))
   else
    Result := nil;
end;

class function TPyObject.GC_Resize(varobj: PPyVarObject; size_: Py_ssize_t): PPyVarObject;
begin
  if assigned(PyObject_GC_Resize) then
    Result := PyObject_GC_Resize(varobj, size_)
   else
    Result := nil;
end;

class function TPyObject.GC_New(typeobj: PPyTypeObject): IPyObject;
begin
  if assigned(PyObject_GC_New) then
    Result := TPyObject.Wrap(PyObject_GC_New(typeobj))
   else
    Result := nil;
end;

class function TPyObject.GC_NewVar(typeobj: PPyTypeObject; size_: Py_ssize_t): PPyVarObject;
begin
  if assigned(PyObject_GC_NewVar) then
    Result := PyObject_GC_NewVar(typeobj, size_)
   else
    Result := nil;
end;

class procedure TPyObject.GC_Del(ptr: pointer);
begin
  if assigned(PyObject_GC_Del) and assigned(ptr) then
    PyObject_GC_Del(ptr);
end;

class procedure TPyObject.GetArenaAllocator(allocator: PPyObjectArenaAllocator);
begin
  if assigned(PyObject_GetArenaAllocator) then
    PyObject_GetArenaAllocator(allocator);
end;

class procedure TPyObject.SetArenaAllocator(allocator: PPyObjectArenaAllocator);
begin
  if assigned(PyObject_SetArenaAllocator) then
    PyObject_SetArenaAllocator(allocator);
end;

class function TPyObject.FromVariant(const aVariant: Variant; aUseDateTuple, aUseBytesString: boolean): IPyObject;
var
  TempType    : TVarType;
  TempVariant : Variant;
begin
  Result      := nil;
  TempVariant := aVariant;
  TempType    := varByRef or varVariant;

  while VarType(TempVariant) = TempType do
    TempVariant := Variant(PVarData(TVarData(TempVariant).VPointer)^);

  TempType := VarType(TempVariant) and (VarTypeMask or VarArray);

  case TempType of
    varBoolean   : Result := TPyBool.FromVariant(TempVariant, TempType);
    varSmallint,
    varByte,
    varShortInt,
    varWord,
    varInteger,
    varLongWord,
    {$IFDEF SUPPORTS_VARUINT64}
    varUInt64,
    {$ENDIF}
    varInt64     : Result := TPyLong.FromVariant(TempVariant, TempType);
    varSingle,
    varDouble,
    varCurrency  : Result := TPyFloat.FromVariant(TempVariant, TempType);
    varArray     : Result := TPyList.FromVariant(TempVariant, TempType);
    varNull,
    varEmpty     : Result := TPyNone.New;
    varOleStr,
    {$IFDEF SUPPORTS_VARUSTRING}
    varUString,
    {$ENDIF}
    varString    :
      if aUseBytesString then
        Result := TPyBytes.FromVariant(TempVariant, TempType)
       else
        Result := TPyUnicode.FromVariant(TempVariant, TempType);

    varDate      :
      if aUseDateTuple then
        Result := TPyTuple.FromVariant(TempVariant, TempType)
       else
        Result := TPyDateTimeModule.FromVariant(TempVariant, TempType);
  end;

  if not(assigned(Result)) then
    Result := TPyNone.New;
end;

class function TPyObject.FromVarRec(const aVarRec : TVarRec): IPyObject;
begin
  case aVarRec.VType of
    vtInteger  : Result := TPyLong.FromLong(aVarRec.VInteger);
    vtBoolean  : Result := TPyLong.FromLong(integer(aVarRec.VBoolean));
    vtChar     : Result := TPyUnicode.FromString(AnsiString(aVarRec.VChar));
    vtExtended : Result := TPyFloat.FromDouble(aVarRec.VExtended^);
    vtPChar    : Result := TPyUnicode.FromString(AnsiString(aVarRec.VPChar));
    vtCurrency : Result := TPyFloat.FromDouble(aVarRec.VCurrency^);
    vtVariant  : Result := FromVariant(aVarRec.VVariant^);
    vtPointer  : Result := Wrap(aVarRec.VPointer);
    vtInt64    : Result := TPyLong.FromLongLong(aVarRec.VInt64^);
    vtWideChar : Result := TPyUnicode.FromString(WideStringToPyUTF8(aVarRec.VWideChar));

    vtString :
      if assigned(aVarRec.VString) then
        Result := TPyUnicode.FromString(AnsiString(aVarRec.VString^))
       else
        Result := TPyUnicode.FromString('');

    vtAnsiString :
      if Assigned(aVarRec.VAnsiString) then
        Result := TPyUnicode.FromString(PAnsiChar(aVarRec.VAnsiString))
       else
        Result := TPyUnicode.FromString('');

    vtPWideChar :
      if Assigned(aVarRec.VPWideChar) then
        Result := TPyUnicode.FromString(WideStringToPyUTF8(WideString(aVarRec.VPWideChar)))
       else
        Result := TPyUnicode.FromString('');

    vtWideString :
      if Assigned(aVarRec.VWideString) then
        Result := TPyUnicode.FromString(WideStringToPyUTF8(WideString(aVarRec.VWideString)))
       else
        Result := TPyUnicode.FromString('');

    {$IFDEF SUPPORTS_VARUSTRING}
    vtUnicodeString :
      if Assigned(aVarRec.VUnicodeString) then
        Result := TPyUnicode.FromString(UnicodeStringToPyUTF8(UnicodeString(aVarRec.VUnicodeString)))
       else
        Result := TPyUnicode.FromString('');
    {$ENDIF}

    else Result := nil;
  end;
end;

class function TPyObject.FromVarData(const aVarData: TVarData): IPyObject;
var
  TempVarDataPtr : PVarData;
begin
  Result := nil;

  if (AVarData.VType = PyObjectVariantType.VarType) then
    begin
      TPyObjectVarData(AVarData).VPyObject.IncRef;
      Result := TPyObject.Wrap(TPyObjectVarData(AVarData).VPyObject.PyObject);
    end
   else
    if ((AVarData.VType and varByRef) <> 0) and
       ((AVarData.VType and varTypeMask) = varVariant) then
      begin
        TempVarDataPtr := AVarData.VPointer;

        if (TempVarDataPtr^.VType = PyObjectVariantType.VarType) then
        begin
          TPyObjectVarData(TempVarDataPtr^).VPyObject.IncRef;
          Result := TPyObject.Wrap(TPyObjectVarData(TempVarDataPtr^).VPyObject.PyObject);
        end;
      end;

  if not(assigned(Result)) then
    Result := TPyObject.FromVariant(Variant(AVarData));
end;

function TPyObject.GetInitialized: boolean;
begin
  Result := assigned(FPyObject);
end;

function TPyObject.GetPyObject: PPyObject;
begin
  Result := FPyObject;
end;

function TPyObject.GetRefCnt: Py_ssize_t;
begin
  Result := TPy.RefCnt(self);
end;

function TPyObject.GetObjRefOwner: boolean;
begin
  Result := FObjRefOwner;
end;

function TPyObject.IsTrueSingleton: boolean;
begin
  Result := TPy.IsTrue(self);
end;

function TPyObject.IsFalseSingleton: boolean;
begin
  Result := TPy.IsFalse(self);
end;

function TPyObject.IsNoneSingleton: boolean;
begin
  Result := TPy.IsNone(self);
end;

function TPyObject.GetPyTypeObject: PPyTypeObject;
begin
  Result := TPy.Type_(self);
end;

function TPyObject.GetTypeData(const cls: PyTypeObject): Pointer;
begin
  if Initialized and assigned(PyObject_GetTypeData) then
    Result := PyObject_GetTypeData(PyObject, @cls)
   else
    Result := nil;
end;

function TPyObject.GetTypeData_DuringGC(const cls: PyTypeObject): Pointer;
begin
  if Initialized and assigned(PyObject_GetTypeData_DuringGC) then
    Result := PyObject_GetTypeData_DuringGC(PyObject, @cls)
   else
    Result := nil;
end;

function TPyObject.GetAsString: string;
var
  TempStr : IPyObject;
begin
  if TPyUnicode.Check(self) then
    Result := PyUTF8ToString(TPyUnicode.AsUTF8(self))
   else
    if TPyBytes.Check(self) then
      Result := TPyBytes.AsString(self)
     else
      begin
        TempStr := self.Str;

        if TPyUnicode.Check(TempStr) then
          Result := PyUTF8ToString(TPyUnicode.AsUTF8(TempStr))
         else
          Result := '';
      end;
end;

function TPyObject.GetAsAnsiString: AnsiString;
var
  TempStr : IPyObject;
begin
  if TPyUnicode.Check(self) then
    Result := TPyUnicode.AsUTF8(self)
   else
    if TPyBytes.Check(self) then
      Result := TPyBytes.AsAnsiString(self)
     else
      begin
        TempStr := self.Str;

        if TPyUnicode.Check(TempStr) then
          Result := TPyUnicode.AsUTF8(TempStr)
         else
          Result := '';
      end;
end;

function TPyObject.GetAsWideString: WideString;
var
  TempStr  : IPyObject;
  TempSize : Py_ssize_t;
begin
  TempSize := 0;

  if TPyUnicode.Check(self) then
    Result := WideString(TPyUnicode.AsWideCharString(self, TempSize))
   else
    if TPyBytes.Check(self) then
      Result := TPyBytes.AsWideString(self)
     else
      begin
        TempStr := self.Str;

        if TPyUnicode.Check(TempStr) then
          Result := WideString(TPyUnicode.AsWideCharString(TempStr, TempSize))
         else
          Result := '';
      end;
end;

function TPyObject.GetAsInteger: C_Long;
begin
  if TPyLong.Check(self) then
    Result := TPyLong.AsLong(self)
   else
    Result := -1;
end;

function TPyObject.GetAsCardinal: C_ULong;
begin
  if TPyLong.Check(self) then
    Result := TPyLong.AsUnsignedLong(self)
   else
    Result := C_ULong(-1);
end;

function TPyObject.GetAsInt64: int64;
begin
  if TPyLong.Check(self) then
    Result := TPyLong.AsLongLong(self)
   else
    Result := -1;
end;

function TPyObject.GetAsUInt64: uint64;
begin
  if TPyLong.Check(self) then
    Result := TPyLong.AsUnsignedLongLong(self)
   else
    Result := uint64(-1);
end;

function TPyObject.GetAsDouble: double;
begin
  if TPyFloat.Check(self) then
    Result := TPyFloat.AsDouble(self)
   else
    Result := -1;
end;

function TPyObject.GetAsDateTime: TDateTime;
var
  TempDateTime : TDateTime;
begin
  TempDateTime := 0;

  if TPyTimeStruct.AsDateTime(self, TempDateTime) or
     TPyDateTimeModule.AsDateTime(self, TempDateTime) then
    Result := TempDateTime
   else
    Result := -1;
end;

function TPyObject.GetAsVariant: Variant;
begin
  PyObjectVariantType.PyObjectVariantCreate(Result, self);
end;

function TPyObject.CastValueAsVariant: Variant;
var
  TempDateTime : TDateTime;
begin
  TempDateTime := 0;

  if IsFloat then
    Result := TPyFloat.AsDouble(self)
   else
    if IsBool then
      Result := IsTrue
     else
      if IsLong then
        Result := TPyLong.AsLong(self)
       else
        if IsUnicode then
          Result := PyUTF8ToString(TPyUnicode.AsUTF8(self))
         else
          if IsBytes then
            Result := TPyBytes.AsString(self)
           else
            if TPyTimeStruct.AsDateTime(self, TempDateTime) then
              Result := TempDateTime
             else
              if TPyDateTimeModule.AsDateTime(self, TempDateTime) then
                Result := TempDateTime
               else
                Result := TPySequence.CastValueAsVariant(self);
end;

function TPyObject.GetIsCallable: boolean;
begin
  Result := TPyCallable.Check(self);
end;

function TPyObject.GetIsTuple: boolean;
begin
  Result := TPyTuple.Check(self);
end;

function TPyObject.GetIsList: boolean;
begin
  Result := TPyList.Check(self);
end;

function TPyObject.GetIsSequence: boolean;
begin
  Result := TPySequence.Check(self);
end;

function TPyObject.GetIsMapping: boolean;
begin
  Result := TPyMapping.Check(self);
end;

function TPyObject.GetIsFloat: boolean;
begin
  Result := TPyFloat.Check(self);
end;

function TPyObject.GetIsLong: boolean;
begin
  Result := TPyLong.Check(self);
end;

function TPyObject.GetIsBool: boolean;
begin
  Result := TPyBool.Check(self);
end;

function TPyObject.GetIsUnicode: boolean;
begin
  Result := TPyUnicode.Check(self);
end;

function TPyObject.GetIsBytes: boolean;
begin
  Result := TPyBytes.Check(self);
end;

procedure TPyObject.SetObjRefOwner(aValue: boolean);
begin
  FObjRefOwner := aValue;
end;

procedure TPyObject.SetRefCnt(aValue: Py_ssize_t);
begin
  TPy.Set_RefCnt(self, aValue);
end;

procedure TPyObject.SetPyObject(aValue: PPyObject);
begin
  FPyObject := aValue;
end;

procedure TPyObject.IncRef;
begin
  TPy.IncRef(self);
end;

procedure TPyObject.DecRef;
begin
  TPy.DecRef(self);
end;

function TPyObject.NewRef: Pointer;
begin
  Result := TPy.NewRef(IPyObject(self));
end;

function TPyObject.SameAs(const other: IPyObject): boolean;
begin
  Result := TPy.Is_(self, other);
end;

function TPyObject.SameAs(const other: PPyObject): boolean;
begin
  Result := TPy.Is_(PyObject, other);
end;

end.

