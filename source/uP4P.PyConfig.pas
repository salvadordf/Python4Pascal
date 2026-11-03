unit uP4P.PyConfig;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

{$IFNDEF FPC}{$IFNDEF DELPHI12_UP}
  // Workaround for "Internal error" in old Delphi versions caused by uint64 handling
  {$R-}
{$ENDIF}{$ENDIF}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.Types, System.SysUtils,
  {$ELSE}
    Classes, Types, SysUtils,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces;

{*
 Update the SUPPORTED_MAJOR_VERSION, MAX_SUPPORTED_MINOR_VERSION and
 MIN_SUPPORTED_MINOR_VERSION constant values and also the TPyConfigBuilder.New
 function after creating a new TPyConfigXY class.
*}

type
  /// <summary>
  /// <para>Helper class for all the PyConfig_* methods.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3.15/c-api/init_config.html#runtime-python-configuration-api">See the article about Runtime Python configuration API.</see></para>
  /// </remarks>
  TPyConfig = class
    public
      /// <summary>
      /// <para>Get all configuration option names as a frozenset.</para>
      /// <code>
      /// - Return a new reference on success.
      /// - Set an exception and return nil on error.
      /// </code>
      /// <para>The caller must have an attached thread state. The function
      /// cannot be called before Python initialization nor after Python
      /// finalization.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function Names: IPyObject;
      /// <summary>
      /// <para>Similar to TPyConfig.Get(), but get the value as a C int.</para>
      /// <para>Return True on success. Set an exception and return False on
      /// error.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function GetInt(const name_: string; var value: integer): boolean;
      /// <summary>
      /// <para>Similar to TPyConfig.Get(), but get the value as a
      /// boolean.</para>
      /// <para>Return True on success. Set an exception and return False on
      /// error.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function GetBoolean(const name_: string; var value: boolean): boolean;
      /// <summary>
      /// <para>Get the current runtime value of a configuration option as a
      /// Python object.</para>
      /// <para>Return a new reference on success.</para>
      /// <para>Set an exception and return nil on error.</para>
      /// <para>The object type depends on the configuration option. It can
      /// be:</para>
      /// <code>
      /// - bool
      /// - int
      /// - str
      /// - list[str]
      /// - dict[str, str]
      /// </code>
      /// <para>The caller must have an attached thread state. The function
      /// cannot be called before Python initialization nor after Python
      /// finalization.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      class function Get(const name_: string): IPyObject;
      /// <summary>
      /// <para>Set the current runtime value of a configuration option.</para>
      /// <code>
      /// - Raise a ValueError if there is no option name.
      /// - Raise a ValueError if value is an invalid value.
      /// - Raise a ValueError if the option is read-only (cannot be set).
      /// - Raise a TypeError if value has not the proper type.
      /// </code>
      /// <para>The caller must have an attached thread state. The function
      /// cannot be called before Python initialization nor after Python
      /// finalization.</para>
      /// <para>Raises an auditing event cpython.PyConfig_Set with arguments
      /// name, value.</para>
      /// <para>Added in version 3.14.</para>
      /// <para>Changed in version 3.15: The function now replaces sys.flags
      /// (create a new object), instead of modifying sys.flags in-place.</para>
      /// </summary>
      class function Set_(const name_: string; const value: IPyObject): boolean;
  end;

  /// <summary>
  /// Class containing most parameters to configure Python.
  /// When done, the PyConfig_Clear() function must be used to release the configuration memory.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/init_config.html#pyconfig">See the article about PyConfig.</see></para>
  /// </remarks>
  TPyConfigBase = class(TInterfacedObject, IPyConfig)
    protected
      function GetConfig: Pointer; virtual;
      function Get_argv: TStringDynArray; virtual;
      function Get_base_exec_prefix: string; virtual;
      function Get_base_executable: string; virtual;
      function Get_base_prefix: string; virtual;
      function Get_buffered_stdio: boolean; virtual;
      function Get_bytes_warning: integer; virtual;
      function Get_check_hash_pycs_mode: string; virtual;
      function Get_code_debug_ranges: boolean; virtual;
      function Get_configure_c_stdio: boolean; virtual;
      function Get_context_aware_warnings: boolean; virtual;
      {$IFDEF APPLE}
      function Get_use_system_logger: boolean; virtual;
      {$ENDIF}
      function Get_cpu_count: integer; virtual;
      function Get_dev_mode: boolean; virtual;
      function Get_dump_refs: boolean; virtual;
      function Get_dump_refs_file: string; virtual;
      function Get_exec_prefix: string; virtual;
      function Get_executable: string; virtual;
      function Get_faulthandler: integer; virtual;
      function Get_use_peg_parser: boolean; virtual;
      function Get_filesystem_encoding: string; virtual;
      function Get_filesystem_errors: string; virtual;
      function Get_hash_seed: uint64; virtual;
      function Get_home: string; virtual;
      function Get_import_time: integer; virtual;
      function Get_inspect: boolean; virtual;
      function Get_install_signal_handlers: boolean; virtual;
      function Get_int_max_str_digits: integer; virtual;
      function Get_interactive: boolean; virtual;
      function Get_isolated: boolean; virtual;
      function Get_lazy_imports: PyImport_LazyImportsMode; virtual;              //****** 3.15.0
      {$IFDEF MSWINDOWS}
      function Get_legacy_windows_stdio: boolean; virtual;
      {$ENDIF}
      function Get_malloc_stats: boolean; virtual;
      function Get_module_search_paths: string; virtual;
      function Get_module_search_paths_set: boolean; virtual;
      function Get_optimization_level: TPyOptimizationLevel; virtual;
      function Get_orig_argv: TStringDynArray; virtual;
      function Get_parse_argv: boolean; virtual;
      function Get_parser_debug: boolean; virtual;
      function Get_pathconfig_warnings: boolean; virtual;
      function Get_perf_profiling: integer; virtual;
      function Get_platlibdir: string; virtual;
      function Get_prefix: string; virtual;
      function Get_program_name: string; virtual;
      function Get_pycache_prefix: string; virtual;
      function Get_pymalloc_hugepages: boolean; virtual;                         //****** 3.15.0
      function Get_pythonpath_env: string; virtual;
      function Get_quiet: boolean; virtual;
      function Get_remote_debug: boolean; virtual;
      function Get_run_command: string; virtual;
      function Get_run_filename: string; virtual;
      function Get_run_module: string; virtual;
      function Get_safe_path: boolean; virtual;
      function Get_show_ref_count: boolean; virtual;
      function Get_site_import: boolean; virtual;
      function Get_skip_source_first_line: boolean; virtual;
      function Get_stdio_encoding: string; virtual;
      function Get_stdio_errors: string; virtual;
      function Get_stdlib_dir: string; virtual;
      function Get_sys_path_0: string; virtual;
      function Get_thread_inherit_context: boolean; virtual;
      function Get_tracemalloc: boolean; virtual;
      function Get_use_environment: boolean; virtual;
      function Get_use_frozen_modules: boolean; virtual;
      function Get_use_hash_seed: boolean; virtual;
      function Get_user_site_directory: boolean; virtual;
      function Get_verbose: TPyVerboseMode; virtual;
      function Get_warn_default_encoding: boolean; virtual;
      function Get_warnoptions: TStringDynArray; virtual;
      function Get_write_bytecode: boolean; virtual;
      function Get_xoptions: TStringDynArray; virtual;

      procedure Set_argv(const aValue: TStringDynArray); virtual;
      procedure Set_base_exec_prefix(const aValue: string); virtual;
      procedure Set_base_executable(const aValue: string); virtual;
      procedure Set_base_prefix(const aValue: string); virtual;
      procedure Set_buffered_stdio(aValue: boolean); virtual;
      procedure Set_bytes_warning(aValue: integer); virtual;
      procedure Set_check_hash_pycs_mode(const aValue: string); virtual;
      procedure Set_code_debug_ranges(aValue: boolean); virtual;
      procedure Set_configure_c_stdio(aValue: boolean); virtual;
      procedure Set_context_aware_warnings(aValue: boolean); virtual;
      {$IFDEF APPLE}
      procedure Set_use_system_logger(aValue: boolean); virtual;
      {$ENDIF}
      procedure Set_cpu_count(aValue: integer); virtual;
      procedure Set_dev_mode(aValue: boolean); virtual;
      procedure Set_dump_refs(aValue: boolean); virtual;
      procedure Set_dump_refs_file(const aValue: string); virtual;
      procedure Set_exec_prefix(const aValue: string); virtual;
      procedure Set_executable(const aValue: string); virtual;
      procedure Set_faulthandler(aValue: integer); virtual;
      procedure Set_use_peg_parser(aValue: boolean); virtual;
      procedure Set_filesystem_encoding(const aValue: string); virtual;
      procedure Set_filesystem_errors(const aValue: string); virtual;
      procedure Set_hash_seed(aValue: uint64); virtual;
      procedure Set_home(const aValue: string); virtual;
      procedure Set_import_time(aValue: integer); virtual;
      procedure Set_inspect(aValue: boolean); virtual;
      procedure Set_install_signal_handlers(aValue: boolean); virtual;
      procedure Set_int_max_str_digits(aValue: integer); virtual;
      procedure Set_interactive(aValue: boolean); virtual;
      procedure Set_isolated(aValue: boolean); virtual;
      procedure Set_lazy_imports(aValue: PyImport_LazyImportsMode); virtual;     //****** 3.15.0
      {$IFDEF MSWINDOWS}
      procedure Set_legacy_windows_stdio(aValue: boolean); virtual;
      {$ENDIF}
      procedure Set_malloc_stats(aValue: boolean); virtual;
      procedure Set_module_search_paths(const aValue: string); virtual;
      procedure Set_module_search_paths_set(aValue: boolean); virtual;
      procedure Set_optimization_level(aValue: TPyOptimizationLevel); virtual;
      procedure Set_orig_argv(const aValue: TStringDynArray); virtual;
      procedure Set_parse_argv(aValue: boolean); virtual;
      procedure Set_parser_debug(aValue: boolean); virtual;
      procedure Set_pathconfig_warnings(aValue: boolean); virtual;
      procedure Set_perf_profiling(aValue: integer); virtual;
      procedure Set_platlibdir(const aValue: string); virtual;
      procedure Set_prefix(const aValue: string); virtual;
      procedure Set_program_name(const aValue: string); virtual;
      procedure Set_pycache_prefix(const aValue: string); virtual;
      procedure Set_pymalloc_hugepages(aValue: boolean); virtual;                //****** 3.15.0
      procedure Set_pythonpath_env(const aValue: string); virtual;
      procedure Set_quiet(aValue: boolean); virtual;
      procedure Set_remote_debug(aValue: boolean); virtual;
      procedure Set_run_command(const aValue: string); virtual;
      procedure Set_run_filename(const aValue: string); virtual;
      procedure Set_run_module(const aValue: string); virtual;
      procedure Set_safe_path(aValue: boolean); virtual;
      procedure Set_show_ref_count(aValue: boolean); virtual;
      procedure Set_site_import(aValue: boolean); virtual;
      procedure Set_skip_source_first_line(aValue: boolean); virtual;
      procedure Set_stdio_encoding(const aValue: string); virtual;
      procedure Set_stdio_errors(const aValue: string); virtual;
      procedure Set_stdlib_dir(const aValue: string); virtual;
      procedure Set_sys_path_0(const aValue: string); virtual;
      procedure Set_thread_inherit_context(aValue: boolean); virtual;
      procedure Set_tracemalloc(aValue: boolean); virtual;
      procedure Set_use_environment(aValue: boolean); virtual;
      procedure Set_use_frozen_modules(aValue: boolean); virtual;
      procedure Set_use_hash_seed(aValue: boolean); virtual;
      procedure Set_user_site_directory(aValue: boolean); virtual;
      procedure Set_verbose(aValue: TPyVerboseMode); virtual;
      procedure Set_warn_default_encoding(aValue: boolean); virtual;
      procedure Set_warnoptions(const aValue: TStringDynArray); virtual;
      procedure Set_write_bytecode(aValue: boolean); virtual;
      procedure Set_xoptions(const aValue: TStringDynArray); virtual;

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

    public
      destructor  Destroy; override;
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
      property Config                    : Pointer              read GetConfig;
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
      property argv                      : TStringDynArray      read Get_argv                         write Set_argv;
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
      property base_exec_prefix          : string               read Get_base_exec_prefix             write Set_base_exec_prefix;
      /// <summary>
      /// <para>Python base executable: sys._base_executable.</para>
      /// <para>Set by the __PYVENV_LAUNCHER__ environment variable.</para>
      /// <para>Set from PyConfig.executable if empty.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
      /// <para>See also PyConfig.executable.</para>
      /// </remarks>
      property base_executable           : string               read Get_base_executable              write Set_base_executable;
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
      property base_prefix               : string               read Get_base_prefix                  write Set_base_prefix;
      /// <summary>
      /// <para>If equals to False and configure_c_stdio is True, disable
      /// buffering on the C streams stdout and stderr.</para>
      /// <para>Set to False by the -u command line option and the
      /// PYTHONUNBUFFERED environment variable.</para>
      /// <para>stdin is always opened in buffered mode.</para>
      /// <para>Default: True.</para>
      /// </summary>
      property buffered_stdio            : boolean              read Get_buffered_stdio               write Set_buffered_stdio;
      /// <summary>
      /// <para>If equals to 1, issue a warning when comparing bytes or
      /// bytearray with str, or comparing bytes with int.</para>
      /// <para>If equal or greater to 2, raise a BytesWarning exception in
      /// these cases.</para>
      /// <para>Incremented by the -b command line option.</para>
      /// <para>Default: 0.</para>
      /// </summary>
      property bytes_warning             : integer              read Get_bytes_warning                write Set_bytes_warning;
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
      property check_hash_pycs_mode      : string               read Get_check_hash_pycs_mode         write Set_check_hash_pycs_mode;
      /// <summary>
      /// <para>If equals to False, disables the inclusion of the end line and
      /// column mappings in code objects. Also disables traceback printing
      /// carets to specific error locations.</para>
      /// <para>Set to False by the PYTHONNODEBUGRANGES environment variable
      /// and by the -X no_debug_ranges command line option.</para>
      /// <para>Default: True.</para>
      /// </summary>
      property code_debug_ranges         : boolean              read Get_code_debug_ranges            write Set_code_debug_ranges;
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
      property configure_c_stdio         : boolean              read Get_configure_c_stdio            write Set_configure_c_stdio;
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
      property context_aware_warnings    : boolean              read Get_context_aware_warnings       write Set_context_aware_warnings;
      {$IFDEF APPLE}
      /// <summary>
      /// <para>If non-zero, stdout and stderr will be redirected to the system
      /// log.</para>
      /// <para>Only available on macOS 10.12 and later, and on iOS.</para>
      /// <para>Default: False (don't use the system log) on macOS; True on iOS
      /// (use the system log).</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      property use_system_logger         : boolean              read Get_use_system_logger            write Set_use_system_logger;
      {$ENDIF}
      /// <summary>
      /// <para>If the value of cpu_count is not -1 then it will override the
      /// return values of os.cpu_count(), os.process_cpu_count(), and
      /// multiprocessing.cpu_count().</para>
      /// <para>Configured by the -X cpu_count=n|default command line flag or
      /// the PYTHON_CPU_COUNT environment variable.</para>
      /// <para>Default: -1.</para>
      /// </summary>
      property cpu_count                 : integer              read Get_cpu_count                    write Set_cpu_count;
      /// <summary>
      /// <para>If True, enable the Python Development Mode.</para>
      /// <para>Set to True by the -X dev option and the PYTHONDEVMODE
      /// environment variable.</para>
      /// <para>Default: True in Python mode, False in isolated mode.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/library/devmode.html#devmode">See the article about Python Development Mode.</see></para>
      /// </remarks>
      property dev_mode                  : boolean              read Get_dev_mode                     write Set_dev_mode;
      /// <summary>
      /// <para>Dump Python references?</para>
      /// <para>If True, dump all objects which are still alive at exit.</para>
      /// <para>Set to True by the PYTHONDUMPREFS environment variable.</para>
      /// <para>Needs a special build of Python with the Py_TRACE_REFS macro
      /// defined: see the configure --with-trace-refs option.</para>
      /// <para>Default: False.</para>
      /// </summary>
      property dump_refs                 : boolean              read Get_dump_refs                    write Set_dump_refs;
      /// <summary>
      /// <para>Filename where to dump Python references. Set by the
      /// PYTHONDUMPREFSFILE environment variable.</para>
      /// </summary>
      property dump_refs_file            : string               read Get_dump_refs_file               write Set_dump_refs_file;
      /// <summary>
      /// <para>The site-specific directory prefix where the platform-dependent
      /// Python files are installed: sys.exec_prefix.</para>
      /// <para>Part of the Python Path Configuration output.</para>
      /// <para>See also PyConfig.base_exec_prefix.</para>
      /// </summary>
      property exec_prefix               : string               read Get_exec_prefix                  write Set_exec_prefix;
      /// <summary>
      /// <para>The absolute path of the executable binary for the Python
      /// interpreter: sys.executable.</para>
      /// <para>Part of the Python Path Configuration output.</para>
      /// <para>See also PyConfig.base_executable.</para>
      /// </summary>
      property executable                : string               read Get_executable                   write Set_executable;
      /// <summary>
      /// <para>Enable faulthandler?</para>
      /// <para>If True, call faulthandler.enable() at startup.</para>
      /// <para>Set to True by -X faulthandler and the PYTHONFAULTHANDLER
      /// environment variable.</para>
      /// <para>Default: True in Python mode, False in isolated mode.</para>
      /// </summary>
      property faulthandler              : integer              read Get_faulthandler                 write Set_faulthandler;
      /// <summary>
      /// <para>Enable PEG parser? Default: 1.</para>
      /// <para>Set to 0 by -X oldparser and PYTHONOLDPARSER.</para>
      /// <para>See also PEP 617.</para>
      /// <para>Deprecated since version 3.9, will be removed in version 3.10.</para>
      /// </summary>
      property use_peg_parser            : boolean              read Get_use_peg_parser               write Set_use_peg_parser;
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
      property filesystem_encoding       : string               read Get_filesystem_encoding          write Set_filesystem_encoding;
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
      property filesystem_errors         : string               read Get_filesystem_errors            write Set_filesystem_errors;
      /// <summary>
      /// <para>Hash seed</para>
      /// </summary>
      property hash_seed                 : uint64               read Get_hash_seed                    write Set_hash_seed;
      /// <summary>
      /// <para>Set the default Python "home" directory, that is, the location
      /// of the standard Python libraries.</para>
      /// <para>Set by the PYTHONHOME environment variable.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
      /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONHOME">See the article about PYTHONHOME.</see></para>
      /// </remarks>
      property home                      : string               read Get_home                         write Set_home;
      /// <summary>
      /// <para>If 1, profile import time. If 2, include additional output that
      /// indicates when an imported module has already been loaded.</para>
      /// <para>Set by the -X importtime option and the PYTHONPROFILEIMPORTTIME
      /// environment variable.</para>
      /// <para>Default: 0.</para>
      /// <para>Changed in version 3.14: Added support for import_time = 2</para>
      /// </summary>
      property import_time               : integer              read Get_import_time                  write Set_import_time;
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
      property inspect                   : boolean              read Get_inspect                      write Set_inspect;
      /// <summary>
      /// <para>Install Python signal handlers?</para>
      /// <para>Default: True in Python mode, False in isolated mode.</para>
      /// </summary>
      property install_signal_handlers   : boolean              read Get_install_signal_handlers      write Set_install_signal_handlers;
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
      property int_max_str_digits        : integer              read Get_int_max_str_digits           write Set_int_max_str_digits;
      /// <summary>
      /// <para>If True, enable the interactive mode (REPL).</para>
      /// <para>Enabled by the -i command line option.</para>
      /// <para>Default: False.</para>
      /// </summary>
      property interactive               : boolean              read Get_interactive                  write Set_interactive;
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
      property isolated                  : boolean              read Get_isolated                     write Set_isolated;
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
      property legacy_windows_stdio      : boolean              read Get_legacy_windows_stdio         write Set_legacy_windows_stdio;
      {$ENDIF}
      /// <summary>
      /// <para>If True, dump statistics on Python pymalloc memory allocator at
      /// exit.</para>
      /// <para>Set to True by the PYTHONMALLOCSTATS environment variable.</para>
      /// <para>The option is ignored if Python is configured using the
      /// --without-pymalloc option.</para>
      /// <para>Default: False.</para>
      /// </summary>
      property malloc_stats              : boolean              read Get_malloc_stats                 write Set_malloc_stats;
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
      property module_search_paths       : string               read Get_module_search_paths          write Set_module_search_paths;
      /// <summary>
      /// <para>If module_search_paths_set is False, Py_InitializeFromConfig()
      /// will replace module_search_paths and sets module_search_paths_set to
      /// True.</para>
      /// <para>Default: False.</para>
      /// </summary>
      property module_search_paths_set   : boolean              read Get_module_search_paths_set      write Set_module_search_paths_set;
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
      property optimization_level        : TPyOptimizationLevel read Get_optimization_level           write Set_optimization_level;
      /// <summary>
      /// <para>The list of the original command line arguments passed to the
      /// Python executable: sys.orig_argv.</para>
      /// <para>If orig_argv list is empty and argv is not a list only
      /// containing an empty string, TPyConfig.Read() copies argv into orig_argv
      /// before modifying argv (if parse_argv is non-zero).</para>
      /// <para>See also the argv member and the TPy.GetArgcArgv()
      /// function.</para>
      /// <para>Default: empty list.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      property orig_argv                 : TStringDynArray      read Get_orig_argv                    write Set_orig_argv;
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
      property parse_argv                : boolean              read Get_parse_argv                   write Set_parse_argv;
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
      property parser_debug              : boolean              read Get_parser_debug                 write Set_parser_debug;
      /// <summary>
      /// <para>If True, calculation of path configuration is allowed to log
      /// warnings into stderr. If False, suppress these warnings.</para>
      /// <para>Default: True in Python mode, False in isolated mode.</para>
      /// <para>Changed in version 3.11: Now also applies on Windows.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
      /// </remarks>
      property pathconfig_warnings       : boolean              read Get_pathconfig_warnings          write Set_pathconfig_warnings;
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
      property perf_profiling            : integer              read Get_perf_profiling               write Set_perf_profiling;
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
      property platlibdir                : string               read Get_platlibdir                   write Set_platlibdir;
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
      property prefix                    : string               read Get_prefix                       write Set_prefix;
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
      property program_name              : string               read Get_program_name                 write Set_program_name;
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
      property pycache_prefix            : string               read Get_pycache_prefix               write Set_pycache_prefix;
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
      property pymalloc_hugepages        : boolean              read Get_pymalloc_hugepages           write Set_pymalloc_hugepages;
      /// <summary>
      /// <para>Set by the PYTHONPATH environment variable.</para>
      /// <para>Default: Empty.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
      /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH">See the article about PYTHONPATH.</see></para>
      /// </remarks>
      property pythonpath_env            : string               read Get_pythonpath_env               write Set_pythonpath_env;
      /// <summary>
      /// <para>Quiet mode. If True, don't display the copyright and version at
      /// Python startup in interactive mode.</para>
      /// <para>Enabled by the -q command line option.</para>
      /// <para>Default: False.</para>
      /// </summary>
      property quiet                     : boolean              read Get_quiet                        write Set_quiet;
      /// <summary>
      /// <para>Safe external debugger interface for CPython.</para>
      /// <para>Default: True.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/using/configure.html#cmdoption-without-remote-debug">See the article about --without-remote-debug</see></para>
      /// <para><see href="https://peps.python.org/pep-0768/">See the PEP 768.</see></para>
      /// </remarks>
      property remote_debug              : boolean              read Get_remote_debug                 write Set_remote_debug;
      /// <summary>
      /// <para>Value of the -c command line option.</para>
      /// <para>Used by TPy.RunMain().</para>
      /// <para>Default: Empty.</para>
      /// </summary>
      property run_command               : string               read Get_run_command                  write Set_run_command;
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
      property run_filename              : string               read Get_run_filename                 write Set_run_filename;
      /// <summary>
      /// <para>Value of the -m command line option.</para>
      /// <para>Used by TPy.RunMain().</para>
      /// <para>Default: Empty.</para>
      /// </summary>
      property run_module                : string               read Get_run_module                   write Set_run_module;
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
      property safe_path                 : boolean              read Get_safe_path                    write Set_safe_path;
      /// <summary>
      /// <para>Show total reference count at exit (excluding immortal
      /// objects)?</para>
      /// <para>Set to True by -X showrefcount command line option.</para>
      /// <para>Needs a debug build of Python (the Py_REF_DEBUG macro must be
      /// defined).</para>
      /// <para>Default: False.</para>
      /// </summary>
      property show_ref_count            : boolean              read Get_show_ref_count               write Set_show_ref_count;
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
      property site_import               : boolean              read Get_site_import                  write Set_site_import;
      /// <summary>
      /// <para>If non-zero, skip the first line of the PyConfig.run_filename
      /// source.</para>
      /// <para>It allows the usage of non-Unix forms of #!cmd. This is intended
      /// for a DOS specific hack only.</para>
      /// <para>Set to True by the -x command line option.</para>
      /// <para>Default: False.</para>
      /// </summary>
      property skip_source_first_line    : boolean              read Get_skip_source_first_line       write Set_skip_source_first_line;
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
      property stdio_encoding            : string               read Get_stdio_encoding               write Set_stdio_encoding;
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
      property stdio_errors              : string               read Get_stdio_errors                 write Set_stdio_errors;
      /// <summary>
      /// <para>Directory of the Python standard library.</para>
      /// <para>Default: Empty.</para>
      /// <para>Added in version 3.11.</para>
      /// </summary>
      property stdlib_dir                : string               read Get_stdlib_dir                   write Set_stdlib_dir;
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
      property sys_path_0                : string               read Get_sys_path_0                   write Set_sys_path_0;
      /// <summary>
      /// <para>Whether the new thread should inherit the current "execution
      /// context" from the thread that created it.</para>
      /// <para>If thread_inherit_context is true, the new thread starts with
      /// that same context (so things like trace IDs, user IDs, request-scoped
      /// metadata, etc. propagate).</para>
      /// <para>If it's false, the new thread runs with a fresh/default context
      /// (so context doesn't automatically carry over).</para>
      /// </summary>
      property thread_inherit_context    : boolean              read Get_thread_inherit_context       write Set_thread_inherit_context;
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
      property tracemalloc               : boolean              read Get_tracemalloc                  write Set_tracemalloc;
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
      property use_environment           : boolean              read Get_use_environment              write Set_use_environment;
      /// <summary>
      /// <para>If True, use frozen modules.</para>
      /// <para>Set by the PYTHON_FROZEN_MODULES environment variable.</para>
      /// <para>Default: True in a release build, or False in a debug
      /// build.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHON_FROZEN_MODULES">See the article about PYTHON_FROZEN_MODULES.</see></para>
      /// </remarks>
      property use_frozen_modules        : boolean              read Get_use_frozen_modules           write Set_use_frozen_modules;
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
      property use_hash_seed             : boolean              read Get_use_hash_seed                write Set_use_hash_seed;
      /// <summary>
      /// <para>If True, add the user site directory to sys.path.</para>
      /// <para>Set to False by the -s and -I command line options.</para>
      /// <para>Set to False by the PYTHONNOUSERSITE environment variable.</para>
      /// <para>Default: True in Python mode, False in isolated mode.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONNOUSERSITE">See the article about PYTHONNOUSERSITE.</see></para>
      /// </remarks>
      property user_site_directory       : boolean              read Get_user_site_directory          write Set_user_site_directory;
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
      property verbose                   : TPyVerboseMode       read Get_verbose                      write Set_verbose;
      /// <summary>
      /// <para>If non-zero, emit a EncodingWarning warning when
      /// io.TextIOWrapper uses its default encoding.</para>
      /// <para>Default: False.</para>
      /// <para>Added in version 3.10.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/library/io.html#io-encoding-warning">See Opt-in EncodingWarning for details.</see></para>
      /// </remarks>
      property warn_default_encoding     : boolean              read Get_warn_default_encoding        write Set_warn_default_encoding;
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
      property warnoptions               : TStringDynArray      read Get_warnoptions                  write Set_warnoptions;
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
      property write_bytecode            : boolean              read Get_write_bytecode               write Set_write_bytecode;
      /// <summary>
      /// <para>Values of the -X command line options: sys._xoptions.</para>
      /// <para>Default: empty list.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/library/sys.html#sys._xoptions">See the article about sys._xoptions.</see></para>
      /// </remarks>
      property xoptions                  : TStringDynArray      read Get_xoptions                     write Set_xoptions;
  end;

  TPyConfig315 = class(TPyConfigBase)
    protected
      FConfig : PyConfig315;
      function GetConfig: Pointer; override;
      function Get_argv: TStringDynArray; override;
      function Get_base_exec_prefix: string; override;
      function Get_base_executable: string; override;
      function Get_base_prefix: string; override;
      function Get_buffered_stdio: boolean; override;
      function Get_bytes_warning: integer; override;
      function Get_check_hash_pycs_mode: string; override;
      function Get_code_debug_ranges: boolean; override;
      function Get_configure_c_stdio: boolean; override;
      function Get_context_aware_warnings: boolean; override;
      {$IFDEF APPLE}
      function Get_use_system_logger: boolean; override;
      {$ENDIF}
      function Get_cpu_count: integer; override;
      function Get_dev_mode: boolean; override;
      function Get_dump_refs: boolean; override;
      function Get_dump_refs_file: string; override;
      function Get_exec_prefix: string; override;
      function Get_executable: string; override;
      function Get_faulthandler: integer; override;
      function Get_filesystem_encoding: string; override;
      function Get_filesystem_errors: string; override;
      function Get_hash_seed: uint64; override;
      function Get_home: string; override;
      function Get_import_time: integer; override;
      function Get_inspect: boolean; override;
      function Get_install_signal_handlers: boolean; override;
      function Get_int_max_str_digits: integer; override;
      function Get_interactive: boolean; override;
      function Get_isolated: boolean; override;
      function Get_lazy_imports: PyImport_LazyImportsMode; override;             //****** 3.15.0
      {$IFDEF MSWINDOWS}
      function Get_legacy_windows_stdio: boolean; override;
      {$ENDIF}
      function Get_malloc_stats: boolean; override;
      function Get_module_search_paths: string; override;
      function Get_module_search_paths_set: boolean; override;
      function Get_optimization_level: TPyOptimizationLevel; override;
      function Get_orig_argv: TStringDynArray; override;
      function Get_parse_argv: boolean; override;
      function Get_parser_debug: boolean; override;
      function Get_pathconfig_warnings: boolean; override;
      function Get_perf_profiling: integer; override;
      function Get_platlibdir: string; override;
      function Get_prefix: string; override;
      function Get_program_name: string; override;
      function Get_pycache_prefix: string; override;
      function Get_pymalloc_hugepages: boolean; override;                        //****** 3.15.0
      function Get_pythonpath_env: string; override;
      function Get_quiet: boolean; override;
      function Get_remote_debug: boolean; override;
      function Get_run_command: string; override;
      function Get_run_filename: string; override;
      function Get_run_module: string; override;
      function Get_safe_path: boolean; override;
      function Get_show_ref_count: boolean; override;
      function Get_site_import: boolean; override;
      function Get_skip_source_first_line: boolean; override;
      function Get_stdio_encoding: string; override;
      function Get_stdio_errors: string; override;
      function Get_stdlib_dir: string; override;
      function Get_sys_path_0: string; override;
      function Get_thread_inherit_context: boolean; override;
      function Get_tracemalloc: boolean; override;
      function Get_use_environment: boolean; override;
      function Get_use_frozen_modules: boolean; override;
      function Get_use_hash_seed: boolean; override;
      function Get_user_site_directory: boolean; override;
      function Get_verbose: TPyVerboseMode; override;
      function Get_warn_default_encoding: boolean; override;
      function Get_warnoptions: TStringDynArray; override;
      function Get_write_bytecode: boolean; override;
      function Get_xoptions: TStringDynArray; override;

      procedure Set_argv(const aValue: TStringDynArray); override;
      procedure Set_base_exec_prefix(const aValue: string); override;
      procedure Set_base_executable(const aValue: string); override;
      procedure Set_base_prefix(const aValue: string); override;
      procedure Set_buffered_stdio(aValue: boolean); override;
      procedure Set_bytes_warning(aValue: integer); override;
      procedure Set_check_hash_pycs_mode(const aValue: string); override;
      procedure Set_code_debug_ranges(aValue: boolean); override;
      procedure Set_configure_c_stdio(aValue: boolean); override;
      procedure Set_context_aware_warnings(aValue: boolean); override;
      {$IFDEF APPLE}
      procedure Set_use_system_logger(aValue: boolean); override;
      {$ENDIF}
      procedure Set_cpu_count(aValue: integer); override;
      procedure Set_dev_mode(aValue: boolean); override;
      procedure Set_dump_refs(aValue: boolean); override;
      procedure Set_dump_refs_file(const aValue: string); override;
      procedure Set_exec_prefix(const aValue: string); override;
      procedure Set_executable(const aValue: string); override;
      procedure Set_faulthandler(aValue: integer); override;
      procedure Set_filesystem_encoding(const aValue: string); override;
      procedure Set_filesystem_errors(const aValue: string); override;
      procedure Set_hash_seed(aValue: uint64); override;
      procedure Set_home(const aValue: string); override;
      procedure Set_import_time(aValue: integer); override;
      procedure Set_inspect(aValue: boolean); override;
      procedure Set_install_signal_handlers(aValue: boolean); override;
      procedure Set_int_max_str_digits(aValue: integer); override;
      procedure Set_interactive(aValue: boolean); override;
      procedure Set_isolated(aValue: boolean); override;
      procedure Set_lazy_imports(aValue: PyImport_LazyImportsMode); override;    //****** 3.15.0
      {$IFDEF MSWINDOWS}
      procedure Set_legacy_windows_stdio(aValue: boolean); override;
      {$ENDIF}
      procedure Set_malloc_stats(aValue: boolean); override;
      procedure Set_module_search_paths(const aValue: string); override;
      procedure Set_module_search_paths_set(aValue: boolean); override;
      procedure Set_optimization_level(aValue: TPyOptimizationLevel); override;
      procedure Set_orig_argv(const aValue: TStringDynArray); override;
      procedure Set_parse_argv(aValue: boolean); override;
      procedure Set_parser_debug(aValue: boolean); override;
      procedure Set_pathconfig_warnings(aValue: boolean); override;
      procedure Set_perf_profiling(aValue: integer); override;
      procedure Set_platlibdir(const aValue: string); override;
      procedure Set_prefix(const aValue: string); override;
      procedure Set_program_name(const aValue: string); override;
      procedure Set_pycache_prefix(const aValue: string); override;
      procedure Set_pymalloc_hugepages(aValue: boolean); override;               //****** 3.15.0
      procedure Set_pythonpath_env(const aValue: string); override;
      procedure Set_quiet(aValue: boolean); override;
      procedure Set_remote_debug(aValue: boolean); override;
      procedure Set_run_command(const aValue: string); override;
      procedure Set_run_filename(const aValue: string); override;
      procedure Set_run_module(const aValue: string); override;
      procedure Set_safe_path(aValue: boolean); override;
      procedure Set_show_ref_count(aValue: boolean); override;
      procedure Set_site_import(aValue: boolean); override;
      procedure Set_skip_source_first_line(aValue: boolean); override;
      procedure Set_stdio_encoding(const aValue: string); override;
      procedure Set_stdio_errors(const aValue: string); override;
      procedure Set_stdlib_dir(const aValue: string); override;
      procedure Set_sys_path_0(const aValue: string); override;
      procedure Set_thread_inherit_context(aValue: boolean); override;
      procedure Set_tracemalloc(aValue: boolean); override;
      procedure Set_use_environment(aValue: boolean); override;
      procedure Set_use_frozen_modules(aValue: boolean); override;
      procedure Set_use_hash_seed(aValue: boolean); override;
      procedure Set_user_site_directory(aValue: boolean); override;
      procedure Set_verbose(aValue: TPyVerboseMode); override;
      procedure Set_warn_default_encoding(aValue: boolean); override;
      procedure Set_warnoptions(const aValue: TStringDynArray); override;
      procedure Set_write_bytecode(aValue: boolean); override;
      procedure Set_xoptions(const aValue: TStringDynArray); override;
  end;

  TPyConfig314 = class(TPyConfigBase)
    protected
      FConfig : PyConfig314;
      function GetConfig: Pointer; override;
      function Get_argv: TStringDynArray; override;
      function Get_base_exec_prefix: string; override;
      function Get_base_executable: string; override;
      function Get_base_prefix: string; override;
      function Get_buffered_stdio: boolean; override;
      function Get_bytes_warning: integer; override;
      function Get_check_hash_pycs_mode: string; override;
      function Get_code_debug_ranges: boolean; override;
      function Get_configure_c_stdio: boolean; override;
      function Get_context_aware_warnings: boolean; override;
      {$IFDEF APPLE}
      function Get_use_system_logger: boolean; override;
      {$ENDIF}
      function Get_cpu_count: integer; override;
      function Get_dev_mode: boolean; override;
      function Get_dump_refs: boolean; override;
      function Get_dump_refs_file: string; override;
      function Get_exec_prefix: string; override;
      function Get_executable: string; override;
      function Get_faulthandler: integer; override;
      function Get_filesystem_encoding: string; override;
      function Get_filesystem_errors: string; override;
      function Get_hash_seed: uint64; override;
      function Get_home: string; override;
      function Get_import_time: integer; override;
      function Get_inspect: boolean; override;
      function Get_install_signal_handlers: boolean; override;
      function Get_int_max_str_digits: integer; override;
      function Get_interactive: boolean; override;
      function Get_isolated: boolean; override;
      {$IFDEF MSWINDOWS}
      function Get_legacy_windows_stdio: boolean; override;
      {$ENDIF}
      function Get_malloc_stats: boolean; override;
      function Get_module_search_paths: string; override;
      function Get_module_search_paths_set: boolean; override;
      function Get_optimization_level: TPyOptimizationLevel; override;
      function Get_orig_argv: TStringDynArray; override;
      function Get_parse_argv: boolean; override;
      function Get_parser_debug: boolean; override;
      function Get_pathconfig_warnings: boolean; override;
      function Get_perf_profiling: integer; override;
      function Get_platlibdir: string; override;
      function Get_prefix: string; override;
      function Get_program_name: string; override;
      function Get_pycache_prefix: string; override;
      function Get_pythonpath_env: string; override;
      function Get_quiet: boolean; override;
      function Get_remote_debug: boolean; override;
      function Get_run_command: string; override;
      function Get_run_filename: string; override;
      function Get_run_module: string; override;
      function Get_safe_path: boolean; override;
      function Get_show_ref_count: boolean; override;
      function Get_site_import: boolean; override;
      function Get_skip_source_first_line: boolean; override;
      function Get_stdio_encoding: string; override;
      function Get_stdio_errors: string; override;
      function Get_stdlib_dir: string; override;
      function Get_sys_path_0: string; override;
      function Get_thread_inherit_context: boolean; override;
      function Get_tracemalloc: boolean; override;
      function Get_use_environment: boolean; override;
      function Get_use_frozen_modules: boolean; override;
      function Get_use_hash_seed: boolean; override;
      function Get_user_site_directory: boolean; override;
      function Get_verbose: TPyVerboseMode; override;
      function Get_warn_default_encoding: boolean; override;
      function Get_warnoptions: TStringDynArray; override;
      function Get_write_bytecode: boolean; override;
      function Get_xoptions: TStringDynArray; override;

      procedure Set_argv(const aValue: TStringDynArray); override;
      procedure Set_base_exec_prefix(const aValue: string); override;
      procedure Set_base_executable(const aValue: string); override;
      procedure Set_base_prefix(const aValue: string); override;
      procedure Set_buffered_stdio(aValue: boolean); override;
      procedure Set_bytes_warning(aValue: integer); override;
      procedure Set_check_hash_pycs_mode(const aValue: string); override;
      procedure Set_code_debug_ranges(aValue: boolean); override;
      procedure Set_configure_c_stdio(aValue: boolean); override;
      procedure Set_context_aware_warnings(aValue: boolean); override;
      {$IFDEF APPLE}
      procedure Set_use_system_logger(aValue: boolean); override;
      {$ENDIF}
      procedure Set_cpu_count(aValue: integer); override;
      procedure Set_dev_mode(aValue: boolean); override;
      procedure Set_dump_refs(aValue: boolean); override;
      procedure Set_dump_refs_file(const aValue: string); override;
      procedure Set_exec_prefix(const aValue: string); override;
      procedure Set_executable(const aValue: string); override;
      procedure Set_faulthandler(aValue: integer); override;
      procedure Set_filesystem_encoding(const aValue: string); override;
      procedure Set_filesystem_errors(const aValue: string); override;
      procedure Set_hash_seed(aValue: uint64); override;
      procedure Set_home(const aValue: string); override;
      procedure Set_import_time(aValue: integer); override;
      procedure Set_inspect(aValue: boolean); override;
      procedure Set_install_signal_handlers(aValue: boolean); override;
      procedure Set_int_max_str_digits(aValue: integer); override;
      procedure Set_interactive(aValue: boolean); override;
      procedure Set_isolated(aValue: boolean); override;
      {$IFDEF MSWINDOWS}
      procedure Set_legacy_windows_stdio(aValue: boolean); override;
      {$ENDIF}
      procedure Set_malloc_stats(aValue: boolean); override;
      procedure Set_module_search_paths(const aValue: string); override;
      procedure Set_module_search_paths_set(aValue: boolean); override;
      procedure Set_optimization_level(aValue: TPyOptimizationLevel); override;
      procedure Set_orig_argv(const aValue: TStringDynArray); override;
      procedure Set_parse_argv(aValue: boolean); override;
      procedure Set_parser_debug(aValue: boolean); override;
      procedure Set_pathconfig_warnings(aValue: boolean); override;
      procedure Set_perf_profiling(aValue: integer); override;
      procedure Set_platlibdir(const aValue: string); override;
      procedure Set_prefix(const aValue: string); override;
      procedure Set_program_name(const aValue: string); override;
      procedure Set_pycache_prefix(const aValue: string); override;
      procedure Set_pythonpath_env(const aValue: string); override;
      procedure Set_quiet(aValue: boolean); override;
      procedure Set_remote_debug(aValue: boolean); override;
      procedure Set_run_command(const aValue: string); override;
      procedure Set_run_filename(const aValue: string); override;
      procedure Set_run_module(const aValue: string); override;
      procedure Set_safe_path(aValue: boolean); override;
      procedure Set_show_ref_count(aValue: boolean); override;
      procedure Set_site_import(aValue: boolean); override;
      procedure Set_skip_source_first_line(aValue: boolean); override;
      procedure Set_stdio_encoding(const aValue: string); override;
      procedure Set_stdio_errors(const aValue: string); override;
      procedure Set_stdlib_dir(const aValue: string); override;
      procedure Set_sys_path_0(const aValue: string); override;
      procedure Set_thread_inherit_context(aValue: boolean); override;
      procedure Set_tracemalloc(aValue: boolean); override;
      procedure Set_use_environment(aValue: boolean); override;
      procedure Set_use_frozen_modules(aValue: boolean); override;
      procedure Set_use_hash_seed(aValue: boolean); override;
      procedure Set_user_site_directory(aValue: boolean); override;
      procedure Set_verbose(aValue: TPyVerboseMode); override;
      procedure Set_warn_default_encoding(aValue: boolean); override;
      procedure Set_warnoptions(const aValue: TStringDynArray); override;
      procedure Set_write_bytecode(aValue: boolean); override;
      procedure Set_xoptions(const aValue: TStringDynArray); override;
  end;

  TPyConfig313 = class(TPyConfigBase)
    protected
      FConfig : PyConfig313;
      function GetConfig: Pointer; override;
      function Get_argv: TStringDynArray; override;
      function Get_base_exec_prefix: string; override;
      function Get_base_executable: string; override;
      function Get_base_prefix: string; override;
      function Get_buffered_stdio: boolean; override;
      function Get_bytes_warning: integer; override;
      function Get_check_hash_pycs_mode: string; override;
      function Get_code_debug_ranges: boolean; override;
      function Get_configure_c_stdio: boolean; override;
      function Get_cpu_count: integer; override;
      function Get_dev_mode: boolean; override;
      function Get_dump_refs: boolean; override;
      function Get_dump_refs_file: string; override;
      function Get_exec_prefix: string; override;
      function Get_executable: string; override;
      function Get_faulthandler: integer; override;
      function Get_filesystem_encoding: string; override;
      function Get_filesystem_errors: string; override;
      function Get_hash_seed: uint64; override;
      function Get_home: string; override;
      function Get_import_time: integer; override;
      function Get_inspect: boolean; override;
      function Get_install_signal_handlers: boolean; override;
      function Get_int_max_str_digits: integer; override;
      function Get_interactive: boolean; override;
      function Get_isolated: boolean; override;
      {$IFDEF MSWINDOWS}
      function Get_legacy_windows_stdio: boolean; override;
      {$ENDIF}
      function Get_malloc_stats: boolean; override;
      function Get_module_search_paths: string; override;
      function Get_module_search_paths_set: boolean; override;
      function Get_optimization_level: TPyOptimizationLevel; override;
      function Get_orig_argv: TStringDynArray; override;
      function Get_parse_argv: boolean; override;
      function Get_parser_debug: boolean; override;
      function Get_pathconfig_warnings: boolean; override;
      function Get_perf_profiling: integer; override;
      function Get_platlibdir: string; override;
      function Get_prefix: string; override;
      function Get_program_name: string; override;
      function Get_pycache_prefix: string; override;
      function Get_pythonpath_env: string; override;
      function Get_quiet: boolean; override;
      function Get_run_command: string; override;
      function Get_run_filename: string; override;
      function Get_run_module: string; override;
      function Get_safe_path: boolean; override;
      function Get_show_ref_count: boolean; override;
      function Get_site_import: boolean; override;
      function Get_skip_source_first_line: boolean; override;
      function Get_stdio_encoding: string; override;
      function Get_stdio_errors: string; override;
      function Get_stdlib_dir: string; override;
      function Get_sys_path_0: string; override;
      function Get_tracemalloc: boolean; override;
      function Get_use_environment: boolean; override;
      function Get_use_frozen_modules: boolean; override;
      function Get_use_hash_seed: boolean; override;
      function Get_user_site_directory: boolean; override;
      function Get_verbose: TPyVerboseMode; override;
      function Get_warn_default_encoding: boolean; override;
      function Get_warnoptions: TStringDynArray; override;
      function Get_write_bytecode: boolean; override;
      function Get_xoptions: TStringDynArray; override;

      procedure Set_argv(const aValue: TStringDynArray); override;
      procedure Set_base_exec_prefix(const aValue: string); override;
      procedure Set_base_executable(const aValue: string); override;
      procedure Set_base_prefix(const aValue: string); override;
      procedure Set_buffered_stdio(aValue: boolean); override;
      procedure Set_bytes_warning(aValue: integer); override;
      procedure Set_check_hash_pycs_mode(const aValue: string); override;
      procedure Set_code_debug_ranges(aValue: boolean); override;
      procedure Set_configure_c_stdio(aValue: boolean); override;
      procedure Set_cpu_count(aValue: integer); override;
      procedure Set_dev_mode(aValue: boolean); override;
      procedure Set_dump_refs(aValue: boolean); override;
      procedure Set_dump_refs_file(const aValue: string); override;
      procedure Set_exec_prefix(const aValue: string); override;
      procedure Set_executable(const aValue: string); override;
      procedure Set_faulthandler(aValue: integer); override;
      procedure Set_filesystem_encoding(const aValue: string); override;
      procedure Set_filesystem_errors(const aValue: string); override;
      procedure Set_hash_seed(aValue: uint64); override;
      procedure Set_home(const aValue: string); override;
      procedure Set_import_time(aValue: integer); override;
      procedure Set_inspect(aValue: boolean); override;
      procedure Set_install_signal_handlers(aValue: boolean); override;
      procedure Set_int_max_str_digits(aValue: integer); override;
      procedure Set_interactive(aValue: boolean); override;
      procedure Set_isolated(aValue: boolean); override;
      {$IFDEF MSWINDOWS}
      procedure Set_legacy_windows_stdio(aValue: boolean); override;
      {$ENDIF}
      procedure Set_malloc_stats(aValue: boolean); override;
      procedure Set_module_search_paths(const aValue: string); override;
      procedure Set_module_search_paths_set(aValue: boolean); override;
      procedure Set_optimization_level(aValue: TPyOptimizationLevel); override;
      procedure Set_orig_argv(const aValue: TStringDynArray); override;
      procedure Set_parse_argv(aValue: boolean); override;
      procedure Set_parser_debug(aValue: boolean); override;
      procedure Set_pathconfig_warnings(aValue: boolean); override;
      procedure Set_perf_profiling(aValue: integer); override;
      procedure Set_platlibdir(const aValue: string); override;
      procedure Set_prefix(const aValue: string); override;
      procedure Set_program_name(const aValue: string); override;
      procedure Set_pycache_prefix(const aValue: string); override;
      procedure Set_pythonpath_env(const aValue: string); override;
      procedure Set_quiet(aValue: boolean); override;
      procedure Set_run_command(const aValue: string); override;
      procedure Set_run_filename(const aValue: string); override;
      procedure Set_run_module(const aValue: string); override;
      procedure Set_safe_path(aValue: boolean); override;
      procedure Set_show_ref_count(aValue: boolean); override;
      procedure Set_site_import(aValue: boolean); override;
      procedure Set_skip_source_first_line(aValue: boolean); override;
      procedure Set_stdio_encoding(const aValue: string); override;
      procedure Set_stdio_errors(const aValue: string); override;
      procedure Set_stdlib_dir(const aValue: string); override;
      procedure Set_sys_path_0(const aValue: string); override;
      procedure Set_tracemalloc(aValue: boolean); override;
      procedure Set_use_environment(aValue: boolean); override;
      procedure Set_use_frozen_modules(aValue: boolean); override;
      procedure Set_use_hash_seed(aValue: boolean); override;
      procedure Set_user_site_directory(aValue: boolean); override;
      procedure Set_verbose(aValue: TPyVerboseMode); override;
      procedure Set_warn_default_encoding(aValue: boolean); override;
      procedure Set_warnoptions(const aValue: TStringDynArray); override;
      procedure Set_write_bytecode(aValue: boolean); override;
      procedure Set_xoptions(const aValue: TStringDynArray); override;
  end;

  TPyConfig312 = class(TPyConfigBase)
    protected
      FConfig : PyConfig312;
      function GetConfig: Pointer; override;
      function Get_argv: TStringDynArray; override;
      function Get_base_exec_prefix: string; override;
      function Get_base_executable: string; override;
      function Get_base_prefix: string; override;
      function Get_buffered_stdio: boolean; override;
      function Get_bytes_warning: integer; override;
      function Get_check_hash_pycs_mode: string; override;
      function Get_code_debug_ranges: boolean; override;
      function Get_configure_c_stdio: boolean; override;
      function Get_dev_mode: boolean; override;
      function Get_dump_refs: boolean; override;
      function Get_dump_refs_file: string; override;
      function Get_exec_prefix: string; override;
      function Get_executable: string; override;
      function Get_faulthandler: integer; override;
      function Get_filesystem_encoding: string; override;
      function Get_filesystem_errors: string; override;
      function Get_hash_seed: uint64; override;
      function Get_home: string; override;
      function Get_import_time: integer; override;
      function Get_inspect: boolean; override;
      function Get_install_signal_handlers: boolean; override;
      function Get_int_max_str_digits: integer; override;
      function Get_interactive: boolean; override;
      function Get_isolated: boolean; override;
      {$IFDEF MSWINDOWS}
      function Get_legacy_windows_stdio: boolean; override;
      {$ENDIF}
      function Get_malloc_stats: boolean; override;
      function Get_module_search_paths: string; override;
      function Get_module_search_paths_set: boolean; override;
      function Get_optimization_level: TPyOptimizationLevel; override;
      function Get_orig_argv: TStringDynArray; override;
      function Get_parse_argv: boolean; override;
      function Get_parser_debug: boolean; override;
      function Get_pathconfig_warnings: boolean; override;
      function Get_perf_profiling: integer; override;
      function Get_platlibdir: string; override;
      function Get_prefix: string; override;
      function Get_program_name: string; override;
      function Get_pycache_prefix: string; override;
      function Get_pythonpath_env: string; override;
      function Get_quiet: boolean; override;
      function Get_run_command: string; override;
      function Get_run_filename: string; override;
      function Get_run_module: string; override;
      function Get_safe_path: boolean; override;
      function Get_show_ref_count: boolean; override;
      function Get_site_import: boolean; override;
      function Get_skip_source_first_line: boolean; override;
      function Get_stdio_encoding: string; override;
      function Get_stdio_errors: string; override;
      function Get_stdlib_dir: string; override;
      function Get_tracemalloc: boolean; override;
      function Get_use_environment: boolean; override;
      function Get_use_frozen_modules: boolean; override;
      function Get_use_hash_seed: boolean; override;
      function Get_user_site_directory: boolean; override;
      function Get_verbose: TPyVerboseMode; override;
      function Get_warn_default_encoding: boolean; override;
      function Get_warnoptions: TStringDynArray; override;
      function Get_write_bytecode: boolean; override;
      function Get_xoptions: TStringDynArray; override;

      procedure Set_argv(const aValue: TStringDynArray); override;
      procedure Set_base_exec_prefix(const aValue: string); override;
      procedure Set_base_executable(const aValue: string); override;
      procedure Set_base_prefix(const aValue: string); override;
      procedure Set_buffered_stdio(aValue: boolean); override;
      procedure Set_bytes_warning(aValue: integer); override;
      procedure Set_check_hash_pycs_mode(const aValue: string); override;
      procedure Set_code_debug_ranges(aValue: boolean); override;
      procedure Set_configure_c_stdio(aValue: boolean); override;
      procedure Set_dev_mode(aValue: boolean); override;
      procedure Set_dump_refs(aValue: boolean); override;
      procedure Set_dump_refs_file(const aValue: string); override;
      procedure Set_exec_prefix(const aValue: string); override;
      procedure Set_executable(const aValue: string); override;
      procedure Set_faulthandler(aValue: integer); override;
      procedure Set_filesystem_encoding(const aValue: string); override;
      procedure Set_filesystem_errors(const aValue: string); override;
      procedure Set_hash_seed(aValue: uint64); override;
      procedure Set_home(const aValue: string); override;
      procedure Set_import_time(aValue: integer); override;
      procedure Set_inspect(aValue: boolean); override;
      procedure Set_install_signal_handlers(aValue: boolean); override;
      procedure Set_int_max_str_digits(aValue: integer); override;
      procedure Set_interactive(aValue: boolean); override;
      procedure Set_isolated(aValue: boolean); override;
      {$IFDEF MSWINDOWS}
      procedure Set_legacy_windows_stdio(aValue: boolean); override;
      {$ENDIF}
      procedure Set_malloc_stats(aValue: boolean); override;
      procedure Set_module_search_paths(const aValue: string); override;
      procedure Set_module_search_paths_set(aValue: boolean); override;
      procedure Set_optimization_level(aValue: TPyOptimizationLevel); override;
      procedure Set_orig_argv(const aValue: TStringDynArray); override;
      procedure Set_parse_argv(aValue: boolean); override;
      procedure Set_parser_debug(aValue: boolean); override;
      procedure Set_pathconfig_warnings(aValue: boolean); override;
      procedure Set_perf_profiling(aValue: integer); override;
      procedure Set_platlibdir(const aValue: string); override;
      procedure Set_prefix(const aValue: string); override;
      procedure Set_program_name(const aValue: string); override;
      procedure Set_pycache_prefix(const aValue: string); override;
      procedure Set_pythonpath_env(const aValue: string); override;
      procedure Set_quiet(aValue: boolean); override;
      procedure Set_run_command(const aValue: string); override;
      procedure Set_run_filename(const aValue: string); override;
      procedure Set_run_module(const aValue: string); override;
      procedure Set_safe_path(aValue: boolean); override;
      procedure Set_show_ref_count(aValue: boolean); override;
      procedure Set_site_import(aValue: boolean); override;
      procedure Set_skip_source_first_line(aValue: boolean); override;
      procedure Set_stdio_encoding(const aValue: string); override;
      procedure Set_stdio_errors(const aValue: string); override;
      procedure Set_stdlib_dir(const aValue: string); override;
      procedure Set_tracemalloc(aValue: boolean); override;
      procedure Set_use_environment(aValue: boolean); override;
      procedure Set_use_frozen_modules(aValue: boolean); override;
      procedure Set_use_hash_seed(aValue: boolean); override;
      procedure Set_user_site_directory(aValue: boolean); override;
      procedure Set_verbose(aValue: TPyVerboseMode); override;
      procedure Set_warn_default_encoding(aValue: boolean); override;
      procedure Set_warnoptions(const aValue: TStringDynArray); override;
      procedure Set_write_bytecode(aValue: boolean); override;
      procedure Set_xoptions(const aValue: TStringDynArray); override;
  end;

  TPyConfig311 = class(TPyConfigBase)
    protected
      FConfig : PyConfig311;
      function GetConfig: Pointer; override;
      function Get_argv: TStringDynArray; override;
      function Get_base_exec_prefix: string; override;
      function Get_base_executable: string; override;
      function Get_base_prefix: string; override;
      function Get_buffered_stdio: boolean; override;
      function Get_bytes_warning: integer; override;
      function Get_check_hash_pycs_mode: string; override;
      function Get_code_debug_ranges: boolean; override;
      function Get_configure_c_stdio: boolean; override;
      function Get_dev_mode: boolean; override;
      function Get_dump_refs: boolean; override;
      function Get_dump_refs_file: string; override;
      function Get_exec_prefix: string; override;
      function Get_executable: string; override;
      function Get_faulthandler: integer; override;
      function Get_filesystem_encoding: string; override;
      function Get_filesystem_errors: string; override;
      function Get_hash_seed: uint64; override;
      function Get_home: string; override;
      function Get_import_time: integer; override;
      function Get_inspect: boolean; override;
      function Get_install_signal_handlers: boolean; override;
      function Get_interactive: boolean; override;
      function Get_isolated: boolean; override;
      {$IFDEF MSWINDOWS}
      function Get_legacy_windows_stdio: boolean; override;
      {$ENDIF}
      function Get_malloc_stats: boolean; override;
      function Get_module_search_paths: string; override;
      function Get_module_search_paths_set: boolean; override;
      function Get_optimization_level: TPyOptimizationLevel; override;
      function Get_orig_argv: TStringDynArray; override;
      function Get_parse_argv: boolean; override;
      function Get_parser_debug: boolean; override;
      function Get_pathconfig_warnings: boolean; override;
      function Get_platlibdir: string; override;
      function Get_prefix: string; override;
      function Get_program_name: string; override;
      function Get_pycache_prefix: string; override;
      function Get_pythonpath_env: string; override;
      function Get_quiet: boolean; override;
      function Get_run_command: string; override;
      function Get_run_filename: string; override;
      function Get_run_module: string; override;
      function Get_safe_path: boolean; override;
      function Get_show_ref_count: boolean; override;
      function Get_site_import: boolean; override;
      function Get_skip_source_first_line: boolean; override;
      function Get_stdio_encoding: string; override;
      function Get_stdio_errors: string; override;
      function Get_stdlib_dir: string; override;
      function Get_tracemalloc: boolean; override;
      function Get_use_environment: boolean; override;
      function Get_use_frozen_modules: boolean; override;
      function Get_use_hash_seed: boolean; override;
      function Get_user_site_directory: boolean; override;
      function Get_verbose: TPyVerboseMode; override;
      function Get_warn_default_encoding: boolean; override;
      function Get_warnoptions: TStringDynArray; override;
      function Get_write_bytecode: boolean; override;
      function Get_xoptions: TStringDynArray; override;

      procedure Set_argv(const aValue: TStringDynArray); override;
      procedure Set_base_exec_prefix(const aValue: string); override;
      procedure Set_base_executable(const aValue: string); override;
      procedure Set_base_prefix(const aValue: string); override;
      procedure Set_buffered_stdio(aValue: boolean); override;
      procedure Set_bytes_warning(aValue: integer); override;
      procedure Set_check_hash_pycs_mode(const aValue: string); override;
      procedure Set_code_debug_ranges(aValue: boolean); override;
      procedure Set_configure_c_stdio(aValue: boolean); override;
      procedure Set_dev_mode(aValue: boolean); override;
      procedure Set_dump_refs(aValue: boolean); override;
      procedure Set_dump_refs_file(const aValue: string); override;
      procedure Set_exec_prefix(const aValue: string); override;
      procedure Set_executable(const aValue: string); override;
      procedure Set_faulthandler(aValue: integer); override;
      procedure Set_filesystem_encoding(const aValue: string); override;
      procedure Set_filesystem_errors(const aValue: string); override;
      procedure Set_hash_seed(aValue: uint64); override;
      procedure Set_home(const aValue: string); override;
      procedure Set_import_time(aValue: integer); override;
      procedure Set_inspect(aValue: boolean); override;
      procedure Set_install_signal_handlers(aValue: boolean); override;
      procedure Set_interactive(aValue: boolean); override;
      procedure Set_isolated(aValue: boolean); override;
      {$IFDEF MSWINDOWS}
      procedure Set_legacy_windows_stdio(aValue: boolean); override;
      {$ENDIF}
      procedure Set_malloc_stats(aValue: boolean); override;
      procedure Set_module_search_paths(const aValue: string); override;
      procedure Set_module_search_paths_set(aValue: boolean); override;
      procedure Set_optimization_level(aValue: TPyOptimizationLevel); override;
      procedure Set_orig_argv(const aValue: TStringDynArray); override;
      procedure Set_parse_argv(aValue: boolean); override;
      procedure Set_parser_debug(aValue: boolean); override;
      procedure Set_pathconfig_warnings(aValue: boolean); override;
      procedure Set_platlibdir(const aValue: string); override;
      procedure Set_prefix(const aValue: string); override;
      procedure Set_program_name(const aValue: string); override;
      procedure Set_pycache_prefix(const aValue: string); override;
      procedure Set_pythonpath_env(const aValue: string); override;
      procedure Set_quiet(aValue: boolean); override;
      procedure Set_run_command(const aValue: string); override;
      procedure Set_run_filename(const aValue: string); override;
      procedure Set_run_module(const aValue: string); override;
      procedure Set_safe_path(aValue: boolean); override;
      procedure Set_show_ref_count(aValue: boolean); override;
      procedure Set_site_import(aValue: boolean); override;
      procedure Set_skip_source_first_line(aValue: boolean); override;
      procedure Set_stdio_encoding(const aValue: string); override;
      procedure Set_stdio_errors(const aValue: string); override;
      procedure Set_stdlib_dir(const aValue: string); override;
      procedure Set_tracemalloc(aValue: boolean); override;
      procedure Set_use_environment(aValue: boolean); override;
      procedure Set_use_frozen_modules(aValue: boolean); override;
      procedure Set_use_hash_seed(aValue: boolean); override;
      procedure Set_user_site_directory(aValue: boolean); override;
      procedure Set_verbose(aValue: TPyVerboseMode); override;
      procedure Set_warn_default_encoding(aValue: boolean); override;
      procedure Set_warnoptions(const aValue: TStringDynArray); override;
      procedure Set_write_bytecode(aValue: boolean); override;
      procedure Set_xoptions(const aValue: TStringDynArray); override;
  end;

  TPyConfig310 = class(TPyConfigBase)
    protected
      FConfig : PyConfig310;
      function GetConfig: Pointer; override;
      function Get_argv: TStringDynArray; override;
      function Get_base_exec_prefix: string; override;
      function Get_base_executable: string; override;
      function Get_base_prefix: string; override;
      function Get_buffered_stdio: boolean; override;
      function Get_bytes_warning: integer; override;
      function Get_check_hash_pycs_mode: string; override;
      function Get_configure_c_stdio: boolean; override;
      function Get_dev_mode: boolean; override;
      function Get_dump_refs: boolean; override;
      function Get_exec_prefix: string; override;
      function Get_executable: string; override;
      function Get_faulthandler: integer; override;
      function Get_filesystem_encoding: string; override;
      function Get_filesystem_errors: string; override;
      function Get_hash_seed: uint64; override;
      function Get_home: string; override;
      function Get_import_time: integer; override;
      function Get_inspect: boolean; override;
      function Get_install_signal_handlers: boolean; override;
      function Get_interactive: boolean; override;
      function Get_isolated: boolean; override;
      {$IFDEF MSWINDOWS}
      function Get_legacy_windows_stdio: boolean; override;
      {$ENDIF}
      function Get_malloc_stats: boolean; override;
      function Get_module_search_paths: string; override;
      function Get_module_search_paths_set: boolean; override;
      function Get_optimization_level: TPyOptimizationLevel; override;
      function Get_orig_argv: TStringDynArray; override;
      function Get_parse_argv: boolean; override;
      function Get_parser_debug: boolean; override;
      function Get_pathconfig_warnings: boolean; override;
      function Get_platlibdir: string; override;
      function Get_prefix: string; override;
      function Get_program_name: string; override;
      function Get_pycache_prefix: string; override;
      function Get_pythonpath_env: string; override;
      function Get_quiet: boolean; override;
      function Get_run_command: string; override;
      function Get_run_filename: string; override;
      function Get_run_module: string; override;
      function Get_show_ref_count: boolean; override;
      function Get_site_import: boolean; override;
      function Get_skip_source_first_line: boolean; override;
      function Get_stdio_encoding: string; override;
      function Get_stdio_errors: string; override;
      function Get_tracemalloc: boolean; override;
      function Get_use_environment: boolean; override;
      function Get_use_hash_seed: boolean; override;
      function Get_user_site_directory: boolean; override;
      function Get_verbose: TPyVerboseMode; override;
      function Get_warn_default_encoding: boolean; override;
      function Get_warnoptions: TStringDynArray; override;
      function Get_write_bytecode: boolean; override;
      function Get_xoptions: TStringDynArray; override;

      procedure Set_argv(const aValue: TStringDynArray); override;
      procedure Set_base_exec_prefix(const aValue: string); override;
      procedure Set_base_executable(const aValue: string); override;
      procedure Set_base_prefix(const aValue: string); override;
      procedure Set_buffered_stdio(aValue: boolean); override;
      procedure Set_bytes_warning(aValue: integer); override;
      procedure Set_check_hash_pycs_mode(const aValue: string); override;
      procedure Set_configure_c_stdio(aValue: boolean); override;
      procedure Set_dev_mode(aValue: boolean); override;
      procedure Set_dump_refs(aValue: boolean); override;
      procedure Set_exec_prefix(const aValue: string); override;
      procedure Set_executable(const aValue: string); override;
      procedure Set_faulthandler(aValue: integer); override;
      procedure Set_filesystem_encoding(const aValue: string); override;
      procedure Set_filesystem_errors(const aValue: string); override;
      procedure Set_hash_seed(aValue: uint64); override;
      procedure Set_home(const aValue: string); override;
      procedure Set_import_time(aValue: integer); override;
      procedure Set_inspect(aValue: boolean); override;
      procedure Set_install_signal_handlers(aValue: boolean); override;
      procedure Set_interactive(aValue: boolean); override;
      procedure Set_isolated(aValue: boolean); override;
      {$IFDEF MSWINDOWS}
      procedure Set_legacy_windows_stdio(aValue: boolean); override;
      {$ENDIF}
      procedure Set_malloc_stats(aValue: boolean); override;
      procedure Set_module_search_paths(const aValue: string); override;
      procedure Set_module_search_paths_set(aValue: boolean); override;
      procedure Set_optimization_level(aValue: TPyOptimizationLevel); override;
      procedure Set_orig_argv(const aValue: TStringDynArray); override;
      procedure Set_parse_argv(aValue: boolean); override;
      procedure Set_parser_debug(aValue: boolean); override;
      procedure Set_pathconfig_warnings(aValue: boolean); override;
      procedure Set_platlibdir(const aValue: string); override;
      procedure Set_prefix(const aValue: string); override;
      procedure Set_program_name(const aValue: string); override;
      procedure Set_pycache_prefix(const aValue: string); override;
      procedure Set_pythonpath_env(const aValue: string); override;
      procedure Set_quiet(aValue: boolean); override;
      procedure Set_run_command(const aValue: string); override;
      procedure Set_run_filename(const aValue: string); override;
      procedure Set_run_module(const aValue: string); override;
      procedure Set_show_ref_count(aValue: boolean); override;
      procedure Set_site_import(aValue: boolean); override;
      procedure Set_skip_source_first_line(aValue: boolean); override;
      procedure Set_stdio_encoding(const aValue: string); override;
      procedure Set_stdio_errors(const aValue: string); override;
      procedure Set_tracemalloc(aValue: boolean); override;
      procedure Set_use_environment(aValue: boolean); override;
      procedure Set_use_hash_seed(aValue: boolean); override;
      procedure Set_user_site_directory(aValue: boolean); override;
      procedure Set_verbose(aValue: TPyVerboseMode); override;
      procedure Set_warn_default_encoding(aValue: boolean); override;
      procedure Set_warnoptions(const aValue: TStringDynArray); override;
      procedure Set_write_bytecode(aValue: boolean); override;
      procedure Set_xoptions(const aValue: TStringDynArray); override;
  end;

  TPyConfig309 = class(TPyConfigBase)
    protected
      FConfig : PyConfig309;
      function GetConfig: Pointer; override;
      function Get_argv: TStringDynArray; override;
      function Get_base_exec_prefix: string; override;
      function Get_base_executable: string; override;
      function Get_base_prefix: string; override;
      function Get_buffered_stdio: boolean; override;
      function Get_bytes_warning: integer; override;
      function Get_check_hash_pycs_mode: string; override;
      function Get_configure_c_stdio: boolean; override;
      function Get_dev_mode: boolean; override;
      function Get_dump_refs: boolean; override;
      function Get_exec_prefix: string; override;
      function Get_executable: string; override;
      function Get_faulthandler: integer; override;
      function Get_use_peg_parser: boolean; override;
      function Get_filesystem_encoding: string; override;
      function Get_filesystem_errors: string; override;
      function Get_hash_seed: uint64; override;
      function Get_home: string; override;
      function Get_import_time: integer; override;
      function Get_inspect: boolean; override;
      function Get_install_signal_handlers: boolean; override;
      function Get_interactive: boolean; override;
      function Get_isolated: boolean; override;
      {$IFDEF MSWINDOWS}
      function Get_legacy_windows_stdio: boolean; override;
      {$ENDIF}
      function Get_malloc_stats: boolean; override;
      function Get_module_search_paths: string; override;
      function Get_module_search_paths_set: boolean; override;
      function Get_optimization_level: TPyOptimizationLevel; override;
      function Get_orig_argv: TStringDynArray; override;
      function Get_parse_argv: boolean; override;
      function Get_parser_debug: boolean; override;
      function Get_pathconfig_warnings: boolean; override;
      function Get_platlibdir: string; override;
      function Get_prefix: string; override;
      function Get_program_name: string; override;
      function Get_pycache_prefix: string; override;
      function Get_pythonpath_env: string; override;
      function Get_quiet: boolean; override;
      function Get_run_command: string; override;
      function Get_run_filename: string; override;
      function Get_run_module: string; override;
      function Get_show_ref_count: boolean; override;
      function Get_site_import: boolean; override;
      function Get_skip_source_first_line: boolean; override;
      function Get_stdio_encoding: string; override;
      function Get_stdio_errors: string; override;
      function Get_tracemalloc: boolean; override;
      function Get_use_environment: boolean; override;
      function Get_use_hash_seed: boolean; override;
      function Get_user_site_directory: boolean; override;
      function Get_verbose: TPyVerboseMode; override;
      function Get_warnoptions: TStringDynArray; override;
      function Get_write_bytecode: boolean; override;
      function Get_xoptions: TStringDynArray; override;

      procedure Set_argv(const aValue: TStringDynArray); override;
      procedure Set_base_exec_prefix(const aValue: string); override;
      procedure Set_base_executable(const aValue: string); override;
      procedure Set_base_prefix(const aValue: string); override;
      procedure Set_buffered_stdio(aValue: boolean); override;
      procedure Set_bytes_warning(aValue: integer); override;
      procedure Set_check_hash_pycs_mode(const aValue: string); override;
      procedure Set_configure_c_stdio(aValue: boolean); override;
      procedure Set_dev_mode(aValue: boolean); override;
      procedure Set_dump_refs(aValue: boolean); override;
      procedure Set_exec_prefix(const aValue: string); override;
      procedure Set_executable(const aValue: string); override;
      procedure Set_faulthandler(aValue: integer); override;
      procedure Set_use_peg_parser(aValue: boolean); override;
      procedure Set_filesystem_encoding(const aValue: string); override;
      procedure Set_filesystem_errors(const aValue: string); override;
      procedure Set_hash_seed(aValue: uint64); override;
      procedure Set_home(const aValue: string); override;
      procedure Set_import_time(aValue: integer); override;
      procedure Set_inspect(aValue: boolean); override;
      procedure Set_install_signal_handlers(aValue: boolean); override;
      procedure Set_interactive(aValue: boolean); override;
      procedure Set_isolated(aValue: boolean); override;
      {$IFDEF MSWINDOWS}
      procedure Set_legacy_windows_stdio(aValue: boolean); override;
      {$ENDIF}
      procedure Set_malloc_stats(aValue: boolean); override;
      procedure Set_module_search_paths(const aValue: string); override;
      procedure Set_module_search_paths_set(aValue: boolean); override;
      procedure Set_optimization_level(aValue: TPyOptimizationLevel); override;
      procedure Set_orig_argv(const aValue: TStringDynArray); override;
      procedure Set_parse_argv(aValue: boolean); override;
      procedure Set_parser_debug(aValue: boolean); override;
      procedure Set_pathconfig_warnings(aValue: boolean); override;
      procedure Set_platlibdir(const aValue: string); override;
      procedure Set_prefix(const aValue: string); override;
      procedure Set_program_name(const aValue: string); override;
      procedure Set_pycache_prefix(const aValue: string); override;
      procedure Set_pythonpath_env(const aValue: string); override;
      procedure Set_quiet(aValue: boolean); override;
      procedure Set_run_command(const aValue: string); override;
      procedure Set_run_filename(const aValue: string); override;
      procedure Set_run_module(const aValue: string); override;
      procedure Set_show_ref_count(aValue: boolean); override;
      procedure Set_site_import(aValue: boolean); override;
      procedure Set_skip_source_first_line(aValue: boolean); override;
      procedure Set_stdio_encoding(const aValue: string); override;
      procedure Set_stdio_errors(const aValue: string); override;
      procedure Set_tracemalloc(aValue: boolean); override;
      procedure Set_use_environment(aValue: boolean); override;
      procedure Set_use_hash_seed(aValue: boolean); override;
      procedure Set_user_site_directory(aValue: boolean); override;
      procedure Set_verbose(aValue: TPyVerboseMode); override;
      procedure Set_warnoptions(const aValue: TStringDynArray); override;
      procedure Set_write_bytecode(aValue: boolean); override;
      procedure Set_xoptions(const aValue: TStringDynArray); override;
  end;

  TPyConfigBuilder = class
    public
      class function New(aMajor, aMinor: integer): IPyConfig;
  end;

