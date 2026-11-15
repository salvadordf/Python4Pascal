unit uP4P.PyInitConfig;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils, System.Types,
  {$ELSE}
    Classes, SysUtils, Types,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces;

type
  /// <summary>
  /// Class to configure the Python initialization.
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/c-api/init_config.html#c.PyInitConfig">See the article about PyInitConfig.</see></para>
  /// </remarks>
  TPyInitConfig = class(TInterfacedObject, IPyInitConfig)
    protected
      FConfig : PPyInitConfig;

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
      {$IFDEF PY_GIL_DISABLED}
      function Get_enable_gil: TPyConfigGIL;
      {$ENDIF}
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
      function Get_lazy_imports: PyImport_LazyImportsMode;                //****** 3.15.0
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
      function Get_pymalloc_hugepages: boolean;                           //****** 3.15.0
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
      {$IFDEF PY_GIL_DISABLED}
      function Get_tlbc_enabled: boolean;
      {$ENDIF}
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
      {$IFDEF PY_GIL_DISABLED}
      procedure Set_enable_gil(aValue: TPyConfigGIL);
      {$ENDIF}
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
      procedure Set_lazy_imports(aValue: PyImport_LazyImportsMode);       //****** 3.15.0
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
      procedure Set_pymalloc_hugepages(aValue: boolean);                  //****** 3.15.0
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
      {$IFDEF PY_GIL_DISABLED}
      procedure Set_tlbc_enabled(aValue: boolean);
      {$ENDIF}
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
      /// <para>Set aItems, and return True on success.</para>
      /// <para>Set an error in config and return False on error.</para>
      /// </summary>
      function GetStrList(const aName: string; var aItems: TStringList): boolean; overload;
      /// <summary>
      /// <para>Get a string list configuration option as a TStringDynArray.</para>
      /// <para>Set aItems, and return True on success.</para>
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

    public
      constructor Create;
      destructor  Destroy; override;

      /// <summary>
      /// <para>Create a new initialization configuration using Isolated
      /// Configuration default values.</para>
      /// <para>It must be freed by PyInitConfig_Free().</para>
      /// <para>Return nil on memory allocation failure.</para>
      /// </summary>
      class function  CreateInitConfig: PPyInitConfig;
      /// <summary>
      /// <para>Free memory of the initialization configuration config.</para>
      /// <para>If config is nil, no operation is performed.</para>
      /// </summary>
      class procedure FreeInitConfig(var config_: PPyInitConfig);
      /// <summary>
      /// Helper function to check if an IPyInitConfig instance is fully
      /// initialized.
      /// </summary>
      class function  IsInitialized(const config_: IPyInitConfig): boolean; {$IFDEF SUPPORTS_INLINE}inline;{$ENDIF}

      /// <summary>
      /// <para>Get the config error message.</para>
      /// <para>If config has an exit code, format the exit code as an error
      /// message.</para>
      /// <para>The error message remains valid until another PyInitConfig
      /// function is called with config. The caller doesn't have to free the
      /// error message.</para>
      /// </summary>
      property Error                      : string                 read GetError;
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
      property ExitCode                   : integer                read GetExitCode;
      /// <summary>
      /// Name of the Python memory allocator.
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/memory.html#memory">See the Memory Management article.</see></para>
      /// <para>See PyMemAllocatorName.</para>
      /// </remarks>
      property allocator                  : PyMemAllocatorName     read Get_allocator                      write Set_allocator;
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
      {$IFDEF PY_GIL_DISABLED}
      /// <summary>
      /// <para>enable_gil controls whether the GIL is on at runtime.</para>
      /// <code>
      /// _PyConfig_GIL_DISABLE requests it off,
      /// _PyConfig_GIL_ENABLE requests it on,
      /// _PyConfig_GIL_DEFAULT leaves the choice to CPython.
      /// </code>
      /// <para>In the default mode, the GIL can be re-enabled when an imported
      /// extension hasn't declared that it supports running without it.</para>
      /// <para>In practice, enable_gil chooses the interpreter's threading
      /// mode.</para>
      /// <para>Added in version 3.13.</para>
      /// </summary>
      property enable_gil                 : TPyConfigGIL             read Get_enable_gil                     write Set_enable_gil;
      {$ENDIF}
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
      property lazy_imports               : PyImport_LazyImportsMode read Get_lazy_imports                   write Set_lazy_imports;
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
      property pymalloc_hugepages        : boolean                   read Get_pymalloc_hugepages             write Set_pymalloc_hugepages;
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
      {$IFDEF PY_GIL_DISABLED}
      /// <summary>
      /// <para>tlbc_enabled controls thread-local bytecode: per-thread bytecode
      /// copies used in free-threaded builds.</para>
      /// <para>It's enabled by default; disabling it also disables the
      /// specializing interpreter.</para>
      /// <para>tlbc_enabled controls a bytecode implementation/optimization
      /// detail within that mode. Most embedders should leave tlbc_enabled at
      /// its default unless they have a specific compatibility or debugging
      /// reason to change it.</para>
      /// <para>Added in version 3.14.</para>
      /// </summary>
      property tlbc_enabled               : boolean                  read Get_tlbc_enabled                   write Set_tlbc_enabled;
      {$ENDIF}
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

