unit uMainForm;

{$I ..\..\..\source\p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs,
  Vcl.StdCtrls, Vcl.ExtCtrls, System.SyncObjs,
  {$ELSE}
  Windows, Messages, SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls, SyncObjs,
  {$ENDIF}
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

// 

{$R *.dfm}

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

      //TempLibPath := TempDrive + ':\python-3.15.2-embed-' + TempBit + '\python315.dll';
      //TempLibPath := TempDrive + ':\python-3.14.8-embed-' + TempBit + '\python314.dll';
      //TempLibPath := TempDrive + ':\python-3.13.16-embed-' + TempBit + '\python313.dll';
      //TempLibPath := TempDrive + ':\python-3.12.10-embed-' + TempBit + '\python312.dll';
      //TempLibPath := TempDrive + ':\python-3.11.9-embed-' + TempBit + '\python311.dll';
      //TempLibPath := TempDrive + ':\python-3.10.11-embed-' + TempBit + '\python310.dll';
      //TempLibPath := TempDrive + ':\python-3.9.13-embed-' + TempBit + '\python39.dll';
      TempLibPath := '';

      GlobalP4PEngine.UseDebugLib := False;

      if GlobalP4PEngine.Load(TempLibPath) and
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
    TThread.Synchronize(nil, ShowPendingMessages);
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
              'bubble_sort(' + inttostr(DATA_LENGTH) + ')';

  CreateSortThread(BUBBLE_MODNAME, TempCode, BUBBLE_IDX);
end;

procedure TMainForm.CreateSelectionSortThread;
var
  TempCode : string;
begin
  TempCode := 'import ' + SELECT_MODNAME + CRLF +
              'def selection_sort(high):' + CRLF +
              '    for i in range(high-1):' + CRLF +
              '        for j in range(i+1,high):' + CRLF +
              '            if ' + SELECT_MODNAME + '.getvalue(i) > ' + SELECT_MODNAME + '.getvalue(j):' + CRLF +
              '                ' + SELECT_MODNAME + '.swap(i,j)' + CRLF +
              'selection_sort(' + inttostr(pred(DATA_LENGTH)) + ')';

  CreateSortThread(SELECT_MODNAME, TempCode, SELECT_IDX);
end;

procedure TMainForm.CreateQuickSortThread;
var
  TempCode : string;
begin
  TempCode := 'import ' + QUICK_MODNAME + CRLF +
              'def quick_sort(low,high):' + CRLF +
              '    Lo = low' + CRLF +
              '    Hi = high-1' + CRLF +
              '    Mid = ' + QUICK_MODNAME + '.getvalue((Lo+Hi) // 2)' + CRLF +
              '    while 1:' + CRLF +
              '        while ' + QUICK_MODNAME + '.getvalue(Lo) < Mid:' + CRLF +
              '            Lo = Lo + 1' + CRLF +
              '        while ' + QUICK_MODNAME + '.getvalue(Hi) > Mid:' + CRLF +
              '            Hi = Hi - 1' + CRLF +
              '        if Lo <= Hi:' + CRLF +
              '            ' + QUICK_MODNAME + '.swap(Lo,Hi)' + CRLF +
              '            Lo = Lo + 1' + CRLF +
              '            Hi = Hi - 1' + CRLF +
              '        if Lo > Hi:' + CRLF +
              '            break' + CRLF +
              '    if Hi > low:' + CRLF +
              '        quick_sort(low,Hi+1)' + CRLF +
              '    if Lo < high-1:' + CRLF +
              '        quick_sort(Lo,high)' + CRLF +
              'quick_sort(0,' + inttostr(pred(DATA_LENGTH)) + ')';

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
  AppendMessage('Thread ' + inttostr(aIdx) + ' has started.' + TimeToStr(Now));

  {$IFDEF DELPHI14_UP}
  TempThread.Start;
  {$ELSE}
  TempThread.Resume;
  {$ENDIF}
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

  AppendMessage('Thread ' + inttostr(TempIdx) + ' has finished.' + TimeToStr(Now));
  TThread.Synchronize(nil, ShowPendingMessages);
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

