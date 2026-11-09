unit uP4P.MiscFunctions;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    {$IFDEF MSWINDOWS}WinApi.Windows,{$ENDIF} System.Classes, System.StrUtils,
    {$IFDEF FMX}FMX.Types, FMX.Platform,{$ENDIF} System.SysUtils, System.IOUtils, System.Types,
    {$IFDEF MACOS}
    System.UITypes, FMX.Helpers.Mac, System.Messaging, Macapi.CoreFoundation, Macapi.Foundation,
    {$ENDIF}
  {$ELSE}
    {$IFDEF MSWINDOWS}Windows,{$ENDIF} Classes, SysUtils, Types, StrUtils,
    {$IFDEF FPC}LazFileUtils,{$ENDIF}
  {$ENDIF}
  uP4P.Types;

/// <summary>
/// Retrieves the fully qualified path for the current module.
/// </summary>
/// <remarks>
/// <para><see href="https://learn.microsoft.com/en-us/windows/win32/api/libloaderapi/nf-libloaderapi-getmodulefilenamew">See the GetModuleFileNameW article.</see></para>
/// </remarks>
function  GetModulePath : string;
procedure OutputDebugMessage(const aMessage : string);
function  CustomExceptionHandler(const aFunctionName : string; const aException : exception) : boolean;
/// <summary>
/// Custom function to show a message dialog.
/// </summary>
procedure ShowErrorMessageDlg(const aError : string);
/// <summary>
/// Return True if this is a 32 bit process.
/// </summary>
function  Is32BitProcess : boolean;
/// <summary>
/// Custom function to get the current thread ID.
/// </summary>
function  CustomGetCurrentThreadId: TThreadID;
/// <summary>
/// Custom function to get the file size.
/// </summary>
function  GetFileSize(const aFilename: string): int64;
/// <summary>
/// Custom function to find all the files in a directory.
/// </summary>
function  CustomFindAllFiles(const aPath, aFilename: string): TStringList;
{$IFNDEF DELPHI14_UP}{$IFNDEF FPC}
function  CharInSet(const aChar: char; const aCharSet: TSysCharSet) : boolean;
{$ENDIF}{$ENDIF}

/// <summary>
/// Convert a UTF8 Python string to a wide string.
/// </summary>
function PyUTF8ToWideString(aString: PAnsiChar; aFreeMem : boolean = False): WideString;     
/// <summary>
/// Convert a wide string to a UTF8 Python string.
/// </summary>
function WideStringToPyUTF8(const aWideString: WideString): AnsiString;
/// <summary>
/// Convert a unicode string to a UTF8 Python string.
/// </summary>
function UnicodeStringToPyUTF8(const aUnicodeString: UnicodeString): AnsiString;
/// <summary>
/// Convert a UTF8 Python string to a regular string.
/// </summary>
function PyUTF8ToString(aString: PAnsiChar; aFreeMem : boolean = False): string;
/// <summary>
/// Convert a regular string to a UTF8 Python string.
/// </summary>
function StringToPyUTF8(const aString: string): AnsiString;

{$IFDEF MSWINDOWS}
function ProcessUnderWow64(hProcess: THandle; Wow64Process: PBOOL): BOOL; stdcall; external 'kernel32.dll' name 'IsWow64Process';
/// <summary>
/// Convert a UnicodeString to AnsiString.
/// </summary>
function UnicodeStringToAnsiString(const aString: UnicodeString): AnsiString;
/// <summary>
/// Convert an AnsiString to UnicodeString.
/// </summary>
function AnsiStringToUnicodeString(const aString: AnsiString): UnicodeString;
/// <summary>
/// Return True if this is a 32 bit process running in a 64 bit OS.
/// </summary>
function Is32BitProcessRunningIn64BitOS : boolean;
/// <summary>
/// Returns the machine type information from the DLL header.
/// </summary>
function GetDLLHeaderMachine(const aDLLFile : string; var aMachine : integer) : boolean;

function GetTempDirectory: string;
{$ENDIF}

