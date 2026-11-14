unit uP4P.Py;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils,
  {$ELSE}
    Classes, SysUtils,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject;

type
  /// <summary>
  /// <para>Helper for all the Py_* functions.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/object.html#object-protocol">See the article about the Object Protocol.</see></para>
  /// </remarks>
  TPy = class
    public
      /// <summary>
      /// <para>Print a fatal error message and kill the process. No cleanup is
      /// performed. This function should only be invoked when a condition is
      /// detected that would make it dangerous to continue using the Python
      /// interpreter; e.g., when the object administration appears to be
      /// corrupted. On Unix, the standard C library function abort() is called
      /// which will attempt to produce a core file.</para>
      /// <para>The TPy.FatalError() function is replaced with a macro which
      /// logs automatically the name of the current function, unless the
      /// Py_LIMITED_API macro is defined.</para>
      /// <para>Changed in version 3.9: Log the function name automatically.</para>
      /// </summary>
      class procedure FatalError(const message_: string);
      /// <summary>
      /// <para>TPy.UniversalNewlineFgets is an fgets variation that understands
      /// all of \r, \n and \r\n conventions.</para>
      /// <para>The stream should be opened in binary mode.</para>
      /// <para>Note that we need no error handling: fgets() treats error and
      /// eof identically.</para>
      /// </summary>
      class function  UniversalNewlineFgets(buf: PByte; n: integer; stream: PFILE): PByte;
      /// <summary>
      /// <para>Get the original command line arguments, before Python modified
      /// them.</para>
      /// <para>See also PyConfig.orig_argv member.</para>
      /// </summary>
      class function  GetArgcArgv(var argc: integer; var argv: TStringList): boolean; overload;
      /// <summary>
      /// <para>Get the original command line arguments, before Python modified
      /// them.</para>
      /// <para>See also PyConfig.orig_argv member.</para>
      /// </summary>
      class function  GetArgcArgv(out argc: integer; out argv: PPWCharT): boolean; overload;
      /// <summary>
      /// <para>Initialize Python from the initialization configuration.</para>
      /// <para>Return True on success.</para>
      /// <para>Set an error in config and return False on error.</para>
      /// <para>Set an exit code in config and return False if Python wants to
      /// exit.</para>
      /// <para>See IPyInitConfig.Exitcode for the exit code case.</para>
      /// </summary>
      class function  InitializeFromInitConfig(const initconfig: IPyInitConfig): boolean;
      /// <summary>
      /// <para>Initialize Python from config configuration, as described in
      /// Initialization with PyConfig.</para>
      /// <para>See the Python Initialization Configuration section for details
      /// on pre-initializing the interpreter, populating the runtime
      /// configuration structure, and querying the returned status
      /// structure.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-config">See the Python Initialization Configuration article.</see></para>
      /// </remarks>
      class function  InitializeFromConfig(config: PPyConfig): IPyStatus;
      /// <summary>
      /// <para>Return True when the Python interpreter has been initialized,
      /// False if not. After TPy.FinalizeEx() is called, this returns False
      /// until TPy.Initialize() is called again.</para>
      /// <para>Changed in version 3.15: This function no longer returns true
      /// until initialization has fully completed, including import of the site
      /// module. Previously it could return true while TPy.Initialize() was
      /// still running.</para>
      /// </summary>
      class function  IsInitialized: boolean;
      /// <summary>
      /// <para>Create a GenericAlias object. Equivalent to calling the Python
      /// class types.GenericAlias. The origin and args arguments set the
      /// GenericAlias's __origin__ and __args__ attributes respectively.
      /// origin should be a PyTypeObject*, and args can be a PyTupleObject* or
      /// any PyObject*. If args passed is not a tuple, a 1-tuple is
      /// automatically constructed and __args__ is set to (args,).
      /// Minimal checking is done for the arguments, so the function will
      /// succeed even if origin is not a type. The GenericAlias's
      /// __parameters__ attribute is constructed lazily from __args__.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/library/stdtypes.html#generic-alias-type">See the article about Generic Alias Type.</see></para>
      /// <para>See the TPyGenericAlias class.</para>
      /// </remarks>
      class function  GenericAlias(const origin, args: IPyObject): IPyObject;
      /// <summary>
      /// <para>Test if an object is the True singleton, the same as x is True
      /// in Python.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  IsTrue(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Test if an object is the False singleton, the same as x is False
      /// in Python.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  IsFalse(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Test if an object is the None singleton, the same as x is None
      /// in Python.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  IsNone(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Get the type of the Python object aPyObject.</para>
      /// <para>The returned reference is borrowed from aPyObject.</para>
      /// <para>Do not release it with TPy.DecRef() or similar.</para>
      /// <para>Changed in version 3.11: TPy.Type_() is changed to an inline
      /// static function. The parameter type is no longer const PyObject*.</para>
      /// </summary>
      class function  Type_(const aPyObject: IPyObject): PPyTypeObject; overload;
      /// <summary>
      /// <para>Get the type of the Python object aPyObject.</para>
      /// <para>The returned reference is borrowed from aPyObject.</para>
      /// <para>Do not release it with TPy.DecRef() or similar.</para>
      /// <para>Changed in version 3.11: TPy.Type_() is changed to an inline
      /// static function. The parameter type is no longer const PyObject*.</para>
      /// </summary>
      class function  Type_(obj: PPyObject): PPyTypeObject; overload;
      /// <summary>
      /// <para>Return non-zero if the object o type is aPyTypeObject.
      /// Return zero otherwise.</para>
      /// </summary>
      class function  IsType(o: PPyObject; aPyTypeObject: PPyTypeObject): boolean; overload;
      /// <summary>
      /// <para>Return non-zero if the object o type is aPyTypeObject.
      /// Return zero otherwise.</para>
      /// </summary>
      class function  IsType(const o: IPyObject; aPyTypeObject: PPyTypeObject): boolean; overload;
      /// <summary>
      /// <para>Get the reference count of the Python object aPyObject.</para>
      /// <para>Note that the returned value may not actually reflect how many
      /// references to the object are actually held. For example, some objects
      /// are immortal and have a very high refcount that does not reflect the
      /// actual number of references. Consequently, do not rely on the returned
      /// value to be accurate, other than a value of 0 or 1.</para>
      /// <para>Use the TPy.SetRefcnt() procedure to set an object reference
      /// count.</para>
      /// <para>Note On free-threaded builds of Python, returning 1 isn't
      /// sufficient to determine if it's safe to treat o as having no access
      /// by other threads. Use PyUnstable_Object_IsUniquelyReferenced() for
      /// that instead.</para>
      /// <para>Changed in version 3.10: TPy.REFCNT() is changed to the inline
      /// static function.</para>
      /// <para>Changed in version 3.11: The parameter type is no longer const
      /// PyObject*.</para>
      /// </summary>
      class function  RefCnt(const aPyObject: IPyObject): Py_ssize_t;
      /// <summary>
      /// <para>Set the object o reference counter to refcnt.</para>
      /// <para>On Python build with Free Threading, if refcnt is larger than
      /// UINT32_MAX, the object is made immortal.</para>
      /// <para>This function has no effect on immortal objects.</para>
      /// </summary>
      class procedure Set_RefCnt(const aPyObject: IPyObject; refcnt_: Py_ssize_t);
      /// <summary>
      /// <para>Indicate taking a new strong reference to object aPyObject,
      /// indicating it is in use and should not be destroyed.</para>
      /// <para>This function has no effect on immortal objects.</para>
      /// <para>This function is usually used to convert a borrowed reference
      /// to a strong reference in-place. The TPy.NewRef() function can be used
      /// to create a new strong reference.</para>
      /// <para>When done using the object, release is by calling
      /// TPy.DecRef().</para>
      /// <para>The object must not be nil; if you aren't sure that it isn't
      /// nil, use TPy.XINCREF().</para>
      /// <para>Do not expect this function to actually modify aPyObject in any
      /// way. For at least some objects, this function has no effect.</para>
      /// <para>Changed in version 3.12: Immortal objects are not
      /// modified.</para>
      /// </summary>
      class procedure IncRef(const aPyObject: IPyObject); overload;
      /// <summary>
      /// <para>Indicate taking a new strong reference to object aPyObject,
      /// indicating it is in use and should not be destroyed.</para>
      /// <para>This function has no effect on immortal objects.</para>
      /// <para>This function is usually used to convert a borrowed reference
      /// to a strong reference in-place. The TPy.NewRef() function can be used
      /// to create a new strong reference.</para>
      /// <para>When done using the object, release is by calling
      /// TPy.DecRef().</para>
      /// <para>The object must not be nil; if you aren't sure that it isn't
      /// nil, use TPy.XINCREF().</para>
      /// <para>Do not expect this function to actually modify aPyObject in any
      /// way. For at least some objects, this function has no effect.</para>
      /// <para>Changed in version 3.12: Immortal objects are not
      /// modified.</para>
      /// </summary>
      class procedure IncRef(const aPyObject: PPyObject); overload;
      /// <summary>
      /// <para>Release a strong reference to object aPyObject, indicating the
      /// reference is no longer used.</para>
      /// <para>This function has no effect on immortal objects.</para>
      /// <para>Once the last strong reference is released (i.e. the object's
      /// reference count reaches 0), the object's type's deallocation function
      /// (which must not be nil) is invoked.</para>
      /// <para>This function is usually used to delete a strong reference
      /// before exiting its scope.</para>
      /// <para>The object must not be nil; if you aren't sure that it isn't
      /// nil, use TPy.XDECREF().</para>
      /// <para>Do not expect this function to actually modify aPyObject in any
      /// way. For at least some objects, this function has no effect.</para>
      /// <para>Warning The deallocation function can cause arbitrary Python
      /// code to be invoked (e.g. when a class instance with a __del__() method
      /// is deallocated). While exceptions in such code are not propagated, the
      /// executed code has free access to all Python global variables. This
      /// means that any object that is reachable from a global variable should
      /// be in a consistent state before TPy.DecRef() is invoked. For example,
      /// code to delete an object from a list should copy a reference to the
      /// deleted object in a temporary variable, update the list data
      /// structure, and then call TPy.DecRef() for the temporary variable.</para>
      /// <para>Changed in version 3.12: Immortal objects are not modified.</para>
      /// </summary>
      class procedure DecRef(const aPyObject: IPyObject); overload;
      /// <summary>
      /// <para>Release a strong reference to object aPyObject, indicating the
      /// reference is no longer used.</para>
      /// <para>This function has no effect on immortal objects.</para>
      /// <para>Once the last strong reference is released (i.e. the object's
      /// reference count reaches 0), the object's type's deallocation function
      /// (which must not be nil) is invoked.</para>
      /// <para>This function is usually used to delete a strong reference
      /// before exiting its scope.</para>
      /// <para>The object must not be nil; if you aren't sure that it isn't
      /// nil, use TPy.XDECREF().</para>
      /// <para>Do not expect this function to actually modify aPyObject in any
      /// way. For at least some objects, this function has no effect.</para>
      /// <para>Warning The deallocation function can cause arbitrary Python
      /// code to be invoked (e.g. when a class instance with a __del__() method
      /// is deallocated). While exceptions in such code are not propagated, the
      /// executed code has free access to all Python global variables. This
      /// means that any object that is reachable from a global variable should
      /// be in a consistent state before TPy.DecRef() is invoked. For example,
      /// code to delete an object from a list should copy a reference to the
      /// deleted object in a temporary variable, update the list data
      /// structure, and then call TPy.DecRef() for the temporary variable.</para>
      /// <para>Changed in version 3.12: Immortal objects are not modified.</para>
      /// </summary>
      class procedure DecRef(const aPyObject: PPyObject); overload;
      /// <summary>
      /// <para>Create a new strong reference to an object: call TPy.INCREF() on
      /// aPyObject and return the object aPyObject.</para>
      /// <para>When the strong reference is no longer needed, TPy.DecRef()
      /// should be called on it to release the reference.</para>
      /// <para>The object aPyObject must not be nil; use XNewRef() if
      /// aPyObject can be nil.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  NewRef(const aPyObject: IPyObject): PPyObject; overload;
      /// <summary>
      /// <para>Create a new strong reference to an object: call TPy.INCREF() on
      /// aPyObject and return the object aPyObject.</para>
      /// <para>When the strong reference is no longer needed, TPy.DecRef()
      /// should be called on it to release the reference.</para>
      /// <para>The object aPyObject must not be nil; use XNewRef() if
      /// aPyObject can be nil.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  NewRef(aPyObject: PPyConfig): PPyObject; overload;
      /// <summary>
      /// <para>Similar to NewRef(), but the object aPyObject can be nil.</para>
      /// <para>If the object aPyObject is nil, the function just returns
      /// nil.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  XNewRef(const aPyObject: IPyObject): PPyObject; overload;
      /// <summary>
      /// <para>Similar to NewRef(), but the object aPyObject can be nil.</para>
      /// <para>If the object aPyObject is nil, the function just returns
      /// nil.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  XNewRef(aPyObject: PPyConfig): PPyObject; overload;
      /// <summary>
      /// <para>Test if the x object is the y object, the same as x is y in
      /// Python.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  Is_(const x, y: IPyObject): boolean; overload;
      /// <summary>
      /// <para>Test if the x object is the y object, the same as x is y in
      /// Python.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      class function  Is_(const x, y: PPyObject): boolean; overload;
      /// <summary>
      /// <para>Get a strong reference to a constant.</para>
      /// <para>Set an exception and return nil if constant_id is invalid.</para>
      /// <para>constant_id must be one of the Py_CONSTANT_* constant
      /// identifiers.</para>
      /// <para>Added in version 3.13.</para>
      /// <para>CPython implementation detail: In CPython, all of these
      /// constants are immortal.</para>
      /// </summary>
      class function  GetConstant(constant_id: cardinal): IPyObject;
      /// <summary>
      /// <para>Similar to GetConstant(), but return a borrowed reference.</para>
      /// <para>This function is primarily intended for backwards
      /// compatibility: using GetConstant() is recommended for new code.</para>
      /// <para>The reference is borrowed from the interpreter, and is valid
      /// until the interpreter finalization.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function  GetConstantBorrowed(constant_id: cardinal): IPyObject;
      /// <summary>
      /// <para>Called at the beginning of the tp_repr implementation to detect
      /// cycles.</para>
      /// <para>If the object has already been processed, the function returns
      /// a positive integer. In that case the tp_repr implementation should
      /// return a string object indicating a cycle. As examples, dict objects
      /// return {...} and list objects return [...].</para>
      /// <para>The function will return a negative integer if the recursion
      /// limit is reached. In that case the tp_repr implementation should
      /// typically return nil.</para>
      /// <para>Otherwise, the function returns zero and the tp_repr
      /// implementation can continue normally.</para>
      /// </summary>
      class function  ReprEnter(const aPyObject: IPyObject): Integer;
      /// <summary>
      /// <para>Ends a ReprEnter(). Must be called once for each invocation of
      /// ReprEnter() that returns zero.</para>
      /// </summary>
      class procedure ReprLeave(const aPyObject: IPyObject);
      /// <summary>
      /// <para>This is a simplified interface to CompileStringFlags(),
      /// leaving flags set to nil.</para>
      /// </summary>
      class function  CompileString(const str: string; const filename: string = DEFAULT_COMPILE_FILENAME; start: TPyStartSymbols = ssFile): IPyObject;
      /// <summary>
      /// <para>This is a simplified interface to TPy.CompileStringExFlags()
      /// below, with optimize set to -1.</para>
      /// </summary>
      class function  CompileStringFlags(const str, filename: string; start: TPyStartSymbols; flags: PPyCompilerFlags): IPyObject;
      /// <summary>
      /// <para>Like CompileStringObject(), but filename is a byte string
      /// decoded from the filesystem encoding and error handler.</para>
      /// </summary>
      class function  CompileStringExFlags(const str, filename: string; start: TPyStartSymbols; flags: PPyCompilerFlags; optimize: integer): IPyObject;
      /// <summary>
      /// <para>Parse and compile the Python source code in str, returning the
      /// resulting code object. The start symbol is given by start; this can
      /// be used to constrain the code which can be compiled and should be
      /// available start symbols. The filename specified by filename is used
      /// to construct the code object and may appear in tracebacks or
      /// SyntaxError exception messages. This returns nil if the code cannot
      /// be parsed or compiled.</para>
      /// <para>The integer optimize specifies the optimization level of the
      /// compiler; a value of -1 selects the optimization level of the
      /// interpreter as given by -O options.</para>
      /// <para>Explicit levels are 0 (no optimization; __debug__ is true),
      /// 1 (asserts are removed, __debug__ is false) or
      /// 2 (docstrings are removed too).</para>
      /// </summary>
      class function  CompileStringObject(const str: string; const filename: IPyObject; start: TPyStartSymbols; flags: PPyCompilerFlags; optimize: integer): IPyObject;
      /// <summary>
      /// <para>Initialize the Python interpreter. In an application embedding
      /// Python, this should be called before using any other Python/C API
      /// functions; see Before Python Initialization for the few
      /// exceptions.</para>
      /// <para>This initializes the table of loaded modules (sys.modules), and
      /// creates the fundamental modules builtins, __main__ and sys. It also
      /// initializes the module search path (sys.path). It does not set
      /// sys.argv; use the Python Initialization Configuration API for that.
      /// This is a no-op when called for a second time (without calling
      /// FinalizeEx() first). There is no return value; it is a fatal error if
      /// the initialization fails.</para>
      /// <para>Use InitializeFromConfig() to customize the Python
      /// Initialization Configuration.</para>
      /// <para>Note On Windows, changes the console mode from O_TEXT to
      /// O_BINARY, which will also affect non-Python uses of the console using
      /// the C Runtime.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-config">See the Python Initialization Configuration article.</see></para>
      /// <para><see href="https://docs.python.org/3/c-api/interp-lifecycle.html#pre-init-safe">See the Before Python Initialization article.</see></para>
      /// </remarks>
      class procedure Initialize;
      /// <summary>
      /// <para>This function works like TPy.Initialize() if initsigs is 1. If
      /// initsigs is 0, it skips initialization registration of signal
      /// handlers, which may be useful when CPython is embedded as part of a
      /// larger application.</para>
      /// <para>Use InitializeFromConfig() to customize the Python
      /// Initialization Configuration.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-config">See the Python Initialization Configuration article.</see></para>
      /// <para><see href="https://docs.python.org/3/c-api/interp-lifecycle.html#pre-init-safe">See the Before Python Initialization article.</see></para>
      /// </remarks>
      class procedure InitializeEx(initsigs: integer);
      /// <summary>
      /// <para>This is a backwards-compatible version of FinalizeEx() that
      /// disregards the return value.</para>
      /// </summary>
      class procedure Finalize;
      /// <summary>
      /// <para>Undo all initializations made by Initialize() and subsequent use
      /// of Python/C API functions, and destroy all sub-interpreters
      /// (see NewInterpreter()) that were created and not yet destroyed since
      /// the last call to Initialize(). This is a no-op when called for a
      /// second time (without calling Initialize() again first).</para>
      /// <para>Since this is the reverse of Initialize(), it should be called
      /// in the same thread with the same interpreter active. That means the
      /// main thread and the main interpreter. This should never be called
      /// while RunMain() is running.</para>
      /// <para>Normally the return value is True. If there were errors during
      /// finalization (flushing buffered data), False is returned.</para>
      /// <para>Note that Python will do a best effort at freeing all memory
      /// allocated by the Python interpreter. Therefore, any C-Extension should
      /// make sure to correctly clean up all of the previously allocated
      /// PyObjects before using them in subsequent calls to Initialize().
      /// Otherwise it could introduce vulnerabilities and incorrect
      /// behavior.</para>
      /// <para>This function is provided for a number of reasons. An embedding
      /// application might want to restart Python without having to restart the
      /// application itself. An application that has loaded the Python
      /// interpreter from a dynamically loadable library (or DLL) might want to
      /// free all memory allocated by Python before unloading the DLL. During a
      /// hunt for memory leaks in an application a developer might want to free
      /// all memory allocated by Python before exiting from the
      /// application.</para>
      /// <para>Bugs and caveats: The destruction of modules and objects in
      /// modules is done in random order; this may cause destructors
      /// (__del__() methods) to fail when they depend on other objects
      /// (even functions) or modules. Dynamically loaded extension modules
      /// loaded by Python are not unloaded. Small amounts of memory allocated
      /// by the Python interpreter may not be freed (if you find a leak, please
      /// report it). Memory tied up in circular references between objects is
      /// not freed. Interned strings will all be deallocated regardless of
      /// their reference count. Some memory allocated by extension modules may
      /// not be freed. Some extensions may not work properly if their
      /// initialization routine is called more than once; this can happen if an
      /// application calls Initialize() and FinalizeEx() more than once.
      /// FinalizeEx() must not be called recursively from within itself.
      /// Therefore, it must not be called by any code that may be run as part
      /// of the interpreter shutdown process, such as atexit handlers, object
      /// finalizers, or any code that may be run while flushing the stdout and
      /// stderr files.</para>
      /// <para>Raises an auditing event cpython._PySys_ClearAuditHooks with no
      /// arguments.</para>
      /// <para>Added in version 3.6.</para>
      /// </summary>
      class function  FinalizeEx: boolean;
      /// <summary>
      /// <para>Create a new sub-interpreter. This is essentially just a wrapper
      /// around NewInterpreterFromConfig() with a config that preserves the
      /// existing behavior. The result is an unisolated sub-interpreter that
      /// shares the main interpreter's GIL, allows fork/exec, allows daemon
      /// threads, and allows single-phase init modules.</para>
      /// </summary>
      class function  NewInterpreter: IPyThreadState;
      /// <summary>
      /// <para>Destroy the (sub-)interpreter represented by the given thread
      /// state. The given thread state must be attached. When the call returns,
      /// there will be no attached thread state. All thread states associated
      /// with this interpreter are destroyed.</para>
      /// <para>FinalizeEx() will destroy all sub-interpreters that haven't been
      /// explicitly destroyed at that point.</para>
      /// </summary>
      class procedure EndInterpreter(const tstate: IPyThreadState);
      /// <summary>
      /// <para>Register a cleanup function to be called by FinalizeEx().
      /// The cleanup function will be called with no arguments and should
      /// return no value. At most 32 cleanup functions can be registered. When
      /// the registration is successful, AtExit() returns True; on failure, it
      /// returns False. The cleanup function registered last is called first.
      /// Each cleanup function will be called at most once. Since Python's
      /// internal finalization will have completed before the cleanup function,
      /// no Python APIs should be called by func.</para>
      /// </summary>
      class function  AtExit(proc: AtExitProc): boolean;
      /// <summary>
      /// <para>Exit the current process. This calls FinalizeEx() and then calls
      /// the standard C library function exit(status). If FinalizeEx()
      /// indicates an error, the exit status is set to 120.</para>
      /// <para>Changed in version 3.6: Errors from finalization no longer
      /// ignored.</para>
      /// </summary>
      class procedure Exit(status: Integer);
      /// <summary>
      /// <para>The main program for the standard interpreter, encapsulating a
      /// full initialization/finalization cycle, as well as additional
      /// behaviour to implement reading configurations settings from the
      /// environment and command line, and then executing __main__ in
      /// accordance with Command line.</para>
      /// <para>This is made available for programs which wish to support the
      /// full CPython command line interface, rather than just embedding a
      /// Python runtime in a larger application.</para>
      /// <para>The argc and argv parameters are similar to those which are
      /// passed to a C program's main() function, except that the argv entries
      /// are first converted to wchar_t using TPy.DecodeLocale(). It is also
      /// important to note that the argument list entries may be modified to
      /// point to strings other than those passed in (however, the contents of
      /// the strings pointed to by the argument list are not modified).</para>
      /// <para>The return value is 2 if the argument list does not represent a
      /// valid Python command line, and otherwise the same as
      /// TPy.RunMain().</para>
      /// <para>In terms of the CPython runtime configuration APIs documented
      /// in the runtime configuration section (and without accounting for error
      /// handling), TPy.Main is approximately equivalent to:</para>
      /// <code>
      /// PyConfig config;
      /// PyConfig_InitPythonConfig(&config);
      /// PyConfig_SetArgv(&config, argc, argv);
      /// Py_InitializeFromConfig(&config);
      /// PyConfig_Clear(&config);
      /// Py_RunMain();
      /// </code>
      /// <para>In normal usage, an embedding application will call this
      /// function instead of calling TPy.Initialize(), TPy.InitializeEx() or
      /// TPy.InitializeFromConfig() directly, and all settings will be applied
      /// as described elsewhere in this documentation. If this function is
      /// instead called after a preceding runtime initialization API call,
      /// then exactly which environmental and command line configuration
      /// settings will be updated is version dependent (as it depends on which
      /// settings correctly support being modified after they have already
      /// been set once when the runtime was first initialized).</para>
      /// </summary>
      class function  Main(argc: integer; argv: PPWCharT): integer;
      /// <summary>
      /// <para>Similar to TPy.Main() but argv is an array of bytes strings,
      /// allowing the calling application to delegate the text decoding step
      /// to the CPython runtime.</para>
      /// <para>Added in version 3.8.</para>
      /// </summary>
      class function  BytesMain(argc: integer; argv: PPAnsiChar): integer;
      /// <summary>
      /// <para>This API is kept for backward compatibility: setting
      /// PyConfig.program_name should be used instead, see
      /// Python Initialization Configuration.</para>
      /// <para>This function should be called before TPy.Initialize() is called
      /// for the first time, if it is called at all. It tells the interpreter
      /// the value of the argv[0] argument to the main() function of the
      /// program (converted to wide characters). This is used by TPy.GetPath()
      /// and some other functions below to find the Python run-time libraries
      /// relative to the interpreter executable. The default value is 'python'.
      /// The argument should point to a zero-terminated wide character string
      /// in static storage whose contents will not change for the duration of
      /// the program's execution. No code in the Python interpreter will change
      /// the contents of this storage.</para>
      /// <para>Use TPy.DecodeLocale() to decode a bytes string to get a
      /// wchar_t* string.</para>
      /// <para>Deprecated since version 3.11, will be removed in
      /// version 3.15.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-config">See the Python Initialization Configuration article.</see></para>
      /// </remarks>
      class function  SetProgramName(const name_: string): boolean;
      /// <summary>
      /// <para>Return the program name set with PyConfig.program_name, or the
      /// default. The returned string points into static storage; the caller
      /// should not modify its value.</para>
      /// <para>This function should not be called before TPy.Initialize(),
      /// otherwise it returns nil.</para>
      /// <para>Changed in version 3.10: It now returns nil if called before
      /// TPy.Initialize().</para>
      /// <para>Deprecated since version 3.13, will be removed in version 3.15:
      /// Use TPyConfig.executable (sys.executable) instead.</para>
      /// </summary>
      class function  GetProgramName: string;
      /// <summary>
      /// <para>This API is kept for backward compatibility: setting
      /// PyConfig.home should be used instead, see Python Initialization
      /// Configuration.</para>
      /// <para>Set the default "home" directory, that is, the location of the
      /// standard Python libraries. See PYTHONHOME for the meaning of the
      /// argument string.</para>
      /// <para>The argument should point to a zero-terminated character string
      /// in static storage whose contents will not change for the duration of
      /// the program's execution. No code in the Python interpreter will change
      /// the contents of this storage.</para>
      /// <para>Use TPy.DecodeLocale() to decode a bytes string to get a
      /// wchar_t* string.</para>
      /// <para>Deprecated since version 3.11, will be removed in
      /// version 3.15.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-config">See the Python Initialization Configuration article.</see></para>
      /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONHOME">See the article about PYTHONHOME.</see></para>
      /// </remarks>
      class function  SetPythonHome(const home: string): boolean;
      /// <summary>
      /// <para>Return the default "home", that is, the value set by
      /// PyConfig.home, or the value of the PYTHONHOME environment variable if
      /// it is set.</para>
      /// <para>This function should not be called before TPy.Initialize(),
      /// otherwise it returns nil.</para>
      /// <para>Changed in version 3.10: It now returns nil if called before
      /// TPy.Initialize().</para>
      /// <para>Deprecated since version 3.13, will be removed in version 3.15:
      /// Use TPyConfig.home or the PYTHONHOME environment variable
      /// instead.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-config">See the Python Initialization Configuration article.</see></para>
      /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONHOME">See the article about PYTHONHOME.</see></para>
      /// </remarks>
      class function  GetPythonHome: string;
      /// <summary>
      /// <para>Return the full program name of the Python executable; this is
      /// computed as a side-effect of deriving the default module search path
      /// from the program name (set by PyConfig.program_name). The returned
      /// string points into static storage; the caller should not modify its
      /// value. The value is available to Python code as sys.executable.</para>
      /// <para>This function should not be called before TPy.Initialize(),
      /// otherwise it returns nil.</para>
      /// <para>Changed in version 3.10: It now returns nil if called before
      /// TPy.Initialize().</para>
      /// <para>Deprecated since version 3.13, will be removed in version 3.15:
      /// Use TPyConfig.executable (sys.executable) instead.</para>
      /// </summary>
      class function  GetProgramFullPath: string;
      /// <summary>
      /// <para>Return the prefix for installed platform-independent files. This
      /// is derived through a number of complicated rules from the program name
      /// set with PyConfig.program_name and some environment variables; for
      /// example, if the program name is '/usr/local/bin/python', the prefix is
      /// '/usr/local'. The returned string points into static storage; the
      /// caller should not modify its value. This corresponds to the prefix
      /// variable in the top-level Makefile and the --prefix argument to the
      /// configure script at build time. The value is available to Python code
      /// as sys.base_prefix. It is only useful on Unix. See also the next
      /// function.</para>
      /// <para>This function should not be called before TPy.Initialize(),
      /// otherwise it returns nil.</para>
      /// <para>Changed in version 3.10: It now returns nil if called before
      /// TPy.Initialize().</para>
      /// <para>Deprecated since version 3.13, will be removed in version 3.15:
      /// Use TPyConfig.base_prefix (sys.base_prefix) instead.
      /// Use TPyConfig.prefix (sys.prefix) if virtual environments need to be
      /// handled.</para>
      /// </summary>
      class function  GetPrefix: string;
      /// <summary>
      /// <para>Return the exec-prefix for installed platform-dependent files.
      /// This is derived through a number of complicated rules from the
      /// program name set with PyConfig.program_name and some environment
      /// variables; for example, if the program name is
      /// '/usr/local/bin/python', the exec-prefix is '/usr/local'.
      /// The returned string points into static storage; the caller should not
      /// modify its value. This corresponds to the exec_prefix variable in the
      /// top-level Makefile and the --exec-prefix argument to the configure
      /// script at build time. The value is available to Python code as
      /// sys.base_exec_prefix. It is only useful on Unix.</para>
      /// <para>Background: The exec-prefix differs from the prefix when
      /// platform dependent files (such as executables and shared libraries)
      /// are installed in a different directory tree. In a typical
      /// installation, platform dependent files may be installed in the
      /// /usr/local/plat subtree while platform independent may be installed
      /// in /usr/local.</para>
      /// <para>Generally speaking, a platform is a combination of hardware and
      /// software families, e.g. Sparc machines running the Solaris 2.x
      /// operating system are considered the same platform, but Intel machines
      /// running Solaris 2.x are another platform, and Intel machines running
      /// Linux are yet another platform. Different major revisions of the same
      /// operating system generally also form different platforms. Non-Unix
      /// operating systems are a different story; the installation strategies
      /// on those systems are so different that the prefix and exec-prefix are
      /// meaningless, and set to the empty string. Note that compiled Python
      /// bytecode files are platform independent (but not independent from the
      /// Python version by which they were compiled!).</para>
      /// <para>System administrators will know how to configure the mount or
      /// automount programs to share /usr/local between platforms while having
      /// /usr/local/plat be a different filesystem for each platform.</para>
      /// <para>This function should not be called before TPy.Initialize(),
      /// otherwise it returns nil.</para>
      /// <para>Changed in version 3.10: It now returns nil if called before
      /// TPy.Initialize().</para>
      /// <para>Deprecated since version 3.13, will be removed in version 3.15:
      /// Use TPyConfig.base_exec_prefix (sys.base_exec_prefix) instead.
      /// Use TPyConfig.exec_prefix (sys.exec_prefix) if virtual environments
      /// need to be handled.</para>
      /// </summary>
      class function  GetExecPrefix: string;
      /// <summary>
      /// <para>Return the default module search path; this is computed from
      /// the program name (set by PyConfig.program_name) and some environment
      /// variables. The returned string consists of a series of directory
      /// names separated by a platform dependent delimiter character. The
      /// delimiter character is ':' on Unix and macOS, ';' on Windows. The
      /// returned string points into static storage; the caller should not
      /// modify its value. The list sys.path is initialized with this value on
      /// interpreter startup; it can be (and usually is) modified later to
      /// change the search path for loading modules.</para>
      /// <para>This function should not be called before TPy.Initialize(),
      /// otherwise it returns nil.</para>
      /// <para>Changed in version 3.10: It now returns nil if called before
      /// TPy.Initialize().</para>
      /// <para>Deprecated since version 3.13, will be removed in version 3.15:
      /// Use TPyConfig.module_search_paths (sys.path) instead.</para>
      /// </summary>
      class function  GetPath: string;
      /// <summary>
      /// <para>Return the version of this Python interpreter. This is a string
      /// that looks something like</para>
      /// <code>"3.0a5+ (py3k:63103M, May 12 2008, 00:53:55) \n[GCC 4.2.3]"</code>
      /// <para>The first word (up to the first space character) is the current
      /// Python version; the first characters are the major and minor version
      /// separated by a period. The returned string points into static storage;
      /// the caller should not modify its value. The value is available to
      /// Python code as sys.version.</para>
      /// <para>See also the Py_Version constant.</para>
      /// </summary>
      class function  GetVersion: string;
      /// <summary>
      /// <para>Return the platform identifier for the current platform.
      /// On Unix, this is formed from the "official" name of the operating
      /// system, converted to lower case, followed by the major revision
      /// number; e.g., for Solaris 2.x, which is also known as SunOS 5.x,
      /// the value is 'sunos5'. On macOS, it is 'darwin'. On Windows,
      /// it is 'win'. The returned string points into static storage; the
      /// caller should not modify its value. The value is available to Python
      /// code as sys.platform.</para>
      /// </summary>
      class function  GetPlatform: string;
      /// <summary>
      /// <para>Return the official copyright string for the current Python
      /// version, for example</para>
      /// <code>'Copyright 1991-1995 Stichting Mathematisch Centrum, Amsterdam'</code>
      /// <para>The returned string points into static storage; the caller
      /// should not modify its value. The value is available to Python code as
      /// sys.copyright.</para>
      /// </summary>
      class function  GetCopyright: string;
      /// <summary>
      /// <para>Return an indication of the compiler used to build the current
      /// Python version, in square brackets, for example:</para>
      /// <code>"[GCC 2.7.2.2]"</code>
      /// <para>The returned string points into static storage; the caller
      /// should not modify its value. The value is available to Python code as
      /// part of the variable sys.version.</para>
      /// </summary>
      class function  GetCompiler: string;
      /// <summary>
      /// <para>Return information about the sequence number and build date and
      /// time of the current Python interpreter instance, for example</para>
      /// <code>"#67, Aug  1 1997, 22:34:28"</code>
      /// <para>The returned string points into static storage; the caller
      /// should not modify its value. The value is available to Python code as
      /// part of the variable sys.version.</para>
      /// </summary>
      class function  GetBuildInfo: string;
      /// <summary>
      /// <para>Return true if the main Python interpreter is shutting down.
      /// Return false otherwise.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function  IsFinalizing: boolean;
      /// <summary>
      /// <para>Preinitialize Python from preconfig preconfiguration.</para>
      /// <para>preconfig must not be nil.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#preinitialize-python-with-pypreconfig">See the Preinitialize Python with PyPreConfig article.</see></para>
      /// </remarks>
      class function  PreInitialize(const src_config: IPyPreConfig): IPyStatus;
      /// <summary>
      /// <para>Preinitialize Python from preconfig preconfiguration.</para>
      /// <para>Parse argv command line arguments (bytes strings) if parse_argv
      /// of preconfig is non-zero.</para>
      /// <para>preconfig must not be nil.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#preinitialize-python-with-pypreconfig">See the Preinitialize Python with PyPreConfig article.</see></para>
      /// </remarks>
      class function  PreInitializeFromBytesArgs(const src_config: IPyPreConfig; argc: Py_ssize_t; argv: PPAnsiChar): IPyStatus;
      /// <summary>
      /// <para>Preinitialize Python from preconfig preconfiguration.</para>
      /// <para>Parse argv command line arguments (wide strings) if parse_argv
      /// of preconfig is non-zero.</para>
      /// <para>preconfig must not be nil.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#preinitialize-python-with-pypreconfig">See the Preinitialize Python with PyPreConfig article.</see></para>
      /// </remarks>
      class function  PreInitializeFromArgs(const src_config: IPyPreConfig; argc: Py_ssize_t; argv: PPWCharT): IPyStatus;
      /// <summary>
      /// <para>Executes the main module in a fully configured CPython
      /// runtime.</para>
      /// <para>Executes the command (PyConfig.run_command), the script
      /// (PyConfig.run_filename) or the module (PyConfig.run_module) specified
      /// on the command line or in the configuration. If none of these values
      /// are set, runs the interactive Python prompt (REPL) using the __main__
      /// module's global namespace.</para>
      /// <para>If PyConfig.inspect is not set (the default), the return value
      /// will be 0 if the interpreter exits normally (that is, without raising
      /// an exception), the exit status of an unhandled SystemExit, or 1 for
      /// any other unhandled exception.</para>
      /// <para>If PyConfig.inspect is set (such as when the -i option is used),
      /// rather than returning when the interpreter exits, execution will
      /// instead resume in an interactive Python prompt (REPL) using the
      /// __main__ module's global namespace. If the interpreter exited with an
      /// exception, it is immediately raised in the REPL session. The function
      /// return value is then determined by the way the REPL session
      /// terminates: 0, 1, or the status of a SystemExit, as specified
      /// above.</para>
      /// <para>This function always finalizes the Python interpreter before it
      /// returns.</para>
      /// <para>See Python Configuration for an example of a customized Python
      /// that always runs in isolated mode using TPy.RunMain().</para>
      /// </summary>
      class function  RunMain: integer;
      /// <summary>
      /// <para>Call exit(exitcode) if status is an exit. Print the error
      /// message and exit with a non-zero exit code if status is an error.
      /// Must only be called if TPyStatus.IsException is true.</para>
      /// </summary>
      class procedure ExitStatusException(const status: IPyStatus);
      /// <summary>
      /// <para>Return true if the standard I/O file fp with name filename is
      /// deemed interactive. This is the case for files for which
      /// isatty(fileno(fp)) is true. If the PyConfig.interactive is non-zero,
      /// this function also returns true if the filename pointer is nil or if
      /// the name is equal to one of the strings '<stdin>' or '???'.</para>
      /// <para>This function must not be called before Python is
      /// initialized.</para>
      /// </summary>
      class function  FdIsInteractive(file_: PFILE; const filename: string): boolean;
      /// <summary>
      /// <para>Create a new sub-interpreter. This is an (almost) totally
      /// separate environment for the execution of Python code. In particular,
      /// the new interpreter has separate, independent versions of all imported
      /// modules, including the fundamental modules builtins, __main__ and sys.
      /// The table of loaded modules (sys.modules) and the module search path
      /// (sys.path) are also separate. The new environment has no sys.argv
      /// variable. It has new standard I/O stream file objects sys.stdin,
      /// sys.stdout and sys.stderr (however these refer to the same underlying
      /// file descriptors).</para>
      /// <para>The given config controls the options with which the interpreter
      /// is initialized.</para>
      /// <para>Upon success, tstate_p will be set to the first thread state
      /// created in the new sub-interpreter. This thread state is attached.
      /// Note that no actual thread is created; see the discussion of thread
      /// states below. If creation of the new interpreter is unsuccessful,
      /// tstate_p is set to nil; no exception is set since the exception state
      /// is stored in the attached thread state, which might not exist.</para>
      /// <para>Like all other Python/C API functions, an attached thread state
      /// must be present before calling this function, but it might be
      /// detached upon returning. On success, the returned thread state will
      /// be attached. If the sub-interpreter is created with its own GIL then
      /// the attached thread state of the calling interpreter will be detached.
      /// When the function returns, the new interpreter's thread state will be
      /// attached to the current thread and the previous interpreter's
      /// attached thread state will remain detached.</para>
      /// <para>Sub-interpreters are most effective when isolated from each
      /// other, with certain functionality restricted:</para>
      /// <code>
      /// PyInterpreterConfig config = {
      ///     .use_main_obmalloc = 0,
      ///     .allow_fork = 0,
      ///     .allow_exec = 0,
      ///     .allow_threads = 1,
      ///     .allow_daemon_threads = 0,
      ///     .check_multi_interp_extensions = 1,
      ///     .gil = PyInterpreterConfig_OWN_GIL,
      /// };
      /// PyThreadState *tstate = NULL;
      /// PyStatus status = Py_NewInterpreterFromConfig(&tstate, &config);
      /// if (PyStatus_Exception(status)) {
      ///     Py_ExitStatusException(status);
      /// }
      /// </code>
      /// <para>Note that the config is used only briefly and does not get
      /// modified. During initialization the config's values are converted
      /// into various PyInterpreterState values. A read-only copy of the
      /// config may be stored internally on the PyInterpreterState.</para>
      /// <para>Extension modules are shared between (sub-)interpreters as
      /// follows:</para>
      /// <para>- For modules using multi-phase initialization,
      /// e.g. TPyModule.FromDefAndSpec(), a separate module object is created
      /// and initialized for each interpreter. Only C-level static and global
      /// variables are shared between these module objects.</para>
      /// <para>- For modules using legacy single-phase initialization,
      /// e.g. TPyModule.Create(), the first time a particular extension is
      /// imported, it is initialized normally, and a (shallow) copy of its
      /// module's dictionary is squirreled away. When the same extension is
      /// imported by another (sub-)interpreter, a new module is initialized
      /// and filled with the contents of this copy; the extension's init
      /// function is not called. Objects in the module's dictionary thus end up
      /// shared across (sub-)interpreters, which might cause unwanted behavior
      /// (see Bugs and caveats below).</para>
      /// <para>Note that this is different from what happens when an extension
      /// is imported after the interpreter has been completely re-initialized
      /// by calling TPy.FinalizeEx() and TPy.Initialize(); in that case,
      /// the extension's initmodule function is called again. As with
      /// multi-phase initialization, this means that only C-level static and
      /// global variables are shared between these modules.</para>
      /// </summary>
      /// <remarks>
      /// <para>Added in version 3.12.</para>
      /// </remarks>
      class function  NewInterpreterFromConfig(out tstate: IPyThreadState; const config: IPyInterpreterConfig): IPyStatus;
      /// <summary>
      /// <para>Schedule a function to be called from the main interpreter
      /// thread. On success, True is returned and func is queued for being
      /// called in the main thread. On failure, False is returned without
      /// setting any exception.</para>
      /// <para>When successfully queued, func will be eventually called from
      /// the main interpreter thread with the argument arg. It will be called
      /// asynchronously with respect to normally running Python code, but with
      /// both these conditions met:</para>
      /// <code>
      /// - on a bytecode boundary;
      /// - with the main thread holding an attached thread state (func can
      ///   therefore use the full C API).
      /// </code>
      /// <para>func must return 0 on success, or -1 on failure with an
      /// exception set. func won't be interrupted to perform another
      /// asynchronous notification recursively, but it can still be interrupted
      /// to switch threads if the thread state is detached.</para>
      /// <para>This function doesn't need an attached thread state. However,
      /// to call this function in a subinterpreter, the caller must have an
      /// attached thread state. Otherwise, the function func can be scheduled
      /// to be called from the wrong interpreter.</para>
      /// <para>Warning This is a low-level function, only useful for very
      /// special cases. There is no guarantee that func will be called as
      /// quick as possible. If the main thread is busy executing a system call,
      /// func won't be called before the system call returns. This function is
      /// generally not suitable for calling Python code from arbitrary C
      /// threads. Instead, use the PyGILState API.</para>
      /// <para>Added in version 3.1.</para>
      /// <para>Changed in version 3.9: If this function is called in a
      /// subinterpreter, the function func is now scheduled to be called from
      /// the subinterpreter, rather than being called from the main
      /// interpreter. Each subinterpreter now has its own list of scheduled
      /// calls.</para>
      /// <para>Changed in version 3.12: This function now always schedules
      /// func to be run in the main interpreter.</para>
      /// </summary>
      class function  AddPendingCall(func: Py_AddPendingCall_func; arg: pointer): boolean;
      /// <summary>
      /// <para>Execute all pending calls. This is usually executed
      /// automatically by the interpreter.</para>
      /// <para>This function returns True on success, and returns False with
      /// an exception set on failure.</para>
      /// <para>If this is not called in the main thread of the main
      /// interpreter, this function does nothing and returns 0. The caller must
      /// hold an attached thread state.</para>
      /// <para>Added in version 3.1.</para>
      /// <para>Changed in version 3.12: This function only runs pending calls
      /// in the main interpreter.</para>
      /// </summary>
      class function  MakePendingCalls: boolean;
      /// <summary>
      /// <para>Set the recursion limit for the current interpreter.</para>
      /// <para>This function cannot fail, and the caller must hold an attached
      /// thread state.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/library/sys.html#sys.setrecursionlimit">See also sys.setrecursionlimit().</see></para>
      /// </remarks>
      class procedure SetRecursionLimit(new_limit: Integer);
      /// <summary>
      /// <para>Get the recursion limit for the current interpreter. It can be
      /// set with TPy.SetRecursionLimit(). The recursion limit prevents the
      /// Python interpreter stack from growing infinitely.</para>
      /// <para>This function cannot fail, and the caller must hold an attached
      /// thread state.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/library/sys.html#sys.getrecursionlimit">See also sys.getrecursionlimit().</see></para>
      /// </remarks>
      class function  GetRecursionLimit: integer;
      /// <summary>
      /// <para>Marks a point where a recursive C-level call is about to be
      /// performed.</para>
      /// <para>The function then checks if the stack limit is reached. If this
      /// is the case, a RecursionError is set and False is returned.
      /// Otherwise, True is returned.</para>
      /// <para>where_ should be a string such as
      /// " in instance check" to be concatenated to the RecursionError message
      /// caused by the recursion depth limit.</para>
      /// </summary>
      class function  EnterRecursiveCall(const where_: string): boolean;
      /// <summary>
      /// <para>Ends a TPy.EnterRecursiveCall(). Must be called once for each
      /// successful invocation of TPy.EnterRecursiveCall().</para>
      /// </summary>
      class procedure LeaveRecursiveCall;
      /// <summary>
      /// <para>Decode a byte string from the filesystem encoding and error
      /// handler. If the error handler is surrogateescape error handler,
      /// undecodable bytes are decoded as characters in range U+DC80..U+DCFF;
      /// and if a byte sequence can be decoded as a surrogate character,
      /// the bytes are escaped using the surrogateescape error handler instead
      /// of decoding them.</para>
      /// <para>Return a pointer to a newly allocated wide character string,
      /// use TPyMem.RawFree() to free the memory. If size is not nil, write
      /// the number of wide characters excluding the nil character into
      /// size_</para>
      /// <para>Return nil on decoding error or memory allocation error.
      /// size_ is set to (size_t)-1 on memory error or set to (size_t)-2 on
      /// decoding error.</para>
      /// <para>The filesystem encoding and error handler are selected by
      /// IPyConfig.Read(): see filesystem_encoding and filesystem_errors
      /// members of PyConfig.</para>
      /// <para>Decoding errors should never happen, unless there is a bug in
      /// the C library.</para>
      /// <para>Use the TPy.EncodeLocale() function to encode the character
      /// string back to a byte string.</para>
      /// <para>See also The TPyUnicode.DecodeFSDefaultAndSize() and
      /// TPyUnicode.DecodeLocaleAndSize() functions.</para>
      /// <para>Added in version 3.5.</para>
      /// <para>Changed in version 3.7: The function now uses the UTF-8 encoding
      /// in the Python UTF-8 Mode.</para>
      /// <para>Changed in version 3.8: The function now uses the UTF-8 encoding
      /// on Windows if PyPreConfig.legacy_windows_fs_encoding is zero;</para>
      /// <para>Warning: This function should not be called directly: use the
      /// PyConfig API with the IPyConfig.SetBytesString() function which
      /// ensures that Python is preinitialized.</para>
      /// <para>This function must not be called before Python is preinitialized
      /// and so that the LC_CTYPE locale is properly configured: see the
      /// TPy.PreInitialize() function.</para>
      /// </summary>
      class function  DecodeLocale(const arg: PAnsiChar; var size_: NativeUInt): PWCharT;
      /// <summary>
      /// <para>Encode a wide character string to the filesystem encoding and
      /// error handler. If the error handler is surrogateescape error handler,
      /// surrogate characters in the range U+DC80..U+DCFF are converted to
      /// bytes 0x80..0xFF.</para>
      /// <para>Return a pointer to a newly allocated byte string, use
      /// TPyMem.Free() to free the memory. Return nil on encoding error or
      /// memory allocation error.</para>
      /// <para>error_pos is set to (size_t)-1 on success, or set to the index
      /// of the invalid character on encoding error.</para>
      /// <para>The filesystem encoding and error handler are selected by
      /// TPyConfig.Read(): see filesystem_encoding and filesystem_errors
      /// members of PyConfig.</para>
      /// <para>Use the TPy.DecodeLocale() function to decode the bytes string
      /// back to a wide character string.</para>
      /// <para>Warning This function must not be called before Python is
      /// preinitialized and so that the LC_CTYPE locale is properly configured:
      /// see the TPy.PreInitialize() function.</para>
      /// <para>See also The TPyUnicode.EncodeFSDefault() and
      /// TPyUnicode.EncodeLocale() functions.</para>
      /// <para>Added in version 3.5.</para>
      /// <para>Changed in version 3.7: The function now uses the UTF-8 encoding
      /// in the Python UTF-8 Mode.</para>
      /// <para>Changed in version 3.8: The function now uses the UTF-8 encoding
      /// on Windows if PyPreConfig.legacy_windows_fs_encoding is zero.</para>
      /// </summary>
      class function  EncodeLocale(const text: PWCharT; var error_pos: NativeUInt): PAnsiChar;
      /// <summary>
      /// <para>Similar to fopen(), but path is a Python object and an exception
      /// is set on error.</para>
      /// <para>path must be a str object, a bytes object, or a path-like
      /// object.</para>
      /// <para>On success, return the new file pointer. On error, set an
      /// exception and return nil.</para>
      /// <para>The file must be closed by TPy.fclose() rather than calling
      /// directly fclose().</para>
      /// <para>The file descriptor is created non-inheritable (PEP 446).</para>
      /// <para>The caller must have an attached thread state.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function  fopen(const path: IPyObject; const mode: string): PFILE; overload;
      /// <summary>
      /// <para>Similar to fopen(), but path is a Python object and an exception
      /// is set on error.</para>
      /// <para>path must be a str object, a bytes object, or a path-like
      /// object.</para>
      /// <para>On success, return the new file pointer. On error, set an
      /// exception and return nil.</para>
      /// <para>The file must be closed by TPy.fclose() rather than calling
      /// directly fclose().</para>
      /// <para>The file descriptor is created non-inheritable (PEP 446).</para>
      /// <para>The caller must have an attached thread state.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function  fopen(const path, mode: string): PFILE; overload;
      /// <summary>
      /// <para>Close a file that was opened by TPy.fopen().</para>
      /// <para>On success, return 0. On error, return EOF and errno is set to
      /// indicate the error. In either case, any further access (including
      /// another call to TPy.fclose()) to the stream results in undefined
      /// behavior.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function  fclose(file_: PFILE): integer;
      /// <summary>
      /// <para>Like getenv(s), but returns nil if -E was passed on the command
      /// line (see PyConfig.use_environment).</para>
      /// <para>Return the value of the environment variable key as a string if
      /// it exists.</para>
      /// <para>Availability: Unix, Windows.</para>
      /// </summary>
      class function  GetEnv(const key: string): string;
      /// <summary>
      /// <para>Hash a pointer value: process the pointer value as an integer
      /// (cast it to uintptr_t internally). The pointer is not
      /// dereferenced.</para>
      /// <para>The function cannot fail: it cannot return -1.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      class function  HashPointer(const ptr: Pointer): Py_hash_t;
      /// <summary>
      /// <para>Compute and return the hash value of a buffer of len bytes
      /// starting at address ptr. The hash is guaranteed to match that of
      /// bytes, memoryview, and other built-in objects that implement the
      /// buffer protocol.
      /// <para>Use this function to implement hashing for immutable objects
      /// whose tp_richcompare function compares to another object's
      /// buffer.</para>
      /// <para>len must be greater than or equal to 0.</para>
      /// <para>This function always succeeds.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function  HashBuffer(const ptr: Pointer; len: Py_ssize_t): Py_hash_t;
      /// <summary>
      /// <para>Get the ob_size field of o.</para>
      /// </summary>
      class function  Size(const o: IPyObject): Py_ssize_t;
      /// <summary>
      /// <para>Set the ob_size field of o to size_.</para>
      /// </summary>
      class procedure SetSize(const o: IPyObject; size_: Py_ssize_t);
      /// <summary>
      /// <para>Return the given version, encoded as an unsigned 32-bit integer.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/apiabiversion.html#run-time-version">See the article about Run-time version.</see></para>
      /// </remarks>
      class function  PACK_FULL_VERSION(major, minor, micro, release_level, release_serial: integer): cardinal;
      /// <summary>
      /// <para>Equivalent to Py_PACK_FULL_VERSION(major, minor, 0, 0, 0).</para>
      /// <para>The result does not correspond to any Python release, but is
      /// useful in numeric comparisons.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/apiabiversion.html#run-time-version">See the article about Run-time version.</see></para>
      /// </remarks>
      class function  PACK_VERSION(major, minor: integer): cardinal;
      /// <summary>
      /// <para>The Python version as a string.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/apiabiversion.html#run-time-version">See the article about Run-time version.</see></para>
      /// </remarks>
      class function  VERSION(major, minor, micro, release_level, release_serial: integer): string;
      /// <summary>
      /// <para>The Python version as an hexadecimal.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3.15/c-api/apiabiversion.html#run-time-version">See the article about Run-time version.</see></para>
      /// </remarks>
      class function  VERSION_HEX: cardinal;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyStatus, uP4P.PyThreadState,
  uP4P.PyInitConfig, uP4P.PyPreConfig, uP4P.PyUnicode;

