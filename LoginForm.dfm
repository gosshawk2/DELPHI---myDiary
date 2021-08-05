object frmLogin: TfrmLogin
  Left = 673
  Top = 303
  Caption = 'Login'
  ClientHeight = 262
  ClientWidth = 344
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poMainFormCenter
  Visible = True
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 344
    Height = 41
    Align = alTop
    TabOrder = 0
    object lblTitle: TLabel
      Left = 96
      Top = 8
      Width = 158
      Height = 24
      Caption = 'Database Login'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -21
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object pnlMain: TPanel
    Left = 0
    Top = 41
    Width = 344
    Height = 160
    Align = alTop
    TabOrder = 1
    object lblHostname: TLabel
      Left = 8
      Top = 8
      Width = 34
      Height = 17
      Caption = 'Host:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblDatabase: TLabel
      Left = 8
      Top = 38
      Width = 67
      Height = 17
      Caption = 'Database:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblPassword: TLabel
      Left = 8
      Top = 130
      Width = 70
      Height = 17
      Caption = 'Password:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblUsername: TLabel
      Left = 8
      Top = 100
      Width = 72
      Height = 17
      Caption = 'Username:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object lblPort: TLabel
      Left = 8
      Top = 68
      Width = 31
      Height = 17
      Caption = 'Port:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -15
      Font.Name = 'Arial'
      Font.Style = []
      ParentFont = False
    end
    object txtHostname: TEdit
      Left = 104
      Top = 8
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object txtDatabase: TEdit
      Left = 104
      Top = 38
      Width = 121
      Height = 21
      TabOrder = 1
    end
    object txtPassword: TEdit
      Left = 104
      Top = 130
      Width = 121
      Height = 21
      PasswordChar = '*'
      TabOrder = 4
    end
    object txtUsername: TEdit
      Left = 104
      Top = 100
      Width = 121
      Height = 21
      TabOrder = 3
    end
    object txtPort: TEdit
      Left = 104
      Top = 68
      Width = 121
      Height = 21
      TabOrder = 2
      Text = '3306'
    end
    object comHostname: TComboBox
      Left = 232
      Top = 8
      Width = 105
      Height = 21
      TabOrder = 5
      OnClick = comHostnameClick
    end
    object comDatabase: TComboBox
      Left = 232
      Top = 38
      Width = 105
      Height = 21
      TabOrder = 6
      OnClick = comDatabaseClick
    end
    object comPort: TComboBox
      Left = 232
      Top = 68
      Width = 105
      Height = 21
      TabOrder = 7
      OnClick = comPortClick
    end
    object comUsername: TComboBox
      Left = 232
      Top = 100
      Width = 105
      Height = 21
      TabOrder = 8
      OnClick = comUsernameClick
    end
  end
  object pnlBottom: TPanel
    Left = 0
    Top = 201
    Width = 344
    Height = 56
    Align = alTop
    TabOrder = 2
    object btnLogin: TBitBtn
      Left = 164
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Login'
      Default = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      TabOrder = 1
      OnClick = btnLoginClick
    end
    object btnCancel: TBitBtn
      Left = 32
      Top = 16
      Width = 113
      Height = 25
      Caption = 'Cancel'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ModalResult = 2
      ParentFont = False
      TabOrder = 0
      OnClick = btnCancelClick
    end
    object btnSave: TBitBtn
      Left = 257
      Top = 16
      Width = 75
      Height = 25
      Caption = 'Save'
      Default = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ModalResult = 1
      ParentFont = False
      TabOrder = 2
      OnClick = btnSaveClick
    end
  end
end