/// <summary>
/// Convert a wide string to a regular string.
/// </summary>
function PyWCharTStringToString(const aString: WCharTString): string;
/// <summary>
/// Convert a regular string to a wide string.
/// </summary>
function StringToPyWCharTString(const aString: string): WCharTString;

/// <summary>
/// Convert an array of wide strings to a TStringList.
/// </summary>
function WCharTArrayToStringList(aItems: PPWCharT; aLength: NativeInt; var aResultSL: TStringList): boolean;
/// <summary>
/// Convert a list of wide strings to a TStringList.
/// </summary>
function PyWideStringListToStringList(const aList: PyWideStringList; var aResultSL: TStringList): boolean;

/// <summary>
/// Convert an array of wide strings to a TStringDynArray.
/// </summary>
function WCharTArrayToStringDynArray(aItems: PPWCharT; aLength: NativeInt; var aResult: TStringDynArray): boolean;
/// <summary>
/// Convert a list of wide strings to a TStringDynArray.
/// </summary>
function PyWideStringListToStringDynArray(const aList: PyWideStringList; var aResult: TStringDynArray): boolean;

/// <summary>
/// Convert a error (TPyCodecErrors) to an AnsiString.
/// </summary>
function ErrorToAnsiString(error: TPyCodecErrors): AnsiString;
/// <summary>
/// Convert a start symbol (TPyStartSymbols) to an integer.
/// </summary>
function PyStartSymbolToInt(start: TPyStartSymbols): integer;

/// <summary>
/// Custom function to split strings with delimeters.
/// </summary>
function CustomSplitString(const S, Delimiters: string): TStringDynArray;

{$IFDEF APPLE}
{$IFDEF FPC}
{$linklib System}
function _dyld_get_image_name(imageIndex: LongWord): PChar; cdecl; external name '_dyld_get_image_name';
function _dyld_image_count: LongWord; cdecl; external name '_dyld_image_count';
{$ELSE}
const
  libSystem = '/usr/lib/libSystem.dylib';

function _dyld_image_count: UInt32; cdecl; external libSystem name '_dyld_image_count';
{$ENDIF}
{$ENDIF}

implementation

uses
  {$IFDEF LINUXFPC}lcltype,{$ENDIF}
  uP4P.Engine, uP4P.PyMem, uP4P.Constants;

function GetModulePath : string;
{$IFDEF APPLE}
const
  MAC_APP_POSTFIX = '.app/';
  MAC_APP_SUBPATH = 'Contents/MacOS/';
{$ENDIF}
begin
  {$IFDEF MSWINDOWS}
  Result := IncludeTrailingPathDelimiter(ExtractFileDir(GetModuleName(HINSTANCE{$IFDEF FPC}(){$ENDIF})));
  {$ENDIF}

  {$IFDEF LINUX}
  Result := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)));
  {$ENDIF}

  {$IFDEF ANDROID}
  Result := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)));
  {$ENDIF}

  {$IFDEF APPLE}
  Result := IncludeTrailingPathDelimiter(ExtractFileDir(ParamStr(0)));

  {$IFDEF FPC}
  if copy(Result, Length(Result) + 1 - Length(MAC_APP_POSTFIX) - Length(MAC_APP_SUBPATH)) = MAC_APP_POSTFIX + MAC_APP_SUBPATH then
    SetLength(Result, Length(Result) - Length(MAC_APP_SUBPATH));

  Result := CreateAbsolutePath(Result, GetCurrentDirUTF8);
  {$ELSE}
  if Result.Contains(MAC_APP_POSTFIX + MAC_APP_SUBPATH) then
    Result := Result.Remove(Result.IndexOf(MAC_APP_SUBPATH));
  {$ENDIF}
  {$ENDIF}
end;

