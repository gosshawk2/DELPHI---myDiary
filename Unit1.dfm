object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 372
  ClientWidth = 600
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object dbSelectGrid: TDBGrid
    Left = 0
    Top = 0
    Width = 600
    Height = 151
    Align = alTop
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
  end
  object pnlTop: TPanel
    Left = 0
    Top = 151
    Width = 600
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitTop = 191
    object btnClose: TBitBtn
      Left = 384
      Top = 6
      Width = 185
      Height = 25
      Caption = 'Close'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object btnSelect: TBitBtn
      Left = 128
      Top = 6
      Width = 185
      Height = 25
      Caption = 'Select'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -13
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnSelectClick
    end
  end
  object pnlDetails: TPanel
    Left = 0
    Top = 192
    Width = 600
    Height = 129
    Align = alTop
    TabOrder = 2
    ExplicitLeft = -8
    ExplicitTop = 188
    object lblBrief: TLabel
      Left = 16
      Top = 6
      Width = 30
      Height = 15
      Caption = 'Brief:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
    end
    object lblDate: TLabel
      Left = 16
      Top = 50
      Width = 28
      Height = 15
      Caption = 'Date:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
    end
    object lblPrivateEntry: TLabel
      Left = 16
      Top = 80
      Width = 77
      Height = 15
      Caption = 'Private Entry?'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      OnClick = lblPrivateEntryClick
    end
    object txtBrief: TEdit
      Left = 128
      Top = 6
      Width = 441
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object txtDate: TEdit
      Left = 128
      Top = 42
      Width = 152
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object txtTime: TEdit
      Left = 293
      Top = 42
      Width = 66
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
    end
    object txtPrivateEntry: TEdit
      Left = 128
      Top = 77
      Width = 57
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
  end
end