class procedure TPy.FatalError(const message_: string);
var
  TempMessage : AnsiString;
begin
  if assigned(Py_FatalError) then
    begin
      TempMessage := StringToPyUTF8(message_);
      Py_FatalError(PAnsiChar(TempMessage));
    end;
end;

class function TPy.UniversalNewlineFgets(buf: PByte; n: integer; stream: PFILE): PByte;
begin
  // The fobj parameter exists solely for legacy reasons and must be nil.
  if assigned(Py_UniversalNewlineFgets) then
    Result := PByte(Py_UniversalNewlineFgets(PAnsiChar(buf), n, stream, nil))
   else
    Result := nil;
end;

class function TPy.GetArgcArgv(out argc: integer; out argv: PPWCharT): boolean;
begin
  if assigned(Py_GetArgcArgv) then
    begin
      Py_GetArgcArgv(argc, argv);
      Result := True;
    end
   else
    Result := False;
end;

class function TPy.GetArgcArgv(var argc: integer; var argv: TStringList): boolean;
var
  TempArgv : PPWCharT;
begin
  Result := GetArgcArgv(argc, TempArgv) and
            WCharTArrayToStringList(TempArgv, argc, argv);
end;

class function TPy.InitializeFromInitConfig(const initconfig: IPyInitConfig): boolean;
begin
  Result := assigned(Py_InitializeFromInitConfig) and
            TPyInitConfig.IsInitialized(initconfig) and
            (Py_InitializeFromInitConfig(initconfig.config) = 0);