procedure OutputDebugMessage(const aMessage : string);
begin
  {$IFDEF DEBUG}
    {$IFDEF MSWINDOWS}
      {$IFDEF FMX}
        FMX.Types.Log.d(aMessage);
      {$ELSE}
        OutputDebugString({$IFDEF DELPHI12_UP}PWideChar{$ELSE}PAnsiChar{$ENDIF}(aMessage + chr(0)));
      {$ENDIF}
    {$ENDIF}

    {$IFDEF LINUX}
      {$IFDEF FPC}
        // TO-DO: Find a way to write in the error console using Lazarus in Linux
      {$ELSE}
        FMX.Types.Log.d(aMessage);
      {$ENDIF}
    {$ENDIF}

    {$IFDEF ANDROID}
      {$IFDEF FPC}
        // TO-DO: Find a way to write in the error console using Lazarus in Android
      {$ELSE}
        FMX.Types.Log.d(aMessage);
      {$ENDIF}
    {$ENDIF}

    {$IFDEF APPLE}
      {$IFDEF FPC}
        // TO-DO: Find a way to write in the error console using Lazarus in MacOS
      {$ELSE}
        FMX.Types.Log.d(aMessage);
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
end;

function CustomExceptionHandler(const aFunctionName : string; const aException : exception) : boolean;
begin
  OutputDebugMessage(aFunctionName + ' error : ' + aException.message);

  Result := (GlobalP4PEngine <> nil) and GlobalP4PEngine.ReRaiseExceptions;
end;

{$IFDEF MACOS}
procedure ShowMessageCF(const aHeading, aMessage : string; const aTimeoutInSecs : double = 0);
var
  TempHeading, TempMessage : CFStringRef;
  TempResponse : CFOptionFlags;
begin
  TempHeading := CFStringCreateWithCharactersNoCopy(nil, PChar(aHeading), Length(AHeading), kCFAllocatorNull);
  TempMessage := CFStringCreateWithCharactersNoCopy(nil, PChar(aMessage), Length(AMessage), kCFAllocatorNull);

  try
    CFUserNotificationDisplayAlert(aTimeoutInSecs, kCFUserNotificationNoteAlertLevel, nil, nil, nil, TempHeading, TempMessage, nil, nil, nil, TempResponse);
  finally
    CFRelease(TempHeading);
    CFRelease(TempMessage);
  end;
end;
{$ENDIF}