implementation

uses
  uP4P.MiscFunctions, uP4P.PyObject, uP4P.PyStatus;

class function TPyConfig.Names: IPyObject;
begin
  if assigned(PyConfig_Names) then
    Result := TPyObject.Wrap(PyConfig_Names())
   else
    Result := nil;
end;

class function TPyConfig.GetInt(const name_: string; var value: integer): boolean;
var
  TempName : AnsiString;
begin
  Result := False;

  if assigned(PyConfig_GetInt) and
     (length(name_) > 0) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PyConfig_GetInt(PAnsiChar(TempName), value) = 0);
    end;
end;

class function TPyConfig.GetBoolean(const name_: string; var value: boolean): boolean;
var
  TempValue: integer;
begin
  Result    := False;
  TempValue := 0;

  if GetInt(name_, TempValue) then
    begin
      value  := (TempValue <> 0);
      Result := True;
    end;
end;

class function TPyConfig.Get(const name_: string): IPyObject;
var
  TempName : AnsiString;
begin
  if assigned(PyConfig_Get) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := TPyObject.Wrap(PyConfig_Get(PAnsiChar(TempName)));
    end
   else
    Result := nil;
end;

class function TPyConfig.Set_(const name_: string; const value: IPyObject): boolean;
var
  TempName : AnsiString;
