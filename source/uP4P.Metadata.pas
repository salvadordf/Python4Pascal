unit uP4P.Metadata;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes, System.SysUtils, System.Variants,
  {$ELSE}
    Classes, SysUtils, Variants,
  {$ENDIF}
  uP4P.Interfaces, uP4P.PyObject;

type
  TPyDistribution = class;
  TPyDistributionList = class;

  /// <summary>
  /// <para>TPyMetadata imports importlib.metadata, which is a library that
  /// provides access to the metadata of an installed Distribution Package,
  /// such as its entry points or its top-level names (Import Packages,
  /// modules, if any).</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/library/importlib.metadata.html">See the article about importlib.metadata.</see></para>
  /// <para><see href="https://importlib-metadata.readthedocs.io/en/latest/">See the importlib.metadata documentation.</see></para>
  /// </remarks>
  TPyMetadata = class
    protected
      FDistributions     : IPyObject;
      FVersion           : IPyObject;
      FDistList          : TPyDistributionList;

      function  GetInitialized : boolean;

      procedure Import;
      procedure Initialize;

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      /// <summary>
      /// Refresh the distributions list.
      /// </summary>
      procedure   RefreshDistributions;
      /// <summary>
      /// Get the version string for the named package.
      /// </summary>
      function version(const distribution_name: string): string;
      /// <summary>
      /// Returns true if the class is fully initialized.
      /// </summary>
      property Initialized   : boolean              read GetInitialized;
      /// <summary>
      /// Get the TPyDistribution instance for the named package.
      /// </summary>
      property Distributions : TPyDistributionList  read FDistList;
  end;

  /// <summary>
  /// <para>The interface of the distributions yielded by
  /// TPyMetadata.distributions() and friends.</para>
  /// <para>Consumers should prefer this protocol over Distribution, as it is
  /// also satisfied by the objects that importlib.metadata supplies.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/library/importlib.metadata.html">See the article about importlib.metadata.</see></para>
  /// <para><see href="https://importlib-metadata.readthedocs.io/en/latest/api.html#importlib_metadata._meta.IDistribution">See the IDistribution documentation.</see></para>
  /// </remarks>
  TPyDistribution = class
    protected
      FName              : IPyObject;
      FVersion           : IPyObject;

      function  GetName : string;
      function  GetVersion : string;
      function  GetInitialized : boolean;

      procedure Initialize;

    public
      constructor Create(const aDistribution: IPyObject);
      destructor  Destroy; override;
      /// <summary>
      /// Returns true if the class is fully initialized.
      /// </summary>
      property Initialized : boolean      read  GetInitialized;
      /// <summary>
      /// Get the version string of the package.
      /// </summary>
      property Name_       : string       read  GetName;
      /// <summary>
      /// Get the name of the package.
      /// </summary>
      property Version     : string       read  GetVersion;
  end;

  /// <summary>
  /// <para>Custom TList with TPyDistribution items.</para>
  /// </summary>
  TPyDistributionList = class(TList)
    protected
      function  GetName(i: integer) : string;
      function  GetVersion(i: integer) : string;

      procedure ClearItems;

    public
      destructor Destroy; override;
      function   AddDistribution(const aDistribution: IPyObject): boolean;
      /// <summary>
      /// Get the version string of the package.
      /// </summary>
      property Name_[i: integer]       : string       read  GetName;
      /// <summary>
      /// Get the name of the package.
      /// </summary>
      property Version[i: integer]     : string       read  GetVersion;
  end;

implementation

uses
  uP4P.PyImport, uP4P.PyUnicode, uP4P.PyIter;


{* TPyMetadata *}

constructor TPyMetadata.Create;
begin
  inherited Create;

  Initialize;
end;

destructor TPyMetadata.Destroy;
begin
  try
    if assigned(FDistList) then
      FreeAndNil(FDistList);

    Initialize;
  finally
    inherited Destroy;
  end;
end;

