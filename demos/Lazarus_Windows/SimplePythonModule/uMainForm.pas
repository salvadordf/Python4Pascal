unit uMainForm;

{$MODE Delphi}

{$I ..\..\..\source\p4p.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyEval, uP4P.PyRun, uP4P.Constants,
  uTestModule, uTestHeapType;

type
  TMainForm = class(TForm)
    Panel1: TPanel;
    RunBtn: TButton;
    LogMem: TMemo;
    Splitter1: TSplitter;
    CodeMem: TMemo;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure RunBtnClick(Sender: TObject);
  private
    FTestModule  : TTestModule;    
    FTestType    : TTestHeapType;
    FCustomValue : string;

    function  CreateModule: boolean;
    function  CreateType: boolean;
    procedure GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
  public
    property CustomValue : string read FCustomValue write FCustomValue;
  end;

var
  MainForm: TMainForm;

implementation
                      
// This demo shows how to create a custom module and a custom heap type.

{$R *.lfm}

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if assigned(FTestModule) then
    FreeAndNil(FTestModule);     

  if assigned(FTestType) then
    FreeAndNil(FTestType);

  DestroyGlobalP4PEngine;
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  TempBit, TempDrive, TempLibPath : string;
begin
  if not(assigned(GlobalP4PEngine)) then
    begin
      GlobalP4PEngine                 := TP4PEngine.Create;
      GlobalP4PEngine.OnOutputMessage := GlobalP4PEngine_OnOutputMessage;
    end;

  if not(GlobalP4PEngine.Initialized) then
    begin
      GlobalP4PEngine.SetCurrentDir := True;

      {$IFDEF TARGET_32BITS}
      TempBit := 'win32';
      {$ELSE}
      TempBit := 'amd64';
      {$ENDIF}

      TempDrive := 'Q';
      //TempDrive := 'S';

      //TempLibPath := TempDrive + ':\python-3.15.0-embed-' + TempBit + '\python315.dll';
      //TempLibPath := TempDrive + ':\python-3.14.8-embed-' + TempBit + '\python314.dll';
      //TempLibPath := TempDrive + ':\python-3.13.16-embed-' + TempBit + '\python313.dll';
      //TempLibPath := TempDrive + ':\python-3.12.10-embed-' + TempBit + '\python312.dll';
      //TempLibPath := TempDrive + ':\python-3.11.9-embed-' + TempBit + '\python311.dll';
      //TempLibPath := TempDrive + ':\python-3.10.11-embed-' + TempBit + '\python310.dll';
      TempLibPath := '';
                                               
      // We create the module and the heap type after the Python initialization
      if GlobalP4PEngine.Load(TempLibPath) and
         GlobalP4PEngine.Initialize and
         CreateModule and
         CreateType then
        LogMem.Lines.Add('Python initialized. ' + GlobalP4PEngine.buildinfo)
       else
        begin
          LogMem.Lines.Add('There was an error initializing Python!');
          LogMem.Lines.Add(GlobalP4PEngine.LastErrorMessage);
        end;
    end;
end;
                                            
// This function creates our custom module
function TMainForm.CreateModule: boolean;
begin
  FTestModule          := TTestModule.Create(TEST_MODULE_NAME);
  FTestModule.MainForm := self;
  Result               := FTestModule.Initialize;
end;              
                                          
// This function creates our custom heap type and adds it to our custom module.
function TMainForm.CreateType: boolean;
begin
  FTestType            := TTestHeapType.Create(TEST_TYPE_NAME);
  FTestType.DocStrings := 'test docstring';

  Result := FTestType.Initialize and
            TPyModule.AddObjectRef(FTestModule.Module, TEST_TYPE_NAME, FTestType.HeapType);
end;

procedure TMainForm.GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
var
  TempMsg : string;
begin
  // We ignore empty messages in this demo.
  TempMsg := trim(message_);

  if (length(TempMsg) > 0) then
    LogMem.Lines.Add(TempMsg);
end;

procedure TMainForm.RunBtnClick(Sender: TObject);
begin
  if TPyRun.SimpleString(CodeMem.Text) then
    LogMem.Lines.Add('Code run correctly.')
   else
    LogMem.Lines.Add('There was an error running the code.');
end;

end.