end;

class function TPy.InitializeFromConfig(config: PPyConfig): IPyStatus;
begin
  if assigned(Py_InitializeFromConfig) then
    Result := TPyStatus.Create(Py_InitializeFromConfig(config))
   else
    Result := nil;
end;

class function TPy.IsInitialized: boolean;
begin
  Result := assigned(Py_IsInitialized) and
            (Py_IsInitialized() <> 0);
end;

class function TPy.GenericAlias(const origin, args: IPyObject): IPyObject;
begin
  if assigned(Py_GenericAlias) and
     TPyObject.IsInitialized(origin) and
     TPyObject.IsInitialized(args) then
    Result := TPyObject.Wrap(Py_GenericAlias(origin.PyObject, args.PyObject))
   else
    Result := nil;
end;

class function TPy.IsTrue(const aPyObject: IPyObject): boolean;
begin
  Result := assigned(Py_IsTrue) and
            TPyObject.IsInitialized(aPyObject)  and
            (Py_IsTrue(aPyObject.PyObject) <> 0);
end;

class function TPy.IsFalse(const aPyObject: IPyObject): boolean;
begin
  Result := assigned(Py_IsFalse) and
            TPyObject.IsInitialized(aPyObject)  and
            (Py_IsFalse(aPyObject.PyObject) <> 0);
