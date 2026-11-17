unit uMainForm;

{$MODE Delphi}

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, SyncObjs,
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyEval, uP4P.PyRun, uP4P.Constants,
  uInterfaces;

const
  DATA_LENGTH = 300;
  BUBBLE_IDX  = 0;
  SELECT_IDX  = 1;
  QUICK_IDX   = 2;
  FIRST_IDX   = BUBBLE_IDX;
  LAST_IDX    = QUICK_IDX;

  CRLF = #13+#10;

  BUBBLE_MODNAME = 'bubblemodule';
  SELECT_MODNAME = 'selectmodule';
  QUICK_MODNAME  = 'quickmodule';

type
  TMainForm = class(TForm, IMainForm)
    LogMem: TMemo;
    RunBtn: TButton;
    RunPnl: TPanel;
    ThreadRunModeRg: TRadioGroup;
    MainPnl: TPanel;
    BottomPnl: TPanel;
    BubbleSortPb: TPaintBox;
    SelectionSortPb: TPaintBox;
    QuickSortPb: TPaintBox;
    BubbleSortPnl: TPanel;
    QuickSortPnl: TPanel;
    SelectionSortPnl: TPanel;
    Timer1: TTimer;
    BubbleSortChk: TCheckBox;
    SelectionSortChk: TCheckBox;
    QuickSortChk: TCheckBox;
    procedure RunBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormShow(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BubbleSortPbPaint(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);

  private
    FPendingMsg : TStringList;
    FPendingCS  : TCriticalSection;
    FData       : array[FIRST_IDX..LAST_IDX, 0..pred(DATA_LENGTH)] of byte;
    FStatus     : array[FIRST_IDX..LAST_IDX] of boolean;

    function  GetRunning: boolean;
    function  GetStatus(idx: integer): boolean;
    procedure SetStatus(idx: integer; aValue: boolean);

    function  AppendMessage(const aMessage: string): boolean;
    procedure ShowPendingMessages;
    procedure CreateSortThread(const aModName, aCode: string; aIdx: integer);
    procedure CreateBubbleSortThread;
    procedure CreateSelectionSortThread;
    procedure CreateQuickSortThread;
    function  Lock: boolean;
    procedure Unlock;
    procedure InitializeData;
    procedure InitializeStatus;
    procedure EnableInterface;
    procedure Thread_OnTerminate(Sender: TObject);

    function  GetValue(ModIdx, i: integer): integer;
    function  Swap(ModIdx, i, j: integer): boolean;

    property Status[idx: integer] : boolean  read GetStatus   write SetStatus;
    property Running              : boolean  read GetRunning;

  public
    procedure GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
  end;

var
  MainForm: TMainForm;

implementation

// This demo shows how to use several threads to execute Python code at
// the same time thanks to the "free-threaded" mode introduced in Python 3.13.
//
//     https://docs.python.org/3/howto/free-threading-python.html
//
// In order to use the "free-threaded" mode it's necessary to build
// Python4Pascal with the PY_GIL_DISABLED conditional and enable the option in
// the official Python installer to download the "free-threaded" binaries.
//
// The project options of this demo enables the PY_GIL_DISABLED conditional
// but you can also enable it in the p4p.inc file.
//
// This demo uses the TSortThread class to sort an array using the bubble,
// selection and quick sort functions.
//
// The TSortModule modules declare the "getvalue" and "swap" Python functions
// to handle the array available in the Delphi code.
//
// It's necessary to call GlobalP4PEngine.SaveThreadState before running Python
// in a different thread.
//
// This demo assumes all callbacks and events run in a different thread so the
// array and the messages are protected by critical sections.
//
// The timer is used to refresh the paitboxes with the ordered data at regular
// intervals.


{$R *.lfm}

uses
  uSortThread, uP4P.Types;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  DestroyGlobalP4PEngine;
  FreeAndNil(FPendingCS);
  FreeAndNil(FPendingMsg);
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FPendingCS  := TCriticalSection.Create;
  FPendingMsg := TStringList.Create;

  InitializeStatus;
  InitializeData;
end;

procedure TMainForm.FormShow(Sender: TObject);
begin
  if not(assigned(GlobalP4PEngine)) then
    begin
      GlobalP4PEngine                 := TP4PEngine.Create;
      GlobalP4PEngine.OnOutputMessage := GlobalP4PEngine_OnOutputMessage;
    end;

  if not(GlobalP4PEngine.Initialized) then
    begin
      GlobalP4PEngine.SetCurrentDir := True;
      GlobalP4PEngine.UseDebugLib   := False;

      if GlobalP4PEngine.Load and
         GlobalP4PEngine.Initialize then
        begin
          EnableInterface;
          LogMem.Lines.Add('Python initialized. ' + GlobalP4PEngine.buildinfo);
          // We *MUST* call SaveThreadState before running Python in a different thread.
          GlobalP4PEngine.SaveThreadState;
        end
       else
        begin
          LogMem.Lines.Add('There was an error initializing Python!');
          LogMem.Lines.Add(GlobalP4PEngine.LastErrorMessage);
        end;
    end;
end;

function TMainForm.Lock: boolean;
begin
  Result := False;

  if assigned(FPendingCS) then
    begin
      FPendingCS.Acquire;
      Result := True;
    end;
end;

procedure TMainForm.Unlock;
begin
  if assigned(FPendingCS) then
    FPendingCS.Release;
end;

procedure TMainForm.GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
begin
  if AppendMessage(message_) then
    TThread.ForceQueue(nil, ShowPendingMessages);
end;

procedure TMainForm.RunBtnClick(Sender: TObject);
begin
  LogMem.Lines.Clear;
  InitializeStatus;
  InitializeData;
  Repaint;

  if BubbleSortChk.Checked    then CreateBubbleSortThread;
  if SelectionSortChk.Checked then CreateSelectionSortThread;
  if QuickSortChk.Checked     then CreateQuickSortThread;

  EnableInterface;
end;

procedure TMainForm.BubbleSortPbPaint(Sender: TObject);
var
  TempIdx, i, TempHeight : integer;
  TempCanvas : TCanvas;
begin
  TempIdx    := TPaintBox(sender).Tag;
  TempCanvas := TPaintBox(sender).Canvas;
  TempHeight := TPaintBox(sender).Height;

  case TempIdx of
    BUBBLE_IDX : TempCanvas.Pen.Color := clRed;
    SELECT_IDX : TempCanvas.Pen.Color := clGreen;
    QUICK_IDX  : TempCanvas.Pen.Color := clBlue;
  end;

  if Lock then
    try
      for i := 0 to pred(DATA_LENGTH) do
        begin
          TempCanvas.MoveTo(i, pred(TempHeight));
          TempCanvas.LineTo(i, pred(TempHeight) - FData[TempIdx, i]);
        end;
    finally
      Unlock;
    end;
end;

function TMainForm.GetRunning: boolean;
var
  i : integer;
begin
  Result := False;

  if Lock then
    try
      for i := FIRST_IDX to LAST_IDX do
        if FStatus[i] then
          begin
            Result := True;
            break;
          end;
    finally
      Unlock;
    end;
end;

function TMainForm.GetStatus(idx: integer): boolean;
begin
  Result := False;

  if Lock then
    try
      Result := FStatus[idx];
    finally
      Unlock;
    end;
end;

procedure TMainForm.SetStatus(idx: integer; aValue: boolean);
begin
  if Lock then
    try
      FStatus[idx] := aValue;
    finally
      Unlock;
    end;
end;

procedure TMainForm.CreateBubbleSortThread;
var
  TempCode : string;
begin
  TempCode := 'import ' + BUBBLE_MODNAME + CRLF +
              'def bubble_sort(n):' + CRLF +
              '    for i in range(n-1):' + CRLF +
              '        for j in range(n-i-1):' + CRLF +
              '            if ' + BUBBLE_MODNAME + '.getvalue(j) > ' + BUBBLE_MODNAME + '.getvalue(j+1):' + CRLF +
              '                ' + BUBBLE_MODNAME + '.swap(j,j+1)' + CRLF +
              'bubble_sort(' + inttostr(DATA_LENGTH) + ')' + CRLF +
              'print("bubble_sort finished")';

  CreateSortThread(BUBBLE_MODNAME, TempCode, BUBBLE_IDX);
end;

procedure TMainForm.CreateSelectionSortThread;
var
  TempCode : string;
begin
  TempCode := 'import ' + SELECT_MODNAME + CRLF +
              'def selection_sort(n):' + CRLF +
              '    for i in range(n - 1):' + CRLF +
              '        min_idx = i' + CRLF +
              '        for j in range(i + 1, n):' + CRLF +
              '            if ' + SELECT_MODNAME + '.getvalue(j) < ' + SELECT_MODNAME + '.getvalue(min_idx):' + CRLF +
              '                min_idx = j' + CRLF +
              '        ' + SELECT_MODNAME + '.swap(i, min_idx)' + CRLF +
              'selection_sort(' + inttostr(DATA_LENGTH) + ')' + CRLF +
              'print("selection_sort finished")';

  CreateSortThread(SELECT_MODNAME, TempCode, SELECT_IDX);
end;

procedure TMainForm.CreateQuickSortThread;
var
  TempCode : string;
begin
  TempCode := 'import ' + QUICK_MODNAME + CRLF +
              'def partition(low, high):' + CRLF +
              '    pivot = ' + QUICK_MODNAME + '.getvalue(high)' + CRLF +
              '    i = low - 1' + CRLF +
              '    for j in range(low, high):' + CRLF +
              '        if ' + QUICK_MODNAME + '.getvalue(j) <= pivot:' + CRLF +
              '            i += 1' + CRLF +
              '            ' + QUICK_MODNAME + '.swap(i, j)' + CRLF +
              CRLF +
              '    ' + QUICK_MODNAME + '.swap(i + 1, high)' + CRLF +
              '    return i + 1' + CRLF +
              CRLF +
              'def quick_sort(low, high):' + CRLF +
              '    if low < high:' + CRLF +
              '        p = partition(low, high)' + CRLF +
              '        quick_sort(low, p - 1)' + CRLF +
              '        quick_sort(p + 1, high)' + CRLF +
              'quick_sort(0,' + inttostr(pred(DATA_LENGTH)) + ')' + CRLF +
              'print("quick_sort finished")';

  CreateSortThread(QUICK_MODNAME,  TempCode,  QUICK_IDX);
end;

procedure TMainForm.CreateSortThread(const aModName, aCode: string; aIdx: integer);
var
  TempThread : TSortThread;
begin
  TempThread                   := TSortThread.Create(True);
  TempThread.ModName           := aModName;
  TempThread.Code              := aCode;
  TempThread.FreeOnTerminate   := True;
  TempThread.MainForm          := self;
  TempThread.Idx               := aIdx;
  TempThread.ThreadInit        := TP4PThreadInit(ThreadRunModeRg.ItemIndex);
  TempThread.OnTerminate       := Thread_OnTerminate;

  Status[aIdx] := True;
  AppendMessage('Thread ' + inttostr(aIdx) + ' has started. ' + TimeToStr(Now));

  TempThread.Resume;
end;

procedure TMainForm.EnableInterface;
begin
  Timer1.Enabled           := Running;
  RunPnl.Enabled           := not(Timer1.Enabled);
  BubbleSortChk.Enabled    := RunPnl.Enabled;
  SelectionSortChk.Enabled := RunPnl.Enabled;
  QuickSortChk.Enabled     := RunPnl.Enabled;
end;

procedure TMainForm.Thread_OnTerminate(Sender: TObject);
var
  TempIdx : integer;
begin
  TempIdx := TSortThread(sender).Idx;

  Status[TempIdx] := False;

  TThread.ForceQueue(nil, EnableInterface);
  TThread.ForceQueue(nil, Refresh);

  AppendMessage('Thread ' + inttostr(TempIdx) + ' has finished. ' + TimeToStr(Now));
  TThread.ForceQueue(nil, ShowPendingMessages);
end;

procedure TMainForm.Timer1Timer(Sender: TObject);
begin
  Refresh;
end;

function TMainForm.AppendMessage(const aMessage: string): boolean;
var
  TempMsg : string;
begin
  Result := False;
  if Lock then
    try
      TempMsg := trim(aMessage);

      if (length(TempMsg) > 0) then
        begin
          FPendingMsg.Add(TempMsg);
          Result := True;
        end;
    finally
      Unlock;
    end;
end;

procedure TMainForm.ShowPendingMessages;
begin
  if Lock then
    try
      if (FPendingMsg.Count > 0) then
        begin
          LogMem.Lines.AddStrings(FPendingMsg);
          FPendingMsg.Clear;
        end;
    finally
      Unlock;
    end;
end;

function TMainForm.GetValue(ModIdx, i: integer): integer;
begin
  Result := 0;

  if (ModIdx >= FIRST_IDX) and (ModIdx <= LAST_IDX) and
     (i >= 0) and (i < DATA_LENGTH) and
     Lock then
    try
      Result := FData[ModIdx, i];
    finally
      Unlock;
    end;
end;

function TMainForm.Swap(ModIdx, i, j: integer): boolean;
var
  TempValue : byte;
begin
  Result := False;

  if (ModIdx >= FIRST_IDX) and (ModIdx <= LAST_IDX) and
     (i >= 0) and (i < DATA_LENGTH) and
     (j >= 0) and (j < DATA_LENGTH) and
     Lock then
    try
      TempValue        := FData[ModIdx, i];
      FData[ModIdx, i] := FData[ModIdx, j];
      FData[ModIdx, j] := TempValue;
      Result           := True;
    finally
      Unlock;
    end;
end;

procedure TMainForm.InitializeStatus;
var
  i : integer;
begin
  if Lock then
    try
      for i := FIRST_IDX to LAST_IDX do
        FStatus[i] := False;
    finally
      Unlock;
    end;
end;

procedure TMainForm.InitializeData;
var
  i : integer;
begin
  if Lock then
    try
      Randomize;

      for i := 0 to pred(DATA_LENGTH) do
        begin
          FData[BUBBLE_IDX, i] := Random(255);
          FData[SELECT_IDX, i] := FData[BUBBLE_IDX, i];
          FData[QUICK_IDX,  i] := FData[BUBBLE_IDX, i];
        end;
    finally
      Unlock;
    end;
end;

end.

