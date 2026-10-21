unit uMainForm;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyEval, uP4P.PyRun, uP4P.Constants;

type
  TMainForm = class(TForm)
    Memo1: TMemo;
    EvaluateBtn: TButton;
    Run2Btn: TButton;
    Splitter1: TSplitter;
    CodeMem: TMemo;
    Panel1: TPanel;
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Run2BtnClick(Sender: TObject);
    procedure EvaluateBtnClick(Sender: TObject);
  private
    { Private declarations }
    procedure GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

// This demo shows the easiest way to embed Python in an application.
//
// Basically, all you need to do is:
// 1. Load the Python library with the GlobalP4PEngine.Load call.
// 2. Initialize Python with the GlobalP4PEngine.Initialize call.
// 3. Run some Python code with the TPyRun.SimpleString call.
//
// This demo also implements the GlobalP4PEngine.OnOutputMessage event to
// show the Python messages in a TMemo.
//
// The "Evaluate code" button shows an alternative way to run Python code with
// a TPyEval.EvalString call.

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

      // All these library paths were used for testing purposes only.
      // Set your own library path if you wat to use an embedded Python package.

      // If you call GlobalP4PEngine.Load with an empty path it will try to load
      // the Python library that is installed in Windows.   

      // You can download Python from https://www.python.org/downloads/windows/

      //TempLibPath := TempDrive + ':\python-3.15.0-embed-' + TempBit + '\python315.dll';
      //TempLibPath := TempDrive + ':\python-3.14.8-embed-' + TempBit + '\python314.dll';
      //TempLibPath := TempDrive + ':\python-3.13.16-embed-' + TempBit + '\python313.dll';
      //TempLibPath := TempDrive + ':\python-3.12.10-embed-' + TempBit + '\python312.dll';
      //TempLibPath := TempDrive + ':\python-3.11.9-embed-' + TempBit + '\python311.dll';
      //TempLibPath := TempDrive + ':\python-3.10.11-embed-' + TempBit + '\python310.dll';
      TempLibPath := '';
                               
      // Load and initialize the Python library.
      if GlobalP4PEngine.Load(TempLibPath) and
         GlobalP4PEngine.Initialize then
        Memo1.Lines.Add('Python initialized. ' + GlobalP4PEngine.buildinfo)
       else
        begin
          Memo1.Lines.Add('There was an error initializing Python!');
          Memo1.Lines.Add(GlobalP4PEngine.LastErrorMessage);
        end;
    end;
end;

procedure TMainForm.GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
var
  TempMsg : string;
begin
  TempMsg := trim(message_);

  if (length(TempMsg) > 0) then
    Memo1.Lines.Add(TempMsg);
end;

procedure TMainForm.Run2BtnClick(Sender: TObject);
begin
  if TPyRun.SimpleString(CodeMem.Text) then
    Memo1.Lines.Add('Code run correctly.')
   else
    Memo1.Lines.Add('There was an error running the code.');
end;

procedure TMainForm.EvaluateBtnClick(Sender: TObject);
var
  TempResult : IPyObject;
begin
  TempResult := TPyEval.EvalString(CodeMem.Text);

  if TPyObject.IsInitialized(TempResult) then
    Memo1.Lines.Add('Code evaluated correctly. Result: ' + quotedstr(TempResult.AsString))
   else
    Memo1.Lines.Add('There was an error evaluating the code.')
end;

end.