end;

class function TPy.IsNone(const aPyObject: IPyObject): boolean;
begin
  Result := assigned(Py_IsNone) and
            TPyObject.IsInitialized(aPyObject)  and
            (Py_IsNone(aPyObject.PyObject) <> 0);
end;

class function TPy.Type_(obj: PPyObject): PPyTypeObject;
begin
  Result := nil;

  if assigned(obj) then
    begin
      if assigned(Py_Type) then
        Result := Py_Type(obj)
       else
        Result := obj^.ob_type;
    end;
end;

class function TPy.Type_(const aPyObject: IPyObject): PPyTypeObject;
begin
  if assigned(aPyObject) then
    Result := Type_(aPyObject.PyObject)
   else
    Result := nil;
end;

class function TPy.IsType(o: PPyObject; aPyTypeObject: PPyTypeObject): boolean;
begin
  if assigned(o) and
     assigned(aPyTypeObject) then
    begin
      if assigned(Py_IS_TYPE) then
        Result := (Py_IS_TYPE(o, aPyTypeObject) <> 0)
       else
        Result := (Type_(o) = aPyTypeObject);
    end
   else
    Result := False;
end;

class function TPy.IsType(const o: IPyObject; aPyTypeObject: PPyTypeObject): boolean;
begin
  Result := TPyObject.IsInitialized(o) and
            IsType(o.PyObject, aPyTypeObject);
