unit uMainForm;

{$I ..\..\..\source\p4p.inc}

interface

uses
  {$IFDEF DELPHI16_UP}
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, System.ImageList, Vcl.Graphics, Vcl.Controls, Vcl.Forms,
  Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.Grids, Vcl.ImgList,
  Vcl.ToolWin, System.JSON, System.Generics.Collections,
  {$ELSE}
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ExtCtrls, StdCtrls, Grids, ImgList, ToolWin, ImageList,
  JSON,
  {$ENDIF}
  uP4P.Interfaces, uP4P.PyObject, uP4P.Engine, uP4P.Py, uP4P.PyImport,
  uP4P.PyModule, uP4P.PyEval, uP4P.PyRun, uP4P.Constants, uP4P.Pip,
  uP4P.Metadata, uP4P.Types;

type
  TMainForm = class(TForm)
    LogMem: TMemo;
    Splitter1: TSplitter;
    PackagesTb: TToolBar;
    ImageList1: TImageList;
    RefreshBtn: TToolButton;
    PackagesSg: TStringGrid;
    InstallPackageBtn: TToolButton;
    UninstallPackageBtn: TToolButton;
    UpdatePackageBtn: TToolButton;
    MainPnl: TPanel;
    InfoPnl: TPanel;
    Splitter2: TSplitter;
    PackagesPnl: TPanel;
    InfoMem: TMemo;
    CheckBtn: TToolButton;
    InstallPIPBtn: TToolButton;
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure RefreshBtnClick(Sender: TObject);
    procedure PackagesSgSelectCell(Sender: TObject; ACol, ARow: LongInt; var CanSelect: Boolean);
    procedure PackagesPnlResize(Sender: TObject);
    procedure InstallPackageBtnClick(Sender: TObject);
    procedure UpdatePackageBtnClick(Sender: TObject);
    procedure UninstallPackageBtnClick(Sender: TObject);
    procedure CheckBtnClick(Sender: TObject);
    procedure InstallPIPBtnClick(Sender: TObject);
  private
    FPip      : TPyPip;
    FMetadata : TPyMetadata;

    procedure InitializePython;
    function  CreateWrappers: boolean;
    procedure EnableGUI(aValue: boolean);
    procedure ShowPackagesInfo;
    procedure RefreshPackages;
    procedure AddLogLine(const aMessage: string);
    procedure AddLogLines(const aMessage: string);
    procedure ParsePackagesList(const aList: string);
    procedure ShowPackageInfo(const aPackage: string);
    procedure GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);

  public

  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

// This is a simple demo used to test TPyPip and TPyMetadata.
// It's *NOT* optimized and all the code runs in the main application thread
// which causes app freezes. If you use these classes consider moving all the
// code to a background thread.

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if assigned(FPip) then
    FreeAndNil(FPip);

  DestroyGlobalP4PEngine;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  FPip := nil;

  PackagesSg.Cells[0, 0] := 'Name';
  PackagesSg.Cells[1, 0] := 'Version';
  PackagesSg.Cells[2, 0] := 'Status';

  InitializePython;
end;

procedure TMainForm.CheckBtnClick(Sender: TObject);
var
  returncode: integer;
  stdout, stderr: string;
begin
  if assigned(FPip) and
     FPip.Check(returncode, stdout, stderr) then
    AddLogLines(stdout)
   else
    AddLogLines(stderr);
end;

function TMainForm.CreateWrappers: boolean;
begin
  FPip            := TPyPip.Create;
  FPip.Executable := GlobalP4PEngine.OSPythonExePath;

  FMetadata := TPyMetadata.Create;

  Result := FPip.Initialized and FMetadata.Initialized;
end;

procedure TMainForm.EnableGUI(aValue: boolean);
begin
  PackagesSg.Enabled := aValue;
  PackagesTb.Enabled := aValue;
end;

procedure TMainForm.ShowPackagesInfo;
var
  i, TempLen : integer;
begin
  TempLen             := FMetadata.Distributions.Count;
  PackagesSg.RowCount := succ(TempLen);

  for i := 1 to TempLen do
    begin
      PackagesSg.cells[0, i] := FMetadata.Distributions.Name_[pred(i)];
      PackagesSg.cells[1, i] := FMetadata.Distributions.Version[pred(i)];
      PackagesSg.cells[2, i] := '';
    end;
end;

procedure TMainForm.RefreshBtnClick(Sender: TObject);
begin
  RefreshPackages;
end;

procedure TMainForm.PackagesPnlResize(Sender: TObject);
begin
  PackagesSg.DefaultColWidth := (PackagesSg.Width - 28) div PackagesSg.ColCount;
end;

procedure TMainForm.PackagesSgSelectCell(Sender: TObject; ACol, ARow: LongInt;
  var CanSelect: Boolean);
begin
  UpdatePackageBtn.Enabled := (ARow > 0) and (length(PackagesSg.cells[2, ARow]) > 0);
  if (ARow > 0) then
    ShowPackageInfo(PackagesSg.cells[0, ARow]);
end;

procedure TMainForm.ShowPackageInfo(const aPackage: string);
var
  returncode: integer;
  stdout, stderr: string;
  TempSL : TStringList;
begin
  InfoMem.Lines.Clear;

  if (length(aPackage) > 0) and
     assigned(FPip) and
     FPip.Show(aPackage, returncode, stdout, stderr) then
    begin
      TempSL      := TStringList.Create;
      TempSL.Text := stdout;
      InfoMem.lines.AddStrings(TempSL);
      TempSL.Free;
    end
   else
    AddLogLines(stderr);