begin
  if assigned(PyConfig_Set) and
     TPyObject.IsInitialized(value) then
    begin
      TempName := StringToPyUTF8(name_);
      Result   := (PyConfig_Set(PAnsiChar(TempName), value.PyObject) = 0);
    end
   else
    Result := False;
end;

destructor TPyConfigBase.Destroy;
begin
  if assigned(PyConfig_Clear) then
    PyConfig_Clear(Config);

  inherited Destroy;
end;

procedure TPyConfigBase.InitPythonConfig;
begin
  if assigned(PyConfig_InitPythonConfig) then
    PyConfig_InitPythonConfig(Config);
end;

procedure TPyConfigBase.InitIsolatedConfig;
begin
  if assigned(PyConfig_InitIsolatedConfig) then
    PyConfig_InitIsolatedConfig(Config);
end;

function TPyConfigBase.Read: IPyStatus;
begin
  if assigned(PyConfig_Read) then
    Result := TPyStatus.Create(PyConfig_Read(Config))
   else
    Result := nil;
end;

function TPyConfigBase.GetConfig: Pointer;
begin
  Result := nil;
end;

function TPyConfigBase.Get_argv: TStringDynArray;
begin
  Result := nil;
end;

function TPyConfigBase.Get_base_exec_prefix: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_base_executable: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_base_prefix: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_buffered_stdio: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_bytes_warning: integer;
begin
  Result := 0;
