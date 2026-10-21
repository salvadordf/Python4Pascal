unit uP4P.Loader;

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
    {$IFDEF MSWINDOWS}WinApi.Windows, Winapi.PsApi, System.Win.Registry,{$ELSE}Posix.DLfcn, Posix.Pthread,{$ENDIF}
    System.Classes, System.SysUtils, System.IOUtils, System.Types,
  {$ELSE}
    {$IFDEF MSWINDOWS}Windows, Registry, {$IFDEF FPC}JwaPsApi,{$ELSE}PsApi,{$ENDIF}{$ENDIF}
    Classes, SysUtils, Types,{$IFDEF DELPHI14_UP}IOUtils,{$ENDIF}
    {$IFDEF FPC}dynlibs, FileUtil, {$IFNDEF MSWINDOWS}dl,{$ENDIF}{$ENDIF}
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Interfaces;

type
  TOnBeforeInitializationEvent = procedure(Sender: TObject; const aInitConfig: IPyInitConfig; const aConfig: IPyConfig) of object;

  /// <summary>
  /// <para>TP4PLoader simplifies the initialization and destruction of the
  /// Python library.</para>
  /// </summary>
  TP4PLoader = class
    protected
      FLibHandle                         : {$IFDEF FPC}TLibHandle{$ELSE}THandle{$ENDIF};
      FReRaiseExceptions                 : boolean;
      FSetCurrentDir                     : boolean;
      FShowMessageDlg                    : boolean;
      FMustFreeLibrary                   : boolean;
      FInExtensionModule                 : boolean;
      FStatus                            : TP4PLoaderStatus;
      FLastErrorMessage                  : string;
      FFileVersion                       : TFileVersionInfo;
      FIsolated                          : boolean;
      FParserDebug                       : boolean;
      FVerbose                           : TPyVerboseMode;
      FInteractive                       : boolean;
      FOptimizationLevel                 : TPyOptimizationLevel;
      FSiteImport                        : boolean;
      FPathConfigWarnings                : boolean;
      FUseEnvironment                    : boolean;
      FUserSiteDirectory                 : boolean;
      FWriteBytecode                     : boolean;
      FDevMode                           : boolean;
      FUseDebugLib                       : boolean;
      FHome                              : string;
      FExecutable                        : string;
      FProgramName                       : string;
      FModuleSearchPaths                 : string;
      FLazyImports                       : PyImport_LazyImportsMode;
      FOnBeforeInitialization            : TOnBeforeInitializationEvent;

      function GetInitialized: boolean;
      function GetLoaded: boolean;
      function GetIsFinalizing: boolean;
      function GetPlatform: string;
      function GetCopyright: string;
      function GetCompiler: string;
      function GetBuildInfo: string;
      function GetOSPythonHome: string;
      function GetOSPythonLibPath: string;
      function GetIsHandleValid: boolean;

      procedure FreePythonLibrary;
      function  ReadLibraryVersionInfo(const aLibraryPath: string): boolean;
      function  ReadVersionFromFilename(const aLibraryPath: string): boolean;
      function  LoadPythonLibrary(const aLibraryPath: string): boolean;
      function  Version(var aMajor, aMinor, aMicro: integer): boolean;
      function  GetVersion(var aMajor, aMinor, aMicro: integer): boolean;
      function  GetFileVersion(var aFileVersion : TFileVersionInfo): boolean;
      procedure doOnBeforeInitialization(const aInitConfig: IPyInitConfig; const aConfig: IPyConfig = nil);
      procedure SetProgramArgs_PEP741(const aConfig : IPyInitConfig);
      procedure SetProgramArgs_PEP587(const aConfig : IPyConfig);
      function  Initialize_PEP741: boolean;
      function  Initialize_PEP587: boolean;
      function  FindPythonLib(const aPath: string; var aFiles: TStringList): boolean;
      function  PythonLibExists(const aPath: string): boolean;
      {$IFDEF MSWINDOWS}
      function  GetExtendedFileVersion(const aFileName : string) : uint64;
      function  GetDLLVersion(const aFileName : string) : boolean;
      function  SearchPythonRegistry(const aRegPath: string; aLocalMachine: boolean; var aInstallPath: string): boolean;
      function  SearchMicrosoftStoreRegistry(var aInstallPath: string): boolean;
      function  SearchUninstallRegistry(const aRegPath: string; aLocalMachine : boolean; var aInstallPath: string): boolean;
      function  CheckDLLbitness(const aFilename : string): boolean;
      function  FindPythonModule_win: boolean;
      {$ENDIF}
      {$IFDEF APPLE}
      function  FindPythonModule_apple: boolean;
      {$ENDIF}
      {$IFDEF LINUX}
      function  FindPythonModule_linux: boolean;
      {$ENDIF}
      function  SearchPythonHomeEnvironmentVariable(var aInstallPath: string): boolean;
      function  HasPythonSymbols: boolean;
      function  FindPythonModule: boolean;

      procedure LoadAllFunctions;
      procedure Load_pymacro;
      procedure Load_pymem;
      procedure Load_pybuffer;
      procedure Load_lock;
      procedure Load_critical_section;
      procedure Load_object;
      procedure Load_refcount;
      procedure Load_objimpl;
      procedure Load_pyhash;
      procedure Load_pydebug;
      procedure Load_bytearrayobject;
      procedure Load_bytesobject;
      procedure Load_unicodeobject;
      procedure Load_pyerrors;
      procedure Load_longobject;
      procedure Load_longintrepr;
      procedure Load_boolobject;
      procedure Load_floatobject;
      procedure Load_complexobject;
      procedure Load_rangeobject;
      procedure Load_memoryobject;
      procedure Load_tupleobject;
      procedure Load_listobject;
      procedure Load_dictobject;
      procedure Load_odictobject;
      procedure Load_enumobject;
      procedure Load_setobject;
      procedure Load_methodobject;
      procedure Load_moduleobject;
      procedure Load_monitoring;
      procedure Load_funcobject;
      procedure Load_classobject;
      procedure Load_fileobject;
      procedure Load_pycapsule;
      procedure Load_code;
      procedure Load_pyframe;
      procedure Load_traceback;
      procedure Load_sliceobject;
      procedure Load_cellobject;
      procedure Load_iterobject;
      procedure Load_initconfig;
      procedure Load_pystate;
      procedure Load_genobject;
      procedure Load_descrobject;
      procedure Load_genericaliasobject;
      procedure Load_sentinelobject;
      procedure Load_warnings;
      procedure Load_weakrefobject;
      procedure Load_structseq;
      procedure Load_picklebufobject;
      procedure Load_pytime;
      procedure Load_codecs;
      procedure Load_pythread;
      procedure Load_context;
      procedure Load_modsupport;
      procedure Load_compile;
      procedure Load_pythonrun;
      procedure Load_pylifecycle;
      procedure Load_ceval;
      procedure Load_sysmodule;
      procedure Load_audit;
      procedure Load_osmodule;
      procedure Load_intrcheck;
      procedure Load_import;
      procedure Load_abstract;
      procedure Load_bltinmodule;
      procedure Load_pystrtod;
      procedure Load_pystrcmp;
      procedure Load_fileutils;
      procedure Load_tracemalloc;
      procedure Load_frameobject;

      property  IsHandleValid : boolean read GetIsHandleValid;

    public
      constructor Create; virtual;
      destructor  Destroy; override;
      procedure   BeforeDestruction; override;
      /// <summary>
      /// Return true if the loaded Python library version is greater or equal
      /// to the version information in the arguments.
      /// </summary>
      function    PythonLibIsGreaterOrEqualThan(aMajor, aMinor, aMicro: integer): boolean;
      /// <summary>
      /// Load the Python library. If aLibraryPath is empty then it will try to
      /// find the Python binaries installed in Windows, Linux or macOS.
      /// </summary>
      function    Load(const aLibraryPath: string = '') : boolean;
      /// <summary>
      /// Load the Python library in an extension module. This function can only
      /// be called from a library.
      /// </summary>
      function    LoadInExtensionModule : boolean;
      /// <summary>
      /// Initialize the Python interpreter.
      /// </summary>
      function    Initialize: boolean; virtual;
      /// <summary>
      /// Finalize the Python interpreter.
      /// </summary>
      procedure   Finalize; virtual;

      /// <summary>
      ///	Used to set the current directory when the libraries are loaded.
      /// This is required if the application is launched from a different
      /// application.
      /// </summary>
      property SetCurrentDir                     : boolean                                      read FSetCurrentDir                     write FSetCurrentDir;
      /// <summary>
      /// Returns the TP4PLoader initialization status.
      /// </summary>
      property Status                            : TP4PLoaderStatus                             read FStatus;
      /// <summary>
      /// Returns true if the loader has an initialized status.
      /// </summary>
      property Initialized                       : boolean                                      read GetInitialized;
      /// <summary>
      /// Returns true if the Python library is loaded.
      /// </summary>
      property Loaded                            : boolean                                      read GetLoaded;
      /// <summary>
      /// Return true if the main Python interpreter is shutting down.
      /// </summary>
      property IsFinalizing                      : boolean                                      read GetIsFinalizing;
      /// <summary>
      /// Set to true to raise all exceptions.
      /// </summary>
      property ReRaiseExceptions                 : boolean                                      read FReRaiseExceptions                 write FReRaiseExceptions;
      /// <summary>
      /// Last error message that is usually shown when there's an
      /// initialization problem.
      /// </summary>
      property LastErrorMessage                  : string                                       read FLastErrorMessage;
      /// <summary>
      /// Set to true when you need to use a showmessage dialog to show the
      /// error messages.
      /// </summary>
      property ShowMessageDlg                    : boolean                                      read FShowMessageDlg                    write FShowMessageDlg;
      /// <summary>
      /// Set to true to free the library handle when the loader is destroyed.
      /// </summary>
      property MustFreeLibrary                   : boolean                                      read FMustFreeLibrary                   write FMustFreeLibrary;
      /// <summary>
      /// Library handle.
      /// </summary>
      property LibHandle                         : {$IFDEF FPC}TLibHandle{$ELSE}THandle{$ENDIF} read FLibHandle;
      /// <summary>
      /// Library version information.
      /// </summary>
      property FileVersion                       : TFileVersionInfo                             read FFileVersion;
      /// <summary>
      /// Python platform information.
      /// </summary>
      property Platform_                         : string                                       read GetPlatform;
      /// <summary>
      /// Python copyright information.
      /// </summary>
      property Copyright                         : string                                       read GetCopyright;
      /// <summary>
      /// Python compiler information.
      /// </summary>
      property Compiler                          : string                                       read GetCompiler;
      /// <summary>
      /// Python build information.
      /// </summary>
      property BuildInfo                         : string                                       read GetBuildInfo;
      /// <summary>
      /// Returns the Python home path when it's installed in the OS.
      /// </summary>
      property OSPythonHome                      : string                                       read GetOSPythonHome;
      /// <summary>
      /// Returns the Python library path when it's installed in the OS.
      /// </summary>
      property OSPythonLibPath                   : string                                       read GetOSPythonLibPath;
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
      property Isolated                          : boolean                                      read FIsolated                          write FIsolated;
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
      property ParserDebug                       : boolean                                      read FParserDebug                       write FParserDebug;
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
      property Verbose                           : TPyVerboseMode                               read FVerbose                           write FVerbose;
      /// <summary>
      /// <para>If True, enable the interactive mode (REPL).</para>
      /// <para>Enabled by the -i command line option.</para>
      /// <para>Default: False.</para>
      /// </summary>
      property Interactive                       : boolean                                      read FInteractive                       write FInteractive;
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
      property OptimizationLevel                 : TPyOptimizationLevel                         read FOptimizationLevel                 write FOptimizationLevel;
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
      property SiteImport                        : boolean                                      read FSiteImport                        write FSiteImport;
      /// <summary>
      /// <para>If True, calculation of path configuration is allowed to log
      /// warnings into stderr. If False, suppress these warnings.</para>
      /// <para>Default: True in Python mode, False in isolated mode.</para>
      /// <para>Changed in version 3.11: Now also applies on Windows.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
      /// </remarks>
      property PathConfigWarnings                : boolean                                      read FPathConfigWarnings                write FPathConfigWarnings;
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
      property UseEnvironment                    : boolean                                      read FUseEnvironment                    write FUseEnvironment;
      /// <summary>
      /// <para>If True, add the user site directory to sys.path.</para>
      /// <para>Set to False by the -s and -I command line options.</para>
      /// <para>Set to False by the PYTHONNOUSERSITE environment
      /// variable.</para>
      /// <para>Default: True in Python mode, False in isolated mode.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONNOUSERSITE">See the article about PYTHONNOUSERSITE.</see></para>
      /// </remarks>
      property UserSiteDirectory                 : boolean                                      read FUserSiteDirectory                 write FUserSiteDirectory;
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
      property WriteBytecode                     : boolean                                      read FWriteBytecode                     write FWriteBytecode;
      /// <summary>
      /// <para>If True, enable the Python Development Mode.</para>
      /// <para>Set to True by the -X dev option and the PYTHONDEVMODE
      /// environment variable.</para>
      /// <para>Default: True in Python mode, False in isolated mode.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/library/devmode.html#devmode">See the article about Python Development Mode.</see></para>
      /// </remarks>
      property DevMode                           : boolean                                      read FDevMode                           write FDevMode;
      /// <summary>
      /// <para>Use the debug library if available.</para>
      /// </summary>
      property UseDebugLib                       : boolean                                      read FUseDebugLib                       write FUseDebugLib;
      /// <summary>
      /// <para>Set the default Python "home" directory, that is, the location
      /// of the standard Python libraries.</para>
      /// <para>Set by the PYTHONHOME environment variable.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration input.</see></para>
      /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONHOME">See the article about PYTHONHOME.</see></para>
      /// </remarks>
      property Home                              : string                                       read FHome                              write FHome;
      /// <summary>
      /// <para>The absolute path of the executable binary for the Python
      /// interpreter: sys.executable.</para>
      /// <para>Part of the Python Path Configuration output.</para>
      /// <para>See also PyConfig.base_executable.</para>
      /// </summary>
      property Executable                        : string                                       read FExecutable                        write FExecutable;
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
      property ProgramName                       : string                                       read FProgramName                       write FProgramName;
      /// <summary>
      /// <para>A list of strings that specifies the search path for
      /// modules.</para>
      /// <para>Initialized from the environment variable PYTHONPATH, plus an
      /// installation-dependent default.</para>
      /// <para>If module_search_paths_set is False, TPy.InitializeFromConfig()
      /// will replace module_search_paths and sets module_search_paths_set to
      /// True.</para>
      /// <para>Default: empty list.</para>
      /// </summary>
      /// <remarks>
      /// <para><see href="https://docs.python.org/3/c-api/init_config.html#init-path-config">Part of the Python Path Configuration output.</see></para>
      /// <para><see href="https://docs.python.org/3/library/sys.html#sys.path">See the article about sys.path.</see></para>
      /// <para><see href="https://docs.python.org/3/using/cmdline.html#envvar-PYTHONPATH">See the article about PYTHONPATH.</see></para>
      /// </remarks>
      property ModuleSearchPaths                 : string                                       read FModuleSearchPaths                 write FModuleSearchPaths;
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
      property LazyImports                       : PyImport_LazyImportsMode                     read FLazyImports                       write FLazyImports;
      /// <summary>
      /// <para>Load the Python library from an extension module.</para>
      /// </summary>
      property InExtensionModule                 : boolean                                      read FInExtensionModule;
      /// <summary>
      /// Event triggered right before the Python initialization. It's used to
      /// change the configuration properties.
      /// </summary>
      property OnBeforeInitialization            : TOnBeforeInitializationEvent                 read FOnBeforeInitialization            write FOnBeforeInitialization;
  end;

implementation

uses
  {$IFDEF DELPHI16_UP}
  System.Math,
  {$ELSE}
  Math,
  {$ENDIF}
  uP4P.Constants, uP4P.MiscFunctions, uP4P.PyInitConfig, uP4P.PyConfig,
  uP4P.Py;

constructor TP4PLoader.Create;
begin
  inherited Create;

  FLibHandle              := 0;
  FReRaiseExceptions      := False;
  FSetCurrentDir          := False;
  FShowMessageDlg         := True;
  FStatus                 := plsUnloaded;
  FLastErrorMessage       := '';
  FMustFreeLibrary        := True;
  FParserDebug            := False;
  FVerbose                := pvmDisabled;
  FInteractive            := False;
  FOptimizationLevel      := polDebug;
  FPathConfigWarnings     := False;
  FWriteBytecode          := False;
  FDevMode                := False;
  FUseDebugLib            := {$IFDEF DEBUG}True{$ELSE}False{$ENDIF};
  FHome                   := '';
  FExecutable             := '';
  FProgramName            := '';
  FModuleSearchPaths      := '';
  FLazyImports            := PyImport_LAZY_NORMAL;
  FInExtensionModule      := False;

  {$IFDEF ANDROID}
  FIsolated               := True;
  FUserSiteDirectory      := True;
  FUseEnvironment         := False;
  FSiteImport             := False;
  {$ELSE}
  {$IFDEF IOS}
  FIsolated               := True;
  FUserSiteDirectory      := True;
  FUseEnvironment         := False;
  FSiteImport             := False;
  {$ELSE}
  FIsolated               := False;
  FUserSiteDirectory      := False;
  FUseEnvironment         := False;
  FSiteImport             := False;
  {$ENDIF}
  {$ENDIF}

  FOnBeforeInitialization := nil;

  FFileVersion.Major := 0;
  FFileVersion.Minor := 0;
  FFileVersion.Micro := 0;

  IsMultiThread := True;

  SetExceptionMask([exInvalidOp, exDenormalized, exZeroDivide, exOverflow, exUnderflow, exPrecision]);
end;

destructor TP4PLoader.Destroy;
begin
  try
    FreePythonLibrary;
  finally
    inherited Destroy;
  end;
end;

procedure TP4PLoader.BeforeDestruction;
begin
  try
    if Initialized then
      begin
        if not(FInExtensionModule) then Finalize;
        FStatus := plsFinalized;
      end;
  finally
    inherited BeforeDestruction;
  end;
end;

procedure TP4PLoader.FreePythonLibrary;
begin
  try
    try
      if FMustFreeLibrary and IsHandleValid then
        FreeLibrary(FLibHandle);
    except
      on e : exception do
        if CustomExceptionHandler('TP4PLoader.FreePythonLibrary', e) then raise;
    end;
  finally
    FLibHandle := 0;
    FStatus    := plsUnloaded;
  end;
end;

function TP4PLoader.GetInitialized : boolean;
begin
  Result := (FStatus = plsInitialized);
end;

function TP4PLoader.GetLoaded : boolean;
begin
  Result := IsHandleValid;
end;

function TP4PLoader.GetIsFinalizing : boolean;
begin
  Result := TPy.IsFinalizing;
end;

function TP4PLoader.GetPlatform: string;
begin
  Result := TPy.GetPlatform;
end;

function TP4PLoader.GetCopyright: string;
begin
  Result := TPy.GetCopyright;
end;

function TP4PLoader.GetCompiler: string;
begin
  Result := TPy.GetCompiler;
end;

function TP4PLoader.GetBuildInfo: string;
begin
  Result := TPy.GetBuildInfo;
end;

function TP4PLoader.GetOSPythonHome: string;
{$IFDEF MSWINDOWS}
const
  PTYHON_REG_PATH     = 'SOFTWARE\Python\PythonCore';
  PTYHON_REG_PATH_WOW = 'SOFTWARE\Wow6432Node\Python\PythonCore';
  UNINST_PATH_32BIT   = 'SOFTWARE\Microsoft\Windows\CurrentVersion\UnInstall';
  UNINST_PATH_64BIT   = 'SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall';
{$ENDIF}
var
  TempPath : string;
begin
  Result   := '';
  TempPath := '';

  try
    if SearchPythonHomeEnvironmentVariable(TempPath) then
      begin
        Result := TempPath;
        exit;
      end;

    {$IFDEF MSWINDOWS}
    if SearchPythonRegistry(PTYHON_REG_PATH,     False, TempPath) or
       SearchPythonRegistry(PTYHON_REG_PATH,     True,  TempPath) or
       SearchPythonRegistry(PTYHON_REG_PATH_WOW, False, TempPath) or
       SearchPythonRegistry(PTYHON_REG_PATH_WOW, True,  TempPath) or
       SearchMicrosoftStoreRegistry(TempPath) or
       SearchUninstallRegistry(UNINST_PATH_32BIT, False, TempPath) or
       SearchUninstallRegistry(UNINST_PATH_32BIT, True,  TempPath) or
       SearchUninstallRegistry(UNINST_PATH_64BIT, False, TempPath) or
       SearchUninstallRegistry(UNINST_PATH_64BIT, True,  TempPath) then
      Result := TempPath;
    {$ENDIF}
  except
    on e : exception do
      if CustomExceptionHandler('TP4PLoader.GetOSPythonHome', e) then raise;
  end;
