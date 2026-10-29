unit uMyClass;

interface

uses
  Classes,
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Constants;

type
  TMyClass = class
    protected
      FMyClass             : IPyObject;
      FXAttrib             : IPyObject;
      FBooleanTestAttrib   : IPyObject;
      FIntegerTestAttrib   : IPyObject;
      FFloatTestAttrib     : IPyObject;
      FStringTestAttrib    : IPyObject;
      FTupleTestAttrib     : IPyObject;
      FListTestAttrib      : IPyObject;
      FDatetimeTestAttrib  : IPyObject;
      FSquareTestAttrib    : IPyObject;
      FUppercaseTestAttrib : IPyObject;
      FDictTestAttrib      : IPyObject;
      FBytesTestAttrib     : IPyObject;

      function  GetInitialized : boolean;
      function  Get_x : integer;

      procedure Set_x(aValue: integer);

      procedure Initialize;
      function  CreatePythonClass : boolean;
      procedure GetAllAttributes;

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      function    boolean_test : boolean;
      function    integer_test : integer;
      function    float_test : double;
      function    string_test : string;
      function    tuple_test : string;
      function    list_test : string;
      function    datetime_test : TDateTime;
      function    square_test(aNumber : integer): integer;
      function    uppercase_test(const aString : string): string;
      function    dict_test(const aKey: string; aValue: integer): string;
      function    bytes_test(a, b, c, d: byte; var aStream : TStream): boolean;

      property Initialized : boolean      read  GetInitialized;
      property x           : integer      read  Get_x           write Set_x;
  end;

implementation

uses
  uP4P.PyLong, uP4P.PyTuple, uP4P.PyUnicode, uP4P.PyDict, uP4P.PyBytes;

const
  MYCLASS_X_ATTRIB_NAME               = 'x';
  MYCLASS_BOOLEAN_TEST_ATTRIB_NAME    = 'boolean_test';
  MYCLASS_INTEGER_TEST_ATTRIB_NAME    = 'integer_test';
  MYCLASS_FLOAT_TEST_ATTRIB_NAME      = 'float_test';
  MYCLASS_STRING_TEST_ATTRIB_NAME     = 'string_test';
  MYCLASS_TUPLE_TEST_ATTRIB_NAME      = 'tuple_test';
  MYCLASS_LIST_TEST_ATTRIB_NAME       = 'list_test';
  MYCLASS_DATETIME_TEST_ATTRIB_NAME   = 'datetime_test';
  MYCLASS_SQUARE_TEST_ATTRIB_NAME     = 'square_test';
  MYCLASS_UPPERCASE_TEST_ATTRIB_NAME  = 'uppercase_test';
  MYCLASS_DICT_TEST_ATTRIB_NAME       = 'dict_test';
  MYCLASS_BYTES_TEST_ATTRIB_NAME      = 'bytes_test';

constructor TMyClass.Create;
begin
  inherited Create;

  Initialize;
end;

destructor TMyClass.Destroy;
begin
  Initialize;

  inherited Destroy;
end;

procedure TMyClass.AfterConstruction;
begin
  inherited AfterConstruction;

  // Create a MyClass instance and get all the properties and functions.
  if CreatePythonClass then
    GetAllAttributes;
end;

procedure TMyClass.Initialize;
begin
  FXAttrib             := nil;
  FBooleanTestAttrib   := nil;
  FIntegerTestAttrib   := nil;
  FFloatTestAttrib     := nil;
  FStringTestAttrib    := nil;
  FTupleTestAttrib     := nil;
  FListTestAttrib      := nil;
  FDatetimeTestAttrib  := nil;
  FSquareTestAttrib    := nil;
  FUppercaseTestAttrib := nil;
  FDictTestAttrib      := nil;
  FBytesTestAttrib     := nil;
  FMyClass             := nil;
end;

function TMyClass.CreatePythonClass : boolean;
var
  TempMainModule, TempAttrib : IPyObject;
