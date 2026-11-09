unit uP4P.HTTPDownloader;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

{$HINTS OFF}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils, System.Variants
    {$IFDEF DELPHI22_UP}
      , System.Net.HttpClient, System.Net.URLClient, System.NetConsts
    {$ELSE}
      {$IFDEF MSWINDOWS}, WinInet{$ENDIF}
    {$ENDIF}
  {$ELSE}
    Classes, SysUtils, Variants
    {$IFDEF FPC}
      , fphttpclient, opensslsockets
    {$ELSE}
      {$IFDEF MSWINDOWS}, WinInet{$ENDIF}
    {$ENDIF}
  {$ENDIF}
  ;

type
  /// <summary>
  /// <para>Custom class used to download files from a web server.</para>
  /// </summary>
  THTTPDownloader = class
    private
      class function Get_NewDelphi(const aURL: string; var aResult: TMemoryStream): boolean;
      class function Get_OldDelphi(const aURL: string; var aResult: TMemoryStream): boolean;
      class function Get_Lazarus(const aURL: string; var aResult: TMemoryStream): boolean;
    public
      /// <summary>
      /// <para>Download the resource in aURL and save the contents in
      /// aResult.</para>
      /// </summary>
      class function Get(const aURL: string; var aResult: TMemoryStream): boolean;
      /// <summary>
      /// <para>Download the resource in aURL and save the contents in
      /// aPath</para>
      /// </summary>
      class function SaveToFile(const aURL, aPath: string): boolean;
  end;

implementation

uses
  uP4P.MiscFunctions;

class function THTTPDownloader.Get_NewDelphi(const aURL: string; var aResult: TMemoryStream): boolean;
{$IFDEF DELPHI22_UP}
var
  TempClient   : THTTPClient;
  TempResponse : IHTTPResponse;  
{$ENDIF}
begin
  Result := False;
  {$IFDEF DELPHI22_UP}
  TempClient := THTTPClient.Create;
  try
    TempClient.AcceptCharSet := 'utf-8';
    TempResponse := TempClient.Get(aURL);
    if (TempResponse.StatusCode = 200) then
      begin
        aResult.LoadFromStream(TempResponse.ContentStream);
        Result := True;
      end;
  finally
    TempClient.Free;
  end;
  {$ENDIF}
end;

class function THTTPDownloader.Get_OldDelphi(const aURL: string; var aResult: TMemoryStream): boolean;
{$IFDEF MSWINDOWS}{$IFNDEF FPC}{$IFNDEF DELPHI22_UP}
var
  {$WARN UNSAFE_TYPE OFF}
  TempInternet, TempURL : HINTERNET;  
  {$WARN UNSAFE_TYPE ON}
  TempBuffer : array[0..8191] of Byte;
  TempLen, TempFlags : cardinal;
{$ENDIF}{$ENDIF}{$ENDIF}
begin
  Result := False;
  {$IFDEF MSWINDOWS}{$IFNDEF FPC}{$IFNDEF DELPHI22_UP}
  {$WARN UNSAFE_CODE OFF}{$WARN UNSAFE_TYPE OFF}
  TempInternet := InternetOpen('Edge', INTERNET_OPEN_TYPE_PRECONFIG, nil, nil, 0);

  if assigned(TempInternet) then
    try
      TempFlags := INTERNET_FLAG_RELOAD or INTERNET_FLAG_NO_CACHE_WRITE or INTERNET_FLAG_SECURE;
      TempURL   := InternetOpenUrl(TempInternet, PChar(aURL), nil, 0, TempFlags, 0);

      if assigned(TempURL) then
        try
          repeat
            TempLen := 0;

            if InternetReadFile(TempURL, @TempBuffer[0], SizeOf(TempBuffer), TempLen) and (TempLen > 0) then
              begin
                aResult.WriteBuffer(TempBuffer[0], TempLen);
                Result := True;
              end;
          until (TempLen = 0);
        finally
          InternetCloseHandle(TempURL);
        end;
    finally
      InternetCloseHandle(TempInternet);
    end;
  {$WARN UNSAFE_CODE ON}{$WARN UNSAFE_TYPE ON}
  {$ENDIF}{$ENDIF}{$ENDIF}
end;

class function THTTPDownloader.Get_Lazarus(const aURL: string; var aResult: TMemoryStream): boolean;
{$IFDEF FPC}
var
  TempClient : TFPHTTPClient;
{$ENDIF}
begin
  Result := False;
  {$IFDEF FPC}
  TempClient := TFPHTTPClient.Create(nil);
  try
    // This function requires the OpenSSL libraries in order to connect to the
    // web server using HTTPS
    TempClient.Get(aURL, aResult);
    Result := (TempClient.ResponseStatusCode = 200);
  finally
    TempClient.Free;
  end;
  {$ENDIF}
end;

class function THTTPDownloader.Get(const aURL: string; var aResult: TMemoryStream): boolean;
begin
  {$IFDEF DELPHI22_UP}
  Result := Get_NewDelphi(aURL, aResult);
  {$ELSE}
    {$IFDEF FPC}
    Result := Get_Lazarus(aURL, aResult);
    {$ELSE}
    Result := Get_OldDelphi(aURL, aResult);
    {$ENDIF}
  {$ENDIF}
end;

class function THTTPDownloader.SaveToFile(const aURL, aPath: string): boolean;
var
  TempResult : TMemoryStream;
begin
  Result     := False;
  TempResult := TMemoryStream.Create;
  try
    try
      if THTTPDownloader.Get(aURL, TempResult) then
        begin
          TempResult.SaveToFile(aPath);
          Result := True;
        end;
    except
      on e : exception do
        if CustomExceptionHandler('THTTPDownloader.SaveToFile', e) then raise;
    end;
  finally
    TempResult.Free;
  end;
end;

end.
