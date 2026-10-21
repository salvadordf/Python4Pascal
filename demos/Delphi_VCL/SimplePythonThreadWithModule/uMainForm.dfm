object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'MainForm'
  ClientHeight = 529
  ClientWidth = 729
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object Splitter1: TSplitter
    Left = 0
    Top = 237
    Width = 729
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 0
    ExplicitWidth = 312
  end
  object LogMem: TMemo
    Left = 0
    Top = 240
    Width = 729
    Height = 289
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object Panel1: TPanel
    Left = 480
    Top = 0
    Width = 249
    Height = 237
    Align = alRight
    BevelOuter = bvNone
    TabOrder = 1
    object RunBtn: TButton
      Left = 5
      Top = 5
      Width = 236
      Height = 25
      Caption = 'Run code'
      TabOrder = 0
      OnClick = RunBtnClick
    end
    object ThreadRunModeRg: TRadioGroup
      Left = 5
      Top = 39
      Width = 236
      Height = 138
      Caption = 'Thread run mode '
      ItemIndex = 3
      Items.Strings = (
        'Legacy API'
        'Shared Interpreter'
        'Subinterpreter with shared GIL'
        'Subinterpreter with own GIL')
      TabOrder = 1
    end
  end
  object CodeMem: TMemo
    Left = 0
    Top = 0
    Width = 480
    Height = 237
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      'import mytest'
      ''
      'print("Check if 42 is even...")'
      'print(mytest.is_even(42))'
      ''
      'print("Check if 45 is even...")'
      'print(mytest.is_even(45))'
      ''
      'obj = mytest.mytype()'
      'print(type(obj))'
      'print(isinstance(obj, mytest.mytype))'
      'print(obj.getid())'
      'print(repr(obj))')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 2
  end
end