begin
  Result         := False;
  TempMainModule := GlobalP4PEngine.MainModule;

  // "MyClass" can be found as an attribute of the main module.
  if TPyObject.IsInitialized(TempMainModule) and
     TempMainModule.GetOptionalAttrString('MyClass', TempAttrib) then
    begin
      // TempAttrib is the constructor of "MyClass" and all we have to do is
      // use TempAttrib.CallNoArgs to get an instance.
      FMyClass := TempAttrib.CallNoArgs;
      Result   := assigned(FMyClass);
    end;
end;

procedure TMyClass.GetAllAttributes;
begin
  // Here we get all the properties and functions of the Python class.
  FMyClass.GetOptionalAttrString(MYCLASS_X_ATTRIB_NAME,              FXAttrib);
  FMyClass.GetOptionalAttrString(MYCLASS_BOOLEAN_TEST_ATTRIB_NAME,   FBooleanTestAttrib);
  FMyClass.GetOptionalAttrString(MYCLASS_INTEGER_TEST_ATTRIB_NAME,   FIntegerTestAttrib);
  FMyClass.GetOptionalAttrString(MYCLASS_FLOAT_TEST_ATTRIB_NAME,     FFloatTestAttrib);
  FMyClass.GetOptionalAttrString(MYCLASS_STRING_TEST_ATTRIB_NAME,    FStringTestAttrib);
  FMyClass.GetOptionalAttrString(MYCLASS_TUPLE_TEST_ATTRIB_NAME,     FTupleTestAttrib);
  FMyClass.GetOptionalAttrString(MYCLASS_LIST_TEST_ATTRIB_NAME,      FListTestAttrib);
  FMyClass.GetOptionalAttrString(MYCLASS_DATETIME_TEST_ATTRIB_NAME,  FDatetimeTestAttrib);
  FMyClass.GetOptionalAttrString(MYCLASS_SQUARE_TEST_ATTRIB_NAME,    FSquareTestAttrib);
  FMyClass.GetOptionalAttrString(MYCLASS_UPPERCASE_TEST_ATTRIB_NAME, FUppercaseTestAttrib);
  FMyClass.GetOptionalAttrString(MYCLASS_DICT_TEST_ATTRIB_NAME,      FDictTestAttrib);
  FMyClass.GetOptionalAttrString(MYCLASS_BYTES_TEST_ATTRIB_NAME,     FBytesTestAttrib);
end;

function TMyClass.GetInitialized: boolean;
begin
  Result := TPyObject.IsInitialized(FMyClass) and
            TPyObject.IsInitialized(FXAttrib) and
            TPyObject.IsInitialized(FBooleanTestAttrib) and
            TPyObject.IsInitialized(FIntegerTestAttrib) and
            TPyObject.IsInitialized(FFloatTestAttrib) and
            TPyObject.IsInitialized(FStringTestAttrib) and
            TPyObject.IsInitialized(FTupleTestAttrib) and
            TPyObject.IsInitialized(FListTestAttrib) and
            TPyObject.IsInitialized(FDatetimeTestAttrib) and
            TPyObject.IsInitialized(FSquareTestAttrib) and
            TPyObject.IsInitialized(FUppercaseTestAttrib) and
            TPyObject.IsInitialized(FDictTestAttrib) and
            TPyObject.IsInitialized(FBytesTestAttrib);
end;

function TMyClass.Get_x : integer;
begin
  if assigned(FXAttrib) then
    Result := FXAttrib.AsInteger
   else
    Result := 0;
end;

procedure TMyClass.Set_x(aValue: integer);
begin
  if assigned(FXAttrib) and (aValue <> FXAttrib.AsInteger) then
    begin
      FXAttrib := TPyLong.FromLong(aValue);
      FMyClass.SetAttrString(MYCLASS_X_ATTRIB_NAME, FXAttrib);
    end;
end;

function TMyClass.boolean_test: boolean;
var
  TempResult : IPyObject;
begin
  Result := False;

  if assigned(FBooleanTestAttrib) then
    begin
      TempResult := FBooleanTestAttrib.CallNoArgs;
      Result     := (TempResult.IsTrue = 1);
    end;
end;

function TMyClass.float_test: double;
var
  TempResult : IPyObject;
