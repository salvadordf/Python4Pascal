unit uMainForm;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, StdCtrls,
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyEval, uP4P.PyRun, uP4P.Constants;

type

  { TMainForm }

  TMainForm = class(TForm)
    LogMem: TMemo;
    CodeMem: TMemo;
    Run2Btn: TButton;
    EvaluateBtn: TButton;
    Panel1: TPanel;
    Splitter1: TSplitter;
    procedure EvaluateBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure Run2BtnClick(Sender: TObject);
  private
    procedure GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
  public

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

{ TMainForm }

procedure TMainForm.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
  DestroyGlobalP4PEngine;
end;

procedure TMainForm.EvaluateBtnClick(Sender: TObject);
var
  TempResult : IPyObject;
begin
  TempResult := TPyEval.EvalString(CodeMem.Text);

  if TPyObject.IsInitialized(TempResult) then
    LogMem.Lines.Add('Code evaluated correctly. Result: ' + quotedstr(TempResult.AsString))
   else
    LogMem.Lines.Add('There was an error evaluating the code.');
end;

procedure TMainForm.FormShow(Sender: TObject);
var
  TempLibPath : string;
begin
  if not(assigned(GlobalP4PEngine)) then
    begin
      GlobalP4PEngine                 := TP4PEngine.Create;
      GlobalP4PEngine.OnOutputMessage := @GlobalP4PEngine_OnOutputMessage;
    end;

  if not(GlobalP4PEngine.Initialized) then
    begin
      GlobalP4PEngine.SetCurrentDir := True;
                                       
      // If you call GlobalP4PEngine.Load with an empty path it will try to load
      // the Python library that is installed in Linux.

      // Load and initialize the Python library.
      if GlobalP4PEngine.Load and
         GlobalP4PEngine.Initialize then
        LogMem.Lines.Add('Python initialized. ' + GlobalP4PEngine.buildinfo)
       else
        begin
          LogMem.Lines.Add('There was an error initializing Python!');
          LogMem.Lines.Add(GlobalP4PEngine.LastErrorMessage);
        end;
    end;
end;

procedure TMainForm.Run2BtnClick(Sender: TObject);
begin
  if TPyRun.SimpleString(CodeMem.Text) then
    LogMem.Lines.Add('Code run correctly.')
   else
    LogMem.Lines.Add('There was an error running the code.');
end;

procedure TMainForm.GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
var
  TempMsg : string;
begin
  TempMsg := trim(message_);

  if (length(TempMsg) > 0) then
    LogMem.Lines.Add(TempMsg);
end;

end.

