unit uP4P.LibFunctions;

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
  uP4P.Types;

var
  {* include/pyport.h *}
  {* include/exports.h *}
  {* include/pymacro.h *}
  Py_PACK_FULL_VERSION                           : function(major, minor, micro, release_level, release_serial: integer): cardinal; cdecl;
  Py_PACK_VERSION                                : function(major, minor: integer): cardinal; cdecl;

  {* include/pymath.h *}
  {* include/pymem.h  include/cpython/pymem.h *}
  PyMem_Malloc                                   : function(size_: NativeUInt): Pointer; cdecl;
  PyMem_Calloc                                   : function(nelem, elsize: NativeUInt): Pointer; cdecl;
  PyMem_Realloc                                  : function(ptr: Pointer; new_size: NativeUInt): Pointer; cdecl;
  PyMem_Free                                     : procedure(ptr: Pointer); cdecl;
  PyMem_RawMalloc                                : function(size_: NativeUInt): Pointer; cdecl;
  PyMem_RawCalloc                                : function(nelem, elsize: NativeUInt): Pointer; cdecl;
  PyMem_RawRealloc                               : function(ptr: Pointer; new_size: NativeUInt): Pointer; cdecl;
  PyMem_RawFree                                  : procedure(ptr: Pointer); cdecl;
  PyMem_GetAllocator                             : procedure(domain: PyMemAllocatorDomain; out allocator: PyMemAllocatorEx); cdecl;
  PyMem_SetAllocator                             : procedure(domain: PyMemAllocatorDomain; allocator: PPyMemAllocatorEx); cdecl;
  PyMem_SetupDebugHooks                          : procedure(); cdecl;

  {* include/pytypedefs.h *}
  {* include/pybuffer.h *}
  PyObject_CheckBuffer                           : function(obj: PPyObject): Integer; cdecl;
  PyObject_GetBuffer                             : function(exporter: PPyObject; view: PPy_buffer; flags: Integer): Integer; cdecl;
  PyBuffer_GetPointer                            : function(const view: PPy_buffer; const indices: PPy_ssize_t): Pointer; cdecl;
  PyBuffer_SizeFromFormat                        : function(const format: PAnsiChar): Py_ssize_t; cdecl;
  PyBuffer_ToContiguous                          : function(buf: Pointer; const src: PPy_buffer; len: Py_ssize_t; order: AnsiChar): Integer; cdecl;
  PyBuffer_FromContiguous                        : function(const view: PPy_buffer; const buf: Pointer; len: Py_ssize_t; fort: AnsiChar): Integer; cdecl;
  PyObject_CopyData                              : function(dest: PPyObject; src: PPyObject): Integer; cdecl;
  PyBuffer_IsContiguous                          : function(const view: PPy_buffer; order: AnsiChar): Integer; cdecl;
  PyBuffer_FillContiguousStrides                 : procedure(ndims: Integer; shape, strides: PPy_ssize_t; itemsize: Integer; order: AnsiChar); cdecl;
  PyBuffer_FillInfo                              : function(view: PPy_buffer; exporter: PPyObject; buf: Pointer; len: Py_ssize_t; readonly, flags: Integer): Integer; cdecl;
  PyBuffer_Release                               : procedure(view: PPy_buffer); cdecl;

  {* include/pystats.h *}
  {* include/pyatomic.h *}
  {* include/lock.h  include/cpython/lock.h  include/cpython/pylock.h *}
  PyMutex_Lock                                   : procedure(m: PPyMutex); cdecl;
  PyMutex_Unlock                                 : procedure(m: PPyMutex); cdecl;
  PyMutex_IsLocked                               : function(m: PPyMutex): integer; cdecl;

  {* include/critical_section.h  include/cpython/critical_section.h *}
  PyCriticalSection_Begin                        : procedure(c: PPyCriticalSection; op: PPyObject); cdecl;
  PyCriticalSection_BeginMutex                   : procedure(c: PPyCriticalSection; m: PPyMutex); cdecl;
  PyCriticalSection_End                          : procedure(c: PPyCriticalSection); cdecl;
  PyCriticalSection2_Begin                       : procedure(c: PPyCriticalSection2; a, b: PPyObject); cdecl;
  PyCriticalSection2_BeginMutex                  : procedure(c: PPyCriticalSection2; m1, m2: PPyMutex); cdecl;
  PyCriticalSection2_End                         : procedure(c: PPyCriticalSection2); cdecl;

  {* include/object.h  include/cpython/object.h *}
  Py_Is                                          : function(x, y: PPyObject): Integer; cdecl;
  Py_TYPE                                        : function(ob: PPyObject): PPyTypeObject; cdecl;
  Py_SIZE                                        : function(ob: PPyObject): Py_ssize_t; cdecl;                        //****** 3.15.0 ******
  Py_IS_TYPE                                     : function(ob: PPyObject; type_: PPyTypeObject): integer; cdecl;     //****** 3.15.0 ******
  Py_SET_SIZE                                    : procedure(ob: PPyVarObject; size: Py_ssize_t); cdecl;              //****** 3.15.0 ******
  PyLong_Type                                    : PPyTypeObject;
  PyBool_Type                                    : PPyTypeObject;
  PyType_FromSpec                                : function(typespec: PPyType_Spec): PPyObject; cdecl;
  PyType_FromSpecWithBases                       : function(typespec: PPyType_Spec; ob: PPyObject): PPyObject; cdecl;
  PyType_GetSlot                                 : function(type_: PPyTypeObject; i: integer): Pointer; cdecl;
  PyType_FromModuleAndSpec                       : function(module: PPyObject; spec: PPyType_Spec; bases: PPyObject): PPyObject; cdecl;
  PyType_GetModule                               : function(type_: PPyTypeObject): PPyObject; cdecl;
  PyType_GetModuleState                          : function(type_: PPyTypeObject): Pointer; cdecl;
  PyType_GetName                                 : function(type_: PPyTypeObject): PPyObject; cdecl;
  PyType_GetQualName                             : function(type_: PPyTypeObject): PPyObject; cdecl;
  PyType_GetFullyQualifiedName                   : function(type_: PPyTypeObject): PPyObject; cdecl;
  PyType_GetModuleName                           : function(type_: PPyTypeObject): PPyObject; cdecl;
  PyType_FromMetaclass                           : function(metaclass: PPyTypeObject; module: PPyObject; spec: PPyType_Spec; bases: PPyObject): PPyObject; cdecl;
  PyObject_GetTypeData                           : function(obj: PPyObject; cls: PPyTypeObject): Pointer; cdecl;
  PyType_GetTypeDataSize                         : function(cls: PPyTypeObject): Py_ssize_t; cdecl;
  PyType_GetBaseByToken                          : function(type_: PPyTypeObject; token: Pointer; result_: PPPyTypeObject): integer; cdecl;
  PyType_FromSlots                               : function(slots: PPySlot): PPyObject; cdecl;                       //****** 3.15.0 ******
  PyType_IsSubtype                               : function(type1, type2: PPyTypeObject): integer; cdecl;
  PyType_Type                                    : PPyTypeObject;
  PyBaseObject_Type                              : PPyTypeObject;
  PySuper_Type                                   : PPyTypeObject;
  PyType_GetFlags                                : function(type_: PPyTypeObject): C_ULong; cdecl;
  PyType_Ready                                   : function(type_: PPyTypeObject): integer; cdecl;
  PyType_GenericAlloc                            : function(type_: PPyTypeObject; nitems: Py_ssize_t): PPyObject; cdecl;
  PyType_GenericNew                              : function(type_: PPyTypeObject; args, kwds: PPyObject): PPyObject; cdecl;
  PyType_ClearCache                              : function(): cardinal; cdecl;
  PyType_Modified                                : procedure(type_: PPyTypeObject); cdecl;
  PyObject_Repr                                  : function(ob: PPyObject): PPyObject; cdecl;
  PyObject_Str                                   : function(ob: PPyObject): PPyObject; cdecl;
  PyObject_ASCII                                 : function(ob: PPyObject): PPyObject; cdecl;
  PyObject_Bytes                                 : function(ob: PPyObject): PPyObject; cdecl;
  PyObject_RichCompare                           : function(ob1, ob2: PPyObject; opid: integer): PPyObject; cdecl;
  PyObject_RichCompareBool                       : function(ob1, ob2: PPyObject; opid: integer): Integer; cdecl;
  PyObject_GetAttrString                         : function(ob: PPyObject; const attr_name: PAnsiChar): PPyObject; cdecl;
  PyObject_SetAttrString                         : function(ob: PPyObject; attr_name: PAnsiChar; value: PPyObject): integer; cdecl;
  PyObject_DelAttrString                         : function(o: PPyObject; const attr_name: PAnsiChar): integer; cdecl;
  PyObject_HasAttrString                         : function(ob: PPyObject; const attr_name: PAnsiChar): integer; cdecl;
  PyObject_GetAttr                               : function(ob1, ob2: PPyObject): PPyObject; cdecl;
  PyObject_GetOptionalAttr                       : function(ob1, ob2: PPyObject; obarr: PPPyObject): Integer; cdecl;
  PyObject_GetOptionalAttrString                 : function(ob: PPyObject; const c: PAnsiChar; obarr: PPPyObject): Integer; cdecl;
  PyObject_SetAttr                               : function(ob1, ob2, ob3: PPyObject): integer; cdecl;
  PyObject_DelAttr                               : function(v, name_: PPyObject): integer; cdecl;
  PyObject_HasAttr                               : function(ob, attr_name: PPyObject): integer; cdecl;
  PyObject_HasAttrWithError                      : function(ob, attr_name: PPyObject): integer; cdecl;
  PyObject_HasAttrStringWithError                : function(ob: PPyObject; const key: PAnsiChar): integer; cdecl;
  PyObject_SelfIter                              : function(ob: PPyObject): PPyObject; cdecl;
  PyObject_GenericGetAttr                        : function(obj, name_: PPyObject): PPyObject; cdecl;
  PyObject_GenericSetAttr                        : function(obj, name_, value: PPyObject): Integer; cdecl;
  PyObject_GenericSetDict                        : function(obj, value: PPyObject; context: Pointer): Integer; cdecl;
  PyObject_Hash                                  : function(ob: PPyObject): Py_hash_t; cdecl;
  PyObject_HashNotImplemented                    : function(ob: PPyObject): Py_hash_t; cdecl;
  PyObject_IsTrue                                : function(ob: PPyObject): integer; cdecl;
  PyObject_Not                                   : function(ob: PPyObject): integer; cdecl;
  PyCallable_Check                               : function(ob: PPyObject): integer; cdecl;
  PyObject_ClearWeakRefs                         : procedure(ob: PPyObject); cdecl;
  PyObject_Dir                                   : function(ob: PPyObject): PPyObject; cdecl;
  Py_ReprEnter                                   : function(ob: PPyObject): Integer; cdecl;
  Py_ReprLeave                                   : procedure(ob: PPyObject); cdecl;
  Py_GetConstant                                 : function(constant_id: cardinal): PPyObject; cdecl;
  Py_GetConstantBorrowed                         : function(constant_id: cardinal): PPyObject; cdecl;
  Py_None                                        : PPyObject;  // _Py_NoneStruct
  Py_NotImplemented                              : PPyObject;  // _Py_NotImplementedStruct
  Py_IsNone                                      : function(x: PPyObject): Integer; cdecl;
  PyType_GetModuleByDef                          : function(type_: PPyTypeObject; def: PPyModuleDef): PPyObject; cdecl;
  PyType_Freeze                                  : function(type_: PPyTypeObject): integer; cdecl;
  PyType_GetModuleByToken                        : function(type_: PPyTypeObject; const mod_token: Pointer): PPyObject; cdecl;             //****** 3.15.0 ******
  PyObject_GetTypeData_DuringGC                  : function(obj: PPyObject; cls: PPyTypeObject): Pointer; cdecl;                           //****** 3.15.0 ******
  PyType_GetModuleState_DuringGC                 : function(type_: PPyTypeObject): Pointer; cdecl;                                         //****** 3.15.0 ******
  PyType_GetBaseByToken_DuringGC                 : function(type1_: PPyTypeObject; buf: Pointer; type2_: PPPyTypeObject): integer; cdecl;  //****** 3.15.0 ******
  PyType_GetModule_DuringGC                      : function(type_: PPyTypeObject): PPyObject; cdecl;                                       //****** 3.15.0 ******
  PyType_GetModuleByToken_DuringGC               : function(type_: PPyTypeObject; const token: Pointer): PPyObject; cdecl;                 //****** 3.15.0 ******
  PyType_GetDict                                 : function(type_: PPyTypeObject): PPyObject; cdecl;
  PyObject_Print                                 : function(ob: PPyObject; file_: PFILE; i: integer): integer; cdecl;
  PyObject_Dump                                  : procedure(ob: PPyObject); cdecl;                                                        //****** 3.15.0 ******
  PyObject_CallFinalizer                         : procedure(ob: PPyObject); cdecl;
  PyObject_CallFinalizerFromDealloc              : function(ob: PPyObject): integer; cdecl;
  PyObject_GetItemData                           : function(ob: PPyObject): Pointer; cdecl;
  PyObject_GetItemData_DuringGC                  : function(ob: PPyObject): Pointer; cdecl;                                                //****** 3.15.0 ******
  PyObject_VisitManagedDict                      : function(obj: PPyObject; visit: visitproc; arg: Pointer): integer; cdecl;
  PyObject_ClearManagedDict                      : procedure(obj: PPyObject); cdecl;
  PyType_AddWatcher                              : function(callback: PyType_WatchCallback): integer; cdecl;
  PyType_ClearWatcher                            : function(watcher_id: integer): integer; cdecl;
  PyType_Watch                                   : function(watcher_id: integer; type_: PPyObject): integer; cdecl;
  PyType_Unwatch                                 : function(watcher_id: integer; type_: PPyObject): integer; cdecl;
  PyRefTracer_SetTracer                          : function(tracer: PyRefTracer; data: Pointer): integer; cdecl;
  PyRefTracer_GetTracer                          : function(var data: Pointer): PyRefTracer; cdecl;

  {* include/refcount.h *}
  Py_REFCNT                                      : function(ob: PPyObject): Py_ssize_t; cdecl;
  Py_SET_REFCNT                                  : procedure(ob: PPyObject; refcnt: Py_ssize_t);                             // _Py_SetRefcnt
  Py_IncRef                                      : procedure(obj: PPyObject); cdecl;
  Py_DecRef                                      : procedure(obj: PPyObject); cdecl;
  Py_NewRef                                      : function(obj: PPyObject): PPyObject; cdecl;
  Py_XNewRef                                     : function(obj: PPyObject): PPyObject; cdecl;

  {* include/objimpl.h  include/cpython/objimpl.h *}
  PyObject_Malloc                                : function(size_: NativeUInt): pointer; cdecl;
  PyObject_Calloc                                : function(nelem, elsize: NativeUInt): pointer; cdecl;
  PyObject_Realloc                               : function(ptr: pointer; new_size: NativeUInt): pointer; cdecl;
  PyObject_Free                                  : procedure(ptr: pointer); cdecl;
  PyObject_Init                                  : function(ob: PPyObject; type_: PPyTypeObject): PPyObject; cdecl;
  PyObject_InitVar                               : function(ob: PPyVarObject; type_: PPyTypeObject; size_: Py_ssize_t): PPyVarObject; cdecl;
  PyObject_New                                   : function(type_: PPyTypeObject): PPyObject; cdecl;                         // _PyObject_New
  PyObject_NewVar                                : function(type_: PPyTypeObject; size_: Py_ssize_t): PPyVarObject; cdecl;   // _PyObject_NewVar
  PyGC_Collect                                   : function(): Py_ssize_t; cdecl;
  PyGC_Enable                                    : function(): integer; cdecl;
  PyGC_Disable                                   : function(): integer; cdecl;
  PyGC_IsEnabled                                 : function(): integer; cdecl;
  PyObject_GC_Resize                             : function(varobj: PPyVarObject; size_: Py_ssize_t): PPyVarObject; cdecl;   // _PyObject_GC_Resize
  PyObject_GC_New                                : function(type_: PPyTypeObject): PPyObject; cdecl;                         // _PyObject_GC_New
  PyObject_GC_NewVar                             : function(type_: PPyTypeObject; size_: Py_ssize_t): PPyVarObject; cdecl;   // _PyObject_GC_NewVar
  PyObject_GC_Track                              : procedure(ob: PPyObject); cdecl;
  PyObject_GC_UnTrack                            : procedure(ptr: pointer); cdecl;
  PyObject_GC_Del                                : procedure(ptr: pointer); cdecl;
  PyObject_GC_IsTracked                          : function(ob: PPyObject): integer; cdecl;
  PyObject_GC_IsFinalized                        : function(ob: PPyObject): integer; cdecl;
  PyObject_GetArenaAllocator                     : procedure(allocator: PPyObjectArenaAllocator); cdecl;
  PyObject_SetArenaAllocator                     : procedure(allocator: PPyObjectArenaAllocator); cdecl;
  PyObject_IS_GC                                 : function(obj: PPyObject): integer; cdecl;
  PyType_SUPPORTS_WEAKREFS                       : function(type_: PPyTypeObject): integer; cdecl;
  PyObject_GET_WEAKREFS_LISTPTR                  : function(op: PPyObject): PPPyObject; cdecl;

  {* include/typeslots.h  include/slots.h  include/slots_generated.h *}
  {* include/pyhash.h  include/cpython/pyhash.h *}
  PyHash_GetFuncDef                              : function(): PPyHash_FuncDef; cdecl;
  Py_HashPointer                                 : function(const ptr: Pointer): Py_hash_t; cdecl;
  PyObject_GenericHash                           : function(obj: PPyObject): Py_hash_t; cdecl;
  Py_HashBuffer                                  : function(const ptr: Pointer; len: Py_ssize_t): Py_hash_t; cdecl;

  {* include/cpython/pydebug.h *}
  Py_GETENV                                      : function(const name_: PAnsiChar): PAnsiChar; cdecl;

  {* include/bytearrayobject.h *}
  PyByteArray_Type                               : PPyTypeObject;
  PyByteArrayIter_Type                           : PPyTypeObject;
  PyByteArray_FromObject                         : function(ob: PPyObject): PPyObject; cdecl;
  PyByteArray_Concat                             : function(ob1, ob2: PPyObject): PPyObject; cdecl;
  PyByteArray_FromStringAndSize                  : function(const str: PAnsiChar; size_: Py_ssize_t): PPyObject; cdecl;
  PyByteArray_Size                               : function(ob: PPyObject): Py_ssize_t; cdecl;
  PyByteArray_AsString                           : function(ob: PPyObject): PAnsiChar; cdecl;
  PyByteArray_Resize                             : function(ob: PPyObject; size_: Py_ssize_t): integer; cdecl;

  {* include/bytesobject.h  include/cpython/bytesobject.h *}
  PyBytes_Type                                   : PPyTypeObject;
  PyBytesIter_Type                               : PPyTypeObject;
  PyBytes_FromStringAndSize                      : function(const str: PAnsiChar; size_: Py_ssize_t): PPyObject; cdecl;
  PyBytes_FromString                             : function(const str: PAnsiChar): PPyObject; cdecl;
  PyBytes_FromObject                             : function(ob: PPyObject): PPyObject; cdecl;
  //PyBytes_FromFormatV not implemented  // PyAPI_FUNC(PyObject *) PyBytes_FromFormatV(const char*, va_list)
  PyBytes_FromFormat                             : function(const str: PAnsiChar {; ...}): PPyObject; cdecl varargs;
  PyBytes_Size                                   : function(ob: PPyObject): Py_ssize_t; cdecl;
  PyBytes_AsString                               : function(ob: PPyObject): PAnsiChar; cdecl;
  PyBytes_Repr                                   : function(ob: PPyObject; smartquotes: integer): PPyObject; cdecl;
  PyBytes_Concat                                 : procedure(bytes: PPPyObject; ob: PPyObject); cdecl;
  PyBytes_ConcatAndDel                           : procedure(bytes: PPPyObject; ob: PPyObject); cdecl;
  PyBytes_DecodeEscape                           : function(const s: PAnsiChar; len: Py_ssize_t; const errors: PAnsiChar; unicode: Py_ssize_t; const recode_encoding: PAnsiChar): PPyObject; cdecl;
  PyBytes_AsStringAndSize                        : function(obj: PPyObject; var buffer: PAnsiChar; var length: Py_ssize_t): integer; cdecl;
  PyBytes_Join                                   : function(sep, iterable: PPyObject): PPyObject; cdecl;
  PyBytesWriter_Create                           : function(size_: Py_ssize_t): PPyBytesWriter; cdecl;                                         //****** 3.15.0 ******
  PyBytesWriter_Discard                          : procedure(writer: PPyBytesWriter); cdecl;                                                   //****** 3.15.0 ******
  PyBytesWriter_Finish                           : function(writer: PPyBytesWriter): PPyObject; cdecl;                                         //****** 3.15.0 ******
  PyBytesWriter_FinishWithSize                   : function(writer: PPyBytesWriter; size_: Py_ssize_t): PPyObject; cdecl;                      //****** 3.15.0 ******
  PyBytesWriter_FinishWithPointer                : function(writer: PPyBytesWriter; buf: Pointer): PPyObject; cdecl;                           //****** 3.15.0 ******
  PyBytesWriter_GetData                          : function(writer: PPyBytesWriter): Pointer; cdecl;                                           //****** 3.15.0 ******
  PyBytesWriter_GetSize                          : function(writer: PPyBytesWriter): Py_ssize_t; cdecl;                                        //****** 3.15.0 ******
  PyBytesWriter_WriteBytes                       : function(writer: PPyBytesWriter; const bytes_: Pointer; size_: Py_ssize_t): integer; cdecl; //****** 3.15.0 ******
  PyBytesWriter_Format                           : function(writer: PPyBytesWriter; const format: PAnsiChar {; ...}): integer; cdecl varargs;  //****** 3.15.0 ******
  PyBytesWriter_Resize                           : function(writer: PPyBytesWriter; size_: Py_ssize_t): integer; cdecl;                        //****** 3.15.0 ******
  PyBytesWriter_Grow                             : function(writer: PPyBytesWriter; size_: Py_ssize_t): integer; cdecl;                        //****** 3.15.0 ******
  PyBytesWriter_GrowAndUpdatePointer             : function(writer: PPyBytesWriter; size_: Py_ssize_t; buf: Pointer): Pointer; cdecl;          //****** 3.15.0 ******


  {* include/unicodeobject.h  include/cpython/unicodeobject.h *}
  PyUnicode_Type                                 : PPyTypeObject;
  PyUnicodeIter_Type                             : PPyTypeObject;
  PyUnicode_FromStringAndSize                    : function(const u: PAnsiChar; size_: Py_ssize_t): PPyObject; cdecl;
  PyUnicode_FromString                           : function(const u: PAnsiChar): PPyObject; cdecl;
  PyUnicode_Substring                            : function(str: PPyObject; start, end_: Py_ssize_t): PPyObject; cdecl;
  PyUnicode_AsUCS4                               : function(unicode: PPyObject; buffer: PPy_UCS4; buflen: Py_ssize_t; copy_null: integer): PPy_UCS4; cdecl;
  PyUnicode_AsUCS4Copy                           : function(unicode: PPyObject): PPy_UCS4; cdecl;
  PyUnicode_GetLength                            : function(unicode: PPyObject): Py_ssize_t; cdecl;
  PyUnicode_ReadChar                             : function(unicode: PPyObject; index: Py_ssize_t): Py_UCS4; cdecl;
  PyUnicode_WriteChar                            : function(unicode: PPyObject; index: Py_ssize_t; character: Py_UCS4): integer; cdecl;
  PyUnicode_Resize                               : function(unicode: PPPyObject; length: Py_ssize_t): integer; cdecl;
  PyUnicode_FromEncodedObject                    : function(obj: PPyObject; const encodging, errors: PAnsiChar): PPyObject; cdecl;
  PyUnicode_FromObject                           : function(obj: PPyObject): PPyObject; cdecl;
  //PyUnicode_FromFormatV not implemented  // PyAPI_FUNC(PyObject *) PyUnicode_FromFormatV(const char *format, va_list vargs);
  PyUnicode_FromFormat                           : function(const format: PAnsiChar {; ...}): PPyObject; cdecl varargs;
  PyUnicode_InternInPlace                        : procedure(obj: PPPyObject); cdecl;
  PyUnicode_InternFromString                     : function(const str: PAnsiChar): PPyObject; cdecl;
  PyUnicode_FromWideChar                         : function(const w: PWCharT; size_: Py_ssize_t): PPyObject; cdecl;
  PyUnicode_AsWideChar                           : function(unicode: PPyObject; w: PWCharT; size_: Py_ssize_t): Py_ssize_t; cdecl;
  PyUnicode_AsWideCharString                     : function(unicode: PPyObject; size_: PPy_ssize_t): PWCharT; cdecl;
  PyUnicode_FromOrdinal                          : function(ordinal: integer): PPyObject; cdecl;
  PyUnicode_GetDefaultEncoding                   : function(): PAnsiChar; cdecl;
  PyUnicode_Decode                               : function(const s: PAnsiChar; size_: Py_ssize_t; const encodging, errors: PAnsiChar): PPyObject; cdecl;
  PyUnicode_AsEncodedString                      : function(unicode: PPyObject; const encoding, errors: PAnsiChar): PPyObject; cdecl;
  PyUnicode_BuildEncodingMap                     : function(string_: PPyObject): PPyObject; cdecl;
  PyUnicode_DecodeUTF7                           : function(const string_: PAnsiChar; length: Py_ssize_t; const errors: PAnsiChar): PPyObject; cdecl;
  PyUnicode_DecodeUTF7Stateful                   : function(const string_: PAnsiChar; length: Py_ssize_t; const errors: PAnsiChar; consumed: PPy_ssize_t): PPyObject; cdecl;
  PyUnicode_DecodeUTF8                           : function(const string_: PAnsiChar; length: Py_ssize_t; const errors: PAnsiChar): PPyObject; cdecl;
  PyUnicode_DecodeUTF8Stateful                   : function(const string_: PAnsiChar; length: Py_ssize_t; const errors: PAnsiChar; consumed: PPy_ssize_t): PPyObject; cdecl;
  PyUnicode_AsUTF8String                         : function(unicode: PPyObject): PPyObject; cdecl;
  PyUnicode_AsUTF8AndSize                        : function(unicode: PPyObject; size_: PPy_ssize_t): PAnsiChar; cdecl;
  PyUnicode_DecodeUTF32                          : function(const string_: PAnsiChar; length: Py_ssize_t; const errors: PAnsiChar; byteorder: PPyBiteOrder): PPyObject; cdecl;
  PyUnicode_DecodeUTF32Stateful                  : function(const string_: PAnsiChar; length: Py_ssize_t; const errors: PAnsiChar; byteorder: PPyBiteOrder; consumed: PPy_ssize_t): PPyObject; cdecl;
  PyUnicode_AsUTF32String                        : function(unicode: PPyObject): PPyObject; cdecl;
  PyUnicode_DecodeUTF16                          : function(const string_: PAnsiChar; length: Py_ssize_t; const errors: PAnsiChar; byteorder: PPyBiteOrder): PPyObject; cdecl;
  PyUnicode_DecodeUTF16Stateful                  : function(const string_: PAnsiChar; length: Py_ssize_t; const errors: PAnsiChar; byteorder: PPyBiteOrder; consumed: PPy_ssize_t): PPyObject; cdecl;
  PyUnicode_AsUTF16String                        : function(unicode: PPyObject): PPyObject; cdecl;
  PyUnicode_DecodeUnicodeEscape                  : function(const string_: PAnsiChar; length: Py_ssize_t; const errors: PAnsiChar): PPyObject; cdecl;
  PyUnicode_AsUnicodeEscapeString                : function(unicode: PPyObject): PPyObject; cdecl;
  PyUnicode_DecodeRawUnicodeEscape               : function(const string_: PAnsiChar; length: Py_ssize_t; const errors: PAnsiChar): PPyObject; cdecl;
  PyUnicode_AsRawUnicodeEscapeString             : function(unicode: PPyObject): PPyObject; cdecl;
  PyUnicode_DecodeLatin1                         : function(const string_: PAnsiChar; length: Py_ssize_t; const errors: PAnsiChar): PPyObject; cdecl;
  PyUnicode_AsLatin1String                       : function(unicode: PPyObject): PPyObject; cdecl;
  PyUnicode_DecodeASCII                          : function(const string_: PAnsiChar; length: Py_ssize_t; const errors: PAnsiChar): PPyObject; cdecl;
  PyUnicode_AsASCIIString                        : function(unicode: PPyObject): PPyObject; cdecl;
  PyUnicode_DecodeCharmap                        : function(const string_: PAnsiChar; length: Py_ssize_t; mapping: PPyObject; const errors: PAnsiChar): PPyObject; cdecl;
  PyUnicode_AsCharmapString                      : function(unicode, mapping: PPyObject): PPyObject; cdecl;
  {$IFDEF MSWINDOWS}
  PyUnicode_DecodeMBCS                           : function(const string_: PAnsiChar; length: Py_ssize_t; const errors: PAnsiChar): PPyObject; cdecl;
  PyUnicode_DecodeMBCSStateful                   : function(const string_: PAnsiChar; length: Py_ssize_t; const errors: PAnsiChar; consumed: PPy_ssize_t): PPyObject; cdecl;
  PyUnicode_DecodeCodePageStateful               : function(codepage: integer; const string_: PAnsiChar; length: Py_ssize_t; const errors: PAnsiChar; consumed: PPy_ssize_t): PPyObject; cdecl;
  PyUnicode_AsMBCSString                         : function(unicode: PPyObject): PPyObject; cdecl;
  PyUnicode_EncodeCodePage                       : function(codepage: integer; unicode: PPyObject; const errors: PAnsiChar): PPyObject; cdecl;
  {$ENDIF}
  PyUnicode_DecodeLocaleAndSize                  : function(const str: PAnsiChar; len: Py_ssize_t; const errors: PAnsiChar): PPyObject; cdecl;
  PyUnicode_DecodeLocale                         : function(const str: PAnsiChar; const errors: PAnsiChar): PPyObject; cdecl;
  PyUnicode_EncodeLocale                         : function(unicode: PPyObject; const errors: PAnsiChar): PPyObject; cdecl;
  PyUnicode_FSConverter                          : function(obj: PPyObject; result_: Pointer): integer; cdecl;
  PyUnicode_FSDecoder                            : function(obj: PPyObject; result_: Pointer): integer; cdecl;
  PyUnicode_DecodeFSDefault                      : function(const s: PAnsiChar): PPyObject; cdecl;
  PyUnicode_DecodeFSDefaultAndSize               : function(const s: PAnsiChar; size_: Py_ssize_t): PPyObject; cdecl;
  PyUnicode_EncodeFSDefault                      : function(unicode: PPyObject): PPyObject; cdecl;
  PyUnicode_Concat                               : function(left, right: PPyObject): PPyObject; cdecl;
  PyUnicode_Append                               : procedure(pleft: PPPyObject; right: PPyObject); cdecl;
  PyUnicode_AppendAndDel                         : procedure(pleft: PPPyObject; right: PPyObject); cdecl;
  PyUnicode_Split                                : function(s, sep: PPyObject; maxsplit: Py_ssize_t): PPyObject; cdecl;
  PyUnicode_Splitlines                           : function(s: PPyObject; keepends: integer): PPyObject; cdecl;
  PyUnicode_Partition                            : function(s, sep: PPyObject): PPyObject; cdecl;
  PyUnicode_RPartition                           : function(s, sep: PPyObject): PPyObject; cdecl;
  PyUnicode_RSplit                               : function(s, sep: PPyObject; maxsplit: Py_ssize_t): PPyObject; cdecl;
  PyUnicode_Translate                            : function(str, table: PPyObject; const errors: PAnsiChar): PPyObject; cdecl;
  PyUnicode_Join                                 : function(separator, sep: PPyObject): PPyObject; cdecl;
  PyUnicode_Tailmatch                            : function(unicode, substr: PPyObject; start, end_: Py_ssize_t; direction: integer): Py_ssize_t; cdecl;
  PyUnicode_Find                                 : function(unicode, substr: PPyObject; start, end_: Py_ssize_t; direction: integer): Py_ssize_t; cdecl;
  PyUnicode_FindChar                             : function(unicode: PPyObject; ch: Py_UCS4; start, end_: Py_ssize_t; direction: integer): Py_ssize_t; cdecl;
  PyUnicode_Count                                : function(unicode, substr: PPyObject; start, end_: Py_ssize_t): Py_ssize_t; cdecl;
  PyUnicode_Replace                              : function(str, substr, replstr: PPyObject; maxcount: Py_ssize_t): PPyObject; cdecl;
  PyUnicode_Compare                              : function(left, right: PPyObject): integer; cdecl;
  PyUnicode_CompareWithASCIIString               : function(left: PPyObject; const right: PAnsiChar): integer; cdecl;
  PyUnicode_EqualToUTF8                          : function(unicode: PPyObject; const string_: PAnsiChar): integer; cdecl;
  PyUnicode_EqualToUTF8AndSize                   : function(unicode: PPyObject; const string_: PAnsiChar; size_: Py_ssize_t): integer; cdecl;
  PyUnicode_Equal                                : function(a, b: PPyObject): integer; cdecl;
  PyUnicode_RichCompare                          : function(left, right: PPyObject; op: integer): PPyObject; cdecl;
  PyUnicode_Format                               : function(format, args: PPyObject): PPyObject; cdecl;
  PyUnicode_Contains                             : function(unicode, substr: PPyObject): integer; cdecl;
  PyUnicode_IsIdentifier                         : function(unicode: PPyObject): integer; cdecl;
  PyUnicode_KIND                                 : function(unicode: PPyObject): PyUnicode_Kind_Result; cdecl;
  PyUnicode_DATA                                 : function(unicode: PPyObject): Pointer; cdecl;
  PyUnicode_New                                  : function(size_: Py_ssize_t; maxchar: Py_UCS4): PPyObject; cdecl;
  PyUnicode_CopyCharacters                       : function(to_: PPyObject; to_start: Py_ssize_t; from: PPyObject; from_start, how_many: Py_ssize_t): Py_ssize_t; cdecl;
  PyUnicode_Fill                                 : function(unicode: PPyObject; start, length: Py_ssize_t; fill_char: Py_UCS4): Py_ssize_t; cdecl;
  PyUnicode_FromKindAndData                      : function(kind: integer; buffer: Pointer; size_: Py_ssize_t): PPyObject; cdecl;
  PyUnicodeWriter_Create                         : function(length: Py_ssize_t): PPyUnicodeWriter; cdecl;
  PyUnicodeWriter_Discard                        : procedure(writer: PPyUnicodeWriter); cdecl;
  PyUnicodeWriter_Finish                         : function(writer: PPyUnicodeWriter): PPyObject; cdecl;
  PyUnicodeWriter_WriteChar                      : function(writer: PPyUnicodeWriter; ch: Py_UCS4): integer; cdecl;
  PyUnicodeWriter_WriteUTF8                      : function(writer: PPyUnicodeWriter; const str: PAnsiChar; size_: Py_ssize_t): integer; cdecl;
  PyUnicodeWriter_WriteASCII                     : function(writer: PPyUnicodeWriter; const str: PAnsiChar; size_: Py_ssize_t): integer; cdecl;
  PyUnicodeWriter_WriteWideChar                  : function(writer: PPyUnicodeWriter; const str: PWCharT; size_: Py_ssize_t): integer; cdecl;
  PyUnicodeWriter_WriteUCS4                      : function(writer: PPyUnicodeWriter; const str: PPy_UCS4; size_: Py_ssize_t): integer; cdecl;
  PyUnicodeWriter_WriteStr                       : function(writer: PPyUnicodeWriter; obj: PPyObject): integer; cdecl;
  PyUnicodeWriter_WriteRepr                      : function(writer: PPyUnicodeWriter; obj: PPyObject): integer; cdecl;
  PyUnicodeWriter_WriteSubstring                 : function(writer: PPyUnicodeWriter; str: PPyObject; start, end_: Py_ssize_t): integer; cdecl;
  PyUnicodeWriter_Format                         : function(writer: PPyUnicodeWriter; const format: PAnsiChar{; ...}): integer; cdecl varargs;
  PyUnicodeWriter_DecodeUTF8Stateful             : function(writer: PPyUnicodeWriter; const string_: PAnsiChar; length: Py_ssize_t; const errors: PAnsiChar; consumed: PPy_ssize_t): integer; cdecl;
  PyUnicode_AsUTF8                               : function(unicode: PPyObject): PAnsiChar; cdecl;

  {* include/pyerrors.h  include/cpython/pyerrors.h *}
  PyErr_SetNone                                  : procedure(type_: PPyObject); cdecl;
  PyErr_SetObject                                : procedure(type_, value: PPyObject); cdecl;
  PyErr_SetString                                : procedure(type_: PPyObject; const message_: PAnsiChar); cdecl;
  PyErr_Occurred                                 : function(): PPyObject; cdecl;
  PyErr_Clear                                    : procedure(); cdecl;
  PyErr_Fetch                                    : procedure(out ptype, pvalue, ptraceback: PPyObject); cdecl;
  PyErr_Restore                                  : procedure(type_, value, traceback: PPyObject); cdecl;
  PyErr_GetRaisedException                       : function(): PPyObject; cdecl;
  PyErr_SetRaisedException                       : procedure(exc: PPyObject); cdecl;
  PyErr_GetHandledException                      : function(): PPyObject; cdecl;
  PyErr_SetHandledException                      : procedure(exc: PPyObject); cdecl;
  PyErr_GetExcInfo                               : procedure(out ptype, pvalue, ptraceback: PPyObject); cdecl;
  PyErr_SetExcInfo                               : procedure(type_, value, traceback: PPyObject); cdecl;
  Py_FatalError                                  : procedure(const message_: PAnsiChar); cdecl;
  PyErr_GivenExceptionMatches                    : function(given, exc: PPyObject): Integer; cdecl;
  PyErr_ExceptionMatches                         : function(exc: PPyObject): Integer; cdecl;
  PyErr_NormalizeException                       : procedure(out ob1, ob2, ob3: PPyObject); cdecl;
  PyException_SetTraceback                       : function(ex, tb: PPyObject): Integer; cdecl;
  PyException_GetTraceback                       : function(ex: PPyObject): PPyObject; cdecl;
  PyException_GetCause                           : function(ex: PPyObject): PPyObject; cdecl;
  PyException_SetCause                           : procedure(ex, cause: PPyObject); cdecl;
  PyException_GetContext                         : function(ex: PPyObject): PPyObject; cdecl;
  PyException_SetContext                         : procedure(ex, ctx: PPyObject); cdecl;
  PyException_GetArgs                            : function(ex: PPyObject): PPyObject; cdecl;
  PyException_SetArgs                            : procedure(ex, args: PPyObject); cdecl;
  PyExceptionClass_Name                          : function(ob: PPyObject): PAnsiChar; cdecl;
  PyExc_BaseException                            : PPyObject;
  PyExc_Exception                                : PPyObject;
  PyExc_BaseExceptionGroup                       : PPyObject;
  PyExc_StopAsyncIteration                       : PPyObject;
  PyExc_StopIteration                            : PPyObject;
  PyExc_GeneratorExit                            : PPyObject;
  PyExc_ArithmeticError                          : PPyObject;
  PyExc_LookupError                              : PPyObject;
  PyExc_AssertionError                           : PPyObject;
  PyExc_AttributeError                           : PPyObject;
  PyExc_BufferError                              : PPyObject;
  PyExc_EOFError                                 : PPyObject;
  PyExc_FloatingPointError                       : PPyObject;
  PyExc_OSError                                  : PPyObject;
  PyExc_ImportError                              : PPyObject;
  PyExc_ImportCycleError                         : PPyObject;    //****** 3.15.0 ******
  PyExc_ModuleNotFoundError                      : PPyObject;
  PyExc_IndexError                               : PPyObject;
  PyExc_KeyError                                 : PPyObject;
  PyExc_KeyboardInterrupt                        : PPyObject;
  PyExc_MemoryError                              : PPyObject;
  PyExc_NameError                                : PPyObject;
  PyExc_OverflowError                            : PPyObject;
  PyExc_RuntimeError                             : PPyObject;
  PyExc_RecursionError                           : PPyObject;
  PyExc_NotImplementedError                      : PPyObject;
  PyExc_SyntaxError                              : PPyObject;
  PyExc_IndentationError                         : PPyObject;
  PyExc_TabError                                 : PPyObject;
  PyExc_ReferenceError                           : PPyObject;
  PyExc_SystemError                              : PPyObject;
  PyExc_SystemExit                               : PPyObject;
  PyExc_TypeError                                : PPyObject;
  PyExc_UnboundLocalError                        : PPyObject;
  PyExc_UnicodeError                             : PPyObject;
  PyExc_UnicodeEncodeError                       : PPyObject;
  PyExc_UnicodeDecodeError                       : PPyObject;
  PyExc_UnicodeTranslateError                    : PPyObject;
  PyExc_ValueError                               : PPyObject;
  PyExc_ZeroDivisionError                        : PPyObject;
  PyExc_BlockingIOError                          : PPyObject;
  PyExc_BrokenPipeError                          : PPyObject;
  PyExc_ChildProcessError                        : PPyObject;
  PyExc_ConnectionError                          : PPyObject;
  PyExc_ConnectionAbortedError                   : PPyObject;
  PyExc_ConnectionRefusedError                   : PPyObject;
  PyExc_ConnectionResetError                     : PPyObject;
  PyExc_FileExistsError                          : PPyObject;
  PyExc_FileNotFoundError                        : PPyObject;
  PyExc_InterruptedError                         : PPyObject;
  PyExc_IsADirectoryError                        : PPyObject;
  PyExc_NotADirectoryError                       : PPyObject;
  PyExc_PermissionError                          : PPyObject;
  PyExc_ProcessLookupError                       : PPyObject;
  PyExc_TimeoutError                             : PPyObject;
  PyExc_EnvironmentError                         : PPyObject;
  PyExc_IOError                                  : PPyObject;
  {$IFDEF MSWINDOWS}
  PyExc_WindowsError                             : PPyObject;
  {$ENDIF}
  PyExc_Warning                                  : PPyObject;
  PyExc_UserWarning                              : PPyObject;
  PyExc_DeprecationWarning                       : PPyObject;
  PyExc_PendingDeprecationWarning                : PPyObject;
  PyExc_SyntaxWarning                            : PPyObject;
  PyExc_RuntimeWarning                           : PPyObject;
  PyExc_FutureWarning                            : PPyObject;
  PyExc_ImportWarning                            : PPyObject;
  PyExc_UnicodeWarning                           : PPyObject;
  PyExc_BytesWarning                             : PPyObject;
  PyExc_EncodingWarning                          : PPyObject;
  PyExc_ResourceWarning                          : PPyObject;
  PyErr_BadArgument                              : function(): integer; cdecl;
  PyErr_NoMemory                                 : function(): PPyObject; cdecl;
  PyErr_SetFromErrno                             : function(type_: PPyObject): PPyObject; cdecl;
  PyErr_SetFromErrnoWithFilenameObject           : function(type_, filenameObject: PPyObject): PPyObject; cdecl;
  PyErr_SetFromErrnoWithFilenameObjects          : function(type_, filenameObject, filenameObject2: PPyObject): PPyObject; cdecl;
  PyErr_SetFromErrnoWithFilename                 : function(type_: PPyObject; const filename: PAnsiChar): PPyObject; cdecl;
  PyErr_Format                                   : function(exception: PPyObject; const format: PAnsiChar {; ...}): PPyObject; cdecl varargs;
  //PyErr_FormatV not implemented.  // PyAPI_FUNC(PyObject *) PyErr_FormatV(PyObject *exception, const char *format, va_list vargs);
  {$IFDEF MSWINDOWS}
  PyErr_SetFromWindowsErrWithFilename            : function(ierr: integer; const filename: PAnsiChar): PPyObject; cdecl;
  PyErr_SetFromWindowsErr                        : function(ierr: integer): PPyObject; cdecl;
  PyErr_SetExcFromWindowsErrWithFilenameObject   : function(type_: PPyObject; ierr: integer; filename: PPyObject): PPyObject; cdecl;
  PyErr_SetExcFromWindowsErrWithFilenameObjects  : function(type_: PPyObject; ierr: integer; filename, filename2: PPyObject): PPyObject; cdecl;
  PyErr_SetExcFromWindowsErrWithFilename         : function(type_: PPyObject; ierr: integer; const filename: PAnsiChar): PPyObject; cdecl;
  PyErr_SetExcFromWindowsErr                     : function(type_: PPyObject; ierr: integer): PPyObject; cdecl;
  {$ENDIF}
  PyErr_SetImportErrorSubclass                   : function(exception, msg, name_, path: PPyObject): PPyObject; cdecl;
  PyErr_SetImportError                           : function(msg, name_, path: PPyObject): PPyObject; cdecl;
  PyErr_BadInternalCall                          : procedure(); cdecl;
  PyErr_NewException                             : function(const name_: PAnsiChar; base, dict: PPyObject): PPyObject; cdecl;
  PyErr_NewExceptionWithDoc                      : function(const name_, doc: PAnsiChar; base, dict: PPyObject): PPyObject; cdecl;
  PyErr_WriteUnraisable                          : procedure(obj: PPyObject); cdecl;
  PyErr_CheckSignals                             : function(): integer; cdecl;
  PyErr_SetInterrupt                             : procedure(); cdecl;
  PyErr_SetInterruptEx                           : function(signum: integer): integer; cdecl;
  PyErr_SyntaxLocation                           : procedure(const filename: PAnsiChar; lineno: integer); cdecl;
  PyErr_SyntaxLocationEx                         : procedure(const filename: PAnsiChar; lineno, col_offset: integer); cdecl;
  PyErr_ProgramText                              : function(const filename: PAnsiChar; lineno: integer): PPyObject; cdecl;
  PyUnicodeDecodeError_Create                    : function(const encoding, object_: PAnsiChar; length, start, end_: Py_ssize_t; const reason: PAnsiChar): PPyObject; cdecl;
  PyUnicodeEncodeError_GetEncoding               : function(exc: PPyObject): PPyObject; cdecl;
  PyUnicodeDecodeError_GetEncoding               : function(exc: PPyObject): PPyObject; cdecl;
  PyUnicodeEncodeError_GetObject                 : function(exc: PPyObject): PPyObject; cdecl;
  PyUnicodeDecodeError_GetObject                 : function(exc: PPyObject): PPyObject; cdecl;
  PyUnicodeTranslateError_GetObject              : function(exc: PPyObject): PPyObject; cdecl;
  PyUnicodeEncodeError_GetStart                  : function(exc: PPyObject; start: PPy_ssize_t): integer; cdecl;
  PyUnicodeDecodeError_GetStart                  : function(exc: PPyObject; start: PPy_ssize_t): integer; cdecl;
  PyUnicodeTranslateError_GetStart               : function(exc: PPyObject; start: PPy_ssize_t): integer; cdecl;
  PyUnicodeEncodeError_SetStart                  : function(exc: PPyObject; start: Py_ssize_t): integer; cdecl;
  PyUnicodeDecodeError_SetStart                  : function(exc: PPyObject; start: Py_ssize_t): integer; cdecl;
  PyUnicodeTranslateError_SetStart               : function(exc: PPyObject; start: Py_ssize_t): integer; cdecl;
  PyUnicodeEncodeError_GetEnd                    : function(exc: PPyObject; end_: PPy_ssize_t): integer; cdecl;
  PyUnicodeDecodeError_GetEnd                    : function(exc: PPyObject; end_: PPy_ssize_t): integer; cdecl;
  PyUnicodeTranslateError_GetEnd                 : function(exc: PPyObject; end_: PPy_ssize_t): integer; cdecl;
  PyUnicodeEncodeError_SetEnd                    : function(exc: PPyObject; end_: Py_ssize_t): integer; cdecl;
  PyUnicodeDecodeError_SetEnd                    : function(exc: PPyObject; end_: Py_ssize_t): integer; cdecl;
  PyUnicodeTranslateError_SetEnd                 : function(exc: PPyObject; end_: Py_ssize_t): integer; cdecl;
  PyUnicodeEncodeError_GetReason                 : function(exc: PPyObject): PPyObject; cdecl;
  PyUnicodeDecodeError_GetReason                 : function(exc: PPyObject): PPyObject; cdecl;
  PyUnicodeTranslateError_GetReason              : function(exc: PPyObject): PPyObject; cdecl;
  PyUnicodeEncodeError_SetReason                 : function(exc: PPyObject; const reason: PAnsiChar): integer; cdecl;
  PyUnicodeDecodeError_SetReason                 : function(exc: PPyObject; const reason: PAnsiChar): integer; cdecl;
  PyUnicodeTranslateError_SetReason              : function(exc: PPyObject; const reason: PAnsiChar): integer; cdecl;
  PyOS_snprintf                                  : function(str: PAnsiChar; size_: NativeUInt; const format: PAnsiChar {; ...}): integer; cdecl varargs;
  //PyOS_vsnprintf not implemented  // PyAPI_FUNC(int) PyOS_vsnprintf(char *str, size_t size_, const char  *format, va_list va)
  PySignal_SetWakeupFd                           : function(fd: integer): integer; cdecl;
  PyErr_SyntaxLocationObject                     : procedure(filename: PPyObject; lineno, col_offset: integer); cdecl;
  PyErr_RangedSyntaxLocationObject               : procedure(filename: PPyObject; lineno, col_offset, end_lineno, end_col_offset: integer); cdecl;
  PyErr_ProgramTextObject                        : function(filename: PPyObject; lineno: integer): PPyObject; cdecl;
  PyErr_FormatUnraisable                         : procedure(const str: PAnsiChar {; ...}); cdecl varargs;
  PyExc_PythonFinalizationError                  : PPyObject;

  {* include/longobject.h  include/cpython/longobject.h *}
  PyLong_FromLong                                : function(l: C_Long): PPyObject; cdecl;
  PyLong_FromUnsignedLong                        : function(ul: C_ULong): PPyObject; cdecl;
  PyLong_FromSize_t                              : function(st: NativeUInt): PPyObject; cdecl;
  PyLong_FromSsize_t                             : function(st: Py_ssize_t): PPyObject; cdecl;
  PyLong_FromDouble                              : function(db: double): PPyObject; cdecl;
  PyLong_AsLong                                  : function(ob: PPyObject): C_Long; cdecl;
  PyLong_AsLongAndOverflow                       : function(ob: PPyObject; out overflow: Integer): C_Long; cdecl;
  PyLong_AsSsize_t                               : function(ob: PPyObject): Py_ssize_t; cdecl;
  PyLong_AsSize_t                                : function(ob: PPyObject): NativeUInt; cdecl;
  PyLong_AsUnsignedLong                          : function(ob: PPyObject): C_ULong; cdecl;
  PyLong_AsUnsignedLongMask                      : function(ob: PPyObject): C_ULong; cdecl;
  PyLong_AsInt                                   : function(ob: PPyObject): integer; cdecl;
  PyLong_FromInt32                               : function(value: integer): PPyObject; cdecl;
  PyLong_FromUInt32                              : function(value: cardinal): PPyObject; cdecl;
  PyLong_FromInt64                               : function(value: int64): PPyObject; cdecl;
  PyLong_FromUInt64                              : function(value: uint64): PPyObject; cdecl;
  PyLong_AsInt32                                 : function(ob: PPyObject; out value: Integer): integer; cdecl;
  PyLong_AsUInt32                                : function(ob: PPyObject; out value: cardinal): integer; cdecl;
  PyLong_AsInt64                                 : function(ob: PPyObject; out value: int64): integer; cdecl;
  PyLong_AsUInt64                                : function(ob: PPyObject; out value: uint64): integer; cdecl;
  PyLong_AsNativeBytes                           : function(v: PPyObject; buffer: Pointer; n_bytes: Py_ssize_t; flags: integer): Py_ssize_t; cdecl;
  PyLong_FromNativeBytes                         : function(buffer: Pointer; n_bytes: NativeUInt; flags: integer): PPyObject; cdecl;
  PyLong_FromUnsignedNativeBytes                 : function(buffer: Pointer; n_bytes: NativeUInt; flags: integer): PPyObject; cdecl;
  PyLong_GetInfo                                 : function(): PPyObject; cdecl;
  PyLong_AsDouble                                : function(ob: PPyObject): double; cdecl;
  PyLong_FromVoidPtr                             : function(buffer: Pointer): PPyObject; cdecl;
  PyLong_AsVoidPtr                               : function(ob: PPyObject): Pointer; cdecl;
  PyLong_FromLongLong                            : function(val: int64): PPyObject; cdecl;
  PyLong_FromUnsignedLongLong                    : function(val: uint64): PPyObject; cdecl;
  PyLong_AsLongLong                              : function(ob: PPyObject): Int64; cdecl;
  PyLong_AsUnsignedLongLong                      : function(ob: PPyObject): uint64; cdecl;
  PyLong_AsUnsignedLongLongMask                  : function(ob: PPyObject): uint64; cdecl;
  PyLong_AsLongLongAndOverflow                   : function(ob: PPyObject; out overflow: Integer): Int64; cdecl;
  PyLong_FromString                              : function(const str: PAnsiChar; pend: PPAnsiChar; base: integer): PPyObject; cdecl;
  PyOS_strtoul                                   : function(const str: PAnsiChar; ptr: PPAnsiChar; base: integer): C_ULong; cdecl;
  PyOS_strtol                                    : function(const str: PAnsiChar; ptr: PPAnsiChar; base: integer): C_Long; cdecl;
  PyLong_FromUnicodeObject                       : function(u: PPyObject; base: integer): PPyObject; cdecl;
  PyLong_IsPositive                              : function(obj: PPyObject): integer; cdecl;
  PyLong_IsNegative                              : function(obj: PPyObject): integer; cdecl;
  PyLong_IsZero                                  : function(obj: PPyObject): integer; cdecl;
  PyLong_GetSign                                 : function(v: PPyObject; out sign: integer): integer; cdecl;

  {* include/longintrepr.h  include/cpython/longintrepr.h *}
  PyLong_GetNativeLayout                         : function(): PPyLongLayout; cdecl;
  PyLong_Export                                  : function(obj: PPyObject; export_long: PPyLongExport): integer; cdecl;
  PyLong_FreeExport                              : procedure(export_long: PPyLongExport); cdecl;
  PyLongWriter_Create                            : function(negative: integer; ndigits: Py_ssize_t; var digits: Pointer): PPyLongWriter; cdecl;
  PyLongWriter_Finish                            : function(writer: PPyLongWriter): PPyObject; cdecl;
  PyLongWriter_Discard                           : procedure(writer: PPyLongWriter); cdecl;

  {* include/boolobject.h *}
  Py_False                                       : PPyLongObject;  // _Py_FalseStruct
  Py_True                                        : PPyLongObject;  // _Py_TrueStruct
  Py_IsTrue                                      : function(ob: PPyObject): integer; cdecl;
  Py_IsFalse                                     : function(ob: PPyObject): integer; cdecl;
  PyBool_FromLong                                : function(l: C_Long): PPyObject; cdecl;

  {* include/floatobject.h  include/cpython/floatobject.h *}
  PyFloat_Type                                   : PPyTypeObject;
  PyFloat_GetMax                                 : function(): double; cdecl;
  PyFloat_GetMin                                 : function(): double; cdecl;
  PyFloat_GetInfo                                : function(): PPyObject; cdecl;
  PyFloat_FromString                             : function(str: PPyObject): PPyObject; cdecl;
  PyFloat_FromDouble                             : function(v: double): PPyObject; cdecl;
  PyFloat_AsDouble                               : function(obj: PPyObject): double; cdecl;

  PyFloat_Pack2                                  : function(x: double; p: PByte; le: integer): integer; cdecl;

  PyFloat_Pack4                                  : function(x: double; p: PByte; le: integer): integer; cdecl;

  PyFloat_Pack8                                  : function(x: double; p: PByte; le: integer): integer; cdecl;

  PyFloat_Unpack2                                : function(const p: PByte; le: integer): double; cdecl;

  PyFloat_Unpack4                                : function(const p: PByte; le: integer): double; cdecl;

  PyFloat_Unpack8                                : function(const p: PByte; le: integer): double; cdecl;


  {* include/complexobject.h  include/cpython/complexobject.h *}
  PyComplex_Type                                 : PPyTypeObject;
  PyComplex_FromDoubles                          : function(real, imag: double): PPyObject; cdecl;
  PyComplex_RealAsDouble                         : function(op: PPyObject): double; cdecl;
  PyComplex_ImagAsDouble                         : function(op: PPyObject): double; cdecl;
  PyComplex_FromCComplex                         : function(comp: Py_complex): PPyObject; cdecl;
  PyComplex_AsCComplex                           : function(obj: PPyObject): Py_complex; cdecl;

  {* include/rangeobject.h *}
  PyRange_Type                                   : PPyTypeObject;
  PyRangeIter_Type                               : PPyTypeObject;
  PyLongRangeIter_Type                           : PPyTypeObject;

  {* include/memoryobject.h *}
  PyMemoryView_Type                              : PPyTypeObject;
  PyMemoryView_FromObject                        : function(base: PPyObject): PPyObject; cdecl;
  PyMemoryView_FromMemory                        : function(mem: Pointer; size_: Py_ssize_t; flags: integer): PPyObject; cdecl;
  PyMemoryView_FromBuffer                        : function(const info: PPy_buffer): PPyObject; cdecl;
  PyMemoryView_GetContiguous                     : function(base: PPyObject; buffertype: integer; order: AnsiChar): PPyObject; cdecl;

  {* include/tupleobject.h *}
  PyTuple_Type                                   : PPyTypeObject;
  PyTupleIter_Type                               : PPyTypeObject;
  PyTuple_New                                    : function(size_: Py_ssize_t): PPyObject; cdecl;
  PyTuple_Size                                   : function(p: PPyObject): Py_ssize_t; cdecl;
  PyTuple_GetItem                                : function(p: PPyObject; pos: Py_ssize_t): PPyObject; cdecl;
  PyTuple_SetItem                                : function(p: PPyObject; pos: Py_ssize_t; o: PPyObject): integer; cdecl;
  PyTuple_GetSlice                               : function(p: PPyObject; low, high: Py_ssize_t): PPyObject; cdecl;
  PyTuple_Pack                                   : function(n: Py_ssize_t {; ...}): PPyObject; cdecl varargs;
  PyTuple_FromArray                              : function(array_: PPPyObject; size_: Py_ssize_t): PPyObject; cdecl;   //****** 3.15.0 ******

  {* include/listobject.h  include/cpython/listobject.h *}
  PyList_Type                                    : PPyTypeObject;
  PyListIter_Type                                : PPyTypeObject;
  PyListRevIter_Type                             : PPyTypeObject;
  PyList_New                                     : function(len: Py_ssize_t): PPyObject; cdecl;
  PyList_Size                                    : function(list: PPyObject): Py_ssize_t; cdecl;
  PyList_GetItem                                 : function(list: PPyObject; index: Py_ssize_t): PPyObject; cdecl;
  PyList_GetItemRef                              : function(list: PPyObject; index: Py_ssize_t): PPyObject; cdecl;
  PyList_SetItem                                 : function(list: PPyObject; index: Py_ssize_t; item: PPyObject): integer; cdecl;
  PyList_Insert                                  : function(list: PPyObject; index: Py_ssize_t; item: PPyObject): integer; cdecl;
  PyList_Append                                  : function(list, item: PPyObject): integer; cdecl;
  PyList_GetSlice                                : function(list: PPyObject; low, high: Py_ssize_t): PPyObject; cdecl;
  PyList_SetSlice                                : function(list: PPyObject; low, high: Py_ssize_t; itemlist: PPyObject): integer; cdecl;
  PyList_Sort                                    : function(list: PPyObject): integer; cdecl;
  PyList_Reverse                                 : function(list: PPyObject): integer; cdecl;
  PyList_AsTuple                                 : function(list: PPyObject): PPyObject; cdecl;
  PyList_Extend                                  : function(self, iterable: PPyObject): integer; cdecl;
  PyList_Clear                                   : function(self: PPyObject): integer; cdecl;

  {* include/dictobject.h  include/cpython/dictobject.h  *}
  PyDict_Type                                    : PPyTypeObject;
  PyDict_New                                     : function(): PPyObject; cdecl;
  PyDict_GetItem                                 : function(mp, key: PPyObject): PPyObject; cdecl;
  PyDict_GetItemWithError                        : function(mp, key: PPyObject): PPyObject; cdecl;
  PyDict_SetItem                                 : function(mp, key, val: PPyObject): integer; cdecl;
  PyDict_DelItem                                 : function(mp, key: PPyObject): integer; cdecl;
  PyDict_Clear                                   : procedure(mp: PPyObject); cdecl;
  PyDict_Next                                    : function(mp: PPyObject; pos: PPy_ssize_t; out key, value: PPyObject): integer; cdecl;
  PyDict_Keys                                    : function(mp: PPyObject): PPyObject; cdecl;
  PyDict_Values                                  : function(mp: PPyObject): PPyObject; cdecl;
  PyDict_Items                                   : function(mp: PPyObject): PPyObject; cdecl;
  PyDict_Size                                    : function(mp: PPyObject): Py_ssize_t; cdecl;
  PyDict_Copy                                    : function(mp: PPyObject): PPyObject; cdecl;
  PyDict_Contains                                : function(mp, key: PPyObject): integer; cdecl;
  PyDict_Update                                  : function(mp, other: PPyObject): integer; cdecl;
  PyDict_Merge                                   : function(mp, other: PPyObject; override_: integer): integer; cdecl;
  PyDict_MergeFromSeq2                           : function(d, seq2: PPyObject; override_: integer): integer; cdecl;
  PyDict_GetItemString                           : function(dp: PPyObject; const key: PAnsiChar): PPyObject; cdecl;
  PyDict_SetItemString                           : function(dp: PPyObject; const key: PAnsiChar; item: PPyObject): integer; cdecl;
  PyDict_DelItemString                           : function(dp: PPyObject; const key: PAnsiChar): integer; cdecl;
  PyDict_GetItemRef                              : function(mp, key: PPyObject; result_: PPPyObject): integer; cdecl;
  PyDict_GetItemStringRef                        : function(mp: PPyObject; const key: PAnsiChar; result_: PPPyObject): integer; cdecl;
  PyObject_GenericGetDict                        : function(obj: PPyObject; context: Pointer): PPyObject; cdecl;
  PyDictKeys_Type                                : PPyTypeObject;
  PyDictValues_Type                              : PPyTypeObject;
  PyDictItems_Type                               : PPyTypeObject;
  PyDictIterKey_Type                             : PPyTypeObject;
  PyDictIterValue_Type                           : PPyTypeObject;
  PyDictIterItem_Type                            : PPyTypeObject;
  PyDictRevIterKey_Type                          : PPyTypeObject;
  PyDictRevIterItem_Type                         : PPyTypeObject;
  PyDictRevIterValue_Type                        : PPyTypeObject;
  PyDict_SetDefault                              : function(p, key, defaultobj: PPyObject): PPyObject; cdecl;
  PyDict_SetDefaultRef                           : function(p, key, default_value: PPyObject; result_: PPPyObject): integer; cdecl;
  PyDict_ContainsString                          : function(p: PPyObject; const key: PAnsiChar): integer; cdecl;
  PyDict_Pop                                     : function(p, key: PPyObject; result_: PPPyObject): integer; cdecl;
  PyDict_PopString                               : function(p: PPyObject; const key: PAnsiChar; result_: PPPyObject): integer; cdecl;
  PyDict_AddWatcher                              : function(callback: PyDict_WatchCallback): integer; cdecl;
  PyDict_ClearWatcher                            : function(watcher_id: integer): integer; cdecl;
  PyDict_Watch                                   : function(watcher_id: integer; dict: PPyObject): integer; cdecl;
  PyDict_Unwatch                                 : function(watcher_id: integer; dict: PPyObject): integer; cdecl;
  PyFrozenDict_New                               : function(iterable: PPyObject): PPyObject; cdecl;                    //****** 3.15.0 ******
  PyFrozenDict_Type                              : PPyTypeObject;                                                      //****** 3.15.0 ******

  {* include/cpython/odictobject.h *}
  PyODict_Type                                   : PPyTypeObject;
  PyODictIter_Type                               : PPyTypeObject;
  PyODictKeys_Type                               : PPyTypeObject;
  PyODictItems_Type                              : PPyTypeObject;
  PyODictValues_Type                             : PPyTypeObject;
  PyODict_New                                    : function(): PPyObject; cdecl;
  PyODict_SetItem                                : function(od, key, value: PPyObject): integer; cdecl;
  PyODict_DelItem                                : function(od, key: PPyObject): integer; cdecl;

  {* include/enumobject.h *}
  PyEnum_Type                                    : PPyTypeObject;
  PyReversed_Type                                : PPyTypeObject;

  {* include/setobject.h  include/cpython/setobject.h *}
  PySet_Type                                     : PPyTypeObject;
  PyFrozenSet_Type                               : PPyTypeObject;
  PySetIter_Type                                 : PPyTypeObject;
  PySet_New                                      : function(iterable: PPyObject): PPyObject; cdecl;
  PyFrozenSet_New                                : function(iterable: PPyObject): PPyObject; cdecl;
  PySet_Add                                      : function(set_, key: PPyObject): integer; cdecl;
  PySet_Clear                                    : function(set_: PPyObject): integer; cdecl;
  PySet_Contains                                 : function(anyset, key: PPyObject): integer; cdecl;
  PySet_Discard                                  : function(set_, key: PPyObject): integer; cdecl;
  PySet_Pop                                      : function(set_: PPyObject): PPyObject; cdecl;
  PySet_Size                                     : function(anyset: PPyObject): Py_ssize_t; cdecl;

  {* include/methodobject.h  include/cpython/methodobject.h *}
  PyCFunction_Type                               : PPyTypeObject;
  PyCFunction_GetFunction                        : function(func: PPyObject): PyCFunction; cdecl;
  PyCFunction_GetSelf                            : function(func: PPyObject): PPyObject; cdecl;
  PyCFunction_GetFlags                           : function(func: PPyObject): integer; cdecl;
  PyCFunction_New                                : function(method: PPyMethodDef; self: PPyObject): PPyObject; cdecl;
  PyCFunction_NewEx                              : function(method: PPyMethodDef; self, module: PPyObject): PPyObject; cdecl;
  PyCMethod_New                                  : function(method: PPyMethodDef; self, module: PPyObject; cls: PPyTypeObject): PPyObject; cdecl;
  PyCMethod_Type                                 : PPyTypeObject;

  {* include/moduleobject.h *}
  PyModule_Type                                  : PPyTypeObject;
  PyModule_NewObject                             : function(name_: PPyObject): PPyObject; cdecl;
  PyModule_New                                   : function(const name_: PAnsiChar): PPyObject; cdecl;
  PyModule_GetDict                               : function(module_: PPyObject): PPyObject; cdecl;
  PyModule_GetNameObject                         : function(module_: PPyObject): PPyObject; cdecl;
  PyModule_GetName                               : function(module_: PPyObject): PAnsiChar; cdecl;
  PyModule_GetFilenameObject                     : function(module_: PPyObject): PPyObject; cdecl;
  PyModule_GetDef                                : function(module_: PPyObject): PPyModuleDef; cdecl;
  PyModule_GetState                              : function(module_: PPyObject): Pointer; cdecl;
  PyModuleDef_Init                               : function(def: PPyModuleDef): PPyObject; cdecl;
  PyModuleDef_Type                               : PPyTypeObject;
  PyModule_FromSlotsAndSpec                      : function(const slots: PPySlot; spec: PPyObject): PPyObject; cdecl;          //****** 3.15.0 ******
  PyModule_Exec                                  : function(module_: PPyObject): integer; cdecl;                               //****** 3.15.0 ******
  PyModule_GetStateSize                          : function(module_: PPyObject; out result_: Py_ssize_t): integer; cdecl;      //****** 3.15.0 ******
  PyModule_GetToken                              : function(module_: PPyObject; out result_: Pointer): integer; cdecl;         //****** 3.15.0 ******
  PyModule_GetState_DuringGC                     : function(ob: PPyObject): Pointer; cdecl;                                    //****** 3.15.0 ******
  PyModule_GetToken_DuringGC                     : function(module_: PPyObject; out result_: Pointer): integer; cdecl;         //****** 3.15.0 ******

  {* include/monitoring.h  include/cpython/monitoring.h *}
  PyMonitoring_EnterScope                        : function(state_array: PPyMonitoringState; version: PUint64; const event_types: PByte; length: Py_ssize_t): integer; cdecl;
  PyMonitoring_ExitScope                         : function(): integer; cdecl;

  {* include/cpython/funcobject.h *}
  PyFunction_Type                                : PPyTypeObject;
  PyFunction_New                                 : function(code, globals: PPyObject): PPyObject; cdecl;
  PyFunction_NewWithQualName                     : function(code, globals, qualname: PPyObject): PPyObject; cdecl;
  PyFunction_GetCode                             : function(op: PPyObject): PPyObject; cdecl;
  PyFunction_GetGlobals                          : function(op: PPyObject): PPyObject; cdecl;
  PyFunction_GetModule                           : function(op: PPyObject): PPyObject; cdecl;
  PyFunction_GetDefaults                         : function(op: PPyObject): PPyObject; cdecl;
  PyFunction_SetDefaults                         : function(op, defaults: PPyObject): integer; cdecl;
  PyFunction_SetVectorcall                       : procedure(func: PPyFunctionObject; vectorcall: vectorcallfunc); cdecl;
  PyFunction_GetKwDefaults                       : function(op: PPyObject): PPyObject; cdecl;
  PyFunction_SetKwDefaults                       : function(op, defaults: PPyObject): integer; cdecl;
  PyFunction_GetClosure                          : function(op: PPyObject): PPyObject; cdecl;
  PyFunction_SetClosure                          : function(op, closure: PPyObject): integer; cdecl;
  PyFunction_GetAnnotations                      : function(op: PPyObject): PPyObject; cdecl;
  PyFunction_SetAnnotations                      : function(op, annotations: PPyObject): integer; cdecl;
  PyClassMethod_Type                             : PPyTypeObject;
  PyStaticMethod_Type                            : PPyTypeObject;
  PyClassMethod_New                              : function(callable: PPyObject): PPyObject; cdecl;
  PyStaticMethod_New                             : function(callable: PPyObject): PPyObject; cdecl;
  PyFunction_AddWatcher                          : function(callback: PyFunction_WatchCallback): integer; cdecl;
  PyFunction_ClearWatcher                        : function(watcher_id: integer): integer;

  {* include/cpython/classobject.h *}
  PyMethod_Type                                  : PPyTypeObject;
  PyMethod_New                                   : function(func, self_: PPyObject): PPyObject; cdecl;
  PyMethod_Function                              : function(meth: PPyObject): PPyObject; cdecl;
  PyMethod_Self                                  : function(meth: PPyObject): PPyObject; cdecl;
  PyInstanceMethod_Type                          : PPyTypeObject;
  PyInstanceMethod_New                           : function(func: PPyObject): PPyObject; cdecl;
  PyInstanceMethod_Function                      : function(im: PPyObject): PPyObject; cdecl;

  {* include/fileobject.h  include/cpython/fileobject.h *}
  PyFile_FromFd                                  : function(fd: integer; const name_, mode: PAnsiChar; buffering: integer; const encoding, errors, newline: PAnsiChar; closefd: integer): PPyObject; cdecl;
  PyFile_GetLine                                 : function(p: PPyObject; n: integer): PPyObject; cdecl;
  PyFile_WriteObject                             : function(obj, p: PPyObject; flags: integer): integer; cdecl;
  PyFile_WriteString                             : function(const s: PAnsiChar; p: PPyObject): integer; cdecl;
  PyObject_AsFileDescriptor                      : function(p: PPyObject): integer; cdecl;
  Py_UniversalNewlineFgets                       : function(buf: PAnsiChar; n: integer; stream: PFILE; fobj: PPyObject): PAnsiChar; cdecl;
  PyFile_NewStdPrinter                           : function(fd: integer): PPyObject; cdecl;
  PyStdPrinter_Type                              : PPyTypeObject;
  PyFile_OpenCode                                : function(const path: PAnsiChar): PPyObject; cdecl;
  PyFile_OpenCodeObject                          : function(path: PPyObject): PPyObject; cdecl;
  PyFile_SetOpenCodeHook                         : function(handler: Py_OpenCodeHookFunction; userData: Pointer): integer; cdecl;

  {* include/pycapsule.h *}
  PyCapsule_Type                                 : PPyTypeObject;
  PyCapsule_New                                  : function(pointer_: Pointer; const name_: PAnsiChar; destructor_: PyCapsule_Destructor): PPyObject; cdecl;
  PyCapsule_GetPointer                           : function(capsule: PPyObject; const name_: PAnsiChar): Pointer; cdecl;
  PyCapsule_GetDestructor                        : function(capsule: PPyObject): PyCapsule_Destructor; cdecl;
  PyCapsule_GetName                              : function(capsule: PPyObject): PAnsiChar; cdecl;
  PyCapsule_GetContext                           : function(capsule: PPyObject): Pointer; cdecl;
  PyCapsule_IsValid                              : function(capsule: PPyObject; const name_: PAnsiChar): integer; cdecl;
  PyCapsule_SetPointer                           : function(capsule: PPyObject; pointer_: Pointer): integer; cdecl;
  PyCapsule_SetDestructor                        : function(capsule: PPyObject; destructor_: PyCapsule_Destructor): integer; cdecl;
  PyCapsule_SetName                              : function(capsule: PPyObject; const name_: PAnsiChar): integer; cdecl;
  PyCapsule_SetContext                           : function(capsule: PPyObject; context: Pointer): integer; cdecl;
  PyCapsule_Import                               : function(const name_: PAnsiChar; no_block: integer): Pointer; cdecl;

  {* include/cpython/code.h *}
  PyCode_Type                                    : PPyTypeObject;
  PyCode_NewEmpty                                : function(const filename, funcname: PAnsiChar; firstlineno: integer): PPyCodeObject; cdecl;
  PyCode_Addr2Line                               : function(co: PPyCodeObject; byte_offset: integer): integer; cdecl;
  PyCode_Addr2Location                           : function(co: PPyCodeObject; byte_offset: integer; out start_line, start_column, end_line, end_column: Integer): integer; cdecl;
  PyCode_AddWatcher                              : function(callback: PyCode_WatchCallback): integer; cdecl;
  PyCode_ClearWatcher                            : function(watcher_id: integer): integer; cdecl;
  PyCode_Optimize                                : function(code, consts, names, lnotab: PPyObject): PPyObject; cdecl;
  PyCode_GetCode                                 : function(co: PPyCodeObject): PPyObject; cdecl;
  PyCode_GetVarnames                             : function(co: PPyCodeObject): PPyObject; cdecl;
  PyCode_GetCellvars                             : function(co: PPyCodeObject): PPyObject; cdecl;
  PyCode_GetFreevars                             : function(co: PPyCodeObject): PPyObject; cdecl;

  {* include/pyframe.h  include/cpython/pyframe.h *}
  PyFrame_GetLineNumber                          : function(frame: PPyFrameObject): integer; cdecl;
  PyFrame_GetCode                                : function(frame: PPyFrameObject): PPyCodeObject; cdecl;
  PyFrame_Type                                   : PPyTypeObject;
  PyFrameLocalsProxy_Type                        : PPyTypeObject;
  PyFrame_GetBack                                : function(frame: PPyFrameObject): PPyFrameObject; cdecl;
  PyFrame_GetLocals                              : function(frame: PPyFrameObject): PPyObject; cdecl;
  PyFrame_GetGlobals                             : function(frame: PPyFrameObject): PPyObject; cdecl;
  PyFrame_GetBuiltins                            : function(frame: PPyFrameObject): PPyObject; cdecl;
  PyFrame_GetGenerator                           : function(frame: PPyFrameObject): PPyObject; cdecl;
  PyFrame_GetLasti                               : function(frame: PPyFrameObject): integer; cdecl;
  PyFrame_GetVar                                 : function(frame: PPyFrameObject; name_: PPyObject): PPyObject; cdecl;
  PyFrame_GetVarString                           : function(frame: PPyFrameObject; const name_: PAnsiChar): PPyObject; cdecl;

  {* include/traceback.h  include/cpython/traceback.h *}
  PyTraceBack_Here                               : function(f: PPyFrameObject): integer; cdecl;
  PyTraceBack_Print                              : function(tb, f: PPyObject): integer; cdecl;
  PyTraceBack_Type                               : PPyTypeObject;

  {* include/sliceobject.h  include/cpython/sliceobject.h *}
  Py_Ellipsis                                    : PPyObject;      // _Py_EllipsisObject
  PySlice_Type                                   : PPyTypeObject;
  PyEllipsis_Type                                : PPyTypeObject;
  PySlice_New                                    : function(start, stop, step: PPyObject): PPyObject; cdecl;
  PySlice_GetIndices                             : function(slice: PPyObject; length: Py_ssize_t; start, stop, step: PPy_ssize_t): integer; cdecl;
  PySlice_GetIndicesEx                           : function(slice: PPyObject; length: Py_ssize_t; start, stop, step, slicelength: PPy_ssize_t): integer; cdecl;
  PySlice_Unpack                                 : function(slice: PPyObject; start, stop, step: PPy_ssize_t): integer; cdecl;
  PySlice_AdjustIndices                          : function(length: Py_ssize_t; start, stop: PPy_ssize_t; step: Py_ssize_t): Py_ssize_t; cdecl;

  {* include/cpython/cellobject.h *}
  PyCell_Type                                    : PPyTypeObject;
  PyCell_New                                     : function(ob: PPyObject): PPyObject; cdecl;
  PyCell_Get                                     : function(cell: PPyObject): PPyObject; cdecl;
  PyCell_Set                                     : function(cell, value: PPyObject): integer; cdecl;

  {* include/iterobject.h *}
  PySeqIter_Type                                 : PPyTypeObject;
  PyCallIter_Type                                : PPyTypeObject;
  PySeqIter_New                                  : function(seq: PPyObject): PPyObject; cdecl;
  PyCallIter_New                                 : function(callable, sentinel: PPyObject): PPyObject; cdecl;

  {* include/cpython/initconfig.h *}
  PyStatus_Ok                                    : function(): PyStatus; cdecl;
  PyStatus_Error                                 : function(const err_msg: PAnsiChar): PyStatus; cdecl;
  PyStatus_NoMemory                              : function(): PyStatus; cdecl;
  PyStatus_Exit                                  : function(exitcode: integer): PyStatus; cdecl;
  PyStatus_IsError                               : function(err: PyStatus): integer; cdecl;
  PyStatus_IsExit                                : function(err: PyStatus): integer; cdecl;
  PyStatus_Exception                             : function(err: PyStatus): integer; cdecl;
  PyWideStringList_Append                        : function(list: PPyWideStringList; const item: PWCharT): PyStatus; cdecl;
  PyWideStringList_Insert                        : function(list: PPyWideStringList; index: Py_ssize_t; const item: PWCharT): PyStatus; cdecl;
  PyPreConfig_InitPythonConfig                   : procedure(config: PPyPreConfig); cdecl;
  PyPreConfig_InitIsolatedConfig                 : procedure(config: PPyPreConfig); cdecl;
  PyConfig_InitPythonConfig                      : procedure(config: PPyConfig); cdecl;
  PyConfig_InitIsolatedConfig                    : procedure(config: PPyConfig); cdecl;
  PyConfig_Clear                                 : procedure(config: PPyConfig); cdecl;
  PyConfig_SetString                             : function(config: PPyConfig; var config_str: PWCharT; const str: PWCharT): PyStatus; cdecl;
  PyConfig_SetBytesString                        : function(config: PPyConfig; var config_str: PWCharT; const str: PAnsiChar): PyStatus; cdecl;
  PyConfig_Read                                  : function(config: PPyConfig): PyStatus; cdecl;
  PyConfig_SetBytesArgv                          : function(config: PPyConfig; argc: Py_ssize_t; const argv: PPAnsiChar): PyStatus; cdecl;
  PyConfig_SetArgv                               : function(config: PPyConfig; argc: Py_ssize_t; const argv: PPWCharT): PyStatus; cdecl;
  PyConfig_SetWideStringList                     : function(config: PPyConfig; list: PPyWideStringList; length: Py_ssize_t; items: PPWCharT): PyStatus; cdecl;
  PyConfig_Get                                   : function(const name_: PAnsiChar): PPyObject; cdecl;
  PyConfig_GetInt                                : function(const name_: PAnsiChar; out value: Integer): integer; cdecl;
  PyConfig_Names                                 : function(): PPyObject; cdecl;
  PyConfig_Set                                   : function(const name_: PAnsiChar; value: PPyObject): Integer; cdecl;
  Py_GetArgcArgv                                 : procedure(out argc: integer; out argv: PPWCharT); cdecl;
  PyInitConfig_Create                            : function(): PPyInitConfig; cdecl;
  PyInitConfig_Free                              : procedure(config: PPyInitConfig); cdecl;
  PyInitConfig_GetError                          : function(config: PPyInitConfig; out err_msg: PAnsiChar): integer; cdecl;
  PyInitConfig_GetExitCode                       : function(config: PPyInitConfig; out exitcode: integer): integer; cdecl;
  PyInitConfig_HasOption                         : function(config: PPyInitConfig; const name_: PAnsiChar): integer; cdecl;
  PyInitConfig_GetInt                            : function(config: PPyInitConfig; const name_: PAnsiChar; out value: int64): integer; cdecl;
  PyInitConfig_GetStr                            : function(config: PPyInitConfig; const name_: PAnsiChar; out value: PAnsiChar): integer; cdecl;
  PyInitConfig_GetStrList                        : function(config: PPyInitConfig; const name_: PAnsiChar; out length: NativeUInt; out items: PPAnsiChar): integer; cdecl;
  PyInitConfig_FreeStrList                       : procedure(length: NativeUInt; items: PPAnsiChar); cdecl;
  PyInitConfig_SetInt                            : function(config: PPyInitConfig; const name_: PAnsiChar; value: int64): integer; cdecl;
  PyInitConfig_SetStr                            : function(config: PPyInitConfig; const name_, value: PAnsiChar): integer; cdecl;
  PyInitConfig_SetStrList                        : function(config: PPyInitConfig; const name_: PAnsiChar; length: NativeUInt; const items: PPAnsiChar): integer; cdecl;
  PyInitConfig_AddModule                         : function(config: PPyInitConfig; const name_: PAnsiChar; initfunc_: initfunc): integer; cdecl;
  Py_InitializeFromInitConfig                    : function(config: PPyInitConfig): integer; cdecl;

  {* include/pystate.h  include/cpython/pystate.h *}
  PyInterpreterState_New                         : function(): PPyInterpreterState; cdecl;
  PyInterpreterState_Clear                       : procedure(interp: PPyInterpreterState); cdecl;
  PyInterpreterState_Delete                      : procedure(interp: PPyInterpreterState); cdecl;
  PyInterpreterState_Get                         : function(): PPyInterpreterState; cdecl;
  PyInterpreterState_GetDict                     : function(interp: PPyInterpreterState): PPyObject; cdecl;
  PyInterpreterState_GetID                       : function(interp: PPyInterpreterState): int64; cdecl;
  PyState_AddModule                              : function(module: PPyObject; def: PPyModuleDef): integer; cdecl;
  PyState_RemoveModule                           : function(def: PPyModuleDef): integer; cdecl;
  PyState_FindModule                             : function(def: PPyModuleDef): PPyObject; cdecl;
  PyThreadState_New                              : function(state: PPyInterpreterState): PPyThreadState; cdecl;
  PyThreadState_Clear                            : procedure(tstate: PPyThreadState); cdecl;
  PyThreadState_Delete                           : procedure(tstate: PPyThreadState); cdecl;
  PyThreadState_Get                              : function(): PPyThreadState; cdecl;
  PyThreadState_Swap                             : function(tstate: PPyThreadState): PPyThreadState; cdecl;
  PyThreadState_GetDict                          : function(): PPyObject; cdecl;
  PyThreadState_SetAsyncExc                      : function(id: C_ULong; exc: PPyObject): integer; cdecl;
  PyThreadState_GetInterpreter                   : function(tstate: PPyThreadState): PPyInterpreterState; cdecl;
  PyThreadState_GetFrame                         : function(tstate: PPyThreadState): PPyFrameObject; cdecl;
  PyThreadState_GetID                            : function(tstate: PPyThreadState): uint64; cdecl;
  PyGILState_Ensure                              : function(): PyGILstate_STATE; cdecl;
  PyGILState_Release                             : procedure(gilstate: PyGILState_STATE); cdecl;
  PyGILState_GetThisThreadState                  : function(): PPyThreadState; cdecl;
  PyInterpreterGuard_FromCurrent                 : function(): PPyInterpreterGuard; cdecl;                               //****** 3.15.0 ******
  PyInterpreterGuard_Close                       : procedure(guard: PPyInterpreterGuard); cdecl;                         //****** 3.15.0 ******
  PyInterpreterGuard_FromView                    : function(view: PPyInterpreterView): PPyInterpreterGuard; cdecl;       //****** 3.15.0 ******
  PyInterpreterView_FromCurrent                  : function(): PPyInterpreterView; cdecl;                                //****** 3.15.0 ******
  PyInterpreterView_Close                        : procedure(view: PPyInterpreterView); cdecl;                           //****** 3.15.0 ******
  PyInterpreterView_FromMain                     : function(): PPyInterpreterView; cdecl;                                //****** 3.15.0 ******
  PyThreadState_Ensure                           : function(guard: PPyInterpreterGuard): PPyThreadStateToken; cdecl;     //****** 3.15.0 ******
  PyThreadState_EnsureFromView                   : function(view: PPyInterpreterView): PPyThreadStateToken; cdecl;       //****** 3.15.0 ******
  PyThreadState_Release                          : procedure(tstate: PPyThreadStateToken); cdecl;                        //****** 3.15.0 ******
  PyThreadState_GetUnchecked                     : function(): PPyThreadState; cdecl;
  PyThreadState_EnterTracing                     : procedure(tstate: PPyThreadState); cdecl;
  PyThreadState_LeaveTracing                     : procedure(tstate: PPyThreadState); cdecl;
  PyGILState_Check                               : function(): integer; cdecl;
  PyInterpreterState_Main                        : function(): PPyInterpreterState; cdecl;
  PyInterpreterState_Head                        : function(): PPyInterpreterState; cdecl;
  PyInterpreterState_Next                        : function(istate: PPyInterpreterState): PPyInterpreterState; cdecl;
  PyInterpreterState_ThreadHead                  : function(istate: PPyInterpreterState): PPyThreadState; cdecl;
  PyThreadState_Next                             : function(tstate: PPyThreadState): PPyThreadState; cdecl;
  PyThreadState_DeleteCurrent                    : procedure(); cdecl;

  {* include/cpython/genobject.h *}
  PyGen_Type                                     : PPyTypeObject;
  PyGen_New                                      : function(frame: PPyFrameObject): PPyObject; cdecl;
  PyGen_NewWithQualName                          : function(frame: PPyFrameObject; name_, qualname: PPyObject): PPyObject; cdecl;
  PyGen_GetCode                                  : function(gen: PPyGenObject): PPyCodeObject;  cdecl;
  PyCoro_Type                                    : PPyTypeObject;
  PyCoro_New                                     : function(frame: PPyFrameObject; name_, qualname: PPyObject): PPyObject; cdecl;
  PyAsyncGen_Type                                : PPyTypeObject;
  PyAsyncGen_New                                 : function(frame: PPyFrameObject; name_, qualname: PPyObject): PPyObject; cdecl;

  {* include/descrobject.h  include/cpython/descrobject.h *}
  PyClassMethodDescr_Type                        : PPyTypeObject;
  PyGetSetDescr_Type                             : PPyTypeObject;
  PyMemberDescr_Type                             : PPyTypeObject;
  PyMethodDescr_Type                             : PPyTypeObject;
  PyWrapperDescr_Type                            : PPyTypeObject;
  PyDictProxy_Type                               : PPyTypeObject;
  PyProperty_Type                                : PPyTypeObject;
  PyDescr_NewMethod                              : function(type_: PPyTypeObject; meth: PPyMethodDef): PPyObject; cdecl;
  PyDescr_NewClassMethod                         : function(type_: PPyTypeObject; meth: PPyMethodDef): PPyObject; cdecl;
  PyDescr_NewMember                              : function(type_: PPyTypeObject; meth: PPyMemberDef): PPyObject; cdecl;
  PyDescr_NewGetSet                              : function(type_: PPyTypeObject; getset: PPyGetSetDef): PPyObject; cdecl;
  PyDictProxy_New                                : function(mapping: PPyObject): PPyObject; cdecl;
  PyWrapper_New                                  : function(obj1, obj2: PPyObject): PPyObject; cdecl;
  PyMember_GetOne                                : function(const obj_addr: PAnsiChar; m: PPyMemberDef): PPyObject; cdecl;
  PyMember_SetOne                                : function(obj_addr: PAnsiChar; m: PPyMemberDef; o: PPyObject): integer; cdecl;
  PyDescr_NewWrapper                             : function(type_: PPyTypeObject; wrapper: Pwrapperbase; wrapped: Pointer): PPyObject; cdecl;
  PyDescr_IsData                                 : function(descr: PPyObject): integer; cdecl;

  {* include/genericaliasobject.h *}
  Py_GenericAlias                                : function(origin, args: PPyObject): PPyObject; cdecl;
  Py_GenericAliasType                            : PPyTypeObject;

  {* include/cpython/sentinelobject.h *}
  PySentinel_Type                                : PPyTypeObject;                                                             //****** 3.15.0 ******
  PySentinel_New                                 : function(const name_, module_name, repr: PAnsiChar): PPyObject; cdecl;     //****** 3.15.0 ******

  {* include/warnings.h  include/cpython/warnings.h *}
  PyErr_WarnEx                                   : function(category: PPyObject; const message_: PAnsiChar; stack_level: Py_ssize_t): integer; cdecl;
  PyErr_WarnFormat                               : function(category: PPyObject; stack_level: Py_ssize_t; const format_: PAnsiChar {; ...}): integer; cdecl varargs;
  PyErr_ResourceWarning                          : function(source: PPyObject; stack_level: Py_ssize_t; const format_: PAnsiChar {; ...}): integer; cdecl varargs;
  PyErr_WarnExplicit                             : function(category: PPyObject; const message_, filename: PAnsiChar; lineno: integer; const module_: PAnsiChar; registry_: PPyObject): integer; cdecl;
  PyErr_WarnExplicitObject                       : function(category, message_, filename: PPyObject; lineno: integer; module_, registry_: PPyObject): integer; cdecl;
  PyErr_WarnExplicitFormat                       : function(category: PPyObject; const filename: PAnsiChar; lineno: integer; const module_: PAnsiChar; registry_: PPyObject; const format_: PAnsiChar {; ...}): integer; cdecl varargs;

  {* include/weakrefobject.h  include/cpython/weakrefobject.h *}
  _PyWeakref_RefType                             : PPyTypeObject;
  _PyWeakref_ProxyType                           : PPyTypeObject;
  _PyWeakref_CallableProxyType                   : PPyTypeObject;
  PyWeakref_NewRef                               : function(ob, callback: PPyObject): PPyObject; cdecl;
  PyWeakref_NewProxy                             : function(ob, callback: PPyObject): PPyObject; cdecl;
  PyWeakref_GetRef                               : function(ref: PPyObject; out pobj: PPyObject): integer; cdecl;
  PyWeakref_IsDead                               : function(ref: PPyObject): integer; cdecl;

  {* include/structseq.h  include/cpython/structseq.h *}
  PyStructSequence_InitType                      : procedure(type_: PPyTypeObject; desc: PPyStructSequence_Desc); cdecl;
  PyStructSequence_InitType2                     : function(type_: PPyTypeObject; desc: PPyStructSequence_Desc): integer; cdecl;
  PyStructSequence_NewType                       : function(desc: PPyStructSequence_Desc): PPyTypeObject; cdecl;
  PyStructSequence_New                           : function(type_: PPyTypeObject): PPyObject; cdecl;
  PyStructSequence_SetItem                       : procedure(p: PPyObject; pos: Py_ssize_t; o: PPyObject); cdecl;
  PyStructSequence_GetItem                       : function(p: PPyObject; pos: Py_ssize_t): PPyObject; cdecl;

  {* include/cpython/picklebufobject.h *}
  PyPickleBuffer_Type                            : PPyTypeObject;
  PyPickleBuffer_FromObject                      : function(obj: PPyObject): PPyObject; cdecl;
  PyPickleBuffer_GetBuffer                       : function(obj: PPyObject): PPy_buffer; cdecl;
  PyPickleBuffer_Release                         : function(obj: PPyObject): integer; cdecl;

  {* include/cpython/pytime.h *}
  PyTime_AsSecondsDouble                         : function(t: PyTime_t): double; cdecl;
  PyTime_Monotonic                               : function(result: PPyTime_t): integer; cdecl;
  PyTime_PerfCounter                             : function(result: PPyTime_t): integer; cdecl;
  PyTime_Time                                    : function(result: PPyTime_t): integer; cdecl;
  PyTime_MonotonicRaw                            : function(result: PPyTime_t): integer; cdecl;
  PyTime_PerfCounterRaw                          : function(result: PPyTime_t): integer; cdecl;
  PyTime_TimeRaw                                 : function(result: PPyTime_t): integer; cdecl;

  {* include/codecs.h *}
  PyCodec_Register                               : function(search_function: PPyObject): integer; cdecl;
  PyCodec_Unregister                             : function(search_function: PPyObject): integer; cdecl;
  PyCodec_KnownEncoding                          : function(const encoding: PAnsiChar): integer; cdecl;
  PyCodec_Encode                                 : function(object_: PPyObject; const encoding, errors: PAnsiChar): PPyObject; cdecl;
  PyCodec_Decode                                 : function(object_: PPyObject; const encoding, errors: PAnsiChar): PPyObject; cdecl;
  PyCodec_Encoder                                : function(const encoding: PAnsiChar): PPyObject; cdecl;
  PyCodec_Decoder                                : function(const encoding: PAnsiChar): PPyObject; cdecl;
  PyCodec_IncrementalEncoder                     : function(const encoding, errors: PAnsiChar): PPyObject; cdecl;
  PyCodec_IncrementalDecoder                     : function(const encoding, errors: PAnsiChar): PPyObject; cdecl;
  PyCodec_StreamReader                           : function(const encoding: PAnsiChar; stream: PPyObject; const errors: PAnsiChar): PPyObject; cdecl;
  PyCodec_StreamWriter                           : function(const encoding: PAnsiChar; stream: PPyObject; const errors: PAnsiChar): PPyObject; cdecl;
  PyCodec_RegisterError                          : function(const name_: PAnsiChar; error: PPyObject): integer; cdecl;
  PyCodec_LookupError                            : function(const name_: PAnsiChar): PPyObject; cdecl;
  PyCodec_StrictErrors                           : function(exc: PPyObject): PPyObject; cdecl;
  PyCodec_IgnoreErrors                           : function(exc: PPyObject): PPyObject; cdecl;
  PyCodec_ReplaceErrors                          : function(exc: PPyObject): PPyObject; cdecl;
  PyCodec_XMLCharRefReplaceErrors                : function(exc: PPyObject): PPyObject; cdecl;
  PyCodec_BackslashReplaceErrors                 : function(exc: PPyObject): PPyObject; cdecl;
  PyCodec_NameReplaceErrors                      : function(exc: PPyObject): PPyObject; cdecl;

  {* include/pythread.h  include/cpython/pythread.h *}
  PyThread_init_thread                           : procedure(); cdecl;
  PyThread_start_new_thread                      : function(func_: PyThread_start_new_thread_func; arg: Pointer): C_ULong; cdecl;
  PyThread_get_thread_ident                      : function(): C_ULong; cdecl;
  PyThread_get_thread_native_id                  : function(): C_ULong; cdecl;
  PyThread_allocate_lock                         : function(): PyThread_type_lock; cdecl;
  PyThread_free_lock                             : procedure(lock: PyThread_type_lock); cdecl;
  PyThread_acquire_lock                          : function(lock: PyThread_type_lock; waitflag: integer): integer; cdecl;
  PyThread_acquire_lock_timed                    : function(lock: PyThread_type_lock; microseconds: PY_TIMEOUT_T; intr_flag: integer): PyLockStatus; cdecl;
  PyThread_release_lock                          : procedure(lock: PyThread_type_lock); cdecl;
  PyThread_get_stacksize                         : function(): NativeUInt; cdecl;
  PyThread_set_stacksize                         : function(size_: NativeUInt): integer; cdecl;
  PyThread_GetInfo                               : function(): PPyObject; cdecl;
  PyThread_tss_alloc                             : function(): PPy_tss_t; cdecl;
  PyThread_tss_free                              : procedure(key: PPy_tss_t); cdecl;
  PyThread_tss_is_created                        : function(key: PPy_tss_t): integer; cdecl;
  PyThread_tss_create                            : function(key: PPy_tss_t): integer; cdecl;
  PyThread_tss_delete                            : procedure(key: PPy_tss_t); cdecl;
  PyThread_tss_set                               : function(key: PPy_tss_t; value: pointer): integer; cdecl;
  PyThread_tss_get                               : function(key: PPy_tss_t): pointer; cdecl;

  {* include/cpython/context.h *}
  PyContext_Type                                 : PPyTypeObject;
  PyContextVar_Type                              : PPyTypeObject;
  PyContextToken_Type                            : PPyTypeObject;
  PyContext_New                                  : function(): PPyObject; cdecl;
  PyContext_Copy                                 : function(ctx: PPyObject): PPyObject; cdecl;
  PyContext_CopyCurrent                          : function(): PPyObject; cdecl;
  PyContext_Enter                                : function(ctx: PPyObject): integer; cdecl;
  PyContext_Exit                                 : function(ctx: PPyObject): integer; cdecl;
  PyContext_AddWatcher                           : function(callback: PyContext_WatchCallback): integer; cdecl;
  PyContext_ClearWatcher                         : function(watcher_id: integer): integer; cdecl;
  PyContextVar_New                               : function(const name_: PAnsiChar; def: PPyObject): PPyObject; cdecl;
  PyContextVar_Get                               : function(var_, default_value: PPyObject; out value: PPyObject): integer; cdecl;
  PyContextVar_Set                               : function(var_, value: PPyObject): PPyObject; cdecl;
  PyContextVar_Reset                             : function(var_, token: PPyObject): integer; cdecl;

  {* include/modsupport.h  include/cpython/modsupport.h *}
  PyArg_Parse                                    : function(obj: PPyObject; const str: PAnsiChar {; ...}): integer; cdecl varargs;
  PyArg_ParseTuple                               : function(obj: PPyObject; const str: PAnsiChar {; ...}): integer; cdecl varargs;
  PyArg_ParseTupleAndKeywords                    : function(obj1, obj2: PPyObject; const str1, str2: PAnsiChar {; ...}): integer; cdecl varargs;
  //PyArg_VaParse not implemented  // PyAPI_FUNC(int) PyArg_VaParse(PyObject *, const char *, va_list);
  //PyArg_VaParseTupleAndKeywords not implemented  // PyAPI_FUNC(int) PyArg_VaParseTupleAndKeywords(PyObject *, PyObject *, const char *, PY_CXX_CONST char * const *, va_list);
  PyArg_ValidateKeywordArguments                 : function(kwargs: PPyObject): integer; cdecl;
  PyArg_UnpackTuple                              : function(obj: PPyObject; const str: PAnsiChar; size1, size2: Py_ssize_t {; ...}): integer; cdecl varargs;
  Py_BuildValue                                  : function(const str: PAnsiChar {; ...}): PPyObject; cdecl varargs;
  //Py_VaBuildValue not implemented  // PyAPI_FUNC(PyObject *) Py_VaBuildValue(const char *, va_list);
  PyModule_AddObjectRef                          : function(module: PPyObject; const name_: PAnsiChar; value: PPyObject): integer; cdecl;
  PyModule_Add                                   : function(module: PPyObject; const name_: PAnsiChar; value: PPyObject): integer; cdecl;
  PyModule_AddObject                             : function(module: PPyObject; const name_: PAnsiChar; value: PPyObject): integer; cdecl;
  PyModule_AddIntConstant                        : function(module: PPyObject; const name_: PAnsiChar; value: C_Long): integer; cdecl;
  PyModule_AddStringConstant                     : function(module: PPyObject; const name_, value: PAnsiChar): integer; cdecl;
  PyModule_AddType                               : function(module: PPyObject; type_: PPyTypeObject): integer; cdecl;
  PyModule_SetDocString                          : function(module: PPyObject; const docstring: PAnsiChar): integer; cdecl;
  PyModule_AddFunctions                          : function(module: PPyObject; functions: PPyMethodDef): integer; cdecl;
  PyModule_ExecDef                               : function(module: PPyObject; def: PPyModuleDef): integer; cdecl;
  PyModule_Create2                               : function(def: PPyModuleDef; module_api_version: integer): PPyObject; cdecl;
  PyModule_FromDefAndSpec2                       : function(def: PPyModuleDef; spec: PPyObject; module_api_version: integer): PPyObject; cdecl;
  PyABIInfo_Check                                : function(info: PPyABIInfo; const module_name: PAnsiChar): integer; cdecl;                                     //****** 3.15.0 ******
  PyArg_ParseArray                               : function(const args: PPPyObject; nargs: Py_ssize_t; const format: PAnsiChar {; ...}): integer; cdecl varargs; //****** 3.15.0 ******
  PyArg_ParseArrayAndKeywords                    : function(const args: PPPyObject; nargs: Py_ssize_t; kwnames: PPyObject; const format: PAnsiChar; const kwlist: PPAnsiChar {; ...}): integer; cdecl varargs; //****** 3.15.0 ******

  {* include/compile.h  include/cpython/compile.h *}
  PyCompile_OpcodeStackEffect                    : function(opcode, oparg: integer): integer; cdecl;
  PyCompile_OpcodeStackEffectWithJump            : function(opcode, oparg, jump: integer): integer; cdecl;

  {* include/pythonrun.h  include/cpython/pythonrun.h *}
  Py_CompileString                               : function(const str, filename: PAnsiChar; start: integer): PPyObject; cdecl;
  PyErr_Print                                    : procedure(); cdecl;
  PyErr_PrintEx                                  : procedure(set_sys_last_vars: integer); cdecl;
  PyErr_Display                                  : procedure(unused, value, tb: PPyObject); cdecl;
  PyErr_DisplayException                         : procedure(exc: PPyObject); cdecl;
  PyOS_CheckStack                                : function(): integer; cdecl;
  PyRun_SimpleStringFlags                        : function(const command: PAnsiChar; flags: PPyCompilerFlags): integer; cdecl;
  PyRun_AnyFileExFlags                           : function(fp: PFILE; const filename: PAnsiChar; closeit: integer; flags: PPyCompilerFlags): integer; cdecl;
  PyRun_SimpleFileExFlags                        : function(fp: PFILE; const filename: PAnsiChar; closeit: integer; flags: PPyCompilerFlags): integer; cdecl;
  PyRun_InteractiveOneFlags                      : function(fp: PFILE; const filename: PAnsiChar; flags: PPyCompilerFlags): integer; cdecl;
  PyRun_InteractiveOneObject                     : function(fp: PFILE; filename: PPyObject; flags: PPyCompilerFlags): integer; cdecl;
  PyRun_InteractiveLoopFlags                     : function(fp: PFILE; const filename: PAnsiChar; flags: PPyCompilerFlags): integer; cdecl;
  PyRun_StringFlags                              : function(const str: PAnsiChar; start: integer; globals, locals: PPyObject; flags: PPyCompilerFlags): PPyObject; cdecl;
  PyRun_FileExFlags                              : function(fp: PFILE; const filename: PAnsiChar; start: integer; globals, locals: PPyObject; closeit: integer; flags: PPyCompilerFlags): PPyObject; cdecl;
  Py_CompileStringFlags                          : function(const str, filename: PAnsiChar; start: integer; flags: PPyCompilerFlags): PPyObject; cdecl;
  Py_CompileStringExFlags                        : function(const str, filename: PAnsiChar; start: integer; flags: PPyCompilerFlags; optimize: integer): PPyObject; cdecl;
  Py_CompileStringObject                         : function(const str: PAnsiChar; filename: PPyObject; start: integer; flags: PPyCompilerFlags; optimize: integer): PPyObject; cdecl;
  PyRun_String                                   : function(const str: PAnsiChar; start: integer; globals, locals: PPyObject): PPyObject; cdecl;
  PyRun_AnyFile                                  : function(fp: PFILE; const name_: PAnsiChar): integer; cdecl;
  PyRun_AnyFileEx                                : function(fp: PFILE; const name_: PAnsiChar; closeit: integer): integer; cdecl;
  PyRun_AnyFileFlags                             : function(fp: PFILE; const name_: PAnsiChar; flags: PPyCompilerFlags): integer; cdecl;
  PyRun_SimpleString                             : function(const command: PAnsiChar): integer; cdecl;
  PyRun_SimpleFile                               : function(fp: PFILE; const filename: PAnsiChar): integer; cdecl;
  PyRun_SimpleFileEx                             : function(fp: PFILE; const filename: PAnsiChar; closeit: integer): integer; cdecl;
  PyRun_InteractiveOne                           : function(fp: PFILE; const filename: PAnsiChar): integer; cdecl;
  PyRun_InteractiveLoop                          : function(fp: PFILE; const filename: PAnsiChar): integer; cdecl;
  PyRun_File                                     : function(fp: PFILE; const filename: PAnsiChar; start: integer; globals, locals: PPyObject): PPyObject; cdecl;
  PyRun_FileEx                                   : function(fp: PFILE; const filename: PAnsiChar; start: integer; globals, locals: PPyObject; closeit: integer): PPyObject; cdecl;
  PyRun_FileFlags                                : function(fp: PFILE; const filename: PAnsiChar; start: integer; globals, locals: PPyObject; flags: PPyCompilerFlags): PPyObject; cdecl;
  PyOS_Readline                                  : function(sys_stdin, sys_stdout: PFILE; const prompt: PAnsiChar): PAnsiChar; cdecl;

  {* include/pylifecycle.h  include/cpython/pylifecycle.h *}
  Py_Initialize                                  : procedure(); cdecl;
  Py_InitializeEx                                : procedure(initsigs: integer); cdecl;
  Py_Finalize                                    : procedure(); cdecl;
  Py_FinalizeEx                                  : function(): integer; cdecl;
  Py_IsInitialized                               : function(): integer; cdecl;
  Py_NewInterpreter                              : function(): PPyThreadState; cdecl;
  Py_EndInterpreter                              : procedure(tstate: PPyThreadState); cdecl;
  Py_AtExit                                      : function(proc: AtExitProc): integer; cdecl;
  Py_Exit                                        : procedure(status: Integer); cdecl;
  Py_Main                                        : function(argc: integer; argv: PPWCharT): integer; cdecl;
  Py_BytesMain                                   : function(argc: integer; argv: PPAnsiChar): integer; cdecl;
  Py_SetProgramName                              : procedure(const name_: PWCharT); cdecl;
  Py_GetProgramName                              : function(): PWCharT; cdecl;
  Py_SetPythonHome                               : procedure(const home: PWCharT); cdecl;
  Py_GetPythonHome                               : function(): PWCharT; cdecl;
  Py_GetProgramFullPath                          : function(): PWCharT; cdecl;
  Py_GetPrefix                                   : function(): PWCharT; cdecl;
  Py_GetExecPrefix                               : function(): PWCharT; cdecl;
  Py_GetPath                                     : function(): PWCharT; cdecl;
  Py_GetVersion                                  : function(): PAnsiChar; cdecl;
  Py_GetPlatform                                 : function(): PAnsiChar; cdecl;
  Py_GetCopyright                                : function(): PAnsiChar; cdecl;
  Py_GetCompiler                                 : function(): PAnsiChar; cdecl;
  Py_GetBuildInfo                                : function(): PAnsiChar; cdecl;
  PyOS_getsig                                    : function(i: integer): PyOS_sighandler_t; cdecl;
  PyOS_setsig                                    : function(i: integer; sighandler: PyOS_sighandler_t): PyOS_sighandler_t; cdecl;
  Py_Version                                     : PC_ULong;
  Py_IsFinalizing                                : function(): integer; cdecl;
  Py_PreInitialize                               : function(src_config: PPyPreConfig): PyStatus; cdecl;
  Py_PreInitializeFromBytesArgs                  : function(src_config: PPyPreConfig; argc: Py_ssize_t; argv: PPAnsiChar): PyStatus; cdecl;
  Py_PreInitializeFromArgs                       : function(src_config: PPyPreConfig; argc: Py_ssize_t; argv: PPWCharT): PyStatus; cdecl;
  Py_InitializeFromConfig                        : function(config: PPyConfig): PyStatus; cdecl;
  Py_RunMain                                     : function(): integer; cdecl;
  Py_ExitStatusException                         : procedure(status: PyStatus); cdecl;
  Py_FdIsInteractive                             : function(file_: PFILE; const filename: PAnsiChar): integer; cdecl;
  Py_NewInterpreterFromConfig                    : function(out tstate: PPyThreadState; config: PPyInterpreterConfig): PyStatus; cdecl;

  {* include/ceval.h  include/cpython/ceval.h *}
  PyEval_EvalCode                                : function(co, globals, locals: PPyObject): PPyObject; cdecl;
  PyEval_EvalCodeEx                              : function(co, globals, locals: PPyObject; args: PPPyObject; argcount: integer; kwds: PPPyObject; kwcount: integer; defs: PPPyObject; defcount: integer; kwdefs, closure: PPyObject): PPyObject; cdecl;
  PyEval_GetBuiltins                             : function(): PPyObject; cdecl;
  PyEval_GetGlobals                              : function(): PPyObject; cdecl;
  PyEval_GetLocals                               : function(): PPyObject; cdecl;
  PyEval_GetFrame                                : function(): PPyFrameObject; cdecl;
  PyEval_GetFrameBuiltins                        : function(): PPyObject; cdecl;
  PyEval_GetFrameGlobals                         : function(): PPyObject; cdecl;
  PyEval_GetFrameLocals                          : function(): PPyObject; cdecl;
  Py_AddPendingCall                              : function(func: Py_AddPendingCall_func; arg: pointer): integer; cdecl;
  Py_MakePendingCalls                            : function(): integer; cdecl;
  Py_SetRecursionLimit                           : procedure(new_limit: Integer); cdecl;
  Py_GetRecursionLimit                           : function(): integer; cdecl;
  Py_EnterRecursiveCall                          : function(const where_: PAnsiChar): integer; cdecl;
  Py_LeaveRecursiveCall                          : procedure(); cdecl;
  PyEval_GetFuncName                             : function(func: PPyObject): PAnsiChar; cdecl;
  PyEval_GetFuncDesc                             : function(func: PPyObject): PAnsiChar; cdecl;
  PyEval_EvalFrame                               : function(f: PPyFrameObject): PPyObject; cdecl;
  PyEval_EvalFrameEx                             : function(f: PPyFrameObject; throwflag: integer): PPyObject; cdecl;
  PyEval_SaveThread                              : function(): PPyThreadState; cdecl;
  PyEval_RestoreThread                           : procedure(tstate: PPyThreadState); cdecl;
  PyEval_AcquireThread                           : procedure(tstate: PPyThreadState); cdecl;
  PyEval_ReleaseThread                           : procedure(tstate: PPyThreadState); cdecl;
  PyEval_SetProfile                              : procedure(func: Py_tracefunc; obj: PPyObject); cdecl;
  PyEval_SetProfileAllThreads                    : procedure(func: Py_tracefunc; obj: PPyObject); cdecl;
  PyEval_SetTrace                                : procedure(func: Py_tracefunc; obj: PPyObject); cdecl;
  PyEval_SetTraceAllThreads                      : procedure(func: Py_tracefunc; obj: PPyObject); cdecl;
  PyEval_MergeCompilerFlags                      : function(cf: PPyCompilerFlags): integer; cdecl;

  {* include/sysmodule.h *}
  PySys_GetAttr                                  : function(name_: PPyObject): PPyObject; cdecl;                               //****** 3.15.0 ******
  PySys_GetAttrString                            : function(const name_: PAnsiChar): PPyObject; cdecl;                         //****** 3.15.0 ******
  PySys_GetOptionalAttr                          : function(name_: PPyObject; out result_: PPyObject): integer; cdecl;         //****** 3.15.0 ******
  PySys_GetOptionalAttrString                    : function(const name_: PAnsiChar; out result_: PPyObject): integer; cdecl;   //****** 3.15.0 ******
  PySys_GetObject                                : function(const name_: PAnsiChar): PPyObject; cdecl;
  PySys_SetObject                                : function(const name_: PAnsiChar; v: PPyObject): integer; cdecl;
  PySys_WriteStdout                              : procedure(const format: PAnsiChar {; ...}); cdecl varargs;
  PySys_WriteStderr                              : procedure(const format: PAnsiChar {; ...}); cdecl varargs;
  PySys_FormatStdout                             : procedure(const format: PAnsiChar {; ...}); cdecl varargs;
  PySys_FormatStderr                             : procedure(const format: PAnsiChar {; ...}); cdecl varargs;
  PySys_GetXOptions                              : function(): PPyObject; cdecl;

  {* include/audit.h  include/cpython/audit.h *}
  PySys_Audit                                    : function(const event, argFormat: PAnsiChar {; ...}): integer; cdecl varargs;
  PySys_AuditTuple                               : function(const event: PAnsiChar; args: PPyObject): integer; cdecl;
  PySys_AddAuditHook                             : function(hook: Py_AuditHookFunction; userData: Pointer): integer; cdecl;

  {* include/osmodule.h *}
  PyOS_FSPath                                    : function(path: PPyObject): PPyObject; cdecl;

  {* include/intrcheck.h *}
  PyOS_InterruptOccurred                         : function(): integer; cdecl;

  {* include/import.h  include/cpython/import.h *}
  PyImport_GetMagicNumber                        : function(): C_Long; cdecl;
  PyImport_GetMagicTag                           : function(): PAnsiChar; cdecl;
  PyImport_ExecCodeModule                        : function(const name_: PAnsiChar; co: PPyObject): PPyObject; cdecl;
  PyImport_ExecCodeModuleEx                      : function(const name_: PAnsiChar; co: PPyObject; const pathname: PAnsiChar): PPyObject; cdecl;
  PyImport_ExecCodeModuleWithPathnames           : function(const name_: PAnsiChar; co: PPyObject; const pathname, cpathname: PAnsiChar): PPyObject; cdecl;
  PyImport_ExecCodeModuleObject                  : function(name_, co, pathname, cpathname: PPyObject): PPyObject; cdecl;
  PyImport_GetModuleDict                         : function(): PPyObject; cdecl;
  PyImport_GetModule                             : function(name_: PPyObject): PPyObject; cdecl;
  PyImport_AddModuleObject                       : function(name_: PPyObject): PPyObject; cdecl;
  PyImport_AddModule                             : function(const name_: PAnsiChar): PPyObject; cdecl;
  PyImport_AddModuleRef                          : function(const name_: PAnsiChar): PPyObject; cdecl;
  PyImport_ImportModule                          : function(const name_: PAnsiChar): PPyObject; cdecl;
  PyImport_ImportModuleLevel                     : function(const name_: PAnsiChar; globals, locals, fromlist: PPyObject; level: integer): PPyObject; cdecl;
  PyImport_ImportModuleLevelObject               : function(name_, globals, locals, fromlist: PPyObject; level: integer): PPyObject; cdecl;
  PyImport_GetImporter                           : function(path: PPyObject): PPyObject; cdecl;
  PyImport_Import                                : function(name_: PPyObject): PPyObject; cdecl;
  PyImport_ReloadModule                          : function(m: PPyObject): PPyObject; cdecl;
  PyImport_ImportFrozenModuleObject              : function(name_: PPyObject): integer; cdecl;
  PyImport_ImportFrozenModule                    : function(const name_: PAnsiChar): integer; cdecl;
  PyImport_AppendInittab                         : function(const name_: PAnsiChar; initfunc_: initfunc): integer; cdecl;
  PyImport_SetLazyImportsMode                    : function(mode: PyImport_LazyImportsMode): integer; cdecl;             //****** 3.15.0 ******
  PyImport_SetLazyImportsFilter                  : function(filter: PPyObject): integer; cdecl;                          //****** 3.15.0 ******
  PyImport_GetLazyImportsMode                    : function(): PyImport_LazyImportsMode; cdecl;                          //****** 3.15.0 ******
  PyImport_GetLazyImportsFilter                  : function(): PPyObject; cdecl;                                         //****** 3.15.0 ******
  PyImport_Inittab                               : P_inittab;
  PyImport_ExtendInittab                         : function(newtab: P_inittab): integer; cdecl;
  PyImport_CreateModuleFromInitfunc              : function(spec: PPyObject; initfunc_: initfunc): PPyObject; cdecl;     //****** 3.15.0 ******
  PyImport_FrozenModules                         : P_frozen;
  PyImport_ImportModuleAttr                      : function(mod_name, attr_name: PPyObject): PPyObject; cdecl;
  PyImport_ImportModuleAttrString                : function(const mod_name, attr_name: PAnsiChar): PPyObject; cdecl;

  {* include/abstract.h  include/cpython/abstract.h *}
  PyObject_CallNoArgs                            : function(callable: PPyObject): PPyObject; cdecl;
  PyObject_Call                                  : function(callable, args, kwargs: PPyObject): PPyObject; cdecl;
  PyObject_CallObject                            : function(callable, args: PPyObject): PPyObject; cdecl;
  PyObject_CallFunction                          : function(callable: PPyObject; const format: PAnsiChar {; ...}): PPyObject; cdecl varargs;
  PyObject_CallMethod                            : function(obj: PPyObject; const name_, format: PAnsiChar {; ...}): PPyObject; cdecl varargs;
  PyObject_CallFunctionObjArgs                   : function(callable: PPyObject {; ...}): PPyObject; cdecl varargs;
  PyObject_CallMethodObjArgs                     : function(obj, name_: PPyObject {; ...}): PPyObject; cdecl varargs;
  PyVectorcall_NARGS                             : function(nargsf: NativeUInt): Py_ssize_t; cdecl;
  PyVectorcall_Call                              : function(callable, tuple, dict: PPyObject): PPyObject; cdecl;
  PyObject_Vectorcall                            : function(callable: PPyObject; args: PPPyObject; nargsf: NativeUInt; kwnames: PPyObject): PPyObject; cdecl;
  PyObject_VectorcallMethod                      : function(name: PPyObject; args: PPPyObject; nargsf: NativeUInt; kwnames: PPyObject): PPyObject; cdecl;
  PyObject_Type                                  : function(o: PPyObject): PPyObject; cdecl;
  PyObject_Size                                  : function(o: PPyObject): Py_ssize_t; cdecl;
  PyObject_Length                                : function(o: PPyObject): Py_ssize_t; cdecl;
  PyObject_GetItem                               : function(o, key: PPyObject): PPyObject; cdecl;
  PyObject_SetItem                               : function(o, key, v: PPyObject): integer; cdecl;
  PyObject_DelItemString                         : function(o: PPyObject; const key: PAnsiChar): integer; cdecl;
  PyObject_DelItem                               : function(o, key: PPyObject): integer; cdecl;
  PyObject_Format                                : function(obj, format_spec: PPyObject): PPyObject; cdecl;
  PyObject_GetIter                               : function(obj: PPyObject): PPyObject; cdecl;
  PyObject_GetAIter                              : function(obj: PPyObject): PPyObject; cdecl;
  PyIter_Check                                   : function(obj: PPyObject): integer; cdecl;
  PyAIter_Check                                  : function(obj: PPyObject): integer; cdecl;
  PyIter_NextItem                                : function(iter: PPyObject; out item: PPyObject): integer; cdecl;
  PyIter_Next                                    : function(obj: PPyObject): PPyObject; cdecl;
  PyIter_Send                                    : function(iter, arg: PPyObject; out presult: PPyObject): PySendResult; cdecl;
  PyNumber_Check                                 : function(o: PPyObject): integer; cdecl;
  PyNumber_Add                                   : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_Subtract                              : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_Multiply                              : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_MatrixMultiply                        : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_FloorDivide                           : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_TrueDivide                            : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_Remainder                             : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_Divmod                                : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_Power                                 : function(o1, o2, o3: PPyObject): PPyObject; cdecl;
  PyNumber_Negative                              : function(o: PPyObject): PPyObject; cdecl;
  PyNumber_Positive                              : function(o: PPyObject): PPyObject; cdecl;
  PyNumber_Absolute                              : function(o: PPyObject): PPyObject; cdecl;
  PyNumber_Invert                                : function(o: PPyObject): PPyObject; cdecl;
  PyNumber_Lshift                                : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_Rshift                                : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_And                                   : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_Xor                                   : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_Or                                    : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyIndex_Check                                  : function(o: PPyObject): integer; cdecl;
  PyNumber_Index                                 : function(o: PPyObject): PPyObject; cdecl;
  PyNumber_AsSsize_t                             : function(o, exc: PPyObject): Py_ssize_t; cdecl;
  PyNumber_Long                                  : function(o: PPyObject): PPyObject; cdecl;
  PyNumber_Float                                 : function(o: PPyObject): PPyObject; cdecl;
  PyNumber_InPlaceAdd                            : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_InPlaceSubtract                       : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_InPlaceMultiply                       : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_InPlaceMatrixMultiply                 : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_InPlaceFloorDivide                    : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_InPlaceTrueDivide                     : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_InPlaceRemainder                      : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_InPlacePower                          : function(o1, o2, o3: PPyObject): PPyObject; cdecl;
  PyNumber_InPlaceLshift                         : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_InPlaceRshift                         : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_InPlaceAnd                            : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_InPlaceXor                            : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_InPlaceOr                             : function(o1, o2: PPyObject): PPyObject; cdecl;
  PyNumber_ToBase                                : function(n: PPyObject; base: integer): PPyObject; cdecl;
  PySequence_Check                               : function(o: PPyObject): integer; cdecl;
  PySequence_Size                                : function(o: PPyObject): Py_ssize_t; cdecl;
  PySequence_Length                              : function(o: PPyObject): Py_ssize_t; cdecl;
  PySequence_Concat                              : function(o1, o2: PPyObject): PPyObject; cdecl;
  PySequence_Repeat                              : function(o: PPyObject; count: Py_ssize_t): PPyObject; cdecl;
  PySequence_GetItem                             : function(o: PPyObject; i: Py_ssize_t): PPyObject; cdecl;
  PySequence_GetSlice                            : function(o: PPyObject; i1, i2: Py_ssize_t): PPyObject; cdecl;
  PySequence_SetItem                             : function(o: PPyObject; i: Py_ssize_t; v: PPyObject): integer; cdecl;
  PySequence_DelItem                             : function(o: PPyObject; i: Py_ssize_t): integer; cdecl;
  PySequence_SetSlice                            : function(o: PPyObject; i1, i2: Py_ssize_t; v: PPyObject): integer; cdecl;
  PySequence_DelSlice                            : function(o: PPyObject; i1, i2: Py_ssize_t): integer; cdecl;
  PySequence_Tuple                               : function(o: PPyObject): PPyObject; cdecl;
  PySequence_List                                : function(o: PPyObject): PPyObject; cdecl;
  PySequence_Fast                                : function(o: PPyObject; const m: PAnsiChar): PPyObject; cdecl;
  PySequence_Count                               : function(o, value: PPyObject): Py_ssize_t; cdecl;
  PySequence_Contains                            : function(o, value: PPyObject): integer; cdecl;
  PySequence_In                                  : function(o, value: PPyObject): integer; cdecl;
  PySequence_Index                               : function(o, value: PPyObject): Py_ssize_t; cdecl;
  PySequence_InPlaceConcat                       : function(o1, o2: PPyObject): PPyObject; cdecl;
  PySequence_InPlaceRepeat                       : function(o: PPyObject; count: Py_ssize_t): PPyObject; cdecl;
  PyMapping_Check                                : function(o: PPyObject): integer; cdecl;
  PyMapping_Size                                 : function(o: PPyObject): Py_ssize_t; cdecl;
  PyMapping_Length                               : function(o: PPyObject): Py_ssize_t; cdecl;
  PyMapping_HasKeyString                         : function(o: PPyObject; const key: PAnsiChar): integer; cdecl;
  PyMapping_HasKey                               : function(o, key: PPyObject): integer; cdecl;
  PyMapping_HasKeyWithError                      : function(o, key: PPyObject): integer; cdecl;
  PyMapping_HasKeyStringWithError                : function(o: PPyObject; const key: PAnsiChar): integer; cdecl;
  PyMapping_Keys                                 : function(o: PPyObject): PPyObject; cdecl;
  PyMapping_Values                               : function(o: PPyObject): PPyObject; cdecl;
  PyMapping_Items                                : function(o: PPyObject): PPyObject; cdecl;
  PyMapping_GetItemString                        : function(o: PPyObject; const key: PAnsiChar): PPyObject; cdecl;
  PyMapping_GetOptionalItem                      : function(obj, key: PPyObject; out result_: PPyObject): integer; cdecl;
  PyMapping_GetOptionalItemString                : function(obj: PPyObject; const key: PAnsiChar; out result_: PPyObject): integer; cdecl;
  PyMapping_SetItemString                        : function(o: PPyObject; const key: PAnsiChar; v: PPyObject): integer; cdecl;
  PyObject_IsInstance                            : function(inst, cls: PPyObject): integer; cdecl;
  PyObject_IsSubclass                            : function(derived, cls: PPyObject): integer; cdecl;
  PyVectorcall_Function                          : function(callable: PPyObject): vectorcallfunc; cdecl;
  PyObject_VectorcallDict                        : function(callable: PPyObject; args: PPPyObject; nargsf: NativeUInt; kwargs: PPyObject): PPyObject; cdecl;
  PyObject_CallOneArg                            : function(callable, arg: PPyObject): PPyObject; cdecl;
  PyObject_LengthHint                            : function(o: PPyObject; defaultvalue: Py_ssize_t): Py_ssize_t; cdecl;

  {* include/bltinmodule.h *}
  PyFilter_Type                                  : PPyTypeObject;
  PyMap_Type                                     : PPyTypeObject;
  PyZip_Type                                     : PPyTypeObject;

  {* include/cpython/pyctype.h *}
  {* include/pystrtod.h *}
  PyOS_string_to_double                          : function(const str: PAnsiChar; endptr: PPAnsiChar; overflow_exception: PPyObject): double; cdecl;
  PyOS_double_to_string                          : function(val: double; format_code: AnsiChar; precision, flags: integer; out type_: integer): PAnsiChar; cdecl;

  {* include/pystrcmp.h *}
  PyOS_mystrnicmp                                : function(const str1, str2: PAnsiChar; size_: Py_ssize_t): integer; cdecl;
  PyOS_mystricmp                                 : function(const str1, str2: PAnsiChar): integer; cdecl;

  {* include/fileutils.h  include/cpython/fileutils.h *}
  Py_DecodeLocale                                : function(const arg: PAnsiChar; size_: PNativeUInt): PWCharT; cdecl;
  Py_EncodeLocale                                : function(const text: PWCharT; error_pos: PNativeUInt): PAnsiChar; cdecl;
  Py_fopen                                       : function(path: PPyObject; const mode: PAnsiChar): PFILE; cdecl;
  Py_fclose                                      : function(file_: PFILE): integer; cdecl;

  {* include/cpython/pyfpe.h *}
  {* include/cpython/tracemalloc.h *}
  PyTraceMalloc_Track                            : function(domain: cardinal; ptr: Py_uintptr_t; size_: NativeUInt): integer; cdecl;
  PyTraceMalloc_Untrack                          : function(domain: cardinal; ptr: Py_uintptr_t): integer; cdecl;

  {* include/frameobject.h  include/cpython/frameobject.h *}
  PyFrame_New                                    : function(tstate: PPyThreadState; code: PPyCodeObject; globals, locals: PPyObject): PPyFrameObject; cdecl;
  PyFrame_LocalsToFast                           : procedure(f: PPyFrameObject; clear: integer); cdecl;
  PyFrame_FastToLocalsWithError                  : function(f: PPyFrameObject): integer; cdecl;
  PyFrame_FastToLocals                           : procedure(f: PPyFrameObject); cdecl;

  {* include/datetime.h *}

  {* include/marshal.h  include/cpython/marshal.h *}
  PyMarshal_ReadObjectFromString                 : function(const data: PAnsiChar; len: Py_ssize_t): PPyObject; cdecl;
  PyMarshal_WriteObjectToString                  : function(value: PPyObject; version: integer): PPyObject; cdecl;
  PyMarshal_ReadLongFromFile                     : function(file_: PFILE): C_Long; cdecl;
  PyMarshal_ReadShortFromFile                    : function(file_: PFILE): integer; cdecl;
  PyMarshal_ReadObjectFromFile                   : function(file_: PFILE): PPyObject; cdecl;
  PyMarshal_ReadLastObjectFromFile               : function(file_: PFILE): PPyObject; cdecl;
  PyMarshal_WriteLongToFile                      : procedure(value: C_Long; file_: PFILE; version: integer); cdecl;
  PyMarshal_WriteObjectToFile                    : procedure(value: PPyObject; file_: PFILE; version: integer); cdecl;


implementation

end.