implementation

uses
  uP4P.MiscFunctions, uP4P.PyMem;

constructor TPyInitConfig.Create;
begin
  inherited Create;

  FConfig := CreateInitConfig();
end;

destructor TPyInitConfig.Destroy;
begin
  FreeInitConfig(FConfig);

  inherited Destroy;
end;

class function TPyInitConfig.CreateInitConfig: PPyInitConfig;
begin
  if assigned(PyInitConfig_Create) then
    Result := PyInitConfig_Create()
   else
    Result := nil;
end;

class procedure TPyInitConfig.FreeInitConfig(var config_: PPyInitConfig);
begin
  if assigned(PyInitConfig_Free) and
     assigned(config_) then
    begin
      PyInitConfig_Free(config_);
      config_ := nil;
    end;
end;

class function TPyInitConfig.IsInitialized(const config_: IPyInitConfig): boolean;
begin
  Result := assigned(config_) and config_.Initialized;
end;

function TPyInitConfig.GetConfig: Pointer;
begin
  Result := FConfig;
end;

function TPyInitConfig.GetInitialized: boolean;
begin
  Result := assigned(FConfig);
end;

function TPyInitConfig.GetError: string;
var
  TempString : PAnsiChar;
begin
  if Initialized and
     assigned(PyInitConfig_GetError) and
     (PyInitConfig_GetError(FConfig, TempString) <> 0) then
    Result := PyUTF8ToString(TempString)
   else
    Result := '';
end;

function TPyInitConfig.GetExitCode: integer;
var
  TempInt : integer;
begin
  if Initialized and
     assigned(PyInitConfig_GetExitCode) and
     (PyInitConfig_GetExitCode(FConfig, TempInt) = 1) then
    Result := TempInt
   else
    Result := 0;
end;

function TPyInitConfig.HasOption(const aOption: string): boolean;
var
  TempName : AnsiString;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_HasOption) and
     (length(aOption) > 0) then
    begin
      TempName := StringToPyUTF8(aOption);
      Result   := (PyInitConfig_HasOption(FConfig, PAnsiChar(TempName)) <> 0);
    end;
end;

function TPyInitConfig.GetInt(const aName: string; var aValue: int64): boolean;
var
  TempName : AnsiString;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_GetInt) and
     (length(aName) > 0) then
    begin
      TempName := StringToPyUTF8(aName);
      Result   := (PyInitConfig_GetInt(FConfig, PAnsiChar(TempName), aValue) = 0);
    end;
end;

function TPyInitConfig.GetStr(const aName: string; var aValue: string): boolean;
var
  TempName  : AnsiString;
  TempValue : PAnsiChar;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_GetStr) and
     (length(aName) > 0) then
    begin
      TempName  := StringToPyUTF8(aName);
      TempValue := nil;

      if (PyInitConfig_GetStr(FConfig, PAnsiChar(TempName), TempValue) = 0) then
        begin
          Result := True;

          if assigned(TempValue) then
            begin
              aValue := PyUTF8ToString(TempValue);
              TPyMem.Free(TempValue);
            end;
        end;
    end;
end;

function TPyInitConfig.GetStrList(const aName: string; var aItems: TStringList): boolean;
var
  TempName : AnsiString;
  TempItems : PPAnsiChar;
  TempItem : PAnsiChar;
  TempLen, i : NativeUInt;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_GetStrList) and
     assigned(PyInitConfig_FreeStrList) and
     (length(aName) > 0) then
    begin
      TempName  := StringToPyUTF8(aName);
      TempLen   := 0;
      TempItems := nil;

      if (PyInitConfig_GetStrList(FConfig, PAnsiChar(TempName), TempLen, TempItems) = 0) then
        begin
          if assigned(aItems) then
            aItems.Clear
           else
            aItems := TStringList.Create;

          Result := True;

          if assigned(TempItems) then
            begin
              i := 0;
              while (i < TempLen) do
                begin
                  TempItem := TempItems^;
                  aItems.Add(PyUTF8ToString(TempItem));
                  inc(TempItems);
                  inc(i);
                end;

              Dec(TempItems, aItems.Count);
              PyInitConfig_FreeStrList(TempLen, TempItems);
            end;
        end;
    end;