end;

function TPyConfigBase.Get_check_hash_pycs_mode: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_code_debug_ranges: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_configure_c_stdio: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_context_aware_warnings: boolean;
begin
  Result := False;
end;

{$IFDEF APPLE}
function TPyConfigBase.Get_use_system_logger: boolean;
begin
  Result := False;
end;
{$ENDIF}

function TPyConfigBase.Get_cpu_count: integer;
begin
  Result := 0;
end;

function TPyConfigBase.Get_dev_mode: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_dump_refs: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_dump_refs_file: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_exec_prefix: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_executable: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_faulthandler: integer;
begin
  Result := 0;
end;

function TPyConfigBase.Get_use_peg_parser: boolean;
begin
  Result := True;
end;

function TPyConfigBase.Get_filesystem_encoding: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_filesystem_errors: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_hash_seed: uint64;
begin
  Result := 0;
end;

function TPyConfigBase.Get_home: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_import_time: integer;
begin
  Result := 0;
end;

function TPyConfigBase.Get_inspect: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_install_signal_handlers: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_int_max_str_digits: integer;
begin
  Result := 0;
end;

function TPyConfigBase.Get_interactive: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_isolated: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_lazy_imports: PyImport_LazyImportsMode;
begin
  Result := PyImport_LAZY_NORMAL;
end;

{$IFDEF MSWINDOWS}
function TPyConfigBase.Get_legacy_windows_stdio: boolean;
begin
  Result := False;
end;
{$ENDIF}

function TPyConfigBase.Get_malloc_stats: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_module_search_paths: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_module_search_paths_set: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_optimization_level: TPyOptimizationLevel;
begin
  Result := polDebug;
end;

function TPyConfigBase.Get_orig_argv: TStringDynArray;
begin
  Result := nil;
end;

function TPyConfigBase.Get_parse_argv: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_parser_debug: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_pathconfig_warnings: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_perf_profiling: integer;
begin
  Result := 0;
end;

function TPyConfigBase.Get_platlibdir: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_prefix: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_program_name: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_pycache_prefix: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_pymalloc_hugepages: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_pythonpath_env: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_quiet: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_remote_debug: boolean;
begin
  Result := True;
end;

function TPyConfigBase.Get_run_command: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_run_filename: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_run_module: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_safe_path: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_show_ref_count: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_site_import: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_skip_source_first_line: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_stdio_encoding: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_stdio_errors: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_stdlib_dir: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_sys_path_0: string;
begin
  Result := '';
end;

function TPyConfigBase.Get_thread_inherit_context: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_tracemalloc: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_use_environment: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_use_frozen_modules: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_use_hash_seed: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_user_site_directory: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_verbose: TPyVerboseMode;
begin
  Result := pvmDisabled;
end;

function TPyConfigBase.Get_warn_default_encoding: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_warnoptions: TStringDynArray;
begin
  Result := nil;
end;

function TPyConfigBase.Get_write_bytecode: boolean;
begin
  Result := False;
end;

function TPyConfigBase.Get_xoptions: TStringDynArray;
begin
  Result := nil;
end;

function TPyConfigBase.SetWCharT(var DstString: PWCharT; const SrcString: string): boolean;
var
  TempStatus : IPyStatus;
begin
  TempStatus := SetString(DstString, StringToPyWCharTString(SrcString));
  Result     := assigned(TempStatus) and not(TempStatus.IsException);
end;

function TPyConfigBase.SetString(var DstString: PWCharT; SrcString: WCharTString): IPyStatus;
begin
  if assigned(PyConfig_SetString) then
    Result := TPyStatus.Create(PyConfig_SetString(Config, DstString, PWCharT(SrcString)))
   else
    Result := nil;
end;

function TPyConfigBase.SetBytesString(var DstString: PWCharT; SrcString: AnsiString): IPyStatus;
begin
  if assigned(PyConfig_SetBytesString) then
    Result := TPyStatus.Create(PyConfig_SetBytesString(Config, DstString, PAnsiChar(SrcString)))
   else
    Result := nil;
end;

function TPyConfigBase.SetArgv(argc: integer; const argv: array of PWCharT): IPyStatus;
begin
  if assigned(PyConfig_SetArgv) then
    begin
      if (argc > 0) then
        Result := TPyStatus.Create(PyConfig_SetArgv(Config, argc, @argv[0]))
       else
        Result := TPyStatus.Create(PyConfig_SetArgv(Config, 0, nil));
    end
   else
    Result := nil;
end;

function TPyConfigBase.SetArgv(const items: TStringList): boolean;
var
  TempStatus : IPyStatus;
  TempItems : array of WCharTString;
  TempItemsPtr : array of PWCharT;
  i : integer;
begin
  Result := False;
  if not(assigned(items)) then exit;
                                   
  TempItems    := nil;
  TempItemsPtr := nil;

  if (items.count > 0) then
    begin                   
      SetLength(TempItems,    items.count);
      SetLength(TempItemsPtr, items.count);

      for i := 0 to pred(items.count) do
        begin
          TempItems[i]    := StringToPyWCharTString(items[i]);
          TempItemsPtr[i] := PWCharT(TempItems[i]);
        end;
    end;

  TempStatus := SetArgv(items.count, TempItemsPtr);
  Result     := assigned(TempStatus) and not(TempStatus.IsException);
end;

function TPyConfigBase.SetArgv(const items: TStringDynArray): boolean;
var
  TempStatus : IPyStatus;
  TempItems : array of WCharTString;
  TempItemsPtr : array of PWCharT;
  i, TempLen : integer;
begin
  Result := False;
  if not(assigned(items)) then exit;

  TempLen      := length(items);
  TempItems    := nil;
  TempItemsPtr := nil;

  if (TempLen > 0) then
    begin
      SetLength(TempItems,    TempLen);
      SetLength(TempItemsPtr, TempLen);

      for i := 0 to pred(TempLen) do
        begin
          TempItems[i]    := StringToPyWCharTString(items[i]);
          TempItemsPtr[i] := PWCharT(TempItems[i]);
        end;
    end;

  TempStatus := SetArgv(TempLen, TempItemsPtr);
  Result     := assigned(TempStatus) and not(TempStatus.IsException);
end;

function TPyConfigBase.SetBytesArgv(argc: integer; const argv: array of PAnsiChar): IPyStatus;
begin
  if assigned(PyConfig_SetBytesArgv) then
    begin
      if (argc > 0) then
        Result := TPyStatus.Create(PyConfig_SetBytesArgv(Config, argc, @argv[0]))
       else
        Result := TPyStatus.Create(PyConfig_SetBytesArgv(Config, 0, nil));
    end
   else
    Result := nil;
end;

function TPyConfigBase.SetWideStringList(var list: PyWideStringList; length: integer; items: array of PWCharT): IPyStatus;
begin
  if assigned(PyConfig_SetWideStringList) then
    begin
      if (length > 0) then
        Result := TPyStatus.Create(PyConfig_SetWideStringList(Config, @list, length, @items[0]))
       else
        Result := TPyStatus.Create(PyConfig_SetWideStringList(Config, @list, 0, nil));
    end
   else
    Result := nil;
end;

function TPyConfigBase.SetWideStringList(var list: PyWideStringList; const items: TStringList): boolean;
var
  TempStatus : IPyStatus;
  TempItems : array of WCharTString;
  TempItemsPtr : array of PWCharT;
  i : integer;
begin
  Result := False;
  if not(assigned(items)) then exit;

  TempItems    := nil;
  TempItemsPtr := nil;

  if (items.count > 0) then
    begin
      SetLength(TempItems,    items.count);
      SetLength(TempItemsPtr, items.count);

      for i := 0 to pred(items.count) do
        begin
          TempItems[i]    := StringToPyWCharTString(items[i]);
          TempItemsPtr[i] := PWCharT(TempItems[i]);
        end;
    end;

  TempStatus := SetWideStringList(list, items.count, TempItemsPtr);
  Result     := assigned(TempStatus) and not(TempStatus.IsException);
end;

function TPyConfigBase.SetWideStringList(var list: PyWideStringList; const items: TStringDynArray): boolean;
var
  TempStatus : IPyStatus;
  TempItems : array of WCharTString;
  TempItemsPtr : array of PWCharT;
  i, TempLen : integer;
begin
  Result := False;
  if not(assigned(items)) then exit;

  TempLen      := length(items);
  TempItems    := nil;
  TempItemsPtr := nil;

  if (TempLen > 0) then
    begin
      SetLength(TempItems,    TempLen);
      SetLength(TempItemsPtr, TempLen);

      for i := 0 to pred(TempLen) do
        begin
          TempItems[i]    := StringToPyWCharTString(items[i]);
          TempItemsPtr[i] := PWCharT(TempItems[i]);
        end;
    end;

  TempStatus := SetWideStringList(list, TempLen, TempItemsPtr);
  Result     := assigned(TempStatus) and not(TempStatus.IsException);
end;

procedure TPyConfigBase.Set_argv(const aValue: TStringDynArray);
begin
  SetArgv(aValue);
end;

procedure TPyConfigBase.Set_base_exec_prefix(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_base_executable(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_base_prefix(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_buffered_stdio(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_bytes_warning(aValue: integer);
begin
  //
end;

procedure TPyConfigBase.Set_check_hash_pycs_mode(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_code_debug_ranges(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_configure_c_stdio(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_context_aware_warnings(aValue: boolean);
begin
  //
end;

{$IFDEF APPLE}
procedure TPyConfigBase.Set_use_system_logger(aValue: boolean);
begin
  //
end;
{$ENDIF}

procedure TPyConfigBase.Set_cpu_count(aValue: integer);
begin
  //
end;

procedure TPyConfigBase.Set_dev_mode(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_dump_refs(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_dump_refs_file(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_exec_prefix(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_executable(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_faulthandler(aValue: integer);
begin
  //
end;

procedure TPyConfigBase.Set_use_peg_parser(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_filesystem_encoding(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_filesystem_errors(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_hash_seed(aValue: uint64);
begin
  //
end;

procedure TPyConfigBase.Set_home(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_import_time(aValue: integer);
begin
  //
end;

procedure TPyConfigBase.Set_inspect(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_install_signal_handlers(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_int_max_str_digits(aValue: integer);
begin
  //
end;

procedure TPyConfigBase.Set_interactive(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_isolated(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_lazy_imports(aValue: PyImport_LazyImportsMode);
begin
  //
end;

{$IFDEF MSWINDOWS}
procedure TPyConfigBase.Set_legacy_windows_stdio(aValue: boolean);
begin
  //
end;
{$ENDIF}

procedure TPyConfigBase.Set_malloc_stats(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_module_search_paths(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_module_search_paths_set(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_optimization_level(aValue: TPyOptimizationLevel);
begin
  //
end;

procedure TPyConfigBase.Set_orig_argv(const aValue: TStringDynArray);
begin
  //
end;

procedure TPyConfigBase.Set_parse_argv(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_parser_debug(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_pathconfig_warnings(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_perf_profiling(aValue: integer);
begin
  //
end;

procedure TPyConfigBase.Set_platlibdir(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_prefix(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_program_name(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_pycache_prefix(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_pymalloc_hugepages(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_pythonpath_env(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_quiet(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_remote_debug(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_run_command(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_run_filename(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_run_module(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_safe_path(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_show_ref_count(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_site_import(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_skip_source_first_line(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_stdio_encoding(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_stdio_errors(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_stdlib_dir(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_sys_path_0(const aValue: string);
begin
  //
end;

procedure TPyConfigBase.Set_thread_inherit_context(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_tracemalloc(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_use_environment(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_use_frozen_modules(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_use_hash_seed(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_user_site_directory(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_verbose(aValue: TPyVerboseMode);
begin
  //
end;

procedure TPyConfigBase.Set_warn_default_encoding(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_warnoptions(const aValue: TStringDynArray);
begin
  //
end;

procedure TPyConfigBase.Set_write_bytecode(aValue: boolean);
begin
  //
end;

procedure TPyConfigBase.Set_xoptions(const aValue: TStringDynArray);
begin
  //
end;

function TPyConfig315.GetConfig: Pointer;
begin
  Result := @FConfig;
end;

function TPyConfig315.Get_argv: TStringDynArray;
begin
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.argv, Result);
end;

function TPyConfig315.Get_base_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_exec_prefix));
end;

function TPyConfig315.Get_base_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_executable));
end;

function TPyConfig315.Get_base_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_prefix));
end;

function TPyConfig315.Get_buffered_stdio: boolean;
begin
  Result := (FConfig.buffered_stdio <> 0);
end;

function TPyConfig315.Get_bytes_warning: integer;
begin
  Result := FConfig.bytes_warning;
end;

function TPyConfig315.Get_check_hash_pycs_mode: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.check_hash_pycs_mode));
end;

function TPyConfig315.Get_code_debug_ranges: boolean;
begin
  Result := (FConfig.code_debug_ranges <> 0);
end;

function TPyConfig315.Get_configure_c_stdio: boolean;
begin
  Result := (FConfig.configure_c_stdio <> 0);
end;

function TPyConfig315.Get_context_aware_warnings: boolean;
begin
  Result := (FConfig.context_aware_warnings <> 0);
end;

{$IFDEF APPLE}
function TPyConfig315.Get_use_system_logger: boolean;
begin
  Result := (FConfig.use_system_logger <> 0);
end;
{$ENDIF}

function TPyConfig315.Get_cpu_count: integer;
begin
  Result := FConfig.cpu_count;
end;

function TPyConfig315.Get_dev_mode: boolean;
begin
  Result := (FConfig.dev_mode <> 0);
end;

function TPyConfig315.Get_dump_refs: boolean;
begin
  Result := (FConfig.dump_refs <> 0);
end;

function TPyConfig315.Get_dump_refs_file: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.dump_refs_file));
end;

function TPyConfig315.Get_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.exec_prefix));
end;

function TPyConfig315.Get_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.executable));
end;

function TPyConfig315.Get_faulthandler: integer;
begin
  Result := FConfig.faulthandler;
end;

function TPyConfig315.Get_filesystem_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_encoding));
end;

function TPyConfig315.Get_filesystem_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_errors));
end;

function TPyConfig315.Get_hash_seed: uint64;
begin
  Result := FConfig.hash_seed;
end;

function TPyConfig315.Get_home: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.home));
end;

function TPyConfig315.Get_import_time: integer;
begin
  Result := FConfig.import_time;
end;

function TPyConfig315.Get_inspect: boolean;
begin
  Result := (FConfig.inspect <> 0);
end;

function TPyConfig315.Get_install_signal_handlers: boolean;
begin
  Result := (FConfig.install_signal_handlers <> 0);
end;

function TPyConfig315.Get_int_max_str_digits: integer;
begin
  Result := FConfig.int_max_str_digits;
end;

function TPyConfig315.Get_interactive: boolean;
begin
  Result := (FConfig.interactive <> 0);
end;

function TPyConfig315.Get_isolated: boolean;
begin
  Result := (FConfig.isolated <> 0);
end;

function TPyConfig315.Get_lazy_imports: PyImport_LazyImportsMode;
begin
  if (FConfig.lazy_imports > 0) then
    Result := PyImport_LAZY_ALL
   else
    Result := PyImport_LAZY_NORMAL;
end;

{$IFDEF MSWINDOWS}
function TPyConfig315.Get_legacy_windows_stdio: boolean;
begin
  Result := (FConfig.legacy_windows_stdio <> 0);
end;
{$ENDIF}

function TPyConfig315.Get_malloc_stats: boolean;
begin
  Result := (FConfig.malloc_stats <> 0);
end;

function TPyConfig315.Get_module_search_paths: string;
var
  TempSL : TStringList;
  i      : integer;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.module_search_paths, TempSL) then
    begin
      i := 0;
      while (i < TempSL.Count) do
        begin
          if (i = 0) then
            Result := TempSL[i]
           else
            Result := Result + PathSep + TempSL[i];

          inc(i);
        end;
    end
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig315.Get_module_search_paths_set: boolean;
begin
  Result := (FConfig.module_search_paths_set <> 0);
end;

function TPyConfig315.Get_optimization_level: TPyOptimizationLevel;
begin
  Result := TPyOptimizationLevel(FConfig.optimization_level);
end;

function TPyConfig315.Get_orig_argv: TStringDynArray;
begin                             
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.orig_argv, Result);
end;

function TPyConfig315.Get_parse_argv: boolean;
begin
  Result := (FConfig.parse_argv <> 0);
end;

function TPyConfig315.Get_parser_debug: boolean;
begin
  Result := (FConfig.parser_debug <> 0);
end;

function TPyConfig315.Get_pathconfig_warnings: boolean;
begin
  Result := (FConfig.pathconfig_warnings <> 0);
end;

function TPyConfig315.Get_perf_profiling: integer;
begin
  Result := FConfig.perf_profiling;
end;

function TPyConfig315.Get_platlibdir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.platlibdir));
end;

function TPyConfig315.Get_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.prefix));
end;

function TPyConfig315.Get_program_name: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.program_name));
end;

function TPyConfig315.Get_pycache_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pycache_prefix));
end;

function TPyConfig315.Get_pymalloc_hugepages: boolean;
begin
  Result := (FConfig.pymalloc_hugepages <> 0);
end;

function TPyConfig315.Get_pythonpath_env: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pythonpath_env));
end;

function TPyConfig315.Get_quiet: boolean;
begin
  Result := (FConfig.quiet <> 0);
end;

function TPyConfig315.Get_remote_debug: boolean;
begin
  Result := (FConfig.remote_debug <> 0);
end;

function TPyConfig315.Get_run_command: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_command));
end;

function TPyConfig315.Get_run_filename: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_filename));
end;

function TPyConfig315.Get_run_module: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_module));
end;

function TPyConfig315.Get_safe_path: boolean;
begin
  Result := (FConfig.safe_path <> 0);
end;

function TPyConfig315.Get_show_ref_count: boolean;
begin
  Result := (FConfig.show_ref_count <> 0);
end;

function TPyConfig315.Get_site_import: boolean;
begin
  Result := (FConfig.site_import <> 0);
end;

function TPyConfig315.Get_skip_source_first_line: boolean;
begin
  Result := (FConfig.skip_source_first_line <> 0);
end;

function TPyConfig315.Get_stdio_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_encoding));
end;

function TPyConfig315.Get_stdio_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_errors));
end;

function TPyConfig315.Get_stdlib_dir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdlib_dir));
end;

function TPyConfig315.Get_sys_path_0: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.sys_path_0));
end;

function TPyConfig315.Get_thread_inherit_context: boolean;
begin
  Result := (FConfig.thread_inherit_context <> 0);
end;

function TPyConfig315.Get_tracemalloc: boolean;
begin
  Result := (FConfig.tracemalloc <> 0);
end;

function TPyConfig315.Get_use_environment: boolean;
begin
  Result := (FConfig.use_environment <> 0);
end;

function TPyConfig315.Get_use_frozen_modules: boolean;
begin
  Result := (FConfig.use_frozen_modules <> 0);
end;

function TPyConfig315.Get_use_hash_seed: boolean;
begin
  Result := (FConfig.use_hash_seed <> 0);
end;

function TPyConfig315.Get_user_site_directory: boolean;
begin
  Result := (FConfig.user_site_directory <> 0);
end;

function TPyConfig315.Get_verbose: TPyVerboseMode;
begin
  Result := TPyVerboseMode(FConfig.verbose);
end;

function TPyConfig315.Get_warn_default_encoding: boolean;
begin
  Result := (FConfig.warn_default_encoding <> 0);
end;

function TPyConfig315.Get_warnoptions: TStringDynArray;
begin                           
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.warnoptions, Result);
end;

function TPyConfig315.Get_write_bytecode: boolean;
begin
  Result := (FConfig.write_bytecode <> 0);
end;

function TPyConfig315.Get_xoptions: TStringDynArray;
begin                          
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.xoptions, Result);
end;

procedure TPyConfig315.Set_argv(const aValue: TStringDynArray);
begin
  SetArgv(aValue);
end;

procedure TPyConfig315.Set_base_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_exec_prefix, aValue);
end;

procedure TPyConfig315.Set_base_executable(const aValue: string);
begin
  SetWCharT(FConfig.base_executable, aValue);
end;

procedure TPyConfig315.Set_base_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_prefix, aValue);
end;

procedure TPyConfig315.Set_buffered_stdio(aValue: boolean);
begin
  FConfig.buffered_stdio := ord(aValue);
end;

procedure TPyConfig315.Set_bytes_warning(aValue: integer);
begin
  FConfig.bytes_warning := aValue;
