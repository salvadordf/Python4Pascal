unit uP4P.WorkerThread;

{$IFDEF FPC}
  {$MODE OBJFPC}{$H+}
{$ENDIF}

{$I p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  System.Classes, System.SysUtils, System.SyncObjs, System.Contnrs,
  {$ELSE}
  Classes, SysUtils, SyncObjs, Contnrs,
  {$ENDIF}
  uP4P.Thread;

const
  WORKERTHREADMSG_QUIT = 1;

type
  /// <summary>
  /// Custom message information
  /// </summary>
  TMsgInfo = record
    Msg      : integer;
    StrParam : string;
    IntParam : integer;
  end;

  /// <summary>
  /// Custom thread message
  /// </summary>
  TP4PWorkerThreadMsg = class
    protected
      FValue : TMsgInfo;

    public
      constructor Create(const aValue : TMsgInfo);

      property Value : TMsgInfo read FValue;
  end;

  /// <summary>
  /// Custom worker thread
  /// </summary>
  TP4PWorkerThread = class(TP4PThread)
    protected
      FCritSect        : TCriticalSection;
      FEvent           : TEvent;
      FWaiting         : boolean;
      FStop            : boolean;
      FMsgQueue        : TObjectQueue;

      function  Lock : boolean;
      procedure Unlock;
      function  CanContinue : boolean;
      procedure ReadAllPendingMessages;
      procedure ProcessMessage(const aInfo : TMsgInfo); virtual;
      function  ReadPendingMessage(var aMsgInfo : TMsgInfo) : boolean;
      procedure EnqueueMessage(const aMsgInfo : TMsgInfo); overload;
      procedure StopThread;
      procedure DestroyQueue;

      procedure doOnExecutePython; override;

    public
      constructor Create;
      destructor  Destroy; override;
      procedure   AfterConstruction; override;

      procedure EnqueueMessage(aMsg: integer; aIntParam : integer = 0; const aStrParam : string = ''); overload;
  end;

implementation

{* TP4PWorkerThreadMsg *}

constructor TP4PWorkerThreadMsg.Create(const aValue : TMsgInfo);
begin
  inherited Create;

  FValue := aValue;
end;


{* TP4PWorkerThread *}

constructor TP4PWorkerThread.Create;
begin
  FCritSect        := nil;
  FWaiting         := False;
  FStop            := False;
  FEvent           := nil;
  FMsgQueue        := nil;

  inherited Create(True);

  FreeOnTerminate := False;
end;

destructor TP4PWorkerThread.Destroy;
begin
  if (FEvent    <> nil) then FreeAndNil(FEvent);
  if (FCritSect <> nil) then FreeAndNil(FCritSect);

  DestroyQueue;

  inherited Destroy;
end;

procedure TP4PWorkerThread.DestroyQueue;
begin
  if (FMsgQueue <> nil) then
    begin
      while (FMsgQueue.Count > 0) do
        FMsgQueue.Pop.Free;

      FreeAndNil(FMsgQueue);
    end;
end;

procedure TP4PWorkerThread.AfterConstruction;
begin
  inherited AfterConstruction;

  FEvent    := TEvent.Create(nil, False, False, '');
  FCritSect := TCriticalSection.Create;
  FMsgQueue := TObjectQueue.Create;
end;

function TP4PWorkerThread.Lock : boolean;
begin
  if (FCritSect <> nil) then
    begin
      FCritSect.Acquire;
      Result := True;
    end
   else
    Result := False;
end;

procedure TP4PWorkerThread.Unlock;
begin
  if (FCritSect <> nil) then FCritSect.Release;
end;

procedure TP4PWorkerThread.StopThread;
begin
  if Lock then
    begin
      FStop := True;
      Unlock;
    end;
end;

procedure TP4PWorkerThread.EnqueueMessage(aMsg, aIntParam : integer; const aStrParam : string);
var
  TempMsgInfo : TMsgInfo;
begin
  TempMsgInfo.Msg      := aMsg;
  TempMsgInfo.StrParam := aStrParam;
  TempMsgInfo.IntParam := aIntParam;
  EnqueueMessage(TempMsgInfo);
end;

procedure TP4PWorkerThread.EnqueueMessage(const aMsgInfo : TMsgInfo);
begin
  if Lock then
    try
      if (FMsgQueue <> nil) then
        FMsgQueue.Push(TP4PWorkerThreadMsg.Create(aMsgInfo));

      if FWaiting then
        begin
          FWaiting := False;
          FEvent.SetEvent;
        end;
    finally
      Unlock;
    end;
end;

function TP4PWorkerThread.ReadPendingMessage(var aMsgInfo : TMsgInfo) : boolean;
var
  TempMessage : TP4PWorkerThreadMsg;
begin
  Result := False;

  if Lock then
    try
      FWaiting := False;

      if (FMsgQueue <> nil) and (FMsgQueue.Count > 0) then
        begin
          TempMessage := TP4PWorkerThreadMsg(FMsgQueue.Pop);
          aMsgInfo    := TempMessage.Value;
          Result      := True;
          TempMessage.Free;
        end;
    finally
      Unlock;
    end;
end;

procedure TP4PWorkerThread.ReadAllPendingMessages;
var
  TempInfo : TMsgInfo;
begin
  while ReadPendingMessage(TempInfo) do
    case TempInfo.Msg of
      WORKERTHREADMSG_QUIT :
        begin
          StopThread;
          exit;
        end;

      else ProcessMessage(TempInfo);
    end;
end;

procedure TP4PWorkerThread.ProcessMessage(const aInfo : TMsgInfo);
begin
  //
end;

function TP4PWorkerThread.CanContinue : boolean;
begin
  Result := False;

  if Lock then
    try
      if not(Terminated) and not(FStop) then
        begin
          Result   := True;
          FWaiting := True;
          FEvent.ResetEvent;
        end;
    finally
      Unlock;
    end;
end;

procedure TP4PWorkerThread.doOnExecutePython;
const
  INFINITE = Cardinal($FFFFFFFF);
begin
  while CanContinue do
    begin
      FEvent.WaitFor(INFINITE);
      ReadAllPendingMessages;
    end;
end;

end.