begin
  Result := 0;

  if assigned(FFloatTestAttrib) then
    begin
      TempResult := FFloatTestAttrib.CallNoArgs;
      Result     := TempResult.AsDouble;
    end;
end;

function TMyClass.integer_test: integer;
var
  TempResult : IPyObject;
begin
  Result := 0;

  if assigned(FIntegerTestAttrib) then
    begin
      TempResult := FIntegerTestAttrib.CallNoArgs;
      Result     := TempResult.AsInteger;
    end;
end;

function TMyClass.list_test: string;
var
  TempResult : IPyObject;
begin
  Result := '';

  if assigned(FListTestAttrib) then
    begin
      TempResult := FListTestAttrib.CallNoArgs;
      Result     := TempResult.AsString;
    end;
end;

function TMyClass.square_test(aNumber: integer): integer;
var
  TempArgs, TempNumber, TempResult : IPyObject;
begin
  Result := 0;

  if assigned(FSquareTestAttrib) then
    try
      // We pass aNumber as a tuple in the CallObject arguments.
      TempNumber := TPyLong.FromLong(aNumber);
      TempArgs   := TPyTuple.Pack([TempNumber]);
      TempResult := FSquareTestAttrib.CallObject(TempArgs);
      Result     := TempResult.AsInteger;
    finally
      TempArgs   := nil;
      TempNumber := nil;
    end;
end;

function TMyClass.string_test: string;
var
  TempResult : IPyObject;
begin
  Result := '';

  if assigned(FStringTestAttrib) then
    begin
      TempResult := FStringTestAttrib.CallNoArgs;
      Result     := TempResult.AsString;
    end;
end;

function TMyClass.tuple_test: string;
var
  TempResult : IPyObject;
begin
  Result := '';

  if assigned(FTupleTestAttrib) then
    begin
      TempResult := FTupleTestAttrib.CallNoArgs;
      Result     := TempResult.AsString;
    end;
end;

function TMyClass.datetime_test: TDateTime;
var
  TempResult : IPyObject;
begin
  Result := 0;

  if assigned(FDatetimeTestAttrib) then
    begin
      TempResult := FDatetimeTestAttrib.CallNoArgs;
      Result     := TempResult.AsDateTime;
    end;
end;

function TMyClass.uppercase_test(const aString: string): string;
var
  TempArgs, TempString, TempResult : IPyObject;
begin
  Result := '';

  if assigned(FUppercaseTestAttrib) then
    try
      TempString := TPyUnicode.FromString(aString);
      TempArgs   := TPyTuple.Pack([TempString]);
      TempResult := FUppercaseTestAttrib.CallObject(TempArgs);
      Result     := TempResult.AsString;
    finally
      TempArgs   := nil;
      TempString := nil;
    end;
end;

function TMyClass.dict_test(const aKey: string; aValue: integer): string;
var
  TempArgs, TempKey, TempValue, TempResult : IPyObject;
begin
  Result := '';

  if assigned(FDictTestAttrib) then
    try
      // We have to create a tuple with all the function arguments in the right order.
      TempKey    := TPyUnicode.FromString(aKey);
      TempValue  := TPyLong.FromLong(aValue);
      TempArgs   := TPyTuple.Pack([TempKey, TempValue]);
      TempResult := FDictTestAttrib.CallObject(TempArgs);
      Result     := TempResult.AsString;
    finally
      TempArgs   := nil;
      TempKey    := nil;
      TempValue  := nil;
    end;
end;

function TMyClass.bytes_test(a, b, c, d: byte; var aStream : TStream): boolean;
var
  TempResult, TempArgs, TempA, TempB, TempC, TempD : IPyObject;
begin
  Result := False;

  if assigned(FBytesTestAttrib) and
     assigned(aStream) then
    begin
      TempA      := TPyLong.FromLong(a);
      TempB      := TPyLong.FromLong(b);
      TempC      := TPyLong.FromLong(c);
      TempD      := TPyLong.FromLong(d);
      TempArgs   := TPyTuple.Pack([TempA, TempB, TempC, TempD]);
      TempResult := FBytesTestAttrib.CallObject(TempArgs);
      Result     := TPyBytes.AsStream(TempResult, aStream);
    end;
end;

end.
