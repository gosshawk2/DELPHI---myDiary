object frmReceiveMessage: TfrmReceiveMessage
  Left = 0
  Top = 0
  Caption = 'Message From'
  ClientHeight = 243
  ClientWidth = 527
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIForm
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 527
    Height = 41
    Align = alTop
    TabOrder = 0
    ExplicitLeft = -89
    ExplicitWidth = 616
    object lblTitle: TLabel
      Left = 198
      Top = 7
      Width = 79
      Height = 22
      Caption = 'Message:'
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
    end
    object btnCancel: TBitBtn
      Left = 8
      Top = 8
      Width = 57
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
    end
    object btnReply: TBitBtn
      Left = 88
      Top = 8
      Width = 88
      Height = 25
      Caption = 'Reply'
      Default = True
      Font.Charset = ANSI_CHARSET
      Font.Color = clGreen
      Font.Height = -15
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 2
      OnClick = btnReplyClick
    end
  end
  object pnlButtons: TPanel
    Left = 0
    Top = 41
    Width = 527
    Height = 41
    Align = alTop
    TabOrder = 1
    ExplicitLeft = -89
    ExplicitWidth = 616
    object Label1: TLabel
      Left = 8
      Top = 6
      Width = 43
      Height = 19
      Caption = 'From:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object txtFirstname: TEdit
      Left = 87
      Top = 6
      Width = 121
      Height = 21
      TabOrder = 0
    end
    object txtLastname: TEdit
      Left = 231
      Top = 6
      Width = 121
      Height = 21
      TabOrder = 1
    end
  end
  object pnlMessage: TPanel
    Left = 0
    Top = 82
    Width = 527
    Height = 153
    Align = alTop
    TabOrder = 2
    ExplicitLeft = -89
    ExplicitWidth = 616
    object lblSubject: TLabel
      Left = 8
      Top = 6
      Width = 58
      Height = 19
      Caption = 'Subject:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object lblMessage: TLabel
      Left = 8
      Top = 31
      Width = 65
      Height = 19
      Caption = 'Message:'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Cambria'
      Font.Style = [fsBold]
      ParentFont = False
    end
    object txtSubject: TEdit
      Left = 72
      Top = 6
      Width = 393
      Height = 21
      TabOrder = 0
    end
    object memMessage: TMemo
      Left = 72
      Top = 33
      Width = 393
      Height = 89
      ScrollBars = ssVertical
      TabOrder = 1
    end
  end
end
