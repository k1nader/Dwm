object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 299
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 33
    Align = alTop
    BevelOuter = bvNone
    TabOrder = 0
    OnDblClick = Panel1DblClick
    OnMouseDown = Panel1MouseDown
    object Button1: TButton
      Left = 478
      Top = 9
      Width = 75
      Height = 25
      Align = alCustom
      Anchors = [akTop, akRight]
      Caption = 'Maximized'
      TabOrder = 0
      OnClick = Button1Click
    end
    object Button2: TButton
      Left = 553
      Top = 9
      Width = 75
      Height = 25
      Align = alCustom
      Anchors = [akTop, akRight]
      Caption = 'Close'
      TabOrder = 1
      OnClick = Button2Click
    end
    object Button3: TButton
      Left = 403
      Top = 9
      Width = 75
      Height = 25
      Align = alCustom
      Anchors = [akTop, akRight]
      Caption = 'Minimized'
      TabOrder = 2
      OnClick = Button3Click
    end
  end
  object DwmNoBorderForm1: TDwmNoBorderForm
    Left = 184
    Top = 160
  end
end