end;

function TPyInitConfig.GetStrList(const aName: string; var aItems: TStringDynArray): boolean;
var
  TempName : AnsiString;
  TempItems : PPAnsiChar;
  TempItem : PAnsiChar;
  TempLen, i : NativeUInt;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_GetStrList) and
     assigned(PyInitConfig_FreeStrList) and
     (length(aName) > 0) then
    begin
      TempName  := StringToPyUTF8(aName);
      TempLen   := 0;
      TempItems := nil;

      if (PyInitConfig_GetStrList(FConfig, PAnsiChar(TempName), TempLen, TempItems) = 0) then
        begin
          Result := True;

          if assigned(TempItems) then
            begin
              SetLength(aItems, TempLen);

              i := 0;
              while (i < TempLen) do
                begin
                  TempItem  := TempItems^;
                  aItems[i] := PyUTF8ToString(TempItem);
                  inc(TempItems);
                  inc(i);
                end;

              Dec(TempItems, TempLen);
              PyInitConfig_FreeStrList(TempLen, TempItems);
            end;
        end;
    end;
end;

function TPyInitConfig.SetInt(const aName: string; aValue: int64): boolean;
var
  TempString : AnsiString;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_SetInt) and
     (length(aName) > 0) then
    begin
      TempString := StringToPyUTF8(aName);
      Result     := (PyInitConfig_SetInt(FConfig, PAnsiChar(TempString), aValue) = 0);
    end;
end;

function TPyInitConfig.SetStr(const aName, aValue: string): boolean;
var
  TempName, TempValue : AnsiString;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_SetStr) and
     (length(aName)  > 0) and
     (length(aValue) > 0) then
    begin
      TempName  := StringToPyUTF8(aName);
      TempValue := StringToPyUTF8(aValue);
      Result    := (PyInitConfig_SetStr(FConfig, PAnsiChar(TempName), PAnsiChar(TempValue)) = 0);
    end;
end;

function TPyInitConfig.SetStrList(const aName: string; const aItems: TStringList): boolean;
var
  TempName : AnsiString;
  TempItems : array of AnsiString;
  TempItemsPtr : array of PAnsiString;
  i : integer;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_SetStrList) and
     (length(aName) > 0) and
     assigned(aItems) and
     (aItems.Count > 0) then
    begin
      TempName     := StringToPyUTF8(aName);
      TempItems    := nil;
      TempItemsPtr := nil;

      SetLength(TempItems,    aItems.Count);
      SetLength(TempItemsPtr, aItems.Count);

      for i := 0 to pred(aItems.Count) do
        begin
          TempItems[i]    := StringToPyUTF8(aItems[i]);
          TempItemsPtr[i] := PAnsiString(TempItems[i]);
        end;

       Result := (PyInitConfig_SetStrList(FConfig, PAnsiChar(TempName), aItems.Count, @TempItemsPtr[0]) = 0);
    end;
end;

function TPyInitConfig.SetStrList(const aName: string; const aItems: TStringDynArray): boolean;
var
  TempName : AnsiString;
  TempItems : array of AnsiString;
  TempItemsPtr : array of PAnsiString;
  i, TempLen : NativeUInt;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_SetStrList) and
     (length(aName) > 0) and
     assigned(aItems) and
     (length(aItems) > 0) then
    begin
      TempLen      := length(aItems);
      TempName     := StringToPyUTF8(aName);
      TempItems    := nil;
      TempItemsPtr := nil;

      SetLength(TempItems,    TempLen);
      SetLength(TempItemsPtr, TempLen);

      for i := 0 to pred(TempLen) do
        begin
          TempItems[i]    := StringToPyUTF8(aItems[i]);
          TempItemsPtr[i] := PAnsiString(TempItems[i]);
        end;

       Result := (PyInitConfig_SetStrList(FConfig, PAnsiChar(TempName), TempLen, @TempItemsPtr[0]) = 0);
    end;
end;

function TPyInitConfig.AddModule(const aName: string; initfunc_: initfunc): boolean;
var
  TempString : AnsiString;
