object frmOutput: TfrmOutput
  Left = 0
  Top = 0
  Caption = 'Output'
  ClientHeight = 300
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 49
    Align = alTop
    TabOrder = 0
    object btnClose: TButton
      Left = 536
      Top = 13
      Width = 75
      Height = 25
      Caption = 'Close'
      TabOrder = 0
      OnClick = btnCloseClick
    end
  end
  object pnlOutput: TPanel
    Left = 0
    Top = 49
    Width = 635
    Height = 243
    Align = alTop
    TabOrder = 1
    object memOutput: TMemo
      Left = 1
      Top = 1
      Width = 633
      Height = 240
      Align = alTop
      ScrollBars = ssVertical
      TabOrder = 0
    end
  end
end