procedure ShowErrorMessageDlg(const aError : string);
begin
  OutputDebugMessage(aError);

  if (GlobalP4PEngine <> nil) and GlobalP4PEngine.ShowMessageDlg then
    begin
      {$IFDEF MSWINDOWS}
      MessageBox(0, PChar(aError + #0), PChar('Error' + #0), MB_ICONERROR or MB_OK or MB_TOPMOST);
      {$ENDIF}

      {$IF DEFINED(LINUX) OR DEFINED(ANDROID)}
        {$IFDEF FPC}
        // if (DisplayServer = ldsX11) then ShowX11Message(aError);
        {$ELSE}
        // TO-DO: Find a way to show message boxes in FMXLinux
        {$ENDIF}
      {$IFEND}

      {$IFDEF MACOSX}
        {$IFDEF FPC}
        // TO-DO: Find a way to show message boxes in Lazarus/FPC for MacOS
        {$ELSE}
        ShowMessageCF('Error', aError, 10);
        {$ENDIF}
      {$ENDIF}
    end;
end;

function Is32BitProcess : boolean;
begin
  {$IFDEF TARGET_32BITS}
  Result := True;
  {$ELSE}
    {$IFDEF MSWINDOWS}
    Result := Is32BitProcessRunningIn64BitOS;
    {$ELSE}
      {$IFDEF DELPHI17_UP}
        Result := TOSVersion.Architecture in [arIntelX86, arARM32];
      {$ELSE}
        Result := False;
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
end;

function CustomGetCurrentThreadId: TThreadID;
begin
  {$IF DEFINED(DELPHI16_UP) OR DEFINED(FPC)}
  if assigned(TThread.CurrentThread) then
    Result := TThread.CurrentThread.ThreadID
   else
    Result := TThreadID(0);
  {$ELSE}
  Result := GetCurrentThreadId();
  {$IFEND}
end;

function PyUTF8ToWideString(aString: PAnsiChar; aFreeMem : boolean): WideString;
begin
  if assigned(aString) then
    begin
      {$IFDEF FPC}
      Result := UTF8Decode(AnsiString(aString));
      {$ELSE}
        {$IFDEF DELPHI12_UP}
        Result := UTF8ToString(RawByteString(aString));
        {$ELSE}
        Result := UTF8Decode(UTF8String(aString));
        {$ENDIF}
      {$ENDIF}
      if aFreeMem then
        TPyMem.Free(aString);
    end
   else
    Result := '';
end;

function WideStringToPyUTF8(const aWideString: WideString): AnsiString;
begin
  Result := UTF8Encode(aWideString) + #0;
end;

function UnicodeStringToPyUTF8(const aUnicodeString: UnicodeString): AnsiString;
begin
  Result := UTF8Encode(aUnicodeString) + #0;
end;

function PyUTF8ToString(aString: PAnsiChar; aFreeMem : boolean): string;
begin
  if assigned(aString) then
    begin
      {$IFDEF FPC}
      Result := aString;
      {$ELSE}
        {$IFDEF DELPHI12_UP}
        Result := UTF8ToString(RawByteString(aString));
        {$ELSE}
        Result := UTF8Decode(UTF8String(aString));
        {$ENDIF}
      {$ENDIF}
      if aFreeMem then
        TPyMem.Free(aString);
    end
   else
    Result := '';
end;

function StringToPyUTF8(const aString: string): AnsiString;
begin
  {$IFDEF FPC}
  Result := aString + #0;
  {$ELSE}
  Result := UTF8Encode(aString) + #0;
  {$ENDIF}
end;

{$IFDEF MSWINDOWS}
function UnicodeStringToAnsiString(const aString: UnicodeString): AnsiString;
const
  WC_NO_BEST_FIT_CHARS = $400;
var
  TempLen : integer;
begin
  TempLen := WideCharToMultiByte(CP_ACP, WC_NO_BEST_FIT_CHARS, PWideChar(aString), length(aString), nil, 0, nil, nil);
  Result  := '';

  if (TempLen > 0) then
    begin
      SetLength(Result, TempLen);
      WideCharToMultiByte(CP_ACP, WC_NO_BEST_FIT_CHARS, PWideChar(aString), length(aString), @Result[1], TempLen, nil, nil);
    end;
end;

function AnsiStringToUnicodeString(const aString: AnsiString): UnicodeString;
var
  TempLen : integer;
begin
  TempLen := MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, @aString[1], -1, nil, 0);
  Result  := '';

  if (TempLen > 0) then
    begin
      SetLength(Result, TempLen);
      MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, @aString[1], -1, PWideChar(Result), TempLen);
    end;
end;

function Is32BitProcessRunningIn64BitOS : boolean;
var
  TempResult : BOOL;
begin
  Result := ProcessUnderWow64(GetCurrentProcess, @TempResult) and
            TempResult;
end;

// This function is based on the answer given by 'Alex' in StackOverflow
// https://stackoverflow.com/questions/2748474/how-to-determine-if-dll-file-was-compiled-as-x64-or-x86-bit-using-either-delphi
function GetDLLHeaderMachine(const aDLLFile : string; var aMachine : integer) : boolean;
var
  TempHeader         : TImageDosHeader;
  TempImageNtHeaders : TImageNtHeaders;
  TempStream         : TFileStream;
