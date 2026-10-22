unit uP4P.Constants;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

{$IFNDEF TARGET_64BITS}{$ALIGN ON}{$ENDIF}
{$MINENUMSIZE 4}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.Math;
  {$ELSE}
    Classes, Math;
  {$ENDIF}

const
  {* include/patchlevel.h *}
  PY_RELEASE_LEVEL_ALPHA = $0A;
  PY_RELEASE_LEVEL_BETA  = $0B;
  PY_RELEASE_LEVEL_GAMMA = $0C; // For release candidates
  PY_RELEASE_LEVEL_FINAL = $0F;

  PY_MAJOR_VERSION       = 3;
  PY_MINOR_VERSION       = 15;
  PY_MICRO_VERSION       = 1;
  PY_RELEASE_LEVEL       = PY_RELEASE_LEVEL_GAMMA;
  PY_RELEASE_SERIAL      = 2;

  PYTHON_API_VERSION   = 1013;
  PYTHON_API_STRING    = '1013';
  PYTHON_ABI_VERSION   = 3;
  PYTHON_ABI_STRING    = '3';


  {* Custom constants *}
  CR              = #13;
  LF              = #10;
  TAB             = #09;
  CRLF            = CR+LF;

  SUPPORTED_MAJOR_VERSION     = PY_MAJOR_VERSION;
  MAX_SUPPORTED_MINOR_VERSION = PY_MINOR_VERSION;
  MIN_SUPPORTED_MINOR_VERSION = 10;

  HOURS_IN_A_DAY        = 24;
  MINUTES_IN_AN_HOUR    = 60;
  SECONDS_IN_A_MINUTE   = 60;
  SECONDS_IN_AN_HOUR    = SECONDS_IN_A_MINUTE * MINUTES_IN_AN_HOUR;
  SECONDS_IN_A_DAY      = SECONDS_IN_AN_HOUR * HOURS_IN_A_DAY;
  MILLISECONDS_IN_A_DAY = SECONDS_IN_A_DAY * 1000;

  MAIN_MODULE_NAME         = '__main__';
  DEFAULT_COMPILE_FILENAME = '<string>';

  {$IFDEF MSWINDOWS}
  PYTHON_LIB_EXT = 'dll';
  {$ELSE}
    {$IFDEF APPLE}
    PYTHON_LIB_EXT = 'dylib';
    {$ELSE}
    PYTHON_LIB_EXT = 'so';
    {$ENDIF}
  {$ENDIF}

  /// <summary>
  /// These contants are declared in the "Windows" unit but
  /// some old Delphi versions don't have them.
  /// We have to add "P4P_" to be compatible with C++ Builder.
  /// </summary>
  P4P_IMAGE_FILE_MACHINE_I386  = $014C;
  P4P_IMAGE_FILE_MACHINE_AMD64 = $8664;

  /// <summary>
  /// Names of configuration options used by TPyInitConfig
  /// </summary>
  PYINITCONFIGOPTION_ALLOCATOR                  = 'allocator';
  PYINITCONFIGOPTION_ARGV                       = 'argv';
  PYINITCONFIGOPTION_BASE_EXEC_PREFIX           = 'base_exec_prefix';
  PYINITCONFIGOPTION_BASE_EXECUTABLE            = 'base_executable';
  PYINITCONFIGOPTION_BASE_PREFIX                = 'base_prefix';
  PYINITCONFIGOPTION_BUFFERED_STDIO             = 'buffered_stdio';
  PYINITCONFIGOPTION_BYTES_WARNING              = 'bytes_warning';
  PYINITCONFIGOPTION_CHECK_HASH_PYCS_MODE       = 'check_hash_pycs_mode';
  PYINITCONFIGOPTION_CODE_DEBUG_RANGES          = 'code_debug_ranges';
  PYINITCONFIGOPTION_COERCE_C_LOCALE            = 'coerce_c_locale';
  PYINITCONFIGOPTION_COERCE_C_LOCALE_WARN       = 'coerce_c_locale_warn';
  PYINITCONFIGOPTION_CONFIGURE_C_STDIO          = 'configure_c_stdio';
  PYINITCONFIGOPTION_CONFIGURE_LOCALE           = 'configure_locale';
  PYINITCONFIGOPTION_CPU_COUNT                  = 'cpu_count';
  PYINITCONFIGOPTION_DEV_MODE                   = 'dev_mode';
  PYINITCONFIGOPTION_DUMP_REFS                  = 'dump_refs';
  PYINITCONFIGOPTION_DUMP_REFS_FILE             = 'dump_refs_file';
  PYINITCONFIGOPTION_EXEC_PREFIX                = 'exec_prefix';
  PYINITCONFIGOPTION_EXECUTABLE                 = 'executable';
  PYINITCONFIGOPTION_FAULTHANDLER               = 'faulthandler';
  PYINITCONFIGOPTION_FILESYSTEM_ENCODING        = 'filesystem_encoding';
  PYINITCONFIGOPTION_FILESYSTEM_ERRORS          = 'filesystem_errors';
  PYINITCONFIGOPTION_HASH_SEED                  = 'hash_seed';
  PYINITCONFIGOPTION_HOME                       = 'home';
  PYINITCONFIGOPTION_IMPORT_TIME                = 'import_time';
  PYINITCONFIGOPTION_INSPECT                    = 'inspect';
  PYINITCONFIGOPTION_INSTALL_SIGNAL_HANDLERS    = 'install_signal_handlers';
  PYINITCONFIGOPTION_INT_MAX_STR_DIGITS         = 'int_max_str_digits';
  PYINITCONFIGOPTION_INTERACTIVE                = 'interactive';
  PYINITCONFIGOPTION_ISOLATED                   = 'isolated';
  PYINITCONFIGOPTION_LAZY_IMPORTS               = 'lazy_imports';           //****** 3.15.0
  {$IFDEF MSWINDOWS}
  PYINITCONFIGOPTION_LEGACY_WINDOWS_FS_ENCODING = 'legacy_windows_fs_encoding';
  PYINITCONFIGOPTION_LEGACY_WINDOWS_STDIO       = 'legacy_windows_stdio';
  {$ENDIF}
  PYINITCONFIGOPTION_MALLOC_STATS               = 'malloc_stats';
  PYINITCONFIGOPTION_MODULE_SEARCH_PATHS        = 'module_search_paths';
  PYINITCONFIGOPTION_OPTIMIZATION_LEVEL         = 'optimization_level';
  PYINITCONFIGOPTION_ORIG_ARGV                  = 'orig_argv';
  PYINITCONFIGOPTION_PARSE_ARGV                 = 'parse_argv';
  PYINITCONFIGOPTION_PARSER_DEBUG               = 'parser_debug';
  PYINITCONFIGOPTION_PATHCONFIG_WARNINGS        = 'pathconfig_warnings';
  PYINITCONFIGOPTION_PERF_PROFILING             = 'perf_profiling';
  PYINITCONFIGOPTION_PLATLIBDIR                 = 'platlibdir';
  PYINITCONFIGOPTION_PREFIX                     = 'prefix';
  PYINITCONFIGOPTION_PROGRAM_NAME               = 'program_name';
  PYINITCONFIGOPTION_PYCACHE_PREFIX             = 'pycache_prefix';
  PYINITCONFIGOPTION_PYMALLOC_HUGEPAGES         = 'pymalloc_hugepages';     //****** 3.15.0
  PYINITCONFIGOPTION_QUIET                      = 'quiet';
  PYINITCONFIGOPTION_RUN_COMMAND                = 'run_command';
  PYINITCONFIGOPTION_RUN_FILENAME               = 'run_filename';
  PYINITCONFIGOPTION_RUN_MODULE                 = 'run_module';
  PYINITCONFIGOPTION_RUN_PRESITE                = 'run_presite';
  PYINITCONFIGOPTION_SAFE_PATH                  = 'safe_path';
  PYINITCONFIGOPTION_SHOW_REF_COUNT             = 'show_ref_count';
  PYINITCONFIGOPTION_SITE_IMPORT                = 'site_import';
  PYINITCONFIGOPTION_SKIP_SOURCE_FIRST_LINE     = 'skip_source_first_line';
  PYINITCONFIGOPTION_STDIO_ENCODING             = 'stdio_encoding';
  PYINITCONFIGOPTION_STDIO_ERRORS               = 'stdio_errors';
  PYINITCONFIGOPTION_STDLIB_DIR                 = 'stdlib_dir';
  PYINITCONFIGOPTION_TRACEMALLOC                = 'tracemalloc';
  PYINITCONFIGOPTION_USE_ENVIRONMENT            = 'use_environment';
  PYINITCONFIGOPTION_USE_FROZEN_MODULES         = 'use_frozen_modules';
  PYINITCONFIGOPTION_USE_HASH_SEED              = 'use_hash_seed';
  PYINITCONFIGOPTION_USE_SYSTEM_LOGGER          = 'use_system_logger';
  PYINITCONFIGOPTION_USER_SITE_DIRECTORY        = 'user_site_directory';
  PYINITCONFIGOPTION_UTF8_MODE                  = 'utf8_mode';
  PYINITCONFIGOPTION_VERBOSE                    = 'verbose';
  PYINITCONFIGOPTION_WARN_DEFAULT_ENCODING      = 'warn_default_encoding';
  PYINITCONFIGOPTION_WARNOPTIONS                = 'warnoptions';
  PYINITCONFIGOPTION_WRITE_BYTECODE             = 'write_bytecode';
  PYINITCONFIGOPTION_XOPTIONS                   = 'xoptions';


  {* include/pyport.h *}
  {* include/exports.h *}
  {* include/pymacro.h *}
  {* include/pymath.h *}

  /// <summary>
  /// High precision (long double) definition of pi constant.
  /// </summary>
  Py_MATH_PIl = 3.1415926535897932384626433832795029;
  /// <summary>
  /// The definition (accurate for a double type) of the math.pi constant.
  /// </summary>
  Py_MATH_PI  = 3.14159265358979323846;
  /// <summary>
  /// High precision (long double) definition of e constant.
  /// </summary>
  Py_MATH_El  = 2.7182818284590452353602874713526625;
  /// <summary>
  /// The definition (accurate for a double type) of the math.e constant.
  /// </summary>
  Py_MATH_E   = 2.7182818284590452354;
  /// <summary>
  /// The definition (accurate for a double type) of the math.tau constant.
  /// </summary>
  Py_MATH_TAU = 6.2831853071795864769252867665590057683943;
  /// <summary>
  /// This constant represents the positive infinity. On most platforms,
  /// this is equivalent to the INFINITY macro from the C11 standard <math.h>
  /// header.
  /// </summary>
  Py_INFINITY = INFINITY;
  /// <summary>
  /// Equivalent to INFINITY. Deprecated since version 3.14: This is soft
  /// deprecated.
  /// </summary>
  Py_HUGE_VAL = Py_INFINITY;
  /// <summary>
  /// This constant represents a quiet not-a-number (qNaN) value. On most
  /// platforms, this is equivalent to the NAN macro from the C11 standard
  /// <math.h> header.
  /// </summary>
  Py_NAN      = NAN;

  {* include/pymem.h  include/cpython/pymem.h *}
  {* include/pytypedefs.h *}
  {* include/pybuffer.h *}

  /// <summary>
  /// The maximum number of dimensions the memory represents. Exporters MUST
  /// respect this limit, consumers of multi-dimensional buffers SHOULD be able
  /// to handle up to PyBUF_MAX_NDIM dimensions. Currently set to 64.
  /// </summary>
  PyBUF_MAX_NDIM = 64;

  /// <summary>
  /// Flags for getting buffers.
  /// </summary>
  PyBUF_SIMPLE   = 0;
  /// <summary>
  /// Flags for getting buffers.
  /// </summary>
  PyBUF_WRITABLE = 1;

  PyBUF_FORMAT         = $0004;
  PyBUF_ND             = $0008;
  PyBUF_STRIDES        = $0010 or PyBUF_ND;
  PyBUF_C_CONTIGUOUS   = $0020 or PyBUF_STRIDES;
  PyBUF_F_CONTIGUOUS   = $0040 or PyBUF_STRIDES;
  PyBUF_ANY_CONTIGUOUS = $0080 or PyBUF_STRIDES;
  PyBUF_INDIRECT       = $0100 or PyBUF_STRIDES;

  PyBUF_CONTIG     = PyBUF_ND or PyBUF_WRITABLE;
  PyBUF_CONTIG_RO  = PyBUF_ND;

  PyBUF_STRIDED    = PyBUF_STRIDES or PyBUF_WRITABLE;
  PyBUF_STRIDED_RO = PyBUF_STRIDES;

  PyBUF_RECORDS    = PyBUF_STRIDES or PyBUF_WRITABLE or PyBUF_FORMAT;
  PyBUF_RECORDS_RO = PyBUF_STRIDES or PyBUF_FORMAT;

  PyBUF_FULL       = PyBUF_INDIRECT or PyBUF_WRITABLE or PyBUF_FORMAT;
  PyBUF_FULL_RO    = PyBUF_INDIRECT or PyBUF_FORMAT;

  PyBUF_READ       = $100;
  PyBUF_WRITE      = $200;

  {* include/pystats.h *}
  {* include/pyatomic.h *}
  {* include/lock.h  include/cpython/lock.h  include/cpython/pylock.h *}
  {* include/critical_section.h   include/cpython/critical_section.h *}
  {* include/object.h  include/cpython/object.h *}
  Py_PRINT_RAW    = 1;

  /// <summary>
  /// <para>Used as a value with Py_tp_token to set the token to the class's
  /// PyType_Spec. Expands to nil.</para>
  /// <para>Added in version 3.14.</para>
  /// </summary>
  Py_TP_USE_SPEC                      : Pointer = nil;

  /// <summary>
  /// <para>Track types initialized using _PyStaticType_InitBuiltin().</para>
  /// </summary>
  _Py_TPFLAGS_STATIC_BUILTIN          = 1 shl 1;
  /// <summary>
  /// <para>This bit indicates that instances of this type will have an
  /// "inline values" array (containing the object's attributes) placed
  /// directly after the end of the object.</para>
  /// <para>This requires that Py_TPFLAGS_HAVE_GC is set.</para>
  /// <para>The values array is placed inline directly after the rest of
  /// the object. Implies Py_TPFLAGS_HAVE_GC.</para>
  /// </summary>
  Py_TPFLAGS_INLINE_VALUES            = 1 shl 2;
  /// <summary>
  /// <para>This bit indicates that instances of the class should be weakly
  /// referenceable.</para>
  /// <para>If this flag is set, Py_TPFLAGS_HAVE_GC must also be set.</para>
  /// <para>Added in version 3.12.</para>
  /// <para>Placement of weakref pointers are managed by the VM, not by the
  /// type. The VM will automatically set tp_weaklistoffset.
  /// Implies Py_TPFLAGS_HAVE_GC.</para>
  /// </summary>
  Py_TPFLAGS_MANAGED_WEAKREF          = 1 shl 3;
  /// <summary>
  /// <para>This bit indicates that instances of the class have a __dict__
  /// attribute, and that the space for the dictionary is managed by the
  /// VM.</para>
  /// <para>If this flag is set, Py_TPFLAGS_HAVE_GC must also be set.</para>
  /// <para>The type traverse function must call TPyObject.VisitManagedDict()
  /// and its clear function must call TPyObject.ClearManagedDict().</para>
  /// <para>Added in version 3.12.</para>
  /// <para>Placement of dict (and values) pointers are managed by the VM,
  /// not by the type. The VM will automatically set tp_dictoffset.
  /// Implies Py_TPFLAGS_HAVE_GC.</para>
  /// </summary>
  Py_TPFLAGS_MANAGED_DICT             = 1 shl 4;
  /// <summary>
  /// <para>These bits indicate that the VM will manage some fields by storing
  /// them before the object. Currently, this macro is equivalent to
  /// Py_TPFLAGS_MANAGED_DICT | Py_TPFLAGS_MANAGED_WEAKREF.</para>
  /// <para>This macro value relies on the implementation of the VM, so its
  /// value is not stable and may change in a future version. Prefer using
  /// individual flags instead.</para>
  /// <para>Added in version 3.12.</para>
  /// <para>Type has dictionary or weakref pointers that are managed by VM and
  /// has to allocate space to store these.</para>
  /// </summary>
  Py_TPFLAGS_PREHEADER                = Py_TPFLAGS_MANAGED_WEAKREF or Py_TPFLAGS_MANAGED_DICT;
  /// <summary>
  /// <para>This bit indicates that instances of the class may match sequence
  /// patterns when used as the subject of a match block. It is automatically
  /// set when registering or subclassing collections.abc.Sequence, and unset
  /// when registering collections.abc.Mapping.</para>
  /// <para>Note: Py_TPFLAGS_MAPPING and Py_TPFLAGS_SEQUENCE are mutually
  /// exclusive; it is an error to enable both flags simultaneously.</para>
  /// <para>Set if instances of the type object are treated as sequences for
  /// pattern matching.</para>
  /// </summary>
  Py_TPFLAGS_SEQUENCE                 = 1 shl 5;
  /// <summary>
  /// <para>This bit indicates that instances of the class may match mapping
  /// patterns when used as the subject of a match block. It is automatically
  /// set when registering or subclassing collections.abc.Mapping, and unset
  /// when registering collections.abc.Sequence.</para>
  /// <para>Note: Py_TPFLAGS_MAPPING and Py_TPFLAGS_SEQUENCE are mutually
  /// exclusive; it is an error to enable both flags simultaneously.</para>
  /// <para>Set if instances of the type object are treated as mappings for
  /// pattern matching.</para>
  /// </summary>
  Py_TPFLAGS_MAPPING                  = 1 shl 6;
  /// <summary>
  /// <para>Disallow creating instances of the type: set tp_new to NULL and
  /// don't create the __new__ key in the type dictionary.</para>
  /// <para>The flag must be set before creating the type, not after.
  /// For example, it must be set before TPyType.Ready() is called on the
  /// type.</para>
  /// <para>The flag is set automatically on static types if tp_base is nil or
  /// &PyBaseObject_Type and tp_new is nil.</para>
  /// <para>Disallow creating instances of the type: set tp_new to NULL and
  /// don't create the "__new__" key in the type dictionary.</para>
  /// </summary>
  Py_TPFLAGS_DISALLOW_INSTANTIATION   = 1 shl 7;
  /// <summary>
  /// <para>This bit is set for type objects that are immutable: type
  /// attributes cannot be set nor deleted.</para>
  /// <para>TPyType.Ready() automatically applies this flag to static
  /// types.</para>
  /// <para>Set if the type object is immutable: type attributes cannot be set
  /// nor deleted.</para>
  /// </summary>
  Py_TPFLAGS_IMMUTABLETYPE            = 1 shl 8;
  /// <summary>
  /// <para>This bit is set when the type object itself is allocated on the
  /// heap, for example, types created dynamically using TPyType.FromSpec().
  /// In this case, the ob_type field of its instances is considered a
  /// reference to the type, and the type object is INCREF'ed when a new
  /// instance is created, and DECREF'ed when an instance is destroyed (this
  /// does not apply to instances of subtypes; only the type referenced by the
  /// instance's ob_type gets INCREF'ed or DECREF'ed). Heap types should also
  /// support garbage collection as they can form a reference cycle with their
  /// own module object.</para>
  /// <para>Set if the type object is dynamically allocated.</para>
  /// </summary>
  Py_TPFLAGS_HEAPTYPE                 = 1 shl 9;
  /// <summary>
  /// <para>This bit is set when the type can be used as the base type of
  /// another type. If this bit is clear, the type cannot be subtyped (similar
  /// to a "final" class in Java).</para>
  /// <para>Set if the type allows subclassing.</para>
  /// </summary>
  Py_TPFLAGS_BASETYPE                 = 1 shl 10;
  /// <summary>
  /// <para>This bit is set when the class implements the vectorcall protocol.
  /// See tp_vectorcall_offset for details.</para>
  /// <para>Inheritance:</para>
  /// <para>This bit is inherited if tp_call is also inherited.</para>
  /// <para>Added in version 3.8: as _Py_TPFLAGS_HAVE_VECTORCALL</para>
  /// <para>Changed in version 3.9: Renamed to the current name, without the
  /// leading underscore. The old provisional name is soft deprecated.</para>
  /// <para>Changed in version 3.12: This flag is now removed from a class when
  /// the class's __call__() method is reassigned.</para>
  /// <para>This flag can now be inherited by mutable classes.</para>
  /// <para>Set if the type implements the vectorcall protocol (PEP 590).</para>
  /// </summary>
  Py_TPFLAGS_HAVE_VECTORCALL          = 1 shl 11;
  /// <summary>
  /// <para>This bit is set when the type object has been fully initialized by
  /// TPyType.Ready().</para>
  /// <para>Set if the type is 'ready' -- fully initialized.</para>
  /// </summary>
  Py_TPFLAGS_READY                    = 1 shl 12;
  /// <summary>
  /// <para>This bit is set while TPyType.Ready() is in the process of
  /// initializing the type object.</para>
  /// <para>Set while the type is being 'readied', to prevent recursive ready
  /// calls.</para>
  /// </summary>
  Py_TPFLAGS_READYING                 = 1 shl 13;
  /// <summary>
  /// <para>This bit is set when the object supports garbage collection. If
  /// this bit is set, memory for new instances (see tp_alloc) must be
  /// allocated using TPyObject.GC_New or TPyType.GenericAlloc() and
  /// deallocated (see tp_free) using TPyObject.GC_Del(). More information in
  /// section Supporting Cyclic Garbage Collection.</para>
  /// <para>Objects support garbage collection (see objimpl.h).</para>
  /// </summary>
  Py_TPFLAGS_HAVE_GC                  = 1 shl 14;
  /// <summary>
  /// <para>Internal. Do not set or unset this flag. Historically, this was a
  /// reserved flag for use in Stackless Python.</para>
  /// <para>Warning: This flag is present in header files, but is not be used.
  /// This may be removed in a future version of CPython.</para>
  /// <para>These two bits are preserved for Stackless Python.</para>
  /// </summary>
  Py_TPFLAGS_HAVE_STACKLESS_EXTENSION = 0; // 3 shl 15;
  /// <summary>
  /// <para>This is a bitmask of all the bits that pertain to the existence of
  /// certain fields in the type object and its extension structures.
  /// Currently, it includes the following bits:
  /// Py_TPFLAGS_HAVE_STACKLESS_EXTENSION.</para>
  /// </summary>
  Py_TPFLAGS_DEFAULT                  = Py_TPFLAGS_HAVE_STACKLESS_EXTENSION;
  /// <summary>
  /// <para>This bit indicates that objects behave like unbound methods.</para>
  /// <para>If this flag is set for type(meth), then:</para>
  /// <code>
  /// - meth.__get__(obj, cls)(*args, **kwds) (with obj not None) must be
  ///   equivalent to meth(obj, *args, **kwds).
  /// - meth.__get__(None, cls)(*args, **kwds) must be equivalent to
  ///   meth(*args, **kwds).
  /// </code>
  /// <para>This flag enables an optimization for typical method calls like
  /// obj.meth(): it avoids creating a temporary "bound method" object for
  /// obj.meth.</para>
  /// <para>Objects behave like an unbound method.</para>
  /// </summary>
  Py_TPFLAGS_METHOD_DESCRIPTOR        = 1 shl 17;
  /// <summary>
  /// <para>Internal. Do not set or unset this flag. To indicate that a class
  /// has changed call TPyType.Modified()</para>
  /// <para>Warning: This flag is present in header files, but is not be used.
  /// It will be removed in a future version of CPython</para>
  /// <para>Unused. Legacy flag.</para>
  /// </summary>
  Py_TPFLAGS_VALID_VERSION_TAG        = 1 shl 19;
  /// <summary>
  /// <para>This bit indicates that this is an abstract type and therefore
  /// cannot be instantiated.</para>
  /// <para>Type is abstract and cannot be instantiated.</para>
  /// </summary>
  Py_TPFLAGS_IS_ABSTRACT              = 1 shl 20;
  /// <summary>
  /// <para>This undocumented flag gives certain built-ins their unique
  /// pattern-matching behavior, which allows a single positional subpattern
  /// to match against the subject itself (rather than a mapped attribute
  /// on it)</para>
  /// </summary>
  _Py_TPFLAGS_MATCH_SELF              = 1 shl 22;
  /// <summary>
  /// <para>Only usable with variable-size types, i.e. ones with non-zero
  /// tp_itemsize.</para>
  /// <para>Indicates that the variable-sized portion of an instance of this
  /// type is at the end of the instance's memory area, at an offset of
  /// Py_TYPE(obj)->tp_basicsize (which may be different in each
  /// subclass).</para>
  /// <para>When setting this flag, be sure that all superclasses either use
  /// this memory layout, or are not variable-sized. Python does not check
  /// this.</para>
  /// <para>Added in version 3.12.</para>
  /// <para>Items (ob_size*tp_itemsize) are found at the end of an
  /// instance's memory.</para>
  /// </summary>
  Py_TPFLAGS_ITEMS_AT_END             = 1 shl 23;
  /// <summary>
  /// <para>Functions such as TPy*.Check() will call TPyType.FastSubclass()
  /// with one of these flags to quickly determine if a type is a subclass of a
  /// built-in type; such specific checks are faster than a generic check, like
  /// TPyObject.IsInstance(). Custom types that inherit from built-ins should
  /// have their tp_flags set appropriately, or the code that interacts with
  /// such types will behave differently depending on what kind of check is
  /// used.</para>
  /// <para>This flag is used to determine if a type is a subclass.</para>
  /// </summary>
  Py_TPFLAGS_LONG_SUBCLASS            = 1 shl 24;
  /// <summary>
  /// <para>Functions such as TPy*.Check() will call TPyType.FastSubclass()
  /// with one of these flags to quickly determine if a type is a subclass of a
  /// built-in type; such specific checks are faster than a generic check, like
  /// TPyObject.IsInstance(). Custom types that inherit from built-ins should
  /// have their tp_flags set appropriately, or the code that interacts with
  /// such types will behave differently depending on what kind of check is
  /// used.</para>
  /// <para>This flag is used to determine if a type is a subclass.</para>
  /// </summary>
  Py_TPFLAGS_LIST_SUBCLASS            = 1 shl 25;
  /// <summary>
  /// <para>Functions such as TPy*.Check() will call TPyType.FastSubclass()
  /// with one of these flags to quickly determine if a type is a subclass of a
  /// built-in type; such specific checks are faster than a generic check, like
  /// TPyObject.IsInstance(). Custom types that inherit from built-ins should
  /// have their tp_flags set appropriately, or the code that interacts with
  /// such types will behave differently depending on what kind of check is
  /// used.</para>
  /// <para>This flag is used to determine if a type is a subclass.</para>
  /// </summary>
  Py_TPFLAGS_TUPLE_SUBCLASS           = 1 shl 26;
  /// <summary>
  /// <para>Functions such as TPy*.Check() will call TPyType.FastSubclass()
  /// with one of these flags to quickly determine if a type is a subclass of a
  /// built-in type; such specific checks are faster than a generic check, like
  /// TPyObject.IsInstance(). Custom types that inherit from built-ins should
  /// have their tp_flags set appropriately, or the code that interacts with
  /// such types will behave differently depending on what kind of check is
  /// used.</para>
  /// <para>This flag is used to determine if a type is a subclass.</para>
  /// </summary>
  Py_TPFLAGS_BYTES_SUBCLASS           = 1 shl 27;
  /// <summary>
  /// <para>Functions such as TPy*.Check() will call TPyType.FastSubclass()
  /// with one of these flags to quickly determine if a type is a subclass of a
  /// built-in type; such specific checks are faster than a generic check, like
  /// TPyObject.IsInstance(). Custom types that inherit from built-ins should
  /// have their tp_flags set appropriately, or the code that interacts with
  /// such types will behave differently depending on what kind of check is
  /// used.</para>
  /// <para>This flag is used to determine if a type is a subclass.</para>
  /// </summary>
  Py_TPFLAGS_UNICODE_SUBCLASS         = 1 shl 28;
  /// <summary>
  /// <para>Functions such as TPy*.Check() will call TPyType.FastSubclass()
  /// with one of these flags to quickly determine if a type is a subclass of a
  /// built-in type; such specific checks are faster than a generic check, like
  /// TPyObject.IsInstance(). Custom types that inherit from built-ins should
  /// have their tp_flags set appropriately, or the code that interacts with
  /// such types will behave differently depending on what kind of check is
  /// used.</para>
  /// <para>This flag is used to determine if a type is a subclass.</para>
  /// </summary>
  Py_TPFLAGS_DICT_SUBCLASS            = 1 shl 29;
  /// <summary>
  /// <para>Functions such as TPy*.Check() will call TPyType.FastSubclass()
  /// with one of these flags to quickly determine if a type is a subclass of a
  /// built-in type; such specific checks are faster than a generic check, like
  /// TPyObject.IsInstance(). Custom types that inherit from built-ins should
  /// have their tp_flags set appropriately, or the code that interacts with
  /// such types will behave differently depending on what kind of check is
  /// used.</para>
  /// <para>This flag is used to determine if a type is a subclass.</para>
  /// </summary>
  Py_TPFLAGS_BASE_EXC_SUBCLASS        = 1 shl 30;
  /// <summary>
  /// <para>Functions such as TPy*.Check() will call TPyType.FastSubclass()
  /// with one of these flags to quickly determine if a type is a subclass of a
  /// built-in type; such specific checks are faster than a generic check, like
  /// TPyObject.IsInstance(). Custom types that inherit from built-ins should
  /// have their tp_flags set appropriately, or the code that interacts with
  /// such types will behave differently depending on what kind of check is
  /// used.</para>
  /// <para>This flag is used to determine if a type is a subclass.</para>
  /// </summary>
  Py_TPFLAGS_TYPE_SUBCLASS            = 1 shl 31;
  /// <summary>
  /// <para>This bit is set when the tp_finalize slot is present in the type
  /// structure.</para>
  /// <para>Added in version 3.4.</para>
  /// <para>Deprecated since version 3.8: This flag isn't necessary anymore,
  /// as the interpreter assumes the tp_finalize slot is always present in the
  /// type structure.</para>
  /// </summary>
  Py_TPFLAGS_HAVE_FINALIZE            = 1 shl  0;
  /// <summary>
  /// <para>This macro does nothing. Historically, this would indicate that
  /// the tp_version_tag field was available and initialized.</para>
  /// <para>Soft deprecated since version 3.13.</para>
  /// </summary>
  Py_TPFLAGS_HAVE_VERSION_TAG         = 1 shl 18;

  Py_CONSTANT_NONE             = 0;
  Py_CONSTANT_FALSE            = 1;
  Py_CONSTANT_TRUE             = 2;
  Py_CONSTANT_ELLIPSIS         = 3;
  Py_CONSTANT_NOT_IMPLEMENTED  = 4;
  Py_CONSTANT_ZERO             = 5;
  Py_CONSTANT_ONE              = 6;
  Py_CONSTANT_EMPTY_STR        = 7;
  Py_CONSTANT_EMPTY_BYTES      = 8;
  Py_CONSTANT_EMPTY_TUPLE      = 9;
  Py_CONSTANT_FIRST            = Py_CONSTANT_NONE;
  Py_CONSTANT_LAST             = Py_CONSTANT_EMPTY_TUPLE;

  Py_LT = 0;
  Py_LE = 1;
  Py_EQ = 2;
  Py_NE = 3;
  Py_GT = 4;
  Py_GE = 5;

  {* include/refcount.h *}
  {* include/objimpl.h  include/cpython/objimpl.h *}
  {* include/typeslots.h  include/slots.h  include/slots_generated.h *}

  /// <summary>
  /// <para>If the slot ID is unknown, the interpreter should ignore the slot
  /// entirely. (For example, if nb_matrix_multiply was being added to CPython
  /// now, your type could use this.)</para>
  /// </summary>
  PySlot_OPTIONAL  = $0001;
  /// <summary>
  /// <para>All data the slot points to is statically allocated and constant.
  /// Thus, the interpreter does not need to copy the information. This flag
  /// is implied for function pointers.</para>
  /// <para>The flag applies even to data the slot points to "indirectly",
  /// except for nested slots - see Nested slot tables below - which can have
  /// their own PySlot_STATIC flag. For example, if applied to a Py_tp_members
  /// slot that points to an array of PyMemberDef structures, then the entire
  /// array, as well as the name and doc strings in its elements, must be
  /// static and constant.</para>
  /// <para>This flag will be required for slots that need static data
  /// (Py_mod_methods, Py_tp_methods, Py_tp_members, Py_tp_getset).</para>
  /// </summary>
  PySlot_STATIC    = $0002;
  /// <summary>
  /// <para>The data is stored in sl_ptr, and must be cast to the appropriate
  /// type.</para>
  /// <para>This flag simplifies porting from the existing PyType_Slot and
  /// PyModuleDef_Slot, where all slots work this way.</para>
  /// </summary>
  PySlot_INTPTR    = $0004;
  /// <summary>
  /// <para>Reserved; will always be treated as an unknown slot ID. Defined as
  /// UINT16_MAX (0xFFFF).</para>
  /// <para>When used with the PySlot_OPTIONAL flag, defines a slot with no
  /// effect. Without the flag, processing a slot with this ID will fail.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_slot_invalid  = $FFFF;

  {*
     WARNING:
     --------
     Due to changes in recent Python versions the Py_mp_*, Py_bf_*
     and Py_mod_* constants are defined by the TPy_mp, TPy_bf and TPy_mod
     class helpers.
  *}
  /// <summary>
  /// <para>Marks the end of a slots array. Defined as zero.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_slot_end = 0;
  Py_nb_absolute = 6;
  Py_nb_add = 7;
  Py_nb_and = 8;
  Py_nb_bool = 9;
  Py_nb_divmod = 10;
  Py_nb_float = 11;
  Py_nb_floor_divide = 12;
  Py_nb_index = 13;
  Py_nb_inplace_add = 14;
  Py_nb_inplace_and = 15;
  Py_nb_inplace_floor_divide = 16;
  Py_nb_inplace_lshift = 17;
  Py_nb_inplace_multiply = 18;
  Py_nb_inplace_or = 19;
  Py_nb_inplace_power = 20;
  Py_nb_inplace_remainder = 21;
  Py_nb_inplace_rshift = 22;
  Py_nb_inplace_subtract = 23;
  Py_nb_inplace_true_divide = 24;
  Py_nb_inplace_xor = 25;
  Py_nb_int = 26;
  Py_nb_invert = 27;
  Py_nb_lshift = 28;
  Py_nb_multiply = 29;
  Py_nb_negative = 30;
  Py_nb_or = 31;
  Py_nb_positive = 32;
  Py_nb_power = 33;
  Py_nb_remainder = 34;
  Py_nb_rshift = 35;
  Py_nb_subtract = 36;
  Py_nb_true_divide = 37;
  Py_nb_xor = 38;
  Py_sq_ass_item = 39;
  Py_sq_concat = 40;
  Py_sq_contains = 41;
  Py_sq_inplace_concat = 42;
  Py_sq_inplace_repeat = 43;
  Py_sq_item = 44;
  Py_sq_length = 45;
  Py_sq_repeat = 46;
  /// <summary>
  /// <para>An optional pointer to an instance allocation function.</para>
  /// <para>The function signature is:</para>
  /// <code>PyObject *tp_alloc(PyTypeObject *self, Py_ssize_t nitems);</code>
  /// </summary>
  Py_tp_alloc = 47;
  /// <summary>
  /// <para>Equivalent to Py_tp_bases (with s at the end). If both are
  /// specified, Py_tp_bases takes priority and this slot is ignored.</para>
  /// <para>Changed in version 3.15: Previously, Py_tp_base required a single
  /// type, not a tuple.</para>
  /// <para>Soft deprecated since version 3.15: When not targeting older Python
  /// versions, prefer Py_tp_bases.</para>
  /// </summary>
  Py_tp_base = 48;
  /// <summary>
  /// <para>Slot ID for type flags, used to set PyTypeObject.tp_bases.</para>
  /// <para>The slot can be set to a tuple of type objects which the newly
  /// created type should inherit from, like the "positional arguments" of a
  /// Python class definition.</para>
  /// <para>Alternately, the slot can be set to a single type object to specify
  /// a single base. The effect is the same as specifying a one-element
  /// tuple.</para>
  /// <para>Changed in version 3.15: Previously, Py_tp_bases required a tuple
  /// of types.</para>
  /// </summary>
  Py_tp_bases = 49;
  /// <summary>
  /// <para>An optional pointer to a function that implements calling the
  /// object. This should be nil if the object is not callable. The signature
  /// is the same as for TPyObject.Call():</para>
  /// <code>PyObject *tp_call(PyObject *self, PyObject *args, PyObject *kwargs);</code>
  /// </summary>
  Py_tp_call = 50;
  /// <summary>
  /// <para>An optional pointer to a clear function. The signature is:</para>
  /// <code>int tp_clear(PyObject *);</code>
  /// <para>The purpose of this function is to break reference cycles that are
  /// causing a cyclic isolate so that the objects can be safely destroyed.
  /// A cleared object is a partially destroyed object; the object is not
  /// obligated to satisfy design invariants held during normal use.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/typeobj.html#c.PyTypeObject.tp_clear">See the article about PyTypeObject.tp_clear.</see></para>
  /// </remarks>
  Py_tp_clear = 51;
  /// <summary>
  /// <para>A pointer to the instance destructor function. The function
  /// signature is:</para>
  /// <code>void tp_dealloc(PyObject *self);</code>
  /// <para>The destructor function should remove all references which the
  /// instance owns (e.g., call Py_CLEAR()), free all memory buffers owned by
  /// the instance, and call the type's tp_free function to free the object
  /// itself.</para>
  /// </summary>
  Py_tp_dealloc = 52;
  /// <summary>
  /// <para>This is deprecated. Use Py_tp_finalize instead.</para>
  /// </summary>
  Py_tp_del = 53;
  /// <summary>
  /// <para>An optional pointer to a "descriptor get" function. The function
  /// signature is:</para>
  /// <code>PyObject * tp_descr_get(PyObject *self, PyObject *obj, PyObject *type);</code>
  /// </summary>
  Py_tp_descr_get = 54;
  /// <summary>
  /// <para>An optional pointer to a function for setting and deleting a
  /// descriptor's value.</para>
  /// <para>The function signature is:</para>
  /// <code>int tp_descr_set(PyObject *self, PyObject *obj, PyObject *value);</code>
  /// <para>The value argument is set to nil to delete the value.</para>
  /// </summary>
  Py_tp_descr_set = 55;
  /// <summary>
  /// <para>An optional pointer to a NUL-terminated C string giving the
  /// docstring for this type object. This is exposed as the __doc__ attribute
  /// on the type and instances of the type.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/typeobj.html#c.PyTypeObject.tp_doc">See the article about PyTypeObject.tp_doc.</see></para>
  /// </remarks>
  Py_tp_doc = 56;
  /// <summary>
  /// <para>An optional pointer to the get-attribute-string function.</para>
  /// <para>This field is deprecated. When it is defined, it should point to a
  /// function that acts the same as the Py_tp_getattro function, but taking a C
  /// string instead of a Python string object to give the attribute name.</para>
  /// </summary>
  Py_tp_getattr = 57;
  /// <summary>
  /// <para>An optional pointer to the get-attribute function.</para>
  /// <para>The signature is the same as for TPyObject.GetAttr():</para>
  /// <code>PyObject *tp_getattro(PyObject *self, PyObject *attr);</code>
  /// <para>It is usually convenient to set this field to
  /// TPyObject.GenericGetAttr(), which implements the normal way of looking
  /// for object attributes.</para>
  /// </summary>
  Py_tp_getattro = 58;
  /// <summary>
  /// <para>An optional pointer to a function that implements the built-in
  /// function hash().</para>
  /// <para>The signature is the same as for TPyObject.Hash():</para>
  /// <code>Py_hash_t tp_hash(PyObject *);</code>
  /// <para>The value -1 should not be returned as a normal return value; when
  /// an error occurs during the computation of the hash value, the function
  /// should set an exception and return -1.</para>
  /// <para>When this field is not set (and tp_richcompare is not set), an
  /// attempt to take the hash of the object raises TypeError. This is the same
  /// as setting it to TPyObject.HashNotImplemented().</para>
  /// <para>This field can be set explicitly to TPyObject.HashNotImplemented()
  /// to block inheritance of the hash method from a parent type. This is
  /// interpreted as the equivalent of __hash__ = None at the Python level,
  /// causing isinstance(o, collections.Hashable) to correctly return False.
  /// Note that the converse is also true - setting __hash__ = None on a class
  /// at the Python level will result in the tp_hash slot being set to
  /// TPyObject.HashNotImplemented().</para>
  /// </summary>
  Py_tp_hash = 59;
  /// <summary>
  /// <para>An optional pointer to an instance initialization function.</para>
  /// <para>This function corresponds to the __init__() method of classes.
  /// Like __init__(), it is possible to create an instance without calling
  /// __init__(), and it is possible to reinitialize an instance by calling
  /// its __init__() method again.</para>
  /// <para>The function signature is:</para>
  /// <code>int tp_init(PyObject *self, PyObject *args, PyObject *kwds);</code>
  /// <para>The self argument is the instance to be initialized; the args and
  /// kwds arguments represent positional and keyword arguments of the call to
  /// __init__().</para>
  /// <para>The tp_init function, if not nil, is called when an instance is
  /// created normally by calling its type, after the type's tp_new function
  /// has returned an instance of the type. If the tp_new function returns an
  /// instance of some other type that is not a subtype of the original type,
  /// no tp_init function is called; if tp_new returns an instance of a subtype
  /// of the original type, the subtype's tp_init is called.</para>
  /// <para>Returns 0 on success, -1 and sets an exception on error.</para>
  /// </summary>
  Py_tp_init = 60;
  /// <summary>
  /// <para>An optional pointer to a function called by the garbage
  /// collector.</para>
  /// <para>The garbage collector needs to know whether a particular object
  /// is collectible or not. Normally, it is sufficient to look at the
  /// object's type's tp_flags field, and check the Py_TPFLAGS_HAVE_GC flag bit.
  /// But some types have a mixture of statically and dynamically allocated
  /// instances, and the statically allocated instances are not collectible.
  /// Such types should define this function; it should return 1 for a
  /// collectible instance, and 0 for a non-collectible instance.
  /// The signature is:</para>
  /// <code>int tp_is_gc(PyObject *self);</code>
  /// <para>(The only example of this are types themselves. The metatype,
  /// PyType_Type, defines this function to distinguish between statically and
  /// dynamically allocated types.)</para>
  /// </summary>
  Py_tp_is_gc = 61;
  /// <summary>
  /// <para>An optional pointer to a function that returns an iterator for
  /// the object. Its presence normally signals that the instances of this type
  /// are iterable (although sequences may be iterable without this
  /// function).</para>
  /// <para>This function has the same signature as TPyObject.GetIter():</para>
  /// <code>PyObject *tp_iter(PyObject *self);</code>
  /// </summary>
  Py_tp_iter = 62;
  /// <summary>
  /// <para>An optional pointer to a function that returns the next item in an
  /// iterator. The signature is:</para>
  /// <code>PyObject *tp_iternext(PyObject *self);</code>
  /// <para>When the iterator is exhausted, the tp_iternext function must
  /// return nil; a StopIteration exception may or may not be set. When another
  /// error occurs, it must return nil too. The presence of tp_iternext signals
  /// that the instances of this type are iterators.</para>
  /// <para>Iterator types should also define the tp_iter function, and that
  /// function should return the iterator instance itself (not a new iterator
  /// instance).</para>
  /// <para>This function has the same signature as TPyIter.Next().</para>
  /// </summary>
  Py_tp_iternext = 63;
  /// <summary>
  /// <para>An optional pointer to a static nil-terminated array of
  /// PyMethodDef structures, declaring regular methods of this type.</para>
  /// <para>For each entry in the array, an entry is added to the type's
  /// dictionary (see tp_dict below) containing a method descriptor.</para>
  /// </summary>
  Py_tp_methods = 64;
  /// <summary>
  /// <para>An optional pointer to an instance creation function.</para>
  /// <para>The function signature is:</para>
  /// <code>PyObject *tp_new(PyTypeObject *subtype, PyObject *args, PyObject *kwds);</code>
  /// <para>The subtype argument is the type of the object being created;
  /// the args and kwds arguments represent positional and keyword arguments
  /// of the call to the type. Note that subtype doesn't have to equal the type
  /// whose tp_new function is called; it may be a subtype of that type
  /// (but not an unrelated type).</para>
  /// <para>The tp_new function should call subtype->tp_alloc(subtype, nitems)
  /// to allocate space for the object, and then do only as much further
  /// initialization as is absolutely necessary. Initialization that can safely
  /// be ignored or repeated should be placed in the tp_init handler. A good
  /// rule of thumb is that for immutable types, all initialization should take
  /// place in tp_new, while for mutable types, most initialization should be
  /// deferred to tp_init.</para>
  /// <para>Set the Py_TPFLAGS_DISALLOW_INSTANTIATION flag to disallow creating
  /// instances of the type in Python.</para>
  /// </summary>
  Py_tp_new = 65;
  /// <summary>
  /// <para>An optional pointer to a function that implements the built-in
  /// function repr().</para>
  /// <para>The signature is the same as for TPyObject.Repr():</para>
  /// <code>PyObject *tp_repr(PyObject *self);</code>
  /// <para>The function must return a string or a Unicode object. Ideally, this
  /// function should return a string that, when passed to eval(), given a
  /// suitable environment, returns an object with the same value. If this is
  /// not feasible, it should return a string starting with '<' and ending
  /// with '>' from which both the type and the value of the object can be
  /// deduced.</para>
  /// <para>When this field is not set, a string of the form <%s object at %p>
  /// is returned, where %s is replaced by the type name, and %p by the object's
  /// memory address.</para>
  /// </summary>
  Py_tp_repr = 66;
  /// <summary>
  /// <para>An optional pointer to the rich comparison function, whose
  /// signature is:</para>
  /// <code>PyObject *tp_richcompare(PyObject *self, PyObject *other, int op);</code>
  /// <para>The first parameter is guaranteed to be an instance of the type
  /// that is defined by PyTypeObject.</para>
  /// <para>The function should return the result of the comparison (usually
  /// Py_True or Py_False). If the comparison is undefined, it must return
  /// Py_NotImplemented, if another error occurred it must return nil and set
  /// an exception condition.</para>
  /// <para>The following constants are defined to be used as the third
  /// argument for tp_richcompare and for TPyObject.RichCompare():</para>
  /// <code>
  /// Constant    Comparison
  /// ----------------------
  ///   Py_LT         <
  ///   Py_LE         <=
  ///   Py_EQ         ==
  ///   Py_NE         !=
  ///   Py_GT         >
  ///   Py_GE         >=
  /// </code>
  /// </summary>
  Py_tp_richcompare = 67;
  /// <summary>
  /// <para>An optional pointer to the function for setting and deleting
  /// attributes.</para>
  /// <para>This field is deprecated. When it is defined, it should point to a
  /// function that acts the same as the tp_setattro function, but taking a C
  /// string instead of a Python string object to give the attribute
  /// name.</para>
  /// </summary>
  Py_tp_setattr = 68;
  /// <summary>
  /// <para>An optional pointer to the function for setting and deleting
  /// attributes.</para>
  /// <para>The signature is the same as for TPyObject.SetAttr():</para>
  /// <code>int tp_setattro(PyObject *self, PyObject *attr, PyObject *value);</code>
  /// <para>In addition, setting value to NULL to delete an attribute must be
  /// supported. It is usually convenient to set this field to
  /// TPyObject.GenericSetAttr(), which implements the normal way of setting
  /// object attributes.</para>
  /// </summary>
  Py_tp_setattro = 69;
  /// <summary>
  /// <para>An optional pointer to a function that implements the built-in
  /// operation str(). (Note that str is a type now, and str() calls the
  /// constructor for that type. This constructor calls TPyObject.Str() to do
  /// the actual work, and TPyObject.Str() will call this handler.)</para>
  /// <para>The signature is the same as for PyObject_Str():</para>
  /// <code>PyObject *tp_str(PyObject *self);</code>
  /// <para>The function must return a string or a Unicode object. It should
  /// be a "friendly" string representation of the object, as this is the
  /// representation that will be used, among other things, by the print()
  /// function.</para>
  /// </summary>
  Py_tp_str = 70;
  /// <summary>
  /// <para>An optional pointer to a traversal function for the garbage
  /// collector. This is only used if the Py_TPFLAGS_HAVE_GC flag bit
  /// is set.</para>
  /// <para>See Traversal for documentation.</para>
  /// </summary>
  Py_tp_traverse = 71;
  /// <summary>
  /// <para>An optional pointer to a static nil-terminated array of
  /// PyMemberDef structures, declaring regular data members (fields or slots)
  /// of instances of this type.</para>
  /// <para>For each entry in the array, an entry is added to the type's
  /// dictionary (see tp_dict below) containing a member descriptor.</para>
  /// </summary>
  Py_tp_members = 72;
  /// <summary>
  /// <para>An optional pointer to a static nil-terminated array of
  /// PyGetSetDef structures, declaring computed attributes of instances of
  /// this type.</para>
  /// <para>For each entry in the array, an entry is added to the type's
  /// dictionary (see tp_dict below) containing a getset descriptor.</para>
  /// </summary>
  Py_tp_getset = 73;
  /// <summary>
  /// <para>An optional pointer to an instance deallocation function.
  /// Its signature is:</para>
  /// <code>void tp_free(void *self);</code>
  /// <para>This function must free the memory allocated by tp_alloc.</para>
  /// </summary>
  Py_tp_free = 74;
  Py_nb_matrix_multiply = 75;
  Py_nb_inplace_matrix_multiply = 76;
  Py_am_await = 77;
  Py_am_aiter = 78;
  Py_am_anext = 79;
  /// <summary>
  /// <para>An optional pointer to an instance finalization function. This is
  /// the C implementation of the __del__() special method.
  /// Its signature is:</para>
  /// <code>void tp_finalize(PyObject *self);</code>
  /// <para>The primary purpose of finalization is to perform any non-trivial
  /// cleanup that must be performed before the object is destroyed, while the
  /// object and any other objects it directly or indirectly references are
  /// still in a consistent state. The finalizer is allowed to execute
  /// arbitrary Python code.</para>
  /// <para>Before Python automatically finalizes an object, some of the
  /// object's direct or indirect referents might have themselves been
  /// automatically finalized. However, none of the referents will have been
  /// automatically cleared (tp_clear) yet.</para>
  /// <para>Other non-finalized objects might still be using a finalized object,
  /// so the finalizer must leave the object in a sane state (e.g., invariants
  /// are still met).</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/typeobj.html#c.PyTypeObject.tp_finalize">See the article about PyTypeObject.tp_finalize.</see></para>
  /// </remarks>
  Py_tp_finalize = 80;
  Py_am_send = 81;
  /// <summary>
  /// <para>A vectorcall function to use for calls of this type object
  /// (rather than instances). In other words, tp_vectorcall can be used to
  /// optimize type.__call__, which typically returns a new instance of
  /// type.</para>
  /// <para>As with any vectorcall function, if tp_vectorcall is nil, the
  /// tp_call protocol (Py_TYPE(type)->tp_call) is used instead.</para>
  /// <para>Note: The vectorcall protocol requires that the vectorcall function
  /// has the same behavior as the corresponding tp_call. This means that
  /// type->tp_vectorcall must match the behavior of
  /// Py_TYPE(type)->tp_call.</para>
  /// <para>Specifically, if type uses the default metaclass,
  /// type->tp_vectorcall must behave the same as PyType_Type->tp_call,
  /// which:</para>
  /// <code>
  /// - calls type->tp_new,
  /// - if the result is a subclass of type, calls type->tp_init on the result
  ///   of tp_new, and
  /// - returns the result of tp_new.
  /// </code>
  /// <para>Typically, tp_vectorcall is overridden to optimize this process for
  /// specific tp_new and tp_init. When doing this for user-subclassable types,
  /// note that both can be overridden (using __new__() and __init__(),
  /// respectively).</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/typeobj.html#c.PyTypeObject.tp_vectorcall">See the article about PyTypeObject.tp_vectorcall.</see></para>
  /// </remarks>
  Py_tp_vectorcall = 82;
  /// <summary>
  /// <para>Slot ID for recording a static memory layout ID for a class.</para>
  /// <para>If the class is defined using a PyType_Spec, and that spec is
  /// statically allocated, the token can be set to the spec using the special
  /// value Py_TP_USE_SPEC:</para>
  /// <code>
  /// static PyType_Slot foo_slots[] = {
  ///    {Py_tp_token, Py_TP_USE_SPEC},
  /// </code>
  /// <para>It can also be set to an arbitrary pointer, but you must ensure
  /// that:</para>
  /// <code>
  /// - The pointer outlives the class, so it's not reused for something else
  ///   while the class exists.
  /// - It "belongs" to the extension module where the class lives, so it will
  ///   not clash with other extensions.
  /// </code>
  /// <para>Use TPyType.GetBaseByToken() to check if a class's superclass has
  /// a given token - that is, check whether the memory layout is
  /// compatible.</para>
  /// <para>To get the token for a given class (without considering
  /// superclasses), use TPyType.GetSlot() with Py_tp_token.</para>
  /// <para>Added in version 3.14.</para>
  /// </summary>
  Py_tp_token = 83;
  /// <summary>
  /// <para>Nested slots array.</para>
  /// <para>The value (sl_ptr) should point to an array of PySlot structures.
  /// The slots in the array (up to but not including the zero-ID terminator)
  /// will be treated as if they were inserted if the current slot array, at
  /// the point Py_slot_subslots appears.</para>
  /// <para>Slot nesting depth is limited to 5 levels. This restriction may be
  /// lifted in the future.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_slot_subslots = 92;
  /// <summary>
  /// <para>Slot ID that works like Py_slot_subslots, except it specifies an
  /// array of PyType_Slot structures.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_tp_slots = 93;
  /// <summary>
  /// <para>Slot ID for the name of the type, used to set
  /// PyTypeObject.tp_name.</para>
  /// <para>This slot (or PyType_Spec.name) is required to create a type.</para>
  /// <para>This may not be used in PyType_Spec.slots. Use PyType_Spec.name
  /// instead.</para>
  /// <para>CPython implementation detail: CPython processes slots in order.
  /// It is recommended to put Py_tp_name at the beginning of the slots array,
  /// so that if processing of a later slots fails, error messages can include
  /// the name.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_tp_name = 95;
  /// <summary>
  /// <para>Slot ID for the size of the instance in bytes. It is used to set
  /// PyTypeObject.tp_basicsize.</para>
  /// <para>The value must be positive.</para>
  /// <para>This may not be used in PyType_Spec.slots. Use
  /// PyType_Spec.basicsize instead.</para>
  /// <para>This slot may not be used with TPyType.GetSlot(). Use
  /// PyTypeObject.tp_basicsize instead if needed, but be aware that a type's
  /// size is often considered an implementation detail.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_tp_basicsize = 96;
  /// <summary>
  /// <para>Slot ID for type data size in bytes, that is, how much space
  /// instances of the class need in addition to space needed for
  /// superclasses.</para>
  /// <para>The value is used, together with the size of superclasses, to set
  /// PyTypeObject.tp_basicsize. Python will insert padding as needed to meet
  /// tp_basicsize's alignment requirements.</para>
  /// <para>Use TPyObject.GetTypeData() to get a pointer to subclass-specific
  /// memory reserved this way.</para>
  /// <para>The value must be positive. To specify that instances need no
  /// additional size (that is, size should be inherited), omit the
  /// Py_tp_extra_basicsize slot rather than set it to zero.</para>
  /// <para>Specifying both Py_tp_basicsize and Py_tp_extra_basicsize is an
  /// error.</para>
  /// <para>This may not be used in PyType_Spec.slots. Use negative
  /// PyType_Spec.basicsize instead.</para>
  /// <para>This slot may not be used with TPyType.GetSlot().</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_tp_extra_basicsize = 97;
  /// <summary>
  /// <para>Slot ID for the size of one element of a variable-size type, in
  /// bytes. Used to set PyTypeObject.tp_itemsize. See tp_itemsize
  /// documentation for caveats.</para>
  /// <para>The value must be positive.</para>
  /// <para>If this slot is missing, tp_itemsize is inherited. Extending
  /// arbitrary variable-sized classes is dangerous, since some types use a
  /// fixed offset for variable-sized memory, which can then overlap
  /// fixed-sized memory used by a subclass. To help prevent mistakes,
  /// inheriting itemsize is only possible in the following situations:</para>
  /// <code>
  /// - The base is not variable-sized (its tp_itemsize is zero).
  /// - The requested PyType_Spec.basicsize is positive, suggesting that the
  ///   memory layout of the base class is known.
  /// - The requested PyType_Spec.basicsize is zero, suggesting that the
  ///   subclass does not access the instance's memory directly.
  /// - With the Py_TPFLAGS_ITEMS_AT_END flag.
  /// </code>
  /// <para>This may not be used in PyType_Spec.slots. Use PyType_Spec.itemsize
  /// instead.</para>
  /// <para>This slot may not be used with TPyType.GetSlot().</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_tp_itemsize = 98;
  /// <summary>
  /// <para>Slot ID for type flags, used to set PyTypeObject.tp_flags.</para>
  /// <para>The Py_TPFLAGS_HEAPTYPE flag is not set, TPyType.FromSpecWithBases()
  /// sets it automatically.</para>
  /// <para>This may not be used in PyType_Spec.slots. Use negative
  /// PyType_Spec.basicsize instead.</para>
  /// <para>This slot may not be used with PyType_GetSlot(). Use
  /// TPyType.GetFlags() instead.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_tp_flags = 99;
  /// <summary>
  /// <para>Slot ID for the metaclass used to construct the resulting type
  /// object. When omitted the metaclass is derived from bases (Py_tp_bases or
  /// the bases argument of TPyType.FromMetaclass()).</para>
  /// <para>Metaclasses that override tp_new are not supported, except if
  /// tp_new is nil.</para>
  /// <para>This may not be used in PyType_Spec.slots. Use
  /// TPyType.FromMetaclass() to specify a metaclass with PyType_Spec.</para>
  /// <para>This slot may not be used with TPyType.GetSlot(). Use TPy.TYPE_()
  /// on the type object instead.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_tp_metaclass = 107;
  /// <summary>
  /// <para>Slot ID for recording the module in which the new class is
  /// defined.</para>
  /// <para>The value must be a module object. The module is associated with
  /// the new type and can later be retrieved with TPyType.GetModule().
  /// The associated module is not inherited by subclasses; it must be
  /// specified for each class individually.</para>
  /// <para>This may not be used in PyType_Spec.slots. Use
  /// TPyType.FromMetaclass() to specify a module with PyType_Spec.</para>
  /// <para>This slot may not be used with TPyType.GetSlot(). Use
  /// TPyType.GetModule() instead.</para>
  /// <para>Added in version 3.15.</para>
  /// </summary>
  Py_tp_module = 108;


  {* include/pyhash.h  include/cpython/pyhash.h *}

  /// <summary>
  /// <para>Buffers of length in range [1, Py_HASH_CUTOFF) are hashed using
  /// DJBX33A instead of the algorithm described by Py_HASH_ALGORITHM.</para>
  /// <para>A Py_HASH_CUTOFF of 0 disables the optimization.</para>
  /// <para>Py_HASH_CUTOFF must be non-negative and less or equal than 7.</para>
  /// <para>32-bit platforms should use a cutoff smaller than 64-bit platforms
  /// because it is easier to create colliding strings. A cutoff of 7 on 64-bit
  /// platforms and 5 on 32-bit platforms should provide a decent safety
  /// margin.</para>
  /// <para>This corresponds to the sys.hash_info.cutoff constant.</para>
  /// </summary>
  Py_HASH_CUTOFF    = 0;
  /// <summary>
  /// <para>Numerical value to compare to Py_HASH_ALGORITHM to determine which
  /// algorithm is used for hashing. The built-in hash algorithm can be
  /// configured via the configure --with-hash-algorithm option.</para>
  /// <para>Py_HASH_EXTERNAL has value 0 and indicates a hash implementation
  /// supplied by the application embedding Python; see PyHash_Func.</para>
  /// </summary>
  Py_HASH_EXTERNAL  = 0;
  /// <summary>
  /// <para>Numerical value to compare to Py_HASH_ALGORITHM to determine which
  /// algorithm is used for hashing. The built-in hash algorithm can be
  /// configured via the configure --with-hash-algorithm option.</para>
  /// <para>Py_HASH_EXTERNAL has value 0 and indicates a hash implementation
  /// supplied by the application embedding Python; see PyHash_Func.</para>
  /// </summary>
  Py_HASH_SIPHASH24 = 1;
  /// <summary>
  /// <para>Numerical value to compare to Py_HASH_ALGORITHM to determine which
  /// algorithm is used for hashing. The built-in hash algorithm can be
  /// configured via the configure --with-hash-algorithm option.</para>
  /// <para>Py_HASH_EXTERNAL has value 0 and indicates a hash implementation
  /// supplied by the application embedding Python; see PyHash_Func.</para>
  /// </summary>
  Py_HASH_FNV       = 2;
  /// <summary>
  /// <para>Numerical value to compare to Py_HASH_ALGORITHM to determine which
  /// algorithm is used for hashing. The built-in hash algorithm can be
  /// configured via the configure --with-hash-algorithm option.</para>
  /// <para>Py_HASH_EXTERNAL has value 0 and indicates a hash implementation
  /// supplied by the application embedding Python; see PyHash_Func.</para>
  /// </summary>
  Py_HASH_SIPHASH13 = 3;
  /// <summary>
  /// <para>A numerical value indicating the algorithm for hashing of str,
  /// bytes, and memoryview.</para>
  /// <para>The algorithm name is exposed by sys.hash_info.algorithm.</para>
  /// </summary>
  Py_HASH_ALGORITHM = Py_HASH_SIPHASH13;
  /// <summary>
  /// <para>Prime multiplier used in string and various other hashes.</para>
  /// </summary>
  PyHASH_MULTIPLIER = 1000003;
  {$IFDEF TARGET_64BITS}
  /// <summary>
  /// <para>The exponent n of P in PyHASH_MODULUS.</para>
  /// </summary>
  PyHASH_BITS    = 61;
  /// <summary>
  /// <para>The Mersenne prime P = 2**n -1, used for numeric hash scheme.</para>
  /// <para>This corresponds to the sys.hash_info.modulus constant.</para>
  /// </summary>
  PyHASH_MODULUS = $1FFFFFFFFFFFFFFF;
  {$ELSE}
  /// <summary>
  /// <para>The exponent n of P in PyHASH_MODULUS.</para>
  /// </summary>
  PyHASH_BITS    = 31;
  /// <summary>
  /// <para>The Mersenne prime P = 2**n -1, used for numeric hash scheme.</para>
  /// <para>This corresponds to the sys.hash_info.modulus constant.</para>
  /// </summary>
  PyHASH_MODULUS = $7FFFFFFF;
  {$ENDIF}
  /// <summary>
  /// <para>The hash value returned for a positive infinity.</para>
  /// <para>This corresponds to the sys.hash_info.inf constant.</para>
  /// </summary>
  PyHASH_INF  = 314159;
  /// <summary>
  /// <para>The multiplier used for the imaginary part of a complex number.</para>
  /// <para>This corresponds to the sys.hash_info.imag constant.</para>
  /// </summary>
  PyHASH_IMAG = PyHASH_MULTIPLIER;


  {* include/cpython/pydebug.h *}
  {* include/bytearrayobject.h *}
  {* include/bytesobject.h  include/cpython/bytesobject.h *}
  {* include/unicodeobject.h  include/cpython/unicodeobject.h *}
  {* include/pyerrors.h  include/cpython/pyerrors.h *}
  {* include/longobject.h  include/cpython/longobject.h *}
  Py_ASNATIVEBYTES_DEFAULTS        = -1;
  Py_ASNATIVEBYTES_BIG_ENDIAN      = 0;
  Py_ASNATIVEBYTES_LITTLE_ENDIAN   = 1;
  Py_ASNATIVEBYTES_NATIVE_ENDIAN   = 3;
  Py_ASNATIVEBYTES_UNSIGNED_BUFFER = 4;
  Py_ASNATIVEBYTES_REJECT_NEGATIVE = 8;
  Py_ASNATIVEBYTES_ALLOW_INDEX     = 16;

  {* include/longintrepr.h  include/cpython/longintrepr.h *}
  {* include/boolobject.h *}
  {* include/floatobject.h  include/cpython/floatobject.h *}
  {* include/complexobject.h  include/cpython/complexobject.h *}
  {* include/rangeobject.h *}
  {* include/memoryobject.h *}
  {* include/tupleobject.h *}
  {* include/listobject.h  include/cpython/listobject.h *}
  {* include/dictobject.h  include/cpython/dictobject.h  *}
  {* include/cpython/odictobject.h *}
  {* include/enumobject.h *}
  {* include/setobject.h  include/cpython/setobject.h *}
  {* include/methodobject.h  include/cpython/methodobject.h *}

  /// <summary>
  /// <para>This is the typical calling convention, where the methods have the
  /// type PyCFunction. The function expects two PyObject* values. The first
  /// one is the self object for methods; for module functions, it is the
  /// module object. The second parameter (often called args) is a tuple object
  /// representing all arguments. This parameter is typically processed using
  /// TPyArg.ParseTuple() or TPyArg.UnpackTuple().</para>
  /// <para>------------</para>
  /// <para>METH_VARARGS | METH_KEYWORDS</para>
  /// <para>Methods with these flags must be of type PyCFunctionWithKeywords.
  /// The function expects three parameters: self, args, kwargs where kwargs
  /// is a dictionary of all the keyword arguments or possibly nil if there
  /// are no keyword arguments. The parameters are typically processed using
  /// TPyArg.ParseTupleAndKeywords().</para>
  /// </summary>
  METH_VARARGS   = $0001;
  /// <summary>
  /// <para>Can only be used in certain combinations with other flags:
  /// METH_VARARGS | METH_KEYWORDS, METH_FASTCALL |
  /// METH_KEYWORDS and METH_METHOD | METH_FASTCALL | METH_KEYWORDS.</para>
  /// <para>------------</para>
  /// <para>METH_VARARGS | METH_KEYWORDS</para>
  /// <para>Methods with these flags must be of type PyCFunctionWithKeywords.
  /// The function expects three parameters: self, args, kwargs where kwargs
  /// is a dictionary of all the keyword arguments or possibly nil if there
  /// are no keyword arguments. The parameters are typically processed using
  /// TPyArg.ParseTupleAndKeywords().</para>
  /// <para>------------</para>
  /// <para>METH_METHOD | METH_FASTCALL | METH_KEYWORDS</para>
  /// <para>Extension of METH_FASTCALL | METH_KEYWORDS supporting the defining
  /// class, that is, the class that contains the method in question.
  /// The defining class might be a superclass of TPy.TYPE(self).</para>
  /// <para>The method needs to be of type PyCMethod, the same as for
  /// METH_FASTCALL | METH_KEYWORDS with defining_class argument added after
  /// self.</para>
  /// </summary>
  METH_KEYWORDS  = $0002;
  /// <summary>
  /// <para>Methods without parameters don’t need to check whether arguments
  /// are given if they are listed with the METH_NOARGS flag. They need to be
  /// of type PyCFunction. The first parameter is typically named self and will
  /// hold a reference to the module or object instance. In all cases the
  /// second parameter will be nil.</para>
  /// <para>The function must have 2 parameters. Since the second parameter
  /// is unused, Py_UNUSED can be used to prevent a compiler warning.</para>
  /// </summary>
  METH_NOARGS    = $0004;
  /// <summary>
  /// <para>Methods with a single object argument can be listed with the
  /// METH_O flag, instead of invoking TPyArg.ParseTuple() with a "O" argument.
  /// They have the type PyCFunction, with the self parameter, and a PyObject*
  /// parameter representing the single argument.</para>
  /// </summary>
  METH_O         = $0008;
  /// <summary>
  /// <para>The method will be passed the type object as the first parameter
  /// rather than an instance of the type. This is used to create class
  /// methods, similar to what is created when using the @classmethod built-in
  /// decorator.</para>
  /// <para>This constants are not used to indicate the calling convention but
  /// the binding when used with methods of classes. This may not be used for
  /// functions defined for modules.</para>
  /// </summary>
  METH_CLASS     = $0010;
  /// <summary>
  /// <para>The method will be passed NULL as the first parameter rather than
  /// an instance of the type. This is used to create static methods, similar
  /// to what is created when using the @staticmethod built-in decorator.</para>
  /// <para>This constants are not used to indicate the calling convention but
  /// the binding when used with methods of classes. This may not be used for
  /// functions defined for modules.</para>
  /// </summary>
  METH_STATIC    = $0020;
  /// <summary>
  /// <para>The method will be loaded in place of existing definitions.
  /// Without METH_COEXIST, the default is to skip repeated definitions.
  /// Since slot wrappers are loaded before the method table, the existence of
  /// a sq_contains slot, for example, would generate a wrapped method named
  /// __contains__() and preclude the loading of a corresponding PyCFunction
  /// with the same name. With the flag defined, the PyCFunction will be
  /// loaded in place of the wrapper object and will co-exist with the slot.
  /// This is helpful because calls to PyCFunctions are optimized more than
  /// wrapper object calls.</para>
  /// </summary>
  METH_COEXIST   = $0040;
  /// <summary>
  /// <para>Fast calling convention supporting only positional arguments.
  /// The methods have the type PyCFunctionFast. The first parameter is self,
  /// the second parameter is a C array of PyObject* values indicating the
  /// arguments and the third parameter is the number of arguments (the length
  /// of the array).</para>
  /// <para>------------</para>
  /// <para>METH_METHOD | METH_FASTCALL | METH_KEYWORDS</para>
  /// <para>Extension of METH_FASTCALL | METH_KEYWORDS supporting the defining
  /// class, that is, the class that contains the method in question.
  /// The defining class might be a superclass of TPy.TYPE(self).</para>
  /// <para>The method needs to be of type PyCMethod, the same as for
  /// METH_FASTCALL | METH_KEYWORDS with defining_class argument added after
  /// self.</para>
  /// </summary>
  METH_FASTCALL  = $0080;
  /// <summary>
  /// <para>This bit is preserved for Stackless Python.</para>
  /// </summary>
  METH_STACKLESS = $0000; // $0100;
  /// <summary>
  /// <para>Can only be used in the combination with other flags:
  /// METH_METHOD | METH_FASTCALL | METH_KEYWORDS.</para>
  /// <para></para>
  /// <para>METH_METHOD | METH_FASTCALL | METH_KEYWORDS</para>
  /// <para>Extension of METH_FASTCALL | METH_KEYWORDS supporting the defining
  /// class, that is, the class that contains the method in question.
  /// The defining class might be a superclass of TPy.TYPE(self).</para>
  /// <para>The method needs to be of type PyCMethod, the same as for
  /// METH_FASTCALL | METH_KEYWORDS with defining_class argument added after
  /// self.</para>
  /// </summary>
  METH_METHOD    = $0200;


  {* include/moduleobject.h *}

  /// <summary>
  /// <para>The module does not support being imported in
  /// subinterpreters.</para>
  /// </summary>
  Py_MOD_MULTIPLE_INTERPRETERS_NOT_SUPPORTED  : Pointer = Pointer(0);
  /// <summary>
  /// <para>The module supports being imported in subinterpreters, but only when
  /// they share the main interpreter's GIL.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/howto/isolating-extensions.html#isolating-extensions-howto">See the article about Isolating Extension Modules.</see></para>
  /// </remarks>
  Py_MOD_MULTIPLE_INTERPRETERS_SUPPORTED      : Pointer = Pointer(1);
  /// <summary>
  /// <para>The module supports being imported in subinterpreters, even when
  /// they have their own GIL.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/howto/isolating-extensions.html#isolating-extensions-howto">See the article about Isolating Extension Modules.</see></para>
  /// </remarks>
  Py_MOD_PER_INTERPRETER_GIL_SUPPORTED        : Pointer = Pointer(2);

  /// <summary>
  /// <para>The module depends on the presence of the global interpreter lock
  /// (GIL), and may access global state without synchronization.</para>
  /// </summary>
  Py_MOD_GIL_USED                             : Pointer = Pointer(0);
  /// <summary>
  /// <para>The module is safe to run without an active GIL.</para>
  /// </summary>
  Py_MOD_GIL_NOT_USED                         : Pointer = Pointer(1);

  {* include/monitoring.h  include/cpython/monitoring.h *}
  PY_MONITORING_EVENT_PY_START          = 0;
  PY_MONITORING_EVENT_PY_RESUME         = 1;
  PY_MONITORING_EVENT_PY_RETURN         = 2;
  PY_MONITORING_EVENT_PY_YIELD          = 3;
  PY_MONITORING_EVENT_CALL              = 4;
  PY_MONITORING_EVENT_LINE              = 5;
  PY_MONITORING_EVENT_INSTRUCTION       = 6;
  PY_MONITORING_EVENT_JUMP              = 7;
  PY_MONITORING_EVENT_BRANCH_LEFT       = 8;
  PY_MONITORING_EVENT_BRANCH_RIGHT      = 9;
  PY_MONITORING_EVENT_STOP_ITERATION    = 10;
  PY_MONITORING_EVENT_RAISE             = 11;
  PY_MONITORING_EVENT_EXCEPTION_HANDLED = 12;
  PY_MONITORING_EVENT_PY_UNWIND         = 13;
  PY_MONITORING_EVENT_PY_THROW          = 14;
  PY_MONITORING_EVENT_RERAISE           = 15;
  PY_MONITORING_EVENT_C_RETURN          = 16;
  PY_MONITORING_EVENT_C_RAISE           = 17;
  PY_MONITORING_EVENT_BRANCH            = 18;

  {* include/cpython/funcobject.h *}
  {* include/cpython/classobject.h *}
  {* include/fileobject.h  include/cpython/fileobject.h *}
  {* include/pycapsule.h *}
  {* include/cpython/code.h *}
  CO_OPTIMIZED    = $0001;
  CO_NEWLOCALS    = $0002;
  CO_VARARGS      = $0004;
  CO_VARKEYWORDS  = $0008;
  CO_NESTED       = $0010;
  CO_GENERATOR    = $0020;

  CO_COROUTINE            = $0080;
  CO_ITERABLE_COROUTINE   = $0100;
  CO_ASYNC_GENERATOR      = $0200;

  CO_FUTURE_DIVISION         = $0020000;
  CO_FUTURE_ABSOLUTE_IMPORT  = $0040000;
  CO_FUTURE_WITH_STATEMENT   = $0080000;
  CO_FUTURE_PRINT_FUNCTION   = $0100000;
  CO_FUTURE_UNICODE_LITERALS = $0200000;

  CO_FUTURE_BARRY_AS_BDFL    = $0400000;
  CO_FUTURE_GENERATOR_STOP   = $0800000;
  CO_FUTURE_ANNOTATIONS      = $1000000;

  CO_NO_MONITORING_EVENTS    = $2000000;

  CO_HAS_DOCSTRING           = $4000000;

  CO_METHOD                  = $8000000;

  CO_MAXBLOCKS               = 21;

  {* include/pyframe.h  include/cpython/pyframe.h *}
  {* include/traceback.h  include/cpython/traceback.h *}
  {* include/sliceobject.h  include/cpython/sliceobject.h *}
  {* include/cpython/cellobject.h *}
  {* include/iterobject.h *}
  {* include/cpython/initconfig.h *}
  {* include/pystate.h  include/cpython/pystate.h *}
  PyTrace_CALL        = 0;
  PyTrace_EXCEPTION   = 1;
  PyTrace_LINE        = 2;
  PyTrace_RETURN      = 3;
  PyTrace_C_CALL      = 4;
  PyTrace_C_EXCEPTION = 5;
  PyTrace_C_RETURN    = 6;
  PyTrace_OPCODE      = 7;

  {* include/cpython/genobject.h *}
  {* include/descrobject.h  include/cpython/descrobject.h *}
  Py_T_SHORT            = 0;
  Py_T_INT              = 1;
  Py_T_LONG             = 2;
  Py_T_FLOAT            = 3;
  Py_T_DOUBLE           = 4;
  Py_T_STRING           = 5;
  _Py_T_OBJECT          = 6;  // Deprecated, use Py_T_OBJECT_EX instead
  Py_T_CHAR             = 7;
  Py_T_BYTE             = 8;
  Py_T_UBYTE            = 9;
  Py_T_USHORT           = 10;
  Py_T_UINT             = 11;
  Py_T_ULONG            = 12;
  Py_T_STRING_INPLACE   = 13;
  Py_T_BOOL             = 14;
  Py_T_OBJECT_EX        = 16;
  Py_T_LONGLONG         = 17;
  Py_T_ULONGLONG        = 18;
  Py_T_PYSSIZET         = 19;
  _Py_T_NONE            = 20; // Deprecated. Value is always None.

  Py_READONLY           = 1 shl 0;
  Py_AUDIT_READ         = 1 shl 1; // Added in 3.10, harmless no-op before that
  _Py_WRITE_RESTRICTED  = 1 shl 2; // Deprecated, no-op. Do not reuse the value.
  Py_RELATIVE_OFFSET    = 1 shl 3;
  _Py_AFTER_ITEMS       = 1 shl 4;

  /// <summary>
  /// Flag for wrapperbase.
  /// The wrapper function takes keyword args.
  /// </summary>
  PyWrapperFlag_KEYWORDS = 1;

  {* include/genericaliasobject.h *}
  {* include/cpython/sentinelobject.h *}
  {* include/warnings.h  include/cpython/warnings.h *}
  {* include/weakrefobject.h  include/cpython/weakrefobject.h *}
  {* include/structseq.h  include/cpython/structseq.h *}
  {* include/cpython/picklebufobject.h *}
  {* include/cpython/pytime.h *}

  /// <summary>
  /// Minimum value of PyTime_t.
  /// </summary>
  PyTime_MIN = low(int64);
  /// <summary>
  /// Maximum value of PyTime_t.
  /// </summary>
  PyTime_MAX = high(int64);

  {* include/codecs.h *}
  {* include/pythread.h  include/cpython/pythread.h *}
  WAIT_LOCK             = 1;
  NOWAIT_LOCK           = 0;

  LLONG_MAX             = high(int64);
  {$IFDEF POSIX}
  PY_TIMEOUT_MAX_VALUE  = LLONG_MAX / 1000;
  {$ELSE}
    {$IFDEF MSWINDOWS}
    PY_TIMEOUT_MAX_VALUE = $3E7FFFFF830; // int64($FFFFFFFE) * 1000;
    {$ELSE}
    PY_TIMEOUT_MAX_VALUE = LLONG_MAX;
    {$ENDIF}
  {$ENDIF}
  PY_TIMEOUT_MAX        = PY_TIMEOUT_MAX_VALUE;


