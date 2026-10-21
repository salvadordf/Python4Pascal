unit uTestHeapType;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I ..\..\..\source\p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
    System.Classes,
  {$ELSE}
    Classes,
  {$ENDIF}
  uP4P.LibFunctions, uP4P.Types, uP4P.Constants, uP4P.Interfaces, uP4P.PyObject,
  uP4P.CustomHeapType, uP4P.PyNone, uP4P.PyType_Spec, uP4P.PyHeapTypeSlotManager;

const
  TEST_TYPE_NAME = 'mytype';

type             
  // TCustomHeapType has all the logic to create heap types and we only have to
  // override some procedures where we'll create the classes that declare our
  // custom functions.
  //
  // In older Python version we would need to create a custom TPyType_Spec class
  // but in Python 3.15 we need to create a custom TPyHeapTypeSlotManager class.
  TTestHeapType = class(TCustomHeapType)
    protected
      procedure CreateTypeSpec; override;
      procedure CreateSlotManager; override;

    public
      function GetID(args: PPyObject): PPyObject;
  end;
                             
  // This class will add our custom functions in older Python versions
  TPyTestType_Spec = class(TPyType_Spec)
    protected
      procedure AddAllSlots; override;
      procedure AddAllMethods; override;
  end;
                     
  // This class will add out custom functions in Python 3.15
  TPyTestSlotManager = class(TPyHeapTypeSlotManager)
    protected
      procedure AddAllSlots; override;
      procedure AddAllMethods; override;
  end;


implementation

uses
  SysUtils,
  uP4P.MiscFunctions, uP4P.Engine, uP4P.PyTuple, uP4P.PyUnicode, uP4P.PyBytes,
  uP4P.PyRun, uP4P.PyBool, uP4P.PyLong;
                                       
// This is the callback for the "repr" function.
// It just shows the type name and the memory location of the object.
function mytype_repr(self: PPyObject): PPyObject; cdecl;
var
  TempResult : IPyObject;
begin
  TempResult := TPyUnicode.FromString('<' + TEST_TYPE_NAME + ' object at 0x' + IntToHex(uint64(self), SizeOf(Pointer) * 2) + '>');
  Result     := TempResult.UnWrap;
end;
                     
// This is the callback for the "getid" function.
// It finds the heap type instance using GlobalP4PEngine.SearchHeapType and calls
// TTestHeapType.GetID
function mytype_getid(self, args: PPyObject): PPyObject; cdecl;
var
  TempType: TCustomHeapType;
begin
  TempType := nil;

  if (GlobalP4PEngine <> nil) and
     GlobalP4PEngine.SearchHeapType(self, False, TempType) and
     (TempType is TTestHeapType) then
    Result := TTestHeapType(TempType).GetID(args)
   else
    Result := TPyNone.ReturnNone;
end;

{ TTestHeapType }

procedure TTestHeapType.CreateSlotManager;
begin
  FSlotManager       := TPyTestSlotManager.Create;
  FSlotManager.Flags := Py_TPFLAGS_DEFAULT or Py_TPFLAGS_BASETYPE;
end;

procedure TTestHeapType.CreateTypeSpec;
begin
  FTypeSpec       := TPyTestType_Spec.Create;
  FTypeSpec.Flags := Py_TPFLAGS_DEFAULT or Py_TPFLAGS_BASETYPE;
end;

function TTestHeapType.GetID(args: PPyObject): PPyObject;
var
  TempResult : IPyObject;
begin
  TempResult := TPyLong.FromLong(self.ID);
  Result     := TempResult.UnWrap;
end;

{ TPyTestType_Spec }
                                         
// This procedure adds a slot to use a custom function for the "repr" function.
procedure TPyTestType_Spec.AddAllSlots;
begin
  inherited AddAllSlots;

  AddReprSlot(@mytype_repr);
end;
                                   
// This procedure adds our custom functions for older Python versions.
// Python will use the mytype_getid callback when it
// needs to call the "getid" function in our heap type.
procedure TPyTestType_Spec.AddAllMethods;
begin
  inherited;
  AddMethod('getid', '', @mytype_getid, METH_VARARGS);
end;

{ TPyTestSlotManager }
                                            
// This procedure adds a slot to use a custom function for the "repr" function.
procedure TPyTestSlotManager.AddAllSlots;
begin
  inherited AddAllSlots;

  AddReprSlot(@mytype_repr);
end;
                                        
// This procedure adds our custom functions for Python 3.15.
// Python will use the mytype_getid callback when it
// needs to call the "getid" function in our heap type.
procedure TPyTestSlotManager.AddAllMethods;
begin
  inherited;
  AddMethod('getid', '', @mytype_getid, METH_VARARGS);
end;

end.
