object MainForm: TMainForm
  Left = 0
  Top = 0
  BorderIcons = [biSystemMenu]
  BorderStyle = bsSingle
  Caption = 'PythonClassWrapper'
  ClientHeight = 715
  ClientWidth = 768
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
    Top = 389
    Width = 768
    Height = 3
    Cursor = crVSplit
    Align = alBottom
    ExplicitTop = 0
    ExplicitWidth = 312
  end
  object CodeMem: TMemo
    Left = 0
    Top = 34
    Width = 768
    Height = 355
    Align = alClient
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -12
    Font.Name = 'Consolas'
    Font.Style = []
    Lines.Strings = (
      'import datetime'
      ''
      'class MyClass:'
      '    x = 5'
      '    def boolean_test(self):'
      '        return True'
      '    def integer_test(self):'
      '        return 9'
      '    def float_test(self):'
      '        return 3.7'
      '    def string_test(self):'
      '        return "test result"'
      '    def tuple_test(self):'
      '        return (1, 2, 3)'
      '    def list_test(self):'
      '        return [1, 2, 3, 4, 5]'
      '    def datetime_test(self):'
      '        return datetime.datetime.now()'
      '    def square_test(self, number):'
      '        return number**2'
      '    def uppercase_test(self, mystring):'
      '        return mystring.upper()'
      '    def dict_test(self, key, value):'
      '        new_dict = dict()'
      '        new_dict[key] = value'
      '        return new_dict')
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
  end
  object LogMem: TMemo
    Left = 0
    Top = 392
    Width = 768
    Height = 323
    Align = alBottom
    ReadOnly = True
    ScrollBars = ssBoth
    TabOrder = 1
  end
  object ButtonPnl: TPanel
    Left = 0
    Top = 0
    Width = 768
    Height = 34
    Align = alTop
    BevelOuter = bvNone
    Enabled = False
    Padding.Left = 5
    Padding.Top = 5
    Padding.Right = 5
    Padding.Bottom = 5
    TabOrder = 2
    DesignSize = (
      768
      34)
    object RunBtn: TButton
      Left = 451
      Top = 5
      Width = 100
      Height = 24
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = '1. Run code'
      TabOrder = 0
      OnClick = RunBtnClick
    end
    object WrapClassBtn: TButton
      Left = 557
      Top = 5
      Width = 100
      Height = 24
      Anchors = [akLeft, akTop, akRight, akBottom]
      Caption = '2. Wrap MyClass'
      Enabled = False
      TabOrder = 1
      OnClick = WrapClassBtnClick
    end
    object TestMyClassBtn: TButton
      Left = 663
      Top = 5
      Width = 100
      Height = 24
      Align = alRight
      Caption = '3. Test MyClass'
      Enabled = False
      TabOrder = 2
      OnClick = TestMyClassBtnClick
    end
  end
end