procedure TPyMetadata.AfterConstruction;
begin
  inherited AfterConstruction;

  FDistList := TPyDistributionList.Create;
  Import;
  RefreshDistributions;
end;

procedure TPyMetadata.Initialize;
begin
  FDistributions          := nil;
  FVersion                := nil;
  FDistList               := nil;
end;

procedure TPyMetadata.RefreshDistributions;
var
  TempIter, TempDist, TempDists : IPyObject;
begin
  FDistList.ClearItems;

  if Initialized then
    begin
      TempDists := FDistributions.CallNoArgs;

      if TPyObject.IsInitialized(TempDists) then
        begin
          TempIter := TempDists.GetIter;

          if TPyObject.IsInitialized(TempIter) then
            begin
              TempDist := TPyIter.Next(TempIter);

              while TPyObject.IsInitialized(TempDist) do
                begin
                  FDistList.AddDistribution(TempDist);
                  TempDist := TPyIter.Next(TempIter);
                end;
            end;
        end;
    end;
end;

function TPyMetadata.version(const distribution_name: string): string;
var
  TempVersion, TempName : IPyObject;
begin
  Result := '';

  if (length(distribution_name) > 0) and Initialized then
    begin
      TempName    := TPyUnicode.FromString(distribution_name);
      TempVersion := FVersion.CallOneArg(TempName);

      if TPyObject.IsInitialized(TempVersion) then
        Result := TempVersion.AsString;
    end;
end;

procedure TPyMetadata.Import;
var
  TempModule : IPyObject;
begin
  TempModule := TPyImport.ImportModule('importlib.metadata');

  if TPyObject.IsInitialized(TempModule) then
    begin
      TempModule.GetOptionalAttrString('distributions', FDistributions);
      TempModule.GetOptionalAttrString('version',       FVersion);
    end;
end;

function TPyMetadata.GetInitialized: boolean;
begin
  Result := TPyObject.IsInitialized(FDistributions) and
            TPyObject.IsInitialized(FVersion);
end;

{ TPyDistribution }

constructor TPyDistribution.Create(const aDistribution: IPyObject);
begin
  inherited Create;

  Initialize;

  if TPyObject.IsInitialized(aDistribution) then
    begin
      aDistribution.GetOptionalAttrString('name',    FName);
      aDistribution.GetOptionalAttrString('version', FVersion);
    end;
end;

destructor TPyDistribution.Destroy;
begin
  Initialize;

  inherited Destroy;
end;

procedure TPyDistribution.Initialize;
begin
  FName         := nil;
  FVersion      := nil;
end;

function TPyDistribution.GetInitialized: boolean;
begin
  Result := TPyObject.IsInitialized(FVersion) and
            TPyObject.IsInitialized(FName);
end;

function TPyDistribution.GetName: string;
begin
  if Initialized then
    Result := FName.AsString
   else
    Result := '';
end;

function TPyDistribution.GetVersion: string;
begin
  if Initialized then
    Result := FVersion.AsString
   else
    Result := '';
end;

{ TPyDistributionList }

destructor TPyDistributionList.Destroy;
begin
  ClearItems;

  inherited Destroy;
end;

procedure TPyDistributionList.ClearItems;
var
  i: integer;
begin
  i := pred(self.Count);
  while (i >= 0) do
    begin
      TPyDistribution(Items[i]).Free;
      Items[i] := nil;
      dec(i);
    end;

  Clear;
end;

function TPyDistributionList.GetName(i: integer) : string;
begin
  if (i >= 0) and (i < Count) then
    Result := TPyDistribution(Items[i]).Name_
   else
    Result := '';
end;

function TPyDistributionList.GetVersion(i: integer) : string;
begin
  if (i >= 0) and (i < Count) then
    Result := TPyDistribution(Items[i]).Version
   else
    Result := '';
end;

function TPyDistributionList.AddDistribution(const aDistribution: IPyObject): boolean;
begin
  Result := (Add(TPyDistribution.Create(aDistribution)) >= 0);
end;

end.
