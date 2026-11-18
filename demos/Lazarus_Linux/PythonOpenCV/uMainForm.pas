unit uMainForm;

{$MODE Delphi}

interface

uses
  SysUtils, Variants, Classes, Graphics,
  Controls, Forms, Dialogs, StdCtrls, ExtCtrls,
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyRun, uP4P.Constants, uP4P.Metadata,
  uCameraTest;

type
  TMainForm = class(TForm)
    CodeMem: TMemo;
    LogMem: TMemo;
    Splitter1: TSplitter;
    ButtonPnl: TPanel;
    TestMyClassBtn: TButton;
    SaveDialog1: TSaveDialog;
    Image1: TImage;
    procedure TestMyClassBtnClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);

  private
    FCameraTest : TCameraTest;
    FMetadata   : TPyMetadata;

    procedure GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
  public
    { Public declarations }
  end;

var
  MainForm: TMainForm;

implementation

{$R *.lfm}

procedure TMainForm.GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
begin
  LogMem.Lines.Add(message_);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if assigned(FCameraTest) then
    FreeAndNil(FCameraTest);

  if assigned(FMetadata) then
    FreeAndnil(FMetadata);

  DestroyGlobalP4PEngine;
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

      if GlobalP4PEngine.Load and
         GlobalP4PEngine.Initialize then
        begin
          LogMem.Lines.Add('Python initialized. ' + GlobalP4PEngine.buildinfo);

          FMetadata := TPyMetadata.Create;
          if FMetadata.Initialized and
             (FMetadata.Distributions.Search('opencv-python') >= 0) then
            begin
              if TPyRun.SimpleString(CodeMem.Text) then
                begin
                  FCameraTest := TCameraTest.Create;

                  if FCameraTest.Initialized then
                    begin
                      LogMem.Lines.Add('FCameraTest is initialized.');
                      ButtonPnl.Enabled := True;
                    end
                   else
                    LogMem.Lines.Add('There was an issue initializing FCameraTest.');
                end
               else
                LogMem.Lines.Add('There was an issue running the code.');
            end
           else
            LogMem.Lines.Add('You need to install the opencv-python package in order to use this demo.');
        end
       else
        begin
          LogMem.Lines.Add('There was an error initializing Python!');
          LogMem.Lines.Add(GlobalP4PEngine.LastErrorMessage);
        end;
    end;
end;

procedure TMainForm.TestMyClassBtnClick(Sender: TObject);
begin
  if assigned(FCameraTest) and
     SaveDialog1.Execute and
     FCameraTest.Snapshot(SaveDialog1.FileName) then
    begin
      Image1.Picture.LoadFromFile(SaveDialog1.FileName);
      LogMem.Lines.Add('Snapshot saved.');
    end
   else
    LogMem.Lines.Add('There was a problem taking the snapshot.');
end;

end.
