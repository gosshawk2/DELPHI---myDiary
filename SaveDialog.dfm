object frmSaveDialog: TfrmSaveDialog
  Left = 0
  Top = 0
  BorderStyle = bsDialog
  ClientHeight = 162
  ClientWidth = 284
  Color = clRed
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  FormStyle = fsMDIChild
  GlassFrame.Left = 5
  GlassFrame.Top = 5
  GlassFrame.Right = 5
  GlassFrame.Bottom = 5
  OldCreateOrder = False
  Visible = True
  PixelsPerInch = 96
  TextHeight = 13
  object pnlForm: TPanel
    Left = 0
    Top = 0
    Width = 284
    Height = 162
    Align = alClient
    Alignment = taLeftJustify
    Color = clRed
    Padding.Left = 1
    Padding.Top = 1
    Padding.Right = 1
    Padding.Bottom = 1
    ParentBackground = False
    TabOrder = 1
  end
  object pnlMain: TPanel
    Left = 11
    Top = 11
    Width = 269
    Height = 147
    Color = clMoneyGreen
    ParentBackground = False
    TabOrder = 0
    object txtMessage2: TEdit
      Left = 1
      Top = 30
      Width = 267
      Height = 29
      Align = alTop
      Alignment = taCenter
      BorderStyle = bsNone
      Color = clMoneyGreen
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -15
      Font.Name = 'Comic Sans MS'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      Text = 'What Do You Want To ?'
    end
    object txtMessage1: TEdit
      Left = 1
      Top = 1
      Width = 267
      Height = 29
      TabStop = False
      Align = alTop
      Alignment = taCenter
      BevelInner = bvNone
      BevelOuter = bvNone
      BorderStyle = bsNone
      Color = clMoneyGreen
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -15
      Font.Name = 'Comic Sans MS'
      Font.Style = [fsBold]
      ParentFont = False
      ReadOnly = True
      TabOrder = 1
      Text = 'Record Already Exists'
    end
    object btnInsert: TButton
      Left = 16
      Top = 65
      Width = 75
      Height = 25
      Caption = 'Insert'
      Default = True
      ModalResult = 6
      TabOrder = 2
      OnClick = btnInsertClick
    end
    object btnUpdate: TButton
      Left = 152
      Top = 65
      Width = 75
      Height = 25
      Caption = 'Update'
      ModalResult = 7
      TabOrder = 3
      OnClick = btnUpdateClick
    end
    object btnCancel: TButton
      Left = 88
      Top = 105
      Width = 75
      Height = 25
      Cancel = True
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 4
      OnClick = btnCancelClick
    end
  end
end
