object frmDiaryEntry: TfrmDiaryEntry
  Left = 0
  Top = 0
  Caption = 'Diary Entry'
  ClientHeight = 603
  ClientWidth = 601
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
  OnKeyUp = FormKeyUp
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 601
    Height = 41
    Align = alTop
    Color = clMaroon
    ParentBackground = False
    TabOrder = 0
    object btnClose: TBitBtn
      Left = 507
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
      TabOrder = 2
      OnClick = btnCloseClick
    end
    object btnSave: TBitBtn
      Left = 8
      Top = 8
      Width = 120
      Height = 25
      Caption = 'Save'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      OnClick = btnSaveClick
    end
    object btnCancel: TBitBtn
      Left = 147
      Top = 8
      Width = 75
      Height = 25
      Caption = 'Cancel'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      OnClick = btnCancelClick
    end
    object btnNOW: TBitBtn
      Left = 241
      Top = 8
      Width = 104
      Height = 25
      Caption = 'NOW'
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = btnNOWClick
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 41
    Width = 601
    Height = 554
    Align = alTop
    TabOrder = 1
    object lblRecNumber: TLabel
      Left = 16
      Top = 16
      Width = 10
      Height = 19
      Caption = '#'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblDay: TLabel
      Left = 97
      Top = 16
      Width = 31
      Height = 19
      Caption = 'Day:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
    end
    object lblDate: TLabel
      Left = 217
      Top = 16
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
    object lblBrief: TLabel
      Left = 16
      Top = 99
      Width = 39
      Height = 19
      Caption = 'Brief:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object Label1: TLabel
      Left = 16
      Top = 142
      Width = 48
      Height = 19
      Caption = 'Detail:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblIncludePrivate: TLabel
      Left = 16
      Top = 335
      Width = 165
      Height = 19
      Caption = 'Include Private Entry?'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object txtRecNumber: TEdit
      Left = 32
      Top = 13
      Width = 49
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
      Text = 'txtRecNumber'
    end
    object txtDayOfWeek: TEdit
      Left = 134
      Top = 13
      Width = 77
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 1
      Text = 'txtRecNumber'
    end
    object txtDate: TEdit
      Left = 259
      Top = 13
      Width = 230
      Height = 27
      Color = clBlue
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
    end
    object txtBrief: TEdit
      Left = 84
      Top = 96
      Width = 498
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -13
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
    end
    object memDetail: TMemo
      Left = 84
      Top = 144
      Width = 498
      Height = 185
      ScrollBars = ssVertical
      TabOrder = 4
    end
    object cbPrivateEntry: TCheckBox
      Left = 187
      Top = 337
      Width = 24
      Height = 17
      TabOrder = 5
      OnClick = cbPrivateEntryClick
    end
    object memPrivate: TMemo
      Left = 84
      Top = 360
      Width = 498
      Height = 185
      ScrollBars = ssVertical
      TabOrder = 6
      Visible = False
    end
    object txtTime: TEdit
      Left = 505
      Top = 13
      Width = 77
      Height = 27
      Alignment = taCenter
      Color = clBlack
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 7
      Text = '00:00:00'
    end
    object btnInsertDateAndTime: TBitBtn
      Left = 84
      Top = 65
      Width = 138
      Height = 25
      Caption = '&Insert Date And Time'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -13
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      OnClick = btnInsertDateAndTimeClick
    end
    object txtMessage: TEdit
      Left = 228
      Top = 63
      Width = 341
      Height = 25
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 9
      Text = 'Press ctrl+S to save or ctrl+C to close, ctrl+I to insert.'
    end
  end
end
