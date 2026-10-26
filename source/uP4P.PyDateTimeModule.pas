unit uP4P.PyDateTimeModule;

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
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.ImportedPyModule;

type
  /// <summary>
  /// <para>TPyDateTimeModule imports the "datetime" module and gets several
  /// object types related to that module.</para>
  /// <para>This class also includes several helper functions to create and
  /// convert "datetime" objects.</para>
  /// </summary>
  /// <remarks>
  /// <para><see href="https://docs.python.org/3/library/datetime.html">See the article about the "datetime" module.</see></para>
  /// </remarks>
  TPyDateTimeModule = class(TImportedPyModule)
    protected
      FDateType          : Pointer;
      FDateTimeType      : Pointer;
      FDeltaType         : Pointer;
      FTimeType          : Pointer;
      FTZInfoType        : Pointer;
      FTimeTZType        : Pointer;
      FDateTimeTZType    : Pointer;
      FInExtensionModule : boolean;

      procedure Import; override;
      procedure Initialize; override;
      procedure Finalize; override;

    public
      /// <summary>
      /// Return true if aPyObject is an instance of the "date" type.
      /// </summary>
      function CheckExactDate(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// Return true if aPyObject is an instance of the "datetime" type.
      /// </summary>
      function CheckExactDateTime(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// Return true if aPyObject is an instance of the "timedelta" type.
      /// </summary>
      function CheckExactDelta(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// Return true if aPyObject is an instance of the "time" type.
      /// </summary>
      function CheckExactTime(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// Return true if aPyObject is an instance of the "tzinfo" type.
      /// </summary>
      function CheckExactTZInfo(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// Return true if aPyObject is an instance of the "timetz" type.
      /// </summary>
      function CheckExactTimeTZ(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// Return true if aPyObject is an instance of the "datetimetz" type.
      /// </summary>
      function CheckExactDateTimeTZ(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if aPyObject is a "date" object or an instance of a
      /// subtype of the "date" type.</para>
      /// </summary>
      function CheckDate(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if aPyObject is a "datetime" object or an instance
      /// of a subtype of the "datetime" type.</para>
      /// </summary>
      function CheckDateTime(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if aPyObject is a "timedelta" object or an instance
      /// of a subtype of the "timedelta" type.</para>
      /// </summary>
      function CheckDelta(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if aPyObject is a "time" object or an instance of a
      /// subtype of the "time" type.</para>
      /// </summary>
      function CheckTime(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if aPyObject is a "tzinfo" object or an instance of
      /// a subtype of the "tzinfo" type.</para>
      /// </summary>
      function CheckTZInfo(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if aPyObject is a "timetz" object or an instance of
      /// a subtype of the "timetz" type.</para>
      /// </summary>
      function CheckTimeTZ(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Return true if aPyObject is a "datetimetz" object or an instance
      /// of a subtype of the "datetimetz" type.</para>
      /// </summary>
      function CheckDateTimeTZ(const aPyObject: IPyObject): boolean;
      /// <summary>
      /// <para>Convert aPyObject to year, month, day.</para>
      /// </summary>
      class function AsDate(const aPyObject: IPyObject; var year, month, day: integer): boolean;
      /// <summary>
      /// <para>Convert aPyObject to hour, minute, second, microsecond.</para>
      /// </summary>
      class function AsTime(const aPyObject: IPyObject; var hour, minute, second, microsecond: integer): boolean;
      /// <summary>
      /// <para>Convert aPyObject to days, seconds, microseconds.</para>
      /// </summary>
      class function AsDelta(const aPyObject: IPyObject; var days, seconds, microseconds: integer): boolean;
      /// <summary>
      /// <para>Convert aPyObject to year, month, day, hour, minute, second,
      /// microsecond.</para>
      /// </summary>
      class function AsDateTime(const aPyObject: IPyObject; var year, month, day, hour, minute, second, microsecond: integer): boolean; overload;
      /// <summary>
      /// <para>Convert aPyObject to TDateTime.</para>
      /// </summary>
      class function AsDateTime(const aPyObject: IPyObject; var aDateTime : TDateTime): boolean; overload;
      /// <summary>
      /// <para>Create a datetime object from a TDateTime.</para>
      /// </summary>
      class function FromDateTime(aDateTime: TDateTime): IPyObject; overload;
      /// <summary>
      /// <para>Create a datetime object from year, month, day, hour, minute,
      /// second, msecond.</para>
      /// </summary>
      class function FromDateTime(year, month, day, hour, minute, second, msecond: integer): IPyObject; overload;
      /// <summary>
      /// <para>Create a Python datetime object from a Variant.</para>
      /// </summary>
      class function FromVariant(const aVariant: Variant): IPyObject; overload;
      /// <summary>
      /// <para>Create a Python datetime object from a Variant.</para>
      /// </summary>
      class function FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject; overload;
      /// <summary>
      /// Pointer to the "datetime" type.
      /// </summary>
      property DateTimeType      : Pointer  read FDateTimeType;
      /// <summary>
      /// <para>This module was loaded from an extension module.</para>
      /// </summary>
      property InExtensionModule : boolean  read FInExtensionModule   write FInExtensionModule;
  end;

implementation

uses
  uP4P.Engine, uP4P.PyTuple, uP4P.PyImport, uP4P.PyType;

procedure TPyDateTimeModule.Initialize;
begin
  FDateType       := nil;
  FDateTimeType   := nil;
  FDeltaType      := nil;
  FTimeType       := nil;
  FTZInfoType     := nil;
  FTimeTZType     := nil;
  FDateTimeTZType := nil;
end;

procedure TPyDateTimeModule.Finalize;
begin
  if FInExtensionModule then exit;

  DecRef(FDateType);
  DecRef(FDateTimeType);
  DecRef(FDeltaType);
  DecRef(FTimeType);
  DecRef(FTZInfoType);
  DecRef(FTimeTZType);
  DecRef(FDateTimeTZType);
end;

procedure TPyDateTimeModule.Import;
var
  TempModule : IPyObject;
begin
  TempModule := TPyImport.ImportModule('datetime');

  if TPyObject.IsInitialized(TempModule) then
    begin
      TempModule.GetOptionalAttrString2('date',       FDateType);
      TempModule.GetOptionalAttrString2('datetime',   FDateTimeType);
      TempModule.GetOptionalAttrString2('timedelta',  FDeltaType);
      TempModule.GetOptionalAttrString2('time',       FTimeType);
      TempModule.GetOptionalAttrString2('tzinfo',     FTZInfoType);
      TempModule.GetOptionalAttrString2('timetz',     FTimeTZType);
      TempModule.GetOptionalAttrString2('datetimetz', FDateTimeTZType);
    end;
end;

function TPyDateTimeModule.CheckExactDate(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FDateType);
end;

function TPyDateTimeModule.CheckExactDateTime(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FDateTimeType);
end;

function TPyDateTimeModule.CheckExactDelta(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FDeltaType);
end;

function TPyDateTimeModule.CheckExactTime(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FTimeType);
end;

function TPyDateTimeModule.CheckExactTZInfo(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FTZInfoType);
end;

function TPyDateTimeModule.CheckExactTimeTZ(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FTimeTZType);
end;

function TPyDateTimeModule.CheckExactDateTimeTZ(const aPyObject: IPyObject): boolean;
begin
  Result := TPyObject.IsInitialized(aPyObject) and
            aPyObject.IsType(FDateTimeTZType);
end;

function TPyDateTimeModule.CheckDate(const aPyObject: IPyObject): boolean;
begin
  Result := CheckExactDate(aPyObject) or
            TPyType.IsSubtype(aPyObject, FDateType);
end;

function TPyDateTimeModule.CheckDateTime(const aPyObject: IPyObject): boolean;
begin
  Result := CheckExactDateTime(aPyObject) or
            TPyType.IsSubtype(aPyObject, FDateTimeType);
end;

function TPyDateTimeModule.CheckDelta(const aPyObject: IPyObject): boolean;
begin
  Result := CheckExactDelta(aPyObject) or
            TPyType.IsSubtype(aPyObject, FDeltaType);
end;

function TPyDateTimeModule.CheckTime(const aPyObject: IPyObject): boolean;
begin
  Result := CheckExactTime(aPyObject) or
            TPyType.IsSubtype(aPyObject, FTimeType);
end;

function TPyDateTimeModule.CheckTZInfo(const aPyObject: IPyObject): boolean;
begin
  Result := CheckExactTZInfo(aPyObject) or
            TPyType.IsSubtype(aPyObject, FTZInfoType);
end;

function TPyDateTimeModule.CheckTimeTZ(const aPyObject: IPyObject): boolean;
begin
  Result := CheckExactTimeTZ(aPyObject) or
            TPyType.IsSubtype(aPyObject, FTimeTZType);
end;

function TPyDateTimeModule.CheckDateTimeTZ(const aPyObject: IPyObject): boolean;
begin
  Result := CheckExactDateTimeTZ(aPyObject) or
            TPyType.IsSubtype(aPyObject, FDateTimeTZType);
end;

class function TPyDateTimeModule.AsDate(const aPyObject: IPyObject; var year, month, day: integer): boolean;
begin
  Result := False;

  if TPyObject.IsInitialized(aPyObject) and
     assigned(GlobalP4PEngine) and
     GlobalP4PEngine.DateTimeModule.CheckDate(aPyObject) then
    begin
      aPyObject.GetAttrAsInteger('year',  year);
      aPyObject.GetAttrAsInteger('month', month);
      aPyObject.GetAttrAsInteger('day',   day);

      Result := True;
    end;
end;

class function TPyDateTimeModule.AsTime(const aPyObject: IPyObject; var hour, minute, second, microsecond: integer): boolean;
begin
  Result := False;

  if TPyObject.IsInitialized(aPyObject) and
     assigned(GlobalP4PEngine) and
     GlobalP4PEngine.DateTimeModule.CheckTime(aPyObject) then
    begin
      aPyObject.GetAttrAsInteger('hour',        hour);
      aPyObject.GetAttrAsInteger('minute',      minute);
      aPyObject.GetAttrAsInteger('second',      second);
      aPyObject.GetAttrAsInteger('microsecond', microsecond);

      Result := True;
    end;
end;

class function TPyDateTimeModule.AsDelta(const aPyObject: IPyObject; var days, seconds, microseconds: integer): boolean;
var
  TempDelta : PyDateTime_Delta;
begin
  Result := False;

  if TPyObject.IsInitialized(aPyObject) and
     assigned(GlobalP4PEngine) and
     GlobalP4PEngine.DateTimeModule.CheckDelta(aPyObject) then
    begin
      TempDelta    := PPyDateTime_Delta(aPyObject.PyObject)^;
      days         := TempDelta.days;
      seconds      := TempDelta.seconds;
      microseconds := TempDelta.microseconds;
      Result       := True;
    end;
end;

class function TPyDateTimeModule.AsDateTime(const aPyObject: IPyObject; var year, month, day, hour, minute, second, microsecond: integer): boolean;
begin
  Result := False;

  if TPyObject.IsInitialized(aPyObject) and
     assigned(GlobalP4PEngine) and
     GlobalP4PEngine.DateTimeModule.CheckDateTime(aPyObject) then
    begin
      aPyObject.GetAttrAsInteger('year',        year);
      aPyObject.GetAttrAsInteger('month',       month);
      aPyObject.GetAttrAsInteger('day',         day);
      aPyObject.GetAttrAsInteger('hour',        hour);
      aPyObject.GetAttrAsInteger('minute',      minute);
      aPyObject.GetAttrAsInteger('second',      second);
      aPyObject.GetAttrAsInteger('microsecond', microsecond);

      Result := True;
    end;
end;

class function TPyDateTimeModule.AsDateTime(const aPyObject: IPyObject; var aDateTime : TDateTime): boolean;
var
  year, month, day, hour, minute, second, microsecond : integer;
begin
  year        := 0;
  month       := 0;
  day         := 0;
  hour        := 0;
  minute      := 0;
  second      := 0;
  microsecond := 0;

  if AsDateTime(aPyObject, year, month, day, hour, minute, second, microsecond) then
    begin
      aDateTime := EncodeDate(year, month, day) + EncodeTime(hour, minute, second, microsecond div 1000);
      Result    := True;
    end
   else
    if AsDate(aPyObject, year, month, day) then
      begin
        aDateTime := EncodeDate(year, month, day);
        Result    := True;
      end
     else
      if AsTime(aPyObject, hour, minute, second, microsecond) then
        begin
          aDateTime := EncodeTime(hour, minute, second, microsecond div 1000);
          Result    := True;
        end
       else
        if AsDelta(aPyObject, day, second, microsecond) then
          begin
            aDateTime := day + (second / SECONDS_IN_A_DAY) + ((microsecond div 1000) / MILLISECONDS_IN_A_DAY);
            Result    := True;
          end
         else
          Result := TPyTuple.AsDateTime(aPyObject, aDateTime);
end;

class function TPyDateTimeModule.FromDateTime(aDateTime: TDateTime): IPyObject;
var
  year, month, day, hour, minute, second, msecond: word;
begin
  DecodeDate(aDateTime, year, month, day);
  DecodeTime(aDateTime, hour, minute, second, msecond);

  Result := FromDateTime(year, month, day, hour, minute, second, msecond);
end;

class function TPyDateTimeModule.FromDateTime(year, month, day, hour, minute, second, msecond: integer): IPyObject;
var
  TempArgs : IPyObject;
begin
  Result := nil;

  if (month   in [1..12]) and
     (day     in [1..31]) and
     (hour    in [0..23]) and
     (minute  in [0..59]) and
     (second  in [0..59]) and
     assigned(GlobalP4PEngine) and
     assigned(GlobalP4PEngine.DateTimeModule) and
     assigned(GlobalP4PEngine.DateTimeModule.DateTimeType) and
     assigned(PyObject_Call) then
    begin
      TempArgs := TPyTuple.FromVarRecArray([year, month, day, hour, minute, second, msecond * 1000]);
      Result   := TPyObject.Wrap(PyObject_Call(PPyObject(GlobalP4PEngine.DateTimeModule), TempArgs.PyObject, nil));
    end;
end;

class function TPyDateTimeModule.FromVariant(const aVariant: Variant; aVarType: TVarType): IPyObject;
begin
  if (aVarType = varDate) then
    Result := FromDateTime(TDateTime(aVariant))
   else
    Result := nil;
end;

class function TPyDateTimeModule.FromVariant(const aVariant: Variant): IPyObject;
var
  TempType    : TVarType;
  TempVariant : Variant;
begin
  TempVariant := aVariant;
  TempType    := varByRef or varVariant;

  while VarType(TempVariant) = TempType do
    TempVariant := Variant(PVarData(TVarData(TempVariant).VPointer)^);

  Result := FromVariant(TempVariant, VarType(TempVariant) and (VarTypeMask or VarArray));
end;

end.
