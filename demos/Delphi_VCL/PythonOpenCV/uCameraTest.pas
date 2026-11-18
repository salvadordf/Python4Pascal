unit uCameraTest;

{$I ..\..\..\source\p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.Classes,
  {$ELSE}
  Classes,
  {$ENDIF}
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Constants;

type
  TCameraTest = class
    protected
      FCameraTest  : IPyObject;
      FSnapshot    : IPyObject;

      function  GetInitialized : boolean;

      procedure Initialize;
      function  CreatePythonClass : boolean;
      procedure GetAllAttributes;

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;
      function    Snapshot(const aFilepath : string): boolean;

      property Initialized : boolean      read  GetInitialized;
  end;

implementation

uses
  uP4P.PyTuple, uP4P.PyUnicode, uP4P.PyDict;

constructor TCameraTest.Create;
begin
  inherited Create;

  Initialize;
end;

destructor TCameraTest.Destroy;
begin
  Initialize;

  inherited Destroy;
end;

procedure TCameraTest.AfterConstruction;
begin
  inherited AfterConstruction;

  if CreatePythonClass then
    GetAllAttributes;
end;

procedure TCameraTest.Initialize;
begin
  FSnapshot    := nil;
  FCameraTest  := nil;
end;

function TCameraTest.CreatePythonClass : boolean;
var
  TempMainModule, TempAttrib : IPyObject;
begin
  Result         := False;
  TempMainModule := GlobalP4PEngine.MainModule;

  if TPyObject.IsInitialized(TempMainModule) and
     TempMainModule.GetOptionalAttrString('CameraTest', TempAttrib) then
    begin
      FCameraTest := TempAttrib.CallNoArgs;
      Result      := assigned(FCameraTest);
    end;
end;

procedure TCameraTest.GetAllAttributes;
begin
  FCameraTest.GetOptionalAttrString('snapshot', FSnapshot);
end;

function TCameraTest.GetInitialized: boolean;
begin
  Result := TPyObject.IsInitialized(FCameraTest) and
            TPyObject.IsInitialized(FSnapshot);
end;

function TCameraTest.Snapshot(const aFilepath : string): boolean;
var
  TempResult, TempArgs, TempString : IPyObject;
begin
  Result := False;

  if assigned(FSnapshot) then
    try
      TempString := TPyUnicode.FromString(aFilepath);
      TempArgs   := TPyTuple.New(1);
      TPyTuple.SetItem(TempArgs, 0, TempString);
      TempResult := FSnapshot.CallObject(TempArgs);
      Result     := (TempResult.IsTrue = 1);
    finally
      TempArgs   := nil;
      TempString := nil;
    end;
end;

end.
