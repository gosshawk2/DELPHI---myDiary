object frmDatabaseOptions: TfrmDatabaseOptions
  Left = 500
  Top = 688
  Caption = 'frmDatabaseOptions'
  ClientHeight = 258
  ClientWidth = 451
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 451
    Height = 41
    Align = alTop
    Color = clTeal
    TabOrder = 0
    object Label1: TLabel
      Left = 152
      Top = 8
      Width = 139
      Height = 19
      Caption = 'Database Settings'
      Font.Charset = ANSI_CHARSET
      Font.Color = clNavy
      Font.Height = -16
      Font.Name = 'Arial'
      Font.Style = [fsBold]
      ParentFont = False
    end
  end
  object memOutput: TMemo
    Left = 0
    Top = 41
    Width = 451
    Height = 209
    Align = alTop
    ScrollBars = ssVertical
    TabOrder = 1
  end
end
