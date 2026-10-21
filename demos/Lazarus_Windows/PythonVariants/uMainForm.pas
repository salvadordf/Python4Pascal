unit uMainForm;

{$MODE Delphi}

{$I ..\..\..\source\p4p.inc}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyEval, uP4P.PyRun, uP4P.Constants;

type
  TMainForm = class(TForm)
    LogMem: TMemo;
    Run2Btn: TButton;
    Splitter1: TSplitter;
    CodeMem: TMemo;
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Run2BtnClick(Sender: TObject);
  private
    { Private declarations }
    procedure GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation         

// This demo shows how to handle Python classes with Delphi variants.
//
// The Python code declares "MyClass". The "Run code" button executes that code
// and creates an instance of that class.
// Then this demo uses the "MyClass" properties and calls its functions.

{$R *.lfm}

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
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

      if GlobalP4PEngine.Load(TempLibPath) and
         GlobalP4PEngine.Initialize then
        LogMem.Lines.Add('Python initialized. ' + GlobalP4PEngine.buildinfo)
       else
        begin
          LogMem.Lines.Add('There was an error initializing Python!');
          LogMem.Lines.Add(GlobalP4PEngine.LastErrorMessage);
        end;
    end;
end;

procedure TMainForm.GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
begin
  LogMem.Lines.Add(message_);
end;

procedure TMainForm.Run2BtnClick(Sender: TObject);
var
  TempMainModObj : IPyObject;
  TempClass, TempMainModVar, TempTuple, TempList, TempDate, TempInt, TempFloat, TempBool, TempString : Variant;
begin                                                
  // First we run the code to declare "MyClass"
  if TPyRun.SimpleString(CodeMem.Text) then
    begin
      // Then we get the main module
      TempMainModObj := GlobalP4PEngine.MainModule;

      if not(assigned(TempMainModObj)) then exit;
                                                  
      // Convert the main module from IPyObject to variant
      TempMainModVar := TempMainModObj.AsVariant;            
      // Call the MyClass constructor found in the main module.
      TempClass      := TempMainModVar.MyClass();     
      // At this point we can use the properties and functions normally.
      LogMem.Lines.Add('MyClass.x = ' + inttostr(TempClass.x));
      TempClass.x := TempClass.x * TempClass.x;
      LogMem.Lines.Add('MyClass.x * TempClass.x = ' + inttostr(TempClass.x));
      TempBool := TempClass.boolean_test();
      LogMem.Lines.Add('MyClass.boolean_test() = ' + booltostr(TempBool, True));
      TempInt := TempClass.integer_test();
      LogMem.Lines.Add('MyClass.integer_test() = ' + inttostr(TempInt));
      TempFloat := TempClass.float_test();
      LogMem.Lines.Add('MyClass.float_test() = ' + floattostr(TempFloat));
      TempString := TempClass.string_test();
      LogMem.Lines.Add('MyClass.string_test() = ' + TempString);
      TempTuple := TempClass.tuple_test();
      LogMem.Lines.Add('MyClass.tuple_test() = ' + TempTuple);
      TempList :=  TempClass.list_test();
      LogMem.Lines.Add('MyClass.list_test() = ' + TempList);
      TempDate := TempClass.datetime_test();
      LogMem.Lines.Add('MyClass.datetime_test() = ' + TempDate + ' -> ' + DateTimeToStr(TDateTime(TempDate)));
      LogMem.Lines.Add('MyClass.square_test(5) = ' + inttostr(TempClass.square_test(5)));
      LogMem.Lines.Add('MyClass.uppercase_test("test") = ' + TempClass.uppercase_test('test'));
    end;
end;

end.
