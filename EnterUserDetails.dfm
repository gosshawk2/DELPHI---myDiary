object frmUserDetails: TfrmUserDetails
  Left = 0
  Top = 0
  Caption = 'Enter User Details'
  ClientHeight = 398
  ClientWidth = 684
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
    Width = 684
    Height = 41
    Align = alTop
    TabOrder = 0
    object lblTitle: TLabel
      Left = 238
      Top = 9
      Width = 135
      Height = 22
      Caption = 'Account Details'
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
    Width = 684
    Height = 41
    Align = alTop
    TabOrder = 1
    object btnSave: TBitBtn
      Left = 232
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
      OnClick = btnCancelClick
    end
  end
  object PageControl_Users: TPageControl
    Left = 0
    Top = 82
    Width = 684
    Height = 311
    ActivePage = tabPersonalDetails
    Align = alTop
    Images = MainForm.ImageList1
    MultiLine = True
    OwnerDraw = True
    TabOrder = 2
    object tabPersonalDetails: TTabSheet
      Caption = 'Personal Details'
      ImageIndex = 2
      object pnlPersonalDetails: TPanel
        Left = 0
        Top = 0
        Width = 676
        Height = 282
        Align = alClient
        Color = 8728863
        ParentBackground = False
        TabOrder = 0
        object lblFirstname: TLabel
          Left = 72
          Top = 32
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
          Left = 72
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
        object lblDateAdded: TLabel
          Left = 72
          Top = 8
          Width = 76
          Height = 17
          Caption = 'Date Added:'
          Color = 8454143
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -15
          Font.Name = 'Cambria'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object lblGender: TLabel
          Left = 72
          Top = 80
          Width = 91
          Height = 17
          Caption = 'Male / Female:'
          Color = clNavy
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -15
          Font.Name = 'Cambria'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object lblDOB: TLabel
          Left = 72
          Top = 104
          Width = 86
          Height = 17
          Caption = 'Date Of Birth:'
          Color = clNavy
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -15
          Font.Name = 'Cambria'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          Visible = False
        end
        object lblNickname: TLabel
          Left = 72
          Top = 128
          Width = 67
          Height = 17
          Caption = 'Nickname:'
          Color = clNavy
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -15
          Font.Name = 'Cambria'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object lblUsername: TLabel
          Left = 72
          Top = 152
          Width = 94
          Height = 17
          Caption = 'DB User Name:'
          Color = clNavy
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -15
          Font.Name = 'Cambria'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object lblPassword: TLabel
          Left = 72
          Top = 176
          Width = 66
          Height = 17
          Caption = 'Password:'
          Color = clNavy
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -15
          Font.Name = 'Cambria'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object lblConfirmPassword: TLabel
          Left = 72
          Top = 200
          Width = 120
          Height = 17
          Caption = 'Confirm Password:'
          Color = clNavy
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -15
          Font.Name = 'Cambria'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object lblemailaddress: TLabel
          Left = 72
          Top = 224
          Width = 91
          Height = 17
          Caption = 'email Address:'
          Color = clNavy
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -15
          Font.Name = 'Cambria'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object lblContactNumber: TLabel
          Left = 72
          Top = 248
          Width = 106
          Height = 17
          Caption = 'Contact Number:'
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
          Left = 234
          Top = 32
          Width = 161
          Height = 21
          TabOrder = 2
        end
        object txtLastname: TEdit
          Left = 234
          Top = 56
          Width = 161
          Height = 21
          TabOrder = 3
        end
        object txtDateAdded: TEdit
          Left = 234
          Top = 8
          Width = 161
          Height = 21
          TabOrder = 0
        end
        object dtDateAddedPicker: TDateTimePicker
          Left = 401
          Top = 8
          Width = 110
          Height = 23
          Date = 44410.000000000000000000
          Time = 0.000363726852810942
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -13
          Font.Name = 'Cambria'
          Font.Style = []
          ParentFont = False
          TabOrder = 1
          OnClick = dtDateAddedPickerClick
          OnChange = dtDateAddedPickerChange
        end
        object txtGender: TEdit
          Left = 234
          Top = 80
          Width = 106
          Height = 21
          TabOrder = 4
        end
        object rbFemale: TRadioButton
          Left = 464
          Top = 82
          Width = 64
          Height = 17
          Caption = 'Female'
          Color = clSkyBlue
          Font.Charset = ANSI_CHARSET
          Font.Color = clWhite
          Font.Height = -15
          Font.Name = 'Cambria'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 6
          OnClick = rbFemaleClick
        end
        object txtDOB: TEdit
          Left = 234
          Top = 104
          Width = 161
          Height = 21
          TabOrder = 7
          Visible = False
        end
        object dtDOBPicker: TDateTimePicker
          Left = 401
          Top = 104
          Width = 88
          Height = 21
          Date = 41832.000000000000000000
          Time = 0.000363726852810942
          TabOrder = 8
          Visible = False
          OnClick = dtDOBPickerClick
          OnChange = dtDOBPickerChange
        end
        object txtNickname: TEdit
          Left = 234
          Top = 128
          Width = 161
          Height = 21
          TabOrder = 9
        end
        object rbMale: TRadioButton
          Left = 401
          Top = 82
          Width = 56
          Height = 17
          Caption = 'Male'
          Color = clYellow
          Font.Charset = ANSI_CHARSET
          Font.Color = clSilver
          Font.Height = -13
          Font.Name = 'Cambria'
          Font.Style = []
          ParentColor = False
          ParentFont = False
          TabOrder = 5
          OnClick = rbMaleClick
        end
        object txtUsername: TEdit
          Left = 234
          Top = 152
          Width = 161
          Height = 21
          TabOrder = 10
        end
        object txtPassword: TEdit
          Left = 234
          Top = 176
          Width = 161
          Height = 21
          TabOrder = 11
        end
        object txtConfirmPassword: TEdit
          Left = 234
          Top = 200
          Width = 161
          Height = 21
          TabOrder = 12
        end
        object txtEmailAddress: TEdit
          Left = 234
          Top = 224
          Width = 161
          Height = 21
          TabOrder = 13
        end
        object txtContactNumber: TEdit
          Left = 234
          Top = 248
          Width = 161
          Height = 21
          TabOrder = 14
        end
        object txtUserID: TEdit
          Left = 10
          Top = 8
          Width = 47
          Height = 21
          ReadOnly = True
          TabOrder = 15
        end
      end
    end
    object tabPermissions: TTabSheet
      Caption = 'Permissions'
      ImageIndex = 1
      object Panel1: TPanel
        Left = 0
        Top = 0
        Width = 676
        Height = 282
        Align = alClient
        Color = clGreen
        ParentBackground = False
        TabOrder = 0
        object Label3: TLabel
          Left = 72
          Top = 10
          Width = 74
          Height = 17
          Caption = 'Permission:'
          Color = clYellow
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Cambria'
          Font.Style = []
          ParentColor = False
          ParentFont = False
        end
        object txtPermission: TEdit
          Left = 152
          Top = 8
          Width = 243
          Height = 25
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Cambria'
          Font.Style = []
          ParentFont = False
          TabOrder = 0
        end
        object comPermissions: TComboBox
          Left = 401
          Top = 8
          Width = 200
          Height = 25
          Font.Charset = ANSI_CHARSET
          Font.Color = clBlack
          Font.Height = -15
          Font.Name = 'Cambria'
          Font.Style = [fsBold]
          ParentFont = False
          TabOrder = 1
          Text = 'Select Permission'
          OnChange = comPermissionsChange
          Items.Strings = (
            'SUPERUSER'
            'VIEW'
            'EDIT/SAVE')
        end
      end
    end
  end
end
