object frmDBView: TfrmDBView
  Left = 404
  Top = 271
  Caption = 'View Records'
  ClientHeight = 282
  ClientWidth = 609
  Color = clBtnFace
  ParentFont = True
  FormStyle = fsMDIChild
  OldCreateOrder = False
  Position = poDefault
  Visible = True
  OnClose = FormClose
  OnResize = FormResize
  PixelsPerInch = 96
  TextHeight = 13
  object pnlTop: TPanel
    Left = 0
    Top = 0
    Width = 609
    Height = 41
    Align = alTop
    TabOrder = 0
    object btnClose: TBitBtn
      Left = 494
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Close'
      Font.Charset = ANSI_CHARSET
      Font.Color = clRed
      Font.Height = -13
      Font.Name = 'Times New Roman'
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 0
      OnClick = btnCloseClick
    end
    object comTables: TComboBox
      Left = 289
      Top = 11
      Width = 185
      Height = 21
      TabOrder = 1
      OnClick = comTablesClick
    end
    object btnConnect: TBitBtn
      Left = 104
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Connect'
      TabOrder = 2
      OnClick = btnConnectClick
    end
    object btnGetTables: TBitBtn
      Left = 200
      Top = 10
      Width = 75
      Height = 25
      Caption = 'Get Tables'
      TabOrder = 3
      OnClick = btnGetTablesClick
    end
  end
  object pnlGrid: TPanel
    Left = 0
    Top = 41
    Width = 609
    Height = 160
    Align = alTop
    TabOrder = 1
    object DBGrid1: TDBGrid
      Left = 5
      Top = 4
      Width = 564
      Height = 151
      DataSource = dsGrid
      TabOrder = 0
      TitleFont.Charset = DEFAULT_CHARSET
      TitleFont.Color = clWindowText
      TitleFont.Height = -11
      TitleFont.Name = 'Tahoma'
      TitleFont.Style = []
    end
  end
  object ADOConnection1: TADOConnection
    ConnectionString = 
      'Driver=MySQL ODBC 5.2 Unicode Driver;SERVER=db4free.net;UID=dgos' +
      's;DATABASE=energycalc;PORT=3306;'
    DefaultDatabase = 'energycalc'
    LoginPrompt = False
    Left = 186
    Top = 215
  end
  object qryData: TADOQuery
    Connection = ADOConnection1
    CursorType = ctStatic
    Parameters = <>
    SQL.Strings = (
      'SELECT * FROM x2_Factories'
      '')
    Left = 560
    Top = 214
  end
  object dsGrid: TDataSource
    DataSet = qryData
    Left = 328
    Top = 216
  end
  object ClientDataSet1: TClientDataSet
    Aggregates = <>
    Params = <>
    ProviderName = 'DataSetProvider1'
    Left = 400
    Top = 216
  end
  object DataSetProvider1: TDataSetProvider
    Left = 24
    Top = 216
  end
  object ADOTable1: TADOTable
    Connection = ADOConnection1
    Left = 480
    Top = 215
  end
  object SQLConnection1: TSQLConnection
    ConnectionName = 'MySQLConnection'
    DriverName = 'MySQL'
    GetDriverFunc = 'getSQLDriverMYSQL'
    LibraryName = 'dbxmys.dll'
    LoadParamsOnConnect = True
    LoginPrompt = False
    Params.Strings = (
      'DriverUnit=Data.DBXMySQL'
      
        'DriverPackageLoader=TDBXDynalinkDriverLoader,DbxCommonDriver160.' +
        'bpl'
      
        'DriverAssemblyLoader=Borland.Data.TDBXDynalinkDriverLoader,Borla' +
        'nd.Data.DbxCommonDriver,Version=16.0.0.0,Culture=neutral,PublicK' +
        'eyToken=91d62ebb5b0d1b1b'
      
        'MetaDataPackageLoader=TDBXMySqlMetaDataCommandFactory,DbxMySQLDr' +
        'iver160.bpl'
      
        'MetaDataAssemblyLoader=Borland.Data.TDBXMySqlMetaDataCommandFact' +
        'ory,Borland.Data.DbxMySQLDriver,Version=16.0.0.0,Culture=neutral' +
        ',PublicKeyToken=91d62ebb5b0d1b1b'
      'GetDriverFunc=getSQLDriverMYSQL'
      'LibraryName=dbxmys.dll'
      'LibraryNameOsx=libsqlmys.dylib'
      'VendorLib=LIBMYSQL.dll'
      'VendorLibWin64=libmysql.dll'
      'VendorLibOsx=libmysqlclient.dylib'
      'MaxBlobSize=-1'
      'DriverName=MySQL'
      'HostName=ServerName'
      'Database=DBNAME'
      'User_Name=user'
      'Password=password'
      'ServerCharSet='
      'BlobSize=-1'
      'ErrorResourceFile='
      'LocaleCode=0000'
      'Compressed=False'
      'Encrypted=False'
      'ConnectTimeout=60')
    VendorLib = 'LIBMYSQL.dll'
    Left = 107
    Top = 232
  end
  object SQLQuery1: TSQLQuery
    MaxBlobSize = -1
    Params = <>
    SQLConnection = SQLConnection1
    Left = 256
    Top = 232
  end
end