end;

procedure TPyConfig315.Set_check_hash_pycs_mode(const aValue: string);
begin
  SetWCharT(FConfig.check_hash_pycs_mode, aValue);
end;

procedure TPyConfig315.Set_code_debug_ranges(aValue: boolean);
begin
  FConfig.code_debug_ranges := ord(aValue);
end;

procedure TPyConfig315.Set_configure_c_stdio(aValue: boolean);
begin
  FConfig.configure_c_stdio := ord(aValue);
end;

procedure TPyConfig315.Set_context_aware_warnings(aValue: boolean);
begin
  FConfig.context_aware_warnings := ord(aValue);
end;

{$IFDEF APPLE}
procedure TPyConfig315.Set_use_system_logger(aValue: boolean);
begin
  FConfig.use_system_logger := ord(aValue);
end;
{$ENDIF}

procedure TPyConfig315.Set_cpu_count(aValue: integer);
begin
  FConfig.cpu_count := aValue;
end;

procedure TPyConfig315.Set_dev_mode(aValue: boolean);
begin
  if aValue then
    FConfig.dev_mode := -1
   else
    FConfig.dev_mode := 0;
end;

procedure TPyConfig315.Set_dump_refs(aValue: boolean);
begin
  FConfig.dump_refs := ord(aValue);
end;

procedure TPyConfig315.Set_dump_refs_file(const aValue: string);
begin
  SetWCharT(FConfig.dump_refs_file, aValue);
end;

procedure TPyConfig315.Set_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.exec_prefix, aValue);
end;

procedure TPyConfig315.Set_executable(const aValue: string);
begin
  SetWCharT(FConfig.executable, aValue);
end;

procedure TPyConfig315.Set_faulthandler(aValue: integer);
begin
  FConfig.faulthandler := aValue;
end;

procedure TPyConfig315.Set_filesystem_encoding(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_encoding, aValue);
end;

procedure TPyConfig315.Set_filesystem_errors(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_errors, aValue);
end;

procedure TPyConfig315.Set_hash_seed(aValue: uint64);
begin
  FConfig.hash_seed := aValue;
end;

procedure TPyConfig315.Set_home(const aValue: string);
begin
  SetWCharT(FConfig.home, aValue);
end;

procedure TPyConfig315.Set_import_time(aValue: integer);
begin
  FConfig.import_time := aValue;
end;

procedure TPyConfig315.Set_inspect(aValue: boolean);
begin
  FConfig.inspect := ord(aValue);
end;

procedure TPyConfig315.Set_install_signal_handlers(aValue: boolean);
begin
  FConfig.install_signal_handlers := ord(aValue);
end;

procedure TPyConfig315.Set_int_max_str_digits(aValue: integer);
begin
  FConfig.int_max_str_digits := aValue;
end;

procedure TPyConfig315.Set_interactive(aValue: boolean);
begin
  FConfig.interactive := ord(aValue);
end;

procedure TPyConfig315.Set_isolated(aValue: boolean);
begin
  FConfig.isolated := ord(aValue);
end;

procedure TPyConfig315.Set_lazy_imports(aValue: PyImport_LazyImportsMode);
begin
  case aValue of
    PyImport_LAZY_ALL     : FConfig.lazy_imports := 1;
    PyImport_LAZY_NORMAL  : FConfig.lazy_imports := -1;
  end;
end;

{$IFDEF MSWINDOWS}
procedure TPyConfig315.Set_legacy_windows_stdio(aValue: boolean);
begin
  FConfig.legacy_windows_stdio := ord(aValue);
end;
{$ENDIF}

procedure TPyConfig315.Set_malloc_stats(aValue: boolean);
begin
  FConfig.malloc_stats := ord(aValue);
end;

procedure TPyConfig315.Set_module_search_paths(const aValue: string);
var
  TempPaths : TStringDynArray;
begin
  if (length(aValue) > 0) then
    begin
      TempPaths := CustomSplitString(aValue, PathSep);
      SetWideStringList(FConfig.module_search_paths, TempPaths);
    end;
end;

procedure TPyConfig315.Set_module_search_paths_set(aValue: boolean);
begin
  FConfig.module_search_paths_set := ord(aValue);
end;

procedure TPyConfig315.Set_optimization_level(aValue: TPyOptimizationLevel);
begin
  FConfig.optimization_level := integer(aValue);
end;

procedure TPyConfig315.Set_orig_argv(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.orig_argv, aValue);
end;

procedure TPyConfig315.Set_parse_argv(aValue: boolean);
begin
  FConfig.parse_argv := ord(aValue);
end;

procedure TPyConfig315.Set_parser_debug(aValue: boolean);
begin
  FConfig.parser_debug := ord(aValue);
end;

procedure TPyConfig315.Set_pathconfig_warnings(aValue: boolean);
begin
  FConfig.pathconfig_warnings := ord(aValue);
end;

procedure TPyConfig315.Set_perf_profiling(aValue: integer);
begin
  FConfig.perf_profiling := aValue;
end;

procedure TPyConfig315.Set_platlibdir(const aValue: string);
begin
  SetWCharT(FConfig.platlibdir, aValue);
end;

procedure TPyConfig315.Set_prefix(const aValue: string);
begin
  SetWCharT(FConfig.prefix, aValue);
end;

procedure TPyConfig315.Set_program_name(const aValue: string);
begin
  SetWCharT(FConfig.program_name, aValue);
end;

procedure TPyConfig315.Set_pycache_prefix(const aValue: string);
begin
  SetWCharT(FConfig.pycache_prefix, aValue);
end;

procedure TPyConfig315.Set_pymalloc_hugepages(aValue: boolean);
begin
  FConfig.pymalloc_hugepages := ord(aValue);
end;

procedure TPyConfig315.Set_pythonpath_env(const aValue: string);
begin
  SetWCharT(FConfig.pythonpath_env, aValue);
end;

procedure TPyConfig315.Set_quiet(aValue: boolean);
begin
  FConfig.quiet := ord(aValue);
end;

procedure TPyConfig315.Set_remote_debug(aValue: boolean);
begin
  FConfig.remote_debug := ord(aValue);
end;

procedure TPyConfig315.Set_run_command(const aValue: string);
begin
  SetWCharT(FConfig.run_command, aValue);
end;

procedure TPyConfig315.Set_run_filename(const aValue: string);
begin
  SetWCharT(FConfig.run_filename, aValue);
end;

procedure TPyConfig315.Set_run_module(const aValue: string);
begin
  SetWCharT(FConfig.run_module, aValue);
end;

procedure TPyConfig315.Set_safe_path(aValue: boolean);
begin
  FConfig.safe_path := ord(aValue);
end;

procedure TPyConfig315.Set_show_ref_count(aValue: boolean);
begin
  FConfig.show_ref_count := ord(aValue);
end;

procedure TPyConfig315.Set_site_import(aValue: boolean);
begin
  FConfig.site_import := ord(aValue);
end;

procedure TPyConfig315.Set_skip_source_first_line(aValue: boolean);
begin
  FConfig.skip_source_first_line := ord(aValue);
end;

procedure TPyConfig315.Set_stdio_encoding(const aValue: string);
begin
  SetWCharT(FConfig.stdio_encoding, aValue);
end;

procedure TPyConfig315.Set_stdio_errors(const aValue: string);
begin
  SetWCharT(FConfig.stdio_errors, aValue);
end;

procedure TPyConfig315.Set_stdlib_dir(const aValue: string);
begin
  SetWCharT(FConfig.stdlib_dir, aValue);
end;

procedure TPyConfig315.Set_sys_path_0(const aValue: string);
begin
  SetWCharT(FConfig.sys_path_0, aValue);
end;

procedure TPyConfig315.Set_thread_inherit_context(aValue: boolean);
begin
  FConfig.thread_inherit_context := ord(aValue);
end;

procedure TPyConfig315.Set_tracemalloc(aValue: boolean);
begin
  if aValue then
    FConfig.tracemalloc := -1
   else
    FConfig.tracemalloc := 0;
end;

procedure TPyConfig315.Set_use_environment(aValue: boolean);
begin
  FConfig.use_environment := ord(aValue);
end;

procedure TPyConfig315.Set_use_frozen_modules(aValue: boolean);
begin
  FConfig.use_frozen_modules := ord(aValue);
end;

procedure TPyConfig315.Set_use_hash_seed(aValue: boolean);
begin
  if aValue then
    FConfig.use_hash_seed := -1
   else
    FConfig.use_hash_seed := 0;
end;

procedure TPyConfig315.Set_user_site_directory(aValue: boolean);
begin
  FConfig.user_site_directory := ord(aValue);
end;

procedure TPyConfig315.Set_verbose(aValue: TPyVerboseMode);
begin
  FConfig.verbose := integer(aValue);
end;

procedure TPyConfig315.Set_warn_default_encoding(aValue: boolean);
begin
  FConfig.warn_default_encoding := ord(aValue);
end;

procedure TPyConfig315.Set_warnoptions(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.warnoptions, aValue);
end;

procedure TPyConfig315.Set_write_bytecode(aValue: boolean);
begin
  FConfig.write_bytecode := ord(aValue);
end;

procedure TPyConfig315.Set_xoptions(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.xoptions, aValue);
end;

function TPyConfig314.GetConfig: Pointer;
begin
  Result := @FConfig;
end;

function TPyConfig314.Get_argv: TStringDynArray;
begin                           
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.argv, Result);
end;

function TPyConfig314.Get_base_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_exec_prefix));
end;

function TPyConfig314.Get_base_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_executable));
end;

function TPyConfig314.Get_base_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_prefix));
end;

function TPyConfig314.Get_buffered_stdio: boolean;
begin
  Result := (FConfig.buffered_stdio <> 0);
end;

function TPyConfig314.Get_bytes_warning: integer;
begin
  Result := FConfig.bytes_warning;
end;

function TPyConfig314.Get_check_hash_pycs_mode: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.check_hash_pycs_mode));
end;

function TPyConfig314.Get_code_debug_ranges: boolean;
begin
  Result := (FConfig.code_debug_ranges <> 0);
end;

function TPyConfig314.Get_configure_c_stdio: boolean;
begin
  Result := (FConfig.configure_c_stdio <> 0);
end;

function TPyConfig314.Get_context_aware_warnings: boolean;
begin
  Result := (FConfig.context_aware_warnings <> 0);
end;

{$IFDEF APPLE}
function TPyConfig314.Get_use_system_logger: boolean;
begin
  Result := (FConfig.use_system_logger <> 0);
end;
{$ENDIF}

function TPyConfig314.Get_cpu_count: integer;
begin
  Result := FConfig.cpu_count;
end;

function TPyConfig314.Get_dev_mode: boolean;
begin
  Result := (FConfig.dev_mode <> 0);
end;

function TPyConfig314.Get_dump_refs: boolean;
begin
  Result := (FConfig.dump_refs <> 0);
end;

function TPyConfig314.Get_dump_refs_file: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.dump_refs_file));
end;

function TPyConfig314.Get_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.exec_prefix));
end;

function TPyConfig314.Get_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.executable));
end;

function TPyConfig314.Get_faulthandler: integer;
begin
  Result := FConfig.faulthandler;
end;

function TPyConfig314.Get_filesystem_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_encoding));
end;

function TPyConfig314.Get_filesystem_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_errors));
end;

function TPyConfig314.Get_hash_seed: uint64;
begin
  Result := FConfig.hash_seed;
end;

function TPyConfig314.Get_home: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.home));
end;

function TPyConfig314.Get_import_time: integer;
begin
  Result := FConfig.import_time;
end;

function TPyConfig314.Get_inspect: boolean;
begin
  Result := (FConfig.inspect <> 0);
end;

function TPyConfig314.Get_install_signal_handlers: boolean;
begin
  Result := (FConfig.install_signal_handlers <> 0);
end;

function TPyConfig314.Get_int_max_str_digits: integer;
begin
  Result := FConfig.int_max_str_digits;
end;

function TPyConfig314.Get_interactive: boolean;
begin
  Result := (FConfig.interactive <> 0);
end;

function TPyConfig314.Get_isolated: boolean;
begin
  Result := (FConfig.isolated <> 0);
end;

{$IFDEF MSWINDOWS}
function TPyConfig314.Get_legacy_windows_stdio: boolean;
begin
  Result := (FConfig.legacy_windows_stdio <> 0);
end;
{$ENDIF}

function TPyConfig314.Get_malloc_stats: boolean;
begin
  Result := (FConfig.malloc_stats <> 0);
end;

function TPyConfig314.Get_module_search_paths: string;
var
  TempSL : TStringList;
  i      : integer;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.module_search_paths, TempSL) then
    begin
      i := 0;
      while (i < TempSL.Count) do
        begin
          if (i = 0) then
            Result := TempSL[i]
           else
            Result := Result + PathSep + TempSL[i];

          inc(i);
        end;
    end
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig314.Get_module_search_paths_set: boolean;
begin
  Result := (FConfig.module_search_paths_set <> 0);
end;

function TPyConfig314.Get_optimization_level: TPyOptimizationLevel;
begin
  Result := TPyOptimizationLevel(FConfig.optimization_level);
end;

function TPyConfig314.Get_orig_argv: TStringDynArray;
begin                                 
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.orig_argv, Result);
end;

function TPyConfig314.Get_parse_argv: boolean;
begin
  Result := (FConfig.parse_argv <> 0);
end;

function TPyConfig314.Get_parser_debug: boolean;
begin
  Result := (FConfig.parser_debug <> 0);
end;

function TPyConfig314.Get_pathconfig_warnings: boolean;
begin
  Result := (FConfig.pathconfig_warnings <> 0);
end;

function TPyConfig314.Get_perf_profiling: integer;
begin
  Result := FConfig.perf_profiling;
end;

function TPyConfig314.Get_platlibdir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.platlibdir));
end;

function TPyConfig314.Get_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.prefix));
end;

function TPyConfig314.Get_program_name: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.program_name));
end;

function TPyConfig314.Get_pycache_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pycache_prefix));
end;

function TPyConfig314.Get_pythonpath_env: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pythonpath_env));
end;

function TPyConfig314.Get_quiet: boolean;
begin
  Result := (FConfig.quiet <> 0);
end;

function TPyConfig314.Get_remote_debug: boolean;
begin
  Result := (FConfig.remote_debug <> 0);
end;

function TPyConfig314.Get_run_command: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_command));
end;

function TPyConfig314.Get_run_filename: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_filename));
end;

function TPyConfig314.Get_run_module: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_module));
end;

function TPyConfig314.Get_safe_path: boolean;
begin
  Result := (FConfig.safe_path <> 0);
end;

function TPyConfig314.Get_show_ref_count: boolean;
begin
  Result := (FConfig.show_ref_count <> 0);
end;

function TPyConfig314.Get_site_import: boolean;
begin
  Result := (FConfig.site_import <> 0);
end;

function TPyConfig314.Get_skip_source_first_line: boolean;
begin
  Result := (FConfig.skip_source_first_line <> 0);
end;

function TPyConfig314.Get_stdio_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_encoding));
end;

function TPyConfig314.Get_stdio_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_errors));
end;

function TPyConfig314.Get_stdlib_dir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdlib_dir));
end;

function TPyConfig314.Get_sys_path_0: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.sys_path_0));
end;

function TPyConfig314.Get_thread_inherit_context: boolean;
begin
  Result := (FConfig.thread_inherit_context <> 0);
end;

function TPyConfig314.Get_tracemalloc: boolean;
begin
  Result := (FConfig.tracemalloc <> 0);
end;

function TPyConfig314.Get_use_environment: boolean;
begin
  Result := (FConfig.use_environment <> 0);
end;

function TPyConfig314.Get_use_frozen_modules: boolean;
begin
  Result := (FConfig.use_frozen_modules <> 0);
end;

function TPyConfig314.Get_use_hash_seed: boolean;
begin
  Result := (FConfig.use_hash_seed <> 0);
end;

function TPyConfig314.Get_user_site_directory: boolean;
begin
  Result := (FConfig.user_site_directory <> 0);
end;

function TPyConfig314.Get_verbose: TPyVerboseMode;
begin
  Result := TPyVerboseMode(FConfig.verbose);
end;

function TPyConfig314.Get_warn_default_encoding: boolean;
begin
  Result := (FConfig.warn_default_encoding <> 0);
end;

function TPyConfig314.Get_warnoptions: TStringDynArray;
begin                                       
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.warnoptions, Result);
end;

function TPyConfig314.Get_write_bytecode: boolean;
begin
  Result := (FConfig.write_bytecode <> 0);
end;

function TPyConfig314.Get_xoptions: TStringDynArray;
begin                                      
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.xoptions, Result);
end;

procedure TPyConfig314.Set_argv(const aValue: TStringDynArray);
begin
  SetArgv(aValue);
end;

procedure TPyConfig314.Set_base_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_exec_prefix, aValue);
end;

procedure TPyConfig314.Set_base_executable(const aValue: string);
begin
  SetWCharT(FConfig.base_executable, aValue);
end;

procedure TPyConfig314.Set_base_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_prefix, aValue);
end;

procedure TPyConfig314.Set_buffered_stdio(aValue: boolean);
begin
  FConfig.buffered_stdio := ord(aValue);
end;

procedure TPyConfig314.Set_bytes_warning(aValue: integer);
begin
  FConfig.bytes_warning := aValue;
end;

procedure TPyConfig314.Set_check_hash_pycs_mode(const aValue: string);
begin
  SetWCharT(FConfig.check_hash_pycs_mode, aValue);
end;

procedure TPyConfig314.Set_code_debug_ranges(aValue: boolean);
begin
  FConfig.code_debug_ranges := ord(aValue);
end;

procedure TPyConfig314.Set_configure_c_stdio(aValue: boolean);
begin
  FConfig.configure_c_stdio := ord(aValue);
end;

procedure TPyConfig314.Set_context_aware_warnings(aValue: boolean);
begin
  FConfig.context_aware_warnings := ord(aValue);
end;

{$IFDEF APPLE}
procedure TPyConfig314.Set_use_system_logger(aValue: boolean);
begin
  FConfig.use_system_logger := ord(aValue);
end;
{$ENDIF}

procedure TPyConfig314.Set_cpu_count(aValue: integer);
begin
  FConfig.cpu_count := aValue;
end;

procedure TPyConfig314.Set_dev_mode(aValue: boolean);
begin
  if aValue then
    FConfig.dev_mode := -1
   else
    FConfig.dev_mode := 0;
end;

procedure TPyConfig314.Set_dump_refs(aValue: boolean);
begin
  FConfig.dump_refs := ord(aValue);
end;

procedure TPyConfig314.Set_dump_refs_file(const aValue: string);
begin
  SetWCharT(FConfig.dump_refs_file, aValue);
end;

procedure TPyConfig314.Set_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.exec_prefix, aValue);
end;

procedure TPyConfig314.Set_executable(const aValue: string);
begin
  SetWCharT(FConfig.executable, aValue);
end;

procedure TPyConfig314.Set_faulthandler(aValue: integer);
begin
  FConfig.faulthandler := aValue;
end;

procedure TPyConfig314.Set_filesystem_encoding(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_encoding, aValue);
end;

procedure TPyConfig314.Set_filesystem_errors(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_errors, aValue);
end;

procedure TPyConfig314.Set_hash_seed(aValue: uint64);
begin
  FConfig.hash_seed := aValue;
end;

procedure TPyConfig314.Set_home(const aValue: string);
begin
  SetWCharT(FConfig.home, aValue);
end;

procedure TPyConfig314.Set_import_time(aValue: integer);
begin
  FConfig.import_time := aValue;
end;

procedure TPyConfig314.Set_inspect(aValue: boolean);
begin
  FConfig.inspect := ord(aValue);
end;

procedure TPyConfig314.Set_install_signal_handlers(aValue: boolean);
begin
  FConfig.install_signal_handlers := ord(aValue);
end;

procedure TPyConfig314.Set_int_max_str_digits(aValue: integer);
begin
  FConfig.int_max_str_digits := aValue;
end;

procedure TPyConfig314.Set_interactive(aValue: boolean);
begin
  FConfig.interactive := ord(aValue);
end;

procedure TPyConfig314.Set_isolated(aValue: boolean);
begin
  FConfig.isolated := ord(aValue);
end;

{$IFDEF MSWINDOWS}
procedure TPyConfig314.Set_legacy_windows_stdio(aValue: boolean);
begin
  FConfig.legacy_windows_stdio := ord(aValue);
end;
{$ENDIF}

procedure TPyConfig314.Set_malloc_stats(aValue: boolean);
begin
  FConfig.malloc_stats := ord(aValue);
end;

procedure TPyConfig314.Set_module_search_paths(const aValue: string);
var
  TempPaths : TStringDynArray;
begin
  if (length(aValue) > 0) then
    begin
      TempPaths := CustomSplitString(aValue, PathSep);
      SetWideStringList(FConfig.module_search_paths, TempPaths);
    end;
end;

procedure TPyConfig314.Set_module_search_paths_set(aValue: boolean);
begin
  FConfig.module_search_paths_set := ord(aValue);
end;

procedure TPyConfig314.Set_optimization_level(aValue: TPyOptimizationLevel);
begin
  FConfig.optimization_level := integer(aValue);
end;

procedure TPyConfig314.Set_orig_argv(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.orig_argv, aValue);
end;

procedure TPyConfig314.Set_parse_argv(aValue: boolean);
begin
  FConfig.parse_argv := ord(aValue);
end;

procedure TPyConfig314.Set_parser_debug(aValue: boolean);
begin
  FConfig.parser_debug := ord(aValue);
end;

procedure TPyConfig314.Set_pathconfig_warnings(aValue: boolean);
begin
  FConfig.pathconfig_warnings := ord(aValue);
end;

procedure TPyConfig314.Set_perf_profiling(aValue: integer);
begin
  FConfig.perf_profiling := aValue;
end;

procedure TPyConfig314.Set_platlibdir(const aValue: string);
begin
  SetWCharT(FConfig.platlibdir, aValue);
end;

procedure TPyConfig314.Set_prefix(const aValue: string);
begin
  SetWCharT(FConfig.prefix, aValue);
end;

procedure TPyConfig314.Set_program_name(const aValue: string);
begin
  SetWCharT(FConfig.program_name, aValue);
end;

procedure TPyConfig314.Set_pycache_prefix(const aValue: string);
begin
  SetWCharT(FConfig.pycache_prefix, aValue);
end;

procedure TPyConfig314.Set_pythonpath_env(const aValue: string);
begin
  SetWCharT(FConfig.pythonpath_env, aValue);
end;

procedure TPyConfig314.Set_quiet(aValue: boolean);
begin
  FConfig.quiet := ord(aValue);
end;

procedure TPyConfig314.Set_remote_debug(aValue: boolean);
begin
  FConfig.remote_debug := ord(aValue);
end;

procedure TPyConfig314.Set_run_command(const aValue: string);
begin
  SetWCharT(FConfig.run_command, aValue);
end;

procedure TPyConfig314.Set_run_filename(const aValue: string);
begin
  SetWCharT(FConfig.run_filename, aValue);
end;

procedure TPyConfig314.Set_run_module(const aValue: string);
begin
  SetWCharT(FConfig.run_module, aValue);
end;

procedure TPyConfig314.Set_safe_path(aValue: boolean);
begin
  FConfig.safe_path := ord(aValue);
end;

procedure TPyConfig314.Set_show_ref_count(aValue: boolean);
begin
  FConfig.show_ref_count := ord(aValue);
end;

procedure TPyConfig314.Set_site_import(aValue: boolean);
begin
  FConfig.site_import := ord(aValue);
end;

procedure TPyConfig314.Set_skip_source_first_line(aValue: boolean);
begin
  FConfig.skip_source_first_line := ord(aValue);
end;

procedure TPyConfig314.Set_stdio_encoding(const aValue: string);
begin
  SetWCharT(FConfig.stdio_encoding, aValue);
end;

procedure TPyConfig314.Set_stdio_errors(const aValue: string);
begin
  SetWCharT(FConfig.stdio_errors, aValue);
end;

procedure TPyConfig314.Set_stdlib_dir(const aValue: string);
begin
  SetWCharT(FConfig.stdlib_dir, aValue);
end;

procedure TPyConfig314.Set_sys_path_0(const aValue: string);
begin
  SetWCharT(FConfig.sys_path_0, aValue);
end;

procedure TPyConfig314.Set_thread_inherit_context(aValue: boolean);
begin
  FConfig.thread_inherit_context := ord(aValue);
end;

procedure TPyConfig314.Set_tracemalloc(aValue: boolean);
begin
  if aValue then
    FConfig.tracemalloc := -1
   else
    FConfig.tracemalloc := 0;
end;

procedure TPyConfig314.Set_use_environment(aValue: boolean);
begin
  FConfig.use_environment := ord(aValue);