end;

function TP4PLoader.PythonLibExists(const aPath: string): boolean;
var
  TempFiles : TStringList;
begin
  TempFiles := nil;
  try
    Result := FindPythonLib(aPath, TempFiles);
  finally
    if assigned(TempFiles) then FreeAndNil(TempFiles);
  end;
end;

function TP4PLoader.FindPythonLib(const aPath: string; var aFiles: TStringList): boolean;
begin
  Result := False;

  try
    if (length(aPath) > 0) and DirectoryExists(aPath) then
      begin
        {$IFDEF FPC}
        aFiles := FindAllFiles(aPath, 'python*.' + PYTHON_LIB_EXT, False);
        {$ELSE}
        aFiles := CustomFindAllFiles(aPath, 'python*.' + PYTHON_LIB_EXT);
        {$ENDIF}
        Result := assigned(aFiles) and (aFiles.Count > 0);
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TP4PLoader.FindPythonLib', e) then raise;
  end;
end;

function TP4PLoader.GetIsHandleValid: boolean;
begin
{$IFDEF MSWINDOWS}
  Result := (FLibHandle >= 32);
{$ELSE}
  Result := FLibHandle <> 0;
{$ENDIF}
end;

function TP4PLoader.GetOSPythonLibPath: string;
{$IFDEF MSWINDOWS}
var
  TempFiles : TStringList;
  i : integer;
  TempSize, TempMaxSize : int64;
  TempLib : string;
begin
  Result    := '';
  TempFiles := nil;

  try
    try
      if FindPythonLib(FHome, TempFiles) then
        begin
          TempLib     := '';
          TempMaxSize := 0;

          i := 0;
          while (i < TempFiles.Count) do
            begin
              {$IFDEF FPC}
              TempSize := FileSize(TempFiles[i]);
              {$ELSE}
                {$IFDEF DELPHI28_UP}
                TempSize := TFile.GetSize(TempFiles[i]);
                {$ELSE}
                TempSize := GetFileSize(TempFiles[i]);
                {$ENDIF}
              {$ENDIF}

              if (TempMaxSize < TempSize) then
                begin
                  if FUseDebugLib then
                    begin
                      TempMaxSize := TempSize;
                      TempLib     := TempFiles[i];
                    end
                   else
                    if (pos('_d', ExtractFilename(TempFiles[i])) = 0) then
                      begin
                        TempMaxSize := TempSize;
                        TempLib     := TempFiles[i];
                      end;
                end;

              inc(i);
            end;

          Result := TempLib;
        end;
    except
      on e : exception do
        if CustomExceptionHandler('TP4PLoader.GetOSPythonLibPath', e) then raise;
    end;
  finally
    if assigned(TempFiles) then FreeAndNil(TempFiles);
  end;
end;
{$ELSE}
{$IFDEF LINUX}
var
  i : integer;
  TempVersion, TempLib, TempPath : string;
begin
  Result := '';
  {$IFDEF TARGET_32BITS}
    {$IF DEFINED(CPUARM32) OR DEFINED(CPUARM)} 
    TempPath := '/usr/lib/arm-linux-gnueabihf/';
    {$ELSE}
    TempPath := '/usr/lib/i386-linux-gnu/';
    {$IFEND}
  {$ENDIF}
  {$IFDEF TARGET_64BITS}
    {$IF DEFINED(CPUARM64) OR DEFINED(CPUAARCH64)}
    TempPath := '/usr/lib/aarch64-linux-gnu/';
    {$ELSE}
    TempPath := '/usr/lib/x86_64-linux-gnu/';
    {$IFEND}
  {$ENDIF}

  try
    for i := MAX_SUPPORTED_MINOR_VERSION downto MIN_SUPPORTED_MINOR_VERSION do
      begin
        TempVersion := inttostr(SUPPORTED_MAJOR_VERSION) + '.' + inttostr(i);
        TempLib     := TempPath + 'libpython' + TempVersion + '.' + PYTHON_LIB_EXT;

        if FileExists(TempLib) then
          begin
            Result := TempLib;
            break;
          end;

        TempLib := TempLib + '.1';

        if FileExists(TempLib) then
          begin
            Result := TempLib;
            break;
          end;
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TP4PLoader.GetOSPythonLibPath', e) then raise;
  end;
end;
{$ELSE}
{$IFDEF APPLE}
var
  i : integer;
  TempVersion, TempLib : string;
begin
  Result := '';

  try
    for i := MAX_SUPPORTED_MINOR_VERSION downto MIN_SUPPORTED_MINOR_VERSION do
      begin
        TempVersion := inttostr(SUPPORTED_MAJOR_VERSION) + '.' + inttostr(i);
        TempLib     := '/Library/Frameworks/Python.framework/Versions/' + TempVersion + '/lib/libpython' + TempVersion + '.' + PYTHON_LIB_EXT;

        if FileExists(TempLib) then
          begin
            Result := TempLib;
            break;
          end;
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TP4PLoader.GetOSPythonLibPath', e) then raise;
  end;
end;
{$ELSE}
begin
  Result := '';
end;
{$ENDIF}
{$ENDIF}
{$ENDIF}

function TP4PLoader.SearchPythonHomeEnvironmentVariable(var aInstallPath: string): boolean;
var
  TempPath : string;
begin
  Result       := False;
  aInstallPath := '';
  TempPath     := GetEnvironmentVariable('PYTHONHOME');

  if PythonLibExists(TempPath) then
    begin
      aInstallPath := TempPath;
      Result       := True;
    end;
end;

function TP4PLoader.PythonLibIsGreaterOrEqualThan(aMajor, aMinor, aMicro: integer): boolean;
begin
  Result := (FFileVersion.Major > aMajor) or
            ((FFileVersion.Major = aMajor) and
             ((FFileVersion.Minor > aMinor) or
              ((FFileVersion.Minor = aMinor) and (FFileVersion.Micro >= aMicro))));
end;

function TP4PLoader.LoadPythonLibrary(const aLibraryPath: string): boolean;
var
  TempOldDir : string;
  TempError  : {$IFDEF MSWINDOWS}DWORD;{$ELSE}Integer;{$ENDIF}
begin
  Result := False;

  if IsHandleValid then
    FLastErrorMessage := 'The Python library is already loaded.'
   else
    try
      if FSetCurrentDir then
        begin
          TempOldDir := GetCurrentDir;
          chdir(GetModulePath);
        end;

      {$IFDEF MSWINDOWS}
        {$IFDEF DELPHI12_UP}
        FLibHandle := LoadLibraryExW(PWideChar(aLibraryPath), 0, LOAD_WITH_ALTERED_SEARCH_PATH);
        {$ELSE}
          {$IFDEF FPC}
          FLibHandle := LoadLibraryExW(PWideChar(UTF8Decode(aLibraryPath)), 0, LOAD_WITH_ALTERED_SEARCH_PATH);
          {$ELSE}
          FLibHandle := LoadLibraryExA(PChar(aLibraryPath), 0, LOAD_WITH_ALTERED_SEARCH_PATH);
          {$ENDIF}
        {$ENDIF}
      {$ELSE}
        {$IFDEF FPC}
        FLibHandle := TLibHandle(dlopen(PAnsiChar(aLibraryPath), RTLD_LAZY + RTLD_GLOBAL));
        {$ELSE}
        FLibHandle := THandle(dlopen(PAnsiChar(AnsiString(aLibraryPath)), RTLD_LAZY + RTLD_GLOBAL));
        {$ENDIF}
      {$ENDIF}

      if IsHandleValid then
        Result  := True
       else
        begin
          FStatus := plsErrorLoadingLibrary;

          {$IFDEF MSWINDOWS}
          TempError         := GetLastError;
          FLastErrorMessage := 'Error loading ' + aLibraryPath + CRLF + CRLF +
                               'Error code : 0x' + inttohex(TempError, 8) + CRLF +
                               SysErrorMessage(TempError);
          {$ELSE}
            {$IFDEF FPC}
            TempError         := GetLastOSError;
            FLastErrorMessage := 'Error loading ' + aLibraryPath + CRLF + CRLF +
                                 'Error code : 0x' + inttohex(TempError, 8) + CRLF +
                                 GetLoadErrorStr;
            {$ELSE}
            TempError         := GetLastError;
            FLastErrorMessage := 'Error loading ' + aLibraryPath + CRLF + CRLF +
                                 'Error code : 0x' + inttohex(TempError, 8);
            {$ENDIF}
          {$ENDIF}
        end;

      if FSetCurrentDir then chdir(TempOldDir);
    except
      on e : exception do
        begin
          FStatus := plsErrorLoadingLibrary;
          if CustomExceptionHandler('TP4PLoader.LoadPythonLibrary', e) then raise;
        end;
    end;
end;

function TP4PLoader.ReadLibraryVersionInfo(const aLibraryPath: string): boolean;
begin
  FFileVersion.Major := 0;
  FFileVersion.Minor := 0;
  FFileVersion.Micro := 0;

  if (length(aLibraryPath) = 0) or not(FileExists(aLibraryPath)) then
    begin
      Result            := False;
      FLastErrorMessage := FLastErrorMessage + CRLF + 'It' + #39 + 's not possible to find the Python library.';
      FStatus           := plsErrorDLLVersion;
    end
   else
    begin
      Result := {$IFDEF MSWINDOWS}GetDLLVersion(aLibraryPath) or{$ENDIF}
                ReadVersionFromFilename(aLibraryPath);

      if not(Result) then
        begin
          FLastErrorMessage := FLastErrorMessage + CRLF + 'Unknown Python library version.';
          FStatus           := plsErrorDLLVersion;
        end;
    end;
end;

function TP4PLoader.ReadVersionFromFilename(const aLibraryPath: string): boolean;
const
  PYTHON_NAME = 'python';
var
  TempName : string;
  i, TempMajor, TempMinor: integer;
begin
  Result    := False;
  TempMajor := 0;
  TempMinor := 0;
  TempName  := LowerCase(ExtractFileName(aLibraryPath));
  i         := Pos(PYTHON_NAME, TempName);

  if (i > 0) then
    begin
      TempName := copy(TempName, i + length(PYTHON_NAME), length(TempName));

      if (Length(TempName) > 0) and (TryStrToInt(TempName[1], TempMajor)) then
        begin
          TempName := copy(TempName, 2, length(TempName));

          if (length(TempName) > 0) and (TempName[1] = '.') then
            TempName := copy(TempName, 2, length(TempName));

          i := 1;
          while (i <= length(TempName)) and CharInSet(TempName[i], ['0'..'9']) do
            inc(i);

          if (i > 1) and
             not(TryStrToInt(copy(TempName, 1, pred(i)), TempMinor)) then
            exit;

          FFileVersion.Major := TempMajor;
          FFileVersion.Minor := TempMinor;
          FFileVersion.Micro := 0;
          Result             := True;
        end;
    end;
end;

{$IFDEF MSWINDOWS}
function TP4PLoader.GetExtendedFileVersion(const aFileName : string) : uint64;
var
  TempSize   : DWORD;
  TempBuffer : pointer;
  TempLen    : UINT;
  TempHandle : cardinal;
  TempInfo   : PVSFixedFileInfo;
