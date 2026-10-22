unit uCustomThread;

{$MODE Delphi}

interface

uses
  SysUtils,
  uP4P.Thread, uP4P.PyModule, uTestModule, uTestHeapType;

type                           
  // TP4PThread has all the code needed to run Python in a thread and all
  // we have to do is override doOnExecutePython or implement the
  // TP4PThread.OnExecutePython event.
  // This demo creates a custom module and a heap type so it's also necessary to
  // override doOnFinalizeModules and doOnDestroyModules.
  TCustomThread = class(TP4PThread)
    protected
      FCode        : string;
      FTestModule  : TTestModule;
      FTestType    : TTestHeapType;

      procedure doOnExecutePython; override;     
      procedure doOnFinalizeModules; override;
      procedure doOnDestroyModules; override;

      function  CreateModule: boolean;
      function  CreateType: boolean;

    public
      property Code : string read FCode write FCode;
  end;

implementation

uses
  uP4P.PyRun, uP4P.Types;
                                 
// We create the module and the heap type before running the Python code.
procedure TCustomThread.doOnExecutePython;
begin
  if CreateModule and CreateType then
    TPyRun.SimpleString(FCode);
end;
                                   
// This procedure will be executed before the TPy.EndInterpreter call and it's
// used to finalize the modules and types.
procedure TCustomThread.doOnFinalizeModules;
begin
  if assigned(FTestType) then
    FTestType.Finalize;

  if assigned(FTestModule) then
    FTestModule.Finalize;
end;

// This procedure will be executed after the TPy.EndInterpreter call and it's
// used to destroy the modules and types.
procedure TCustomThread.doOnDestroyModules;
begin
  if assigned(FTestType) then
    FreeAndNil(FTestType);

  if assigned(FTestModule) then
    FreeAndnil(FTestModule);
end;
                                   
// This function creates our custom module
function TCustomThread.CreateModule: boolean;
begin
  FTestModule                  := TTestModule.Create(TEST_MODULE_NAME);
  FTestModule.MultIntprSupport := piGilSupported;
  Result                       := FTestModule.Initialize;
end;
                                          
// This function creates our custom heap type and adds it to our custom module.
function TCustomThread.CreateType: boolean;
begin
  FTestType            := TTestHeapType.Create(TEST_TYPE_NAME);
  FTestType.DocStrings := 'test docstring';

  Result := FTestType.Initialize and
            TPyModule.AddObjectRef(FTestModule.Module, TEST_TYPE_NAME, FTestType.HeapType);
end;

end.