end;

class function TPy.RefCnt(const aPyObject: IPyObject): Py_ssize_t;
begin
  if TPyObject.IsInitialized(aPyObject) and
     assigned(Py_REFCNT) then
    Result := Py_REFCNT(aPyObject.PyObject)
   else
    Result := 0;
end;

class procedure TPy.Set_RefCnt(const aPyObject: IPyObject; refcnt_: Py_ssize_t);
begin
  if TPyObject.IsInitialized(aPyObject) and
     assigned(Py_SET_REFCNT) then
    Py_SET_REFCNT(aPyObject.PyObject, refcnt_);
end;

class procedure TPy.IncRef(const aPyObject: IPyObject);
begin
  if assigned(aPyObject) then
    IncRef(aPyObject.PyObject);
end;

class procedure TPy.IncRef(const aPyObject: PPyObject);
begin
  if assigned(Py_IncRef) and
     assigned(aPyObject) then
    Py_IncRef(aPyObject);
end;

class procedure TPy.DecRef(const aPyObject: IPyObject);
begin
  if assigned(aPyObject) then
    DecRef(aPyObject.PyObject);
end;

class procedure TPy.DecRef(const aPyObject: PPyObject);
begin
  if assigned(Py_DecRef) and
     assigned(aPyObject) then
    Py_DecRef(aPyObject);
