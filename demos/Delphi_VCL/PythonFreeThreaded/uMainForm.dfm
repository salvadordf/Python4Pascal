object MainForm: TMainForm
  Left = 0
  Top = 0
  Caption = 'Python free-threaded mode demo'
  ClientHeight = 475
  ClientWidth = 920
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Padding.Left = 5
  Padding.Top = 5
  Padding.Right = 5
  Padding.Bottom = 5
  Position = poScreenCenter
  OnClose = FormClose
  OnCreate = FormCreate
  OnShow = FormShow
  TextHeight = 15
  object MainPnl: TPanel
    Left = 5
    Top = 5
    Width = 910
    Height = 280
    Align = alClient
    BevelOuter = bvNone
    TabOrder = 0
    object BubbleSortPnl: TPanel
      Left = 0
      Top = 0
      Width = 300
      Height = 280
      Align = alLeft
      BevelOuter = bvNone
      TabOrder = 0
      object BubbleSortPb: TPaintBox
        Left = 0
        Top = 25
        Width = 300
        Height = 255
        Align = alClient
        OnPaint = BubbleSortPbPaint
        ExplicitLeft = -1
        ExplicitTop = 24
        ExplicitHeight = 406
      end
      object BubbleSortChk: TCheckBox
        Left = 0
        Top = 0
        Width = 300
        Height = 25
        Align = alTop
        Caption = 'Bubble Sort'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 0
      end
    end
    object QuickSortPnl: TPanel
      Left = 610
      Top = 0
      Width = 300
      Height = 280
      Align = alRight
      BevelOuter = bvNone
      TabOrder = 1
      object QuickSortPb: TPaintBox
        Tag = 2
        Left = 0
        Top = 25
        Width = 300
        Height = 255
        Align = alClient
        OnPaint = BubbleSortPbPaint
        ExplicitLeft = 48
        ExplicitTop = 208
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
      object QuickSortChk: TCheckBox
        Left = 0
        Top = 0
        Width = 300
        Height = 25
        Align = alTop
        Caption = 'Quick Sort'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 0
      end
    end
    object SelectionSortPnl: TPanel
      Left = 300
      Top = 0
      Width = 310
      Height = 280
      Align = alClient
      BevelOuter = bvNone
      Padding.Left = 5
      Padding.Right = 5
      TabOrder = 2
      object SelectionSortPb: TPaintBox
        Tag = 1
        Left = 5
        Top = 25
        Width = 300
        Height = 255
        Align = alClient
        OnPaint = BubbleSortPbPaint
        ExplicitLeft = 184
        ExplicitTop = 208
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
      object SelectionSortChk: TCheckBox
        Left = 5
        Top = 0
        Width = 300
        Height = 25
        Align = alTop
        Caption = 'Selection Sort'
        Checked = True
        Font.Charset = DEFAULT_CHARSET
        Font.Color = clWindowText
        Font.Height = -12
        Font.Name = 'Segoe UI'
        Font.Style = [fsBold]
        ParentFont = False
        State = cbChecked
        TabOrder = 0
      end
    end
  end
  object BottomPnl: TPanel
    Left = 5
    Top = 285
    Width = 910
    Height = 185
    Align = alBottom
    BevelOuter = bvNone
    Padding.Top = 5
    TabOrder = 1
    object LogMem: TMemo
      Left = 0
      Top = 5
      Width = 704
      Height = 180
      Align = alClient
      ReadOnly = True
      ScrollBars = ssVertical
      TabOrder = 0
    end
    object RunPnl: TPanel
      Left = 704
      Top = 5
      Width = 206
      Height = 180
      Align = alRight
      BevelOuter = bvNone
      Enabled = False
      Padding.Left = 5
      TabOrder = 1
      object RunBtn: TButton
        Left = 5
        Top = 0
        Width = 201
        Height = 25
        Align = alTop
        Caption = 'Run'
        TabOrder = 0
        OnClick = RunBtnClick
      end
      object ThreadRunModeRg: TRadioGroup
        Left = 5
        Top = 25
        Width = 201
        Height = 155
        Align = alClient
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
  end
  object Timer1: TTimer
    Enabled = False
    Interval = 50
    OnTimer = Timer1Timer
    Left = 501
    Top = 365
  end
end