end;

procedure TPyConfig314.Set_use_frozen_modules(aValue: boolean);
begin
  FConfig.use_frozen_modules := ord(aValue);
end;

procedure TPyConfig314.Set_use_hash_seed(aValue: boolean);
begin
  if aValue then
    FConfig.use_hash_seed := -1
   else
    FConfig.use_hash_seed := 0;
end;

procedure TPyConfig314.Set_user_site_directory(aValue: boolean);
begin
  FConfig.user_site_directory := ord(aValue);
end;

procedure TPyConfig314.Set_verbose(aValue: TPyVerboseMode);
begin
  FConfig.verbose := integer(aValue);
end;

procedure TPyConfig314.Set_warn_default_encoding(aValue: boolean);
begin
  FConfig.warn_default_encoding := ord(aValue);
end;

procedure TPyConfig314.Set_warnoptions(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.warnoptions, aValue);
end;

procedure TPyConfig314.Set_write_bytecode(aValue: boolean);
begin
  FConfig.write_bytecode := ord(aValue);
end;

procedure TPyConfig314.Set_xoptions(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.xoptions, aValue);
end;

function TPyConfig313.GetConfig: Pointer;
begin
  Result := @FConfig;
end;

function TPyConfig313.Get_argv: TStringDynArray;
begin                            
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.argv, Result);
end;

function TPyConfig313.Get_base_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_exec_prefix));
end;

function TPyConfig313.Get_base_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_executable));
end;

function TPyConfig313.Get_base_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_prefix));
end;

function TPyConfig313.Get_buffered_stdio: boolean;
begin
  Result := (FConfig.buffered_stdio <> 0);
end;

function TPyConfig313.Get_bytes_warning: integer;
begin
  Result := FConfig.bytes_warning;
end;

function TPyConfig313.Get_check_hash_pycs_mode: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.check_hash_pycs_mode));
end;

function TPyConfig313.Get_code_debug_ranges: boolean;
begin
  Result := (FConfig.code_debug_ranges <> 0);
end;

function TPyConfig313.Get_configure_c_stdio: boolean;
begin
  Result := (FConfig.configure_c_stdio <> 0);
end;

function TPyConfig313.Get_cpu_count: integer;
begin
  Result := FConfig.cpu_count;
end;

function TPyConfig313.Get_dev_mode: boolean;
begin
  Result := (FConfig.dev_mode <> 0);
end;

function TPyConfig313.Get_dump_refs: boolean;
begin
  Result := (FConfig.dump_refs <> 0);
end;

function TPyConfig313.Get_dump_refs_file: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.dump_refs_file));
end;

function TPyConfig313.Get_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.exec_prefix));
end;

function TPyConfig313.Get_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.executable));
end;

function TPyConfig313.Get_faulthandler: integer;
begin
  Result := FConfig.faulthandler;
end;

function TPyConfig313.Get_filesystem_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_encoding));
end;

function TPyConfig313.Get_filesystem_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_errors));
end;

function TPyConfig313.Get_hash_seed: uint64;
begin
  Result := FConfig.hash_seed;
end;

function TPyConfig313.Get_home: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.home));
end;

function TPyConfig313.Get_import_time: integer;
begin
  Result := FConfig.import_time;
end;

function TPyConfig313.Get_inspect: boolean;
begin
  Result := (FConfig.inspect <> 0);
end;

function TPyConfig313.Get_install_signal_handlers: boolean;
begin
  Result := (FConfig.install_signal_handlers <> 0);
end;

function TPyConfig313.Get_int_max_str_digits: integer;
begin
  Result := FConfig.int_max_str_digits;
end;

function TPyConfig313.Get_interactive: boolean;
begin
  Result := (FConfig.interactive <> 0);
end;

function TPyConfig313.Get_isolated: boolean;
begin
  Result := (FConfig.isolated <> 0);
end;

{$IFDEF MSWINDOWS}
function TPyConfig313.Get_legacy_windows_stdio: boolean;
begin
  Result := (FConfig.legacy_windows_stdio <> 0);
end;
{$ENDIF}

function TPyConfig313.Get_malloc_stats: boolean;
begin
  Result := (FConfig.malloc_stats <> 0);
end;

function TPyConfig313.Get_module_search_paths: string;
var
  TempSL : TStringList;
  i      : integer;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.module_search_paths, TempSL) then
    begin
      i := 0;
      while (i < TempSL.Count) do
        begin
          if (i = 0) then
            Result := TempSL[i]
           else
            Result := Result + PathSep + TempSL[i];

          inc(i);
        end;
    end
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig313.Get_module_search_paths_set: boolean;
begin
  Result := (FConfig.module_search_paths_set <> 0);
end;

function TPyConfig313.Get_optimization_level: TPyOptimizationLevel;
begin
  Result := TPyOptimizationLevel(FConfig.optimization_level);
end;

function TPyConfig313.Get_orig_argv: TStringDynArray;
begin                           
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.orig_argv, Result);
end;

function TPyConfig313.Get_parse_argv: boolean;
begin
  Result := (FConfig.parse_argv <> 0);
end;

function TPyConfig313.Get_parser_debug: boolean;
begin
  Result := (FConfig.parser_debug <> 0);
end;

function TPyConfig313.Get_pathconfig_warnings: boolean;
begin
  Result := (FConfig.pathconfig_warnings <> 0);
end;

function TPyConfig313.Get_perf_profiling: integer;
begin
  Result := FConfig.perf_profiling;
end;

function TPyConfig313.Get_platlibdir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.platlibdir));
end;

function TPyConfig313.Get_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.prefix));
end;

function TPyConfig313.Get_program_name: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.program_name));
end;

function TPyConfig313.Get_pycache_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pycache_prefix));
end;

function TPyConfig313.Get_pythonpath_env: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pythonpath_env));
end;

function TPyConfig313.Get_quiet: boolean;
begin
  Result := (FConfig.quiet <> 0);
end;

function TPyConfig313.Get_run_command: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_command));
end;

function TPyConfig313.Get_run_filename: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_filename));
end;

function TPyConfig313.Get_run_module: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_module));
end;

function TPyConfig313.Get_safe_path: boolean;
begin
  Result := (FConfig.safe_path <> 0);
end;

function TPyConfig313.Get_show_ref_count: boolean;
begin
  Result := (FConfig.show_ref_count <> 0);
end;

function TPyConfig313.Get_site_import: boolean;
begin
  Result := (FConfig.site_import <> 0);
end;

function TPyConfig313.Get_skip_source_first_line: boolean;
begin
  Result := (FConfig.skip_source_first_line <> 0);
end;

function TPyConfig313.Get_stdio_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_encoding));
end;

function TPyConfig313.Get_stdio_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_errors));
end;

function TPyConfig313.Get_stdlib_dir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdlib_dir));
end;

function TPyConfig313.Get_sys_path_0: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.sys_path_0));
end;

function TPyConfig313.Get_tracemalloc: boolean;
begin
  Result := (FConfig.tracemalloc <> 0);
end;

function TPyConfig313.Get_use_environment: boolean;
begin
  Result := (FConfig.use_environment <> 0);
end;

function TPyConfig313.Get_use_frozen_modules: boolean;
begin
  Result := (FConfig.use_frozen_modules <> 0);
end;

function TPyConfig313.Get_use_hash_seed: boolean;
begin
  Result := (FConfig.use_hash_seed <> 0);
end;

function TPyConfig313.Get_user_site_directory: boolean;
begin
  Result := (FConfig.user_site_directory <> 0);
end;

function TPyConfig313.Get_verbose: TPyVerboseMode;
begin
  Result := TPyVerboseMode(FConfig.verbose);
end;

function TPyConfig313.Get_warn_default_encoding: boolean;
begin
  Result := (FConfig.warn_default_encoding <> 0);
end;

function TPyConfig313.Get_warnoptions: TStringDynArray;
begin                       
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.warnoptions, Result);
end;

function TPyConfig313.Get_write_bytecode: boolean;
begin
  Result := (FConfig.write_bytecode <> 0);
end;

function TPyConfig313.Get_xoptions: TStringDynArray;
begin                           
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.xoptions, Result);
end;

procedure TPyConfig313.Set_argv(const aValue: TStringDynArray);
begin
  SetArgv(aValue);
end;

procedure TPyConfig313.Set_base_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_exec_prefix, aValue);
end;

procedure TPyConfig313.Set_base_executable(const aValue: string);
begin
  SetWCharT(FConfig.base_executable, aValue);
end;

procedure TPyConfig313.Set_base_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_prefix, aValue);
end;

procedure TPyConfig313.Set_buffered_stdio(aValue: boolean);
begin
  FConfig.buffered_stdio := ord(aValue);
end;

procedure TPyConfig313.Set_bytes_warning(aValue: integer);
begin
  FConfig.bytes_warning := aValue;
end;

procedure TPyConfig313.Set_check_hash_pycs_mode(const aValue: string);
begin
  SetWCharT(FConfig.check_hash_pycs_mode, aValue);
end;

procedure TPyConfig313.Set_code_debug_ranges(aValue: boolean);
begin
  FConfig.code_debug_ranges := ord(aValue);
end;

procedure TPyConfig313.Set_configure_c_stdio(aValue: boolean);
begin
  FConfig.configure_c_stdio := ord(aValue);
end;

procedure TPyConfig313.Set_cpu_count(aValue: integer);
begin
  FConfig.cpu_count := aValue;
end;

procedure TPyConfig313.Set_dev_mode(aValue: boolean);
begin
  if aValue then
    FConfig.dev_mode := -1
   else
    FConfig.dev_mode := 0;
end;

procedure TPyConfig313.Set_dump_refs(aValue: boolean);
begin
  FConfig.dump_refs := ord(aValue);
end;

procedure TPyConfig313.Set_dump_refs_file(const aValue: string);
begin
  SetWCharT(FConfig.dump_refs_file, aValue);
end;

procedure TPyConfig313.Set_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.exec_prefix, aValue);
end;

procedure TPyConfig313.Set_executable(const aValue: string);
begin
  SetWCharT(FConfig.executable, aValue);
end;

procedure TPyConfig313.Set_faulthandler(aValue: integer);
begin
  FConfig.faulthandler := aValue;
end;

procedure TPyConfig313.Set_filesystem_encoding(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_encoding, aValue);
end;

procedure TPyConfig313.Set_filesystem_errors(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_errors, aValue);
end;

procedure TPyConfig313.Set_hash_seed(aValue: uint64);
begin
  FConfig.hash_seed := aValue;
end;

procedure TPyConfig313.Set_home(const aValue: string);
begin
  SetWCharT(FConfig.home, aValue);
end;

procedure TPyConfig313.Set_import_time(aValue: integer);
begin
  FConfig.import_time := aValue;
end;

procedure TPyConfig313.Set_inspect(aValue: boolean);
begin
  FConfig.inspect := ord(aValue);
end;

procedure TPyConfig313.Set_install_signal_handlers(aValue: boolean);
begin
  FConfig.install_signal_handlers := ord(aValue);
end;

procedure TPyConfig313.Set_int_max_str_digits(aValue: integer);
begin
  FConfig.int_max_str_digits := aValue;
end;

procedure TPyConfig313.Set_interactive(aValue: boolean);
begin
  FConfig.interactive := ord(aValue);
end;

procedure TPyConfig313.Set_isolated(aValue: boolean);
begin
  FConfig.isolated := ord(aValue);
end;

{$IFDEF MSWINDOWS}
procedure TPyConfig313.Set_legacy_windows_stdio(aValue: boolean);
begin
  FConfig.legacy_windows_stdio := ord(aValue);
end;
{$ENDIF}

procedure TPyConfig313.Set_malloc_stats(aValue: boolean);
begin
  FConfig.malloc_stats := ord(aValue);
end;

procedure TPyConfig313.Set_module_search_paths(const aValue: string);
var
  TempPaths : TStringDynArray;
begin
  if (length(aValue) > 0) then
    begin
      TempPaths := CustomSplitString(aValue, PathSep);
      SetWideStringList(FConfig.module_search_paths, TempPaths);
    end;
end;

procedure TPyConfig313.Set_module_search_paths_set(aValue: boolean);
begin
  FConfig.module_search_paths_set := ord(aValue);
end;

procedure TPyConfig313.Set_optimization_level(aValue: TPyOptimizationLevel);
begin
  FConfig.optimization_level := integer(aValue);
end;

procedure TPyConfig313.Set_orig_argv(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.orig_argv, aValue);
end;

procedure TPyConfig313.Set_parse_argv(aValue: boolean);
begin
  FConfig.parse_argv := ord(aValue);
end;

procedure TPyConfig313.Set_parser_debug(aValue: boolean);
begin
  FConfig.parser_debug := ord(aValue);
end;

procedure TPyConfig313.Set_pathconfig_warnings(aValue: boolean);
begin
  FConfig.pathconfig_warnings := ord(aValue);
end;

procedure TPyConfig313.Set_perf_profiling(aValue: integer);
begin
  FConfig.perf_profiling := aValue;
end;

procedure TPyConfig313.Set_platlibdir(const aValue: string);
begin
  SetWCharT(FConfig.platlibdir, aValue);
end;

procedure TPyConfig313.Set_prefix(const aValue: string);
begin
  SetWCharT(FConfig.prefix, aValue);
end;

procedure TPyConfig313.Set_program_name(const aValue: string);
begin
  SetWCharT(FConfig.program_name, aValue);
end;

procedure TPyConfig313.Set_pycache_prefix(const aValue: string);
begin
  SetWCharT(FConfig.pycache_prefix, aValue);
end;

procedure TPyConfig313.Set_pythonpath_env(const aValue: string);
begin
  SetWCharT(FConfig.pythonpath_env, aValue);
end;

procedure TPyConfig313.Set_quiet(aValue: boolean);
begin
  FConfig.quiet := ord(aValue);
end;

procedure TPyConfig313.Set_run_command(const aValue: string);
begin
  SetWCharT(FConfig.run_command, aValue);
end;

procedure TPyConfig313.Set_run_filename(const aValue: string);
begin
  SetWCharT(FConfig.run_filename, aValue);
end;

procedure TPyConfig313.Set_run_module(const aValue: string);
begin
  SetWCharT(FConfig.run_module, aValue);
end;

procedure TPyConfig313.Set_safe_path(aValue: boolean);
begin
  FConfig.safe_path := ord(aValue);
end;

procedure TPyConfig313.Set_show_ref_count(aValue: boolean);
begin
  FConfig.show_ref_count := ord(aValue);
end;

procedure TPyConfig313.Set_site_import(aValue: boolean);
begin
  FConfig.site_import := ord(aValue);
end;

procedure TPyConfig313.Set_skip_source_first_line(aValue: boolean);
begin
  FConfig.skip_source_first_line := ord(aValue);
end;

procedure TPyConfig313.Set_stdio_encoding(const aValue: string);
begin
  SetWCharT(FConfig.stdio_encoding, aValue);
end;

procedure TPyConfig313.Set_stdio_errors(const aValue: string);
begin
  SetWCharT(FConfig.stdio_errors, aValue);
end;

procedure TPyConfig313.Set_stdlib_dir(const aValue: string);
begin
  SetWCharT(FConfig.stdlib_dir, aValue);
end;

procedure TPyConfig313.Set_sys_path_0(const aValue: string);
begin
  SetWCharT(FConfig.sys_path_0, aValue);
end;

procedure TPyConfig313.Set_tracemalloc(aValue: boolean);
begin
  if aValue then
    FConfig.tracemalloc := -1
   else
    FConfig.tracemalloc := 0;
end;

procedure TPyConfig313.Set_use_environment(aValue: boolean);
begin
  FConfig.use_environment := ord(aValue);
end;

procedure TPyConfig313.Set_use_frozen_modules(aValue: boolean);
begin
  FConfig.use_frozen_modules := ord(aValue);
end;

procedure TPyConfig313.Set_use_hash_seed(aValue: boolean);
begin
  if aValue then
    FConfig.use_hash_seed := -1
   else
    FConfig.use_hash_seed := 0;
end;

procedure TPyConfig313.Set_user_site_directory(aValue: boolean);
begin
  FConfig.user_site_directory := ord(aValue);
end;

procedure TPyConfig313.Set_verbose(aValue: TPyVerboseMode);
begin
  FConfig.verbose := integer(aValue);
end;

procedure TPyConfig313.Set_warn_default_encoding(aValue: boolean);
begin
  FConfig.warn_default_encoding := ord(aValue);
end;

procedure TPyConfig313.Set_warnoptions(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.warnoptions, aValue);
end;

procedure TPyConfig313.Set_write_bytecode(aValue: boolean);
begin
  FConfig.write_bytecode := ord(aValue);
end;

procedure TPyConfig313.Set_xoptions(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.xoptions, aValue);
end;

function TPyConfig312.GetConfig: Pointer;
begin
  Result := @FConfig;
end;

function TPyConfig312.Get_argv: TStringDynArray;
begin                                    
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.argv, Result);
end;

function TPyConfig312.Get_base_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_exec_prefix));
end;

function TPyConfig312.Get_base_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_executable));
end;

function TPyConfig312.Get_base_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_prefix));
end;

function TPyConfig312.Get_buffered_stdio: boolean;
begin
  Result := (FConfig.buffered_stdio <> 0);
end;

function TPyConfig312.Get_bytes_warning: integer;
begin
  Result := FConfig.bytes_warning;
end;

function TPyConfig312.Get_check_hash_pycs_mode: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.check_hash_pycs_mode));
end;

function TPyConfig312.Get_code_debug_ranges: boolean;
begin
  Result := (FConfig.code_debug_ranges <> 0);
end;

function TPyConfig312.Get_configure_c_stdio: boolean;
begin
  Result := (FConfig.configure_c_stdio <> 0);
end;

function TPyConfig312.Get_dev_mode: boolean;
begin
  Result := (FConfig.dev_mode <> 0);
end;

function TPyConfig312.Get_dump_refs: boolean;
begin
  Result := (FConfig.dump_refs <> 0);
end;

function TPyConfig312.Get_dump_refs_file: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.dump_refs_file));
end;

function TPyConfig312.Get_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.exec_prefix));
end;

function TPyConfig312.Get_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.executable));
end;

function TPyConfig312.Get_faulthandler: integer;
begin
  Result := FConfig.faulthandler;
end;

function TPyConfig312.Get_filesystem_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_encoding));
end;

function TPyConfig312.Get_filesystem_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_errors));
end;

function TPyConfig312.Get_hash_seed: uint64;
begin
  Result := FConfig.hash_seed;
end;

function TPyConfig312.Get_home: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.home));
end;

function TPyConfig312.Get_import_time: integer;
begin
  Result := FConfig.import_time;
end;

function TPyConfig312.Get_inspect: boolean;
begin
  Result := (FConfig.inspect <> 0);
end;

function TPyConfig312.Get_install_signal_handlers: boolean;
begin
  Result := (FConfig.install_signal_handlers <> 0);
end;

function TPyConfig312.Get_int_max_str_digits: integer;
begin
  Result := FConfig.int_max_str_digits;
end;

function TPyConfig312.Get_interactive: boolean;
begin
  Result := (FConfig.interactive <> 0);
end;

function TPyConfig312.Get_isolated: boolean;
begin
  Result := (FConfig.isolated <> 0);
end;

{$IFDEF MSWINDOWS}
function TPyConfig312.Get_legacy_windows_stdio: boolean;
begin
  Result := (FConfig.legacy_windows_stdio <> 0);
end;
{$ENDIF}

function TPyConfig312.Get_malloc_stats: boolean;
begin
  Result := (FConfig.malloc_stats <> 0);
end;

function TPyConfig312.Get_module_search_paths: string;
var
  TempSL : TStringList;
  i      : integer;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.module_search_paths, TempSL) then
    begin
      i := 0;
      while (i < TempSL.Count) do
        begin
          if (i = 0) then
            Result := TempSL[i]
           else
            Result := Result + PathSep + TempSL[i];

          inc(i);
        end;
    end
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig312.Get_module_search_paths_set: boolean;
begin
  Result := (FConfig.module_search_paths_set <> 0);
end;

function TPyConfig312.Get_optimization_level: TPyOptimizationLevel;
begin
  Result := TPyOptimizationLevel(FConfig.optimization_level);
end;

function TPyConfig312.Get_orig_argv: TStringDynArray;
begin                           
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.orig_argv, Result);
end;

function TPyConfig312.Get_parse_argv: boolean;
begin
  Result := (FConfig.parse_argv <> 0);
end;

function TPyConfig312.Get_parser_debug: boolean;
begin
  Result := (FConfig.parser_debug <> 0);
end;

function TPyConfig312.Get_pathconfig_warnings: boolean;
begin
  Result := (FConfig.pathconfig_warnings <> 0);
end;

function TPyConfig312.Get_perf_profiling: integer;
begin
  Result := FConfig.perf_profiling;
end;

function TPyConfig312.Get_platlibdir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.platlibdir));
end;

function TPyConfig312.Get_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.prefix));
end;

function TPyConfig312.Get_program_name: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.program_name));
end;

function TPyConfig312.Get_pycache_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pycache_prefix));
end;

function TPyConfig312.Get_pythonpath_env: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pythonpath_env));
end;

function TPyConfig312.Get_quiet: boolean;
begin
  Result := (FConfig.quiet <> 0);
end;

function TPyConfig312.Get_run_command: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_command));
end;

function TPyConfig312.Get_run_filename: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_filename));
end;

function TPyConfig312.Get_run_module: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_module));
end;

function TPyConfig312.Get_safe_path: boolean;
begin
  Result := (FConfig.safe_path <> 0);
end;

function TPyConfig312.Get_show_ref_count: boolean;
begin
  Result := (FConfig.show_ref_count <> 0);
end;

function TPyConfig312.Get_site_import: boolean;
begin
  Result := (FConfig.site_import <> 0);
end;

function TPyConfig312.Get_skip_source_first_line: boolean;
begin
  Result := (FConfig.skip_source_first_line <> 0);
end;

function TPyConfig312.Get_stdio_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_encoding));
end;

function TPyConfig312.Get_stdio_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_errors));
end;

function TPyConfig312.Get_stdlib_dir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdlib_dir));
end;

function TPyConfig312.Get_tracemalloc: boolean;
begin
  Result := (FConfig.tracemalloc <> 0);
end;

function TPyConfig312.Get_use_environment: boolean;
begin
  Result := (FConfig.use_environment <> 0);
end;

function TPyConfig312.Get_use_frozen_modules: boolean;
begin
  Result := (FConfig.use_frozen_modules <> 0);
end;

function TPyConfig312.Get_use_hash_seed: boolean;
begin
  Result := (FConfig.use_hash_seed <> 0);
end;

function TPyConfig312.Get_user_site_directory: boolean;
begin
  Result := (FConfig.user_site_directory <> 0);
end;

function TPyConfig312.Get_verbose: TPyVerboseMode;
begin
  Result := TPyVerboseMode(FConfig.verbose);
end;

function TPyConfig312.Get_warn_default_encoding: boolean;
begin
  Result := (FConfig.warn_default_encoding <> 0);
end;

function TPyConfig312.Get_warnoptions: TStringDynArray;
begin                              
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.warnoptions, Result);
end;

function TPyConfig312.Get_write_bytecode: boolean;
begin
  Result := (FConfig.write_bytecode <> 0);
end;

function TPyConfig312.Get_xoptions: TStringDynArray;
begin                          
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.xoptions, Result);
end;

procedure TPyConfig312.Set_argv(const aValue: TStringDynArray);
begin
  SetArgv(aValue);
end;

procedure TPyConfig312.Set_base_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_exec_prefix, aValue);
end;

procedure TPyConfig312.Set_base_executable(const aValue: string);
begin
  SetWCharT(FConfig.base_executable, aValue);
end;

procedure TPyConfig312.Set_base_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_prefix, aValue);
end;

procedure TPyConfig312.Set_buffered_stdio(aValue: boolean);
begin
  FConfig.buffered_stdio := ord(aValue);
end;

procedure TPyConfig312.Set_bytes_warning(aValue: integer);
begin
  FConfig.bytes_warning := aValue;
end;

procedure TPyConfig312.Set_check_hash_pycs_mode(const aValue: string);
begin
  SetWCharT(FConfig.check_hash_pycs_mode, aValue);
end;

procedure TPyConfig312.Set_code_debug_ranges(aValue: boolean);
begin
  FConfig.code_debug_ranges := ord(aValue);
end;

procedure TPyConfig312.Set_configure_c_stdio(aValue: boolean);
begin
  FConfig.configure_c_stdio := ord(aValue);
end;

procedure TPyConfig312.Set_dev_mode(aValue: boolean);
begin
  if aValue then
    FConfig.dev_mode := -1
   else
    FConfig.dev_mode := 0;
end;

