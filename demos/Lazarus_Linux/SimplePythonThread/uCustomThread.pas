unit uCustomThread;

{$MODE Delphi}

interface

uses
  uP4P.Thread;

type                               
  // TP4PThread has all the code needed to run Python in a thread and all
  // we have to do is override doOnExecutePython or implement the
  // TP4PThread.OnExecutePython event.
  TCustomThread = class(TP4PThread)
    protected
      FCode : string;
      procedure doOnExecutePython; override;

    public
      property Code : string read FCode write FCode;
  end;

implementation

uses
  uP4P.PyRun;

procedure TCustomThread.doOnExecutePython;
begin
  TPyRun.SimpleString(FCode);
end;

end.