end;

class function TPy.NewRef(aPyObject: PPyConfig): PPyObject;
begin
  Result := nil;

  if assigned(aPyObject) then
    begin
      if assigned(Py_NewRef) then
        Result := Py_NewRef(aPyObject)
       else
        if assigned(Py_IncRef) then
          begin
            Py_IncRef(aPyObject);
            Result := aPyObject;
          end;
    end;
end;

class function TPy.NewRef(const aPyObject: IPyObject): PPyObject;
begin
  if assigned(aPyObject) then
    Result := NewRef(aPyObject.PyObject)
   else
    Result := nil;
end;

class function TPy.XNewRef(aPyObject: PPyConfig): PPyObject;
begin
  if assigned(Py_XNewRef) then
    Result := Py_XNewRef(aPyObject)
   else
    Result := nil;
end;

class function TPy.XNewRef(const aPyObject: IPyObject): PPyObject;
begin
  if assigned(aPyObject) then
    Result := XNewRef(aPyObject.PyObject)
   else
    Result := nil;
end;

class function TPy.Is_(const x, y: IPyObject): boolean;
begin
  Result := assigned(x) and
            assigned(y) and
            TPy.Is_(x.PyObject, y.PyObject);
end;

class function TPy.Is_(const x, y: PPyObject): boolean;
begin
  Result := False;

  if assigned(x) and assigned(y) then
    begin
      if assigned(Py_Is) then
        Result := (Py_Is(x, y) <> 0)
       else
        Result := (x = y);
    end;