procedure TPyConfig312.Set_dump_refs(aValue: boolean);
begin
  FConfig.dump_refs := ord(aValue);
end;

procedure TPyConfig312.Set_dump_refs_file(const aValue: string);
begin
  SetWCharT(FConfig.dump_refs_file, aValue);
end;

procedure TPyConfig312.Set_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.exec_prefix, aValue);
end;

procedure TPyConfig312.Set_executable(const aValue: string);
begin
  SetWCharT(FConfig.executable, aValue);
end;

procedure TPyConfig312.Set_faulthandler(aValue: integer);
begin
  FConfig.faulthandler := aValue;
end;

procedure TPyConfig312.Set_filesystem_encoding(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_encoding, aValue);
end;

procedure TPyConfig312.Set_filesystem_errors(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_errors, aValue);
end;

procedure TPyConfig312.Set_hash_seed(aValue: uint64);
begin
  FConfig.hash_seed := aValue;
end;

procedure TPyConfig312.Set_home(const aValue: string);
begin
  SetWCharT(FConfig.home, aValue);
end;

procedure TPyConfig312.Set_import_time(aValue: integer);
begin
  FConfig.import_time := aValue;
end;

procedure TPyConfig312.Set_inspect(aValue: boolean);
begin
  FConfig.inspect := ord(aValue);
end;

procedure TPyConfig312.Set_install_signal_handlers(aValue: boolean);
begin
  FConfig.install_signal_handlers := ord(aValue);
end;

procedure TPyConfig312.Set_int_max_str_digits(aValue: integer);
begin
  FConfig.int_max_str_digits := aValue;
end;

procedure TPyConfig312.Set_interactive(aValue: boolean);
begin
  FConfig.interactive := ord(aValue);
end;

procedure TPyConfig312.Set_isolated(aValue: boolean);
begin
  FConfig.isolated := ord(aValue);
end;

{$IFDEF MSWINDOWS}
procedure TPyConfig312.Set_legacy_windows_stdio(aValue: boolean);
begin
  FConfig.legacy_windows_stdio := ord(aValue);
end;
{$ENDIF}

procedure TPyConfig312.Set_malloc_stats(aValue: boolean);
begin
  FConfig.malloc_stats := ord(aValue);
end;

procedure TPyConfig312.Set_module_search_paths(const aValue: string);
var
  TempPaths : TStringDynArray;
begin
  if (length(aValue) > 0) then
    begin
      TempPaths := CustomSplitString(aValue, PathSep);
      SetWideStringList(FConfig.module_search_paths, TempPaths);
    end;
end;

procedure TPyConfig312.Set_module_search_paths_set(aValue: boolean);
begin
  FConfig.module_search_paths_set := ord(aValue);
end;

procedure TPyConfig312.Set_optimization_level(aValue: TPyOptimizationLevel);
begin
  FConfig.optimization_level := integer(aValue);
end;

procedure TPyConfig312.Set_orig_argv(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.orig_argv, aValue);
end;

procedure TPyConfig312.Set_parse_argv(aValue: boolean);
begin
  FConfig.parse_argv := ord(aValue);
end;

procedure TPyConfig312.Set_parser_debug(aValue: boolean);
begin
  FConfig.parser_debug := ord(aValue);
end;

procedure TPyConfig312.Set_pathconfig_warnings(aValue: boolean);
begin
  FConfig.pathconfig_warnings := ord(aValue);
end;

procedure TPyConfig312.Set_perf_profiling(aValue: integer);
begin
  FConfig.perf_profiling := aValue;
end;

procedure TPyConfig312.Set_platlibdir(const aValue: string);
begin
  SetWCharT(FConfig.platlibdir, aValue);
end;

procedure TPyConfig312.Set_prefix(const aValue: string);
begin
  SetWCharT(FConfig.prefix, aValue);
end;

procedure TPyConfig312.Set_program_name(const aValue: string);
begin
  SetWCharT(FConfig.program_name, aValue);
end;

procedure TPyConfig312.Set_pycache_prefix(const aValue: string);
begin
  SetWCharT(FConfig.pycache_prefix, aValue);
end;

procedure TPyConfig312.Set_pythonpath_env(const aValue: string);
begin
  SetWCharT(FConfig.pythonpath_env, aValue);
end;

procedure TPyConfig312.Set_quiet(aValue: boolean);
begin
  FConfig.quiet := ord(aValue);
end;

procedure TPyConfig312.Set_run_command(const aValue: string);
begin
  SetWCharT(FConfig.run_command, aValue);
end;

procedure TPyConfig312.Set_run_filename(const aValue: string);
begin
  SetWCharT(FConfig.run_filename, aValue);
end;

procedure TPyConfig312.Set_run_module(const aValue: string);
begin
  SetWCharT(FConfig.run_module, aValue);
end;

procedure TPyConfig312.Set_safe_path(aValue: boolean);
begin
  FConfig.safe_path := ord(aValue);
end;

procedure TPyConfig312.Set_show_ref_count(aValue: boolean);
begin
  FConfig.show_ref_count := ord(aValue);
end;

procedure TPyConfig312.Set_site_import(aValue: boolean);
begin
  FConfig.site_import := ord(aValue);
end;

procedure TPyConfig312.Set_skip_source_first_line(aValue: boolean);
begin
  FConfig.skip_source_first_line := ord(aValue);
end;

procedure TPyConfig312.Set_stdio_encoding(const aValue: string);
begin
  SetWCharT(FConfig.stdio_encoding, aValue);
end;

procedure TPyConfig312.Set_stdio_errors(const aValue: string);
begin
  SetWCharT(FConfig.stdio_errors, aValue);
end;

procedure TPyConfig312.Set_stdlib_dir(const aValue: string);
begin
  SetWCharT(FConfig.stdlib_dir, aValue);
end;

procedure TPyConfig312.Set_tracemalloc(aValue: boolean);
begin
  if aValue then
    FConfig.tracemalloc := -1
   else
    FConfig.tracemalloc := 0;
end;

procedure TPyConfig312.Set_use_environment(aValue: boolean);
begin
  FConfig.use_environment := ord(aValue);
end;

procedure TPyConfig312.Set_use_frozen_modules(aValue: boolean);
begin
  FConfig.use_frozen_modules := ord(aValue);
end;

procedure TPyConfig312.Set_use_hash_seed(aValue: boolean);
begin
  if aValue then
    FConfig.use_hash_seed := -1
   else
    FConfig.use_hash_seed := 0;
end;

procedure TPyConfig312.Set_user_site_directory(aValue: boolean);
begin
  FConfig.user_site_directory := ord(aValue);
end;

procedure TPyConfig312.Set_verbose(aValue: TPyVerboseMode);
begin
  FConfig.verbose := integer(aValue);
end;

procedure TPyConfig312.Set_warn_default_encoding(aValue: boolean);
begin
  FConfig.warn_default_encoding := ord(aValue);
end;

procedure TPyConfig312.Set_warnoptions(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.warnoptions, aValue);
end;

procedure TPyConfig312.Set_write_bytecode(aValue: boolean);
begin
  FConfig.write_bytecode := ord(aValue);
end;

procedure TPyConfig312.Set_xoptions(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.xoptions, aValue);
end;

function TPyConfig311.GetConfig: Pointer;
begin
  Result := @FConfig;
end;

function TPyConfig311.Get_argv: TStringDynArray;
begin                    
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.argv, Result);
end;

function TPyConfig311.Get_base_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_exec_prefix));
end;

function TPyConfig311.Get_base_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_executable));
end;

function TPyConfig311.Get_base_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_prefix));
end;

function TPyConfig311.Get_buffered_stdio: boolean;
begin
  Result := (FConfig.buffered_stdio <> 0);
end;

function TPyConfig311.Get_bytes_warning: integer;
begin
  Result := FConfig.bytes_warning;
end;

function TPyConfig311.Get_check_hash_pycs_mode: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.check_hash_pycs_mode));
end;

function TPyConfig311.Get_code_debug_ranges: boolean;
begin
  Result := (FConfig.code_debug_ranges <> 0);
end;

function TPyConfig311.Get_configure_c_stdio: boolean;
begin
  Result := (FConfig.configure_c_stdio <> 0);
end;

function TPyConfig311.Get_dev_mode: boolean;
begin
  Result := (FConfig.dev_mode <> 0);
end;

function TPyConfig311.Get_dump_refs: boolean;
begin
  Result := (FConfig.dump_refs <> 0);
end;

function TPyConfig311.Get_dump_refs_file: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.dump_refs_file));
end;

function TPyConfig311.Get_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.exec_prefix));
end;

function TPyConfig311.Get_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.executable));
end;

function TPyConfig311.Get_faulthandler: integer;
begin
  Result := FConfig.faulthandler;
end;

function TPyConfig311.Get_filesystem_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_encoding));
end;

function TPyConfig311.Get_filesystem_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_errors));
end;

function TPyConfig311.Get_hash_seed: uint64;
begin
  Result := FConfig.hash_seed;
end;

function TPyConfig311.Get_home: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.home));
end;

function TPyConfig311.Get_import_time: integer;
begin
  Result := FConfig.import_time;
end;

function TPyConfig311.Get_inspect: boolean;
begin
  Result := (FConfig.inspect <> 0);
end;

function TPyConfig311.Get_install_signal_handlers: boolean;
begin
  Result := (FConfig.install_signal_handlers <> 0);
end;

function TPyConfig311.Get_interactive: boolean;
begin
  Result := (FConfig.interactive <> 0);
end;

function TPyConfig311.Get_isolated: boolean;
begin
  Result := (FConfig.isolated <> 0);
end;

{$IFDEF MSWINDOWS}
function TPyConfig311.Get_legacy_windows_stdio: boolean;
begin
  Result := (FConfig.legacy_windows_stdio <> 0);
end;
{$ENDIF}

function TPyConfig311.Get_malloc_stats: boolean;
begin
  Result := (FConfig.malloc_stats <> 0);
end;

function TPyConfig311.Get_module_search_paths: string;
var
  TempSL : TStringList;
  i      : integer;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.module_search_paths, TempSL) then
    begin
      i := 0;
      while (i < TempSL.Count) do
        begin
          if (i = 0) then
            Result := TempSL[i]
           else
            Result := Result + PathSep + TempSL[i];

          inc(i);
        end;
    end
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig311.Get_module_search_paths_set: boolean;
begin
  Result := (FConfig.module_search_paths_set <> 0);
end;

function TPyConfig311.Get_optimization_level: TPyOptimizationLevel;
begin
  Result := TPyOptimizationLevel(FConfig.optimization_level);
end;

function TPyConfig311.Get_orig_argv: TStringDynArray;
begin                             
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.orig_argv, Result);
end;

function TPyConfig311.Get_parse_argv: boolean;
begin
  Result := (FConfig.parse_argv <> 0);
end;

function TPyConfig311.Get_parser_debug: boolean;
begin
  Result := (FConfig.parser_debug <> 0);
end;

function TPyConfig311.Get_pathconfig_warnings: boolean;
begin
  Result := (FConfig.pathconfig_warnings <> 0);
end;

function TPyConfig311.Get_platlibdir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.platlibdir));
end;

function TPyConfig311.Get_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.prefix));
end;

function TPyConfig311.Get_program_name: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.program_name));
end;

function TPyConfig311.Get_pycache_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pycache_prefix));
end;

function TPyConfig311.Get_pythonpath_env: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pythonpath_env));
end;

function TPyConfig311.Get_quiet: boolean;
begin
  Result := (FConfig.quiet <> 0);
end;

function TPyConfig311.Get_run_command: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_command));
end;

function TPyConfig311.Get_run_filename: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_filename));
end;

function TPyConfig311.Get_run_module: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_module));
end;

function TPyConfig311.Get_safe_path: boolean;
begin
  Result := (FConfig.safe_path <> 0);
end;

function TPyConfig311.Get_show_ref_count: boolean;
begin
  Result := (FConfig.show_ref_count <> 0);
end;

function TPyConfig311.Get_site_import: boolean;
begin
  Result := (FConfig.site_import <> 0);
end;

function TPyConfig311.Get_skip_source_first_line: boolean;
begin
  Result := (FConfig.skip_source_first_line <> 0);
end;

function TPyConfig311.Get_stdio_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_encoding));
end;

function TPyConfig311.Get_stdio_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_errors));
end;

function TPyConfig311.Get_stdlib_dir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdlib_dir));
end;

function TPyConfig311.Get_tracemalloc: boolean;
begin
  Result := (FConfig.tracemalloc <> 0);
end;

function TPyConfig311.Get_use_environment: boolean;
begin
  Result := (FConfig.use_environment <> 0);
end;

function TPyConfig311.Get_use_frozen_modules: boolean;
begin
  Result := (FConfig.use_frozen_modules <> 0);
end;

function TPyConfig311.Get_use_hash_seed: boolean;
begin
  Result := (FConfig.use_hash_seed <> 0);
end;

function TPyConfig311.Get_user_site_directory: boolean;
begin
  Result := (FConfig.user_site_directory <> 0);
end;

function TPyConfig311.Get_verbose: TPyVerboseMode;
begin
  Result := TPyVerboseMode(FConfig.verbose);
end;

function TPyConfig311.Get_warn_default_encoding: boolean;
begin
  Result := (FConfig.warn_default_encoding <> 0);
end;

function TPyConfig311.Get_warnoptions: TStringDynArray;
begin                               
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.warnoptions, Result);
end;

function TPyConfig311.Get_write_bytecode: boolean;
begin
  Result := (FConfig.write_bytecode <> 0);
end;

function TPyConfig311.Get_xoptions: TStringDynArray;
begin                                     
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.xoptions, Result);
end;

procedure TPyConfig311.Set_argv(const aValue: TStringDynArray);
begin
  SetArgv(aValue);
end;

procedure TPyConfig311.Set_base_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_exec_prefix, aValue);
end;

procedure TPyConfig311.Set_base_executable(const aValue: string);
begin
  SetWCharT(FConfig.base_executable, aValue);
end;

procedure TPyConfig311.Set_base_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_prefix, aValue);
end;

procedure TPyConfig311.Set_buffered_stdio(aValue: boolean);
begin
  FConfig.buffered_stdio := ord(aValue);
end;

procedure TPyConfig311.Set_bytes_warning(aValue: integer);
begin
  FConfig.bytes_warning := aValue;
end;

procedure TPyConfig311.Set_check_hash_pycs_mode(const aValue: string);
begin
  SetWCharT(FConfig.check_hash_pycs_mode, aValue);
end;

procedure TPyConfig311.Set_code_debug_ranges(aValue: boolean);
begin
  FConfig.code_debug_ranges := ord(aValue);
end;

procedure TPyConfig311.Set_configure_c_stdio(aValue: boolean);
begin
  FConfig.configure_c_stdio := ord(aValue);
end;

procedure TPyConfig311.Set_dev_mode(aValue: boolean);
begin
  if aValue then
    FConfig.dev_mode := -1
   else
    FConfig.dev_mode := 0;
end;

procedure TPyConfig311.Set_dump_refs(aValue: boolean);
begin
  FConfig.dump_refs := ord(aValue);
end;

procedure TPyConfig311.Set_dump_refs_file(const aValue: string);
begin
  SetWCharT(FConfig.dump_refs_file, aValue);
end;

procedure TPyConfig311.Set_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.exec_prefix, aValue);
end;

procedure TPyConfig311.Set_executable(const aValue: string);
begin
  SetWCharT(FConfig.executable, aValue);
end;

procedure TPyConfig311.Set_faulthandler(aValue: integer);
begin
  FConfig.faulthandler := aValue;
end;

procedure TPyConfig311.Set_filesystem_encoding(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_encoding, aValue);
end;

procedure TPyConfig311.Set_filesystem_errors(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_errors, aValue);
end;

procedure TPyConfig311.Set_hash_seed(aValue: uint64);
begin
  FConfig.hash_seed := aValue;
end;

procedure TPyConfig311.Set_home(const aValue: string);
begin
  SetWCharT(FConfig.home, aValue);
end;

procedure TPyConfig311.Set_import_time(aValue: integer);
begin
  FConfig.import_time := aValue;
end;

procedure TPyConfig311.Set_inspect(aValue: boolean);
begin
  FConfig.inspect := ord(aValue);
end;

procedure TPyConfig311.Set_install_signal_handlers(aValue: boolean);
begin
  FConfig.install_signal_handlers := ord(aValue);
end;

procedure TPyConfig311.Set_interactive(aValue: boolean);
begin
  FConfig.interactive := ord(aValue);
end;

procedure TPyConfig311.Set_isolated(aValue: boolean);
begin
  FConfig.isolated := ord(aValue);
end;

{$IFDEF MSWINDOWS}
procedure TPyConfig311.Set_legacy_windows_stdio(aValue: boolean);
begin
  FConfig.legacy_windows_stdio := ord(aValue);
end;
{$ENDIF}

procedure TPyConfig311.Set_malloc_stats(aValue: boolean);
begin
  FConfig.malloc_stats := ord(aValue);
end;

procedure TPyConfig311.Set_module_search_paths(const aValue: string);
var
  TempPaths : TStringDynArray;
begin
  if (length(aValue) > 0) then
    begin
      TempPaths := CustomSplitString(aValue, PathSep);
      SetWideStringList(FConfig.module_search_paths, TempPaths);
    end;
end;

procedure TPyConfig311.Set_module_search_paths_set(aValue: boolean);
begin
  FConfig.module_search_paths_set := ord(aValue);
end;

procedure TPyConfig311.Set_optimization_level(aValue: TPyOptimizationLevel);
begin
  FConfig.optimization_level := integer(aValue);
end;

procedure TPyConfig311.Set_orig_argv(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.orig_argv, aValue);
end;

procedure TPyConfig311.Set_parse_argv(aValue: boolean);
begin
  FConfig.parse_argv := ord(aValue);
end;

procedure TPyConfig311.Set_parser_debug(aValue: boolean);
begin
  FConfig.parser_debug := ord(aValue);
end;

procedure TPyConfig311.Set_pathconfig_warnings(aValue: boolean);
begin
  FConfig.pathconfig_warnings := ord(aValue);
end;

procedure TPyConfig311.Set_platlibdir(const aValue: string);
begin
  SetWCharT(FConfig.platlibdir, aValue);
end;

procedure TPyConfig311.Set_prefix(const aValue: string);
begin
  SetWCharT(FConfig.prefix, aValue);
end;

procedure TPyConfig311.Set_program_name(const aValue: string);
begin
  SetWCharT(FConfig.program_name, aValue);
end;

procedure TPyConfig311.Set_pycache_prefix(const aValue: string);
begin
  SetWCharT(FConfig.pycache_prefix, aValue);
end;

procedure TPyConfig311.Set_pythonpath_env(const aValue: string);
begin
  SetWCharT(FConfig.pythonpath_env, aValue);
end;

procedure TPyConfig311.Set_quiet(aValue: boolean);
begin
  FConfig.quiet := ord(aValue);
end;

procedure TPyConfig311.Set_run_command(const aValue: string);
begin
  SetWCharT(FConfig.run_command, aValue);
end;

procedure TPyConfig311.Set_run_filename(const aValue: string);
begin
  SetWCharT(FConfig.run_filename, aValue);
end;

procedure TPyConfig311.Set_run_module(const aValue: string);
begin
  SetWCharT(FConfig.run_module, aValue);
end;

procedure TPyConfig311.Set_safe_path(aValue: boolean);
begin
  FConfig.safe_path := ord(aValue);
end;

procedure TPyConfig311.Set_show_ref_count(aValue: boolean);
begin
  FConfig.show_ref_count := ord(aValue);
end;

procedure TPyConfig311.Set_site_import(aValue: boolean);
begin
  FConfig.site_import := ord(aValue);
end;

procedure TPyConfig311.Set_skip_source_first_line(aValue: boolean);
begin
  FConfig.skip_source_first_line := ord(aValue);
end;

procedure TPyConfig311.Set_stdio_encoding(const aValue: string);
begin
  SetWCharT(FConfig.stdio_encoding, aValue);
end;

procedure TPyConfig311.Set_stdio_errors(const aValue: string);
begin
  SetWCharT(FConfig.stdio_errors, aValue);
end;

procedure TPyConfig311.Set_stdlib_dir(const aValue: string);
begin
  SetWCharT(FConfig.stdlib_dir, aValue);
end;

procedure TPyConfig311.Set_tracemalloc(aValue: boolean);
begin
  if aValue then
    FConfig.tracemalloc := -1
   else
    FConfig.tracemalloc := 0;
end;

procedure TPyConfig311.Set_use_environment(aValue: boolean);
begin
  FConfig.use_environment := ord(aValue);
end;

procedure TPyConfig311.Set_use_frozen_modules(aValue: boolean);
begin
  FConfig.use_frozen_modules := ord(aValue);
end;

procedure TPyConfig311.Set_use_hash_seed(aValue: boolean);
begin
  if aValue then
    FConfig.use_hash_seed := -1
   else
    FConfig.use_hash_seed := 0;
end;

procedure TPyConfig311.Set_user_site_directory(aValue: boolean);
begin
  FConfig.user_site_directory := ord(aValue);
end;

procedure TPyConfig311.Set_verbose(aValue: TPyVerboseMode);
begin
  FConfig.verbose := integer(aValue);
end;

procedure TPyConfig311.Set_warn_default_encoding(aValue: boolean);
begin
  FConfig.warn_default_encoding := ord(aValue);
end;

procedure TPyConfig311.Set_warnoptions(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.warnoptions, aValue);
end;

procedure TPyConfig311.Set_write_bytecode(aValue: boolean);
begin
  FConfig.write_bytecode := ord(aValue);
end;

procedure TPyConfig311.Set_xoptions(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.xoptions, aValue);
end;

function TPyConfig310.GetConfig: Pointer;
begin
  Result := @FConfig;
end;

function TPyConfig310.Get_argv: TStringDynArray;
begin                               
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.argv, Result);
end;

function TPyConfig310.Get_base_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_exec_prefix));
end;

function TPyConfig310.Get_base_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_executable));
end;

function TPyConfig310.Get_base_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_prefix));
end;

function TPyConfig310.Get_buffered_stdio: boolean;
begin
  Result := (FConfig.buffered_stdio <> 0);
end;

function TPyConfig310.Get_bytes_warning: integer;
begin
  Result := FConfig.bytes_warning;
end;

function TPyConfig310.Get_check_hash_pycs_mode: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.check_hash_pycs_mode));
end;

function TPyConfig310.Get_configure_c_stdio: boolean;
begin
  Result := (FConfig.configure_c_stdio <> 0);
end;

function TPyConfig310.Get_dev_mode: boolean;
begin
  Result := (FConfig.dev_mode <> 0);
end;

function TPyConfig310.Get_dump_refs: boolean;
begin
  Result := (FConfig.dump_refs <> 0);
end;

function TPyConfig310.Get_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.exec_prefix));
end;

function TPyConfig310.Get_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.executable));
end;

function TPyConfig310.Get_faulthandler: integer;
begin
  Result := FConfig.faulthandler;
end;

function TPyConfig310.Get_filesystem_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_encoding));
end;

function TPyConfig310.Get_filesystem_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_errors));
end;

function TPyConfig310.Get_hash_seed: uint64;
begin
  Result := FConfig.hash_seed;
end;

function TPyConfig310.Get_home: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.home));
end;

function TPyConfig310.Get_import_time: integer;
begin
  Result := FConfig.import_time;
end;

function TPyConfig310.Get_inspect: boolean;
begin
  Result := (FConfig.inspect <> 0);
end;

function TPyConfig310.Get_install_signal_handlers: boolean;
begin
  Result := (FConfig.install_signal_handlers <> 0);
end;

function TPyConfig310.Get_interactive: boolean;
begin
  Result := (FConfig.interactive <> 0);
end;

function TPyConfig310.Get_isolated: boolean;
begin
  Result := (FConfig.isolated <> 0);
end;

{$IFDEF MSWINDOWS}
function TPyConfig310.Get_legacy_windows_stdio: boolean;
begin
  Result := (FConfig.legacy_windows_stdio <> 0);
end;
{$ENDIF}

function TPyConfig310.Get_malloc_stats: boolean;
begin
  Result := (FConfig.malloc_stats <> 0);
end;

function TPyConfig310.Get_module_search_paths: string;
var
  TempSL : TStringList;
  i      : integer;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.module_search_paths, TempSL) then
    begin
      i := 0;
      while (i < TempSL.Count) do
        begin
          if (i = 0) then
            Result := TempSL[i]
           else
            Result := Result + PathSep + TempSL[i];

          inc(i);
        end;
    end
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig310.Get_module_search_paths_set: boolean;
begin
  Result := (FConfig.module_search_paths_set <> 0);
end;

function TPyConfig310.Get_optimization_level: TPyOptimizationLevel;
begin
  Result := TPyOptimizationLevel(FConfig.optimization_level);