{* #define PYTHREAD_INVALID_THREAD_ID ((unsigned long)-1) *}
{$IFDEF MSWINDOWS}
  PYTHREAD_INVALID_THREAD_ID = Cardinal(-1);
{$ELSE}
  PYTHREAD_INVALID_THREAD_ID = NativeUInt(-1);
{$ENDIF}

  {* include/cpython/context.h *}
  {* include/modsupport.h  include/cpython/modsupport.h *}
  Py_CLEANUP_SUPPORTED = $20000;

  /// <summary>
  /// Specifies that Stable ABI is used.
  /// </summary>
  PyABIInfo_STABLE                 = $0001;
  /// <summary>
  /// Specifies ABI compatible with non-free-threaded builds of CPython
  /// (ones compiled without --disable-gil).
  /// </summary>
  PyABIInfo_GIL                    = $0002;
  /// <summary>
  /// Specifies ABI compatible with free-threaded builds of CPython.
  /// (That is, ones compiled with --disable-gil; with t in sys.abiflags).
  /// </summary>
  PyABIInfo_FREETHREADED           = $0004;
  /// <summary>
  /// Specifies ABI specific to a particular build of CPython. Internal use only.
  /// </summary>
  PyABIInfo_INTERNAL               = $0008;
  /// <summary>
  /// Specifies ABI compatible with both free-threaded and non-free-threaded
  /// builds of CPython, that is, both abi3 and abi3t.
  /// </summary>
  PyABIInfo_FREETHREADING_AGNOSTIC = PyABIInfo_GIL or PyABIInfo_FREETHREADED;


  {* include/compile.h  include/cpython/compile.h *}
  Py_single_input    = 256;
  Py_file_input      = 257;
  Py_eval_input      = 258;
  Py_func_type_input = 345;

  PyCF_MASK = CO_FUTURE_DIVISION or
              CO_FUTURE_ABSOLUTE_IMPORT or
              CO_FUTURE_WITH_STATEMENT or
              CO_FUTURE_PRINT_FUNCTION or
              CO_FUTURE_UNICODE_LITERALS or
              CO_FUTURE_BARRY_AS_BDFL or
              CO_FUTURE_GENERATOR_STOP or
              CO_FUTURE_ANNOTATIONS;

  PyCF_SOURCE_IS_UTF8         = $0100;
  PyCF_DONT_IMPLY_DEDENT      = $0200;
  PyCF_ONLY_AST               = $0400;
  PyCF_IGNORE_COOKIE          = $0800;
  PyCF_TYPE_COMMENTS          = $1000;
  PyCF_ALLOW_TOP_LEVEL_AWAIT  = $2000;
  PyCF_ALLOW_INCOMPLETE_INPUT = $4000;
  PyCF_OPTIMIZED_AST          = $8000 or PyCF_ONLY_AST;
  PyCF_COMPILE_MASK           = PyCF_ONLY_AST or
                                PyCF_ALLOW_TOP_LEVEL_AWAIT or
                                PyCF_TYPE_COMMENTS or
                                PyCF_DONT_IMPLY_DEDENT or
                                PyCF_ALLOW_INCOMPLETE_INPUT or
                                PyCF_OPTIMIZED_AST;

  FUTURE_NESTED_SCOPES    = 'nested_scopes';
  FUTURE_GENERATORS       = 'generators';
  FUTURE_DIVISION         = 'division';
  FUTURE_ABSOLUTE_IMPORT  = 'absolute_import';
  FUTURE_WITH_STATEMENT   = 'with_statement';
  FUTURE_PRINT_FUNCTION   = 'print_function';
  FUTURE_UNICODE_LITERALS = 'unicode_literals';
  FUTURE_BARRY_AS_BDFL    = 'barry_as_FLUFL';
  FUTURE_GENERATOR_STOP   = 'generator_stop';
  FUTURE_ANNOTATIONS      = 'annotations';

  PY_INVALID_STACK_EFFECT = high(integer);

  {* include/pythonrun.h  include/cpython/pythonrun.h *}
  {* include/pylifecycle.h  include/cpython/pylifecycle.h *}

  /// <summary>
  /// Use the default selection (PyInterpreterConfig_SHARED_GIL).
  /// Used in PyInterpreterConfig.gil
  /// </summary>
  PyInterpreterConfig_DEFAULT_GIL = 0;
  /// <summary>
  /// Use (share) the main interpreter's GIL.
  /// Used in PyInterpreterConfig.gil
  /// </summary>
  PyInterpreterConfig_SHARED_GIL  = 1;
  /// <summary>
  /// Use the sub-interpreter's own GIL.
  /// Used in PyInterpreterConfig.gil
  /// </summary>
  PyInterpreterConfig_OWN_GIL     = 2;

  {* include/ceval.h  include/cpython/ceval.h *}
  FVC_MASK      = $3;
  FVC_NONE      = $0;
  FVC_STR       = $1;
  FVC_REPR      = $2;
  FVC_ASCII     = $3;
  FVS_MASK      = $4;
  FVS_HAVE_SPEC = $4;

  {* include/sysmodule.h *}
  {* include/audit.h  include/cpython/audit.h *}
  {* include/osmodule.h *}
  {* include/intrcheck.h *}
  {* include/import.h  include/cpython/import.h *}
  {* include/abstract.h  include/cpython/abstract.h *}
  {* include/bltinmodule.h *}
  {* include/cpython/pyctype.h *}
  {* include/pystrtod.h *}

  /// <summary>
  /// <para>Always precede the returned string with a sign character, even if
  /// val is non-negative.</para>
  /// </summary>
  Py_DTSF_SIGN      = $01;
  /// <summary>
  /// <para>Ensure that the returned string will not look like an
  /// integer.</para>
  /// </summary>
  Py_DTSF_ADD_DOT_0 = $02;
  /// <summary>
  /// <para>Apply "alternate" formatting rules. See the documentation for the
  /// TPyOS.snprintf() '#' specifier for details.</para>
  /// </summary>
  Py_DTSF_ALT       = $04;
  /// <summary>
  /// <para>Negative zero is converted to positive zero.
  /// Added in version 3.11.</para>
  /// </summary>
  Py_DTSF_NO_NEG_0  = $08;

  /// <summary>
  /// <para>finite number</para>
  /// </summary>
  Py_DTST_FINITE    = 0;
  /// <summary>
  /// <para>infinite number</para>
  /// </summary>
  Py_DTST_INFINITE  = 1;
  /// <summary>
  /// <para>not a number</para>
  /// </summary>
  Py_DTST_NAN       = 2;

  {* include/pystrcmp.h *}
  {* include/fileutils.h  include/cpython/fileutils.h *}
  {* include/cpython/pyfpe.h *}
  {* include/cpython/tracemalloc.h *}
  {* include/frameobject.h  include/cpython/frameobject.h *}
  {* include/datetime.h *}

  /// <summary>
  /// # of bytes for year, month, and day.
  /// </summary>
  _PyDateTime_DATE_DATASIZE      = 4;
  /// <summary>
  ///  of bytes for hour, minute, second, and usecond.
  /// </summary>
  _PyDateTime_TIME_DATASIZE      = 6;
  /// <summary>
  /// # of bytes for year, month, day, hour, minute, second, and usecond.
  /// </summary>
  _PyDateTime_DATETIME_DATASIZE  = 10;

implementation

end.