end;

class function TPy.GetConstant(constant_id: cardinal): IPyObject;
begin
  if assigned(Py_GetConstant) and
     (constant_id in [Py_CONSTANT_FIRST..Py_CONSTANT_LAST]) then
    Result := TPyObject.Wrap(Py_GetConstant(constant_id))
   else
    Result := nil;
end;

class function TPy.GetConstantBorrowed(constant_id: cardinal): IPyObject;
begin
  if assigned(Py_GetConstantBorrowed) and
     (constant_id in [Py_CONSTANT_FIRST..Py_CONSTANT_LAST]) then
    Result := TPyObject.Wrap(Py_GetConstantBorrowed(constant_id), False)
   else
    Result := nil;
end;

class function TPy.ReprEnter(const aPyObject: IPyObject): Integer;
begin
  if assigned(Py_ReprEnter) and
     TPyObject.IsInitialized(aPyObject) then
    Result := Py_ReprEnter(aPyObject.PyObject)
   else
    Result := 0;
end;

class procedure TPy.ReprLeave(const aPyObject: IPyObject);
begin
  if assigned(Py_ReprLeave) and
     TPyObject.IsInitialized(aPyObject) then
    Py_ReprLeave(aPyObject.PyObject);
end;

class function TPy.CompileString(const str, filename: string; start: TPyStartSymbols): IPyObject;
var
  TempString, TempFilename : AnsiString;
begin
  if assigned(Py_CompileString) then
    begin
      TempString   := StringToPyUTF8(str);
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(Py_CompileString(PAnsiChar(TempString), PAnsiChar(TempFilename), PyStartSymbolToInt(start)));
    end
   else
    Result := nil;
end;

class function TPy.CompileStringFlags(const str, filename: string; start: TPyStartSymbols; flags: PPyCompilerFlags): IPyObject;
var
  TempString, TempFilename : AnsiString;
begin
  if assigned(Py_CompileStringFlags) then
    begin
      TempString   := StringToPyUTF8(str);
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(Py_CompileStringFlags(PAnsiChar(TempString), PAnsiChar(TempFilename), PyStartSymbolToInt(start), flags));
    end
   else
    Result := TPy.CompileStringExFlags(str, filename, start, flags, -1);
end;

class function TPy.CompileStringExFlags(const str, filename: string; start: TPyStartSymbols; flags: PPyCompilerFlags; optimize: integer): IPyObject;
var
  TempString, TempFilename : AnsiString;
begin
  if assigned(Py_CompileStringExFlags) then
    begin
      TempString   := StringToPyUTF8(str);
      TempFilename := StringToPyUTF8(filename);
      Result       := TPyObject.Wrap(Py_CompileStringExFlags(PAnsiChar(TempString), PAnsiChar(TempFilename), PyStartSymbolToInt(start), flags, optimize));
    end
   else
    Result := nil;
end;

class function TPy.CompileStringObject(const str: string; const filename: IPyObject; start: TPyStartSymbols; flags: PPyCompilerFlags; optimize: integer): IPyObject;
var
  TempString : AnsiString;
begin
  if assigned(Py_CompileStringObject) and
     TPyObject.IsInitialized(filename) then
    begin
      TempString := StringToPyUTF8(str);
      Result     := TPyObject.Wrap(Py_CompileStringObject(PAnsiChar(TempString), filename.PyObject, PyStartSymbolToInt(start), flags, optimize));
    end
   else
    Result := nil;
end;

class procedure TPy.Initialize;
begin
  if assigned(Py_Initialize) then
    Py_Initialize();
end;

class procedure TPy.InitializeEx(initsigs: integer);
begin
  if assigned(Py_InitializeEx) then
    Py_InitializeEx(initsigs);
end;

class procedure TPy.Finalize;
begin
  if assigned(Py_Finalize) then
    Py_Finalize();
end;

class function TPy.FinalizeEx: boolean;
begin
  Result := assigned(Py_FinalizeEx) and
            (Py_FinalizeEx() = 0);
end;

class function TPy.NewInterpreter: IPyThreadState;
begin
  if assigned(Py_NewInterpreter) then
    Result := TPyThreadState.Wrap(Py_NewInterpreter())
   else
    Result := nil;
end;

class procedure TPy.EndInterpreter(const tstate: IPyThreadState);
begin
  if assigned(Py_EndInterpreter) and
     TPyThreadState.IsInitialized(tstate) then
    Py_EndInterpreter(tstate.UnWrap);
end;

class function TPy.AtExit(proc: AtExitProc): boolean;
begin
  Result := assigned(Py_AtExit) and
            assigned(proc) and
            (Py_AtExit(proc) = 0);
end;

class procedure TPy.Exit(status: Integer);
begin
  if assigned(Py_Exit) then
    Py_Exit(status);
end;

class function TPy.Main(argc: integer; argv: PPWCharT): integer;
begin
  if assigned(Py_Main) then
    Result := Py_Main(argc, argv)
   else
    Result := 0;
end;

class function TPy.BytesMain(argc: integer; argv: PPAnsiChar): integer;
begin
  if assigned(Py_BytesMain) then
    Result := Py_BytesMain(argc, argv)
   else
    Result := 0;
end;

class function TPy.SetProgramName(const name_: string): boolean;
var
  TempName : WCharTString;
begin
  Result := False;
  if assigned(Py_SetProgramName) then
    begin
      TempName := StringToPyWCharTString(name_);
      Py_SetProgramName(PWCharT(TempName));
      Result := True;
    end;
end;

class function TPy.GetProgramName: string;
begin
  if assigned(Py_GetProgramName) then
    Result := PyWCharTStringToString(WCharTString(Py_GetProgramName()))
   else
    Result := '';
end;

class function TPy.SetPythonHome(const home: string): boolean;
var
  TempHome : WCharTString;
begin
  Result := False;
  if assigned(Py_SetPythonHome) then
    begin
      TempHome := StringToPyWCharTString(home);
      Py_SetPythonHome(PWCharT(TempHome));
      Result := True;
    end;
end;

class function TPy.GetPythonHome: string;
begin
  if assigned(Py_GetPythonHome) then
    Result := PyWCharTStringToString(WCharTString(Py_GetPythonHome()))
   else
    Result := '';
end;

class function TPy.GetProgramFullPath: string;
begin
  if assigned(Py_GetProgramFullPath) then
    Result := PyWCharTStringToString(WCharTString(Py_GetProgramFullPath()))
   else
    Result := '';
end;

class function TPy.GetPrefix: string;
begin
  if assigned(Py_GetPrefix) then
    Result := PyWCharTStringToString(WCharTString(Py_GetPrefix()))
   else
    Result := '';