begin
  Result     := False;
  aMachine   := IMAGE_FILE_MACHINE_UNKNOWN;
  TempStream := nil;

  try
    try
      if FileExists(aDLLFile) then
        begin                                    
          FillChar(TempHeader, SizeOf(TImageDosHeader), 0);
          FillChar(TempImageNtHeaders, SizeOf(TImageNtHeaders), 0);

          TempStream := TFileStream.Create(aDLLFile, fmOpenRead or fmShareDenyWrite);
          TempStream.seek(0, soFromBeginning);
          TempStream.ReadBuffer(TempHeader, SizeOf(TempHeader));

          if (TempHeader.e_magic = IMAGE_DOS_SIGNATURE) and
             (TempHeader._lfanew <> 0) then
            begin
              TempStream.Position := TempHeader._lfanew;
              TempStream.ReadBuffer(TempImageNtHeaders, SizeOf(TempImageNtHeaders));

              if (TempImageNtHeaders.Signature = IMAGE_NT_SIGNATURE) then
                begin
                  aMachine := TempImageNtHeaders.FileHeader.Machine;
                  Result   := True;
                end;
            end;
        end;
    except
      on e : exception do
        if CustomExceptionHandler('GetDLLHeaderMachine', e) then raise;
    end;
  finally
    if (TempStream <> nil) then FreeAndNil(TempStream);
  end;
end;

function GetTempDirectory: string;
var
  TempPath: array[0..MAX_PATH - 1] of Char;
begin
  GetTempPath(MAX_PATH, TempPath);
  Result := IncludeTrailingPathDelimiter(TempPath);
end;
{$ENDIF}

function GetFileSize(const aFilename: string): int64;
var
  {$IFDEF MSWINDOWS}
  TempInfo : TWin32FileAttributeData;
  {$ELSE}
  TempFile : file of Byte;
  {$ENDIF}
begin
  Result := -1;
  try
    if FileExists(aFileName) then
      begin
        {$IFDEF MSWINDOWS}
        if FileExists(aFileName) and
           GetFileAttributesEx(PChar(aFileName), GetFileExInfoStandard, @TempInfo) then
          Result := int64(TempInfo.nFileSizeLow) or int64(TempInfo.nFileSizeHigh shl 32);
        {$ELSE}
        AssignFile(TempFile, aFileName);
        try
          Reset(TempFile);
          Result := FileSize(TempFile);
        finally
          CloseFile(TempFile);
        end;
        {$ENDIF}
      end;
  except
    on e : exception do
      if CustomExceptionHandler('GetFileSize', e) then raise;
  end;
end;

function CustomFindAllFiles(const aPath, aFilename: string): TStringList;
var
  i : integer;
  {$IFDEF DELPHI16_UP}
  TempFiles : TStringDynArray;
  {$ELSE}
  TempRec : TSearchRec;
  TempStart, TempEnd : string;
  {$ENDIF}
begin
  Result := nil;
  try
    if (length(aPath) > 0) and DirectoryExists(aPath) then
      begin
        Result := TStringList.Create;

        {$IFDEF DELPHI16_UP}
        TempFiles := TDirectory.GetFiles(aPath, aFilename, TSearchOption.soTopDirectoryOnly);
        for i := 0 to pred(length(TempFiles)) do
          Result.Add(TempFiles[i]);
        {$ELSE}
        if (FindFirst(aPath + '\*', faAnyFile, TempRec) = 0) then
          try
            i         := pos('*', aFilename);
            TempStart := copy(aFilename, 1, pred(i));
            TempEnd   := copy(aFilename, succ(i), length(aFilename));

            repeat
              if ((TempRec.Attr and faDirectory) = 0) and
                 (CompareText(TempStart, copy(TempRec.Name, 1, length(TempStart))) = 0) and
                 (CompareText(TempEnd, copy(TempRec.Name, length(TempRec.Name) - length(TempEnd), length(TempRec.Name))) = 0) then
                Result.Add(TempRec.Name);
            until (FindNext(TempRec) <> 0);
          finally
            FindClose(TempRec);
          end;
        {$ENDIF}
      end;
  except
    on e : exception do
      if CustomExceptionHandler('CustomFindAllFiles', e) then raise;
  end;
end;

{$IFNDEF DELPHI14_UP}{$IFNDEF FPC}
function CharInSet(const aChar: char; const aCharSet: TSysCharSet) : boolean;
begin
  Result := aChar in aCharSet;