begin
  Result := False;

  if Initialized and
     assigned(PyInitConfig_AddModule) and
     (length(aName) > 0) then
    begin
      TempString := StringToPyUTF8(aName);
      Result     := (PyInitConfig_AddModule(FConfig, PAnsiChar(TempString), initfunc_) = 0);
    end;
end;

function TPyInitConfig.Get_allocator: PyMemAllocatorName;
var
  TempResult : int64;
begin
  TempResult := 0;

  if GetInt(PYINITCONFIGOPTION_ALLOCATOR, TempResult) then
    Result := PyMemAllocatorName(TempResult)
   else
    Result := PYMEM_ALLOCATOR_NOT_SET;
end;

function TPyInitConfig.Get_argv: TStringDynArray;
begin
  Result := nil;
  GetStrList(PYINITCONFIGOPTION_ARGV, Result);
end;

function TPyInitConfig.Get_base_exec_prefix: string;
var
  TempResult : string;
begin
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_BASE_EXEC_PREFIX, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_base_executable: string;
var
  TempResult : string;
begin
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_BASE_EXECUTABLE, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_base_prefix: string;
var
  TempResult : string;
begin
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_BASE_PREFIX, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_buffered_stdio: boolean;
var
  TempResult : int64;
begin
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_BUFFERED_STDIO, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_bytes_warning: int64;
var
  TempResult : int64;