end;

function TPyConfig310.Get_orig_argv: TStringDynArray;
begin                             
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.orig_argv, Result);
end;

function TPyConfig310.Get_parse_argv: boolean;
begin
  Result := (FConfig.parse_argv <> 0);
end;

function TPyConfig310.Get_parser_debug: boolean;
begin
  Result := (FConfig.parser_debug <> 0);
end;

function TPyConfig310.Get_pathconfig_warnings: boolean;
begin
  Result := (FConfig.pathconfig_warnings <> 0);
end;

function TPyConfig310.Get_platlibdir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.platlibdir));
end;

function TPyConfig310.Get_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.prefix));
end;

function TPyConfig310.Get_program_name: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.program_name));
end;

function TPyConfig310.Get_pycache_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pycache_prefix));
end;

function TPyConfig310.Get_pythonpath_env: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pythonpath_env));
end;

function TPyConfig310.Get_quiet: boolean;
begin
  Result := (FConfig.quiet <> 0);
end;

function TPyConfig310.Get_run_command: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_command));
end;

function TPyConfig310.Get_run_filename: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_filename));
end;

function TPyConfig310.Get_run_module: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_module));
end;

function TPyConfig310.Get_show_ref_count: boolean;
begin
  Result := (FConfig.show_ref_count <> 0);
end;

function TPyConfig310.Get_site_import: boolean;
begin
  Result := (FConfig.site_import <> 0);
end;

function TPyConfig310.Get_skip_source_first_line: boolean;
begin
  Result := (FConfig.skip_source_first_line <> 0);
end;

function TPyConfig310.Get_stdio_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_encoding));
end;

function TPyConfig310.Get_stdio_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_errors));
end;

function TPyConfig310.Get_tracemalloc: boolean;
begin
  Result := (FConfig.tracemalloc <> 0);
end;

function TPyConfig310.Get_use_environment: boolean;
begin
  Result := (FConfig.use_environment <> 0);
end;

function TPyConfig310.Get_use_hash_seed: boolean;
begin
  Result := (FConfig.use_hash_seed <> 0);
end;

function TPyConfig310.Get_user_site_directory: boolean;
begin
  Result := (FConfig.user_site_directory <> 0);
end;

function TPyConfig310.Get_verbose: TPyVerboseMode;
begin
  Result := TPyVerboseMode(FConfig.verbose);
end;

function TPyConfig310.Get_warn_default_encoding: boolean;
begin
  Result := (FConfig.warn_default_encoding <> 0);
end;

function TPyConfig310.Get_warnoptions: TStringDynArray;
begin                         
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.warnoptions, Result);
end;

function TPyConfig310.Get_write_bytecode: boolean;
begin
  Result := (FConfig.write_bytecode <> 0);
end;

function TPyConfig310.Get_xoptions: TStringDynArray;
begin                    
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.xoptions, Result);
end;

procedure TPyConfig310.Set_argv(const aValue: TStringDynArray);
begin
  SetArgv(aValue);
end;

procedure TPyConfig310.Set_base_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_exec_prefix, aValue);
end;

procedure TPyConfig310.Set_base_executable(const aValue: string);
begin
  SetWCharT(FConfig.base_executable, aValue);
end;

procedure TPyConfig310.Set_base_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_prefix, aValue);
end;

procedure TPyConfig310.Set_buffered_stdio(aValue: boolean);
begin
  FConfig.buffered_stdio := ord(aValue);
end;

procedure TPyConfig310.Set_bytes_warning(aValue: integer);
begin
  FConfig.bytes_warning := aValue;
end;

procedure TPyConfig310.Set_check_hash_pycs_mode(const aValue: string);
begin
  SetWCharT(FConfig.check_hash_pycs_mode, aValue);
end;

procedure TPyConfig310.Set_configure_c_stdio(aValue: boolean);
begin
  FConfig.configure_c_stdio := ord(aValue);
end;

procedure TPyConfig310.Set_dev_mode(aValue: boolean);
begin
  if aValue then
    FConfig.dev_mode := -1
   else
    FConfig.dev_mode := 0;
end;

procedure TPyConfig310.Set_dump_refs(aValue: boolean);
begin
  FConfig.dump_refs := ord(aValue);
end;

procedure TPyConfig310.Set_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.exec_prefix, aValue);
end;

procedure TPyConfig310.Set_executable(const aValue: string);
begin
  SetWCharT(FConfig.executable, aValue);
end;

procedure TPyConfig310.Set_faulthandler(aValue: integer);
begin
  FConfig.faulthandler := aValue;
end;

procedure TPyConfig310.Set_filesystem_encoding(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_encoding, aValue);
end;

procedure TPyConfig310.Set_filesystem_errors(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_errors, aValue);
end;

procedure TPyConfig310.Set_hash_seed(aValue: uint64);
begin
  FConfig.hash_seed := aValue;
end;

procedure TPyConfig310.Set_home(const aValue: string);
begin
  SetWCharT(FConfig.home, aValue);
end;

procedure TPyConfig310.Set_import_time(aValue: integer);
begin
  FConfig.import_time := aValue;
end;

procedure TPyConfig310.Set_inspect(aValue: boolean);
begin
  FConfig.inspect := ord(aValue);
end;

procedure TPyConfig310.Set_install_signal_handlers(aValue: boolean);
begin
  FConfig.install_signal_handlers := ord(aValue);
end;

procedure TPyConfig310.Set_interactive(aValue: boolean);
begin
  FConfig.interactive := ord(aValue);
end;

procedure TPyConfig310.Set_isolated(aValue: boolean);
begin
  FConfig.isolated := ord(aValue);
end;

{$IFDEF MSWINDOWS}
procedure TPyConfig310.Set_legacy_windows_stdio(aValue: boolean);
begin
  FConfig.legacy_windows_stdio := ord(aValue);
end;
{$ENDIF}

procedure TPyConfig310.Set_malloc_stats(aValue: boolean);
begin
  FConfig.malloc_stats := ord(aValue);
end;

procedure TPyConfig310.Set_module_search_paths(const aValue: string);
var
  TempPaths : TStringDynArray;
begin
  if (length(aValue) > 0) then
    begin
      TempPaths := CustomSplitString(aValue, PathSep);
      SetWideStringList(FConfig.module_search_paths, TempPaths);
    end;
end;

procedure TPyConfig310.Set_module_search_paths_set(aValue: boolean);
begin
  FConfig.module_search_paths_set := ord(aValue);
end;

procedure TPyConfig310.Set_optimization_level(aValue: TPyOptimizationLevel);
begin
  FConfig.optimization_level := integer(aValue);
end;

procedure TPyConfig310.Set_orig_argv(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.orig_argv, aValue);
end;

procedure TPyConfig310.Set_parse_argv(aValue: boolean);
begin
  FConfig.parse_argv := ord(aValue);
end;

procedure TPyConfig310.Set_parser_debug(aValue: boolean);
begin
  FConfig.parser_debug := ord(aValue);
end;

procedure TPyConfig310.Set_pathconfig_warnings(aValue: boolean);
begin
  FConfig.pathconfig_warnings := ord(aValue);
end;

procedure TPyConfig310.Set_platlibdir(const aValue: string);
begin
  SetWCharT(FConfig.platlibdir, aValue);
end;

procedure TPyConfig310.Set_prefix(const aValue: string);
begin
  SetWCharT(FConfig.prefix, aValue);
end;

procedure TPyConfig310.Set_program_name(const aValue: string);
begin
  SetWCharT(FConfig.program_name, aValue);
end;

procedure TPyConfig310.Set_pycache_prefix(const aValue: string);
begin
  SetWCharT(FConfig.pycache_prefix, aValue);
end;

procedure TPyConfig310.Set_pythonpath_env(const aValue: string);
begin
  SetWCharT(FConfig.pythonpath_env, aValue);
end;

procedure TPyConfig310.Set_quiet(aValue: boolean);
begin
  FConfig.quiet := ord(aValue);
end;

procedure TPyConfig310.Set_run_command(const aValue: string);
begin
  SetWCharT(FConfig.run_command, aValue);
end;

procedure TPyConfig310.Set_run_filename(const aValue: string);
begin
  SetWCharT(FConfig.run_filename, aValue);
end;

procedure TPyConfig310.Set_run_module(const aValue: string);
begin
  SetWCharT(FConfig.run_module, aValue);
end;

procedure TPyConfig310.Set_show_ref_count(aValue: boolean);
begin
  FConfig.show_ref_count := ord(aValue);
end;

procedure TPyConfig310.Set_site_import(aValue: boolean);
begin
  FConfig.site_import := ord(aValue);
end;

procedure TPyConfig310.Set_skip_source_first_line(aValue: boolean);
begin
  FConfig.skip_source_first_line := ord(aValue);
end;

procedure TPyConfig310.Set_stdio_encoding(const aValue: string);
begin
  SetWCharT(FConfig.stdio_encoding, aValue);
end;

procedure TPyConfig310.Set_stdio_errors(const aValue: string);
begin
  SetWCharT(FConfig.stdio_errors, aValue);
end;

procedure TPyConfig310.Set_tracemalloc(aValue: boolean);
begin
  if aValue then
    FConfig.tracemalloc := -1
   else
    FConfig.tracemalloc := 0;
end;

procedure TPyConfig310.Set_use_environment(aValue: boolean);
begin
  FConfig.use_environment := ord(aValue);
end;

procedure TPyConfig310.Set_use_hash_seed(aValue: boolean);
begin
  if aValue then
    FConfig.use_hash_seed := -1
   else
    FConfig.use_hash_seed := 0;
end;

procedure TPyConfig310.Set_user_site_directory(aValue: boolean);
begin
  FConfig.user_site_directory := ord(aValue);
end;

procedure TPyConfig310.Set_verbose(aValue: TPyVerboseMode);
begin
  FConfig.verbose := integer(aValue);
end;

procedure TPyConfig310.Set_warn_default_encoding(aValue: boolean);
begin
  FConfig.warn_default_encoding := ord(aValue);
end;

procedure TPyConfig310.Set_warnoptions(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.warnoptions, aValue);
end;

procedure TPyConfig310.Set_write_bytecode(aValue: boolean);
begin
  FConfig.write_bytecode := ord(aValue);
end;

procedure TPyConfig310.Set_xoptions(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.xoptions, aValue);
end;

function TPyConfig309.GetConfig: Pointer;
begin
  Result := @FConfig;
end;

function TPyConfig309.Get_argv: TStringDynArray;
begin
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.argv, Result);
end;

function TPyConfig309.Get_base_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_exec_prefix));
end;

function TPyConfig309.Get_base_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_executable));
end;

function TPyConfig309.Get_base_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.base_prefix));
end;

function TPyConfig309.Get_buffered_stdio: boolean;
begin
  Result := (FConfig.buffered_stdio <> 0);
end;

function TPyConfig309.Get_bytes_warning: integer;
begin
  Result := FConfig.bytes_warning;
end;

function TPyConfig309.Get_check_hash_pycs_mode: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.check_hash_pycs_mode));
end;

function TPyConfig309.Get_configure_c_stdio: boolean;
begin
  Result := (FConfig.configure_c_stdio <> 0);
end;

function TPyConfig309.Get_dev_mode: boolean;
begin
  Result := (FConfig.dev_mode <> 0);
end;

function TPyConfig309.Get_dump_refs: boolean;
begin
  Result := (FConfig.dump_refs <> 0);
end;

function TPyConfig309.Get_exec_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.exec_prefix));
end;

function TPyConfig309.Get_executable: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.executable));
end;

function TPyConfig309.Get_faulthandler: integer;
begin
  Result := FConfig.faulthandler;
end;

function TPyConfig309.Get_use_peg_parser: boolean;
begin
  Result := (FConfig._use_peg_parser <> 0);
end;

function TPyConfig309.Get_filesystem_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_encoding));
end;

function TPyConfig309.Get_filesystem_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.filesystem_errors));
end;

function TPyConfig309.Get_hash_seed: uint64;
begin
  Result := FConfig.hash_seed;
end;

function TPyConfig309.Get_home: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.home));
end;

function TPyConfig309.Get_import_time: integer;
begin
  Result := FConfig.import_time;
end;

function TPyConfig309.Get_inspect: boolean;
begin
  Result := (FConfig.inspect <> 0);
end;

function TPyConfig309.Get_install_signal_handlers: boolean;
begin
  Result := (FConfig.install_signal_handlers <> 0);
end;

function TPyConfig309.Get_interactive: boolean;
begin
  Result := (FConfig.interactive <> 0);
end;

function TPyConfig309.Get_isolated: boolean;
begin
  Result := (FConfig.isolated <> 0);
end;

{$IFDEF MSWINDOWS}
function TPyConfig309.Get_legacy_windows_stdio: boolean;
begin
  Result := (FConfig.legacy_windows_stdio <> 0);
end;
{$ENDIF}

function TPyConfig309.Get_malloc_stats: boolean;
begin
  Result := (FConfig.malloc_stats <> 0);
end;

function TPyConfig309.Get_module_search_paths: string;
var
  TempSL : TStringList;
  i      : integer;
begin
  TempSL := TStringList.Create;

  if PyWideStringListToStringList(FConfig.module_search_paths, TempSL) then
    begin
      i := 0;
      while (i < TempSL.Count) do
        begin
          if (i = 0) then
            Result := TempSL[i]
           else
            Result := Result + PathSep + TempSL[i];

          inc(i);
        end;
    end
   else
    Result := '';

  TempSL.Free;
end;

function TPyConfig309.Get_module_search_paths_set: boolean;
begin
  Result := (FConfig.module_search_paths_set <> 0);
end;

function TPyConfig309.Get_optimization_level: TPyOptimizationLevel;
begin
  Result := TPyOptimizationLevel(FConfig.optimization_level);
end;

function TPyConfig309.Get_orig_argv: TStringDynArray;
begin
  Result := nil;
  PyWideStringListToStringDynArray(FConfig._orig_argv, Result);
end;

function TPyConfig309.Get_parse_argv: boolean;
begin
  Result := (FConfig.parse_argv <> 0);
end;

function TPyConfig309.Get_parser_debug: boolean;
begin
  Result := (FConfig.parser_debug <> 0);
end;

function TPyConfig309.Get_pathconfig_warnings: boolean;
begin
  Result := (FConfig.pathconfig_warnings <> 0);
end;

function TPyConfig309.Get_platlibdir: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.platlibdir));
end;

function TPyConfig309.Get_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.prefix));
end;

function TPyConfig309.Get_program_name: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.program_name));
end;

function TPyConfig309.Get_pycache_prefix: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pycache_prefix));
end;

function TPyConfig309.Get_pythonpath_env: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.pythonpath_env));
end;

function TPyConfig309.Get_quiet: boolean;
begin
  Result := (FConfig.quiet <> 0);
end;

function TPyConfig309.Get_run_command: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_command));
end;

function TPyConfig309.Get_run_filename: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_filename));
end;

function TPyConfig309.Get_run_module: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.run_module));
end;

function TPyConfig309.Get_show_ref_count: boolean;
begin
  Result := (FConfig.show_ref_count <> 0);
end;

function TPyConfig309.Get_site_import: boolean;
begin
  Result := (FConfig.site_import <> 0);
end;

function TPyConfig309.Get_skip_source_first_line: boolean;
begin
  Result := (FConfig.skip_source_first_line <> 0);
end;

function TPyConfig309.Get_stdio_encoding: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_encoding));
end;

function TPyConfig309.Get_stdio_errors: string;
begin
  Result := PyWCharTStringToString(WCharTString(FConfig.stdio_errors));
end;

function TPyConfig309.Get_tracemalloc: boolean;
begin
  Result := (FConfig.tracemalloc <> 0);
end;

function TPyConfig309.Get_use_environment: boolean;
begin
  Result := (FConfig.use_environment <> 0);
end;

function TPyConfig309.Get_use_hash_seed: boolean;
begin
  Result := (FConfig.use_hash_seed <> 0);
end;

function TPyConfig309.Get_user_site_directory: boolean;
begin
  Result := (FConfig.user_site_directory <> 0);
end;

function TPyConfig309.Get_verbose: TPyVerboseMode;
begin
  Result := TPyVerboseMode(FConfig.verbose);
end;

function TPyConfig309.Get_warnoptions: TStringDynArray;
begin
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.warnoptions, Result);
end;

function TPyConfig309.Get_write_bytecode: boolean;
begin
  Result := (FConfig.write_bytecode <> 0);
end;

function TPyConfig309.Get_xoptions: TStringDynArray;
begin
  Result := nil;
  PyWideStringListToStringDynArray(FConfig.xoptions, Result);
end;

procedure TPyConfig309.Set_argv(const aValue: TStringDynArray);
begin
  SetArgv(aValue);
end;

procedure TPyConfig309.Set_base_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_exec_prefix, aValue);
end;

procedure TPyConfig309.Set_base_executable(const aValue: string);
begin
  SetWCharT(FConfig.base_executable, aValue);
end;

procedure TPyConfig309.Set_base_prefix(const aValue: string);
begin
  SetWCharT(FConfig.base_prefix, aValue);
end;

procedure TPyConfig309.Set_buffered_stdio(aValue: boolean);
begin
  FConfig.buffered_stdio := ord(aValue);
end;

procedure TPyConfig309.Set_bytes_warning(aValue: integer);
begin
  FConfig.bytes_warning := aValue;
end;

procedure TPyConfig309.Set_check_hash_pycs_mode(const aValue: string);
begin
  SetWCharT(FConfig.check_hash_pycs_mode, aValue);
end;

procedure TPyConfig309.Set_configure_c_stdio(aValue: boolean);
begin
  FConfig.configure_c_stdio := ord(aValue);
end;

procedure TPyConfig309.Set_dev_mode(aValue: boolean);
begin
  if aValue then
    FConfig.dev_mode := -1
   else
    FConfig.dev_mode := 0;
end;

procedure TPyConfig309.Set_dump_refs(aValue: boolean);
begin
  FConfig.dump_refs := ord(aValue);
end;

procedure TPyConfig309.Set_exec_prefix(const aValue: string);
begin
  SetWCharT(FConfig.exec_prefix, aValue);
end;

procedure TPyConfig309.Set_executable(const aValue: string);
begin
  SetWCharT(FConfig.executable, aValue);
end;

procedure TPyConfig309.Set_faulthandler(aValue: integer);
begin
  FConfig.faulthandler := aValue;
end;

procedure TPyConfig309.Set_use_peg_parser(aValue: boolean);
begin
  FConfig._use_peg_parser := ord(aValue);
end;

procedure TPyConfig309.Set_filesystem_encoding(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_encoding, aValue);
end;

procedure TPyConfig309.Set_filesystem_errors(const aValue: string);
begin
  SetWCharT(FConfig.filesystem_errors, aValue);
end;

procedure TPyConfig309.Set_hash_seed(aValue: uint64);
begin
  FConfig.hash_seed := aValue;
end;

procedure TPyConfig309.Set_home(const aValue: string);
begin
  SetWCharT(FConfig.home, aValue);
end;

procedure TPyConfig309.Set_import_time(aValue: integer);
begin
  FConfig.import_time := aValue;
end;

procedure TPyConfig309.Set_inspect(aValue: boolean);
begin
  FConfig.inspect := ord(aValue);
end;

procedure TPyConfig309.Set_install_signal_handlers(aValue: boolean);
begin
  FConfig.install_signal_handlers := ord(aValue);
end;

procedure TPyConfig309.Set_interactive(aValue: boolean);
begin
  FConfig.interactive := ord(aValue);
end;

procedure TPyConfig309.Set_isolated(aValue: boolean);
begin
  FConfig.isolated := ord(aValue);
end;

{$IFDEF MSWINDOWS}
procedure TPyConfig309.Set_legacy_windows_stdio(aValue: boolean);
begin
  FConfig.legacy_windows_stdio := ord(aValue);
end;
{$ENDIF}

procedure TPyConfig309.Set_malloc_stats(aValue: boolean);
begin
  FConfig.malloc_stats := ord(aValue);
end;

procedure TPyConfig309.Set_module_search_paths(const aValue: string);
var
  TempPaths : TStringDynArray;
begin
  if (length(aValue) > 0) then
    begin
      TempPaths := CustomSplitString(aValue, PathSep);
      SetWideStringList(FConfig.module_search_paths, TempPaths);
    end;
end;

procedure TPyConfig309.Set_module_search_paths_set(aValue: boolean);
begin
  FConfig.module_search_paths_set := ord(aValue);
end;

procedure TPyConfig309.Set_optimization_level(aValue: TPyOptimizationLevel);
begin
  FConfig.optimization_level := integer(aValue);
end;

procedure TPyConfig309.Set_orig_argv(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig._orig_argv, aValue);
end;

procedure TPyConfig309.Set_parse_argv(aValue: boolean);
begin
  FConfig.parse_argv := ord(aValue);
end;

procedure TPyConfig309.Set_parser_debug(aValue: boolean);
begin
  FConfig.parser_debug := ord(aValue);
end;

procedure TPyConfig309.Set_pathconfig_warnings(aValue: boolean);
begin
  FConfig.pathconfig_warnings := ord(aValue);
end;

procedure TPyConfig309.Set_platlibdir(const aValue: string);
begin
  SetWCharT(FConfig.platlibdir, aValue);
end;

procedure TPyConfig309.Set_prefix(const aValue: string);
begin
  SetWCharT(FConfig.prefix, aValue);
end;

procedure TPyConfig309.Set_program_name(const aValue: string);
begin
  SetWCharT(FConfig.program_name, aValue);
end;

procedure TPyConfig309.Set_pycache_prefix(const aValue: string);
begin
  SetWCharT(FConfig.pycache_prefix, aValue);
end;

procedure TPyConfig309.Set_pythonpath_env(const aValue: string);
begin
  SetWCharT(FConfig.pythonpath_env, aValue);
end;

procedure TPyConfig309.Set_quiet(aValue: boolean);
begin
  FConfig.quiet := ord(aValue);
end;

procedure TPyConfig309.Set_run_command(const aValue: string);
begin
  SetWCharT(FConfig.run_command, aValue);
end;

procedure TPyConfig309.Set_run_filename(const aValue: string);
begin
  SetWCharT(FConfig.run_filename, aValue);
end;

procedure TPyConfig309.Set_run_module(const aValue: string);
begin
  SetWCharT(FConfig.run_module, aValue);
end;

procedure TPyConfig309.Set_show_ref_count(aValue: boolean);
begin
  FConfig.show_ref_count := ord(aValue);
end;

procedure TPyConfig309.Set_site_import(aValue: boolean);
begin
  FConfig.site_import := ord(aValue);
end;

procedure TPyConfig309.Set_skip_source_first_line(aValue: boolean);
begin
  FConfig.skip_source_first_line := ord(aValue);
end;

procedure TPyConfig309.Set_stdio_encoding(const aValue: string);
begin
  SetWCharT(FConfig.stdio_encoding, aValue);
end;

procedure TPyConfig309.Set_stdio_errors(const aValue: string);
begin
  SetWCharT(FConfig.stdio_errors, aValue);
end;

procedure TPyConfig309.Set_tracemalloc(aValue: boolean);
begin
  if aValue then
    FConfig.tracemalloc := -1
   else
    FConfig.tracemalloc := 0;
end;

procedure TPyConfig309.Set_use_environment(aValue: boolean);
begin
  FConfig.use_environment := ord(aValue);
end;

procedure TPyConfig309.Set_use_hash_seed(aValue: boolean);
begin
  if aValue then
    FConfig.use_hash_seed := -1
   else
    FConfig.use_hash_seed := 0;
end;

procedure TPyConfig309.Set_user_site_directory(aValue: boolean);
begin
  FConfig.user_site_directory := ord(aValue);
end;

procedure TPyConfig309.Set_verbose(aValue: TPyVerboseMode);
begin
  FConfig.verbose := integer(aValue);
end;

procedure TPyConfig309.Set_warnoptions(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.warnoptions, aValue);
end;

procedure TPyConfig309.Set_write_bytecode(aValue: boolean);
begin
  FConfig.write_bytecode := ord(aValue);
end;

procedure TPyConfig309.Set_xoptions(const aValue: TStringDynArray);
begin
  SetWideStringList(FConfig.xoptions, aValue);
end;

class function TPyConfigBuilder.New(aMajor, aMinor: integer): IPyConfig;
begin
  Result := nil;
  case aMajor of
    SUPPORTED_MAJOR_VERSION:
      case aMinor of
        15: Result := TPyConfig315.Create;
        14: Result := TPyConfig314.Create;
        13: Result := TPyConfig313.Create;
        12: Result := TPyConfig312.Create;
        11: Result := TPyConfig311.Create;
        10: Result := TPyConfig310.Create;
        09: Result := TPyConfig309.Create;
      end;
  end;
end;

end.