end;

class function TPy.GetExecPrefix: string;
begin
  if assigned(Py_GetExecPrefix) then
    Result := PyWCharTStringToString(WCharTString(Py_GetExecPrefix()))
   else
    Result := '';
end;

class function TPy.GetPath: string;
begin
  if assigned(Py_GetPath) then
    Result := PyWCharTStringToString(WCharTString(Py_GetPath()))
   else
    Result := '';
end;

class function TPy.GetVersion: string;
begin
  if assigned(Py_GetVersion) then
    Result := PyUTF8ToString(Py_GetVersion())
   else
    Result := '';
end;

class function TPy.GetPlatform: string;
begin
  if assigned(Py_GetPlatform) then
    Result := PyUTF8ToString(Py_GetPlatform())
   else
    Result := '';
end;

class function TPy.GetCopyright: string;
begin
  if assigned(Py_GetCopyright) then
    Result := PyUTF8ToString(Py_GetCopyright())
   else
    Result := '';
end;

class function TPy.GetCompiler: string;
begin
  if assigned(Py_GetCompiler) then
    Result := PyUTF8ToString(Py_GetCompiler())
   else
    Result := '';
end;

class function TPy.GetBuildInfo: string;
begin
  if assigned(Py_GetBuildInfo) then
    Result := PyUTF8ToString(Py_GetBuildInfo())
   else
    Result := '';
end;

class function TPy.IsFinalizing: boolean;
begin
  Result := assigned(Py_IsFinalizing) and (Py_IsFinalizing() <> 0);
end;

class function TPy.PreInitialize(const src_config: IPyPreConfig): IPyStatus;
begin
  if assigned(Py_PreInitialize) and
     TPyPreConfig.IsInitialized(src_config) then
    Result := TPyStatus.Create(Py_PreInitialize(src_config.Config))
   else
    Result := nil;
end;

class function TPy.PreInitializeFromBytesArgs(const src_config: IPyPreConfig; argc: Py_ssize_t; argv: PPAnsiChar): IPyStatus;
begin
  if assigned(Py_PreInitializeFromBytesArgs) and
     TPyPreConfig.IsInitialized(src_config) then
    Result := TPyStatus.Create(Py_PreInitializeFromBytesArgs(src_config.Config, argc, argv))
   else
    Result := nil;
end;

class function TPy.PreInitializeFromArgs(const src_config: IPyPreConfig; argc: Py_ssize_t; argv: PPWCharT): IPyStatus;
begin
  if assigned(Py_PreInitializeFromArgs) and
     TPyPreConfig.IsInitialized(src_config) then
    Result := TPyStatus.Create(Py_PreInitializeFromArgs(src_config.Config, argc, argv))
   else
    Result := nil;
end;

class function TPy.RunMain: integer;
begin
  if assigned(Py_RunMain) then
    Result := Py_RunMain()
   else
    REsult := 0;
end;

class procedure TPy.ExitStatusException(const status: IPyStatus);
begin
  if assigned(Py_ExitStatusException) and
     assigned(status) then
    Py_ExitStatusException(status.Status);
end;

class function TPy.FdIsInteractive(file_: PFILE; const filename: string): boolean;
var
  TempFilename : AnsiString;
  TempFilenamePtr : PAnsiChar;
begin
  Result := False;

  if assigned(Py_FdIsInteractive) then
    begin
      if (length(filename) > 0) then
        begin
          TempFilename    := StringToPyUTF8(filename);
          TempFilenamePtr := PAnsiChar(TempFilename);
        end
       else
        TempFilenamePtr := nil;

      Result := (Py_FdIsInteractive(file_, TempFilenamePtr) <> 0);
    end;
end;

class function TPy.NewInterpreterFromConfig(out tstate: IPyThreadState; const config: IPyInterpreterConfig): IPyStatus;
var
  TempState : PPyThreadState;
begin
  if assigned(Py_NewInterpreterFromConfig) and
     assigned(config) then
    begin
      TempState := nil;
      Result    := TPyStatus.Create(Py_NewInterpreterFromConfig(TempState, config.Config));
      tstate    := TPyThreadState.Wrap(TempState);
    end
   else
    Result := nil;
end;

class function TPy.AddPendingCall(func: Py_AddPendingCall_func; arg: pointer): boolean;
begin
  Result := assigned(Py_AddPendingCall) and
            (Py_AddPendingCall(func, arg) = 0);
end;

class function TPy.MakePendingCalls: boolean;
begin
  Result := assigned(Py_MakePendingCalls) and
            (Py_MakePendingCalls() = 0);
end;

class procedure TPy.SetRecursionLimit(new_limit: Integer);
begin
  if assigned(Py_SetRecursionLimit) then
    Py_SetRecursionLimit(new_limit);
end;

class function TPy.GetRecursionLimit: integer;
begin
  if assigned(Py_GetRecursionLimit) then
    Result := Py_GetRecursionLimit()
   else
    Result := 0;
end;

class function TPy.EnterRecursiveCall(const where_: string): boolean;
var
  TempWhere : AnsiString;
begin
  if assigned(Py_EnterRecursiveCall) then
    begin
      TempWhere := StringToPyUTF8(where_);
      Result    := (Py_EnterRecursiveCall(PAnsiChar(TempWhere)) = 0);
    end
   else
    Result := False;
end;

class procedure TPy.LeaveRecursiveCall;
begin
  if assigned(Py_LeaveRecursiveCall) then
    Py_LeaveRecursiveCall();
end;

class function TPy.DecodeLocale(const arg: PAnsiChar; var size_: NativeUInt): PWCharT;
begin
  if assigned(Py_DecodeLocale) then
    Result := Py_DecodeLocale(arg, @size_)
   else
    Result := nil;
end;

class function TPy.EncodeLocale(const text: PWCharT; var error_pos: NativeUInt): PAnsiChar;
begin
  if assigned(Py_EncodeLocale) then
    Result := Py_EncodeLocale(text, @error_pos)
   else
    Result := nil;
end;

class function TPy.fopen(const path: IPyObject; const mode: string): PFILE;
var
  TempMode : AnsiString;
begin
  if assigned(Py_fopen) and
     TPyObject.IsInitialized(path) then
    begin
      TempMode := StringToPyUTF8(mode);
      Result   := Py_fopen(path.PyObject, PAnsiChar(TempMode));
    end
   else
    Result := nil;
end;

class function TPy.fopen(const path, mode: string): PFILE;
var
  TempPath : IPyObject;
begin
  Result := nil;

  if (length(path) > 0) and FileExists(path) then
    try
      TempPath := TPyUnicode.FromString(path);
      Result   := fopen(TempPath, mode);
    finally
      TempPath := nil;
    end;
end;

class function TPy.fclose(file_: PFILE): integer;
begin
  if assigned(Py_fclose) and
     assigned(file_) then
    Result := Py_fclose(file_)
   else
    Result := 0;
end;

class function TPy.GetEnv(const key: string): string;
var
  TempKey : AnsiString;
begin
  if assigned(Py_GETENV) then
    begin
      TempKey := StringToPyUTF8(key);
      Result  := PyUTF8ToString(Py_GETENV(PAnsiChar(TempKey)));
    end
   else
    Result := '';
end;

class function TPy.HashPointer(const ptr: Pointer): Py_hash_t;
begin
  if assigned(Py_HashPointer) then
    Result := Py_HashPointer(ptr)
   else
    Result := -1;
end;

class function TPy.HashBuffer(const ptr: Pointer; len: Py_ssize_t): Py_hash_t;
begin
  if assigned(Py_HashBuffer) then
    Result := Py_HashBuffer(ptr, len)
   else
    Result := -1;
end;

class function TPy.Size(const o: IPyObject): Py_ssize_t;
begin
  if assigned(Py_SIZE) and
     TPyObject.IsInitialized(o) then
    Result := Py_SIZE(o.PyObject)
   else
    Result := 0;
end;

class procedure TPy.SetSize(const o: IPyObject; size_: Py_ssize_t);
begin
  if assigned(Py_SET_SIZE) and
     TPyObject.IsInitialized(o) then
    Py_SET_SIZE(PPyVarObject(o.PyObject), size_);
end;

class function TPy.PACK_FULL_VERSION(major, minor, micro, release_level, release_serial: integer): cardinal;
begin
  if assigned(Py_PACK_FULL_VERSION) then
    Result := Py_PACK_FULL_VERSION(major, minor, micro, release_level, release_serial)
   else
    Result := ((major          and $FF) shl 24) or
              ((minor          and $FF) shl 16) or
              ((micro          and $FF) shl 8) or
              ((release_level  and $0F) shl 4) or
              ((release_serial and $0F));
end;

class function TPy.PACK_VERSION(major, minor: integer): cardinal;
begin
  if assigned(Py_PACK_VERSION) then
    Result := Py_PACK_VERSION(major, minor)
   else
    Result := PACK_FULL_VERSION(major, minor, 0, 0, 0);
end;

class function TPy.VERSION(major, minor, micro, release_level, release_serial: integer): string;
begin
  Result := IntToStr(major) + '.' +
            IntToStr(minor) + '.' +
            IntToStr(minor);

  case release_level of
    PY_RELEASE_LEVEL_ALPHA : Result := Result + 'a'  + IntToStr(release_serial);
    PY_RELEASE_LEVEL_BETA  : Result := Result + 'b'  + IntToStr(release_serial);
    PY_RELEASE_LEVEL_GAMMA : Result := Result + 'rc' + IntToStr(release_serial);
  end;
end;

class function TPy.VERSION_HEX: cardinal;
begin
  Result := PACK_FULL_VERSION(PY_MAJOR_VERSION,
                              PY_MINOR_VERSION,
                              PY_MICRO_VERSION,
                              PY_RELEASE_LEVEL,
                              PY_RELEASE_SERIAL);
end;

end.