begin                
  TempResult := 0;

  if GetInt(PYINITCONFIGOPTION_BYTES_WARNING, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_check_hash_pycs_mode: string;
var
  TempResult : string;
begin
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_CHECK_HASH_PYCS_MODE, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_code_debug_ranges: boolean;
var
  TempResult : int64;
begin                          
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_CODE_DEBUG_RANGES, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_coerce_c_locale: integer;
var
  TempResult : int64;
begin
  TempResult := 0;

  if GetInt(PYINITCONFIGOPTION_COERCE_C_LOCALE, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_coerce_c_locale_warn: boolean;
var
  TempResult : int64;
begin
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_COERCE_C_LOCALE_WARN, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_configure_c_stdio: boolean;
var
  TempResult : int64;
begin              
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_CONFIGURE_C_STDIO, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_configure_locale: boolean;
var
  TempResult : int64;
begin               
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_CONFIGURE_LOCALE, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_cpu_count: int64;
var
  TempResult : int64;
begin           
  TempResult := 0;

  if GetInt(PYINITCONFIGOPTION_CPU_COUNT, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_dev_mode: boolean;
var
  TempResult : int64;
begin
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_DEV_MODE, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_dump_refs: boolean;
var
  TempResult : int64;
begin               
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_DUMP_REFS, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_dump_refs_file: string;
var
  TempResult : string;
begin
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_DUMP_REFS_FILE, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

{$IFDEF PY_GIL_DISABLED}
function TPyInitConfig.Get_enable_gil: TPyConfigGIL;
var
  TempResult : int64;
begin
  TempResult := 0;
  if GetInt(PYINITCONFIGOPTION_ENABLE_GIL, TempResult) then
    Result := TPyConfigGIL(TempResult)
   else
    Result := _PyConfig_GIL_DEFAULT;
end;
{$ENDIF}

function TPyInitConfig.Get_exec_prefix: string;
var
  TempResult : string;
begin                 
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_EXEC_PREFIX, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_executable: string;
var
  TempResult : string;
begin                  
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_EXECUTABLE, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_faulthandler: boolean;
var
  TempResult : int64;
begin               
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_FAULTHANDLER, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_filesystem_encoding: string;
var
  TempResult : string;
begin
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_FILESYSTEM_ENCODING, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_filesystem_errors: string;
var
  TempResult : string;
begin
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_FILESYSTEM_ERRORS, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_hash_seed: int64;
var
  TempResult : int64;
begin
  TempResult := 0;

  if GetInt(PYINITCONFIGOPTION_HASH_SEED, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_home: string;
var
  TempResult : string;
begin
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_HOME, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_import_time: int64;
var
  TempResult : int64;
begin
  TempResult := 0;

  if GetInt(PYINITCONFIGOPTION_IMPORT_TIME, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_inspect: boolean;
var
  TempResult : int64;
begin            
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_INSPECT, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_install_signal_handlers: boolean;
var
  TempResult : int64;
begin              
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_INSTALL_SIGNAL_HANDLERS, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_int_max_str_digits: int64;
var
  TempResult : int64;
begin                 
  TempResult := 0;

  if GetInt(PYINITCONFIGOPTION_INT_MAX_STR_DIGITS, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_interactive: boolean;
var
  TempResult : int64;
begin                   
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_INTERACTIVE, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_isolated: boolean;
var
  TempResult : int64;
begin
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_ISOLATED, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_lazy_imports: PyImport_LazyImportsMode;
var
  TempResult : int64;
begin                   
  TempResult := 0;

  if GetInt(PYINITCONFIGOPTION_LAZY_IMPORTS, TempResult) and (TempResult > 0) then
    Result := PyImport_LAZY_ALL
   else
    Result := PyImport_LAZY_NORMAL;
end;

{$IFDEF MSWINDOWS}
function TPyInitConfig.Get_legacy_windows_fs_encoding: boolean;
var
  TempResult : int64;
begin             
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_LEGACY_WINDOWS_FS_ENCODING, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_legacy_windows_stdio: boolean;
var
  TempResult : int64;
begin              
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_LEGACY_WINDOWS_STDIO, TempResult) and
                (TempResult <> 0);
end;
{$ENDIF}

function TPyInitConfig.Get_malloc_stats: boolean;
var
  TempResult : int64;
begin                        
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_MALLOC_STATS, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_module_search_paths: string;
var
  TempSL : TStringList;
  i      : integer;
begin
  TempSL := TStringList.Create;

  if GetStrList(PYINITCONFIGOPTION_MODULE_SEARCH_PATHS, TempSL) then
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

function TPyInitConfig.Get_optimization_level: TPyOptimizationLevel;
var
  TempResult : int64;
begin                                    
  TempResult := 0;

  if GetInt(PYINITCONFIGOPTION_OPTIMIZATION_LEVEL, TempResult) then
    Result := TPyOptimizationLevel(TempResult)
   else
    Result := polDebug;
end;

function TPyInitConfig.Get_orig_argv: TStringDynArray;
begin
  Result := nil;
  GetStrList(PYINITCONFIGOPTION_ORIG_ARGV, Result);
end;

function TPyInitConfig.Get_parse_argv: boolean;
var
  TempResult : int64;
begin                       
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_PARSE_ARGV, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_parser_debug: boolean;
var
  TempResult : int64;
begin                                 
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_PARSER_DEBUG, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_pathconfig_warnings: boolean;
var
  TempResult : int64;
begin                         
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_PATHCONFIG_WARNINGS, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_perf_profiling: int64;
var
  TempResult : int64;
begin           
  TempResult := 0;

  if GetInt(PYINITCONFIGOPTION_PERF_PROFILING, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_platlibdir: string;
var
  TempResult : string;
begin
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_PLATLIBDIR, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_prefix: string;
var
  TempResult : string;
begin            
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_PREFIX, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_program_name: string;
var
  TempResult : string;
begin           
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_PROGRAM_NAME, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_pycache_prefix: string;
var
  TempResult : string;
begin                   
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_PYCACHE_PREFIX, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_pymalloc_hugepages: boolean;
var
  TempResult : int64;
begin
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_PYMALLOC_HUGEPAGES, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_quiet: boolean;
var
  TempResult : int64;
begin            
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_QUIET, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_run_command: string;
var
  TempResult : string;
begin
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_RUN_COMMAND, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_run_filename: string;
var
  TempResult : string;
begin                          
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_RUN_FILENAME, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_run_module: string;
var
  TempResult : string;
begin                          
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_RUN_MODULE, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_run_presite: string;
var
  TempResult : string;
begin                          
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_RUN_PRESITE, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_safe_path: boolean;
var
  TempResult : int64;
begin                          
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_SAFE_PATH, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_show_ref_count: boolean;
var
  TempResult : int64;
begin
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_SHOW_REF_COUNT, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_site_import: boolean;
var
  TempResult : int64;
begin            
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_SITE_IMPORT, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_skip_source_first_line: boolean;
var
  TempResult : int64;
begin                       
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_SKIP_SOURCE_FIRST_LINE, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_stdio_encoding: string;
var
  TempResult : string;
begin
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_STDIO_ENCODING, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_stdio_errors: string;
var
  TempResult : string;
begin
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_STDIO_ERRORS, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

function TPyInitConfig.Get_stdlib_dir: string;
var
  TempResult : string;
begin          
  TempResult := '';

  if GetStr(PYINITCONFIGOPTION_STDLIB_DIR, TempResult) then
    Result := TempResult
   else
    Result := '';
end;

{$IFDEF PY_GIL_DISABLED}
function TPyInitConfig.Get_tlbc_enabled: boolean;
var
  TempResult : int64;
begin
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_TLBC_ENABLED, TempResult) and
                (TempResult <> 0);
end;
{$ENDIF}

function TPyInitConfig.Get_tracemalloc: int64;
var
  TempResult : int64;
begin
  TempResult := 0;

  if GetInt(PYINITCONFIGOPTION_TRACEMALLOC, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_use_environment: boolean;
var
  TempResult : int64;
begin
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_USE_ENVIRONMENT, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_use_frozen_modules: boolean;
var
  TempResult : int64;
begin
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_USE_FROZEN_MODULES, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_use_hash_seed: boolean;
var
  TempResult : int64;
begin
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_USE_HASH_SEED, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_use_system_logger: boolean;
var
  TempResult : int64;
begin
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_USE_SYSTEM_LOGGER, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_user_site_directory: boolean;
var
  TempResult : int64;
begin
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_USER_SITE_DIRECTORY, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_utf8_mode: integer;
var
  TempResult : int64;
begin
  TempResult := 0;

  if GetInt(PYINITCONFIGOPTION_UTF8_MODE, TempResult) then
    Result := TempResult
   else
    Result := 0;
end;

function TPyInitConfig.Get_verbose: TPyVerboseMode;
var
  TempResult : int64;
begin
  TempResult := 0;

  if GetInt(PYINITCONFIGOPTION_VERBOSE, TempResult) then
    Result := TPyVerboseMode(TempResult)
   else
    Result := pvmDisabled;
end;

function TPyInitConfig.Get_warn_default_encoding: boolean;
var
  TempResult : int64;
begin
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_WARN_DEFAULT_ENCODING, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_warnoptions: TStringDynArray;
begin
  Result := nil;
  GetStrList(PYINITCONFIGOPTION_WARNOPTIONS, Result);
end;

function TPyInitConfig.Get_write_bytecode: boolean;
var
  TempResult : int64;
begin
  TempResult := 0;
  Result     := GetInt(PYINITCONFIGOPTION_WRITE_BYTECODE, TempResult) and
                (TempResult <> 0);
end;

function TPyInitConfig.Get_xoptions: TStringDynArray;
begin                        
  Result := nil;
  GetStrList(PYINITCONFIGOPTION_XOPTIONS, Result);
end;

procedure TPyInitConfig.Set_allocator(aValue: PyMemAllocatorName);
begin
  SetInt(PYINITCONFIGOPTION_ALLOCATOR, int64(aValue));
end;

procedure TPyInitConfig.Set_argv(const aValue: TStringDynArray);
begin
  SetStrList(PYINITCONFIGOPTION_ARGV, aValue);
end;

procedure TPyInitConfig.Set_base_exec_prefix(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_BASE_EXEC_PREFIX, aValue);
end;

procedure TPyInitConfig.Set_base_executable(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_BASE_EXECUTABLE, aValue);
end;

procedure TPyInitConfig.Set_base_prefix(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_BASE_PREFIX, aValue);
end;

procedure TPyInitConfig.Set_buffered_stdio(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_BUFFERED_STDIO, ord(aValue));
end;

procedure TPyInitConfig.Set_bytes_warning(aValue: int64);
begin
  SetInt(PYINITCONFIGOPTION_BYTES_WARNING, aValue);
end;

procedure TPyInitConfig.Set_check_hash_pycs_mode(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_CHECK_HASH_PYCS_MODE, aValue);
end;

procedure TPyInitConfig.Set_code_debug_ranges(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_CODE_DEBUG_RANGES, ord(aValue));
end;

procedure TPyInitConfig.Set_coerce_c_locale(aValue: integer);
begin
  SetInt(PYINITCONFIGOPTION_COERCE_C_LOCALE, aValue);
end;

procedure TPyInitConfig.Set_coerce_c_locale_warn(aValue: boolean);
begin
  if aValue then
    SetInt(PYINITCONFIGOPTION_COERCE_C_LOCALE_WARN, -1)
   else
    SetInt(PYINITCONFIGOPTION_COERCE_C_LOCALE_WARN, 0);
end;

procedure TPyInitConfig.Set_configure_c_stdio(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_CONFIGURE_C_STDIO, ord(aValue));
end;

procedure TPyInitConfig.Set_configure_locale(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_CONFIGURE_LOCALE, ord(aValue));
end;

procedure TPyInitConfig.Set_cpu_count(aValue: int64);
begin
  SetInt(PYINITCONFIGOPTION_CPU_COUNT, aValue);
end;

procedure TPyInitConfig.Set_dev_mode(aValue: boolean);
begin
  if aValue then
    SetInt(PYINITCONFIGOPTION_DEV_MODE, -1)
   else
    SetInt(PYINITCONFIGOPTION_DEV_MODE, 0);
end;

procedure TPyInitConfig.Set_dump_refs(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_DUMP_REFS, ord(aValue));
end;

procedure TPyInitConfig.Set_dump_refs_file(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_DUMP_REFS_FILE, aValue);
end;

{$IFDEF PY_GIL_DISABLED}
procedure TPyInitConfig.Set_enable_gil(aValue: TPyConfigGIL);
begin
  SetInt(PYINITCONFIGOPTION_ENABLE_GIL, integer(aValue));
end;
{$ENDIF}

procedure TPyInitConfig.Set_exec_prefix(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_EXEC_PREFIX, aValue);
end;

procedure TPyInitConfig.Set_executable(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_EXECUTABLE, aValue);
end;

procedure TPyInitConfig.Set_faulthandler(aValue: boolean);
begin
  if aValue then
    SetInt(PYINITCONFIGOPTION_FAULTHANDLER, -1)
   else
    SetInt(PYINITCONFIGOPTION_FAULTHANDLER, 0);
end;

procedure TPyInitConfig.Set_filesystem_encoding(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_FILESYSTEM_ENCODING, aValue);
end;

procedure TPyInitConfig.Set_filesystem_errors(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_FILESYSTEM_ERRORS, aValue);
end;

procedure TPyInitConfig.Set_hash_seed(aValue: int64);
begin
  SetInt(PYINITCONFIGOPTION_HASH_SEED, aValue);
end;

procedure TPyInitConfig.Set_home(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_HOME, aValue);
end;

procedure TPyInitConfig.Set_import_time(aValue: int64);
begin
  SetInt(PYINITCONFIGOPTION_IMPORT_TIME, aValue);
end;

procedure TPyInitConfig.Set_inspect(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_INSPECT, ord(aValue));
end;

procedure TPyInitConfig.Set_install_signal_handlers(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_INSTALL_SIGNAL_HANDLERS, ord(aValue));
end;

procedure TPyInitConfig.Set_int_max_str_digits(aValue: int64);
begin
  SetInt(PYINITCONFIGOPTION_INT_MAX_STR_DIGITS, aValue);
end;

procedure TPyInitConfig.Set_interactive(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_INTERACTIVE, ord(aValue));
end;

procedure TPyInitConfig.Set_isolated(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_ISOLATED, ord(aValue));
end;

procedure TPyInitConfig.Set_lazy_imports(aValue: PyImport_LazyImportsMode);
begin
  case aValue of
    PyImport_LAZY_NORMAL : SetInt(PYINITCONFIGOPTION_LAZY_IMPORTS, -1);
    PyImport_LAZY_ALL    : SetInt(PYINITCONFIGOPTION_LAZY_IMPORTS, 1);
  end;
end;

{$IFDEF MSWINDOWS}
procedure TPyInitConfig.Set_legacy_windows_fs_encoding(aValue: boolean);
begin
  if aValue then
    SetInt(PYINITCONFIGOPTION_LEGACY_WINDOWS_FS_ENCODING, -1)
   else
    SetInt(PYINITCONFIGOPTION_LEGACY_WINDOWS_FS_ENCODING, 0);
end;

procedure TPyInitConfig.Set_legacy_windows_stdio(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_LEGACY_WINDOWS_STDIO, ord(aValue));
end;
{$ENDIF}

procedure TPyInitConfig.Set_malloc_stats(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_MALLOC_STATS, ord(aValue));
end;

procedure TPyInitConfig.Set_module_search_paths(const aValue: string);
var
  TempSL: TStringList;
begin
  TempSL      := TStringList.Create;
  TempSL.Text := StringReplace(aValue, PathSep, #13, [rfReplaceAll]);
  SetStrList(PYINITCONFIGOPTION_MODULE_SEARCH_PATHS, TempSL);
  TempSL.Free;
end;

procedure TPyInitConfig.Set_optimization_level(aValue: TPyOptimizationLevel);
begin
  SetInt(PYINITCONFIGOPTION_OPTIMIZATION_LEVEL, int64(aValue));
end;

procedure TPyInitConfig.Set_orig_argv(const aValue: TStringDynArray);
begin
  SetStrList(PYINITCONFIGOPTION_ORIG_ARGV, aValue);
end;

procedure TPyInitConfig.Set_parse_argv(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_PARSE_ARGV, ord(aValue));
end;

procedure TPyInitConfig.Set_parser_debug(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_PARSER_DEBUG, ord(aValue));
end;

procedure TPyInitConfig.Set_pathconfig_warnings(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_PATHCONFIG_WARNINGS, ord(aValue));
end;

procedure TPyInitConfig.Set_perf_profiling(aValue: int64);
begin
  SetInt(PYINITCONFIGOPTION_PERF_PROFILING, aValue);
end;

procedure TPyInitConfig.Set_platlibdir(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_PLATLIBDIR, aValue);
end;

procedure TPyInitConfig.Set_prefix(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_PREFIX, aValue);
end;

procedure TPyInitConfig.Set_program_name(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_PROGRAM_NAME, aValue);
end;

procedure TPyInitConfig.Set_pycache_prefix(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_PYCACHE_PREFIX, aValue);
end;

procedure TPyInitConfig.Set_pymalloc_hugepages(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_PYMALLOC_HUGEPAGES, ord(aValue));
end;

procedure TPyInitConfig.Set_quiet(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_QUIET, ord(aValue));
end;

procedure TPyInitConfig.Set_run_command(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_RUN_COMMAND, aValue);
end;

procedure TPyInitConfig.Set_run_filename(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_RUN_FILENAME, aValue);
end;

procedure TPyInitConfig.Set_run_module(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_RUN_MODULE, aValue);
end;

procedure TPyInitConfig.Set_run_presite(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_RUN_PRESITE, aValue);
end;

procedure TPyInitConfig.Set_safe_path(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_SAFE_PATH, ord(aValue));
end;

procedure TPyInitConfig.Set_show_ref_count(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_SHOW_REF_COUNT, ord(aValue));
end;

procedure TPyInitConfig.Set_site_import(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_SITE_IMPORT, ord(aValue));
end;

procedure TPyInitConfig.Set_skip_source_first_line(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_SKIP_SOURCE_FIRST_LINE, ord(aValue));
end;

procedure TPyInitConfig.Set_stdio_encoding(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_STDIO_ENCODING, aValue);
end;

procedure TPyInitConfig.Set_stdio_errors(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_STDIO_ERRORS, aValue);
end;

procedure TPyInitConfig.Set_stdlib_dir(const aValue: string);
begin
  SetStr(PYINITCONFIGOPTION_STDLIB_DIR, aValue);
end;

{$IFDEF PY_GIL_DISABLED}
procedure TPyInitConfig.Set_tlbc_enabled(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_TLBC_ENABLED, ord(aValue));
end;
{$ENDIF}

procedure TPyInitConfig.Set_tracemalloc(aValue: int64);
begin
  SetInt(PYINITCONFIGOPTION_TRACEMALLOC, aValue);
end;

procedure TPyInitConfig.Set_use_environment(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_USE_ENVIRONMENT, ord(aValue));
end;

procedure TPyInitConfig.Set_use_frozen_modules(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_USE_FROZEN_MODULES, ord(aValue));
end;

procedure TPyInitConfig.Set_use_hash_seed(aValue: boolean);
begin
  if aValue then
    SetInt(PYINITCONFIGOPTION_USE_HASH_SEED, -1)
   else
    SetInt(PYINITCONFIGOPTION_USE_HASH_SEED, 0);
end;

procedure TPyInitConfig.Set_use_system_logger(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_USE_SYSTEM_LOGGER, ord(aValue));
end;

procedure TPyInitConfig.Set_user_site_directory(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_USER_SITE_DIRECTORY, ord(aValue));
end;

procedure TPyInitConfig.Set_utf8_mode(aValue: integer);
begin
  SetInt(PYINITCONFIGOPTION_UTF8_MODE, aValue);
end;

procedure TPyInitConfig.Set_verbose(aValue: TPyVerboseMode);
begin
  SetInt(PYINITCONFIGOPTION_VERBOSE, int64(aValue));
end;

procedure TPyInitConfig.Set_warn_default_encoding(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_WARN_DEFAULT_ENCODING, ord(aValue));
end;

procedure TPyInitConfig.Set_warnoptions(const aValue: TStringDynArray);
begin
  SetStrList(PYINITCONFIGOPTION_WARNOPTIONS, aValue);
end;

procedure TPyInitConfig.Set_write_bytecode(aValue: boolean);
begin
  SetInt(PYINITCONFIGOPTION_WRITE_BYTECODE, ord(aValue));
end;

procedure TPyInitConfig.Set_xoptions(const aValue: TStringDynArray);
begin
  SetStrList(PYINITCONFIGOPTION_XOPTIONS, aValue);
end;

end.
