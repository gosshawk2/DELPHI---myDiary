unit DatabaseConnections;

//Unit DatabaseConnections for DelphiRichardProject to test and experiment with database handling.
//Written by Daniel Goss - copyright May - July 2012
//version 1.1.0.145 Tuesday July 24th 2012
//Amended: Added MDB functionality and changed name of property from ShowLogin to LoginForm
//New Version: 12-9-2012  - added combobox and font.name functionality.
//Last Amendment: 17-Sep-2012

interface

uses Dialogs, Classes, sysUtils, strUtils, ADODB, DB, CreateAForm;

type TstrArray = Array of String;

type TDBLogin = class //Login process,store db credentials and session management
    private
      FDBType: integer;
      FHostname: string;
      FDatabase: string;
      FUsername: string;
      FPassword: string;
      FRadioButtonTag: integer;
      FCreateForm: TCreateForm;
      FLoginControls: TControlOptions;
      FLoginControlAttributes: TStrings;
      FPointer: Pointer;
      FButtonClicked: Integer;
      procedure ClickHandlerAddServer(Sender: TObject);
    public
      constructor Create;
      destructor Destroy;override;
      procedure SetDatabaseType(Value:integer);
      procedure comServersClick(Sender: TObject);
      procedure btnAddServersClick(Sender: TObject);
      function GetDatabaseType:integer;
      function GetHostname:string;
      function GetDatabase:string;
      function GetUsername:string;
      function GetPassword:string;
    published
  end; {type TDBLogin}

type TMyADOConnection = class
  private
    FDBType: integer;
    FServer: string;
    FDatabase: string;
    FUserID: string;
    FPassword: string;
    FADOConnStr: string;
    FFieldNames: string;
    FFieldValues: string;
    FFieldsMAX: integer;
    FValuesMAX: integer;
    FTableNames: TstrArray;
    FStringArray: TstrArray;
    FFieldsArray: TstrArray;
    FValuesArray: TstrArray;
    FADOConnection: TADOConnection;
    FADOQuery: TADOQuery;
    FADODataset: TADODataset;
    FLoginForm: TDBLogin;
    FOpenError: integer;
    FExceptionError: string;
    FLoginButtonClicked: integer;

    function GetADOConnectionString(DBType:integer;Server,Database,UserID,PW:string):string;
    function GetADOConnection: TADOConnection;
    function GetADOQuery: TADOQuery;
    procedure SetADOQuery(ADOQuerySetting: TADOQuery);
    function GetADODataset: TADODataset;
    procedure SetADOConnection(ADOValue:TADOConnection);
    procedure SetTableNames(StringArray: TstrArray);
    procedure SetFFieldsArray(StringArray: TstrArray);
    procedure SetFValuesArray(StringArray: TstrArray);
    //constructor Create(DBType,Server,Database,UserID,PW: string); Overload;
    //constructor Create(DBType,Server,Database,UserID,PW: string; var AADOConnection: TADOConnection); Overload;
    procedure PrepareDataset(qryString:string; AAdoConnection:TADOConnection); Overload;
  public
    destructor Destroy; override;
    constructor Create(RequireLoginForm:boolean=True); overload;
    constructor Create(DBType:integer;Server,Database,UserID,PW: string; var AADOConnection: TADOConnection); Overload;
    procedure PrepareQuery(qryString:string; AAdoConnection:TADOConnection); Overload;
    procedure PrepareQuery(qryString:string; AAdoConnection:TADOConnection; TableName,FieldNames,FieldValues,Filter,OrderFields:string); Overload;
    procedure PrepareQuery(qryString:string; TableName,FieldNames,FieldValues,Filter,OrderFields:string); Overload;
    procedure InsertMode(var AADOQuery: TADOQuery); Overload;
    property LoginForm:TDBLogin read FLoginForm;
    property OpenError:integer read FOpenError write FOpenError;
    property LoginButtonClicked:integer read FLoginButtonClicked write FLoginButtonClicked;
    function TestConnection:boolean;
    function GetErrors(ErrorNo:integer):string;
    //function StrToStringArray(TheString:string; SubString:string = ','):TstrArray;
  published
    property myADOConnection: TADOConnection read GetADOConnection;
    property myADOQuery: TADOQuery read GetADOQuery write SetADOQuery;
    property myADODataset: TADODataSet read GetADODataset;
    property myADOFields: TstrArray read FFieldsArray write SetFFieldsArray;
    property myADOValues: TstrArray read FValuesArray write SetFValuesArray;
    constructor Create(DBType:integer;Server,Database,UserID,PW:string;OpenConnection:boolean); Overload;
    //constructor Create(DBType,Server,Database,UserID,PW: string; var AADOConnection: TADOConnection); Overload;
    procedure PrepareQuery(qryString:string); Overload;
    procedure PrepareDataset(qryString:string); Overload;
    function PrepareInsert(TableName,FieldNames,FieldValues:string):string;
    function PrepareUpdate(TableName,FieldNames,FieldValues,Filter:string):string;
    function PrepareDelete(TableName,FieldNames,FieldValues,Filter:string):string;
    function ExtractFieldNames(AADOQuery:TADOQuery):string;
    function ExtractFieldValues(AADOQuery:TADOQuery):string;
    procedure InsertMode; Overload;
    function StrToStringArray(TheString:string; SubString:string = ','):TstrArray;
  end; {type TMyADOConnection}

implementation

