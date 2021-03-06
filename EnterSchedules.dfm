object frmEnterSchedules: TfrmEnterSchedules
  Left = 0
  Top = 0
  Caption = 'Schedule Entry'
  ClientHeight = 583
  ClientWidth = 562
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnClose = FormClose
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 562
    Height = 41
    Align = alTop
    TabOrder = 0
    object lblTitle: TLabel
      Left = 238
      Top = 9
      Width = 143
      Height = 22
      Caption = 'Schedule Details'
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -19
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object btnClose: TBitBtn
      Left = 440
      Top = 9
      Width = 75
      Height = 25
      Caption = 'Close'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 41
    Width = 562
    Height = 41
    Align = alTop
    TabOrder = 1
    object btnSave: TBitBtn
      Left = 234
      Top = 8
      Width = 113
      Height = 25
      Caption = 'Save'
      Default = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btnSaveClick
    end
    object btnCancel: TBitBtn
      Left = 64
      Top = 8
      Width = 113
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
    end
    object btnLastSchedule: TBitBtn
      Left = 440
      Top = 8
      Width = 113
      Height = 25
      Caption = 'Last Schedule'
      Default = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnSaveClick
    end
  end
  object pnlPersonalDetails: TPanel
    Left = 0
    Top = 80
    Width = 562
    Height = 479
    Align = alCustom
    Color = 8728863
    ParentBackground = False
    TabOrder = 2
    object lblFirstname: TLabel
      Left = 52
      Top = 33
      Width = 67
      Height = 17
      Caption = 'Firstname:'
      Color = clNavy
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblLastname: TLabel
      Left = 52
      Top = 56
      Width = 64
      Height = 17
      Caption = 'Lastname:'
      Color = clNavy
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblComputerName: TLabel
      Left = 52
      Top = 8
      Width = 102
      Height = 17
      Caption = 'ComputerName:'
      Color = clNavy
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblSessionName: TLabel
      Left = 52
      Top = 80
      Width = 99
      Height = 17
      Caption = 'Schedule Name:'
      Color = clNavy
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblComments: TLabel
      Left = 53
      Top = 266
      Width = 70
      Height = 17
      Caption = 'Comments:'
      Color = clNavy
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblGameStartDate: TLabel
      Left = 52
      Top = 138
      Width = 66
      Height = 17
      Caption = 'Start Date:'
      Color = clNavy
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblGameStartColon: TLabel
      Left = 382
      Top = 126
      Width = 8
      Height = 34
      Caption = ':'
      Color = clNavy
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -29
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object lblGameStartDateSeparator1: TLabel
      Left = 256
      Top = 128
      Width = 15
      Height = 34
      Caption = '/'
      Color = clNavy
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -29
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object lblGameStartDateSeparator2: TLabel
      Left = 291
      Top = 128
      Width = 15
      Height = 34
      Caption = '/'
      Color = clNavy
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -29
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object lblGameEndDate: TLabel
      Left = 52
      Top = 176
      Width = 61
      Height = 17
      Caption = 'End Date:'
      Color = clNavy
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object lblGameEndDateSeparator2: TLabel
      Left = 291
      Top = 169
      Width = 15
      Height = 34
      Caption = '/'
      Color = clNavy
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -29
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object lblGameEndColon: TLabel
      Left = 382
      Top = 167
      Width = 8
      Height = 34
      Caption = ':'
      Color = clNavy
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -29
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object lblGameEndDateSeparator1: TLabel
      Left = 256
      Top = 169
      Width = 15
      Height = 34
      Caption = '/'
      Color = clNavy
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -29
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentColor = False
      ParentFont = False
    end
    object Label1: TLabel
      Left = 52
      Top = 217
      Width = 73
      Height = 17
      Caption = 'Set Alarm ?:'
      Color = clNavy
      Font.Charset = ANSI_CHARSET
      Font.Color = clSilver
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = []
      ParentColor = False
      ParentFont = False
    end
    object txtFirstname: TEdit
      Left = 288
      Top = 32
      Width = 117
      Height = 21
      TabOrder = 2
      OnClick = txtFirstnameClick
    end
    object txtLastname: TEdit
      Left = 234
      Top = 56
      Width = 171
      Height = 21
      TabOrder = 4
      OnClick = txtLastnameClick
    end
    object txtComputerName: TEdit
      Left = 234
      Top = 8
      Width = 171
      Height = 21
      TabOrder = 0
    end
    object txtScheduleName: TEdit
      Left = 234
      Top = 80
      Width = 171
      Height = 20
      Color = clMoneyGreen
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -11
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 5
    end
    object comNicknames: TComboBox
      Left = 433
      Top = 31
      Width = 113
      Height = 23
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -13
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 3
      OnClick = comNicknamesClick
      OnEnter = comNicknamesEnter
    end
    object memComments: TMemo
      Left = 53
      Top = 289
      Width = 468
      Height = 191
      ScrollBars = ssBoth
      TabOrder = 7
    end
    object txtNameID: TEdit
      Left = 234
      Top = 32
      Width = 48
      Height = 21
      TabOrder = 1
      OnClick = txtNameIDClick
    end
    object txtStartDay: TEdit
      Left = 234
      Top = 135
      Width = 23
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 6
      Text = '01'
    end
    object txtStartHour: TEdit
      Left = 358
      Top = 135
      Width = 24
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 8
      Text = '00'
    end
    object dtStartPicker: TDateTimePicker
      Left = 433
      Top = 136
      Width = 88
      Height = 21
      Date = 41832.000000000000000000
      Time = 0.000363726852810942
      TabOrder = 9
      OnChange = dtStartPickerChange
    end
    object txtStartMinute: TEdit
      Left = 391
      Top = 135
      Width = 24
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 10
      Text = '00'
    end
    object txtStartMonth: TEdit
      Left = 270
      Top = 135
      Width = 23
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 11
      Text = '01'
    end
    object txtStartYear: TEdit
      Left = 307
      Top = 135
      Width = 43
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 12
      Text = '9999'
    end
    object txtEndDay: TEdit
      Left = 234
      Top = 176
      Width = 23
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 13
      Text = '01'
    end
    object txtEndMonth: TEdit
      Left = 270
      Top = 176
      Width = 23
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 14
      Text = '01'
    end
    object txtEndYear: TEdit
      Left = 307
      Top = 176
      Width = 43
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 15
      Text = '9999'
    end
    object txtEndHour: TEdit
      Left = 358
      Top = 176
      Width = 24
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 16
      Text = '00'
    end
    object txtEndMinute: TEdit
      Left = 391
      Top = 176
      Width = 24
      Height = 27
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlack
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = []
      ParentFont = False
      TabOrder = 17
      Text = '00'
    end
    object dtEndPicker: TDateTimePicker
      Left = 433
      Top = 176
      Width = 88
      Height = 21
      Date = 41832.000000000000000000
      Time = 0.000363726852810942
      TabOrder = 18
      OnChange = dtEndPickerChange
    end
    object cbAlarm: TCheckBox
      Left = 234
      Top = 219
      Width = 23
      Height = 17
      TabOrder = 19
    end
  end
  object rbHourly: TRadioButton
    Left = 270
    Top = 299
    Width = 56
    Height = 17
    Caption = 'Hourly'
    TabOrder = 3
  end
  object rbDaily: TRadioButton
    Left = 332
    Top = 299
    Width = 56
    Height = 17
    Caption = 'Daily'
    TabOrder = 4
  end
  object rbWeekly: TRadioButton
    Left = 398
    Top = 299
    Width = 56
    Height = 17
    Caption = 'Weekly'
    TabOrder = 5
  end
  object rbMonthly: TRadioButton
    Left = 270
    Top = 322
    Width = 56
    Height = 17
    Caption = 'Monthly'
    TabOrder = 6
  end
  object rbYearly: TRadioButton
    Left = 332
    Top = 322
    Width = 56
    Height = 17
    BiDiMode = bdRightToLeft
    Caption = 'Yearly'
    ParentBiDiMode = False
    TabOrder = 7
  end
end
