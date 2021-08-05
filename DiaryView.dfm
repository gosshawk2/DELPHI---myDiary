object frmDiaryView: TfrmDiaryView
  Left = 0
  Top = 0
  Caption = 'Diary View'
  ClientHeight = 689
  ClientWidth = 1007
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  OnCreate = FormCreate
  OnKeyDown = FormKeyDown
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 1007
    Height = 41
    Align = alTop
    Color = clMaroon
    ParentBackground = False
    TabOrder = 0
    object btnClose: TBitBtn
      Left = 890
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Close'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
      OnClick = btnCloseClick
    end
    object btnInsert: TBitBtn
      Left = 15
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Insert'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnInsertClick
    end
    object btnSave: TBitBtn
      Left = 215
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Save'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 2
      OnClick = btnSaveClick
    end
    object btnCancel: TBitBtn
      Left = 315
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Cancel'
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnCancelClick
    end
    object btnEdit: TBitBtn
      Left = 115
      Top = 8
      Width = 75
      Height = 25
      Caption = '&Edit'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnEditClick
    end
    object txtCurrentTime: TEdit
      Left = 725
      Top = 6
      Width = 121
      Height = 33
      Alignment = taCenter
      Color = clBlack
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 6
      Text = '00:00:00'
    end
    object txtCurrentDate: TEdit
      Left = 416
      Top = 8
      Width = 281
      Height = 25
      Color = clBlue
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 5
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 133
    Width = 1007
    Height = 556
    Align = alTop
    Alignment = taLeftJustify
    Color = 10485760
    ParentBackground = False
    TabOrder = 1
    DesignSize = (
      1007
      556)
    object lblBrief: TLabel
      Left = 16
      Top = 191
      Width = 39
      Height = 19
      Caption = 'Brief:'
      Color = clNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Label1: TLabel
      Left = 16
      Top = 235
      Width = 48
      Height = 19
      Caption = 'Detail:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblIncludePrivate: TLabel
      Left = 16
      Top = 427
      Width = 148
      Height = 19
      Caption = 'Show Private Entry?'
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblTotalRecords: TLabel
      Left = 16
      Top = 137
      Width = 42
      Height = 19
      Caption = 'Total:'
      Color = clNone
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object txtRecNumber: TEdit
      Left = 15
      Top = 162
      Width = 49
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = '0'
    end
    object txtBrief: TEdit
      Left = 84
      Top = 188
      Width = 490
      Height = 23
      Color = clCream
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object memDetail: TMemo
      Left = 84
      Top = 236
      Width = 908
      Height = 185
      Anchors = [akLeft, akTop, akRight]
      Color = 13487565
      ScrollBars = ssVertical
      TabOrder = 2
    end
    object cbPrivateEntry: TCheckBox
      Left = 187
      Top = 427
      Width = 24
      Height = 17
      TabOrder = 3
      OnClick = cbPrivateEntryClick
    end
    object memPrivate: TMemo
      Left = 84
      Top = 451
      Width = 908
      Height = 96
      Anchors = [akLeft, akTop, akRight]
      Color = clMoneyGreen
      ScrollBars = ssVertical
      TabOrder = 4
      Visible = False
    end
    object btnShowDiaryEntries: TBitBtn
      Left = 615
      Top = 177
      Width = 222
      Height = 25
      Caption = 'Show Diary Entries - Popup'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Visible = False
      OnClick = btnShowDiaryEntriesClick
    end
    object btnInsertDateAndTime: TBitBtn
      Left = 83
      Top = 164
      Width = 128
      Height = 25
      Caption = 'Insert Date and Time'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clFuchsia
      Font.Height = -13
      Font.Name = 'Tahoma'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      OnClick = btnInsertDateAndTimeClick
    end
    object btnShowDiaryEntriesEmbedded: TBitBtn
      Left = 615
      Top = 208
      Width = 222
      Height = 25
      Caption = 'Show Diary Entries - Embed'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      Visible = False
      OnClick = btnShowDiaryEntriesEmbeddedClick
    end
    object DBDailyGrid: TDBGrid
      Left = 1
      Top = 1
      Width = 1005
      Height = 129
      Align = alTop
      Anchors = [akLeft, akTop, akRight, akBottom]
      DataSource = dsDBGrid
      GradientEndColor = clGreen
      Options = [dgTitles, dgIndicator, dgColumnResize, dgColLines, dgRowLines, dgTabs, dgRowSelect, dgConfirmDelete, dgCancelOnExit, dgTitleClick, dgTitleHotTrack]
      TabOrder = 8
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
      OnCellClick = DBDailyGridCellClick
    end
    object txtPrivateEntry: TEdit
      Left = 212
      Top = 424
      Width = 53
      Height = 23
      Color = clCream
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
    end
  end
  object pnlControls: TPanel
    Left = 0
    Top = 41
    Width = 1007
    Height = 92
    Align = alTop
    Color = clSkyBlue
    ParentBackground = False
    TabOrder = 2
    object lblDate: TLabel
      Left = 16
      Top = 6
      Width = 36
      Height = 19
      Caption = 'Date:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
    end
    object pnlNavigation: TPanel
      Left = 652
      Top = 2
      Width = 340
      Height = 80
      BevelInner = bvLowered
      TabOrder = 7
      object rgSkip: TRadioGroup
        Left = 4
        Top = 1
        Width = 332
        Height = 48
        Caption = 'Interval'
        Columns = 4
        Font.Charset = ANSI_CHARSET
        Font.Color = clGreen
        Font.Height = -13
        Font.Name = 'Cambria'
        Font.Style = [fsBold]
        ItemIndex = 0
        Items.Strings = (
          'Daily'
          'Weekly'
          'Monthly'
          'Yearly')
        ParentFont = False
        TabOrder = 4
      end
      object btnLast: TBitBtn
        Left = 8
        Top = 52
        Width = 60
        Height = 25
        Caption = '<<'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Cambria'
        Font.Style = []
        ParentFont = False
        TabOrder = 1
        OnClick = btnLastClick
      end
      object btnNext: TBitBtn
        Left = 198
        Top = 52
        Width = 60
        Height = 25
        Caption = '>'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Cambria'
        Font.Style = []
        ParentFont = False
        TabOrder = 2
        OnClick = btnNextClick
      end
      object btnPrevious: TBitBtn
        Left = 78
        Top = 52
        Width = 60
        Height = 25
        Caption = '<'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Cambria'
        Font.Style = []
        ParentFont = False
        TabOrder = 3
        OnClick = btnPreviousClick
      end
      object btnFirst: TBitBtn
        Left = 268
        Top = 52
        Width = 60
        Height = 25
        Caption = '>>'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Cambria'
        Font.Style = []
        ParentFont = False
        TabOrder = 0
        OnClick = btnFirstClick
      end
      object btnTODAY: TBitBtn
        Left = 141
        Top = 52
        Width = 55
        Height = 25
        Caption = 'Today!'
        Font.Charset = ANSI_CHARSET
        Font.Color = clBlue
        Font.Height = -16
        Font.Name = 'Cambria'
        Font.Style = []
        ParentFont = False
        TabOrder = 5
        OnClick = btnTODAYClick
      end
    end
    object btnSearch: TBitBtn
      Left = 15
      Top = 36
      Width = 83
      Height = 25
      Caption = 'Search:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnSearchClick
    end
    object txtSearch: TEdit
      Left = 102
      Top = 36
      Width = 215
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
    end
    object DateTimePicker1: TDateTimePicker
      Left = 356
      Top = 6
      Width = 17
      Height = 21
      Date = 42502.000000000000000000
      Time = 0.156347141200967600
      TabOrder = 2
      OnChange = DateTimePicker1Change
    end
    object txtDate: TEdit
      Left = 113
      Top = 3
      Width = 240
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object txtDayOfWeek: TEdit
      Left = 57
      Top = 3
      Width = 50
      Height = 30
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 4
    end
    object comSearchFields: TComboBox
      Left = 349
      Top = 36
      Width = 100
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
      Text = 'Select Search'
      OnChange = comSearchFieldsChange
    end
    object txtTime: TEdit
      Left = 377
      Top = 3
      Width = 72
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
    end
    object btnClearSearch: TBitBtn
      Left = 316
      Top = 35
      Width = 26
      Height = 25
      Hint = 'Clear Search'
      Caption = 'X'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -21
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnClick = btnClearSearchClick
    end
    object btnSetTime: TBitBtn
      Left = 455
      Top = 4
      Width = 134
      Height = 25
      Hint = 'Clear Search'
      Caption = 'Set Time (CTRL+T)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      OnClick = btnSetTimeClick
    end
  end
  object txtTotalRecords: TEdit
    Left = 83
    Top = 268
    Width = 128
    Height = 23
    Color = clCream
    Font.Charset = ANSI_CHARSET
    Font.Color = clBlack
    Font.Height = -13
    Font.Name = 'Cambria'
    Font.Style = []
    ParentFont = False
    TabOrder = 3
  end
  object Timer1: TTimer
    OnTimer = Timer1Timer
    Left = 856
    Top = 8
  end
  object dsDBGrid: TDataSource
    Left = 528
    Top = 77
  end
end