end;
{$ENDIF}{$ENDIF}

function PyWCharTStringToString(const aString: WCharTString): string;
begin
  {$IFDEF POSIX}
  Result := UCS4StringToUnicodeString(UCS4String(aString));
  {$ELSE}
    {$IFDEF FPC}
      Result := UTF8Encode(aString);
    {$ELSE}
      {$IFDEF DELPHI12_UP}
      Result := aString;
      {$ELSE}
      Result := UnicodeStringToAnsiString(aString);
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
end;

function StringToPyWCharTString(const aString: string): WCharTString;
begin
  {$IFDEF POSIX}
  Result := WCharTString(UnicodeStringToUCS4String(UnicodeString(aString)));
  {$ELSE}
    {$IFDEF FPC}
      Result := UTF8Decode(aString);
    {$ELSE}
      {$IFDEF DELPHI12_UP}
      Result := aString;
      {$ELSE}
      Result := AnsiStringToUnicodeString(aString);
      {$ENDIF}
    {$ENDIF}
  {$ENDIF}
end;

function WCharTArrayToStringList(aItems: PPWCharT; aLength: NativeInt; var aResultSL: TStringList): boolean;
var
  TempItem : PWCharT;
  i        : NativeInt;
begin
  Result := False;
  if not(assigned(aResultSL)) or (aLength <= 0) then exit;

  aResultSL.Clear;

  for i := 0 to pred(aLength) do
    begin
      TempItem := PWCharT(aItems^);
      aResultSL.Add(PyWCharTStringToString(WCharTString(TempItem)));
      inc(aItems);
    end;

  Result := True;
end;

function PyWideStringListToStringList(const aList: PyWideStringList; var aResultSL: TStringList): boolean;
begin
  Result := WCharTArrayToStringList(aList.items, aList.length, aResultSL);
end;

function WCharTArrayToStringDynArray(aItems: PPWCharT; aLength: NativeInt; var aResult: TStringDynArray): boolean;
var
  TempItem : PWCharT;
  i        : NativeInt;
begin
  Result := False;
  if (aLength <= 0) then exit;

  SetLength(aResult, aLength);

  for i := 0 to pred(aLength) do
    begin
      TempItem   := PWCharT(aItems^);
      aResult[i] := PyWCharTStringToString(WCharTString(TempItem));
      inc(aItems);
    end;

  Result := True;
end;

function PyWideStringListToStringDynArray(const aList: PyWideStringList; var aResult: TStringDynArray): boolean;
begin
  Result := WCharTArrayToStringDynArray(aList.items, aList.length, aResult);
end;

function ErrorToAnsiString(error: TPyCodecErrors): AnsiString;
begin
  case error of
    pceStrict  : Result := 'strict' + #0;
    pceReplace : Result := 'replace' + #0;
    pceIgnore  : Result := 'ignore' + #0;
    else         Result := 'surrogateescape' + #0;
  end;
end;

function PyStartSymbolToInt(start: TPyStartSymbols): integer;
begin
  case start of
    ssSingle   : Result := Py_single_input;
    ssFile     : Result := Py_file_input;
    ssEval     : Result := Py_eval_input;
    ssFuncType : Result := Py_func_type_input;
    else         Result := Py_file_input;
  end;
end;

function CustomSplitString(const S, Delimiters: string): TStringDynArray;
{$IF DEFINED(DELPHI15_UP) OR DEFINED(FPC)}
begin
  Result := SplitString(S, Delimiters);
end;
{$ELSE}
var
  TempList : TStrings;
  i : integer;
begin
  if (length(Delimiters) = 0) or (length(S) = 0) then exit;

  TempList := TStringList.Create;
  try
    ExtractStrings([Delimiters[1]], [], PChar(S), TempList);
    SetLength(Result, TempList.Count);
    for i := 0 to pred(TempList.Count) do
      Result[i] := TempList[i];
  finally
    TempList.Free;
  end;
end;
{$IFEND}

end.