constructor TDBLogin.Create;
begin
  //create form dynamically - it will exist for the term of this procedure
  FCreateForm:= TCreateForm.Create('frmDBLogin','Enter Login Details',-2,200,100,700,500);
  FLoginControlAttributes:= TStringList.Create;
  //Setup Panels pnlMain to hold controls:
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=1');
  FLoginControlAttributes.Add('NAME=pnlMain');
  FLoginControlAttributes.Add('LEFT=5');
  FLoginControlAttributes.Add('TOP=5');
  FLoginControlAttributes.Add('WIDTH=500');
  FLoginControlAttributes.Add('HEIGHT=236');
  FLoginControlAttributes.Add('TABORDER=1');
  FLoginControlAttributes.Add('CAPTION=');
  FLoginControlAttributes.Add('COLOR=166,202,240'); //SKY BLUE
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TPanel',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //Setup Panels pnlEntry to hold controls:
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=2');
  FLoginControlAttributes.Add('NAME=pnlEntry');
  FLoginControlAttributes.Add('LEFT=8');
  FLoginControlAttributes.Add('TOP=83');
  FLoginControlAttributes.Add('WIDTH=484');
  FLoginControlAttributes.Add('HEIGHT=145');
  FLoginControlAttributes.Add('TABORDER=2');
  FLoginControlAttributes.Add('PARENT=pnlMain');
  FLoginControlAttributes.Add('CAPTION=');
  FLoginControlAttributes.Add('COLOUR=192,192,192'); //SILVER BACKGROUND
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TPanel',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //Setup Panels pnlDBSelection to hold controls:
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=3');
  FLoginControlAttributes.Add('NAME=pnlDBSelection');
  FLoginControlAttributes.Add('LEFT=8');
  FLoginControlAttributes.Add('TOP=8');
  FLoginControlAttributes.Add('WIDTH=484');
  FLoginControlAttributes.Add('HEIGHT=72');
  FLoginControlAttributes.Add('TABORDER=3');
  FLoginControlAttributes.Add('PARENT=pnlMain');
  FLoginControlAttributes.Add('CAPTION=');
  FLoginControlAttributes.Add('COLOUR=192,192,192');
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TPanel',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //setup GroupBox to hold the RadioButtons to select the required database to use.
  //GroupBox to hold radiobuttons:
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=1');
  FLoginControlAttributes.Add('NAME=gbDBSelection');
  FLoginControlAttributes.Add('LEFT=4');
  FLoginControlAttributes.Add('TOP=4');
  FLoginControlAttributes.Add('WIDTH=476');
  FLoginControlAttributes.Add('HEIGHT=63');
  FLoginControlAttributes.Add('COLOR=72,15,225'); //DARKISH BLUE
  FLoginControlAttributes.Add('FONT.COLOR=255,255,255'); //WHITE
  FLoginControlAttributes.Add('PARENT=pnlDBSelection');
  FLoginControlAttributes.Add('CAPTION=Select Database');
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TGroupbox',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);

  //RadioButton1 to allow the database choice MYSQL:
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=1');
  FLoginControlAttributes.Add('NAME=rbMySQL');
  FLoginControlAttributes.Add('LEFT=10');
  FLoginControlAttributes.Add('TOP=16');
  FLoginControlAttributes.Add('HEIGHT=20');
  FLoginControlAttributes.Add('WIDTH=200');
  FLoginControlAttributes.Add('COLOR=255,255,0'); //YELLOW
  FLoginControlAttributes.Add('FONT.COLOR=0,0,0'); //CLBLACK
  FLoginControlAttributes.Add('PARENT=gbDBSelection');
  FLoginControlAttributes.Add('CAPTION=MySQL');
  FLoginControlAttributes.Add('CHECKED=TRUE');
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TRadioButton',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //RadioButton2 to allow the database choice MYSQL:
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=2');
  FLoginControlAttributes.Add('NAME=rbMSSQL');
  FLoginControlAttributes.Add('LEFT=266');
  FLoginControlAttributes.Add('TOP=16');
  FLoginControlAttributes.Add('HEIGHT=20');
  FLoginControlAttributes.Add('WIDTH=200');
  FLoginControlAttributes.Add('COLOR=255,0,255'); //CLFUCHISIA - PURPLE
  FLoginControlAttributes.Add('FONT.COLOR=0,0,0'); //CLBLACK
  FLoginControlAttributes.Add('PARENT=gbDBSelection');
  FLoginControlAttributes.Add('CAPTION=MSSQL');
  FLoginControlAttributes.Add('CHECKED=FALSE');
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TRadioButton',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //RadioButton3 to allow the database choice ACCESS MDB:
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=3');
  FLoginControlAttributes.Add('NAME=rbAccessMDB');
  FLoginControlAttributes.Add('LEFT=10');
  FLoginControlAttributes.Add('TOP=38');
  FLoginControlAttributes.Add('HEIGHT=20');
  FLoginControlAttributes.Add('WIDTH=200');
  FLoginControlAttributes.Add('PARENT=gbDBSelection');
  FLoginControlAttributes.Add('COLOR=128,255,0'); ////BRIGHT GREEN
  FLoginControlAttributes.Add('FONT.COLOR=0,0,0'); //CLBLACK
  FLoginControlAttributes.Add('CAPTION=AccessMDB');
  FLoginControlAttributes.Add('CHECKED=FALSE');
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TRadioButton',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //RadioButton4 to allow the database choice FIREBIRD:
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=4');
  FLoginControlAttributes.Add('NAME=rbFirebird');
  FLoginControlAttributes.Add('LEFT=266');
  FLoginControlAttributes.Add('TOP=38');
  FLoginControlAttributes.Add('HEIGHT=20');
  FLoginControlAttributes.Add('WIDTH=200');
  FLoginControlAttributes.Add('COLOR=255,0,0'); //CLRED
  FLoginControlAttributes.Add('FONT.COLOR=0,0,0'); //CLBLACK
  FLoginControlAttributes.Add('PARENT=gbDBSelection');
  FLoginControlAttributes.Add('CAPTION=Firebird');
  FLoginControlAttributes.Add('CHECKED=FALSE');
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TRadioButton',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //Label1 - Hostname
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=1');
  FLoginControlAttributes.Add('NAME=lblHostname');
  FLoginControlAttributes.Add('LEFT=8');
  FLoginControlAttributes.Add('TOP=8');
  FLoginControlAttributes.Add('HEIGHT=15');
  FLoginControlAttributes.Add('WIDTH=70');
  FLoginControlAttributes.Add('COLOR=192,192,192'); //CLSILVER
  FLoginControlAttributes.Add('FONT.COLOR=0,0,0'); //CLBLACK
  FLoginControlAttributes.Add('CAPTION=Host/Server:');
  FLoginControlAttributes.Add('PARENT=pnlEntry');

  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TLabel',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //Label2 - Database
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=2');
  FLoginControlAttributes.Add('NAME=lblDatabase');
  FLoginControlAttributes.Add('LEFT=8');
  FLoginControlAttributes.Add('TOP=32');
  FLoginControlAttributes.Add('HEIGHT=15');
  FLoginControlAttributes.Add('WIDTH=53');
  FLoginControlAttributes.Add('COLOR=192,192,192'); //CLSILVER
  FLoginControlAttributes.Add('FONT.COLOR=0,0,0'); //CLBLACK
  FLoginControlAttributes.Add('CAPTION=Database:');
  FLoginControlAttributes.Add('PARENT=pnlEntry');

  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TLabel',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //Label3 - Username
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=3');
  FLoginControlAttributes.Add('NAME=lblUsername');
  FLoginControlAttributes.Add('LEFT=8');
  FLoginControlAttributes.Add('TOP=56');
  FLoginControlAttributes.Add('HEIGHT=15');
  FLoginControlAttributes.Add('WIDTH=58');
  FLoginControlAttributes.Add('COLOR=192,192,192'); //CLSILVER
  FLoginControlAttributes.Add('FONT.COLOR=0,0,0'); //CLBLACK
  FLoginControlAttributes.Add('CAPTION=Username:');
  FLoginControlAttributes.Add('PARENT=pnlEntry');

  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TLabel',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //Label4 - Password
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=4');
  FLoginControlAttributes.Add('NAME=lblPassword');
  FLoginControlAttributes.Add('LEFT=8');
  FLoginControlAttributes.Add('TOP=80');
  FLoginControlAttributes.Add('HEIGHT=15');
  FLoginControlAttributes.Add('WIDTH=57');
  FLoginControlAttributes.Add('COLOR=192,192,192'); //silver
  FLoginControlAttributes.Add('FONT.COLOR=0,0,0'); //CLBLACK
  FLoginControlAttributes.Add('CAPTION=Password:');
  FLoginControlAttributes.Add('PARENT=pnlEntry');

  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TLabel',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //Edit1 - Hostname
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=1');
  FLoginControlAttributes.Add('NAME=txtHostname');
  FLoginControlAttributes.Add('LEFT=88');
  FLoginControlAttributes.Add('TOP=6');
  FLoginControlAttributes.Add('HEIGHT=23');
  FLoginControlAttributes.Add('WIDTH=162');
  FLoginControlAttributes.Add('PARENT=pnlEntry');
  FLoginControlAttributes.Add('TEXT=');
  FLoginControlAttributes.Add('COLOR=0,128,192'); //BLUE
  FLoginControlAttributes.Add('FONT.COLOR=255,255,255'); //CLWHITE
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TEdit',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //Edit2 - Database
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=2');
  FLoginControlAttributes.Add('NAME=txtDatabase');
  FLoginControlAttributes.Add('LEFT=88');
  FLoginControlAttributes.Add('TOP=30');
  FLoginControlAttributes.Add('HEIGHT=23');
  FLoginControlAttributes.Add('WIDTH=162');
  FLoginControlAttributes.Add('PARENT=pnlEntry');
  FLoginControlAttributes.Add('TEXT=');
  FLoginControlAttributes.Add('COLOR=0,128,192'); //BLUE
  FLoginControlAttributes.Add('FONT.COLOR=255,255,255'); //WHITE
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TEdit',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //Edit3 - Username
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=3');
  FLoginControlAttributes.Add('NAME=txtUsername');
  FLoginControlAttributes.Add('LEFT=88');
  FLoginControlAttributes.Add('TOP=54');
  FLoginControlAttributes.Add('HEIGHT=23');
  FLoginControlAttributes.Add('WIDTH=162');
  FLoginControlAttributes.Add('PARENT=pnlEntry');
  FLoginControlAttributes.Add('TEXT=');
  FLoginControlAttributes.Add('COLOR=0,128,192'); //BLUE
  FLoginControlAttributes.Add('FONT.COLOR=255,255,255'); //WHITE
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TEdit',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //Edit4 - Password
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=4');
  FLoginControlAttributes.Add('NAME=txtPassword');
  FLoginControlAttributes.Add('LEFT=88');
  FLoginControlAttributes.Add('TOP=78');
  FLoginControlAttributes.Add('HEIGHT=23');
  FLoginControlAttributes.Add('WIDTH=162');
  FLoginControlAttributes.Add('PARENT=pnlEntry');
  FLoginControlAttributes.Add('PASSWORD=TRUE');
  FLoginControlAttributes.Add('TEXT=');
  FLoginControlAttributes.Add('COLOR=0,128,192'); //BLUE
  FLoginControlAttributes.Add('FONT.COLOR=255,255,255'); //WHITE
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TEdit',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //BitBtn1 - Cancel
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('Tag=1');
  FLoginControlAttributes.Add('Name=btnCancel');
  FLoginControlAttributes.Add('Left=8');
  FLoginControlAttributes.Add('Top=112');
  FLoginControlAttributes.Add('HEIGHT=25');
  FLoginControlAttributes.Add('WIDTH=170');
  FLoginControlAttributes.Add('PARENT=pnlEntry');
  FLoginControlAttributes.Add('Caption=Cancel');
  FLoginControlAttributes.Add('OnClick=ClickHandler');
  FLoginControlAttributes.Add('ModalResult=mrCancel');
  FLoginControlAttributes.Add('Default=False');
  FLoginControlAttributes.Add('Cancel=True');
  FLoginControlAttributes.Add('FONT.COLOR=0,0,0'); //CLBLACK
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TBitBtn',FLoginControlAttributes);
  //TBitBtn(FLoginControls).ModalResult:= mrCancel;
  FCreateForm.ControlList.Add(FLoginControls);
  //BitBtn2 - Submit
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=2');
  FLoginControlAttributes.Add('NAME=btnLogin');
  FLoginControlAttributes.Add('LEFT=254');
  FLoginControlAttributes.Add('TOP=112');
  FLoginControlAttributes.Add('HEIGHT=25');
  FLoginControlAttributes.Add('WIDTH=170');
  FLoginControlAttributes.Add('PARENT=pnlEntry');
  FLoginControlAttributes.Add('CAPTION=Login');
  FLoginControlAttributes.Add('ONCLICK=ClickHandler');
  FLoginControlAttributes.Add('ModalResult=mrOK');
  FLoginControlAttributes.Add('DEFAULT=True');
  FLoginControlAttributes.Add('CANCEL=False');
  FLoginControlAttributes.Add('FONT.COLOR=0,0,0'); //CLBLACK
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TBitBtn',FLoginControlAttributes);
  //TBitBtn(FLoginControls).ModalResult:= mrOK;
  FCreateForm.ControlList.Add(FLoginControls);
  //BitBtn3 - Add Server
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=3');
  FLoginControlAttributes.Add('NAME=btnAddServers');
  FLoginControlAttributes.Add('LEFT=254');
  FLoginControlAttributes.Add('TOP=6');
  FLoginControlAttributes.Add('HEIGHT=23');
  FLoginControlAttributes.Add('WIDTH=23');
  FLoginControlAttributes.Add('PARENT=pnlEntry');
  FLoginControlAttributes.Add('CAPTION=+');
  FLoginControlAttributes.Add('ONCLICK=btnAddServersClick');
  FLoginControlAttributes.Add('ModalResult=mrOK');
  FLoginControlAttributes.Add('DEFAULT=False');
  FLoginControlAttributes.Add('CANCEL=False');
  FLoginControlAttributes.Add('FONT.COLOR=0,0,0'); //CLBLACK
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TBitBtn',FLoginControlAttributes);
  //TBitBtn(FLoginControls).ModalResult:= mrOK;
  FCreateForm.ControlList.Add(FLoginControls);
  //BitBtn4 - Add Database
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=4');
  FLoginControlAttributes.Add('NAME=btnAddDatabase');
  FLoginControlAttributes.Add('LEFT=254');
  FLoginControlAttributes.Add('TOP=30');
  FLoginControlAttributes.Add('HEIGHT=23');
  FLoginControlAttributes.Add('WIDTH=23');
  FLoginControlAttributes.Add('PARENT=pnlEntry');
  FLoginControlAttributes.Add('CAPTION=+');
  FLoginControlAttributes.Add('ONCLICK=ClickHandlerAddDatabase');
  FLoginControlAttributes.Add('ModalResult=mrNone');
  FLoginControlAttributes.Add('DEFAULT=False');
  FLoginControlAttributes.Add('CANCEL=False');
  FLoginControlAttributes.Add('FONT.COLOR=0,0,0'); //CLBLACK
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TBitBtn',FLoginControlAttributes);
  //TBitBtn(FLoginControls).ModalResult:= mrOK;
  FCreateForm.ControlList.Add(FLoginControls);
  //BitBtn5 - Add Username
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=5');
  FLoginControlAttributes.Add('NAME=btnAddUsername');
  FLoginControlAttributes.Add('LEFT=254');
  FLoginControlAttributes.Add('TOP=54');
  FLoginControlAttributes.Add('HEIGHT=23');
  FLoginControlAttributes.Add('WIDTH=23');
  FLoginControlAttributes.Add('PARENT=pnlEntry');
  FLoginControlAttributes.Add('CAPTION=+');
  FLoginControlAttributes.Add('ONCLICK=ClickHandlerAddUsername');
  FLoginControlAttributes.Add('ModalResult=mrNone');
  FLoginControlAttributes.Add('DEFAULT=False');
  FLoginControlAttributes.Add('CANCEL=False');
  FLoginControlAttributes.Add('FONT.COLOR=0,0,0'); //CLBLACK
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TBitBtn',FLoginControlAttributes);
  //TBitBtn(FLoginControls).ModalResult:= mrOK;
  FCreateForm.ControlList.Add(FLoginControls);
  //comboBox1 - Servers
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=1');
  FLoginControlAttributes.Add('NAME=comServers');
  FLoginControlAttributes.Add('LEFT=280');
  FLoginControlAttributes.Add('TOP=6');
  FLoginControlAttributes.Add('HEIGHT=21');
  FLoginControlAttributes.Add('WIDTH=200');
  FLoginControlAttributes.Add('PARENT=pnlEntry');
  FLoginControlAttributes.Add('OnClick=comServersClick');
  FLoginControlAttributes.Add('AddItem=localhost');
  FLoginControlAttributes.Add('AddItem=DANNYG-PC\DGPIN');
  FLoginControlAttributes.Add('AddItem=DANNYG-DESKTOP\');
  FLoginControlAttributes.Add('TEXT=localhost');
  FLoginControlAttributes.Add('COLOR=255,255,255'); // WHITE=255,255,255
  FLoginControlAttributes.Add('FONT.COLOR=0,128,192'); //BLUE=0,128,192
  FLoginControlAttributes.Add('FONT.NAME=CAMBRIA'); //BLUE=0,128,192
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TComboBox',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //FCreateForm.GetOnClickName(self,'comServers','comServersClick');
  //comboBox2 - Databases
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=2');
  FLoginControlAttributes.Add('NAME=comDatabases');
  FLoginControlAttributes.Add('LEFT=280');
  FLoginControlAttributes.Add('TOP=30');
  FLoginControlAttributes.Add('HEIGHT=21');
  FLoginControlAttributes.Add('WIDTH=200');
  FLoginControlAttributes.Add('PARENT=pnlEntry');
  FLoginControlAttributes.Add('OnClick=comDatabasesClick');
  FLoginControlAttributes.Add('AddItem=richard1');
  FLoginControlAttributes.Add('TEXT=richard1');
  FLoginControlAttributes.Add('COLOR=255,255,255'); // WHITE=255,255,255
  FLoginControlAttributes.Add('FONT.COLOR=0,128,192'); //BLUE=0,128,192
  FLoginControlAttributes.Add('FONT.NAME=CAMBRIA'); //BLUE=0,128,192
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TComboBox',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //comboBox3 - Usernames
  FLoginControlAttributes.Clear;
  FLoginControlAttributes.Add('TAG=3');
  FLoginControlAttributes.Add('NAME=comUsernames');
  FLoginControlAttributes.Add('LEFT=280');
  FLoginControlAttributes.Add('TOP=54');
  FLoginControlAttributes.Add('HEIGHT=21');
  FLoginControlAttributes.Add('WIDTH=200');
  FLoginControlAttributes.Add('PARENT=pnlEntry');
  FLoginControlAttributes.Add('OnClick=comUsernamesClick');
  FLoginControlAttributes.Add('AddItem=root');
  FLoginControlAttributes.Add('AddItem=dannyg');
  FLoginControlAttributes.Add('AddItem=DANNYG-PC\DGPIN');
  FLoginControlAttributes.Add('AddItem=DANNYG-DESKTOP\');
  FLoginControlAttributes.Add('TEXT=');
  FLoginControlAttributes.Add('COLOR=255,255,255'); // WHITE=255,255,255
  FLoginControlAttributes.Add('FONT.COLOR=0,128,192'); //BLUE=0,128,192
  FLoginControlAttributes.Add('FONT.NAME=CAMBRIA'); //BLUE=0,128,192
  FLoginControls:= TControlOptions.Create(FCreateForm.GetForm,'TComboBox',FLoginControlAttributes);
  FCreateForm.ControlList.Add(FLoginControls);
  //Show LOGIN FORM
  FButtonClicked:= self.FCreateForm.Form.ShowModal;
  if FButtonClicked = 1 then begin
    FRadioButtonTag:= FCreateForm.GetRadiobuttonTag;
    if FRadioButtonTag>0 then SetDatabaseType(FRadioButtonTag) //1 = MYSQL, 2= MSSQL, 3= AccessDB, 4= Firebird
    else ShowMessage('Please select a radio option');
    FHostname:= FCreateForm.GetTextEntry(1);
    FDatabase:= FCreateForm.GetTextEntry(2);
    FUsername:= FCreateForm.GetTextEntry(3);
    FPassword:= FCreateForm.GetTextEntry(4);
    //ShowMessage('Button1 clicked:LOGIN '+FHostname);
  end;
  if FButtonClicked = 2 then begin
    //ShowMessage('Button2 clicked: CANCEL');
  end;
end; {TDBLogin.Create}

destructor TDBLogin.Destroy;
begin
  //destroy all login controls
  if FLoginControlAttributes<>nil then
    FreeAndNil(FLoginControlAttributes);
  if FLoginControls<>nil then
    FreeAndNil(FLoginControls);
  if FCreateForm<>nil then
    FreeAndNil(FCreateForm);
  inherited;
end;

procedure TDBLogin.comServersClick(Sender: TObject);
begin
  ShowMessage('Button Clicked on server combo in LOGIN');
end;

procedure TDBLogin.ClickHandlerAddServer(Sender: TObject);
begin
  ShowMessage('Button Clicked on ClickHandlerAddServer in LOGIN');
end;

procedure TDBLogin.btnAddServersClick(Sender: TObject);
begin
  ShowMessage('Button Click on Add Servers in TDBLogin');
end;

procedure TDBLogin.SetDatabaseType(Value:integer);
begin
  FDBType:= Value;
end;

function TDBLogin.GetDatabaseType:integer;
begin
  Result:= FDBType;
end;

function TDBLogin.GetHostname:string;
begin
  Result:= FHostname;
end; {function TDBLogin.GetHostname}

function TDBLogin.GetDatabase:string;
begin
  Result:= FDatabase;
end; {function TDBLogin.GetHostname}

function TDBLogin.GetUsername:string;
begin
  Result:= FUsername;
end; {function TDBLogin.GetHostname}

function TDBLogin.GetPassword:string;
begin
  Result:= FPassword;
end; {function TDBLogin.GetHostname}



function TMyADOConnection.GetADOConnectionString(DBType:integer;Server,Database,UserID,PW:string):string;
var
  Provider: string;
  Driver: string;
  InitialCat: string;
  ConnStr: string;
  Port: string;
  IntegratedSecurity: string;
  PersistSecurityInfo: string;
  DataSource: string;
begin
  ConnStr:= '';
  if DBType=1 then begin
    if Length(Server)=0 then Server:= 'localhost';
    Port:= '3306';
    Driver:= '{MySQL ODBC 5.1 Driver}';
    Provider:= 'MSDASQL.1';
    ConnStr:= 'Provider='+Provider;
    ConnStr:= ConnStr+';'+'Password='+pw;
    ConnStr:= ConnStr+';'+'User ID='+userID;
    ConnStr:= ConnStr+';'+'Extended Properties='+chr(34);
    ConnStr:= ConnStr+'DRIVER='+Driver;
    ConnStr:= ConnStr+';'+'UID='+userID;
    ConnStr:= ConnStr+';'+'PWD='+pw;
    ConnStr:= ConnStr+';'+'Port='+Port;
    ConnStr:= ConnStr+';'+'Database='+Database;
    ConnStr:= ConnStr+';'+'SERVER='+Server+chr(34);

  end {MYSQL type}
  else if DBType = 2 then begin
    //Use Procedure for Prepare=1;
    //Auto Translate=True;
    //Packet Size=4096;
    //Workstation ID=DANNYG-PC;
    //Use Encryption for Data=False;
    //Tag with column collation when possible=False;
    Provider:= 'sqloledb.1';
    IntegratedSecurity:= 'SSPI';
    PersistSecurityInfo:= 'false';
    DataSource:= Server;
    InitialCat:= Database;
    ConnStr:= 'Provider='+Provider;
    ConnStr:= ConnStr+';'+'Integrated Security='+IntegratedSecurity;
    ConnStr:= ConnStr+';'+'Persist Security Info='+PersistSecurityInfo;
    ConnStr:= ConnStr+';'+'Data Source='+DataSource;
    ConnStr:= ConnStr+';'+'Initial Catalog='+InitialCat;
    ConnStr:= ConnStr+';'+'User ID='+userID;
    ConnStr:= ConnStr+';'+'Password='+pw;
  end {MSSQL type}
  else if DBType = 3 then begin
    //construct MDB type
    Provider:= 'Microsoft.Jet.OLEDB.4.0';
    PersistSecurityInfo:= 'false';
    DataSource:= Database;
    ConnStr:= 'Provider='+Provider;
    ConnStr:= ConnStr+';'+'Data Source='+DataSource;
    ConnStr:= ConnStr+';'+'Persist Security Info='+PersistSecurityInfo;
    if pw <> '' then
      ConnStr:= ConnStr+';'+'Jet OLEDB:Database Password='+pw;

  end {MDB type}
  else
    ConnStr:= '';
  result:= ConnStr;
end; {SetupADOConnectionString}

procedure TMyADOConnection.SetADOConnection(ADOValue:TADOConnection);
begin
  FADOConnection:= ADOValue;
end; {SetADOConnection}

procedure TMyADOConnection.SetADOQuery(ADOQuerySetting: TADOQuery);
begin
  FADOQuery:= ADOQuerySetting;
end; {SetADOQuery}

function TMyADOConnection.GetErrors(ErrorNo:integer):string;
begin
  if ErrorNo = 0 then Result:= 'No Errors';
  if ErrorNo = 1 then Result:= 'Exception Error: '+FExceptionError;
  if ErrorNo = 2 then Result:= 'Cancel Clicked';
end; {TMyADOConnection.GetErrors(ErrorNo:integer):string}

function TMyADOConnection.TestConnection:boolean;
begin
  Result:= True; //connects OK
  FADOConnStr:= GetADOConnectionString(FDBType,FServer,FDatabase,FUserID,FPassword);
  FADOConnection:= TADOConnection.Create(nil);
  //FADOQuery:= TADOQuery.Create(nil);
  //FADODataset:= TADODataset.Create(nil);
  try
    FADOConnection.DefaultDatabase:= FDatabase;
    FADOConnection.Close;
    FADOConnection.ConnectionString:= FADOConnStr;
    FADOConnection.LoginPrompt:= false;
    if not FADOConnection.Connected then begin
      try
        FADOConnection.Open;
      except on E:Exception do begin
          FOpenError:= 1;
          FExceptionError:= e.Message;
          Result:= False;
        end;
      end; {exception}
    end; {if not}
  finally
    if FADOConnection<>nil then
      FreeAndNil(FADOConnection);
  end;
end;

Constructor TMyADOConnection.Create(DBType:integer;Server,Database,UserID,PW:string;OpenConnection:boolean);
begin
  FFieldsMAX:= 0;
  FValuesMAX:= 0;
  FADOConnStr:= GetADOConnectionString(DBType,Server,Database,UserID,PW);
  FADOConnection:= TADOConnection.Create(nil);
  FADOQuery:= TADOQuery.Create(nil);
  FADODataset:= TADODataset.Create(nil);
  FADOConnection.Close;
  FADOConnection.ConnectionString:= FADOConnStr; //test if not empty
  FADOConnection.LoginPrompt:= false;
  FADOConnection.DefaultDatabase:= Database;
  FADOConnection.ConnectionTimeout:= 2;
  //FADOConnection.Provider:= Provider;
  if OpenConnection = true then begin
    if not FADOConnection.Connected then begin
        try
          FADOConnection.Open;
        except on E:Exception do begin
            FExceptionError:= e.Message;
            FOpenError:= 1;
          end; {inner exception}
        end; {exception}
    end; {if not}
  end; {if OpenConnection=True}
end; {Constructor TMyADOConnection.Create}

Constructor TMyADOConnection.Create(DBType:integer;Server,Database,UserID,PW:string; var AADOConnection: TADOConnection);
begin
  FFieldsMAX:= 0;
  FValuesMAX:= 0;
  FADOConnStr:= GetADOConnectionString(DBType,Server,Database,UserID,PW);
  FADOConnection:= TADOConnection.Create(nil);
  FADOQuery:= TADOQuery.Create(nil);
  FADODataset:= TADODataset.Create(nil);
  FADOConnection.DefaultDatabase:= Database;
  FADOConnection.Close;
  FADOConnection.ConnectionString:= FADOConnStr;
  FADOConnection.LoginPrompt:= false;
  AADOConnection.Close;
  AADOConnection.ConnectionString:= FADOConnStr; //test if not empty
  AADOConnection.LoginPrompt:= false;
  AADOConnection.DefaultDatabase:= Database;
  //AADOConnection.Provider:= Provider;
  if not AADOConnection.Connected then begin
    try
      AADOConnection.Open;
      FADOConnection.Open;
    except on E:Exception do begin
        FExceptionError:= e.Message;
        FOpenError:= 1;
      end; {inner exception}
    end; {exception}
  end; {if not}

end; {Constructor2 TMyADOConnection.Create type2}

Constructor TMyADOConnection.Create(RequireLoginForm:boolean=True);
var
  IsOpenError: boolean;
begin
  if RequireLoginForm then begin
    FLoginForm:= TDBLogin.Create;
    FLoginButtonClicked:= FLoginForm.FButtonClicked;
    FDBType:= FLoginForm.GetDatabaseType;
    FDBType:= FLoginForm.FRadioButtonTag;
    FServer:= FLoginForm.FHostname;
    FDatabase:= FLoginForm.FDatabase;
    FUserID:= FLoginForm.FUsername;
    FPassword:= FLoginForm.FPassword;
    self.FOpenError:=0;
    self.FExceptionError:='';
    if FLoginButtonClicked = 2 then begin
      self.FOpenError:= 2;
      exit;
    end;
    if self.TestConnection then begin
      //This is where everything gets initialised.
      ShowMessage('OK CONNECTED');

    end
    else begin
      ShowMessage('CONNECTION ERROR');
    end;
  end; {if}
end;

function TMyADOConnection.GetADOConnection: TADOConnection;
begin
  Result:= FADOConnection;
end; {GetADOConnection}

function TMyADOConnection.GetADOQuery: TADOQuery;
begin
  Result:= FADOQuery;
end;

function TMyADOConnection.GetADODataset: TADODataset;
begin
  Result:= FADODataset;
end;

destructor TMyADOConnection.Destroy;
begin
  if FADOConnection <> nil then
    FreeAndNil(FADOConnection);
  if FADOQuery <> nil then
    FreeAndNil(FADOQuery);
  if FADODataset <> nil then
    FreeAndNil(FADODataset);
  inherited;
end; {destroy}

procedure TMyADOConnection.PrepareQuery(qryString:string);
begin
  //Prepare intenal query with SQL - but do not activate

  FADOQuery.Connection:= GetADOConnection;
  FADOQuery.Close;
  FADOQuery.SQL.Clear;
  FADOQuery.SQL.Text:= qryString;
  FADOQuery.Prepared:= True;
  if PosEx('SELECT',qryString,1)>0 then begin
    FADOQuery.Open;
    FADOQuery.Refresh;
  end
  else begin
    FADOQuery.ExecSQL;
  end;

end; {PrepareQuery(qryString:string)}

procedure TMyADOConnection.PrepareQuery(qryString:string; TableName,FieldNames,FieldValues,Filter,OrderFields:string);
var
  qrySelect: string;
  qryInsert: string;
  qryUpdate: string;
  qryDelete: string;
begin
  //Prepare intenal query with SQL - but do not activate
  FADOQuery.Connection:= GetADOConnection;
  FADOQuery.Close;
  FADOQuery.SQL.Clear;
  qrySelect:= qryString;
  if PosEx('SELECT',qryString,1)>0 then begin
    if Length(Filter)>0 then begin
      qrySelect:= qrySelect+' WHERE '+Filter;
    end;
    if Length(OrderFields)>0 then begin
      qrySelect:= qrySelect+' OrderBy '+OrderFields;
    end;
    FADOQuery.SQL.Text:= qrySelect;
    FADOQuery.Prepared:= True;
    FADOQuery.Open;
    FADOQuery.Refresh;
    //FFieldsArray[FFieldsMAX]:= self.strToArrayString()
    //FValuesArray[FValuesMAX]:=
  end
  else if PosEx('INSERT',qryString,1)>0 then begin
    qryInsert:= self.PrepareInsert(TableName,FieldNames,FieldValues);
    FADOQuery.SQL.Text:= qryInsert;
    FADOQuery.Prepared:= True; //set insert mode
    FADOQuery.ExecSQL;
  end
  else if PosEx('UPDATE',qryString,1)>0 then begin
    qryUpdate:= self.PrepareUpdate(TableName,FieldNames,FieldValues,Filter);
    FADOQuery.SQL.Text:= qryUpdate;
    FADOQuery.Prepared:= True; //set insert mode
    FADOQuery.ExecSQL;
  end
  else if PosEx('DELETE',qryString,1)>0 then begin
    qryDelete:= self.PrepareDelete(TableName,FieldNames,FieldValues,Filter);
    FADOQuery.SQL.Text:= qryDelete;
    FADOQuery.Prepared:= True; //set insert mode
    FADOQuery.ExecSQL;
  end
  else begin
    MessageDlg('DGError: '+ #13#10+'SQL Command not recognised',mtError,[mbok],0);
  end;

end; {PrepareQuery(qryString:string)}

procedure TMyADOConnection.PrepareQuery(qryString:string; AAdoConnection:TADOConnection);
begin
  //use this if the internal query is connected to a different database connection
  FADOQuery.Connection:= AAdoConnection;
  FADOQuery.Close;
  FADOQuery.SQL.Clear;
  FADOQuery.SQL.Text:= qryString;
  FADOQuery.Prepared:= True;
  if PosEx('SELECT',qryString,1)>0 then begin
    FADOQuery.Open;
    FADOQuery.Refresh;
  end
  else begin
    FADOQuery.ExecSQL;
  end;
end; {PrepareQuery(qryString:string; AdoConnection:TADOConnection)}

procedure TMyADOConnection.PrepareQuery(qryString:string; AAdoConnection:TADOConnection; TableName,FieldNames,FieldValues,Filter,OrderFields:string);
var
  qrySelect: string;
  qryInsert: string;
  qryUpdate: string;
  qryDelete: string;
begin
  //use this if the internal query is connected to a different database connection
  FADOQuery.Connection:= AAdoConnection;
  qrySelect:= qryString;
  if PosEx('SELECT',qryString,1)>0 then begin

    if Length(Filter)>0 then begin
      qrySelect:= qrySelect+' WHERE '+Filter;
    end;
    if Length(OrderFields)>0 then begin
      qrySelect:= qrySelect+' OrderBy '+OrderFields;
    end;
    FADOQuery.Close;
    FADOQuery.SQL.Clear;
    FADOQuery.SQL.Text:= qrySelect;
    FADOQuery.Prepared:= True;
    FADOQuery.Open;
    FADOQuery.Refresh;
  end
  else if PosEx('INSERT',qryString,1)>0 then begin
    qryInsert:= self.PrepareInsert(TableName,FieldNames,FieldValues);
    FADOQuery.Close;
    FADOQuery.SQL.Clear;
    FADOQuery.SQL.Text:= qryInsert;
    FADOQuery.Prepared:= True; //set insert mode
    FADOQuery.ExecSQL;
  end
  else if PosEx('UPDATE',qryString,1)>0 then begin
    qryUpdate:= self.PrepareUpdate(TableName,FieldNames,FieldValues,Filter);
    ShowMessage('qryUpdate='+qryUpdate);
    FADOQuery.SQL.Text:= qryUpdate;
    FADOQuery.Prepared:= True; //set insert mode
    FADOQuery.ExecSQL;
  end
  else if PosEx('DELETE',qryString,1)>0 then begin
    qryDelete:= self.PrepareDelete(TableName,FieldNames,FieldValues,Filter);
    FADOQuery.SQL.Text:= qryDelete;
    FADOQuery.Prepared:= True; //set insert mode
    FADOQuery.ExecSQL;
  end
  else begin
    MessageDlg('DGError: '+ #13#10+'SQL Command not recognised',mtError,[mbok],0);
  end;
end; {PrepareQuery(qryString:string; AdoConnection:TADOConnection)}

function TMyADOConnection.ExtractFieldNames(AADOQuery:TADOQuery):string;
var
  TheFields: string;
  IDX:integer;
begin
  IDX:=0;
  TheFields:='';
  while IDX<= AADOQuery.FieldCount-1 do begin
    //FADOQuery.Fields is needed here.
    if IDX=0 then TheFields:= AADOQuery.Fields[IDX].FieldName
    else TheFields:= TheFields+ ','+AADOQuery.Fields[IDX].FieldName;
    IDX:= IDX+1;
  end; {while}
  result:= TheFields;
end; {ExtractFieldNames}

function TMyADOConnection.ExtractFieldValues(AADOQuery:TADOQuery):string;
var
  TheValues: string;
  IDX:integer;
begin
  //This procedure needs to focus on WHICH record is being operated on:
  //the default seems to be the first record in the table or query being
  //pointed to.
  IDX:=0;
  TheValues:='';
  while IDX<= AADOQuery.FieldCount-1 do begin
    if IDX=0 then TheValues:= AADOQuery.Fields[IDX].Value
    else TheValues:= TheValues+ ','+AADOQuery.Fields[IDX].Value;
    IDX:= IDX+1;
  end; {while}
  result:= TheValues;
end; {ExtractFieldNames}

procedure TMyADOConnection.PrepareDataset(qryString:string);
begin
  //Prepare intenal dataset with SQL - but do not activate
  FADODataset.Connection:= myADOConnection;
  FADODataset.Active:= false;
  FADODataset.CommandType:= cmdText;
  FADODataset.CommandText:= qryString;
  if PosEx('SELECT',UpperCase(qryString),1)>0 then
    FADODataset.Active:= True
  else
    FADODataset.Active:= True; //should be an ExecSQL type command ??

end;

procedure TMyADOConnection.PrepareDataset(qryString:string; AAdoConnection:TADOConnection);
begin
  //Prepare internal dataset to a different database connection
  FADODataset.Connection:= AAdoConnection;
  FADODataset.Active:= false;
  FADODataset.CommandType:= cmdText;
  FADODataset.CommandText:= qryString;
  if PosEx('SELECT',UpperCase(qryString),1)>0 then
    FADODataset.Active:= True
  else
    FADODataset.Active:= True;

end;

function TMyADOConnection.PrepareInsert(TableName,FieldNames,FieldValues:string):string;
var
  SQLcmd: string;
begin
  SQLcmd:= 'INSERT INTO '+TableName+' ('+FieldNames+') VALUES ('+FieldValues+')';
  Result:= SQLcmd;
end; {InsertQuery}

function TMyADOConnection.PrepareUpdate(TableName,FieldNames,FieldValues,Filter:string):string;
var
  SQLcmd: string;
  SETstring: string;
  MyFieldsArray: TstrArray;
  MyValuesArray: TstrArray;
  IDX: integer;
begin
  //FieldNames and FieldValues contains delimited string by comma
  //
  setLength(MyFieldsArray,Length(MyFieldsArray)+1);
  setLength(MyValuesArray,Length(MyValuesArray)+1);
  MyFieldsArray:= self.StrToStringArray(FieldNames);
  MyValuesArray:= self.StrToStringArray(FieldValues);
  IDX:=0;
  While IDX< high(MyFieldsArray) do begin
    if IDX=0 then SETstring:= MyFieldsArray[IDX]+ ' = '+ chr(34)+MyValuesArray[IDX]+chr(34)
    else SETstring:= ','+MyFieldsArray[IDX] + ' = '+ chr(34)+MyValuesArray[IDX]+chr(34);
    IDX:= IDX+1;
  end; {while}
  SQLcmd:= 'UPDATE '+TableName+' SET '+SETstring;
  if Length(Filter)>0 then SQLcmd:= SQLcmd+' WHERE '+Filter;
  Result:= SQLcmd;
end; {InsertQuery}

function TMyADOConnection.PrepareDelete(TableName,FieldNames,FieldValues,Filter:string):string;
var
  SQLcmd: string;
begin
  SQLcmd:= 'DELETE FROM '+TableName;
  if Length(Filter)>0 then SQLcmd:= SQLcmd+' WHERE '+Filter;
  Result:= SQLcmd;
end; {InsertQuery}

procedure TMyADOConnection.InsertMode;
begin
  FADOQuery.Insert;
end;

procedure TMyADOConnection.InsertMode(var AADOQuery: TADOQuery);
begin
  AADOQuery.Append;
end;

function TMyADOConnection.StrToStringArray(TheString:string; SubString:string = ','):TstrArray;
var
  IDX: integer;
  Elements: integer;
  CommaPos: integer;
  Extract:string;
begin
  IDX:=0;
  Elements:=0;
  //while (PosEx(SubString,TheString,IDX+1)>0) do begin
  Repeat
    CommaPos:= PosEx(SubString,TheString,IDX+1);
    if CommaPos>0 then
      Extract:= Copy(TheString,IDX+1,(CommaPos-(IDX+1)))
    else
      Extract:= Copy(TheString,IDX+1,Length(TheString));
    SetLength(FStringArray,Length(FStringArray)+1);
    FStringArray[Elements]:= Extract;
    IDX:=CommaPos;
    Elements:= Elements+1;
  Until CommaPos = 0;
  //end; {while}

  Result:= FStringArray;
end; {StrToStringArray}

procedure TMyADOConnection.SetFFieldsArray(StringArray: TstrArray);
begin
  SetLength(FFieldsArray,Length(StringArray)+1);
  FFieldsArray:= StringArray;
end;

procedure TMyADOConnection.SetFValuesArray(StringArray: TstrArray);
begin
  SetLength(FValuesArray,Length(StringArray)+1);
  FValuesArray:= StringArray;
end;

procedure TMyADOConnection.SetTablenames(StringArray: TstrArray);
begin
  SetLength(FTableNames,Length(StringArray)+1);
  FTableNames:= StringArray;
end;

{procedure TMyADOConnection.ShowLogin;
var
  LoginForm: TDBLogin;
begin
  LoginForm:= TDBLogin.Create;
  try
    ShowMEssage('OK Login completed');
  finally
    LoginForm.Free;
    LoginForm:= nil;
  end;

end; {TMyADOConnection.ShowLogin}

end.

