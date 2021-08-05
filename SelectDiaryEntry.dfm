object frmSelectDiaryEntry: TfrmSelectDiaryEntry
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  Caption = 'Select Diary Entry'
  ClientHeight = 246
  ClientWidth = 599
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  GlassFrame.SheetOfGlass = True
  OldCreateOrder = False
  Visible = True
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object dbSelectGrid: TDBGrid
    Left = 0
    Top = 0
    Width = 599
    Height = 81
    Align = alTop
    Anchors = [akLeft, akTop, akRight, akBottom]
    Color = 16718362
    DataSource = dsGridSource
    Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -11
    TitleFont.Name = 'Tahoma'
    TitleFont.Style = []
    OnCellClick = dbSelectGridCellClick
    OnTitleClick = dbSelectGridTitleClick
  end
  object pnlTop: TPanel
    Left = 0
    Top = 81
    Width = 599
    Height = 41
    Align = alTop
    Color = clBlue
    ParentBackground = False
    TabOrder = 1
    object btnClose: TBitBtn
      Left = 213
      Top = 7
      Width = 146
      Height = 25
      Caption = 'Close'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object btnSelect: TBitBtn
      Left = 68
      Top = 7
      Width = 70
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
    object txtTotalRecords: TEdit
      Left = 16
      Top = 9
      Width = 46
      Height = 21
      TabOrder = 2
      Text = '0'
    end
  end
  object pnlDetails: TPanel
    Left = 0
    Top = 122
    Width = 599
    Height = 129
    Align = alTop
    Color = clGreen
    ParentBackground = False
    TabOrder = 2
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
  object dsGridSource: TDataSource
    Left = 8
    Top = 152
  end
end