begin
  Result     := 0;
  TempBuffer := nil;
  TempHandle := 0;
  TempLen    := 0;
  TempInfo   := nil;

  try
    try
      TempSize := GetFileVersionInfoSize({$IFNDEF DELPHI12_UP}PAnsiChar{$ELSE}PWideChar{$ENDIF}(aFileName), TempHandle);

      if (TempSize > 0) then
        begin
          GetMem(TempBuffer, TempSize);

          if GetFileVersionInfo({$IFNDEF DELPHI12_UP}PAnsiChar{$ELSE}PWideChar{$ENDIF}(aFileName), TempHandle, TempSize, TempBuffer) and
             VerQueryValue(TempBuffer, '\', Pointer(TempInfo), TempLen) then
            begin
              Result := TempInfo^.dwFileVersionMS;
              Result := Result shl 32;
              Result := Result or TempInfo^.dwFileVersionLS;
            end;
        end
       else
        FLastErrorMessage := SysErrorMessage(GetLastError());
    except
      on e : exception do
        if CustomExceptionHandler('TP4PLoader.GetExtendedFileVersion', e) then raise;
    end;
  finally
    if (TempBuffer <> nil) then FreeMem(TempBuffer);
  end;
end;

function TP4PLoader.GetDLLVersion(const aFileName : string) : boolean;
var
  TempVersion : uint64;
begin
  Result := False;

  try
    if FileExists(aFileName) then
      begin
        TempVersion := GetExtendedFileVersion(aFileName);

        if (TempVersion <> 0) then
          begin
            FFileVersion.Major := uint16(TempVersion shr 48);
            FFileVersion.Minor := uint16((TempVersion shr 32) and $FFFF);
            FFileVersion.Micro := uint16((TempVersion shr 16) and $FFFF);
            Result             := True;
          end;
      end;
  except
    on e : exception do
      if CustomExceptionHandler('TP4PLoader.GetDLLVersion', e) then raise;
  end;
end;

function TP4PLoader.SearchPythonRegistry(const aRegPath: string; aLocalMachine: boolean; var aInstallPath: string): boolean;
var
  TempReg : TRegistry;
  TempKeys : TStringList;
  i : integer;
  TempKey, TempPath : string;
begin
  Result   := False;
  TempReg  := nil;
  TempKeys := nil;

  try
    try
      TempReg := TRegistry.Create;

      if aLocalMachine then
        TempReg.RootKey := HKEY_LOCAL_MACHINE
       else
        TempReg.RootKey := HKEY_CURRENT_USER;

      if TempReg.OpenKeyReadOnly(aRegPath) then
        begin
          TempKeys := TStringList.Create;
          TempReg.GetKeyNames(TStrings(TempKeys));
          TempReg.CloseKey;

          TempKeys.Sort;

          i := pred(TempKeys.Count);

          while (i >= 0) and not(Result) do
            begin
              TempKey := TempKeys[i];

              if TempReg.OpenKeyReadOnly(aRegPath + '\' + TempKey + '\InstallPath') then
                begin
                  TempPath := TempReg.ReadString('');

                  if PythonLibExists(TempPath) then
                    begin
                      aInstallPath := TempPath;
                      Result       := True;
                    end;

                  TempReg.CloseKey;
                end;

              dec(i);
            end;
        end;
    except
      on e : exception do
        if CustomExceptionHandler('TP4PLoader.SearchPythonRegistry', e) then raise;
    end;
  finally
    if (TempReg  <> nil) then FreeAndNil(TempReg);
    if (TempKeys <> nil) then FreeAndNil(TempKeys);
  end;
end;

function TP4PLoader.SearchMicrosoftStoreRegistry(var aInstallPath: string): boolean;
const
  APPSTORE_REG = 'SOFTWARE\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppModel\Repository\Packages';
  PACKAGEROOTFOLDER_KEY = 'PackageRootFolder';
var
  TempReg : TRegistry;
  TempKeys : TStringList;
  i : integer;
  TempKey, TempPath : string;
begin
  Result   := False;
  TempReg  := nil;
  TempKeys := nil;

  try
    try
      TempReg         := TRegistry.Create;
      TempReg.RootKey := HKEY_CURRENT_USER;

      if TempReg.OpenKeyReadOnly(APPSTORE_REG) then
        begin
          TempKeys := TStringList.Create;
          TempReg.GetKeyNames(TStrings(TempKeys));
          TempReg.CloseKey;

          i := 0;
          while (i < TempKeys.Count) and not(Result) do
            begin
              TempKey := TempKeys[i];

              if (pos('python', lowercase(TempKey)) > 0) and
                 TempReg.OpenKeyReadOnly(APPSTORE_REG + '\' + TempKey) then
                begin
                  if TempReg.ValueExists(PACKAGEROOTFOLDER_KEY) then
                    begin
                      TempPath := TempReg.ReadString(PACKAGEROOTFOLDER_KEY);

                      if PythonLibExists(TempPath) then
                        begin
                          aInstallPath := TempPath;
                          Result       := True;
                        end;
                    end;

                  TempReg.CloseKey;
                end;

              inc(i);
            end;
        end;
    except
      on e : exception do
        if CustomExceptionHandler('TP4PLoader.SearchMicrosoftStoreRegistry', e) then raise;
    end;
  finally
    if (TempReg  <> nil) then FreeAndNil(TempReg);
    if (TempKeys <> nil) then FreeAndNil(TempKeys);
  end;
end;

function TP4PLoader.SearchUninstallRegistry(const aRegPath: string; aLocalMachine : boolean; var aInstallPath: string): boolean;
const
  DISPLAYNAME_KEY     = 'DisplayName';
  INSTALLLOCATION_KEY = 'InstallLocation';
var
  TempReg : TRegistry;
  TempKeys : TStringList;
  i : integer;
  TempDisplayName, TempPath, TempKey : string;
begin
  Result   := False;
  TempReg  := nil;
  TempKeys := nil;

  try
    try
      TempReg := TRegistry.Create;

      if aLocalMachine then
        TempReg.RootKey := HKEY_LOCAL_MACHINE
       else
        TempReg.RootKey := HKEY_CURRENT_USER;

      if TempReg.OpenKeyReadOnly(aRegPath) then
        begin
          TempKeys := TStringList.Create;
          TempReg.GetKeyNames(TStrings(TempKeys));
          TempReg.CloseKey;

          i := 0;
          while (i < TempKeys.Count) and not(Result) do
            begin
              TempKey := TempKeys[i];

              if TempReg.OpenKeyReadOnly(aRegPath + '\' + TempKey) then
                begin
                  if TempReg.ValueExists(DISPLAYNAME_KEY) and
                     TempReg.ValueExists(INSTALLLOCATION_KEY) then
                    begin
                      TempDisplayName := lowercase(TempReg.ReadString(DISPLAYNAME_KEY));

                      if (Pos('python', TempDisplayName) > 0) then
                        begin
                          TempPath := TempReg.ReadString(INSTALLLOCATION_KEY);

                          if PythonLibExists(TempPath) then
                            begin
                              aInstallPath := TempPath;
                              Result       := True;
                            end;
                        end;
                    end;

                  TempReg.CloseKey;
                end;

              inc(i);
            end;
        end;
    except
      on e : exception do
        if CustomExceptionHandler('TP4PLoader.SearchUninstallRegistry', e) then raise;
    end;
  finally
    if (TempReg  <> nil) then FreeAndNil(TempReg);
    if (TempKeys <> nil) then FreeAndNil(TempKeys);
  end;
end;

function TP4PLoader.CheckDLLbitness(const aFilename : string): boolean;
var
  TempMachine : integer;
begin
  Result      := False;
  TempMachine := 0;

  if GetDLLHeaderMachine(aFilename, TempMachine) then
    case TempMachine of
      P4P_IMAGE_FILE_MACHINE_I386 :
        if Is32BitProcess then
          Result := True
         else
          begin
            FStatus           := plsErrorDLLVersion;
            FLastErrorMessage := 'Wrong Python binaries!' +
                                 CRLF + CRLF +
                                 'Use the 32 bit Python binaries with 32 bits applications only.';
          end;

      P4P_IMAGE_FILE_MACHINE_AMD64 :
        if not(Is32BitProcess) then
          Result := True
         else
          begin
            FStatus           := plsErrorDLLVersion;
            FLastErrorMessage := 'Wrong Python binaries!' +
                                 CRLF + CRLF +
                                 'Use the 64 bit Python binaries with 64 bits applications only.';
          end;

      else
        begin
          FStatus           := plsErrorDLLVersion;
          FLastErrorMessage := 'Unknown Python binaries!';
        end;
    end
   else
    Result := True;
end;

function TP4PLoader.FindPythonModule_win: boolean;
const
  MODULES_LENGTH = 4096;
var
  TempNeeded : DWORD;
  i, j : integer;
  TempProcHandle : THandle;
  TempModulesArray : array [0..MODULES_LENGTH] of HMODULE;
begin
  Result     := False;
  FLibHandle := GetModuleHandle(nil);

  if (FLibHandle = 0) then
    FLibHandle := LoadLibrary('');

  if (FLibHandle = 0) then exit;

  if HasPythonSymbols then
    begin
      Result := True;
      exit;
    end;

  FLibHandle     := 0;
  TempNeeded     := 0;
  TempProcHandle := OpenProcess(PROCESS_QUERY_INFORMATION or PROCESS_VM_READ, False, GetCurrentProcessId);

  if (TempProcHandle > 0) then
    try
      if EnumProcessModules(TempProcHandle, @TempModulesArray[0], MODULES_LENGTH * SizeOf(HMODULE), TempNeeded) then
        begin
          i := 0;
          j := min(MODULES_LENGTH, TempNeeded div SizeOf(HMODULE));

          while (i < j) do
            begin
              FLibHandle := TempModulesArray[i];

              if HasPythonSymbols then
                begin
                  Result := True;
                  break;
                end;

              inc(i);
            end;

          if not(Result) then
            FLibHandle := 0;
        end;
    finally
      CloseHandle(TempProcHandle);
    end
end;
{$ENDIF}

{$IFDEF LINUX}
function TP4PLoader.FindPythonModule_linux: boolean;
{$IFDEF LINUXFMX}
type
  plink_map = ^link_map;
  link_map = record
    l_addr : Pointer;
    l_name : PAnsiChar;
    l_ld   : Pointer;
    l_next : plink_map;
    l_prev : plink_map;
  end;
{$ENDIF}
var
  TempLinkMap : plink_map;
  TempPath    : AnsiString;
begin
  Result   := False;
  TempPath := '';
  {$IFDEF FPC}
  FLibHandle := TLibHandle(dlopen(PAnsiChar(TempPath), RTLD_LAZY + RTLD_GLOBAL));
  {$ELSE}
  FLibHandle := THandle(dlopen(PAnsiChar(TempPath), RTLD_LAZY + RTLD_GLOBAL));
  {$ENDIF}

  if IsHandleValid and HasPythonSymbols then
    begin
      Result := True;
      exit;
    end;

  FLibHandle  := 0;
  TempLinkMap := plink_map(dlopen(nil, RTLD_NOW));

  while assigned(TempLinkMap) do
    begin
      TempPath := AnsiString(TempLinkMap^.l_name);

      if (length(TempPath) > 0) and FileExists(TempPath) then
        begin
          {$IFDEF FPC}
          FLibHandle := TLibHandle(dlopen(PAnsiChar(TempPath), RTLD_LAZY + RTLD_GLOBAL));
          {$ELSE}
          FLibHandle := THandle(dlopen(PAnsiChar(TempPath), RTLD_LAZY + RTLD_GLOBAL));
          {$ENDIF}
          if HasPythonSymbols then
            begin
              Result := True;
              break;
            end;
        end;

      TempLinkMap := TempLinkMap^.l_next;
    end;

  if not(Result) then
    FLibHandle := 0;
end;
{$ENDIF}

{$IFDEF APPLE}
function TP4PLoader.FindPythonModule_apple: boolean;
var
  i, j : LongWord;
  TempName : PAnsiChar;
begin
  Result   := False;
  TempName := '';
  {$IFDEF FPC}
  FLibHandle := TLibHandle(dlopen(PAnsiChar(TempName), RTLD_LAZY + RTLD_GLOBAL));
  {$ELSE}
  FLibHandle := THandle(dlopen(PAnsiChar(TempName), RTLD_LAZY + RTLD_GLOBAL));
  {$ENDIF}

  if IsHandleValid and HasPythonSymbols then
    begin
      Result := True;
      exit;
    end;

  FLibHandle := 0;
  i          := 0;
  j          := _dyld_image_count();

  while (i < j) do
    begin
      TempName := _dyld_get_image_name(i);

      if FileExists(AnsiString(TempName)) then
        begin
          {$IFDEF FPC}
          FLibHandle := TLibHandle(dlopen(TempName, RTLD_LAZY + RTLD_GLOBAL));
          {$ELSE}
          FLibHandle := THandle(dlopen(TempName, RTLD_LAZY + RTLD_GLOBAL));
          {$ENDIF}
          if HasPythonSymbols then
            begin
              Result := True;
              break;
            end;
        end;

      inc(i);
    end;

  if not(Result) then
    FLibHandle := 0;
end;
{$ENDIF}

function TP4PLoader.HasPythonSymbols: boolean;
begin
  Load_pylifecycle;

  Result := TPy.IsInitialized and
            (length(TPy.GetBuildInfo) > 0);
end;

function TP4PLoader.FindPythonModule: boolean;
begin
  {$IFDEF MSWINDOWS}
  Result := FindPythonModule_win;
  {$ENDIF}

  {$IFDEF APPLE}
  Result := FindPythonModule_apple;
  {$ENDIF}

  {$IFDEF LINUX}
  Result := FindPythonModule_linux;
  {$ENDIF}

  {$IFDEF ANDROID}
  Result := False;
  {$ENDIF}
end;

function TP4PLoader.LoadInExtensionModule : boolean;
begin
  Result := False;

  if ModuleIsLib then
    begin
      FInExtensionModule := True;

      if FindPythonModule and
         GetFileVersion(FFileVersion) then
        begin
          if (FFileVersion.Major = SUPPORTED_MAJOR_VERSION) and
             (FFileVersion.Minor >= MIN_SUPPORTED_MINOR_VERSION) and
             (FFileVersion.Minor <= MAX_SUPPORTED_MINOR_VERSION) then
            begin
              LoadAllFunctions;
              FStatus := plsLoaded;
              Initialize;
              FMustFreeLibrary := False;
              Result := True;
            end
           else
            begin
              FLastErrorMessage := FLastErrorMessage + CRLF + 'Unknown Python library version.';
              FStatus           := plsErrorDLLVersion;
            end;
        end
       else
        begin
          FLastErrorMessage := FLastErrorMessage + CRLF + 'Python library not available.';
          FStatus           := plsErrorInitializingExtensionModule;
        end;
    end
   else
    begin
      FLastErrorMessage := FLastErrorMessage + CRLF + 'LoadInExtensionModule can only be used by a module.';
      FStatus           := plsErrorInitializingExtensionModule;
    end;
end;

function TP4PLoader.Load(const aLibraryPath: string) : boolean;
var
  {$IFDEF MSWINDOWS}TempLibPath, TempPackagesPath,{$ENDIF} TempPath : string;
  TempValidPath : boolean;
begin
  Result            := False;
  FLastErrorMessage := '';
  TempValidPath     := (length(aLibraryPath) > 0) and FileExists(aLibraryPath);

  {$IFDEF MSWINDOWS}
  if (length(FHome) = 0) then
    begin
      if TempValidPath then
        FHome := ExtractFilePath(aLibraryPath)
       else
        FHome := OSPythonHome;
    end;

  if (length(FModuleSearchPaths) = 0) and (length(FHome) > 0) then
    begin
      TempLibPath      := IncludeTrailingPathDelimiter(FHome) + 'Lib';
      TempPackagesPath := IncludeTrailingPathDelimiter(TempLibPath) + 'site-packages';

      if DirectoryExists(TempLibPath) and
         DirectoryExists(TempPackagesPath) then
        FModuleSearchPaths := TempLibPath + PathSep + TempPackagesPath;
    end;
  {$ENDIF}

  if TempValidPath then
    TempPath := aLibraryPath
   else
    TempPath := OSPythonLibPath;

  {$IFDEF MSWINDOWS}
  if not(CheckDLLbitness(TempPath)) then exit;
  {$ENDIF}

  if ReadLibraryVersionInfo(TempPath) and
     LoadPythonLibrary(TempPath) then
    begin
      LoadAllFunctions;
      GetFileVersion(FFileVersion);
      FStatus := plsLoaded;
      Result  := True;
    end
   else
    ShowErrorMessageDlg(FLastErrorMessage);
end;

procedure TP4PLoader.SetProgramArgs_PEP741(const aConfig : IPyInitConfig);
var
  i          : integer;
  TempParams : TStringDynArray;
begin
  aConfig.parse_argv := False;
  TempParams         := nil;

  SetLength(TempParams, succ(ParamCount));

  for i := 0 to ParamCount do
    if i = 0 then
      TempParams[i] := ''
     else
      TempParams[i] := ParamStr(i);

  aConfig.argv := TempParams;
end;

procedure TP4PLoader.SetProgramArgs_PEP587(const aConfig : IPyConfig);
var
  i          : integer;
  TempParams : TStringDynArray;
begin
  aConfig.parse_argv := False;  
  TempParams         := nil;

  SetLength(TempParams, succ(ParamCount));

  for i := 0 to ParamCount do
    if i = 0 then
      TempParams[i] := ''
     else
      TempParams[i] := ParamStr(i);

  aConfig.argv := TempParams;
end;

function TP4PLoader.Initialize_PEP741: boolean;
var
  TempConfig : IPyInitConfig;
begin
  Result := False;

  try
    TempConfig := TPyInitConfig.Create;

    if TempConfig.Initialized then
      begin
        TempConfig.isolated            := FIsolated;
        TempConfig.parser_debug        := FParserDebug;
        TempConfig.verbose             := FVerbose;
        TempConfig.interactive         := FInteractive;
        TempConfig.optimization_level  := FOptimizationLevel;
        TempConfig.site_import         := FSiteImport;
        TempConfig.pathconfig_warnings := FPathconfigWarnings;
        TempConfig.use_environment     := FUseEnvironment;
        TempConfig.user_site_directory := FUserSiteDirectory;
        TempConfig.write_bytecode      := FWriteBytecode;
        TempConfig.dev_mode            := FDevMode;
        TempConfig.home                := FHome;
        TempConfig.executable          := FExecutable;
        TempConfig.program_name        := FProgramName;
        TempConfig.module_search_paths := FModuleSearchPaths;
        TempConfig.lazy_imports        := FLazyImports;

        SetProgramArgs_PEP741(TempConfig);

        doOnBeforeInitialization(TempConfig);

        if TPy.InitializeFromInitConfig(TempConfig) and
           TPy.IsInitialized then
          begin
            FStatus := plsInitialized;
            Result  := True;
          end
         else
          begin
            FStatus           := plsErrorInitializingLibrary;
            FLastErrorMessage := TempConfig.Error + CRLF +
                                 'Exit code: ' + inttostr(TempConfig.ExitCode);
          end;
      end;
  finally
    TempConfig := nil;
  end;
end;

function TP4PLoader.Initialize_PEP587: boolean;
var
  TempConfig : IPyConfig;
  TempStatus : IPyStatus;
begin
  Result := False;

  try
    TempConfig := TPyConfigBuilder.New(FFileVersion.Major, FFileVersion.Minor);

    if not(assigned(TempConfig)) then
      begin
        FStatus := plsErrorDLLVersion;
        exit;
      end;

    if FIsolated then
      TempConfig.InitIsolatedConfig
     else
      TempConfig.InitPythonConfig;

    TempConfig.isolated                := FIsolated;
    TempConfig.parser_debug            := FParserDebug;
    TempConfig.verbose                 := FVerbose;
    TempConfig.interactive             := FInteractive;
    TempConfig.optimization_level      := FOptimizationLevel;
    TempConfig.site_import             := FSiteImport;
    TempConfig.pathconfig_warnings     := FPathconfigWarnings;
    TempConfig.use_environment         := FUseEnvironment;
    TempConfig.user_site_directory     := FUserSiteDirectory;
    TempConfig.write_bytecode          := FWriteBytecode;       
    TempConfig.dev_mode                := FDevMode;
    TempConfig.home                    := FHome;
    TempConfig.executable              := FExecutable;
    TempConfig.program_name            := FProgramName;
    TempConfig.module_search_paths     := FModuleSearchPaths;
    TempConfig.module_search_paths_set := (length(FModuleSearchPaths) > 0);
    TempConfig.lazy_imports            := FLazyImports;

    SetProgramArgs_PEP587(TempConfig);

    doOnBeforeInitialization(nil, TempConfig);
    TempStatus := TPy.InitializeFromConfig(TempConfig.Config);

    if assigned(TempStatus) then
      begin
        if TempStatus.IsException then
          begin
            FStatus           := plsErrorInitializingLibrary;
            FLastErrorMessage := TempStatus.ErrMsg + CRLF +
                                 'Exit code: ' + inttostr(TempStatus.ExitCode);
          end
         else
          if TPy.IsInitialized then
            begin
              FStatus := plsInitialized;
              Result  := True;
            end
           else
            FStatus := plsErrorInitializingLibrary;
      end
     else
      FStatus := plsErrorInitializingLibrary;
  finally
    TempConfig := nil;
  end;
end;

function TP4PLoader.Initialize: boolean;
begin
  Result := False;
  if (FStatus <> plsLoaded) then exit;

  if FInExtensionModule then
    begin
      FStatus := plsInitialized;
      Result  := True;
    end
   else
    if PythonLibIsGreaterOrEqualThan(3, 14, 0) then
      Result := Initialize_PEP741
     else
      Result := Initialize_PEP587;
end;

function TP4PLoader.Version(var aMajor, aMinor, aMicro: integer): boolean;
var
  TempVersion : C_ULong;
begin
  Result := False;

  if assigned(Py_Version) then
    begin
      TempVersion := Py_Version^;
      aMajor      := byte((TempVersion and $FF000000) shr 24);
      aMinor      := byte((TempVersion and $00FF0000) shr 16);
      aMicro      := byte((TempVersion and $0000FF00) shr 8);
      Result      := True;
    end;
end;

function TP4PLoader.GetVersion(var aMajor, aMinor, aMicro: integer): boolean;
var
  TempVersion : string;
  i, TempMajor, TempMinor, TempMicro : integer;
begin
  Result := False;

  // "3.0a5+ (py3k:63103M, May 12 2008, 00:53:55) \n[GCC 4.2.3]"
  // "3.14.3 (tags/v3.14.3:323c59a, Feb  3 2026, 15:53:00) [MSC v.1944 32 bit (Intel)]"
  TempVersion := trim(TPy.GetVersion);

  i := pos(' ', TempVersion);
  if (i <= 0) then exit;

  TempVersion := copy(TempVersion, 1, pred(i));
  if (length(TempVersion) = 0) then exit;

  i := pos('.', TempVersion);
  if (i <= 0) then exit;

  if not(TryStrToInt(copy(TempVersion, 1, pred(i)), TempMajor)) then exit;

  TempVersion := copy(TempVersion, succ(i), length(TempVersion));

  i := pos('.', TempVersion);
  if (i > 0) then
    begin
      if not(TryStrToInt(copy(TempVersion, 1, pred(i)), TempMinor)) then exit;

      TempVersion := copy(TempVersion, succ(i), length(TempVersion));

      i := 1;
      while (i <= length(TempVersion)) and CharInSet(TempVersion[i], ['0'..'9']) do
        inc(i);

      if TryStrToInt(copy(TempVersion, 1, pred(i)), TempMicro) then
        begin
          aMajor := TempMajor;
          aMinor := TempMinor;
          aMicro := TempMicro;
          Result := True;
        end;
    end
   else
    begin
      i := 1;
      while (i <= length(TempVersion)) and CharInSet(TempVersion[i], ['0'..'9']) do
        inc(i);

      if TryStrToInt(copy(TempVersion, 1, pred(i)), TempMinor) then
        begin
          aMajor := TempMajor;
          aMinor := TempMinor;
          aMicro := 0;
          Result := True;
        end;
    end;
end;

function TP4PLoader.GetFileVersion(var aFileVersion : TFileVersionInfo): boolean;
var
  TempMajor, TempMinor, TempMicro : integer;
begin
  Result    := False;
  TempMajor := 0;
  TempMinor := 0;
  TempMicro := 0;

  if Version(TempMajor, TempMinor, TempMicro) or
     GetVersion(TempMajor, TempMinor, TempMicro) then
    begin
      aFileVersion.Major := uint16(TempMajor);
      aFileVersion.Minor := uint16(TempMinor);
      aFileVersion.Micro := uint16(TempMicro);
      Result             := True;
    end;
end;

procedure TP4PLoader.Finalize;
begin
  try
    TPy.Finalize;
  except
    on e : exception do
      if CustomExceptionHandler('TP4PLoader.Finalize', e) then raise;
  end;
end;

procedure TP4PLoader.doOnBeforeInitialization(const aInitConfig: IPyInitConfig; const aConfig: IPyConfig);
begin
  if assigned(FOnBeforeInitialization) then
    FOnBeforeInitialization(self, aInitConfig, aConfig);
end;

procedure TP4PLoader.LoadAllFunctions;
begin
  Load_pymacro;
  Load_pymem;
  Load_pybuffer;
  Load_lock;
  Load_critical_section;
  Load_object;
  Load_refcount;
  Load_objimpl;
  Load_pyhash;
  Load_pydebug;
  Load_bytearrayobject;
  Load_bytesobject;
  Load_unicodeobject;
  Load_pyerrors;
  Load_longobject;
  Load_longintrepr;
  Load_boolobject;
  Load_floatobject;
  Load_complexobject;
  Load_rangeobject;
  Load_memoryobject;
  Load_tupleobject;
  Load_listobject;
  Load_dictobject;
  Load_odictobject;
  Load_enumobject;
  Load_setobject;
  Load_methodobject;
  Load_moduleobject;
  Load_monitoring;
  Load_funcobject;
  Load_classobject;
  Load_fileobject;
  Load_pycapsule;
  Load_code;
  Load_pyframe;
  Load_traceback;
  Load_sliceobject;
  Load_cellobject;
  Load_iterobject;
  Load_initconfig;
  Load_pystate;
  Load_genobject;
  Load_descrobject;
  Load_genericaliasobject;
  Load_sentinelobject;
  Load_warnings;
  Load_weakrefobject;
  Load_structseq;
  Load_picklebufobject;
  Load_pytime;
  Load_codecs;
  Load_pythread;
  Load_context;
  Load_modsupport;
  Load_compile;
  Load_pythonrun;
  Load_pylifecycle;
  Load_ceval;
  Load_sysmodule;
  Load_audit;
  Load_osmodule;
  Load_intrcheck;
  Load_import;
  Load_abstract;
  Load_bltinmodule;
  Load_pystrtod;
  Load_pystrcmp;
  Load_fileutils;
  Load_tracemalloc;
  Load_frameobject;
end;

procedure TP4PLoader.Load_pymacro;
begin
  {$IFDEF FPC}Pointer({$ENDIF}Py_PACK_FULL_VERSION{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'Py_PACK_FULL_VERSION');
  {$IFDEF FPC}Pointer({$ENDIF}Py_PACK_VERSION{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'Py_PACK_VERSION');
end;

procedure TP4PLoader.Load_pymem;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyMem_Malloc{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyMem_Malloc');
  {$IFDEF FPC}Pointer({$ENDIF}PyMem_Calloc{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyMem_Calloc');
  {$IFDEF FPC}Pointer({$ENDIF}PyMem_Realloc{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyMem_Realloc');
  {$IFDEF FPC}Pointer({$ENDIF}PyMem_Free{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyMem_Free');
  {$IFDEF FPC}Pointer({$ENDIF}PyMem_RawMalloc{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyMem_RawMalloc');
  {$IFDEF FPC}Pointer({$ENDIF}PyMem_RawCalloc{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyMem_RawCalloc');
  {$IFDEF FPC}Pointer({$ENDIF}PyMem_RawRealloc{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyMem_RawRealloc');
  {$IFDEF FPC}Pointer({$ENDIF}PyMem_RawFree{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyMem_RawFree');
  {$IFDEF FPC}Pointer({$ENDIF}PyMem_GetAllocator{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyMem_GetAllocator');
  {$IFDEF FPC}Pointer({$ENDIF}PyMem_SetAllocator{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyMem_SetAllocator');
  {$IFDEF FPC}Pointer({$ENDIF}PyMem_SetupDebugHooks{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyMem_SetupDebugHooks');
end;

procedure TP4PLoader.Load_pybuffer;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_CheckBuffer{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyObject_CheckBuffer');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GetBuffer{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyObject_GetBuffer');
  {$IFDEF FPC}Pointer({$ENDIF}PyBuffer_GetPointer{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyBuffer_GetPointer');
  {$IFDEF FPC}Pointer({$ENDIF}PyBuffer_SizeFromFormat{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyBuffer_SizeFromFormat');
  {$IFDEF FPC}Pointer({$ENDIF}PyBuffer_ToContiguous{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyBuffer_ToContiguous');
  {$IFDEF FPC}Pointer({$ENDIF}PyBuffer_FromContiguous{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyBuffer_FromContiguous');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_CopyData{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyObject_CopyData');
  {$IFDEF FPC}Pointer({$ENDIF}PyBuffer_IsContiguous{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyBuffer_IsContiguous');
  {$IFDEF FPC}Pointer({$ENDIF}PyBuffer_FillContiguousStrides{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyBuffer_FillContiguousStrides');
  {$IFDEF FPC}Pointer({$ENDIF}PyBuffer_FillInfo{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyBuffer_FillInfo');
  {$IFDEF FPC}Pointer({$ENDIF}PyBuffer_Release{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyBuffer_Release');
end;

procedure TP4PLoader.Load_lock;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyMutex_Lock{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyMutex_Lock');
  {$IFDEF FPC}Pointer({$ENDIF}PyMutex_Unlock{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyMutex_Unlock');
  {$IFDEF FPC}Pointer({$ENDIF}PyMutex_IsLocked{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyMutex_IsLocked');
end;

procedure TP4PLoader.Load_critical_section;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyCriticalSection_Begin{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyCriticalSection_Begin');
  {$IFDEF FPC}Pointer({$ENDIF}PyCriticalSection_BeginMutex{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyCriticalSection_BeginMutex');
  {$IFDEF FPC}Pointer({$ENDIF}PyCriticalSection_End{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyCriticalSection_End');
  {$IFDEF FPC}Pointer({$ENDIF}PyCriticalSection2_Begin{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyCriticalSection2_Begin');
  {$IFDEF FPC}Pointer({$ENDIF}PyCriticalSection2_BeginMutex{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyCriticalSection2_BeginMutex');
  {$IFDEF FPC}Pointer({$ENDIF}PyCriticalSection2_End{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyCriticalSection2_End');
end;

procedure TP4PLoader.Load_object;
begin
  {$IFDEF FPC}Pointer({$ENDIF}Py_Is{$IFDEF FPC}){$ENDIF}                             := GetProcAddress(FLibHandle, 'Py_Is');
  {$IFDEF FPC}Pointer({$ENDIF}Py_TYPE{$IFDEF FPC}){$ENDIF}                           := GetProcAddress(FLibHandle, 'Py_TYPE');
  {$IFDEF FPC}Pointer({$ENDIF}Py_SIZE{$IFDEF FPC}){$ENDIF}                           := GetProcAddress(FLibHandle, 'Py_SIZE');
  {$IFDEF FPC}Pointer({$ENDIF}Py_IS_TYPE{$IFDEF FPC}){$ENDIF}                        := GetProcAddress(FLibHandle, 'Py_IS_TYPE');
  {$IFDEF FPC}Pointer({$ENDIF}Py_SET_SIZE{$IFDEF FPC}){$ENDIF}                       := GetProcAddress(FLibHandle, 'Py_SET_SIZE');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_Type{$IFDEF FPC}){$ENDIF}                       := GetProcAddress(FLibHandle, 'PyLong_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyBool_Type{$IFDEF FPC}){$ENDIF}                       := GetProcAddress(FLibHandle, 'PyBool_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_FromSpec{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyType_FromSpec');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_FromSpecWithBases{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyType_FromSpecWithBases');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetSlot{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyType_GetSlot');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_FromModuleAndSpec{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyType_FromModuleAndSpec');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetModule{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyType_GetModule');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetModuleState{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyType_GetModuleState');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetName{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyType_GetName');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetQualName{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyType_GetQualName');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetFullyQualifiedName{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyType_GetFullyQualifiedName');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetModuleName{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyType_GetModuleName');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_FromMetaclass{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyType_FromMetaclass');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GetTypeData{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyObject_GetTypeData');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetTypeDataSize{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyType_GetTypeDataSize');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetBaseByToken{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyType_GetBaseByToken');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_FromSlots{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyType_FromSlots');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_IsSubtype{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyType_IsSubtype');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_Type{$IFDEF FPC}){$ENDIF}                       := GetProcAddress(FLibHandle, 'PyType_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyBaseObject_Type{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyBaseObject_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PySuper_Type{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PySuper_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetFlags{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyType_GetFlags');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_Ready{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyType_Ready');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GenericAlloc{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyType_GenericAlloc');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GenericNew{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyType_GenericNew');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_ClearCache{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyType_ClearCache');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_Modified{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyType_Modified');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Repr{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'PyObject_Repr');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Str{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyObject_Str');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_ASCII{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyObject_ASCII');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Bytes{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyObject_Bytes');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_RichCompare{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyObject_RichCompare');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_RichCompareBool{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyObject_RichCompareBool');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GetAttrString{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyObject_GetAttrString');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_SetAttrString{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyObject_SetAttrString');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_DelAttrString{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyObject_DelAttrString');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_HasAttrString{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyObject_HasAttrString');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GetAttr{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyObject_GetAttr');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GetOptionalAttr{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyObject_GetOptionalAttr');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GetOptionalAttrString{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyObject_GetOptionalAttrString');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_SetAttr{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyObject_SetAttr');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_DelAttr{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyObject_DelAttr');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_HasAttr{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyObject_HasAttr');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_HasAttrWithError{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyObject_HasAttrWithError');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_HasAttrStringWithError{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyObject_HasAttrStringWithError');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_SelfIter{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyObject_SelfIter');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GenericGetAttr{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyObject_GenericGetAttr');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GenericSetAttr{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyObject_GenericSetAttr');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GenericSetDict{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyObject_GenericSetDict');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Hash{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'PyObject_Hash');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_HashNotImplemented{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyObject_HashNotImplemented');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_IsTrue{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyObject_IsTrue');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Not{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyObject_Not');
  {$IFDEF FPC}Pointer({$ENDIF}PyCallable_Check{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyCallable_Check');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_ClearWeakRefs{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyObject_ClearWeakRefs');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Dir{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyObject_Dir');
  {$IFDEF FPC}Pointer({$ENDIF}Py_ReprEnter{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'Py_ReprEnter');
  {$IFDEF FPC}Pointer({$ENDIF}Py_ReprLeave{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'Py_ReprLeave');
  {$IFDEF FPC}Pointer({$ENDIF}Py_GetConstant{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'Py_GetConstant');
  {$IFDEF FPC}Pointer({$ENDIF}Py_GetConstantBorrowed{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'Py_GetConstantBorrowed');
  {$IFDEF FPC}Pointer({$ENDIF}Py_None{$IFDEF FPC}){$ENDIF}                           := GetProcAddress(FLibHandle, '_Py_NoneStruct');
  {$IFDEF FPC}Pointer({$ENDIF}Py_NotImplemented{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, '_Py_NotImplementedStruct');
  {$IFDEF FPC}Pointer({$ENDIF}Py_IsNone{$IFDEF FPC}){$ENDIF}                         := GetProcAddress(FLibHandle, 'Py_IsNone');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetModuleByDef{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyType_GetModuleByDef');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_Freeze{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'PyType_Freeze');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetModuleByToken{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyType_GetModuleByToken');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GetTypeData_DuringGC{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyObject_GetTypeData_DuringGC');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetModuleState_DuringGC{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyType_GetModuleState_DuringGC');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetBaseByToken_DuringGC{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyType_GetBaseByToken_DuringGC');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetModule_DuringGC{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyType_GetModule_DuringGC');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetModuleByToken_DuringGC{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyType_GetModuleByToken_DuringGC');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_GetDict{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyType_GetDict');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Print{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyObject_Print');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Dump{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'PyObject_Dump');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_CallFinalizer{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyObject_CallFinalizer');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_CallFinalizerFromDealloc{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyObject_CallFinalizerFromDealloc');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GetItemData{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyObject_GetItemData');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GetItemData_DuringGC{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyObject_GetItemData_DuringGC');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_VisitManagedDict{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyObject_VisitManagedDict');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_ClearManagedDict{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyObject_ClearManagedDict');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_AddWatcher{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyType_AddWatcher');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_ClearWatcher{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyType_ClearWatcher');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_Watch{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyType_Watch');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_Unwatch{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyType_Unwatch');
  {$IFDEF FPC}Pointer({$ENDIF}PyRefTracer_SetTracer{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyRefTracer_SetTracer');
  {$IFDEF FPC}Pointer({$ENDIF}PyRefTracer_GetTracer{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyRefTracer_GetTracer');
end;

procedure TP4PLoader.Load_refcount;
begin
  {$IFDEF FPC}Pointer({$ENDIF}Py_REFCNT{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'Py_REFCNT');
  {$IFDEF FPC}Pointer({$ENDIF}Py_SET_REFCNT{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, '_Py_SetRefcnt');
  {$IFDEF FPC}Pointer({$ENDIF}Py_IncRef{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'Py_IncRef');
  {$IFDEF FPC}Pointer({$ENDIF}Py_DecRef{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'Py_DecRef');
  {$IFDEF FPC}Pointer({$ENDIF}Py_NewRef{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'Py_NewRef');
  {$IFDEF FPC}Pointer({$ENDIF}Py_XNewRef{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'Py_XNewRef');
end;

procedure TP4PLoader.Load_objimpl;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Malloc{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyObject_Malloc');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Calloc{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyObject_Calloc');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Realloc{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyObject_Realloc');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Free{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyObject_Free');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Init{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyObject_Init');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_InitVar{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyObject_InitVar');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_New{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, '_PyObject_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_NewVar{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, '_PyObject_NewVar');
  {$IFDEF FPC}Pointer({$ENDIF}PyGC_Collect{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyGC_Collect');
  {$IFDEF FPC}Pointer({$ENDIF}PyGC_Enable{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyGC_Enable');
  {$IFDEF FPC}Pointer({$ENDIF}PyGC_Disable{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyGC_Disable');
  {$IFDEF FPC}Pointer({$ENDIF}PyGC_IsEnabled{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyGC_IsEnabled');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GC_Resize{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, '_PyObject_GC_Resize');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GC_New{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, '_PyObject_GC_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GC_NewVar{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, '_PyObject_GC_NewVar');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GC_Track{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyObject_GC_Track');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GC_UnTrack{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyObject_GC_UnTrack');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GC_Del{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyObject_GC_Del');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GC_IsTracked{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyObject_GC_IsTracked');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GC_IsFinalized{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyObject_GC_IsFinalized');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GetArenaAllocator{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyObject_GetArenaAllocator');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_SetArenaAllocator{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyObject_SetArenaAllocator');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_IS_GC{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyObject_IS_GC');
  {$IFDEF FPC}Pointer({$ENDIF}PyType_SUPPORTS_WEAKREFS{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyType_SUPPORTS_WEAKREFS');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GET_WEAKREFS_LISTPTR{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyObject_GET_WEAKREFS_LISTPTR');
end;

procedure TP4PLoader.Load_pyhash;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyHash_GetFuncDef{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyHash_GetFuncDef');
  {$IFDEF FPC}Pointer({$ENDIF}Py_HashPointer{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'Py_HashPointer');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GenericHash{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyObject_GenericHash');
  {$IFDEF FPC}Pointer({$ENDIF}Py_HashBuffer{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'Py_HashBuffer');
end;

procedure TP4PLoader.Load_pydebug;
begin
  {$IFDEF FPC}Pointer({$ENDIF}Py_GETENV{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'Py_GETENV');
end;

procedure TP4PLoader.Load_bytearrayobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyByteArray_Type{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyByteArray_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyByteArrayIter_Type{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyByteArrayIter_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyByteArray_FromObject{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyByteArray_FromObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyByteArray_Concat{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyByteArray_Concat');
  {$IFDEF FPC}Pointer({$ENDIF}PyByteArray_FromStringAndSize{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyByteArray_FromStringAndSize');
  {$IFDEF FPC}Pointer({$ENDIF}PyByteArray_Size{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyByteArray_Size');
  {$IFDEF FPC}Pointer({$ENDIF}PyByteArray_AsString{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyByteArray_AsString');
  {$IFDEF FPC}Pointer({$ENDIF}PyByteArray_Resize{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyByteArray_Resize');
end;

procedure TP4PLoader.Load_bytesobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyBytes_Type{$IFDEF FPC}){$ENDIF}                        := GetProcAddress(FLibHandle, 'PyBytes_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytesIter_Type{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyBytesIter_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytes_FromStringAndSize{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyBytes_FromStringAndSize');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytes_FromString{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyBytes_FromString');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytes_FromObject{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyBytes_FromObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytes_FromFormat{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyBytes_FromFormat');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytes_Size{$IFDEF FPC}){$ENDIF}                        := GetProcAddress(FLibHandle, 'PyBytes_Size');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytes_AsString{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyBytes_AsString');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytes_Repr{$IFDEF FPC}){$ENDIF}                        := GetProcAddress(FLibHandle, 'PyBytes_Repr');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytes_Concat{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyBytes_Concat');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytes_ConcatAndDel{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyBytes_ConcatAndDel');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytes_DecodeEscape{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyBytes_DecodeEscape');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytes_AsStringAndSize{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyBytes_AsStringAndSize');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytes_Join{$IFDEF FPC}){$ENDIF}                        := GetProcAddress(FLibHandle, 'PyBytes_Join');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytesWriter_Create{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyBytesWriter_Create');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytesWriter_Discard{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyBytesWriter_Discard');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytesWriter_Finish{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyBytesWriter_Finish');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytesWriter_FinishWithSize{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyBytesWriter_FinishWithSize');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytesWriter_FinishWithPointer{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyBytesWriter_FinishWithPointer');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytesWriter_GetData{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyBytesWriter_GetData');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytesWriter_GetSize{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyBytesWriter_GetSize');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytesWriter_WriteBytes{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyBytesWriter_WriteBytes');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytesWriter_Format{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyBytesWriter_Format');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytesWriter_Resize{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyBytesWriter_Resize');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytesWriter_Grow{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyBytesWriter_Grow');
  {$IFDEF FPC}Pointer({$ENDIF}PyBytesWriter_GrowAndUpdatePointer{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyBytesWriter_GrowAndUpdatePointer');
end;

procedure TP4PLoader.Load_unicodeobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Type{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyUnicode_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeIter_Type{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyUnicodeIter_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_FromStringAndSize{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyUnicode_FromStringAndSize');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_FromString{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicode_FromString');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Substring{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyUnicode_Substring');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AsUCS4{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyUnicode_AsUCS4');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AsUCS4Copy{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicode_AsUCS4Copy');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_GetLength{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyUnicode_GetLength');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_ReadChar{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyUnicode_ReadChar');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_WriteChar{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyUnicode_WriteChar');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Resize{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyUnicode_Resize');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_FromEncodedObject{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyUnicode_FromEncodedObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_FromObject{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicode_FromObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_FromFormat{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicode_FromFormat');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_InternInPlace{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyUnicode_InternInPlace');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_InternFromString{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyUnicode_InternFromString');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_FromWideChar{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyUnicode_FromWideChar');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AsWideChar{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicode_AsWideChar');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AsWideCharString{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyUnicode_AsWideCharString');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_FromOrdinal{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyUnicode_FromOrdinal');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_GetDefaultEncoding{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyUnicode_GetDefaultEncoding');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Decode{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyUnicode_Decode');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AsEncodedString{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyUnicode_AsEncodedString');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_BuildEncodingMap{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyUnicode_BuildEncodingMap');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeUTF7{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicode_DecodeUTF7');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeUTF7Stateful{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyUnicode_DecodeUTF7Stateful');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeUTF8{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicode_DecodeUTF8');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeUTF8Stateful{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyUnicode_DecodeUTF8Stateful');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AsUTF8String{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyUnicode_AsUTF8String');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AsUTF8AndSize{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyUnicode_AsUTF8AndSize');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeUTF32{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyUnicode_DecodeUTF32');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeUTF32Stateful{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyUnicode_DecodeUTF32Stateful');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AsUTF32String{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyUnicode_AsUTF32String');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeUTF16{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyUnicode_DecodeUTF16');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeUTF16Stateful{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyUnicode_DecodeUTF16Stateful');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AsUTF16String{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyUnicode_AsUTF16String');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeUnicodeEscape{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyUnicode_DecodeUnicodeEscape');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AsUnicodeEscapeString{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyUnicode_AsUnicodeEscapeString');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeRawUnicodeEscape{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyUnicode_DecodeRawUnicodeEscape');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AsRawUnicodeEscapeString{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyUnicode_AsRawUnicodeEscapeString');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeLatin1{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyUnicode_DecodeLatin1');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AsLatin1String{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyUnicode_AsLatin1String');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeASCII{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyUnicode_DecodeASCII');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AsASCIIString{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyUnicode_AsASCIIString');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeCharmap{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyUnicode_DecodeCharmap');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AsCharmapString{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyUnicode_AsCharmapString');
  {$IFDEF MSWINDOWS}
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeMBCS{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicode_DecodeMBCS');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeMBCSStateful{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyUnicode_DecodeMBCSStateful');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeCodePageStateful{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyUnicode_DecodeCodePageStateful');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AsMBCSString{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyUnicode_AsMBCSString');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_EncodeCodePage{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyUnicode_EncodeCodePage');
  {$ENDIF}
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeLocaleAndSize{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyUnicode_DecodeLocaleAndSize');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeLocale{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyUnicode_DecodeLocale');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_EncodeLocale{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyUnicode_EncodeLocale');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_FSConverter{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyUnicode_FSConverter');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_FSDecoder{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyUnicode_FSDecoder');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeFSDefault{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyUnicode_DecodeFSDefault');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DecodeFSDefaultAndSize{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyUnicode_DecodeFSDefaultAndSize');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_EncodeFSDefault{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyUnicode_EncodeFSDefault');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Concat{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyUnicode_Concat');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Append{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyUnicode_Append');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AppendAndDel{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyUnicode_AppendAndDel');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Split{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'PyUnicode_Split');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Splitlines{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicode_Splitlines');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Partition{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyUnicode_Partition');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_RPartition{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicode_RPartition');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_RSplit{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyUnicode_RSplit');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Translate{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyUnicode_Translate');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Join{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyUnicode_Join');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Tailmatch{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyUnicode_Tailmatch');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Find{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyUnicode_Find');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_FindChar{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyUnicode_FindChar');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Count{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'PyUnicode_Count');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Replace{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyUnicode_Replace');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Compare{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyUnicode_Compare');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_CompareWithASCIIString{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyUnicode_CompareWithASCIIString');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_EqualToUTF8{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyUnicode_EqualToUTF8');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_EqualToUTF8AndSize{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyUnicode_EqualToUTF8AndSize');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Equal{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'PyUnicode_Equal');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_RichCompare{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyUnicode_RichCompare');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Format{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyUnicode_Format');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Contains{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyUnicode_Contains');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_IsIdentifier{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyUnicode_IsIdentifier');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_KIND{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyUnicode_KIND');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_DATA{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyUnicode_DATA');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_New{$IFDEF FPC}){$ENDIF}                       := GetProcAddress(FLibHandle, 'PyUnicode_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_CopyCharacters{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyUnicode_CopyCharacters');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_Fill{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyUnicode_Fill');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_FromKindAndData{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyUnicode_FromKindAndData');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeWriter_Create{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyUnicodeWriter_Create');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeWriter_Discard{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyUnicodeWriter_Discard');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeWriter_Finish{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyUnicodeWriter_Finish');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeWriter_WriteChar{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyUnicodeWriter_WriteChar');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeWriter_WriteUTF8{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyUnicodeWriter_WriteUTF8');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeWriter_WriteASCII{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyUnicodeWriter_WriteASCII');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeWriter_WriteWideChar{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyUnicodeWriter_WriteWideChar');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeWriter_WriteUCS4{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyUnicodeWriter_WriteUCS4');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeWriter_WriteStr{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyUnicodeWriter_WriteStr');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeWriter_WriteRepr{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyUnicodeWriter_WriteRepr');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeWriter_WriteSubstring{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyUnicodeWriter_WriteSubstring');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeWriter_Format{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyUnicodeWriter_Format');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeWriter_DecodeUTF8Stateful{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyUnicodeWriter_DecodeUTF8Stateful');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicode_AsUTF8{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyUnicode_AsUTF8');
end;

procedure TP4PLoader.Load_pyerrors;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetNone{$IFDEF FPC}){$ENDIF}                                 := GetProcAddress(FLibHandle, 'PyErr_SetNone');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetObject{$IFDEF FPC}){$ENDIF}                               := GetProcAddress(FLibHandle, 'PyErr_SetObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetString{$IFDEF FPC}){$ENDIF}                               := GetProcAddress(FLibHandle, 'PyErr_SetString');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_Occurred{$IFDEF FPC}){$ENDIF}                                := GetProcAddress(FLibHandle, 'PyErr_Occurred');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_Clear{$IFDEF FPC}){$ENDIF}                                   := GetProcAddress(FLibHandle, 'PyErr_Clear');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_Fetch{$IFDEF FPC}){$ENDIF}                                   := GetProcAddress(FLibHandle, 'PyErr_Fetch');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_Restore{$IFDEF FPC}){$ENDIF}                                 := GetProcAddress(FLibHandle, 'PyErr_Restore');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_GetRaisedException{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyErr_GetRaisedException');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetRaisedException{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyErr_SetRaisedException');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_GetHandledException{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'PyErr_GetHandledException');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetHandledException{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'PyErr_SetHandledException');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_GetExcInfo{$IFDEF FPC}){$ENDIF}                              := GetProcAddress(FLibHandle, 'PyErr_GetExcInfo');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetExcInfo{$IFDEF FPC}){$ENDIF}                              := GetProcAddress(FLibHandle, 'PyErr_SetExcInfo');
  {$IFDEF FPC}Pointer({$ENDIF}Py_FatalError{$IFDEF FPC}){$ENDIF}                                 := GetProcAddress(FLibHandle, 'Py_FatalError');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_GivenExceptionMatches{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyErr_GivenExceptionMatches');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_ExceptionMatches{$IFDEF FPC}){$ENDIF}                        := GetProcAddress(FLibHandle, 'PyErr_ExceptionMatches');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_NormalizeException{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyErr_NormalizeException');
  {$IFDEF FPC}Pointer({$ENDIF}PyException_SetTraceback{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyException_SetTraceback');
  {$IFDEF FPC}Pointer({$ENDIF}PyException_GetTraceback{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyException_GetTraceback');
  {$IFDEF FPC}Pointer({$ENDIF}PyException_GetCause{$IFDEF FPC}){$ENDIF}                          := GetProcAddress(FLibHandle, 'PyException_GetCause');
  {$IFDEF FPC}Pointer({$ENDIF}PyException_SetCause{$IFDEF FPC}){$ENDIF}                          := GetProcAddress(FLibHandle, 'PyException_SetCause');
  {$IFDEF FPC}Pointer({$ENDIF}PyException_GetContext{$IFDEF FPC}){$ENDIF}                        := GetProcAddress(FLibHandle, 'PyException_GetContext');
  {$IFDEF FPC}Pointer({$ENDIF}PyException_SetContext{$IFDEF FPC}){$ENDIF}                        := GetProcAddress(FLibHandle, 'PyException_SetContext');
  {$IFDEF FPC}Pointer({$ENDIF}PyException_GetArgs{$IFDEF FPC}){$ENDIF}                           := GetProcAddress(FLibHandle, 'PyException_GetArgs');
  {$IFDEF FPC}Pointer({$ENDIF}PyException_SetArgs{$IFDEF FPC}){$ENDIF}                           := GetProcAddress(FLibHandle, 'PyException_SetArgs');
  {$IFDEF FPC}Pointer({$ENDIF}PyExceptionClass_Name{$IFDEF FPC}){$ENDIF}                         := GetProcAddress(FLibHandle, 'PyExceptionClass_Name');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_BaseException{$IFDEF FPC}){$ENDIF}                           := GetProcAddress(FLibHandle, 'PyExc_BaseException');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_Exception{$IFDEF FPC}){$ENDIF}                               := GetProcAddress(FLibHandle, 'PyExc_Exception');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_BaseExceptionGroup{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyExc_BaseExceptionGroup');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_StopAsyncIteration{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyExc_StopAsyncIteration');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_StopIteration{$IFDEF FPC}){$ENDIF}                           := GetProcAddress(FLibHandle, 'PyExc_StopIteration');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_GeneratorExit{$IFDEF FPC}){$ENDIF}                           := GetProcAddress(FLibHandle, 'PyExc_GeneratorExit');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_ArithmeticError{$IFDEF FPC}){$ENDIF}                         := GetProcAddress(FLibHandle, 'PyExc_ArithmeticError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_LookupError{$IFDEF FPC}){$ENDIF}                             := GetProcAddress(FLibHandle, 'PyExc_LookupError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_AssertionError{$IFDEF FPC}){$ENDIF}                          := GetProcAddress(FLibHandle, 'PyExc_AssertionError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_AttributeError{$IFDEF FPC}){$ENDIF}                          := GetProcAddress(FLibHandle, 'PyExc_AttributeError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_BufferError{$IFDEF FPC}){$ENDIF}                             := GetProcAddress(FLibHandle, 'PyExc_BufferError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_EOFError{$IFDEF FPC}){$ENDIF}                                := GetProcAddress(FLibHandle, 'PyExc_EOFError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_FloatingPointError{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyExc_FloatingPointError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_OSError{$IFDEF FPC}){$ENDIF}                                 := GetProcAddress(FLibHandle, 'PyExc_OSError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_ImportError{$IFDEF FPC}){$ENDIF}                             := GetProcAddress(FLibHandle, 'PyExc_ImportError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_ImportCycleError{$IFDEF FPC}){$ENDIF}                        := GetProcAddress(FLibHandle, 'PyExc_ImportCycleError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_ModuleNotFoundError{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'PyExc_ModuleNotFoundError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_IndexError{$IFDEF FPC}){$ENDIF}                              := GetProcAddress(FLibHandle, 'PyExc_IndexError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_KeyError{$IFDEF FPC}){$ENDIF}                                := GetProcAddress(FLibHandle, 'PyExc_KeyError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_KeyboardInterrupt{$IFDEF FPC}){$ENDIF}                       := GetProcAddress(FLibHandle, 'PyExc_KeyboardInterrupt');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_MemoryError{$IFDEF FPC}){$ENDIF}                             := GetProcAddress(FLibHandle, 'PyExc_MemoryError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_NameError{$IFDEF FPC}){$ENDIF}                               := GetProcAddress(FLibHandle, 'PyExc_NameError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_OverflowError{$IFDEF FPC}){$ENDIF}                           := GetProcAddress(FLibHandle, 'PyExc_OverflowError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_RuntimeError{$IFDEF FPC}){$ENDIF}                            := GetProcAddress(FLibHandle, 'PyExc_RuntimeError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_RecursionError{$IFDEF FPC}){$ENDIF}                          := GetProcAddress(FLibHandle, 'PyExc_RecursionError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_NotImplementedError{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'PyExc_NotImplementedError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_SyntaxError{$IFDEF FPC}){$ENDIF}                             := GetProcAddress(FLibHandle, 'PyExc_SyntaxError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_IndentationError{$IFDEF FPC}){$ENDIF}                        := GetProcAddress(FLibHandle, 'PyExc_IndentationError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_TabError{$IFDEF FPC}){$ENDIF}                                := GetProcAddress(FLibHandle, 'PyExc_TabError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_ReferenceError{$IFDEF FPC}){$ENDIF}                          := GetProcAddress(FLibHandle, 'PyExc_ReferenceError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_SystemError{$IFDEF FPC}){$ENDIF}                             := GetProcAddress(FLibHandle, 'PyExc_SystemError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_SystemExit{$IFDEF FPC}){$ENDIF}                              := GetProcAddress(FLibHandle, 'PyExc_SystemExit');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_TypeError{$IFDEF FPC}){$ENDIF}                               := GetProcAddress(FLibHandle, 'PyExc_TypeError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_UnboundLocalError{$IFDEF FPC}){$ENDIF}                       := GetProcAddress(FLibHandle, 'PyExc_UnboundLocalError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_UnicodeError{$IFDEF FPC}){$ENDIF}                            := GetProcAddress(FLibHandle, 'PyExc_UnicodeError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_UnicodeEncodeError{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyExc_UnicodeEncodeError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_UnicodeDecodeError{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyExc_UnicodeDecodeError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_UnicodeTranslateError{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyExc_UnicodeTranslateError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_ValueError{$IFDEF FPC}){$ENDIF}                              := GetProcAddress(FLibHandle, 'PyExc_ValueError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_ZeroDivisionError{$IFDEF FPC}){$ENDIF}                       := GetProcAddress(FLibHandle, 'PyExc_ZeroDivisionError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_BlockingIOError{$IFDEF FPC}){$ENDIF}                         := GetProcAddress(FLibHandle, 'PyExc_BlockingIOError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_BrokenPipeError{$IFDEF FPC}){$ENDIF}                         := GetProcAddress(FLibHandle, 'PyExc_BrokenPipeError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_ChildProcessError{$IFDEF FPC}){$ENDIF}                       := GetProcAddress(FLibHandle, 'PyExc_ChildProcessError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_ConnectionError{$IFDEF FPC}){$ENDIF}                         := GetProcAddress(FLibHandle, 'PyExc_ConnectionError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_ConnectionAbortedError{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyExc_ConnectionAbortedError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_ConnectionRefusedError{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyExc_ConnectionRefusedError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_ConnectionResetError{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyExc_ConnectionResetError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_FileExistsError{$IFDEF FPC}){$ENDIF}                         := GetProcAddress(FLibHandle, 'PyExc_FileExistsError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_FileNotFoundError{$IFDEF FPC}){$ENDIF}                       := GetProcAddress(FLibHandle, 'PyExc_FileNotFoundError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_InterruptedError{$IFDEF FPC}){$ENDIF}                        := GetProcAddress(FLibHandle, 'PyExc_InterruptedError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_IsADirectoryError{$IFDEF FPC}){$ENDIF}                       := GetProcAddress(FLibHandle, 'PyExc_IsADirectoryError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_NotADirectoryError{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyExc_NotADirectoryError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_PermissionError{$IFDEF FPC}){$ENDIF}                         := GetProcAddress(FLibHandle, 'PyExc_PermissionError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_ProcessLookupError{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyExc_ProcessLookupError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_TimeoutError{$IFDEF FPC}){$ENDIF}                            := GetProcAddress(FLibHandle, 'PyExc_TimeoutError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_EnvironmentError{$IFDEF FPC}){$ENDIF}                        := GetProcAddress(FLibHandle, 'PyExc_EnvironmentError');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_IOError{$IFDEF FPC}){$ENDIF}                                 := GetProcAddress(FLibHandle, 'PyExc_IOError');
  {$IFDEF MSWINDOWS}
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_WindowsError{$IFDEF FPC}){$ENDIF}                            := GetProcAddress(FLibHandle, 'PyExc_WindowsError');
  {$ENDIF}
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_Warning{$IFDEF FPC}){$ENDIF}                                 := GetProcAddress(FLibHandle, 'PyExc_Warning');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_UserWarning{$IFDEF FPC}){$ENDIF}                             := GetProcAddress(FLibHandle, 'PyExc_UserWarning');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_DeprecationWarning{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyExc_DeprecationWarning');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_PendingDeprecationWarning{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyExc_PendingDeprecationWarning');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_SyntaxWarning{$IFDEF FPC}){$ENDIF}                           := GetProcAddress(FLibHandle, 'PyExc_SyntaxWarning');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_RuntimeWarning{$IFDEF FPC}){$ENDIF}                          := GetProcAddress(FLibHandle, 'PyExc_RuntimeWarning');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_FutureWarning{$IFDEF FPC}){$ENDIF}                           := GetProcAddress(FLibHandle, 'PyExc_FutureWarning');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_ImportWarning{$IFDEF FPC}){$ENDIF}                           := GetProcAddress(FLibHandle, 'PyExc_ImportWarning');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_UnicodeWarning{$IFDEF FPC}){$ENDIF}                          := GetProcAddress(FLibHandle, 'PyExc_UnicodeWarning');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_BytesWarning{$IFDEF FPC}){$ENDIF}                            := GetProcAddress(FLibHandle, 'PyExc_BytesWarning');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_EncodingWarning{$IFDEF FPC}){$ENDIF}                         := GetProcAddress(FLibHandle, 'PyExc_EncodingWarning');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_ResourceWarning{$IFDEF FPC}){$ENDIF}                         := GetProcAddress(FLibHandle, 'PyExc_ResourceWarning');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_BadArgument{$IFDEF FPC}){$ENDIF}                             := GetProcAddress(FLibHandle, 'PyErr_BadArgument');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_NoMemory{$IFDEF FPC}){$ENDIF}                                := GetProcAddress(FLibHandle, 'PyErr_NoMemory');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetFromErrno{$IFDEF FPC}){$ENDIF}                            := GetProcAddress(FLibHandle, 'PyErr_SetFromErrno');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetFromErrnoWithFilenameObject{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyErr_SetFromErrnoWithFilenameObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetFromErrnoWithFilenameObjects{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyErr_SetFromErrnoWithFilenameObjects');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetFromErrnoWithFilename{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyErr_SetFromErrnoWithFilename');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_Format{$IFDEF FPC}){$ENDIF}                                  := GetProcAddress(FLibHandle, 'PyErr_Format');
  {$IFDEF MSWINDOWS}
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetFromWindowsErrWithFilename{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyErr_SetFromWindowsErrWithFilename');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetFromWindowsErr{$IFDEF FPC}){$ENDIF}                       := GetProcAddress(FLibHandle, 'PyErr_SetFromWindowsErr');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetExcFromWindowsErrWithFilenameObject{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyErr_SetExcFromWindowsErrWithFilenameObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetExcFromWindowsErrWithFilenameObjects{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyErr_SetExcFromWindowsErrWithFilenameObjects');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetExcFromWindowsErrWithFilename{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyErr_SetExcFromWindowsErrWithFilename');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetExcFromWindowsErr{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyErr_SetExcFromWindowsErr');
  {$ENDIF}
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetImportErrorSubclass{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyErr_SetImportErrorSubclass');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetImportError{$IFDEF FPC}){$ENDIF}                          := GetProcAddress(FLibHandle, 'PyErr_SetImportError');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_BadInternalCall{$IFDEF FPC}){$ENDIF}                         := GetProcAddress(FLibHandle, 'PyErr_BadInternalCall');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_NewException{$IFDEF FPC}){$ENDIF}                            := GetProcAddress(FLibHandle, 'PyErr_NewException');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_NewExceptionWithDoc{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'PyErr_NewExceptionWithDoc');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_WriteUnraisable{$IFDEF FPC}){$ENDIF}                         := GetProcAddress(FLibHandle, 'PyErr_WriteUnraisable');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_CheckSignals{$IFDEF FPC}){$ENDIF}                            := GetProcAddress(FLibHandle, 'PyErr_CheckSignals');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetInterrupt{$IFDEF FPC}){$ENDIF}                            := GetProcAddress(FLibHandle, 'PyErr_SetInterrupt');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SetInterruptEx{$IFDEF FPC}){$ENDIF}                          := GetProcAddress(FLibHandle, 'PyErr_SetInterruptEx');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SyntaxLocation{$IFDEF FPC}){$ENDIF}                          := GetProcAddress(FLibHandle, 'PyErr_SyntaxLocation');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SyntaxLocationEx{$IFDEF FPC}){$ENDIF}                        := GetProcAddress(FLibHandle, 'PyErr_SyntaxLocationEx');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_ProgramText{$IFDEF FPC}){$ENDIF}                             := GetProcAddress(FLibHandle, 'PyErr_ProgramText');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeDecodeError_Create{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyUnicodeDecodeError_Create');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeEncodeError_GetEncoding{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyUnicodeEncodeError_GetEncoding');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeDecodeError_GetEncoding{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyUnicodeDecodeError_GetEncoding');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeEncodeError_GetObject{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicodeEncodeError_GetObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeDecodeError_GetObject{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicodeDecodeError_GetObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeTranslateError_GetObject{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyUnicodeTranslateError_GetObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeEncodeError_GetStart{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyUnicodeEncodeError_GetStart');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeDecodeError_GetStart{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyUnicodeDecodeError_GetStart');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeTranslateError_GetStart{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyUnicodeTranslateError_GetStart');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeEncodeError_SetStart{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyUnicodeEncodeError_SetStart');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeDecodeError_SetStart{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyUnicodeDecodeError_SetStart');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeTranslateError_SetStart{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyUnicodeTranslateError_SetStart');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeEncodeError_GetEnd{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyUnicodeEncodeError_GetEnd');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeDecodeError_GetEnd{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyUnicodeDecodeError_GetEnd');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeTranslateError_GetEnd{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicodeTranslateError_GetEnd');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeEncodeError_SetEnd{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyUnicodeEncodeError_SetEnd');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeDecodeError_SetEnd{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyUnicodeDecodeError_SetEnd');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeTranslateError_SetEnd{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicodeTranslateError_SetEnd');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeEncodeError_GetReason{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicodeEncodeError_GetReason');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeDecodeError_GetReason{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicodeDecodeError_GetReason');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeTranslateError_GetReason{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyUnicodeTranslateError_GetReason');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeEncodeError_SetReason{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicodeEncodeError_SetReason');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeDecodeError_SetReason{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyUnicodeDecodeError_SetReason');
  {$IFDEF FPC}Pointer({$ENDIF}PyUnicodeTranslateError_SetReason{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyUnicodeTranslateError_SetReason');
  {$IFDEF FPC}Pointer({$ENDIF}PyOS_snprintf{$IFDEF FPC}){$ENDIF}                                 := GetProcAddress(FLibHandle, 'PyOS_snprintf');
  {$IFDEF FPC}Pointer({$ENDIF}PySignal_SetWakeupFd{$IFDEF FPC}){$ENDIF}                          := GetProcAddress(FLibHandle, 'PySignal_SetWakeupFd');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_SyntaxLocationObject{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyErr_SyntaxLocationObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_RangedSyntaxLocationObject{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyErr_RangedSyntaxLocationObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_ProgramTextObject{$IFDEF FPC}){$ENDIF}                       := GetProcAddress(FLibHandle, 'PyErr_ProgramTextObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_FormatUnraisable{$IFDEF FPC}){$ENDIF}                        := GetProcAddress(FLibHandle, 'PyErr_FormatUnraisable');
  {$IFDEF FPC}Pointer({$ENDIF}PyExc_PythonFinalizationError{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyExc_PythonFinalizationError');
end;

procedure TP4PLoader.Load_longobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FromLong{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyLong_FromLong');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FromUnsignedLong{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyLong_FromUnsignedLong');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FromSize_t{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyLong_FromSize_t');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FromSsize_t{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyLong_FromSsize_t');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FromDouble{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyLong_FromDouble');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsLong{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyLong_AsLong');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsLongAndOverflow{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyLong_AsLongAndOverflow');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsSsize_t{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyLong_AsSsize_t');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsSize_t{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyLong_AsSize_t');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsUnsignedLong{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyLong_AsUnsignedLong');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsUnsignedLongMask{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyLong_AsUnsignedLongMask');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsInt{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyLong_AsInt');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FromInt32{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyLong_FromInt32');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FromUInt32{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyLong_FromUInt32');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FromInt64{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyLong_FromInt64');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FromUInt64{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyLong_FromUInt64');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsInt32{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyLong_AsInt32');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsUInt32{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyLong_AsUInt32');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsInt64{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyLong_AsInt64');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsUInt64{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyLong_AsUInt64');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsNativeBytes{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyLong_AsNativeBytes');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FromNativeBytes{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyLong_FromNativeBytes');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FromUnsignedNativeBytes{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyLong_FromUnsignedNativeBytes');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_GetInfo{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyLong_GetInfo');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsDouble{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyLong_AsDouble');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FromVoidPtr{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyLong_FromVoidPtr');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsVoidPtr{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyLong_AsVoidPtr');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FromLongLong{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyLong_FromLongLong');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FromUnsignedLongLong{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyLong_FromUnsignedLongLong');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsLongLong{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyLong_AsLongLong');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsUnsignedLongLong{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyLong_AsUnsignedLongLong');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsUnsignedLongLongMask{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyLong_AsUnsignedLongLongMask');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_AsLongLongAndOverflow{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyLong_AsLongLongAndOverflow');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FromString{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyLong_FromString');
  {$IFDEF FPC}Pointer({$ENDIF}PyOS_strtoul{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyOS_strtoul');
  {$IFDEF FPC}Pointer({$ENDIF}PyOS_strtol{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyOS_strtol');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FromUnicodeObject{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyLong_FromUnicodeObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_IsPositive{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyLong_IsPositive');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_IsNegative{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyLong_IsNegative');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_IsZero{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyLong_IsZero');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_GetSign{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyLong_GetSign');
end;

procedure TP4PLoader.Load_longintrepr;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_GetNativeLayout{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyLong_GetNativeLayout');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_Export{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyLong_Export');
  {$IFDEF FPC}Pointer({$ENDIF}PyLong_FreeExport{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyLong_FreeExport');
  {$IFDEF FPC}Pointer({$ENDIF}PyLongWriter_Create{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyLongWriter_Create');
  {$IFDEF FPC}Pointer({$ENDIF}PyLongWriter_Finish{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyLongWriter_Finish');
  {$IFDEF FPC}Pointer({$ENDIF}PyLongWriter_Discard{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyLongWriter_Discard');
end;

procedure TP4PLoader.Load_boolobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}Py_False{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, '_Py_FalseStruct');
  {$IFDEF FPC}Pointer({$ENDIF}Py_True{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, '_Py_TrueStruct');
  {$IFDEF FPC}Pointer({$ENDIF}Py_IsTrue{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'Py_IsTrue');
  {$IFDEF FPC}Pointer({$ENDIF}Py_IsFalse{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'Py_IsFalse');
  {$IFDEF FPC}Pointer({$ENDIF}PyBool_FromLong{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyBool_FromLong');
end;

procedure TP4PLoader.Load_floatobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyFloat_Type{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyFloat_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyFloat_GetMax{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyFloat_GetMax');
  {$IFDEF FPC}Pointer({$ENDIF}PyFloat_GetMin{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyFloat_GetMin');
  {$IFDEF FPC}Pointer({$ENDIF}PyFloat_GetInfo{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyFloat_GetInfo');
  {$IFDEF FPC}Pointer({$ENDIF}PyFloat_FromString{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyFloat_FromString');
  {$IFDEF FPC}Pointer({$ENDIF}PyFloat_FromDouble{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyFloat_FromDouble');
  {$IFDEF FPC}Pointer({$ENDIF}PyFloat_AsDouble{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyFloat_AsDouble');
  {$IFDEF FPC}Pointer({$ENDIF}PyFloat_Pack2{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyFloat_Pack2');
  {$IFDEF FPC}Pointer({$ENDIF}PyFloat_Pack4{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyFloat_Pack4');
  {$IFDEF FPC}Pointer({$ENDIF}PyFloat_Pack8{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyFloat_Pack8');
  {$IFDEF FPC}Pointer({$ENDIF}PyFloat_Unpack2{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyFloat_Unpack2');
  {$IFDEF FPC}Pointer({$ENDIF}PyFloat_Unpack4{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyFloat_Unpack4');
  {$IFDEF FPC}Pointer({$ENDIF}PyFloat_Unpack8{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyFloat_Unpack8');
end;

procedure TP4PLoader.Load_complexobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyComplex_Type{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyComplex_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyComplex_FromDoubles{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyComplex_FromDoubles');
  {$IFDEF FPC}Pointer({$ENDIF}PyComplex_RealAsDouble{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyComplex_RealAsDouble');
  {$IFDEF FPC}Pointer({$ENDIF}PyComplex_ImagAsDouble{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyComplex_ImagAsDouble');
  {$IFDEF FPC}Pointer({$ENDIF}PyComplex_FromCComplex{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyComplex_FromCComplex');
  {$IFDEF FPC}Pointer({$ENDIF}PyComplex_AsCComplex{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyComplex_AsCComplex');
end;

procedure TP4PLoader.Load_rangeobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyRange_Type{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyRange_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyRangeIter_Type{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyRangeIter_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyLongRangeIter_Type{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyLongRangeIter_Type');
end;

procedure TP4PLoader.Load_memoryobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyMemoryView_Type{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyMemoryView_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyMemoryView_FromObject{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyMemoryView_FromObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyMemoryView_FromMemory{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyMemoryView_FromMemory');
  {$IFDEF FPC}Pointer({$ENDIF}PyMemoryView_FromBuffer{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyMemoryView_FromBuffer');
  {$IFDEF FPC}Pointer({$ENDIF}PyMemoryView_GetContiguous{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyMemoryView_GetContiguous');
end;

procedure TP4PLoader.Load_tupleobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyTuple_Type{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyTuple_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyTupleIter_Type{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyTupleIter_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyTuple_New{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyTuple_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyTuple_Size{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyTuple_Size');
  {$IFDEF FPC}Pointer({$ENDIF}PyTuple_GetItem{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyTuple_GetItem');
  {$IFDEF FPC}Pointer({$ENDIF}PyTuple_SetItem{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyTuple_SetItem');
  {$IFDEF FPC}Pointer({$ENDIF}PyTuple_GetSlice{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyTuple_GetSlice');
  {$IFDEF FPC}Pointer({$ENDIF}PyTuple_Pack{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyTuple_Pack');
  {$IFDEF FPC}Pointer({$ENDIF}PyTuple_FromArray{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyTuple_FromArray');
end;

procedure TP4PLoader.Load_listobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyList_Type{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyList_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyListIter_Type{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyListIter_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyListRevIter_Type{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyListRevIter_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyList_New{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyList_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyList_Size{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyList_Size');
  {$IFDEF FPC}Pointer({$ENDIF}PyList_GetItem{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyList_GetItem');
  {$IFDEF FPC}Pointer({$ENDIF}PyList_GetItemRef{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyList_GetItemRef');
  {$IFDEF FPC}Pointer({$ENDIF}PyList_SetItem{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyList_SetItem');
  {$IFDEF FPC}Pointer({$ENDIF}PyList_Insert{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyList_Insert');
  {$IFDEF FPC}Pointer({$ENDIF}PyList_Append{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyList_Append');
  {$IFDEF FPC}Pointer({$ENDIF}PyList_GetSlice{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyList_GetSlice');
  {$IFDEF FPC}Pointer({$ENDIF}PyList_SetSlice{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyList_SetSlice');
  {$IFDEF FPC}Pointer({$ENDIF}PyList_Sort{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyList_Sort');
  {$IFDEF FPC}Pointer({$ENDIF}PyList_Reverse{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyList_Reverse');
  {$IFDEF FPC}Pointer({$ENDIF}PyList_AsTuple{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyList_AsTuple');
  {$IFDEF FPC}Pointer({$ENDIF}PyList_Extend{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyList_Extend');
  {$IFDEF FPC}Pointer({$ENDIF}PyList_Clear{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyList_Clear');
end;

procedure TP4PLoader.Load_dictobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_Type{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyDict_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_New{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyDict_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_GetItem{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyDict_GetItem');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_GetItemWithError{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyDict_GetItemWithError');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_SetItem{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyDict_SetItem');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_DelItem{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyDict_DelItem');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_Clear{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyDict_Clear');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_Next{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyDict_Next');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_Keys{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyDict_Keys');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_Values{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyDict_Values');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_Items{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyDict_Items');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_Size{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyDict_Size');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_Copy{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyDict_Copy');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_Contains{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyDict_Contains');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_Update{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyDict_Update');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_Merge{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyDict_Merge');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_MergeFromSeq2{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyDict_MergeFromSeq2');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_GetItemString{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyDict_GetItemString');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_SetItemString{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyDict_SetItemString');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_DelItemString{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyDict_DelItemString');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_GetItemRef{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyDict_GetItemRef');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_GetItemStringRef{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyDict_GetItemStringRef');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GenericGetDict{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyObject_GenericGetDict');
  {$IFDEF FPC}Pointer({$ENDIF}PyDictKeys_Type{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyDictKeys_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyDictValues_Type{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyDictValues_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyDictItems_Type{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyDictItems_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyDictIterKey_Type{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyDictIterKey_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyDictIterValue_Type{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyDictIterValue_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyDictIterItem_Type{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyDictIterItem_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyDictRevIterKey_Type{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyDictRevIterKey_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyDictRevIterItem_Type{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyDictRevIterItem_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyDictRevIterValue_Type{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyDictRevIterValue_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_SetDefault{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyDict_SetDefault');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_SetDefaultRef{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyDict_SetDefaultRef');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_ContainsString{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyDict_ContainsString');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_Pop{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyDict_Pop');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_PopString{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyDict_PopString');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_AddWatcher{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyDict_AddWatcher');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_ClearWatcher{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyDict_ClearWatcher');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_Watch{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyDict_Watch');
  {$IFDEF FPC}Pointer({$ENDIF}PyDict_Unwatch{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyDict_Unwatch');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrozenDict_New{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyFrozenDict_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrozenDict_Type{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyFrozenDict_Type');
end;

procedure TP4PLoader.Load_odictobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyODict_Type{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyODict_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyODictIter_Type{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyODictIter_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyODictKeys_Type{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyODictKeys_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyODictItems_Type{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyODictItems_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyODictValues_Type{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyODictValues_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyODict_New{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyODict_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyODict_SetItem{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyODict_SetItem');
  {$IFDEF FPC}Pointer({$ENDIF}PyODict_DelItem{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyODict_DelItem');
end;

procedure TP4PLoader.Load_enumobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyEnum_Type{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyEnum_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyReversed_Type{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyReversed_Type');
end;

procedure TP4PLoader.Load_setobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PySet_Type{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PySet_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrozenSet_Type{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyFrozenSet_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PySetIter_Type{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PySetIter_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PySet_New{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PySet_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrozenSet_New{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyFrozenSet_New');
  {$IFDEF FPC}Pointer({$ENDIF}PySet_Add{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PySet_Add');
  {$IFDEF FPC}Pointer({$ENDIF}PySet_Clear{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PySet_Clear');
  {$IFDEF FPC}Pointer({$ENDIF}PySet_Contains{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PySet_Contains');
  {$IFDEF FPC}Pointer({$ENDIF}PySet_Discard{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PySet_Discard');
  {$IFDEF FPC}Pointer({$ENDIF}PySet_Pop{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PySet_Pop');
  {$IFDEF FPC}Pointer({$ENDIF}PySet_Size{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PySet_Size');
end;

procedure TP4PLoader.Load_methodobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyCFunction_Type{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyCFunction_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyCFunction_GetFunction{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyCFunction_GetFunction');
  {$IFDEF FPC}Pointer({$ENDIF}PyCFunction_GetSelf{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyCFunction_GetSelf');
  {$IFDEF FPC}Pointer({$ENDIF}PyCFunction_GetFlags{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyCFunction_GetFlags');
  {$IFDEF FPC}Pointer({$ENDIF}PyCFunction_New{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyCFunction_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyCFunction_NewEx{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyCFunction_NewEx');
  {$IFDEF FPC}Pointer({$ENDIF}PyCMethod_New{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyCMethod_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyCMethod_Type{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyCMethod_Type');
end;

procedure TP4PLoader.Load_moduleobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_Type{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyModule_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_NewObject{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyModule_NewObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_New{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyModule_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_GetDict{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyModule_GetDict');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_GetNameObject{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyModule_GetNameObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_GetName{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyModule_GetName');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_GetFilenameObject{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyModule_GetFilenameObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_GetDef{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyModule_GetDef');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_GetState{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyModule_GetState');
  {$IFDEF FPC}Pointer({$ENDIF}PyModuleDef_Init{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyModuleDef_Init');
  {$IFDEF FPC}Pointer({$ENDIF}PyModuleDef_Type{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyModuleDef_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_FromSlotsAndSpec{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyModule_FromSlotsAndSpec');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_Exec{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyModule_Exec');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_GetStateSize{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyModule_GetStateSize');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_GetToken{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyModule_GetToken');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_GetState_DuringGC{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyModule_GetState_DuringGC');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_GetToken_DuringGC{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyModule_GetToken_DuringGC');
end;

procedure TP4PLoader.Load_monitoring;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyMonitoring_EnterScope{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyMonitoring_EnterScope');
  {$IFDEF FPC}Pointer({$ENDIF}PyMonitoring_ExitScope{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyMonitoring_ExitScope');
end;

procedure TP4PLoader.Load_funcobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_Type{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyFunction_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_New{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyFunction_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_NewWithQualName{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyFunction_NewWithQualName');
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_GetCode{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyFunction_GetCode');
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_GetGlobals{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyFunction_GetGlobals');
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_GetModule{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyFunction_GetModule');
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_GetDefaults{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyFunction_GetDefaults');
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_SetDefaults{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyFunction_SetDefaults');
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_SetVectorcall{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyFunction_SetVectorcall');
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_GetKwDefaults{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyFunction_GetKwDefaults');
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_SetKwDefaults{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyFunction_SetKwDefaults');
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_GetClosure{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyFunction_GetClosure');
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_SetClosure{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyFunction_SetClosure');
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_GetAnnotations{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyFunction_GetAnnotations');
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_SetAnnotations{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyFunction_SetAnnotations');
  {$IFDEF FPC}Pointer({$ENDIF}PyClassMethod_Type{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyClassMethod_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyStaticMethod_Type{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyStaticMethod_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyClassMethod_New{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyClassMethod_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyStaticMethod_New{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyStaticMethod_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_AddWatcher{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyFunction_AddWatcher');
  {$IFDEF FPC}Pointer({$ENDIF}PyFunction_ClearWatcher{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyFunction_ClearWatcher');
end;

procedure TP4PLoader.Load_classobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyMethod_Type{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyMethod_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyMethod_New{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyMethod_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyMethod_Function{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyMethod_Function');
  {$IFDEF FPC}Pointer({$ENDIF}PyMethod_Self{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyMethod_Self');
  {$IFDEF FPC}Pointer({$ENDIF}PyInstanceMethod_Type{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyInstanceMethod_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyInstanceMethod_New{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyInstanceMethod_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyInstanceMethod_Function{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyInstanceMethod_Function');
end;

procedure TP4PLoader.Load_fileobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyFile_FromFd{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyFile_FromFd');
  {$IFDEF FPC}Pointer({$ENDIF}PyFile_GetLine{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyFile_GetLine');
  {$IFDEF FPC}Pointer({$ENDIF}PyFile_WriteObject{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyFile_WriteObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyFile_WriteString{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyFile_WriteString');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_AsFileDescriptor{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyObject_AsFileDescriptor');
  {$IFDEF FPC}Pointer({$ENDIF}Py_UniversalNewlineFgets{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'Py_UniversalNewlineFgets');
  {$IFDEF FPC}Pointer({$ENDIF}PyFile_NewStdPrinter{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyFile_NewStdPrinter');
  {$IFDEF FPC}Pointer({$ENDIF}PyStdPrinter_Type{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyStdPrinter_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyFile_OpenCode{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyFile_OpenCode');
  {$IFDEF FPC}Pointer({$ENDIF}PyFile_OpenCodeObject{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyFile_OpenCodeObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyFile_SetOpenCodeHook{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyFile_SetOpenCodeHook');
end;

procedure TP4PLoader.Load_pycapsule;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyCapsule_Type{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyCapsule_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyCapsule_New{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyCapsule_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyCapsule_GetPointer{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyCapsule_GetPointer');
  {$IFDEF FPC}Pointer({$ENDIF}PyCapsule_GetDestructor{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyCapsule_GetDestructor');
  {$IFDEF FPC}Pointer({$ENDIF}PyCapsule_GetName{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyCapsule_GetName');
  {$IFDEF FPC}Pointer({$ENDIF}PyCapsule_GetContext{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyCapsule_GetContext');
  {$IFDEF FPC}Pointer({$ENDIF}PyCapsule_IsValid{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyCapsule_IsValid');
  {$IFDEF FPC}Pointer({$ENDIF}PyCapsule_SetPointer{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyCapsule_SetPointer');
  {$IFDEF FPC}Pointer({$ENDIF}PyCapsule_SetDestructor{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyCapsule_SetDestructor');
  {$IFDEF FPC}Pointer({$ENDIF}PyCapsule_SetName{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyCapsule_SetName');
  {$IFDEF FPC}Pointer({$ENDIF}PyCapsule_SetContext{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyCapsule_SetContext');
  {$IFDEF FPC}Pointer({$ENDIF}PyCapsule_Import{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyCapsule_Import');
end;

procedure TP4PLoader.Load_code;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyCode_Type{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyCode_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyCode_NewEmpty{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyCode_NewEmpty');
  {$IFDEF FPC}Pointer({$ENDIF}PyCode_Addr2Line{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyCode_Addr2Line');
  {$IFDEF FPC}Pointer({$ENDIF}PyCode_Addr2Location{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyCode_Addr2Location');
  {$IFDEF FPC}Pointer({$ENDIF}PyCode_AddWatcher{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyCode_AddWatcher');
  {$IFDEF FPC}Pointer({$ENDIF}PyCode_ClearWatcher{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyCode_ClearWatcher');
  {$IFDEF FPC}Pointer({$ENDIF}PyCode_Optimize{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyCode_Optimize');
  {$IFDEF FPC}Pointer({$ENDIF}PyCode_GetCode{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyCode_GetCode');
  {$IFDEF FPC}Pointer({$ENDIF}PyCode_GetVarnames{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyCode_GetVarnames');
  {$IFDEF FPC}Pointer({$ENDIF}PyCode_GetCellvars{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyCode_GetCellvars');
  {$IFDEF FPC}Pointer({$ENDIF}PyCode_GetFreevars{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyCode_GetFreevars');
end;

procedure TP4PLoader.Load_pyframe;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyFrame_GetLineNumber{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyFrame_GetLineNumber');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrame_GetCode{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyFrame_GetCode');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrame_Type{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyFrame_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrameLocalsProxy_Type{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyFrameLocalsProxy_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrame_GetBack{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyFrame_GetBack');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrame_GetLocals{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyFrame_GetLocals');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrame_GetGlobals{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyFrame_GetGlobals');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrame_GetBuiltins{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyFrame_GetBuiltins');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrame_GetGenerator{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyFrame_GetGenerator');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrame_GetLasti{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyFrame_GetLasti');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrame_GetVar{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyFrame_GetVar');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrame_GetVarString{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyFrame_GetVarString');
end;

procedure TP4PLoader.Load_traceback;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyTraceBack_Here{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyTraceBack_Here');
  {$IFDEF FPC}Pointer({$ENDIF}PyTraceBack_Print{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyTraceBack_Print');
  {$IFDEF FPC}Pointer({$ENDIF}PyTraceBack_Type{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyTraceBack_Type');
end;

procedure TP4PLoader.Load_sliceobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}Py_Ellipsis{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, '_Py_EllipsisObject');
  {$IFDEF FPC}Pointer({$ENDIF}PySlice_Type{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PySlice_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyEllipsis_Type{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyEllipsis_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PySlice_New{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PySlice_New');
  {$IFDEF FPC}Pointer({$ENDIF}PySlice_GetIndices{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PySlice_GetIndices');
  {$IFDEF FPC}Pointer({$ENDIF}PySlice_GetIndicesEx{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PySlice_GetIndicesEx');
  {$IFDEF FPC}Pointer({$ENDIF}PySlice_Unpack{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PySlice_Unpack');
  {$IFDEF FPC}Pointer({$ENDIF}PySlice_AdjustIndices{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PySlice_AdjustIndices');
end;

procedure TP4PLoader.Load_cellobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyCell_Type{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyCell_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyCell_New{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyCell_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyCell_Get{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyCell_Get');
  {$IFDEF FPC}Pointer({$ENDIF}PyCell_Set{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyCell_Set');
end;

procedure TP4PLoader.Load_iterobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PySeqIter_Type{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PySeqIter_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyCallIter_Type{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyCallIter_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PySeqIter_New{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PySeqIter_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyCallIter_New{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyCallIter_New');
end;

procedure TP4PLoader.Load_initconfig;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyStatus_Ok{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyStatus_Ok');
  {$IFDEF FPC}Pointer({$ENDIF}PyStatus_Error{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyStatus_Error');
  {$IFDEF FPC}Pointer({$ENDIF}PyStatus_NoMemory{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyStatus_NoMemory');
  {$IFDEF FPC}Pointer({$ENDIF}PyStatus_Exit{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyStatus_Exit');
  {$IFDEF FPC}Pointer({$ENDIF}PyStatus_IsError{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyStatus_IsError');
  {$IFDEF FPC}Pointer({$ENDIF}PyStatus_IsExit{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyStatus_IsExit');
  {$IFDEF FPC}Pointer({$ENDIF}PyStatus_Exception{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyStatus_Exception');
  {$IFDEF FPC}Pointer({$ENDIF}PyWideStringList_Append{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyWideStringList_Append');
  {$IFDEF FPC}Pointer({$ENDIF}PyWideStringList_Insert{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyWideStringList_Insert');
  {$IFDEF FPC}Pointer({$ENDIF}PyPreConfig_InitPythonConfig{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyPreConfig_InitPythonConfig');
  {$IFDEF FPC}Pointer({$ENDIF}PyPreConfig_InitIsolatedConfig{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyPreConfig_InitIsolatedConfig');
  {$IFDEF FPC}Pointer({$ENDIF}PyConfig_InitPythonConfig{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyConfig_InitPythonConfig');
  {$IFDEF FPC}Pointer({$ENDIF}PyConfig_InitIsolatedConfig{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyConfig_InitIsolatedConfig');
  {$IFDEF FPC}Pointer({$ENDIF}PyConfig_Clear{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyConfig_Clear');
  {$IFDEF FPC}Pointer({$ENDIF}PyConfig_SetString{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyConfig_SetString');
  {$IFDEF FPC}Pointer({$ENDIF}PyConfig_SetBytesString{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyConfig_SetBytesString');
  {$IFDEF FPC}Pointer({$ENDIF}PyConfig_Read{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyConfig_Read');
  {$IFDEF FPC}Pointer({$ENDIF}PyConfig_SetBytesArgv{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyConfig_SetBytesArgv');
  {$IFDEF FPC}Pointer({$ENDIF}PyConfig_SetArgv{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyConfig_SetArgv');
  {$IFDEF FPC}Pointer({$ENDIF}PyConfig_SetWideStringList{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyConfig_SetWideStringList');
  {$IFDEF FPC}Pointer({$ENDIF}PyConfig_Get{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyConfig_Get');
  {$IFDEF FPC}Pointer({$ENDIF}PyConfig_GetInt{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyConfig_GetInt');
  {$IFDEF FPC}Pointer({$ENDIF}PyConfig_Names{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyConfig_Names');
  {$IFDEF FPC}Pointer({$ENDIF}PyConfig_Set{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyConfig_Set');
  {$IFDEF FPC}Pointer({$ENDIF}Py_GetArgcArgv{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'Py_GetArgcArgv');
  {$IFDEF FPC}Pointer({$ENDIF}PyInitConfig_Create{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyInitConfig_Create');
  {$IFDEF FPC}Pointer({$ENDIF}PyInitConfig_Free{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyInitConfig_Free');
  {$IFDEF FPC}Pointer({$ENDIF}PyInitConfig_GetError{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyInitConfig_GetError');
  {$IFDEF FPC}Pointer({$ENDIF}PyInitConfig_GetExitCode{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyInitConfig_GetExitCode');
  {$IFDEF FPC}Pointer({$ENDIF}PyInitConfig_HasOption{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyInitConfig_HasOption');
  {$IFDEF FPC}Pointer({$ENDIF}PyInitConfig_GetInt{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyInitConfig_GetInt');
  {$IFDEF FPC}Pointer({$ENDIF}PyInitConfig_GetStr{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyInitConfig_GetStr');
  {$IFDEF FPC}Pointer({$ENDIF}PyInitConfig_GetStrList{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyInitConfig_GetStrList');
  {$IFDEF FPC}Pointer({$ENDIF}PyInitConfig_FreeStrList{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyInitConfig_FreeStrList');
  {$IFDEF FPC}Pointer({$ENDIF}PyInitConfig_SetInt{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyInitConfig_SetInt');
  {$IFDEF FPC}Pointer({$ENDIF}PyInitConfig_SetStr{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyInitConfig_SetStr');
  {$IFDEF FPC}Pointer({$ENDIF}PyInitConfig_SetStrList{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyInitConfig_SetStrList');
  {$IFDEF FPC}Pointer({$ENDIF}PyInitConfig_AddModule{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyInitConfig_AddModule');
  {$IFDEF FPC}Pointer({$ENDIF}Py_InitializeFromInitConfig{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'Py_InitializeFromInitConfig');
end;

procedure TP4PLoader.Load_pystate;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyInterpreterState_New{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyInterpreterState_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyInterpreterState_Clear{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyInterpreterState_Clear');
  {$IFDEF FPC}Pointer({$ENDIF}PyInterpreterState_Delete{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyInterpreterState_Delete');
  {$IFDEF FPC}Pointer({$ENDIF}PyInterpreterState_Get{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyInterpreterState_Get');
  {$IFDEF FPC}Pointer({$ENDIF}PyInterpreterState_GetDict{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyInterpreterState_GetDict');
  {$IFDEF FPC}Pointer({$ENDIF}PyInterpreterState_GetID{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyInterpreterState_GetID');
  {$IFDEF FPC}Pointer({$ENDIF}PyState_AddModule{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyState_AddModule');
  {$IFDEF FPC}Pointer({$ENDIF}PyState_RemoveModule{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyState_RemoveModule');
  {$IFDEF FPC}Pointer({$ENDIF}PyState_FindModule{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyState_FindModule');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_New{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyThreadState_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_Clear{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyThreadState_Clear');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_Delete{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyThreadState_Delete');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_Get{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyThreadState_Get');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_Swap{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyThreadState_Swap');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_GetDict{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyThreadState_GetDict');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_SetAsyncExc{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyThreadState_SetAsyncExc');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_GetInterpreter{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyThreadState_GetInterpreter');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_GetFrame{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyThreadState_GetFrame');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_GetID{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyThreadState_GetID');
  {$IFDEF FPC}Pointer({$ENDIF}PyGILState_Ensure{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyGILState_Ensure');
  {$IFDEF FPC}Pointer({$ENDIF}PyGILState_Release{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyGILState_Release');
  {$IFDEF FPC}Pointer({$ENDIF}PyGILState_GetThisThreadState{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyGILState_GetThisThreadState');
  {$IFDEF FPC}Pointer({$ENDIF}PyInterpreterGuard_FromCurrent{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyInterpreterGuard_FromCurrent');
  {$IFDEF FPC}Pointer({$ENDIF}PyInterpreterGuard_Close{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyInterpreterGuard_Close');
  {$IFDEF FPC}Pointer({$ENDIF}PyInterpreterGuard_FromView{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyInterpreterGuard_FromView');
  {$IFDEF FPC}Pointer({$ENDIF}PyInterpreterView_FromCurrent{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyInterpreterView_FromCurrent');
  {$IFDEF FPC}Pointer({$ENDIF}PyInterpreterView_Close{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyInterpreterView_Close');
  {$IFDEF FPC}Pointer({$ENDIF}PyInterpreterView_FromMain{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyInterpreterView_FromMain');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_Ensure{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyThreadState_Ensure');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_EnsureFromView{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyThreadState_EnsureFromView');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_Release{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyThreadState_Release');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_GetUnchecked{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyThreadState_GetUnchecked');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_EnterTracing{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyThreadState_EnterTracing');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_LeaveTracing{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyThreadState_LeaveTracing');
  {$IFDEF FPC}Pointer({$ENDIF}PyGILState_Check{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyGILState_Check');
  {$IFDEF FPC}Pointer({$ENDIF}PyInterpreterState_Main{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyInterpreterState_Main');
  {$IFDEF FPC}Pointer({$ENDIF}PyInterpreterState_Head{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyInterpreterState_Head');
  {$IFDEF FPC}Pointer({$ENDIF}PyInterpreterState_Next{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyInterpreterState_Next');
  {$IFDEF FPC}Pointer({$ENDIF}PyInterpreterState_ThreadHead{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyInterpreterState_ThreadHead');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_Next{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyThreadState_Next');
  {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_DeleteCurrent{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyThreadState_DeleteCurrent');

  if not(assigned(PyThreadState_GetUnchecked)) then
    {$IFDEF FPC}Pointer({$ENDIF}PyThreadState_GetUnchecked{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, '_PyThreadState_UncheckedGet');
end;

procedure TP4PLoader.Load_genobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyGen_Type{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyGen_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyGen_New{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyGen_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyGen_NewWithQualName{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyGen_NewWithQualName');
  {$IFDEF FPC}Pointer({$ENDIF}PyGen_GetCode{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyGen_GetCode');
  {$IFDEF FPC}Pointer({$ENDIF}PyCoro_Type{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyCoro_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyCoro_New{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyCoro_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyAsyncGen_Type{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyAsyncGen_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyAsyncGen_New{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyAsyncGen_New');
end;

procedure TP4PLoader.Load_descrobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyClassMethodDescr_Type{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyClassMethodDescr_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyGetSetDescr_Type{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyGetSetDescr_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyMemberDescr_Type{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyMemberDescr_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyMethodDescr_Type{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyMethodDescr_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyWrapperDescr_Type{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyWrapperDescr_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyDictProxy_Type{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyDictProxy_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyProperty_Type{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyProperty_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyDescr_NewMethod{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyDescr_NewMethod');
  {$IFDEF FPC}Pointer({$ENDIF}PyDescr_NewClassMethod{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyDescr_NewClassMethod');
  {$IFDEF FPC}Pointer({$ENDIF}PyDescr_NewMember{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyDescr_NewMember');
  {$IFDEF FPC}Pointer({$ENDIF}PyDescr_NewGetSet{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyDescr_NewGetSet');
  {$IFDEF FPC}Pointer({$ENDIF}PyDictProxy_New{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyDictProxy_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyWrapper_New{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyWrapper_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyMember_GetOne{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyMember_GetOne');
  {$IFDEF FPC}Pointer({$ENDIF}PyMember_SetOne{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyMember_SetOne');
  {$IFDEF FPC}Pointer({$ENDIF}PyDescr_NewWrapper{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyDescr_NewWrapper');
  {$IFDEF FPC}Pointer({$ENDIF}PyDescr_IsData{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyDescr_IsData');
end;

procedure TP4PLoader.Load_genericaliasobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}Py_GenericAlias{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'Py_GenericAlias');
  {$IFDEF FPC}Pointer({$ENDIF}Py_GenericAliasType{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'Py_GenericAliasType');
end;

procedure TP4PLoader.Load_sentinelobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PySentinel_Type{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PySentinel_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PySentinel_New{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PySentinel_New');
end;

procedure TP4PLoader.Load_warnings;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_WarnEx{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyErr_WarnEx');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_WarnFormat{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyErr_WarnFormat');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_ResourceWarning{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyErr_ResourceWarning');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_WarnExplicit{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyErr_WarnExplicit');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_WarnExplicitObject{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyErr_WarnExplicitObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_WarnExplicitFormat{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyErr_WarnExplicitFormat');
end;

procedure TP4PLoader.Load_weakrefobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}_PyWeakref_RefType{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, '_PyWeakref_RefType');
  {$IFDEF FPC}Pointer({$ENDIF}_PyWeakref_ProxyType{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, '_PyWeakref_ProxyType');
  {$IFDEF FPC}Pointer({$ENDIF}_PyWeakref_CallableProxyType{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, '_PyWeakref_CallableProxyType');
  {$IFDEF FPC}Pointer({$ENDIF}PyWeakref_NewRef{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyWeakref_NewRef');
  {$IFDEF FPC}Pointer({$ENDIF}PyWeakref_NewProxy{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyWeakref_NewProxy');
  {$IFDEF FPC}Pointer({$ENDIF}PyWeakref_GetRef{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyWeakref_GetRef');
  {$IFDEF FPC}Pointer({$ENDIF}PyWeakref_IsDead{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyWeakref_IsDead');
end;

procedure TP4PLoader.Load_structseq;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyStructSequence_InitType{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyStructSequence_InitType');
  {$IFDEF FPC}Pointer({$ENDIF}PyStructSequence_InitType2{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyStructSequence_InitType2');
  {$IFDEF FPC}Pointer({$ENDIF}PyStructSequence_NewType{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyStructSequence_NewType');
  {$IFDEF FPC}Pointer({$ENDIF}PyStructSequence_New{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyStructSequence_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyStructSequence_SetItem{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyStructSequence_SetItem');
  {$IFDEF FPC}Pointer({$ENDIF}PyStructSequence_GetItem{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyStructSequence_GetItem');
end;

procedure TP4PLoader.Load_picklebufobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyPickleBuffer_Type{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyPickleBuffer_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyPickleBuffer_FromObject{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyPickleBuffer_FromObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyPickleBuffer_GetBuffer{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyPickleBuffer_GetBuffer');
  {$IFDEF FPC}Pointer({$ENDIF}PyPickleBuffer_Release{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyPickleBuffer_Release');
end;

procedure TP4PLoader.Load_pytime;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyTime_AsSecondsDouble{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyTime_AsSecondsDouble');
  {$IFDEF FPC}Pointer({$ENDIF}PyTime_Monotonic{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyTime_Monotonic');
  {$IFDEF FPC}Pointer({$ENDIF}PyTime_PerfCounter{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyTime_PerfCounter');
  {$IFDEF FPC}Pointer({$ENDIF}PyTime_Time{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyTime_Time');
  {$IFDEF FPC}Pointer({$ENDIF}PyTime_MonotonicRaw{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyTime_MonotonicRaw');
  {$IFDEF FPC}Pointer({$ENDIF}PyTime_PerfCounterRaw{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyTime_PerfCounterRaw');
  {$IFDEF FPC}Pointer({$ENDIF}PyTime_TimeRaw{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyTime_TimeRaw');
end;

procedure TP4PLoader.Load_codecs;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_Register{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyCodec_Register');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_Unregister{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyCodec_Unregister');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_KnownEncoding{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyCodec_KnownEncoding');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_Encode{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyCodec_Encode');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_Decode{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyCodec_Decode');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_Encoder{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyCodec_Encoder');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_Decoder{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyCodec_Decoder');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_IncrementalEncoder{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyCodec_IncrementalEncoder');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_IncrementalDecoder{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyCodec_IncrementalDecoder');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_StreamReader{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyCodec_StreamReader');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_StreamWriter{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyCodec_StreamWriter');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_RegisterError{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyCodec_RegisterError');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_LookupError{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyCodec_LookupError');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_StrictErrors{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyCodec_StrictErrors');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_IgnoreErrors{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyCodec_IgnoreErrors');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_ReplaceErrors{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyCodec_ReplaceErrors');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_XMLCharRefReplaceErrors{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyCodec_XMLCharRefReplaceErrors');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_BackslashReplaceErrors{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyCodec_BackslashReplaceErrors');
  {$IFDEF FPC}Pointer({$ENDIF}PyCodec_NameReplaceErrors{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyCodec_NameReplaceErrors');
end;

procedure TP4PLoader.Load_pythread;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_init_thread{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyThread_init_thread');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_start_new_thread{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyThread_start_new_thread');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_get_thread_ident{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyThread_get_thread_ident');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_get_thread_native_id{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyThread_get_thread_native_id');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_allocate_lock{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyThread_allocate_lock');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_free_lock{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyThread_free_lock');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_acquire_lock{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyThread_acquire_lock');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_acquire_lock_timed{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyThread_acquire_lock_timed');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_release_lock{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyThread_release_lock');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_get_stacksize{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyThread_get_stacksize');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_set_stacksize{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyThread_set_stacksize');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_GetInfo{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyThread_GetInfo');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_tss_alloc{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyThread_tss_alloc');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_tss_free{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyThread_tss_free');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_tss_is_created{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyThread_tss_is_created');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_tss_create{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyThread_tss_create');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_tss_delete{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyThread_tss_delete');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_tss_set{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyThread_tss_set');
  {$IFDEF FPC}Pointer({$ENDIF}PyThread_tss_get{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyThread_tss_get');
end;

procedure TP4PLoader.Load_context;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyContext_Type{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyContext_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyContextVar_Type{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyContextVar_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyContextToken_Type{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyContextToken_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyContext_New{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyContext_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyContext_Copy{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyContext_Copy');
  {$IFDEF FPC}Pointer({$ENDIF}PyContext_CopyCurrent{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyContext_CopyCurrent');
  {$IFDEF FPC}Pointer({$ENDIF}PyContext_Enter{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyContext_Enter');
  {$IFDEF FPC}Pointer({$ENDIF}PyContext_Exit{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyContext_Exit');
  {$IFDEF FPC}Pointer({$ENDIF}PyContext_AddWatcher{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyContext_AddWatcher');
  {$IFDEF FPC}Pointer({$ENDIF}PyContext_ClearWatcher{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyContext_ClearWatcher');
  {$IFDEF FPC}Pointer({$ENDIF}PyContextVar_New{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyContextVar_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyContextVar_Get{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyContextVar_Get');
  {$IFDEF FPC}Pointer({$ENDIF}PyContextVar_Set{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyContextVar_Set');
  {$IFDEF FPC}Pointer({$ENDIF}PyContextVar_Reset{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyContextVar_Reset');
end;

procedure TP4PLoader.Load_modsupport;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyArg_Parse{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyArg_Parse');
  {$IFDEF FPC}Pointer({$ENDIF}PyArg_ParseTuple{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyArg_ParseTuple');
  {$IFDEF FPC}Pointer({$ENDIF}PyArg_ParseTupleAndKeywords{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyArg_ParseTupleAndKeywords');
  {$IFDEF FPC}Pointer({$ENDIF}PyArg_ValidateKeywordArguments{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyArg_ValidateKeywordArguments');
  {$IFDEF FPC}Pointer({$ENDIF}PyArg_UnpackTuple{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyArg_UnpackTuple');
  {$IFDEF FPC}Pointer({$ENDIF}Py_BuildValue{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'Py_BuildValue');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_AddObjectRef{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyModule_AddObjectRef');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_Add{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyModule_Add');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_AddObject{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyModule_AddObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_AddIntConstant{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyModule_AddIntConstant');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_AddStringConstant{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyModule_AddStringConstant');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_AddType{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyModule_AddType');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_SetDocString{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyModule_SetDocString');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_AddFunctions{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyModule_AddFunctions');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_ExecDef{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyModule_ExecDef');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_Create2{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyModule_Create2');
  {$IFDEF FPC}Pointer({$ENDIF}PyModule_FromDefAndSpec2{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyModule_FromDefAndSpec2');
  {$IFDEF FPC}Pointer({$ENDIF}PyABIInfo_Check{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyABIInfo_Check');
  {$IFDEF FPC}Pointer({$ENDIF}PyArg_ParseArray{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyArg_ParseArray');
  {$IFDEF FPC}Pointer({$ENDIF}PyArg_ParseArrayAndKeywords{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyArg_ParseArrayAndKeywords');
end;

procedure TP4PLoader.Load_compile;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyCompile_OpcodeStackEffect{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyCompile_OpcodeStackEffect');
  {$IFDEF FPC}Pointer({$ENDIF}PyCompile_OpcodeStackEffectWithJump{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyCompile_OpcodeStackEffectWithJump');
end;

procedure TP4PLoader.Load_pythonrun;
begin
  {$IFDEF FPC}Pointer({$ENDIF}Py_CompileString{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'Py_CompileString');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_Print{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyErr_Print');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_PrintEx{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyErr_PrintEx');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_Display{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyErr_Display');
  {$IFDEF FPC}Pointer({$ENDIF}PyErr_DisplayException{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyErr_DisplayException');
  {$IFDEF FPC}Pointer({$ENDIF}PyOS_CheckStack{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyOS_CheckStack');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_SimpleStringFlags{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyRun_SimpleStringFlags');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_AnyFileExFlags{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyRun_AnyFileExFlags');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_SimpleFileExFlags{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyRun_SimpleFileExFlags');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_InteractiveOneFlags{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyRun_InteractiveOneFlags');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_InteractiveOneObject{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyRun_InteractiveOneObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_InteractiveLoopFlags{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyRun_InteractiveLoopFlags');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_StringFlags{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyRun_StringFlags');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_FileExFlags{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyRun_FileExFlags');
  {$IFDEF FPC}Pointer({$ENDIF}Py_CompileStringFlags{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'Py_CompileStringFlags');
  {$IFDEF FPC}Pointer({$ENDIF}Py_CompileStringExFlags{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'Py_CompileStringExFlags');
  {$IFDEF FPC}Pointer({$ENDIF}Py_CompileStringObject{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'Py_CompileStringObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_String{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyRun_String');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_AnyFile{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyRun_AnyFile');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_AnyFileEx{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyRun_AnyFileEx');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_AnyFileFlags{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyRun_AnyFileFlags');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_SimpleString{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyRun_SimpleString');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_SimpleFile{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyRun_SimpleFile');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_SimpleFileEx{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyRun_SimpleFileEx');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_InteractiveOne{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyRun_InteractiveOne');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_InteractiveLoop{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyRun_InteractiveLoop');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_File{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyRun_File');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_FileEx{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyRun_FileEx');
  {$IFDEF FPC}Pointer({$ENDIF}PyRun_FileFlags{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyRun_FileFlags');
  {$IFDEF FPC}Pointer({$ENDIF}PyOS_Readline{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyOS_Readline');
end;

procedure TP4PLoader.Load_pylifecycle;
begin
  {$IFDEF FPC}Pointer({$ENDIF}Py_Initialize{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'Py_Initialize');
  {$IFDEF FPC}Pointer({$ENDIF}Py_InitializeEx{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'Py_InitializeEx');
  {$IFDEF FPC}Pointer({$ENDIF}Py_Finalize{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'Py_Finalize');
  {$IFDEF FPC}Pointer({$ENDIF}Py_FinalizeEx{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'Py_FinalizeEx');
  {$IFDEF FPC}Pointer({$ENDIF}Py_IsInitialized{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'Py_IsInitialized');
  {$IFDEF FPC}Pointer({$ENDIF}Py_NewInterpreter{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'Py_NewInterpreter');
  {$IFDEF FPC}Pointer({$ENDIF}Py_EndInterpreter{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'Py_EndInterpreter');
  {$IFDEF FPC}Pointer({$ENDIF}Py_AtExit{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'Py_AtExit');
  {$IFDEF FPC}Pointer({$ENDIF}Py_Exit{$IFDEF FPC}){$ENDIF}                       := GetProcAddress(FLibHandle, 'Py_Exit');
  {$IFDEF FPC}Pointer({$ENDIF}Py_Main{$IFDEF FPC}){$ENDIF}                       := GetProcAddress(FLibHandle, 'Py_Main');
  {$IFDEF FPC}Pointer({$ENDIF}Py_BytesMain{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'Py_BytesMain');
  {$IFDEF FPC}Pointer({$ENDIF}Py_SetProgramName{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'Py_SetProgramName');
  {$IFDEF FPC}Pointer({$ENDIF}Py_GetProgramName{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'Py_GetProgramName');
  {$IFDEF FPC}Pointer({$ENDIF}Py_SetPythonHome{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'Py_SetPythonHome');
  {$IFDEF FPC}Pointer({$ENDIF}Py_GetPythonHome{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'Py_GetPythonHome');
  {$IFDEF FPC}Pointer({$ENDIF}Py_GetProgramFullPath{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'Py_GetProgramFullPath');
  {$IFDEF FPC}Pointer({$ENDIF}Py_GetPrefix{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'Py_GetPrefix');
  {$IFDEF FPC}Pointer({$ENDIF}Py_GetExecPrefix{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'Py_GetExecPrefix');
  {$IFDEF FPC}Pointer({$ENDIF}Py_GetPath{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'Py_GetPath');
  {$IFDEF FPC}Pointer({$ENDIF}Py_GetVersion{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'Py_GetVersion');
  {$IFDEF FPC}Pointer({$ENDIF}Py_GetPlatform{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'Py_GetPlatform');
  {$IFDEF FPC}Pointer({$ENDIF}Py_GetCopyright{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'Py_GetCopyright');
  {$IFDEF FPC}Pointer({$ENDIF}Py_GetCompiler{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'Py_GetCompiler');
  {$IFDEF FPC}Pointer({$ENDIF}Py_GetBuildInfo{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'Py_GetBuildInfo');
  {$IFDEF FPC}Pointer({$ENDIF}PyOS_getsig{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyOS_getsig');
  {$IFDEF FPC}Pointer({$ENDIF}PyOS_setsig{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyOS_setsig');
  {$IFDEF FPC}Pointer({$ENDIF}Py_Version{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'Py_Version');
  {$IFDEF FPC}Pointer({$ENDIF}Py_IsFinalizing{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'Py_IsFinalizing');
  {$IFDEF FPC}Pointer({$ENDIF}Py_PreInitialize{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'Py_PreInitialize');
  {$IFDEF FPC}Pointer({$ENDIF}Py_PreInitializeFromBytesArgs{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'Py_PreInitializeFromBytesArgs');
  {$IFDEF FPC}Pointer({$ENDIF}Py_PreInitializeFromArgs{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'Py_PreInitializeFromArgs');
  {$IFDEF FPC}Pointer({$ENDIF}Py_InitializeFromConfig{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'Py_InitializeFromConfig');
  {$IFDEF FPC}Pointer({$ENDIF}Py_RunMain{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'Py_RunMain');
  {$IFDEF FPC}Pointer({$ENDIF}Py_ExitStatusException{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'Py_ExitStatusException');
  {$IFDEF FPC}Pointer({$ENDIF}Py_FdIsInteractive{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'Py_FdIsInteractive');
  {$IFDEF FPC}Pointer({$ENDIF}Py_NewInterpreterFromConfig{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'Py_NewInterpreterFromConfig');
end;

procedure TP4PLoader.Load_ceval;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_EvalCode{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyEval_EvalCode');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_EvalCodeEx{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyEval_EvalCodeEx');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_GetBuiltins{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyEval_GetBuiltins');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_GetGlobals{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyEval_GetGlobals');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_GetLocals{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyEval_GetLocals');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_GetFrame{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyEval_GetFrame');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_GetFrameBuiltins{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyEval_GetFrameBuiltins');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_GetFrameGlobals{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyEval_GetFrameGlobals');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_GetFrameLocals{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyEval_GetFrameLocals');
  {$IFDEF FPC}Pointer({$ENDIF}Py_AddPendingCall{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'Py_AddPendingCall');
  {$IFDEF FPC}Pointer({$ENDIF}Py_MakePendingCalls{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'Py_MakePendingCalls');
  {$IFDEF FPC}Pointer({$ENDIF}Py_SetRecursionLimit{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'Py_SetRecursionLimit');
  {$IFDEF FPC}Pointer({$ENDIF}Py_GetRecursionLimit{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'Py_GetRecursionLimit');
  {$IFDEF FPC}Pointer({$ENDIF}Py_EnterRecursiveCall{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'Py_EnterRecursiveCall');
  {$IFDEF FPC}Pointer({$ENDIF}Py_LeaveRecursiveCall{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'Py_LeaveRecursiveCall');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_GetFuncName{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyEval_GetFuncName');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_GetFuncDesc{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyEval_GetFuncDesc');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_EvalFrame{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyEval_EvalFrame');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_EvalFrameEx{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyEval_EvalFrameEx');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_SaveThread{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyEval_SaveThread');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_RestoreThread{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyEval_RestoreThread');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_AcquireThread{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyEval_AcquireThread');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_ReleaseThread{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyEval_ReleaseThread');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_SetProfile{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyEval_SetProfile');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_SetProfileAllThreads{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyEval_SetProfileAllThreads');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_SetTrace{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyEval_SetTrace');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_SetTraceAllThreads{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyEval_SetTraceAllThreads');
  {$IFDEF FPC}Pointer({$ENDIF}PyEval_MergeCompilerFlags{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyEval_MergeCompilerFlags');
end;

procedure TP4PLoader.Load_sysmodule;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PySys_GetAttr{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PySys_GetAttr');
  {$IFDEF FPC}Pointer({$ENDIF}PySys_GetAttrString{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PySys_GetAttrString');
  {$IFDEF FPC}Pointer({$ENDIF}PySys_GetOptionalAttr{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PySys_GetOptionalAttr');
  {$IFDEF FPC}Pointer({$ENDIF}PySys_GetOptionalAttrString{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PySys_GetOptionalAttrString');
  {$IFDEF FPC}Pointer({$ENDIF}PySys_GetObject{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PySys_GetObject');
  {$IFDEF FPC}Pointer({$ENDIF}PySys_SetObject{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PySys_SetObject');
  {$IFDEF FPC}Pointer({$ENDIF}PySys_WriteStdout{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PySys_WriteStdout');
  {$IFDEF FPC}Pointer({$ENDIF}PySys_WriteStderr{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PySys_WriteStderr');
  {$IFDEF FPC}Pointer({$ENDIF}PySys_FormatStdout{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PySys_FormatStdout');
  {$IFDEF FPC}Pointer({$ENDIF}PySys_FormatStderr{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PySys_FormatStderr');
  {$IFDEF FPC}Pointer({$ENDIF}PySys_GetXOptions{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PySys_GetXOptions');
end;

procedure TP4PLoader.Load_audit;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PySys_Audit{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PySys_Audit');
  {$IFDEF FPC}Pointer({$ENDIF}PySys_AuditTuple{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PySys_AuditTuple');
  {$IFDEF FPC}Pointer({$ENDIF}PySys_AddAuditHook{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PySys_AddAuditHook');
end;

procedure TP4PLoader.Load_osmodule;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyOS_FSPath{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyOS_FSPath');
end;

procedure TP4PLoader.Load_intrcheck;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyOS_InterruptOccurred{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyOS_InterruptOccurred');
end;

procedure TP4PLoader.Load_import;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_GetMagicNumber{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyImport_GetMagicNumber');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_GetMagicTag{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyImport_GetMagicTag');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_ExecCodeModule{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyImport_ExecCodeModule');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_ExecCodeModuleEx{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyImport_ExecCodeModuleEx');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_ExecCodeModuleWithPathnames{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyImport_ExecCodeModuleWithPathnames');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_ExecCodeModuleObject{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyImport_ExecCodeModuleObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_GetModuleDict{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyImport_GetModuleDict');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_GetModule{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyImport_GetModule');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_AddModuleObject{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyImport_AddModuleObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_AddModule{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyImport_AddModule');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_AddModuleRef{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyImport_AddModuleRef');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_ImportModule{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyImport_ImportModule');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_ImportModuleLevel{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyImport_ImportModuleLevel');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_ImportModuleLevelObject{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyImport_ImportModuleLevelObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_GetImporter{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyImport_GetImporter');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_Import{$IFDEF FPC}){$ENDIF}                      := GetProcAddress(FLibHandle, 'PyImport_Import');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_ReloadModule{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyImport_ReloadModule');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_ImportFrozenModuleObject{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyImport_ImportFrozenModuleObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_ImportFrozenModule{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyImport_ImportFrozenModule');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_AppendInittab{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyImport_AppendInittab');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_SetLazyImportsMode{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyImport_SetLazyImportsMode');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_SetLazyImportsFilter{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyImport_SetLazyImportsFilter');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_GetLazyImportsMode{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyImport_GetLazyImportsMode');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_GetLazyImportsFilter{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyImport_GetLazyImportsFilter');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_Inittab{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'PyImport_Inittab');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_ExtendInittab{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyImport_ExtendInittab');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_CreateModuleFromInitfunc{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyImport_CreateModuleFromInitfunc');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_FrozenModules{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyImport_FrozenModules');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_ImportModuleAttr{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyImport_ImportModuleAttr');
  {$IFDEF FPC}Pointer({$ENDIF}PyImport_ImportModuleAttrString{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyImport_ImportModuleAttrString');
end;

procedure TP4PLoader.Load_abstract;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_CallNoArgs{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyObject_CallNoArgs');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Call{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyObject_Call');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_CallObject{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyObject_CallObject');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_CallFunction{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyObject_CallFunction');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_CallMethod{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyObject_CallMethod');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_CallFunctionObjArgs{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyObject_CallFunctionObjArgs');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_CallMethodObjArgs{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyObject_CallMethodObjArgs');
  {$IFDEF FPC}Pointer({$ENDIF}PyVectorcall_NARGS{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyVectorcall_NARGS');
  {$IFDEF FPC}Pointer({$ENDIF}PyVectorcall_Call{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyVectorcall_Call');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Vectorcall{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyObject_Vectorcall');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_VectorcallMethod{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyObject_VectorcallMethod');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Type{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyObject_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Size{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyObject_Size');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Length{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyObject_Length');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GetItem{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyObject_GetItem');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_SetItem{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyObject_SetItem');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_DelItemString{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyObject_DelItemString');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_DelItem{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyObject_DelItem');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_Format{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyObject_Format');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GetIter{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyObject_GetIter');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_GetAIter{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyObject_GetAIter');
  {$IFDEF FPC}Pointer({$ENDIF}PyIter_Check{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyIter_Check');
  {$IFDEF FPC}Pointer({$ENDIF}PyAIter_Check{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyAIter_Check');
  {$IFDEF FPC}Pointer({$ENDIF}PyIter_NextItem{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyIter_NextItem');
  {$IFDEF FPC}Pointer({$ENDIF}PyIter_Next{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'PyIter_Next');
  {$IFDEF FPC}Pointer({$ENDIF}PyIter_Send{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'PyIter_Send');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Check{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyNumber_Check');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Add{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyNumber_Add');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Subtract{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyNumber_Subtract');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Multiply{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyNumber_Multiply');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_MatrixMultiply{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyNumber_MatrixMultiply');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_FloorDivide{$IFDEF FPC}){$ENDIF}            := GetProcAddress(FLibHandle, 'PyNumber_FloorDivide');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_TrueDivide{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyNumber_TrueDivide');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Remainder{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyNumber_Remainder');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Divmod{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyNumber_Divmod');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Power{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyNumber_Power');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Negative{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyNumber_Negative');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Positive{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyNumber_Positive');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Absolute{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PyNumber_Absolute');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Invert{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyNumber_Invert');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Lshift{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyNumber_Lshift');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Rshift{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyNumber_Rshift');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_And{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyNumber_And');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Xor{$IFDEF FPC}){$ENDIF}                    := GetProcAddress(FLibHandle, 'PyNumber_Xor');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Or{$IFDEF FPC}){$ENDIF}                     := GetProcAddress(FLibHandle, 'PyNumber_Or');
  {$IFDEF FPC}Pointer({$ENDIF}PyIndex_Check{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyIndex_Check');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Index{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyNumber_Index');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_AsSsize_t{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyNumber_AsSsize_t');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Long{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyNumber_Long');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_Float{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyNumber_Float');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_InPlaceAdd{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyNumber_InPlaceAdd');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_InPlaceSubtract{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyNumber_InPlaceSubtract');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_InPlaceMultiply{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PyNumber_InPlaceMultiply');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_InPlaceMatrixMultiply{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyNumber_InPlaceMatrixMultiply');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_InPlaceFloorDivide{$IFDEF FPC}){$ENDIF}     := GetProcAddress(FLibHandle, 'PyNumber_InPlaceFloorDivide');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_InPlaceTrueDivide{$IFDEF FPC}){$ENDIF}      := GetProcAddress(FLibHandle, 'PyNumber_InPlaceTrueDivide');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_InPlaceRemainder{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyNumber_InPlaceRemainder');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_InPlacePower{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyNumber_InPlacePower');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_InPlaceLshift{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyNumber_InPlaceLshift');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_InPlaceRshift{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyNumber_InPlaceRshift');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_InPlaceAnd{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyNumber_InPlaceAnd');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_InPlaceXor{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyNumber_InPlaceXor');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_InPlaceOr{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PyNumber_InPlaceOr');
  {$IFDEF FPC}Pointer({$ENDIF}PyNumber_ToBase{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyNumber_ToBase');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_Check{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PySequence_Check');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_Size{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PySequence_Size');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_Length{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PySequence_Length');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_Concat{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PySequence_Concat');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_Repeat{$IFDEF FPC}){$ENDIF}               := GetProcAddress(FLibHandle, 'PySequence_Repeat');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_GetItem{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PySequence_GetItem');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_GetSlice{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PySequence_GetSlice');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_SetItem{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PySequence_SetItem');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_DelItem{$IFDEF FPC}){$ENDIF}              := GetProcAddress(FLibHandle, 'PySequence_DelItem');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_SetSlice{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PySequence_SetSlice');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_DelSlice{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PySequence_DelSlice');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_Tuple{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PySequence_Tuple');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_List{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PySequence_List');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_Fast{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PySequence_Fast');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_Count{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PySequence_Count');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_Contains{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PySequence_Contains');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_In{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PySequence_In');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_Index{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PySequence_Index');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_InPlaceConcat{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PySequence_InPlaceConcat');
  {$IFDEF FPC}Pointer({$ENDIF}PySequence_InPlaceRepeat{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'PySequence_InPlaceRepeat');
  {$IFDEF FPC}Pointer({$ENDIF}PyMapping_Check{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyMapping_Check');
  {$IFDEF FPC}Pointer({$ENDIF}PyMapping_Size{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyMapping_Size');
  {$IFDEF FPC}Pointer({$ENDIF}PyMapping_Length{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyMapping_Length');
  {$IFDEF FPC}Pointer({$ENDIF}PyMapping_HasKeyString{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyMapping_HasKeyString');
  {$IFDEF FPC}Pointer({$ENDIF}PyMapping_HasKey{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyMapping_HasKey');
  {$IFDEF FPC}Pointer({$ENDIF}PyMapping_HasKeyWithError{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyMapping_HasKeyWithError');
  {$IFDEF FPC}Pointer({$ENDIF}PyMapping_HasKeyStringWithError{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyMapping_HasKeyStringWithError');
  {$IFDEF FPC}Pointer({$ENDIF}PyMapping_Keys{$IFDEF FPC}){$ENDIF}                  := GetProcAddress(FLibHandle, 'PyMapping_Keys');
  {$IFDEF FPC}Pointer({$ENDIF}PyMapping_Values{$IFDEF FPC}){$ENDIF}                := GetProcAddress(FLibHandle, 'PyMapping_Values');
  {$IFDEF FPC}Pointer({$ENDIF}PyMapping_Items{$IFDEF FPC}){$ENDIF}                 := GetProcAddress(FLibHandle, 'PyMapping_Items');
  {$IFDEF FPC}Pointer({$ENDIF}PyMapping_GetItemString{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyMapping_GetItemString');
  {$IFDEF FPC}Pointer({$ENDIF}PyMapping_GetOptionalItem{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'PyMapping_GetOptionalItem');
  {$IFDEF FPC}Pointer({$ENDIF}PyMapping_GetOptionalItemString{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyMapping_GetOptionalItemString');
  {$IFDEF FPC}Pointer({$ENDIF}PyMapping_SetItemString{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyMapping_SetItemString');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_IsInstance{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyObject_IsInstance');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_IsSubclass{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyObject_IsSubclass');
  {$IFDEF FPC}Pointer({$ENDIF}PyVectorcall_Function{$IFDEF FPC}){$ENDIF}           := GetProcAddress(FLibHandle, 'PyVectorcall_Function');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_VectorcallDict{$IFDEF FPC}){$ENDIF}         := GetProcAddress(FLibHandle, 'PyObject_VectorcallDict');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_CallOneArg{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyObject_CallOneArg');
  {$IFDEF FPC}Pointer({$ENDIF}PyObject_LengthHint{$IFDEF FPC}){$ENDIF}             := GetProcAddress(FLibHandle, 'PyObject_LengthHint');
end;

procedure TP4PLoader.Load_bltinmodule;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyFilter_Type{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyFilter_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyMap_Type{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyMap_Type');
  {$IFDEF FPC}Pointer({$ENDIF}PyZip_Type{$IFDEF FPC}){$ENDIF}    := GetProcAddress(FLibHandle, 'PyZip_Type');
end;

procedure TP4PLoader.Load_pystrtod;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyOS_string_to_double{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyOS_string_to_double');
  {$IFDEF FPC}Pointer({$ENDIF}PyOS_double_to_string{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyOS_double_to_string');
end;

procedure TP4PLoader.Load_pystrcmp;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyOS_mystrnicmp{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyOS_mystrnicmp');
  {$IFDEF FPC}Pointer({$ENDIF}PyOS_mystricmp{$IFDEF FPC}){$ENDIF}  := GetProcAddress(FLibHandle, 'PyOS_mystricmp');
end;

procedure TP4PLoader.Load_fileutils;
begin
  {$IFDEF FPC}Pointer({$ENDIF}Py_DecodeLocale{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'Py_DecodeLocale');
  {$IFDEF FPC}Pointer({$ENDIF}Py_EncodeLocale{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'Py_EncodeLocale');
  {$IFDEF FPC}Pointer({$ENDIF}Py_fopen{$IFDEF FPC}){$ENDIF}        := GetProcAddress(FLibHandle, 'Py_fopen');
  {$IFDEF FPC}Pointer({$ENDIF}Py_fclose{$IFDEF FPC}){$ENDIF}       := GetProcAddress(FLibHandle, 'Py_fclose');
end;

procedure TP4PLoader.Load_tracemalloc;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyTraceMalloc_Track{$IFDEF FPC}){$ENDIF}   := GetProcAddress(FLibHandle, 'PyTraceMalloc_Track');
  {$IFDEF FPC}Pointer({$ENDIF}PyTraceMalloc_Untrack{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyTraceMalloc_Untrack');
end;

procedure TP4PLoader.Load_frameobject;
begin
  {$IFDEF FPC}Pointer({$ENDIF}PyFrame_New{$IFDEF FPC}){$ENDIF}                   := GetProcAddress(FLibHandle, 'PyFrame_New');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrame_LocalsToFast{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyFrame_LocalsToFast');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrame_FastToLocalsWithError{$IFDEF FPC}){$ENDIF} := GetProcAddress(FLibHandle, 'PyFrame_FastToLocalsWithError');
  {$IFDEF FPC}Pointer({$ENDIF}PyFrame_FastToLocals{$IFDEF FPC}){$ENDIF}          := GetProcAddress(FLibHandle, 'PyFrame_FastToLocals');
end;

end.