end;

procedure TMainForm.ParsePackagesList(const aList: string);
var
  TempArray : TJSONArray;
  TempItem  : TJSONObject;
  TempName, TempLatest : string;
  i, TempIdx : integer;
begin
  TempArray := TJSONObject.ParseJSONValue(aList, False, False) as TJSONArray;

  if assigned(TempArray) then
    try
      for i := 0 to pred(TempArray.Count) do
        begin
          TempItem   := TempArray.Items[i] as TJSONObject;
          TempName   := TempItem.GetValue('name').ToString.DeQuotedString('"');
          TempLatest := TempItem.GetValue('latest_version').ToString.DeQuotedString('"');
          TempIdx    := FMetadata.Distributions.Search(TempName);
          if (TempIdx >= 0) then
            PackagesSg.cells[2, succ(TempIdx)] := TempLatest + ' - New version!' ;
        end;
    finally
      FreeAndNil(TempArray);
    end;
end;

procedure TMainForm.RefreshPackages;
var
  returncode: integer;
  stdout, stderr: string;
begin
  EnableGUI(False);
  try
    FMetadata.RefreshDistributions;
    ShowPackagesInfo;
    InstallPIPBtn.Enabled := not(FMetadata.HasPIP);

    if FPip.List(plf_json, True, returncode, stdout, stderr) then
      ParsePackagesList(stdout)
     else
      AddLogLines(stderr);
  finally
    EnableGUI(True);
  end;
end;

procedure TMainForm.InitializePython;
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

      //TempLibPath := TempDrive + ':\python-3.15.2-embed-' + TempBit + '\python315.dll';
      //TempLibPath := TempDrive + ':\python-3.14.8-embed-' + TempBit + '\python314.dll';
      //TempLibPath := TempDrive + ':\python-3.13.16-embed-' + TempBit + '\python313.dll';
      //TempLibPath := TempDrive + ':\python-3.12.10-embed-' + TempBit + '\python312.dll';
      //TempLibPath := TempDrive + ':\python-3.11.9-embed-' + TempBit + '\python311.dll';
      //TempLibPath := TempDrive + ':\python-3.10.11-embed-' + TempBit + '\python310.dll';
      //TempLibPath := TempDrive + ':\python-3.9.13-embed-' + TempBit + '\python39.dll';
      TempLibPath := '';

      // Load and initialize the Python library.
      if GlobalP4PEngine.Load(TempLibPath) and
         GlobalP4PEngine.Initialize then
        begin
          LogMem.Lines.Add('Python initialized. ' + GlobalP4PEngine.buildinfo);

          if CreateWrappers then
            RefreshPackages
           else
            AddLogLine('There was an error initializing the module wrappers!');
        end
       else
        begin
          AddLogLine('There was an error initializing Python!');
          AddLogLine(GlobalP4PEngine.LastErrorMessage);
        end;
    end;
end;

procedure TMainForm.AddLogLine(const aMessage: string);
begin
  if (length(aMessage) > 0) then
    LogMem.Lines.Add(aMessage);
end;

procedure TMainForm.AddLogLines(const aMessage: string);
var
  TempSL : TStringList;
begin
  if (length(aMessage) > 0) then
    begin
      TempSL      := TStringList.Create;
      TempSL.Text := aMessage;
      LogMem.lines.AddStrings(TempSL);
      TempSL.Free;
    end;
end;

procedure TMainForm.InstallPackageBtnClick(Sender: TObject);
var
  returncode: integer;
  TempPackage, stdout, stderr: string;
begin
  if not(assigned(FPip)) then exit;

  TempPackage := InputBox('Install a new package', 'Package name', '');

  if (length(TempPackage) > 0) and
     (FMetadata.Distributions.Search(TempPackage) < 0) then
    begin
      if FPip.Install(TempPackage, False, returncode, stdout, stderr) then
        RefreshPackages
       else
        AddLogLines(stderr);
    end;
end;

procedure TMainForm.InstallPIPBtnClick(Sender: TObject);
var
  returncode: integer;
  stdout, stderr: string;
begin
  if assigned(FPip) and
     FPip.Ensurepip(returncode, stdout, stderr) then
    RefreshPackages
   else
    AddLogLines(stderr);
end;

procedure TMainForm.UninstallPackageBtnClick(Sender: TObject);
var
  returncode: integer;
  TempPackage, stdout, stderr: string;
begin
  if not(assigned(FPip)) then exit;

  TempPackage := PackagesSg.cells[0, PackagesSg.Selection.Top];

  if (length(TempPackage) > 0) then
    begin
      if FPip.Uninstall(TempPackage, returncode, stdout, stderr) then
        RefreshPackages
       else
        AddLogLines(stderr);
    end;
end;

procedure TMainForm.UpdatePackageBtnClick(Sender: TObject);
var
  returncode: integer;
  TempPackage, stdout, stderr: string;
begin
  if not(assigned(FPip)) then exit;

  TempPackage := PackagesSg.cells[0, PackagesSg.Selection.Top];

  if (length(TempPackage) > 0) then
    begin
      if FPip.Install(TempPackage, True, returncode, stdout, stderr) then
        RefreshPackages
       else
        AddLogLines(stderr);
    end;
end;

procedure TMainForm.GlobalP4PEngine_OnOutputMessage(Sender: TObject; const message_: string);
begin
  AddLogLine(trim(message_));
end;

end.
