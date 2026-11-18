object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'PythonOpenCV'
  ClientHeight = 718
  ClientWidth = 825
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 0
    Top = 597
    Width = 825
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 0
    ExplicitWidth = 312
  end
  object Image1: TImage
    Left = 0
    Top = 201
    Width = 825
    Height = 396
    Align = alClient
    ExplicitLeft = 352
    ExplicitTop = 256
    ExplicitWidth = 105
    ExplicitHeight = 105
  end
  object CodeMem: TMemo
    Left = 0
    Top = 34
    Width = 825
    Height = 167
    Align = alTop
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      'import cv2'
      ''
      'class CameraTest:        '
      '    def snapshot(self, filepath):'
      '        cap = cv2.VideoCapture(0)'
      '        if (cap is not None) and (cap.isOpened()):'
      '            cap.set(cv2.CAP_PROP_FRAME_WIDTH, 800)'
      '            cap.set(cv2.CAP_PROP_FRAME_HEIGHT, 600)'
      '            ret, frame = cap.read()'
      '            cv2.imwrite(filepath, frame)'
      '            cap.release()'
      '            return True'
      '        else:'
      '            return False')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object LogMem: TMemo
    Left = 0
    Top = 600
    Width = 825
    Height = 118
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object ButtonPnl: TPanel
    Left = 0
    Top = 0
    Width = 825
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    Enabled = False
    Padding.Left = 5
    Padding.Top = 5
    Padding.Right = 5
    Padding.Bottom = 5
    TabOrder = 2
    object TestMyClassBtn: TButton
      Left = 608
      Top = 5
      Width = 212
      Height = 24
      Align = alRight
      Caption = 'Capture snapshot'
      TabOrder = 0
      OnClick = TestMyClassBtnClick
    end
  end
  object SaveDialog1: TSaveDialog
    DefaultExt = 'bmp'
    Filter = 'Bitmap images (*.bmp)|*.BMP'
    Title = 'Save snapshot as...'
    Left = 336
    Top = 248
  end
end
