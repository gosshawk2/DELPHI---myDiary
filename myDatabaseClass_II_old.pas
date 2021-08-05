unit myDatabaseClass_II;

//Unit myDatabaseClass to create (eventually) , connect and manipulate Databases:
//   Currently just MYSQL database is supported with a view to adding MSSQL and JET MDB files later.
//Written by Daniel Goss - copyright 2014-2016
//
// This Version - 2.0.1.9 Monday 05-09-2016 at 03:10
// Incorporates the lost code from April 2015 - found in MyDiary under projects.
//
//First Amendment: 18 Feb 2014 = Create and Destroy methods, tidy up code.
//Amendment: 28 Feb 2014 = Combine DBOperations Class into single DBConnections.
//Amendment: 03 Mar 2014 = Alter CreateQuery under DBOperations to work with DBConnections.
//Latest Amendment: 12 Mar 2014 = Added new function to search Date fields,
//                  Return record id>0 if record found
//Functions Added: 16 Mar 2014
//  function DateForSQL(const date: TDate; hash:Boolean=false): string;
//  function DateTimeForSQL(const dateTime : TDateTime; hash:boolean=false) : string;
//  function TimeForSQL(const time: TTime; hash:Boolean=false): string;
//  function SearchDateField(DBTable,ConnString,SearchDateField:string;
//    SearchDate: TDateTime; MatchTime:boolean):integer;
//  function ConvertStringsToStrArray(StringList: TStringList):TStrArray;
//  function SaveIDs(theADOQuery:TADOQuery):integer;
//  function StringArrayToString(TheArray:TstrArray; SubString: string): string; was added 17/4/2014
//  function SearchField(DBTable,ConnString,SearchField: string; SearchValue: Variant): integer; added 19/6/2014
//                  CHANGES : 1st JULY 2014 - 03:27
//  function PrepareUpdate changed - IDX now starts at 1 and not 0 to remove the id field.
//  function GetNewFieldValue(FieldName,FieldValue,TableName,ConnString:string):string;
//    was added so both PrepareInsert and PrepareUpdate can call this to get new proper converted values to string
//    before saving to database. SO PrepareInsert and PrepareUpdate functions have changed slightly.
//Private Functions Added: 30/10/2014
//  function GetfFieldsArray: TstrArray;
//  function GetfValuesArray: TstrArray;
//private Procedures Added: 30/10/2014
//  procedure SetfFieldsArray(FieldList:string);
//  procedure SetfValuesArray(ValueList:string);
//  Latest Amendment - 25/02/2015 at 05:59
//  Added quotes around search field variable in line 1356 in function SearchFields()
//  changed line to while idx<= High(FieldsArray) do begin  otherwise last item is missed.
//TDBOperations.CreateQuery was changed to allow ReverseDir boolean value to work. 28/11/2015
//Added procedure TDBOperations.PopulateDropdownFromArray(comboBox: TComboBox; 03/12/2015
//Corrected: function TDBOperations.GetFieldnamesOfTypesPassed(TableName:string;
//  FieldType:string; conStr:WideString):string;  - from SaceIDX to IDX only. 04/12/2015
//11/12/2015 at 05:50 added new property:
//  property QueryString: string read GetQueryString write SetQueryString;
//  and self.QueryString:= SQLQuery; is used in these methods:
//  function TDBOperations.SelectDates(DBTable,ConnString,SearchDateField: string;
//  function TDBOperations.CreateRecArray(AADOQuery: TADOQuery): TRecArray;
//  function TDBOperations.SearchField(DBTable,ConnString,SearchField: string;
//    SearchValue: String; ChangeQueryString: boolean = FALSE): integer;
//  function TDBOperations.SearchDateField(DBTable,ConnString,SearchDateField: string;
//    SearchDate: TDateTime; MatchTime: boolean; ChangeQueryString: boolean = FALSE): integer;
//  function TDBOperations.SelectDates(DBTable,ConnString,SearchDateField: string;
//    SortField: string; ReverseDirection: boolean; DateFrom,DateTo: TDateTime;
//    Filter:string; ChangeQueryString:boolean = FALSE): integer;
//1/1/2016 - function TDBOperations.SelectDates - changed to return -1 if the
//  FIELD was not Found.
//1/1/2016 - procedure CreateQuery() is now a function
// and returns boolean value the field passed was NOT found in the table passed.
//
//03/01/2016 - minor changes to search methods and createQuery -
// check if field passed exists in passed tablename -
// if not - return -1 or FALSE and set the error message variable self.ErrorMessage
//
//04/01/2016 - changed function TDBOperations.GetID(index: integer): integer;
//  from just < to <= when looping through index.
//28/01/2016 - GetNewFieldValue was changed - now returns the string DATE ERROR
//
//31/01/2016 - started to add new procedure -
// procedure InsertValueIntoForm(Formname,ControlName,Value: string);
//
//21/03/2016 - Added private var fTableCount and property TableCount to Operations.
//
//13/06/2016 - NEW property UserID HAS BEEN ADDED along with Get and Set USERID
//           - in function SelectDates - SearchQuery should not be used and
//             should be fADOQuery.
//
//15/06/2016 - Changed function:
//             TDBOperations.CreateSingleRecArray(AADOQuery: TADOQuery): TstrArray;
//           - Added new function:
//             function GetRecArrayLastIndex:integer;
//             This returns the last RECORD Position in the 2-dim array -
//             taking into account the last index usually is blank -
//             so it subtracts 1 from the index to get last filled index.
//
// 05/09/2016 - Added two methods to TUsefulRoutines class:
// function GetValueFromForm(ParentForm:TForm; Formname,ControlName: string):string;
// procedure InsertValueIntoForm(ParentForm:TFORM; Formname,ControlName,Value: string;ControlType:string = 'TEdit');
//

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls, Buttons,
  ExtCtrls, Grids, DBGrids, DB, ADODB, Provider, DBClient,
  SqlExpr, strUtils, sysUtils, inifiles, DateUtils, Variants;

const ADO = 1;
      DBX = 2;

type TstrArray = Array of String;
  TRecArray = Array of Array of String;
  TintArray = Array of Integer;
  TintintArray = Array of Array of Integer; //mainly for grid info like col widths
  TBoolArray = Array of Boolean;

  TDBOperations = class(TObject)
  private
    fADOQuery: TADOQuery;
    fADOTable: TADOTable;
    fSQLQuery: TSQLQuery;
    fRecArray: TRecArray;
    fConnectionString: WideString;
    fQueryString: string;
    fFieldlist: string;
    fValuelist: string;
    fExcludedFields: integer;
    FStringArray: TstrArray;
    fFieldsArray: TstrArray;
    fValuesArray: TstrArray;
    fTableNames: TstrArray;
    fTypesArray: TstrArray;
    fIDArray: TintArray;
    fSingleRecArray: TstrArray;
    fDatabaseName: string;
    fTableCount: integer;

    function PrepareInsert(TableName,FieldNames,FieldValues:string):string;
    function PrepareUpdate(TableName,FieldNames,FieldValues,Filter:string;StartIndex:integer=1):string;overload;
    function PrepareUpdate(TableName, FieldNames, FieldValues, Filter,ExcludeList: string;StartIndex:integer=1): string;overload;
    function PrepareDelete(TableName, Filter: string): string;
    function GetConnectionString: widestring;
    function GetTablenames: TstrArray;
    function GetfFieldsArray:TstrArray;
    function GetfValuesArray:TstrArray;

    function GetTableCount: integer;
    procedure SetfFieldsArray(const FieldArray: TstrArray);
    procedure SetfValuesArray(const ValueArray: TstrArray);
    procedure AddTablename(tablename: string);
    procedure SetConnectionString(connString: widestring);
    procedure SetTablenames(StringArray: TstrArray);

    procedure SetTableCount(TheTableCount:integer);

  public
    queryMessage: string;
    errorMessage: string;
    errorMessage2: string;
    errorNumber: integer;
    exceptionMessage: string;
    errorFlag: boolean;
    variantArray: Variant;
    RecArray: TRecArray;
    SingleRecArray: TstrArray;
    ExcludeArray: TBoolArray;
    TotalRecords: integer;
    recFilter: string;
    recFilterArray: TstrArray;

    function StringArrayToString(TheArray:TstrArray; SubString: string): string;
    function StrToStringArray(TheString, SubString:string):TstrArray;overload;
    function StrToStringArray(TheString, SubString:string; StartIndex:integer): TstrArray;overload;
    function VariantToStr(V: Variant; IncludeType: Boolean = False): string;
    function VarArrayToStr(v: Variant; Delimiter: Char = #44; LineDelimiter: Char = #13): string;
    function DateForSQL(const date: TDate; hash:Boolean=false): string;
    function DateTimeForSQL(const dateTime : TDateTime; hash:boolean=false) : string;
    function TimeForSQL(const time: TTime; hash:Boolean=false): string;
    function SearchDateField(DBTable,ConnString,SearchDateField: string;
      SearchDate: TDateTime; MatchTime: boolean; AdditionalFilter:string = '';
      ChangeQueryString: boolean = FALSE; SplitDateTime:boolean = FALSE): integer;
    function SelectDates(DBTable,ConnString,SearchDateField: string;
      SortField: string; ReverseDirection: boolean; DateFrom,DateTo: TDateTime;
      ChangeQueryString:boolean = FALSE): integer;overload;
    function SelectDates(DBTable,ConnString,SearchDateField: string;
      SortField: string; ReverseDirection: boolean; DateFrom,DateTo: TDateTime;
      Filter:string; ChangeQueryString:boolean = FALSE): integer;overload;
    function ConvertStringListToStrArray(StringList: TStringList):TStrArray;
    function SaveIDs(theADOQuery:TADOQuery):integer;
    function GetID(index:integer):integer;
    function ExtractFieldNames(ADOQuery:TADOQuery):string;overload;
    function ExtractFieldNames(connString,DBTable:string):string;overload;
    function UpdateData(TableName: string;
      connString: widestring; FieldList,dataValues,Filter:String;
      FieldExcludeList:String = ''; StartIndex:integer=1):integer;overload;
    function UpdateData(TableName: string;
      connString: widestring; dataValues,Filter:string;
      FieldExcludeList: string = '';StartIndex:integer=1):integer;overload;
    function InsertData(TableName:string; connString:widestring; dataValues:string):integer;overload;
    function InsertData(TableName:string; connString:widestring; fieldList:string; dataValues:string):integer;overload;
    function InsertDBXData(TableName: string; connString: widestring; FieldList, dataValues: string): integer;
    function GetFieldTypes(TableName:string; connString:widestring):string;
    function GetFieldType(FieldName,TableName:string; connString:widestring):string;
    function CreateVariantArray(const MaxElements:integer):Variant;
    function ShowBasicVariantType(varVar: Variant):string;
    function AddVariant(FieldPlaceIndex:integer; Value:Variant): integer;
    function CreateRecArray(AADOQuery: TADOQuery): TRecArray;
    function CreateSingleRecArray(AADOQuery: TADOQuery): TstrArray;
    function GetFieldPosition(TableName,FieldName: String; connString:widestring): integer;
    function SearchField(DBTable,ConnString,SearchField: string; SearchValue: String;
      ChangeQueryString: boolean = FALSE): integer;overload;
    function SearchField(DBTable,ConnString,ReturnField: string;
      SearchField,SearchValue: String; ChangeQueryString: boolean = FALSE): string;overload;
    function GetNewFieldValue(FieldName,FieldValue,TableName,ConnString:string):string;
    function SetupExcludeList(FieldList,ExcludedList:string):integer;
    function WriteChanges(TableName: string; DateTimeOfChange:TDateTime):integer;
    function GetFieldname(TableName: string; FieldPos: integer; conString:widestring):string;
    function MySQL_Use(DataBaseName:string; connString:widestring):boolean;
    function GetNumberOfTables:integer;

    function SearchFields(DBTable,ConnString,SearchFields: string;
      SearchValues,operators: String; SortField:string = ''; ChangeQueryString: boolean = FALSE): integer;
    function GetFieldnamesOfTypesPassed(TableName:string; FieldType:string; conStr:WideString):string;
    function GetTotalRecords(TableName:string; connString:widestring):integer;
    function CreateListFromStringArray(theStringArray: TstrArray; SortList:boolean = TRUE):TStringList;

    function NotInTable(TableName,FieldName:string; ConStr:Widestring): boolean;

    function SaveRecord(theADOQuery: TADOQuery): TstrArray;
    function GetSingleRecArray(index: integer): string;overload;
    function GetSingleRecArray(DBTableName,connectingString,FieldName: string): string;overload;
    function GetRecArray: TRecArray;
    function GetRecArrayValue(DBName:string; conString:widestring; RecordNo:integer; Fieldname:string):string;
    function CreateQuery(ConnString:widestring; cmdString,querystring: string; sortField:string=''; ReverseDir:boolean=FALSE; Filter:string=''):boolean;
    function GetRecArrayLastIndex:integer;
    function GetQueryString: string;
    function GetFieldnames(TableName:string; conString:widestring): TstrArray; overload;
    function GetFieldnames(var FieldList: TStringList; TableName: string; conString: widestring): TstrArray; overload;

    procedure CloseQuery;
    procedure DestroyQuery;
    procedure DeleteData(TableName,Filter:string; connString:widestring);
    procedure SetFields(Fieldlist:string);
    procedure SetValues(Valuelist:string);
    procedure ClearErrors;
    procedure ClearMessages;
    procedure RemoveDuplicates(const theStringList:TStringList);
    procedure MySQL_CreateDatabase(connString:widestring; DBName:string; UseSchema_Command:boolean);
    procedure MySQL_CreateTable(DatabaseName:string; connString: widestring; TableName,
                Fieldnames, FieldTypes, NullValue, DefaultValue: string);

    procedure CreateFilter(Fieldnames,values:string;StartIndex:integer = 0);
    procedure PopulateDropdownFromArray(comboBox: TComboBox; strArray:TstrArray);
    procedure SetQueryString(qryString: string);

    property ADOQuery: TADOQuery read fADOQuery write fADOQuery;
    property ADOTable: TADOTable read fADOTable write fADOTable;
    property FieldsArray: TstrArray read GetfFieldsArray write SetfFieldsArray;
    property ValuesArray: TstrArray read GetfValuesArray write SetfValuesArray;
    property connString: widestring read GetConnectionString write SetConnectionString;
    property CountExcludedFields: integer read fExcludedFields;
    property DatabaseName: string read fDatabaseName write fDatabaseName;
    property QueryString: string read GetQueryString write SetQueryString;
    property TableCount: integer read GetTableCount write SetTableCount;

    Constructor Create;overload;
    Constructor Create(ConnectionString: widestring);overload;
    Destructor Destroy; override;
  end;

  TUsefulRoutines = class(TObject)
  private
    fSerialNumber: uint;
    MaxItems: integer;
    FStringArray: TstrArray;
    function GetSerialNumber: uint;
    function GetItems: TintArray;

    procedure SetSerialNumber(SerialItems:TintArray);
    //property SerialNumber:uint read GetSerialNumber write SetSerialNumber(GetItems);

  protected
    { Protected declarations }


  public
    { Public declarations }
    function StringArrayToString(TheArray:TstrArray; SubString: string): string;
    function StrToStringArray(TheString, SubString: string): TstrArray;overload;
    function StrToStringArray(TheString, SubString:string; StartIndex:integer):TstrArray;overload;
    function GetStringArray:TstrArray;
  published
    function GetGridColumnWidths(DBGrid: TDBGrid):TintArray;
    function SetGridColumns(DBGrid: TDBGrid; MaxRows:integer; offset:integer = 0): TintArray;
    function GetValueFromForm(ParentForm:TForm; Formname,ControlName: string):string;
    procedure InsertValueIntoForm(ParentForm:TFORM; Formname,ControlName,Value: string;ControlType:string = 'TEdit');
  end;

  TDBConnections = class(TObject)
  private
    { Private declarations }
    fADOConnection: TADOConnection;
    fDBXConnection: TSQLConnection;
    fDBOperations: TDBOperations;
    fADOQuery: TADOQuery;
    fADOTable: TADOTable;
    FStringArray: TstrArray;
    fConnectionString:widestring;
    fProviderString:string;
    fSecurityInfoString:string;
    fDriverString:string;
    fServerString:string;
    fUsernameString:string;
    fPasswordString:string;
    fDatabaseName:string;
    fPortString:string;
    fDynamicCursorString:string;
    fNoBigIntString:string;
    fPersistantSecurityBool:boolean;
    fDynamicCursorBool:boolean;
    fNoBigIntBool:boolean;
    fUserID: UInt64;

    procedure SetConnString(ConnectionString:widestring);
    procedure SetProviderString(ProviderString:string);
    procedure SetSecurityInfoString(SecurityInfoString:string);
    procedure SetDriverString(DriverString:string);
    procedure SetServerString(ServerString:string);
    procedure SetUsernameString(UsernameString:string);
    procedure SetPasswordString(PasswordString:string);
    procedure SetDatabaseName(DatabaseNameString:string);
    procedure SetPortString(PortString:string);
    procedure SetDynamicCursorString(DynamicCursor:string);
    procedure SetNoBigIntString(BigInt:string);
    procedure SetfUserID(userid:UInt64);

    function GetConnString:widestring;
    function GetProviderString:string;
    function GetSecurityInfoString:string;
    function GetDriverString:string;
    function GetServerString:string;
    function GetUsernameString:string;
    function GetPasswordString:string;
    function GetDatabaseName:string;
    function GetPortString:string;
    function GetDynamicCursorString:string;
    function GetNoBigIntString:string;
    function GetPersistantSecurityBool:boolean;
    function GetDynamicCursorBool:boolean;
    function GetNoBigIntBool:boolean;
    function GetfUserID:UInt64;
  protected
    { Protected declarations }
  public
    { Public declarations }
    DBMessage: string;
    DBErrors: string;
    function StrToStringArray(TheString, SubString:string):TstrArray;overload;
    function StrToStringArray(TheString, SubString:string; StartIndex:integer): TstrArray;overload;
    function StringToDateTime(strDate,strTime:string; var ErrMsg:string): TDateTime;
    function TestConnection(ConnString:string; Login:boolean=FALSE; DatabaseName:string = 'test'):Boolean;

    procedure OpenConnection(ConnString:string; Login:boolean=FALSE);
    procedure CloseConnection;
    procedure InsertDataFromIniFile;
    procedure ClearErrors;
    procedure ClearMessages;
    procedure InsertValueIntoForm(Formname,ControlName,Value: string);

    property ADOConnection: TADOConnection read fADOConnection write fADOConnection;
    property ConnString:widestring read GetConnString write SetConnString;
    property Provider:string read GetProviderString write SetProviderString;
    property SecurityInfo:string read GetSecurityInfoString write SetSecurityInfoString;
    property Driver:string read GetDriverString write SetDriverString;
    property Server:string read GetServerString write SetServerString;
    property UID:string read GetUsernameString write SetUsernameString;
    property Password:string read GetPasswordString write SetPasswordString;
    property DBName:string read GetDatabaseName write SetDatabaseName;
    property Port:string read GetPortString write SetPortString;
    property DynamicCursorString:string read GetDynamicCursorString write SetDynamicCursorString;
    property NoBigIntString:string read GetNoBigIntString write SetNoBigIntString;
    property Dynamic_Cursor:boolean read fDynamicCursorBool write fDynamicCursorBool;
    property No_BigInt:boolean read fNoBigIntBool write fNoBigIntBool;
    property DBOperations: TDBOperations read fDBOperations write fDBOperations;
    property UserID: UInt64 read GetfUserID write SetfUserID;

    Constructor Create;overload;
    Constructor Create(DBType:string);overload;
    Destructor Destroy; override;
  published
    { Published declarations - includes RTTI info etc.}
    function SetConnectionString_ADOwithMYSQL(Servername,Database,Username,PassWord,Drivername:string; PWBlank:boolean=FALSE):string;
    function SetSecurityInfo(SInfo:boolean):string;

  end;

  TLinkOperations = class(TObject)
  private
    fLinkID: integer; //needs to be unsigned so length of 11 - otherwise may run into trouble if id 65535 or 32768.
    fcomboID: integer;
    fcomboName: string;
  protected
    { Protected declarations }
  public
    { Public declarations }
    function InsertIDs: boolean;

    property LinkID: integer read fLinkID write fLinkID;
    property comboID: integer read fcomboID write fcomboID;
    property comboName: string read fcomboName write fcomboName;

    constructor Create(id1,id2:integer; comboName: string);
    Destructor Destroy; override;
  end;

implementation

{ TDBConnections }

Constructor TDBConnections.Create;
begin
  //set all connection string variables to defaults ready
  //before calling procedure to construct the connection string.
  inherited;
  fADOConnection:= TADOConnection.Create(nil);
  fDBOperations:= TDBOperations.Create;
  fProviderString:= 'MSDASQL.1';
  fSecurityInfoString:= 'Persist Security Info=True';
  fDriverString:= 'MySQL ODBC 5.3 Unicode Driver';
  fServerString:= 'localhost';
  fUsernameString:= 'root';
  fPasswordString:= '';
  fDatabaseName:= 'mysql';
  fPortString:= '3307';
  fDynamicCursorString:= 'DYNAMIC_CURSOR=1';
  fNoBigIntString:= 'NO_BIGINT=1';
  fPersistantSecurityBool:= False;
  fDynamicCursorBool:= True;
  fNoBigIntBool:= True; //BigINT is treated as INT for compatible reasons - MS ACCESS
  self.SetConnString('');
  self.DBMessage:='';
end;

Destructor TDBConnections.Destroy;
begin
  if fADOConnection <> nil then
    FreeAndNil(fADOConnection);
  inherited;
end;

function TDBConnections.GetConnString: widestring;
begin
  Result:= fConnectionString;
end;

function TDBConnections.GetDatabaseName: string;
begin
  Result:= fDatabaseName;
end;

function TDBConnections.GetDriverString: string;
begin
  Result:= fDriverString;
end;

function TDBConnections.GetDynamicCursorBool: boolean;
begin
  Result:= fDynamicCursorBool;
end;

function TDBConnections.GetDynamicCursorString: string;
begin
  Result:= fDynamicCursorString;
end;

function TDBConnections.GetfUserID: UInt64;
begin
  Result:= fUserID;
end;

function TDBConnections.GetNoBigIntBool: boolean;
begin
  Result:= fNoBigIntBool;
end;

function TDBConnections.GetNoBigIntString: string;
begin
  Result:= fNoBigIntString;
end;

function TDBConnections.GetPasswordString: string;
begin
  Result:= fPasswordString;
end;

function TDBConnections.GetPortString: string;
begin
  Result:= fPortString;
end;

function TDBConnections.GetProviderString: string;
begin
  Result:= fProviderString;
end;

function TDBConnections.GetSecurityInfoString: string;
begin
  Result:= fSecurityInfoString;
end;

function TDBConnections.GetServerString: string;
begin
  Result:= fServerString;
end;

function TDBConnections.GetUsernameString: string;
begin
  Result:= fUsernameString;
end;

function TDBConnections.GetPersistantSecurityBool: boolean;
begin
  Result:= fPersistantSecurityBool;
end;

function TDBConnections.SetConnectionString_ADOwithMYSQL(Servername, Database, Username,
  Password, Drivername: string; PWBlank:boolean=FALSE): string;
begin
  //ADOConnection1.Connected:= False;
  //ADOConnection1.LoginPrompt:= False;
  //ADOConnection1.ConnectionString:= strCon;
  //ADOConnection1.Connected:= True;
  //qryData.Open;
end;

function TDBConnections.SetSecurityInfo(SInfo: boolean):string;
var
  searchstring,replacestring: string;
  SearchPos: integer;
begin
  searchstring:= 'Persist Security Info=False;';
  SearchPos:= PosEx(Connstring,searchstring,1);
  if SearchPos>0 then begin
    searchstring:= 'Persist Security Info=False;';
    if SInfo = True then
      replacestring:= 'Persist Security Info=True;'
    else
      replacestring:= 'Persist Security Info=False;';
  end
  else
    searchstring:= 'Persist Security Info=True;';
    if SInfo = True then
      replacestring:= 'Persist Security Info=True;'
    else
      replacestring:= 'Persist Security Info=False;';

  Connstring := StringReplace(Connstring,searchstring,replacestring, [rfIgnoreCase]);
  Result:= Connstring;
end;

procedure TDBConnections.OpenConnection(ConnString:string; Login:boolean=FALSE);
begin
  fADOConnection.Connected:= False;
  if length(ConnString)>0 then
    fADOConnection.ConnectionString:= ConnString
  else
    fADOConnection.ConnectionString:= fConnectionString;
  fADOConnection.LoginPrompt:= Login;
  //use Try ... Finally here and return any connection errors in DBErrors
  self.DBErrors:= '';
  try
    fADOConnection.Connected:= True;
  except
    on e: Exception do
      self.DBOperations.errorMessage2:= 'OpenConnection: '+e.Message;
  end;
end;

function TDBConnections.TestConnection(ConnString:string; Login:boolean=FALSE; DatabaseName:string = 'test'):Boolean;
var
  ConStr: Widestring;
  NoError: boolean;
begin
  NoError:= True;
  fADOConnection.Connected:= False;
  if Length(ConnString)>0 then
    fADOConnection.ConnectionString:= ConnString
  else
    fADOConnection.ConnectionString:= fConnectionString;
  ConStr:= fADOConnection.ConnectionString;
  fADOConnection.LoginPrompt:= Login;
  self.DBErrors:= '';
  //Result:= FALSE;
  try

    //fADOConnection.Connected:= True;
    //self.OpenConnection(ConStr,FALSE);
    if self.DBOperations.MySQL_Use(DatabaseName,ConStr) then begin
    //OK was able to connect to database - no error?
    //if self.DBOperations.MySQL_Use('mysql',ConStr) then begin
      //OK was able to select mysql db
      self.DBOperations.queryMessage:= 'OK mysql DB successfully opened';
      self.DBOperations.errorMessage:= '';
      try
        fADOConnection.Connected:= True;
        if self.DBOperations.MySQL_Use(self.DBName,ConStr) then begin
          self.DBMessage:= 'SUCCESSFUL';
          self.DBOperations.errorMessage:= '';
          self.DBOperations.queryMessage:= 'Successfully opened user database';
          self.DBOperations.errorNumber:= -1;
          Result:= TRUE;
          self.DBOperations.errorFlag:= FALSE;
        end
        else begin
          //so USE test database was sucessful BUT not user-selected database:
          self.DBOperations.errorMessage:= 'Could not connect to: '+self.DBName;
          self.DBOperations.errorNumber:= 4;
        end;
      except
        on E: Exception do begin
          self.DBMessage:= 'Test Connection: '+DatabaseName+' Not EXISTS, '+e.Message;
          self.DBErrors:= 'Test Connection: '+DatabaseName+' Not Exist: '+e.Message;
          self.DBOperations.errorMessage:= 'Test Connection: Cannot open '+DatabaseName+' db, '+e.Message;
          self.DBOperations.errorNumber:= 2;
          self.DBOperations.errorFlag:= TRUE;
          NoError:= False;
        end;
      end; //inner try
    end //if
    else begin
      self.DBOperations.queryMessage:= 'DID NOT CONNECT TO mysql DB: ';
      self.DBOperations.errorMessage:= 'Could NOT connect to database';
      self.DBOperations.errorNumber:= -2;
    end;
  except
    on E: Exception do begin
      self.DBOperations.exceptionMessage:= e.Message;
      self.DBErrors:= 'Test Connection: '+e.Message;
      NoError:= False;
      self.DBOperations.errorMessage:= 'Test Connection: '+e.Message;
      self.DBOperations.errorNumber:= 3;
      //self.SetDatabaseName('mysql');
      self.DBMessage:= 'Database may not exist';
    end;

  end;
  Result:= NoError;
end;

procedure TDBConnections.SetConnString(ConnectionString: widestring);
var
  Constring: widestring;
begin
  if Length(ConnectionString)>0 then
    fConnectionString:= ConnectionString
  else begin
    Constring:= 'Provider='+fProviderString+';';
    if fPersistantSecurityBool = TRUE then begin
      fSecurityInfoString:= 'Persist Security Info=True;';
      Constring:= Constring+'Persist Security Info=True;';
    end
    else begin
      fSecurityInfoString:= 'Persist Security Info=False;';
      Constring:= Constring+'Persist Security Info=False;';
    end;
    Constring:= Constring+'Extended Properties="Driver='+fDriverString+';';
    Constring:= Constring+'SERVER='+fServerString+';';
    Constring:= Constring+'UID='+fUsernameString+';';
    Constring:= Constring+'Password='+fPasswordString+';';
    Constring:= Constring+'DATABASE='+fDatabaseName+';';
    Constring:= Constring+'PORT='+fPortString+';';
    if fDynamicCursorBool = TRUE then begin
      fDynamicCursorString:= 'DYNAMIC_CURSOR=1;';
      Constring:= Constring+'DYNAMIC_CURSOR=1;';
    end
    else begin
      fDynamicCursorString:= 'DYNAMIC_CURSOR=0;';
      Constring:= Constring+'DYNAMIC_CURSOR=0;';
    end;
    if fNoBigIntBool = TRUE then begin
      fNoBigIntString:= 'NO_BIGINT=1;';
      Constring:= Constring+'NO_BIGINT=1;'+chr(34);
    end
    else begin
      fNoBigIntString:= 'NO_BIGINT=0;';
      Constring:= Constring+'NO_BIGINT=0;'+chr(34);
    end;
    fConnectionString:= Constring;
  end;

end;

procedure TDBConnections.SetDatabaseName(DatabaseNameString: string);
begin
  fDatabaseName:= DatabaseNameString;
  self.SetConnString('');
end;

procedure TDBConnections.SetDriverString(DriverString: string);
begin
  fDriverString:= DriverString;
  self.SetConnString('');
end;

procedure TDBConnections.SetDynamicCursorString(DynamicCursor: string);
begin
  fDynamicCursorString:= DynamicCursor;
  self.SetConnString('');
end;

procedure TDBConnections.SetfUserID(userid: UInt64);
begin
  self.fUserID:= userid;
end;

procedure TDBConnections.SetNoBigIntString(BigInt: string);
begin
  fNoBigIntString:= BigInt;
  self.SetConnString('');
end;

procedure TDBConnections.SetPasswordString(PasswordString: string);
begin
  fPasswordString:= PasswordString;
  self.SetConnString('');
end;

procedure TDBConnections.SetPortString(PortString: string);
begin
  fPortString:= PortString;
  self.SetConnString('');
end;

procedure TDBConnections.SetProviderString(ProviderString: string);
begin
  fProviderString:= ProviderString;
  self.SetConnString('');
end;

procedure TDBConnections.SetSecurityInfoString(SecurityInfoString: string);
begin
  fSecurityInfoString:= SecurityInfoString;
  self.SetConnString('');
end;

procedure TDBConnections.SetServerString(ServerString: string);
begin
  fServerString:= ServerString;
  self.SetConnString('');
end;

procedure TDBConnections.SetUsernameString(UsernameString: string);
begin
  fUsernameString:= UsernameString;
  self.SetConnString('');
end;

procedure TDBConnections.CloseConnection;
begin
  self.fADOConnection.Connected:= False;
  //self.fADOConnection.Free;
end;

constructor TDBConnections.Create(DBType: string);
begin
  //connection based on passed DB Type such as DB Express.
  //Possible Create the construction string here from the login ????
  //dont know as it has to insert the facts into the object first.
end;

function TDBConnections.StrToStringArray(TheString, SubString:string): TstrArray;
var
  IDX: integer;
  Elements: integer;
  CommaPos: integer;
  Extract:string;
begin
  IDX:=0;
  SetLength(FStringArray,0);
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

function TDBConnections.StringToDateTime(strDate, strTime: string; var ErrMsg:string): TDateTime;
var
  dtDate,dtTime: TDateTime;
  NewDate,NewTime: TDateTime;
  NewDateYear,NewDateMonth,NewDateDay: Word;
  NewTimeHour,NewTimeMin,NewTimeSec,NewTimeMsec: Word;
  IsDateOK,IsTimeOK: Boolean;
  formatSettings : TFormatSettings;
begin
  IsDateOK:= False;
  IsTimeOK:= False;
  ErrMsg:= '';
  GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, formatSettings);
  //NewDate:= StrToDate(strDate,formatSettings);
  if Length(strDate)>0 then begin
    IsDateOK:= TrystrToDate(strDate,dtDate);
    if NOT IsDateOK then begin
      ErrMsg:= 'Error: Date Not Valid';
    end;
  end;

  if Length(strTime)>0 then begin
    IsTimeOK:= TrystrToTime(strTime,dtTime);
    if NOT IsTimeOK then begin
      if Length(ErrMsg)>0 then
        ErrMsg:= ErrMsg+' and Time Not Valid'
      else begin
        NewTime:= StrToTime(strTime,formatSettings);
        ErrMsg:= ErrMsg+' Error: Time Not Valid';
      end;
    end; //if
  end; //if
  //if (NOT IsDateOK) OR (NOT IsTimeOK) then exit; not the same as the following:
  if IsDateOK AND IsTimeOK then begin

    NewDateYear:= YearOf(dtDate);
    NewDateMonth:= MonthOf(dtDate);
    NewDateDay:= DayOf(dtDate);
    NewTimeHour:= HourOf(dtTime);
    NewTimeMin:= MinuteOf(dtTime);
    NewTimeSec:= SecondOf(dtTime);
    NewTimeMSec:= MilliSecondOf(dtTime);
    dtDate:= EncodeDateTime(NewDateYear,NewDateMonth,NewDateDay,NewTimeHour,NewTimeMin,NewTimeSec,NewTimeMSec);

  end;
  Result:= dtDate;

end;

function TDBConnections.StrToStringArray(TheString, SubString:string; StartIndex:integer): TstrArray;
var
  IDX: integer;
  CommaPos: integer;
  Extract:string;
  SaveIdx: integer;
begin
  IDX:= 0;
  SetLength(FStringArray,0);
  SaveIdx:= StartIndex; //index result array at startIndex i.e. allows index to start at 1 not 0
  //this will automatically create a dummy - uninitialised element of zero.
  //while (PosEx(SubString,TheString,IDX+1)>0) do begin
  if StartIndex>0 then SetLength(FStringArray,Length(FStringArray)+StartIndex);
  Repeat
    Extract:= '';
    CommaPos:= PosEx(SubString,TheString,IDX+1);
    if CommaPos>0 then
      Extract:= Copy(TheString,IDX+1,(CommaPos-(IDX+1)))
    else
      Extract:= Copy(TheString,IDX+1,Length(TheString));
    SetLength(FStringArray,Length(FStringArray)+1);
    FStringArray[SaveIdx]:= Extract;
    SaveIdx:= SaveIdx+1;
    IDX:=CommaPos;
  Until CommaPos = 0;
  //end; {while}

  Result:= FStringArray;
end;

procedure TDBConnections.InsertDataFromIniFile;
var
  Hostname,Database,Username,Port: string;
  Section: string;
  DBINI: TIniFile;
begin
  //Get connection details from ini file:
  if FileExists(ChangeFileExt(Application.ExeName,'.ini')) then begin
    DBINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
    try
      Section:= Trim('DatabaseSettings'+IntToStr(1));
        Hostname := DBINI.ReadString(Section,'Hostname', Hostname) ;
        Database := DBINI.ReadString(Section,'Database', Database) ;
        Username := DBINI.ReadString(Section,'Username', Username) ;
        Port := DBINI.ReadString(Section,'Port', Port) ;
    finally
      DBINI.Free;
    end;
  end; {if}
  self.Server:= Hostname;
  self.DBName:= Database;
  self.UID:= Username;
  self.Port:= Port;
end;

procedure TDBConnections.InsertValueIntoForm(Formname, ControlName,
  Value: string);
var
  FormControl: TControl;
  Panels: TWincontrol;
  idx: integer;
begin
  idx:= 0;
  //while idx< MDIChildCount do

end;

procedure TDBConnections.ClearErrors;
begin
  self.DBErrors:= '';
end;

procedure TDBConnections.ClearMessages;
begin
  self.DBMessage:= '';
end;

{ TDBOperations }

procedure TDBOperations.CloseQuery;
begin
    if Assigned(self.fADOQuery) then begin
      self.fADOQuery.Close;
      //FreeAndNil(self.fADOQuery);
    end;
end;

function TDBOperations.DateForSQL(const date: TDate; hash:Boolean=false): string;
var
  y, m, d : word;
  strDate: string;
begin
  DecodeDate(date, y, m, d) ;
  //result := Format('#%.*d-%.*d-%.*d#',[4, y, 2, m, 2, d]) ;
  if hash then
    strDate:= FormatDateTime('#yyyy-mm-dd#',date)
  else
    strDate:= FormatDateTime('yyyy-mm-dd',date);
  Result:= strDate;
end;

function TDBOperations.TimeForSQL(const time: TTime; hash:Boolean=false): string;
var
  hour, min, sec,msec : word;
  strTime: string;
begin
  DecodeTime(time, hour, min, sec,msec) ;
  //result := Format('#%.*d-%.*d-%.*d#',[4, y, 2, m, 2, d]) ;
  if hash then
    strTime:= FormatDateTime('#hh.nn.ss#',time)
  else
    strTime:= FormatDateTime('hh:nn:ss',time);
  Result:= strTime;
end;

function TDBOperations.DateTimeForSQL(const dateTime : TDateTime; hash:boolean=false) : string;
begin
  if hash then
   result := FormatDateTime('#yyyy-mm-dd hh.nn.ss#', dateTime)
  else
    Result:= FormatDateTime('yyyy-mm-dd hh:nn:ss', dateTime);
end;

function TDBOperations.ConvertStringListToStrArray(StringList: TStringList):TStrArray;
var
  strItems: string;
  TotalStrings: integer;
  strArray: TStrArray;
begin
  TotalStrings:= StringList.Count;
  strItems:= StringList.CommaText;
  strArray:= self.StrToStringArray(strItems,',');
  Result:= strArray;
  self.queryMessage:= 'Total Strings='+IntToStr(TotalStrings)+', Elements='+IntToStr(Length(strArray));
end;

function TDBOperations.SaveIDs(theADOQuery:TADOQuery):integer;
var
  idx: integer;
begin
  theADOQuery.First;
  idx:=0;
  SetLength(self.fIDArray,0);
  SetLength(self.fIDArray,Length(self.fIDArray)+1);
  while NOT theADOQuery.Eof do begin
    //primary key = Fields.DataType = ftAutoint
    fIDArray[idx]:= theADOQuery.Fields[0].Value;
    idx:= idx+1;
    theADOQuery.Next;
    SetLength(self.fIDArray,Length(self.fIDArray)+1);
  end;
  Result:= idx;
end;

function TDBOperations.SaveRecord(theADOQuery: TADOQuery): TstrArray;
var
  Recidx: integer;
begin
  //Could check if the Query is empty first with If Not theADOQuery.EOF ???
  //but then the result array will only contain one blank element and not the
  //number corresponding to the amount of fields in the table ????
  //ALSO this ONLY saves the FIRST record found - so if more than one record
  // exists in the query - they will be ignored !!!
  // - updated 11-09-2016 at 12:48
  // hmmm OK lets use RecArray public variable to store all the records in the
  // query as well.
  theADOQuery.First;
  Recidx:= 0;
  SetLength(self.fSingleRecArray,0);
  SetLength(self.fSingleRecArray,Length(self.fSingleRecArray)+1);
  while Recidx< theADOQuery.FieldCount do begin //need = too ???
    //need to convert to string.
    self.fSingleRecArray[Recidx]:= theADOQuery.Fields[Recidx].AsString;
    Recidx:= Recidx+1;
    //theADOQuery.Next; - will advance to next record if needed.
    SetLength(self.fSingleRecArray,Length(self.fSingleRecArray)+1);
  end;
  Result:= self.fSingleRecArray;
end;

function TDBOPerations.ExtractFieldNames(ADOQuery:TADOQuery):string;
var
  FieldList: TStringList;
  FinalList: string;
  FieldArray: TstrArray;
begin
  FieldList:= TStringList.Create;
  try
    try
      ADOQuery.GetFieldNames(FieldList);
      FinalList:= FieldList.CommaText;
      self.fFieldlist:= FinalList;
      setLength(FieldArray,FieldList.Count+1);
      FieldArray:= self.ConvertStringListToStrArray(FieldList);
      self.fFieldsArray:= FieldArray;
    except on E: Exception do begin
        self.errorMessage:= 'Error in ExtractFieldNames: '+e.Message;
      end;

    end;
  finally
    FreeAndNil(FieldList);
  end;
  Result:= FinalList;
end;

function TDBOPerations.ExtractFieldNames(connString,DBTable:string):string;
var
  FieldList: TStringList;
  ADOQuery: TADOQuery;
  FinalList: string;
begin
  ADOQuery:= TADOQuery.Create(nil);
  FinalList:= '';
  try
    FieldList:= TStringList.Create;
    ADOQuery.ConnectionString:= connString;
    ADOQuery.close;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add('SELECT * FROM '+DBTable);
    ADOQuery.GetFieldNames(FieldList);
    FinalList:= FieldList.CommaText;
  finally
    FreeAndNil(ADOQuery);
    FreeAndNil(FieldList);
  end;
  Result:= FinalList;
end;

function TDBOperations.MySQL_Use(DataBaseName:string; connString:widestring):boolean;
var
  cmdSQL: string;
  ADOQuery: TADOQuery;
  NoError: boolean;
begin
  //First TEST if we can connect to the user-specified database in MYSQL.
  //- if not then test if we can connect to the default database - mysql.
  //- so if we can then we know the username and password are OK,
  //this may suggest that the specified database does NOT Exist ?
  //TEST if we can connect to the default database - MYSQL.
  //if we cannot - then something wrong with login details.
  //need it to return the actual mysql error - database not exist or access denied.
  NoError:= TRUE;
  self.errorNumber:= 0;
  ADOQuery:= TADOQuery.Create(nil);
  try
    //try
      ADOQuery.ConnectionString:= connString;
      ADOQuery.Close;

      ADOQuery.SQL.Clear;
      ADOQuery.SQL.Add('use '+DataBaseName);
      ADOQuery.ExecSQL;
    {except
      on E: Exception do
      begin
        //raise;
        //HERE IS WHERE WE GET AN unspecified error in general.
        //so if we are here then it means we cannot -use database- that has been passed.
        //do we still get here even if the password is wrong but the database exists ?
        //should return mysql error saying access denied
        self.exceptionMessage:= e.Message;
        self.errorMessage:= 'Cannot connect to database : '+E.Message;
        self.queryMessage:= 'Cannot connect to database : '+E.Message;
        self.errorNumber:=1; //fundamental - cannot connect to specified database.
        NoError:= FALSE;
      end;//
    end; }
  finally
    FreeAndNil(ADOQuery);
  end;
  Result:= NoError;
end;

function TDBOperations.NotInTable(TableName, FieldName: string; ConStr:Widestring): boolean;
var
  FieldPosition: integer;
begin
  FieldPosition:= self.GetFieldPosition(TableName,FieldName,ConStr);
  if FieldPosition = -1 then
    Result:= TRUE
  else
    Result:= FALSE;
end;

//procedure USE() to select MySQL Database

constructor TDBOperations.Create;
begin
  inherited;
  //fADOConnection:= TDBConnections.Create;
  self.queryMessage:= '';
  self.errorMessage:= '';
  self.DatabaseName:= '';
  self.QueryString:= '';
  SetLength(self.fFieldsArray,Length(self.fFieldsArray)+1);
  SetLength(self.fValuesArray,Length(self.fValuesArray)+1);
  SetLength(self.fTypesArray,Length(self.fTypesArray)+1);

end;

constructor TDBOperations.Create(ConnectionString: widestring);
begin
  //inherited;
  //fADOConnection:= TDBConnections.Create;
  self.queryMessage:= '';
  self.errorMessage:= '';
  self.DatabaseName:= '';
  self.QueryString:= '';
  SetLength(self.fFieldsArray,Length(self.fFieldsArray)+1);
  SetLength(self.fValuesArray,Length(self.fValuesArray)+1);
  SetLength(self.fTypesArray,Length(self.fTypesArray)+1);

  self.connString:= ConnectionString;
end;

procedure TDBOperations.CreateFilter(Fieldnames, values: string;
  StartIndex: integer);
begin
  //CREATE FILTER:
end;

procedure TDBOperations.MySQL_CreateDatabase(connString:widestring; DBName: string; UseSchema_Command: boolean);
var
  cmdSQL: string;
  ADOQuery: TADOQuery;
begin
  ADOQuery:= TADOQuery.Create(nil);
  if UseSchema_Command then
    cmdSQL:= 'CREATE SCHEMA IF NOT EXISTS '+DBName
  else
    cmdSQL:= 'CREATE DATABASE IF NOT EXISTS '+DBName;
  try
    ADOQuery.ConnectionString:= connString;
    ADOQuery.Close;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add(cmdSQL);
    ADOQuery.ExecSQL;
    //need to issue command: use dbname
    self.DatabaseName:= DBName;
  finally
    FreeAndNil(ADOQuery);
  end;
end;

procedure TDBOperations.MySQL_CreateTable(DatabaseName:string; connString: widestring; TableName,
  Fieldnames, FieldTypes, NullValue, DefaultValue: string);
var
  cmdSQL: string;
  SQLLine: string;
  ADOQuery: TADOQuery;
  FieldsArray: TstrArray;
  TypesArray: TstrArray;
  NullValueArray: TstrArray;
  DefaultValueArray: TstrArray;
  idx: integer;
  TestString: string;
  FieldElements: integer;
  OKCreated: integer;
  ElementIndex: integer;
begin
  ADOQuery:= TADOQuery.Create(nil);
  //cmdSql:= 'use '+self.DBNAME;
  ADOQuery.ConnectionString:= connString;
  ADOQuery.Close;
  ADOQuery.SQL.Clear;
  ADOQuery.SQL.Add('USE '+DatabaseName);
  ADOQuery.ExecSQL;
  //The following string WORKS !!!
  TestString:= 'CREATE TABLE IF NOT EXISTS '+TableName;
  TestString:= TestString+' ('+'id'+' int(10) unsigned NOT NULL AUTO_INCREMENT';
  TestString:= TestString+', PRIMARY KEY ('+'id'+')';
  TestString:= TestString+') ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;';

  ElementIndex:= 0;
  setLength(FieldsArray,1);
  setLength(TypesArray,1);
  setLength(NullValueArray,1);
  setLength(DefaultValueArray,1);
  FieldsArray:= self.StrToStringArray(Fieldnames,',');
  TypesArray:= self.StrToStringArray(FieldTypes,',');
  NullValueArray:= self.StrToStringArray(NullValue,',');
  DefaultValueArray:= self.StrToStringArray(DefaultValue,',');
  FieldElements:= Length(FieldsArray);
  self.queryMessage:= '';
  if (Length(TypesArray)<FieldElements) then begin
    self.queryMessage:= ' Not Enough TYPE elements in Table '+TableName+':'+IntToStr(Length(TypesArray));
  end
  else
    ElementIndex:= ElementIndex+1;
  if (Length(NullValueArray)<FieldElements) then begin
    self.queryMessage:= self.queryMessage+chr(10)+chr(13)+' '+
      ' Not Enough Null Elements in Table '+TableName+':'+IntToStr(Length(NullValueArray));
  end
  else
    ElementIndex:= ElementIndex+2;
  if (Length(DefaultValueArray)<FieldElements) then begin
    self.queryMessage:= self.queryMessage+chr(10)+chr(13)+' '+
      ' Not Enough Default Elements in Table '+TableNAme+':'+IntToStr(Length(DefaultValueArray));
  end
  else
    ElementIndex:= ElementIndex+4;
  if ElementIndex = 7 then begin
    self.queryMessage:= 'OK TABLE CREATED: '+TableName+' -Type Elements:'+
    IntToStr(Length(TypesArray))+' Null Elements:'+IntToStr(Length(NullValueArray))+
    ' Default Elements:'+IntToStr(Length(DefaultValueArray));
    self.TableCount:= self.TableCount+1;
  end;
  idx:= 0;
  cmdSql:= 'CREATE TABLE IF NOT EXISTS '+TableName+' (';

  while idx< Length(FieldsArray) do begin
    //build up command string - putting in each field and its type:
    SQLLine:= FieldsArray[idx]+' '+TypesArray[idx]+' ';
    if Length(NullValueArray[idx])=0 then
      SQLLine:= SQLLine+'NOT NULL'
    else
      SQLLine:= SQLLine+NullValueArray[idx];
    if Length(DefaultValueArray[idx])>0  then begin
      if AnsiPos('AUTO_',Uppercase(DefaultValueArray[idx]))>0 then
        SQLLine:= SQLLine+' '+DefaultValueArray[idx]
      else if Length(DefaultValueArray[idx])>0 then
        SQLLine:= SQLLine+' DEFAULT '+DefaultValueArray[idx];
    end; //if LENGTH()

      cmdSql:= cmdSql+SQLLine+',';
    idx:= idx+1;
  end; //end while
  cmdSql:= cmdSql+'PRIMARY KEY ('+FieldsArray[0]+')';
  cmdSql:= cmdSql+') ENGINE=MyISAM AUTO_INCREMENT=1 DEFAULT CHARSET=utf8;';
  //self.queryMessage:= self.queryMessage+', Command SQL= '+cmdSql;
  try
    ADOQuery.ConnectionString:= connString;
    ADOQuery.Close;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add(cmdSql);
    OKCreated:= ADOQuery.ExecSQL;
    if OKCreated = 0 then
      //syntax not quite right here - raise EUpdateFailed.Create('Error Occurred during execution')

    else
      self.queryMessage:= self.queryMessage+chr(10)+chr(13)+' -Error';
      //' Error - Table Not Created'

  finally
    FreeAndNil(ADOQuery);
  end;
end;



procedure TDBOperations.DeleteData(TableName,Filter:string; connString:widestring);
var
  cmdSQL: string;
  ADOQuery: TADOQuery;
begin
  //DELETE FROM tablename WHERE ID= id value
  ADOQuery:= TADOQuery.Create(nil);
  cmdSQL:= self.PrepareDelete(TableName,Filter);
  try
    ADOQuery.ConnectionString:= connString;
    ADOQuery.Close;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add(cmdSQL);
    ADOQuery.ExecSQL;
  finally
    FreeAndNil(ADOQuery);
  end;
end;

destructor TDBOperations.Destroy;
begin
  //getting ACCESS VIOLATION ERROR

  if Assigned(self.fADOQuery) then
    if self.fADOQuery <> nil then FreeAndNil(self.fADOQuery);
  if Assigned(self.fADOTable) then
    if self.fADOTable <> nil then FreeAndNil(self.fADOTable);
  inherited;
end;



procedure TDBOperations.DestroyQuery;
begin
  if fADOQuery <> nil then
    FreeAndNil(fADOQuery);
end;

function TDBOperations.CreateQuery(ConnString:widestring; cmdString,querystring: string; sortField:string=''; ReverseDir:boolean=FALSE; Filter:string=''):boolean;
var
  FieldNames: TStringList;
  FieldsOK: boolean;
  TableName: string;
  FromPos: integer;
  StartTableNamePos: integer;
  EndTableNamePos: integer;
  NumberOfChars: integer;
begin
  FieldsOK:= TRUE;
  if Assigned(self.fADOQuery) then
    self.fADOQuery:= nil;
  fADOQuery:= TADOQuery.Create(nil);
  FieldNames:= TStringList.Create;
  try
    if Length(ConnString)>0 then
      fADOQuery.ConnectionString:= ConnString
    else
      fADOQuery.ConnectionString:= self.fConnectionString;
    //ensure that the database is open and connected for query to work.
    //also ensure that the fields passed for the sortField actually exists in the table.
    //


    if Length(querystring)>0 then begin
      //Extract the TableName from the Query passed:
      FromPos:= PosEx('FROM',querystring,1);
      EndTableNamePos:= PosEx(' ',querystring,FromPos+5);
      StartTableNamePos:= FromPos+5;
      if EndTableNamePos = 0 then
        NumberOfChars:= Length(querystring)-(StartTableNamePos-1)
      else
        NumberOfChars:= EndTableNamePos-StartTableNamePos;
      TableName:= Copy(querystring,StartTableNamePos,NumberOfChars);
      //Could test if tablename exists in database ???
      if (Length(TableName)=0) then begin
        //(self.GetFieldPosition(TableName,sortField,ConnString) = -1) then begin
        Result:= FALSE;
        //self.errorMessage:= 'Error: '+sortField+' NOT in table '+TableName;
        self.errorMessage:= 'Error: TableName is blank';
        exit;
      end;
    end //Length(querystring)
    else begin
      //create a new query ? but will need tablename passed.
    end;
    if (Length(cmdString)=0) OR (UpperCase(cmdString)='SELECT') then begin

      if ansipos('WHERE',Uppercase(querystring))=0 then begin

        if Length(Filter)>0 then
          querystring:= querystring+' WHERE '+Filter;
        if (Length(sortField)>0) then begin
          if (ansipos('DESC',Uppercase(sortField))=0) AND  (ReverseDir) then
            sortField:= sortField+' DESC';
          if (ansipos('ORDER BY',Uppercase(querystring))=0) then
            querystring:= querystring+' ORDER BY '+sortField;
        end
        else begin
          //no sort field - ordered by primary key by default - I assume.
        end;
      end;
      fADOQuery.Close;
      fADOQuery.SQL.Clear;
      fADOQuery.SQL.Add(querystring);
      //The following line can produce a FAIL error if no records exist.
      fADOQuery.GetFieldNames(FieldNames); //Yep this works!
      fFieldsArray:= self.ConvertStringListToStrArray(FieldNames);
      //fFieldsArray:= FieldNames;
      self.queryMessage:= 'Connection String: '+fADOQuery.ConnectionString;
      self.queryMessage:= self.queryMessage+'First field= '+fFieldsArray[0];
      fADOQuery.Open;
      self.TotalRecords:= fADOQuery.RecordCount;
    end //if cmd=SELECT or empty
    else begin //INSERT,UPDATE,DELETE
      self.queryMessage:= 'HIT INSERT.UPDATE.DELETE part';
      fADOQuery.Close;
      fADOQuery.SQL.Clear;
      fADOQuery.SQL.Add(querystring);
      fADOQuery.ExecSQL;
    end;
    self.QueryString:= querystring;
  finally
    FreeAndNil(FieldNames);
  end;
  Result:= FieldsOK;
end;

function TDBOperations.GetRecArray: TRecArray;
begin
  Result:= self.fRecArray;
end;

function TDBOperations.GetRecArrayLastIndex: integer;
var
  LastIndex: integer;
  HighestIndex: integer;
  idx: integer;
begin
  idx:= -1;
  if self.RecArray <> nil then begin
    HighestIndex:= high(self.RecArray); //7
    idx:= HighestIndex; //7
    //need to get the index of the primary key field as dangerous
    //  to assume that it will be the first field.
    while idx>=0 do begin
      if Length(self.RecArray[idx][0])>0 then begin
        Result:= idx;
        exit;
      end;
      idx:= idx-1;
    end;
    Result:= idx;
  end;
end;

function TDBOperations.GetRecArrayValue(DBName:string; conString:widestring; RecordNo:integer; Fieldname:string):string;
var
  FieldIndex: integer;
  RecArrayValue: string;
begin
  RecArrayValue:= '';
  if Assigned(self.fRecArray) then begin

    if Length(FieldName)>0 then begin
      FieldIndex:= self.GetFieldPosition(DBName,FieldName,conString);
      RecArrayValue:= self.fRecArray[RecordNo,FieldIndex];

    end;
  end;
  Result:= RecArrayValue;
end;

function TDBOperations.GetSingleRecArray(index: integer): string;
begin
  //First overloaded version:
  if Index<Length(self.fSingleRecArray) then
    Result:= self.fSingleRecArray[index]
  else
    Result:= '';
end;

function TDBOperations.GetSingleRecArray(DBTableName, connectingString,
  FieldName: string): string;
var
  FieldIndex: integer;
begin
  //Second overloaded version:
  FieldIndex:= self.GetFieldPosition(DBTableName,FieldName,connectingString);
  if FieldIndex<Length(self.fSingleRecArray) then
    Result:= self.fSingleRecArray[FieldIndex]
  else
    Result:= '';
end;

function TDBOperations.CreateRecArray(AADOQuery: TADOQuery): TRecArray;
var
  Rows,Cols: integer;
  Value: string;
  FieldList: string;
  FieldArray: TstrArray;
begin
  //does this function need to alter the QueryString property ??
  try
    Rows:= 1; //first record goes into element 1 of the 2-dimensional array NOT 0 so 1st record not missed.
    FieldList:= self.ExtractFieldNames(AADOQuery);
    SetLength(RecArray,AADOQuery.RecordCount+2,Length(FieldsArray)+1);

    //self.RecArray[0][0]:= IntToStr(FieldPosition);
    AADOQuery.First;
    while NOT AADOQuery.Eof do begin
      Cols:= 0;
      while Cols< Length(FieldsArray) do begin
        Value:= AADOQuery.FieldByName(self.FieldsArray[Cols]).AsString;
        //test value is not blank. record row number.
        //if (Cols = FieldPosition) And (Length(Value)=0) then
          //value in specified field is blank.
        if Rows=1 then
          self.RecArray[0][Cols]:= FieldsArray[Cols];
        self.RecArray[Rows][Cols]:= Value;
        Cols:= Cols+1;
      end;
      Rows:= Rows+1;
      AADOQuery.Next;
    end;
  finally
    //always executed- if try fails will also call anything here.
  end;

  Result:= self.RecArray;
end; //CreateRecArray

function TDBOperations.CreateSingleRecArray(AADOQuery: TADOQuery): TstrArray;
var
  QueryRows,QueryCols: integer;
  Value: string;
  FieldList: string;
  FieldArray: TstrArray;
begin
  //does this function need to alter the QueryString property ??
  //OK the purpose of this function is to return all columns from the single
  //   record chosen. Therefore some kind of filter is needed.
  //   Needs the record position index  - first dim array - passed in also.
  //   no need for inner and outer loop as only single dim array returned.
  //
  //hmmmm interesting situation here - the SingleRecArray is NOT initialised -
  // - but added to - the memory for the elements are increased by 1 -
  // even though the element indexes may be used again ??? the actual array
  // here will grow longer and longer ????????
  // as this function is used again and again withing the same run of the
  // application !! ????
  QueryRows:= 1; //record found goes into single-dimensional array NOT 0 so 1st record not missed.
  FieldList:= self.ExtractFieldNames(AADOQuery);
  SetLength(SingleRecArray,Length(SingleRecArray)+1);

  //self.RecArray[0][0]:= IntToStr(FieldPosition);
  AADOQuery.First;
  while NOT AADOQuery.Eof do begin
    QueryCols:= 0;
    while QueryCols< Length(FieldsArray) do begin
      Value:= AADOQuery.FieldByName(self.FieldsArray[QueryCols]).AsString;
      //test value is not blank. record row number.
      //if (Cols = FieldPosition) And (Length(Value)=0) then
        //value in specified field is blank.
      self.SingleRecArray[QueryCols]:= Value;
      SetLength(SingleRecArray,Length(SingleRecArray)+1);
      QueryCols:= QueryCols+1;
    end;
    QueryRows:= QueryRows+1;
    AADOQuery.Next;
  end;
  self.fSingleRecArray:= self.SingleRecArray;
  Result:= self.SingleRecArray; //will actually return last record.
end; //CreateRecArray

function TDBOperations.SearchField(DBTable,ConnString,SearchField: string;
  SearchValue: String; ChangeQueryString: boolean = FALSE): integer;
var
  NewYear,NewMonth,NewDay: word;
  NewHour,NewMin,NewSec,MSec: word;
  NewDate:string;
  NewTime:string;
  RecordID,i: integer;
  NewInteger: integer;
  NewDouble: double;
  SQLQuery, newSearch: string;
  searchQuery: TADOQuery;
  FieldType: string;
begin
  RecordID:= 0;
  if self.NotInTable(DBTable,SearchField,ConnString) then begin
    self.errorMessage:= 'Error: '+SearchField+' NOT in table: '+DBTable;
    Result:= -1;
    exit;
  end;
  //This function changes the value of QueryString

  //DecodeDate EXTRACTS the date into its word parts
  //EncodeDate FORMS the date FROM the word parts into a NEW DATE.
  //DecodeDateTime(SearchDate,NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,MSec);
  //NewDate:= EncodeDateTime(NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,MSec);

  //GetFieldNames system function fails when bad date in database:
  //First chance exception at - Exception class EOleException with message
  // Data provider or other service returned an E_FAIL status
  FieldType:= '';
  SQLQuery:= '';
  FieldType:= self.GetFieldType(SearchField,DBTable,ConnString);
  if (FieldType = 'ftInteger') or (FieldType = 'ftAutoInc') then begin
    NewInteger:= StrToIntDef(SearchValue,0);
    SQLQuery:= 'SELECT * FROM '+DBTable+' WHERE '+SearchField+' = '+IntToStr(NewInteger);
  end
  else if FieldType = 'ftDouble' then begin
    NewDouble:= StrToFloat(SearchValue);
    SQLQuery:= 'SELECT * FROM '+DBTable+' WHERE '+SearchField+' = '+FloatToStr(NewDouble);
  end
  else
    SQLQuery:= 'SELECT * FROM '+DBTable+' WHERE '+SearchField+' like '+chr(39)+'%'+SearchValue+'%'+chr(39);
    //if any more searchfields then add:
    //SQLQuery:= SQLQuery+' AND Time('+SearchDateField+') like '+chr(39)+'%'+NewTime+'%'+chr(39);
  searchQuery:= TADOQuery.Create(nil);
  try
    searchQuery.ConnectionString:= ConnString;
    searchQuery.Close;
    searchQuery.SQL.Clear;
    if ChangeQueryString then
      self.QueryString:= SQLQuery;

    //searchQuery.ParamCheck:= True;
    //searchQuery.Parameters.AddParameter.Name:= 'DateVal';
    //searchQuery.Parameters.AddParameter.DataType:= ftDateTime;
    //searchQuery.Parameters.AddParameter.Value:= SearchDate;
    //searchQuery.Parameters.AddParameter.Direction in or output ?
    searchQuery.SQL.BeginUpdate;
    searchQuery.SQL.Add(SQLQuery);
    searchQuery.SQL.EndUpdate;
    //searchQuery.Parameters.ParamByName('DateVal').DataType:= ftString;
    //searchQuery.Parameters.ParamByName('DateVal').Value:= FormatFloat('yyyy-mm-dd hh:nn:ss',NewDate);
    //The following produces error - arguments are of the wrong type ...
    //beep;
    //searchQuery.Parameters.ParamByName('DateVal').DataType:= ftDateTime;
    //searchQuery.Parameters.ParamByName('DateVal').Value:= NewDate;
    //searchQuery.Parameters.ParamValues['DateVal']:= NewDate;
    {for i:=0 to searchQuery.Parameters.Count-1 do begin
      if searchQuery.Parameters.Items[i].Name = 'dateval' then
        searchQuery.Parameters.Items[i].Value := SearchDate;
    end;       }
    searchQuery.Open;
    self.SaveIDs(searchQuery);
    searchQuery.First;
    self.SaveRecord(searchQuery);
    RecordID:= self.GetID(0);
  finally
    FreeandNil(searchQuery);
  end;
  Result:= RecordID;
end;

function TDBOperations.SearchField(DBTable,ConnString,ReturnField: string;
  SearchField,SearchValue: String; ChangeQueryString: boolean = FALSE): string;
var
  NewYear,NewMonth,NewDay: word;
  NewHour,NewMin,NewSec,MSec: word;
  NewDate:string;
  NewTime:string;
  RecordID,i: integer;
  NewInteger: integer;
  NewDouble: double;
  SQLQuery, newSearch: string;
  searchQuery: TADOQuery;
  FieldType: string;
  FieldPos: integer;
  ResultValue: string;
begin
  RecordID:= 0;
  ResultValue:= '';
  if self.NotInTable(DBTable,SearchField,ConnString) then begin
    self.errorMessage:= 'Error: '+SearchField+' NOT in table: '+DBTable;
    Result:= 'ERROR';
    exit;
  end;
  if self.NotInTable(DBTable,ReturnField,ConnString) then begin
    self.errorMessage:= 'Error: '+ReturnField+' NOT in table: '+DBTable;
    Result:= 'ERROR';
    exit;
  end;
  FieldType:= '';
  SQLQuery:= '';
  FieldType:= self.GetFieldType(SearchField,DBTable,ConnString);
  if (FieldType = 'ftInteger') or (FieldType = 'ftAutoInc') then begin
    NewInteger:= StrToIntDef(SearchValue,0);
    SQLQuery:= 'SELECT * FROM '+DBTable+' WHERE '+SearchField+' = '+IntToStr(NewInteger);
  end
  else if FieldType = 'ftDouble' then begin
    NewDouble:= StrToFloat(SearchValue);
    SQLQuery:= 'SELECT * FROM '+DBTable+' WHERE '+SearchField+' = '+FloatToStr(NewDouble);
  end
  else
    SQLQuery:= 'SELECT * FROM '+DBTable+' WHERE '+SearchField+' like '+chr(39)+'%'+SearchValue+'%'+chr(39);
    //if any more searchfields then add:
    //SQLQuery:= SQLQuery+' AND Time('+SearchDateField+') like '+chr(39)+'%'+NewTime+'%'+chr(39);
  searchQuery:= TADOQuery.Create(nil);
  try
    searchQuery.ConnectionString:= ConnString;
    searchQuery.Close;
    searchQuery.SQL.Clear;
    if ChangeQueryString then
      self.QueryString:= SQLQuery;

    searchQuery.SQL.BeginUpdate;
    searchQuery.SQL.Add(SQLQuery);
    searchQuery.SQL.EndUpdate;
    searchQuery.Open;
    self.SaveIDs(searchQuery);
    FieldPos:= self.GetFieldPosition(DBTable,ReturnField,ConnString);
    searchQuery.First;
    ResultValue:= searchQuery.Fields[FieldPos].AsString;
    self.SaveRecord(searchQuery);
    RecordID:= self.GetID(0);
  finally
    FreeandNil(searchQuery);
  end;
  Result:= ResultValue;
end;

function TDBOperations.SearchFields(DBTable,ConnString,SearchFields: string;
  SearchValues,operators: String; SortField:string = ''; ChangeQueryString: boolean = FALSE): integer;
var
  NewYear,NewMonth,NewDay: word;
  NewHour,NewMin,NewSec,MSec: word;
  NewDateString:string;
  NewTimeString:string;
  NewDate: TDateTime;
  NextDateString:string;
  NextTimeString:string;
  NextDate: TDateTime;
  NextFieldType: string;
  NextSearchField: string;
  NextSearchValue: string;
  NextOperation: string;
  RecordID,i: integer;
  NewInteger: integer;
  NewDouble: double;
  SQLQuery, newSearch: string;
  searchQuery: TADOQuery;
  FieldType: string;
  idx: integer;
  FieldsArray: TstrArray;
  ValuesArray: TstrArray;
  TypesArray: TstrArray;
  OperatorsArray: TstrArray;
  SearchField: string;
  SearchValue: string;
  WhereParts: string;
  Operation: string;
begin
  RecordID:= 0;
  if self.NotInTable(DBTable,SearchField,ConnString) then begin
    self.errorMessage:= 'Error: '+SearchField+' NOT in table: '+DBTable;
    Result:= -1;
    exit;
  end;
  //DecodeDate EXTRACTS the date into its word parts
  //EncodeDate FORMS the date FROM the word parts into a NEW DATE.
  //DecodeDateTime(SearchDate,NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,MSec);
  //NewDate:= EncodeDateTime(NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,MSec);
  FieldType:= '';
  SQLQuery:= '';
  WhereParts:= '';
  SetLength(FieldsArray,1);
  SetLength(ValuesArray,1);
  SetLength(TypesArray,1);
  SetLength(OperatorsArray,1);
  FieldsArray:= StrToStringArray(SearchFields,',');
  ValuesArray:= StrToStringArray(SearchValues,',');
  OperatorsArray:= StrToStringArray(Operators,',');
  SQLQuery:= 'SELECT * FROM '+DBTable;

  //SQLQuery:= 'SELECT * FROM '+DBTable+' WHERE '+SearchField+' = '+IntToStr(NewInteger);
  idx:=0; //will High() miss off last field ???? 29/12/2014 at 04:09
  while idx<= High(FieldsArray) do begin

    SearchField:= FieldsArray[idx];
    SearchValue:= ValuesArray[idx];
    Operation:= OperatorsArray[idx];
    if Length(Operation)=0 then
      Operation:= '=';
    FieldType:= self.GetFieldType(SearchField,DBTable,ConnString);

    if (FieldType = 'ftInteger') AND (Length(SearchField)>0) then begin
      NewInteger:= StrToIntDef(SearchValue,0);
      if idx>0 then
        WhereParts:= WhereParts+' AND ';
      WhereParts:= WhereParts+SearchField+' '+Operation+' '+IntToStr(NewInteger);
    end
    else if (FieldType = 'ftDouble') AND (Length(SearchField)>0) then begin
      NewDouble:= StrToFloatDef(SearchValue,0.0);
      if idx>0 then
        WhereParts:= WhereParts+' AND ';
      WhereParts:= WhereParts+SearchField+' '+Operation+' '+FloatToStr(NewDouble);
    end
    else if (FieldType = 'ftDateTime') AND (Length(SearchField)>0) then begin
      if TryStrToDateTime(SearchValue,NewDate) then begin
        NewDateString:= self.DateForSQL(NewDate);
        NewTimeString:= self.TimeForSQL(NewDate);
        if idx>0 then
          WhereParts:= WhereParts+' AND ';
        if Uppercase(Operation)='BETWEEN' then begin
          if (idx+1)<high(FieldsArray) then begin
            NextSearchField:= FieldsArray[idx+1];
            NextSearchValue:= ValuesArray[idx+1];
            NextOperation:= OperatorsArray[idx+1];
            idx:= idx+1; //to make sure field after 2nd date field is landed on.
            if Length(NextOperation)=0 then
              NextOperation:= '=';
            NextFieldType:= self.GetFieldType(NextSearchField,DBTable,ConnString);
            if (NextFieldType = 'ftDateTime') then begin
              if TryStrToDateTime(NextSearchValue,NextDate) then begin
                NextDateString:= self.DateForSQL(NextDate);
                NextTimeString:= self.TimeForSQL(NextDate);
                WhereParts:= WhereParts+' Date('+SearchField+') '+operation+chr(39)+''+NewDateString+' '+NewTimeString+''+chr(39);
                WhereParts:= WhereParts+' AND '+chr(39)+''+NextDateString+' '+NextTimeString+''+chr(39);
              end
              else
                self.errorMessage:= self.errorMessage+' ,Error converting next date:'+NextSearchField;
            end
            else
              self.errorMessage:= self.errorMessage+' ,Error WRONG next DATE TYPE:'+SearchField;
          end
          else
            self.errorMessage:= self.errorMessage+' ,Error getting next date field:'+SearchField;
        end
        else
          WhereParts:= WhereParts+' Date('+SearchField+') '+operation+chr(39)+''+NewDateString+' '+NewTimeString+''+chr(39);
      end
      else
        self.errorMessage:= self.errorMessage+' ,Error converting Date Field:'+SearchField;
    end
    else if (Length(SearchField)>0) then begin
      if idx>0 then
        WhereParts:= WhereParts+' AND ';
      if Uppercase(Operation) = 'LIKE' then
        WhereParts:= WhereParts+SearchField+' '+operation+' '+chr(39)+'%'+SearchValue+'%'+chr(39)
      else
        WhereParts:= WhereParts+SearchField+' '+operation+' '+chr(39)+SearchValue+chr(39);
      //if any more searchfields then add:
      //SQLQuery:= SQLQuery+' AND Time('+SearchDateField+') like '+chr(39)+'%'+NewTime+'%'+chr(39);

    end
    else
      SQLQuery:= 'SELECT * FROM '+DBTable;
    idx:= idx+1;
  end; {while}
  if Length(WhereParts)>0 then
    SQLQuery:= SQLQuery+' WHERE '+WhereParts;
  if Length(SortField)>0 then
    SQLQuery:= SQLQuery+' ORDER BY '+SortField;
  searchQuery:= TADOQuery.Create(nil);
  try
    searchQuery.ConnectionString:= ConnString;
    searchQuery.Close;
    searchQuery.SQL.Clear;
    if ChangeQueryString then
      self.QueryString:= SQLQuery;
    searchQuery.SQL.BeginUpdate;
    searchQuery.SQL.Add(SQLQuery);
    searchQuery.SQL.EndUpdate;
    searchQuery.Open;
    beep;
    self.SaveIDs(searchQuery);
    searchQuery.First;
    self.SaveRecord(searchQuery);
    RecordID:= self.GetID(0);
  finally
    FreeandNil(searchQuery);
  end;
  Result:= RecordID;
end;

function TDBOperations.SearchDateField(DBTable,ConnString,SearchDateField: string;
  SearchDate: TDateTime; MatchTime: boolean; AdditionalFilter:string = '';
  ChangeQueryString: boolean = FALSE; SplitDateTime:boolean = FALSE): integer;
var
  NewYear,NewMonth,NewDay: word;
  NewHour,NewMin,NewSec,MSec: word;
  NewDate:string;
  NewTime:string;
  NewSearchDate, NewSearchTime: TDateTime;
  RecordID,i: integer;
  SQLQuery, newSearch: string;
  searchQuery: TADOQuery;
  WherePart: string;
  TimePart: string;
begin
  RecordID:= 0;
  //DecodeDate EXTRACTS the date into its word parts
  //EncodeDate FORMS the date FROM the word parts into a NEW DATE.
  //DecodeDateTime(SearchDate,NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,MSec);
  //NewDate:= EncodeDateTime(NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,MSec);
  if NotInTable(DBTable,SearchDateField,connString) then begin
    Result:= -1;
    self.errorMessage:= 'Error: '+SearchDateField+' NOT in table: '+DBTable;
    exit;
  end;
  NewSearchDate:= SearchDate;
  NewSearchTime:= SearchDate;
  WherePart:= '';
  TimePart:= '';
  if SplitDateTime then begin
    DecodeDateTime(SearchDate,NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,MSec);
    NewSearchDate:= EncodeDate(NewYear,NewMonth,NewDay);
    NewSearchTime:= EncodeTime(NewHour,NewMin,NewSec,MSec);
    NewDate:= self.DateForSQL(NewSearchDate);
    NewTime:= self.TimeForSQL(NewSearchTime);
    WherePart:= WherePart+' Date('+SearchDateField+') like '+chr(39)+'%'+NewDate+'%'+chr(39);
    if MatchTime then begin
      //TimePart:= ' AND Time('+SearchDateField+') like '+chr(39)+'%'+NewTime+'%'+chr(39);
      WherePart:= WherePart+' AND Time('+SearchDateField+') like '+chr(39)+'%'+NewTime+'%'+chr(39);
    end;
  end
  else begin
    if MatchTime then  begin
      NewDate:= self.DateTimeForSQL(SearchDate);
      NewTime:= self.DateTimeForSQL(SearchDate);
      //WherePart:= WherePart+' DateTime('+SearchDateField+') like '+chr(39)+'%'+NewDate+'%'+chr(39);
      WherePart:= WherePart+' DateTime('+SearchDateField+') = '+chr(39)+''+NewDate+''+chr(39);
    end
    else begin
      NewDate:= self.DateTimeForSQL(SearchDate);
      NewTime:= self.DateTimeForSQL(SearchDate);
      WherePart:= WherePart+' Date('+SearchDateField+') like '+chr(39)+'%'+NewDate+'%'+chr(39);
    end;
  end;
  SQLQuery:= 'SELECT * FROM '+DBTable;

  if Length(AdditionalFilter)>0 then
    WherePart:= WherePart+' AND '+AdditionalFilter;

  //SQLQuery:= SQLQuery+' WHERE '+WherePart+TimePart;
  SQLQuery:= SQLQuery+' WHERE '+WherePart;
  searchQuery:= TADOQuery.Create(nil);
  try
    searchQuery.ConnectionString:= ConnString;
    searchQuery.Close;
    searchQuery.SQL.Clear;
    if ChangeQueryString then
      self.QueryString:= SQLQuery;
    //searchQuery.ParamCheck:= True;
    //searchQuery.Parameters.AddParameter.Name:= 'DateVal';
    //searchQuery.Parameters.AddParameter.DataType:= ftDateTime;
    //searchQuery.Parameters.AddParameter.Value:= SearchDate;
    //searchQuery.Parameters.AddParameter.Direction in or output ?
    searchQuery.SQL.BeginUpdate;
    searchQuery.SQL.Add(SQLQuery);
    searchQuery.SQL.EndUpdate;
    //searchQuery.Parameters.ParamByName('DateVal').DataType:= ftString;
    //searchQuery.Parameters.ParamByName('DateVal').Value:= FormatFloat('yyyy-mm-dd hh:nn:ss',NewDate);
    //The following produces error - arguments are of the wrong type ...
    //beep;
    //searchQuery.Parameters.ParamByName('DateVal').DataType:= ftDateTime;
    //searchQuery.Parameters.ParamByName('DateVal').Value:= NewDate;
    //searchQuery.Parameters.ParamValues['DateVal']:= NewDate;
    {for i:=0 to searchQuery.Parameters.Count-1 do begin
      if searchQuery.Parameters.Items[i].Name = 'dateval' then
        searchQuery.Parameters.Items[i].Value := SearchDate;
    end;       }
    searchQuery.Open;
    self.SaveIDs(searchQuery); //returns number of elements in id array
    searchQuery.First;
    self.SaveRecord(searchQuery);
    RecordID:= self.GetID(0);
  finally
    FreeandNil(searchQuery);
  end;
  Result:= RecordID;
end;

function TDBOperations.SelectDates(DBTable,ConnString,SearchDateField: string;
  SortField: string; ReverseDirection: boolean; DateFrom,DateTo: TDateTime; ChangeQueryString:boolean = FALSE): integer;
var
  NewYear,NewMonth,NewDay: word;
  NewHour,NewMin,NewSec,MSec: word;
  NewDateFrom,NewDateTo:string;
  NewTimeFrom,NewTimeTo:string;
  RecordID,i: integer;
  SQLQuery, newSearch: string;
  searchQuery: TADOQuery;
begin
  RecordID:= 0;
    NewDateFrom:= self.DateForSQL(DateFrom);
    NewTimeFrom:= self.TimeForSQL(DateFrom);
    NewDateTo:= self.DateForSQL(DateTo);
    NewTimeTo:= self.TimeForSQL(DateTo);
    //TEST if field exists in sort fields first:
    //so if the field does NOT exist in the table passed then -1 is returned.
    //if the Field DOES EXIST then 0 will be returned if VALUE not Found.
    if Length(SearchDateField)>0 then begin
      if self.NotInTable(DBTable,SearchDateField,ConnString) then begin
        self.errorMessage:= 'Error: '+SearchDateField+' NOT in table: '+DBTable;
        Result:= -1;
        exit;
      end;
    end;
    if Length(SortField)>0 then begin
      if self.NotInTable(DBTable,SortField,ConnString) then begin
        self.errorMessage:= 'Error: '+SortField+' NOT in table: '+DBTable;
        Result:= -1;
        exit;
      end;
    end;
    if RecordID = -1 then begin
      Result:= -1;
      exit;
    end;
    //NOTE - The other function following this one has been changed - to use
    //   single quotes rather than double quotes.
    //SELECT * FROM alerts WHERE DATE BETWEEN '2014-11-16' AND '2014-11-26'
    //  AND TIME(DATE) BETWEEN '09:00' AND '19:00' Is giving the expected result.
    SQLQuery:= 'SELECT * FROM '+DBTable+' WHERE '+SearchDateField+' BETWEEN '+chr(39)+''+NewDateFrom+''+chr(39);
    SQLQuery:= SQLQuery+' AND '+chr(39)+''+NewDateTo+''+chr(39)+' AND TIME('+SearchDateField+')'+' BETWEEN '+chr(39)+''+NewTimeFrom+''+chr(39);
    SQLQuery:= SQLQuery+' AND '+chr(39)+''+NewTimeTo+''+chr(39);

    if ReverseDirection then begin
      //SQLQuery:= 'SELECT * FROM '+DBTable+' WHERE Date('+SearchDateField+') between '+chr(39)+''+NewDateFrom+' '+NewTimeFrom+''+chr(39);
      //SQLQuery:= SQLQuery+' AND '+chr(39)+''+NewDateTo+' '+NewTimeTo+''+chr(39);
      //SQLQuery:= SQLQuery+' ORDER BY '+chr(39)+''+SortField+' desc'+''+chr(39);
      SQLQuery:= SQLQuery+' ORDER BY '+SortField+' desc';
    end
    else begin
      //SQLQuery:= 'SELECT * FROM '+DBTable+' WHERE Date('+SearchDateField+') between '+chr(39)+''+NewDateFrom+' '+NewTimeFrom+''+chr(39);
      //SQLQuery:= SQLQuery+' AND '+chr(39)+''+NewDateTo+' '+NewTimeTo+''+chr(39);
      //SQLQuery:= SQLQuery+' ORDER BY '+chr(39)+''+SortField+' asc'+''+chr(39);
      SQLQuery:= SQLQuery+' ORDER BY '+SortField+' asc';
    end;
  if fADOQuery <> nil then
    FreeAndNil(fADOQuery);
  fADOQuery:= TADOQuery.Create(nil);
  fADOQuery.ConnectionString:= ConnString;
  fADOQuery.Close;
  fADOQuery.SQL.Clear;
  if ChangeQueryString then
    self.QueryString:= SQLQuery;
  fADOQuery.SQL.BeginUpdate;
  fADOQuery.SQL.Add(SQLQuery);
  fADOQuery.SQL.EndUpdate;
  //beep;
  fADOQuery.Open;
  self.SaveIDs(fADOQuery);
  searchQuery.First;
  self.SaveRecord(fADOQuery);
  RecordID:= self.GetID(0);
  Result:= RecordID;
end;

function TDBOperations.SelectDates(DBTable,ConnString,SearchDateField: string;
  SortField: string; ReverseDirection: boolean; DateFrom,DateTo: TDateTime;
  Filter:string; ChangeQueryString:boolean = FALSE): integer;
var
  NewYear,NewMonth,NewDay: word;
  NewHour,NewMin,NewSec,MSec: word;
  NewDateFrom,NewDateTo:string;
  NewTimeFrom,NewTimeTo:string;
  RecordID,i: integer;
  SQLQuery, newSearch: string;
  searchQuery: TADOQuery;
begin
  RecordID:= 0;
    NewDateFrom:= self.DateForSQL(DateFrom);
    NewTimeFrom:= self.TimeForSQL(DateFrom);
    NewDateTo:= self.DateForSQL(DateTo);
    NewTimeTo:= self.TimeForSQL(DateTo);
    if Length(SearchDateField)>0 then begin
      //wrong table being used here !!!!!
      if self.NotInTable(DBTable,SearchDateField,ConnString) then begin
        self.errorMessage:= 'Error: '+SearchDateField+' NOT in table: '+DBTable;
        Result:= -1;
        exit;
      end;
    end;
    if Length(SortField)>0 then begin
      if self.NotInTable(DBTable,SortField,ConnString) then begin
        self.errorMessage:= 'Error: '+SortField+' NOT in table: '+DBTable;
        Result:= -1;
        exit;
      end;
    end;
    if RecordID = -1 then begin
      Result:= -1;
      exit;
    end;

    SQLQuery:= 'SELECT * FROM '+DBTable+' WHERE Date('+SearchDateField+') BETWEEN '+chr(39)+NewDateFrom+chr(39);
    SQLQuery:= SQLQuery+' AND '+chr(39)+NewDateTo+chr(39)+' AND TIME('+SearchDateField+')'+' BETWEEN '+chr(39)+NewTimeFrom+chr(39);
    SQLQuery:= SQLQuery+' AND '+chr(39)+NewTimeTo+chr(39);

    if ReverseDirection then begin
      //SQLQuery:= 'SELECT * FROM '+DBTable+' WHERE Date('+SearchDateField+') between '+chr(39)+''+NewDateFrom+' '+NewTimeFrom+''+chr(39);
      //SQLQuery:= SQLQuery+' AND '+chr(39)+''+NewDateTo+' '+NewTimeTo+''+chr(39);
      if Length(Filter)>0 then
        SQLQuery:= SQLQuery+ ' AND '+Filter;
      //SQLQuery:= SQLQuery+' ORDER BY '+chr(39)+''+SortField+' desc'+''+chr(39);
      if Length(SortField)>0 then
        SQLQuery:= SQLQuery+' ORDER BY '+SortField+' desc';
    end
    else begin
      //SQLQuery:= 'SELECT * FROM '+DBTable+' WHERE Date('+SearchDateField+') between '+chr(39)+''+NewDateFrom+' '+NewTimeFrom+''+chr(39);
      //SQLQuery:= SQLQuery+' AND '+chr(39)+''+NewDateTo+' '+NewTimeTo+''+chr(39);
      if Length(Filter)>0 then
        SQLQuery:= SQLQuery+ ' AND '+Filter;
      //SQLQuery:= SQLQuery+' ORDER BY '+chr(39)+''+SortField+' asc'+''+chr(39);
      if Length(SortField)>0 then
        SQLQuery:= SQLQuery+' ORDER BY '+SortField+' asc';
    end;
  if fADOQuery <> nil then
    FreeAndNil(fADOQuery);
  fADOQuery:= TADOQuery.Create(nil);
  fADOQuery.ConnectionString:= ConnString;
  fADOQuery.Close;
  fADOQuery.SQL.Clear;
  if ChangeQueryString then
    self.QueryString:= SQLQuery;
  fADOQuery.SQL.BeginUpdate;
  fADOQuery.SQL.Add(SQLQuery);
  fADOQuery.SQL.EndUpdate;
  //beep;
  fADOQuery.Open;
  self.SaveIDs(fADOQuery);
  fADOQuery.First;
  self.SaveRecord(fADOQuery);
  RecordID:= self.GetID(0);
  Result:= RecordID;
end;

procedure TDBOperations.PopulateDropdownFromArray(comboBox: TComboBox;
  strArray: TstrArray);
var
  idx: integer;
  strItem: string;
begin
  idx:=0;
  while idx<= High(strArray) do begin
    strItem:= strArray[idx];
    comboBox.Items.Add(strItem);
    idx:= idx+1;
  end;
  comboBox.ItemIndex:= 0;
end;

function TDBOperations.PrepareDelete(TableName, Filter: string): string;
var
  SQLcmd: string;
begin
  SQLcmd:= 'DELETE FROM '+TableName;
  if Length(Filter)>0 then SQLcmd:= SQLcmd+' WHERE '+Filter;
  Result:= SQLcmd;
end;

function TDBOperations.PrepareInsert(TableName, FieldNames,
  FieldValues: string): string;
var
  SQLcmd: string;
  fldArray: TstrArray;
  ValArray: TstrArray;
  FieldType: string;
  FieldTypeArray: TstrArray;
  ValueList: string;
  strValue: string;
  idx: integer;
  valIdx: integer;
  constr: WideString;
  tempDateTime: TDateTime;
begin
  //The fieldnames and fieldvalues are passed - both as string list.
  //the fieldtype is extracted for each fieldname and then applied
  //to the value before being put into an "INSERT" list.
  //the :dataVal1 part needs quotes around it.
  //ValArray:= VarArrayCreate([0,Length(FieldNames)],VarVariant);
  constr:= self.connString;
  SQLcmd:= '';
  ValueList:= '';
  if Length(self.connString)=0 then begin
    self.errorMessage:= 'No Connection String specified';
    SQLcmd:= 'ERROR';
  end
  else begin
  //clear arrays before using them:
    SetLength(self.fValuesArray,0);
    SetLength(self.fTypesArray,0);
    SetLength(fldArray,0);
    SetLength(ValArray,0);
    if Length(FieldNames) = 0 then
      FieldNames:= self.ExtractFieldNames(constr,TableName);
    fldArray:= self.StrToStringArray(FieldNames,','); //index starts at 0
    ValArray:= self.StrToStringArray(FieldValues,','); //index starts at 1, element 0=null
    self.fValuesArray:= self.StrToStringArray(FieldValues,','); //starts at element 1
    variantArray:= self.CreateVariantArray(Length(fldArray)+2);
    //parameters - insert into table (fields) VALUES (:value1, :value2, :value3)
    //SQLQuery.parameters.add
    //insert autoinc field at element 0.
    idx:=0;
    //fldArray[0]:= 'id';
    //FieldNames:= self.StringArrayToString(fldArray,',');
    //FieldNames:= fldArray[0..elements] - convert array back to string since we have inserted new field !
    valIdx:=1; //parameter values - value1, value2 etc.
    while idx< Length(fldArray) do begin
      if Length(ValArray)<= idx then
        SetLength(ValArray,Length(ValArray)+1);
      FieldType:= self.GetFieldType(fldArray[idx],TableName,constr);
      SetLength(self.fTypesArray,Length(self.fTypesArray)+2); //Add extra element
      self.fTypesArray:= self.StrToStringArray(self.GetFieldTypes(TableName,constr),',');
      //self.fTypesArray[idx]:= UpperCase(FieldType);
      strValue:= self.GetNewFieldValue(fldArray[idx],ValArray[idx],TableName,constr);
      VariantArray[idx]:= strValue;
      if idx=0 then
        ValueList:= strValue
      else
        ValueList:= ValueList+', '+strValue;
      idx:= idx+1;
      valIdx:= valIdx+1;
    end;

    SQLcmd:= 'INSERT INTO '+TableName+' ('+FieldNames+') VALUES ('+ValueList+')';
    //SQLcmd:= 'INSERT INTO energy_gasmeterreadings (id,EnergyType,Customerid,AccountNo,Reading1) VALUES (null, "MyInsert",1,"ac123",456.7)';

    self.queryMessage:= SQLcmd;
  end;
  Result:= SQLcmd;
end;

function TDBOperations.VariantToStr(V: Variant; IncludeType: Boolean = False): string;
begin
  if VarIsArray(V) then
    Result := VarArrayToStr(V)
  else
    case VarType(V) of
      varError:
        Result := Format('Error($%x)', [TVarData(v).VError]);
      varNull:
        Result := '#NULL';
      varEmpty:
        Result := '#EMPTY';
      varDate:
        Result := FormatDateTime(ShortDateFormat + ' ' + LongTimeFormat + '.zzz', V)
    else
      Result := VarToStr(V);
    end;
  if IncludeType then
    //Result := Format('%s{%s}', [Result, VarTypeToString(VarType(V))]);
end;

function TDBOperations.VarArrayToStr(v: Variant; Delimiter: Char = #44; LineDelimiter: Char = #13): string;
var
  i,j,d: Integer;
  line: string;
begin
  if VarIsArray(v) then
  begin
    if Delimiter = #0 then
      Delimiter := ListSeparator;
    if LineDelimiter = #0 then
      LineDelimiter := ListSeparator;
    d := VarArrayDimCount(v);
    // The elements
    case d of
      1:
      begin
        Result := '';
        for i := VarArrayLowBound(v,1) to VarArrayHighBound(v,1) do
          Result := Result + VariantToStr(v[i]) + Delimiter;
        if Length(Result) > 0 then
          SetLength(Result, Length(Result)-1);
      end;
      2:
      begin
        Result := '';
        if (VarArrayLowBound(v,1) <= VarArrayHighBound(v,1)) and
          (VarArrayLowBound(v,2) <= VarArrayHighBound(v,2)) then
        begin
          for i := VarArrayLowBound(v,1) to VarArrayHighBound(v,1) do
          begin
            line := '';
            for j := VarArrayLowBound(v,2) to VarArrayHighBound(v,2) do
              line := line + VariantToStr(v[i,j]) + Delimiter;
            if Length(Result) > 0 then
              SetLength(line, Length(line)-1);
            Result := Result + LineDelimiter + Format('[%s]', [line]);
          end;
        end;
      end // 2
    else
      Result := 'Array Dim=' + IntToStr(d);
    end;
    Result := Format('[%s]', [Result]);
  end
  else
    Result := VarToStr(v);
end;

function TDBOperations.GetFieldnames(TableName:string; conString:widestring): TstrArray;
var
  ADOQuery: TADOQuery;
  FieldNamesArray: TstrArray;
  FieldList: TStringList;
  Fieldname: string;
begin
  //get the fieldname , given the field position and table name:
  ADOQuery:= TADOQuery.Create(nil);
  FieldList:= TStringList.Create;
  try
    ADOQuery.ConnectionString:= conString;
    ADOQuery.Close;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Text:= 'SELECT * FROM '+TableName;
    ADOQuery.GetFieldNames(FieldList);
    ADOQuery.Open;
    FieldNamesArray:= self.StrToStringArray(FieldList.CommaText,',');
  finally
    FreeAndNil(ADOQuery);
    FreeAndNil(FieldList);
  end;
  Result:= FieldNamesArray;
end;

function TDBOperations.GetFieldnames(var FieldList: TStringList; TableName: string;
  conString: widestring): TstrArray;
var
  ADOQuery: TADOQuery;
  Fieldname: string;
  FieldsArray: TstrArray;
begin
   ADOQuery:= TADOQuery.Create(nil);
   SetLength(FieldsArray,1);
  try
    ADOQuery.ConnectionString:= conString;
    ADOQuery.Close;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Text:= 'SELECT * FROM '+TableName;
    ADOQuery.GetFieldNames(FieldList);
    ADOQuery.Open;
    FieldsArray:= self.ConvertStringListToStrArray(FieldList);
    Result:= FieldsArray;
  finally
    FreeAndNil(ADOQuery);
  end;
end;

function TDBOperations.GetFieldname(TableName: string;
  FieldPos: integer; conString:widestring): string;
var
  ADOQuery: TADOQuery;
  FieldNamesArray: TstrArray;
  FieldList: TStringList;
  Fieldname: string;
begin
  //get the fieldname , given the field position and table name:
  ADOQuery:= TADOQuery.Create(nil);
  FieldList:= TStringList.Create;
  try
    ADOQuery.ConnectionString:= conString;
    ADOQuery.Close;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Text:= 'SELECT * FROM '+TableName;
    ADOQuery.GetFieldNames(FieldList);
    ADOQuery.Open;
    FieldNamesArray:= self.StrToStringArray(FieldList.CommaText,',');
    Fieldname:= ADOQuery.Fields[FieldPos].FieldName;
  finally
    FreeAndNil(ADOQuery);
    FreeAndNil(FieldList);
  end;
  Result:= Fieldname;
end;

function TDBOperations.GetFieldPosition(TableName,FieldName: String; connString:widestring): integer;
var
  ADOQuery: TADOQuery;
  idx: integer;
  FieldNamesArray: TstrArray;
  FieldList: TStringList;
  FieldPosition: integer;
begin
  //cycle through fields to find the fieldname.
  //***** Return -1 if field NOT FOUND *****
  if (Length(TableName)=0) OR (Length(FieldName)=0) then begin
    Result:= -1;
    exit;
  end;
  ADOQuery:= TADOQuery.Create(nil);
  FieldList:= TStringList.Create;
  FieldPosition:= -1;
  try
    //if self.TotalRecords>0 then begin
      ADOQuery.ConnectionString:= connString;
      ADOQuery.Close;
      ADOQuery.SQL.Clear;
      ADOQuery.SQL.Add('SELECT * FROM '+TableName);
      ADOQuery.GetFieldNames(FieldList);
      ADOQuery.Open;
      idx:=0;
      FieldNamesArray:= self.StrToStringArray(FieldList.CommaText,',');
      fFieldsArray:= self.ConvertStringListToStrArray(FieldList);
      while idx< ADOQuery.FieldCount do begin
        if UpperCase(FieldName) = UpperCase(FieldNamesArray[idx]) then begin
          FieldPosition:= idx;
          Result:= FieldPosition;
          exit;
        end;

        idx:= idx+1;
      end;
    //end;
  finally
    FreeAndNil(ADOQuery);
    FreeAndNil(FieldList);
  end;
  Result:= FieldPosition;
end;

function TDBOperations.GetFieldType(FieldName,TableName:string; connString:widestring):string;
//returns type of field given the fieldname.
var
  ADOQuery: TADOQuery;
  idx: integer;
  FieldType: TFieldType;
  FieldList: TStringList;
  strFieldType: string;
  fldName: string;
  FieldNamesArray: TstrArray;
begin
  ADOQuery:= TADOQuery.Create(nil);
  FieldList:= TStringList.Create;
  strFieldType:='';
  try
    ADOQuery.ConnectionString:= connString;
    ADOQuery.Close;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Text:= 'SELECT * FROM '+TableName;
    ADOQuery.GetFieldNames(FieldList);
    ADOQuery.Open;
    idx:=0;
    FieldNamesArray:= self.StrToStringArray(FieldList.CommaText,',');
    while idx< ADOQuery.FieldCount do begin
      fldName:= FieldNamesArray[idx];
      if UpperCase(fldName) = UpperCase(FieldName) then begin
        FieldType:= ADOQuery.Fields[idx].DataType;
        if FieldType = ftAutoInc then
          strFieldType:= 'ftAutoInc'
        else if FieldType = ftInteger then
          strFieldType:= 'ftInteger'
        else if FieldType = ftWideString then
          strFieldType:= 'ftWideString'
        else if FieldType = ftDateTime then
          strFieldType:= 'ftDateTime'
        else if FieldType = ftFloat then
          strFieldType:= 'ftFloat'
        else if FieldType = ftWideMemo then
          strFieldType:= 'ftWideMemo' //for MySQL field type TEXT
        else
          strFieldType:= 'UNKNOWN';
        Result:= strFieldType;
        break;
      end;
      idx:= idx+1;
    end;
  finally
    FreeAndNil(ADOQuery);
    FreeAndNil(FieldList);
  end;
  Result:= strFieldType;
end;



function TDBOperations.GetFieldnamesOfTypesPassed(TableName:string; FieldType:string; conStr:WideString):string;
var
  idx,saveIDX: integer;
  FieldArray: TstrArray;
  FieldTypeArray: TstrArray;
  FieldNames: string;
begin
  SetLength(FieldTypeArray,1);
  SetLength(FieldArray,1);
  FieldNames:= '';
  FieldTypeArray:= self.StrToStringArray(self.GetFieldTypes(TableName,conStr),',');
  FieldArray:= self.StrToStringArray(self.ExtractFieldNames(conStr,TableName),',');
  idx:=0;
  saveIDX:= 0; //- save to first element. space in array element for some reason.
  while idx< Length(FieldTypeArray) do begin
    if UpperCase(FieldTypeArray[idx]) = Uppercase(FieldType) then begin
      if Uppercase(FieldType) = 'FTDATETIME' then self.queryMessage:='DATETIME detected';
      if saveIDX=0 then
        FieldNames:= FieldArray[idx]
      else
        FieldNames:= FieldNames+','+FieldArray[idx];
      saveIDX:= saveIDX+1;
    end;
    idx:= idx+1;
  end;
  Result:= FieldNames;
end;

function TDBOperations.GetFieldTypes(TableName:string; connString:widestring):string;
//produces comma delimited list of all field types in table given
//- which can be put into an array later.
var
  ADOQuery: TADOQuery;
  idx: integer;
  FieldTypes, FieldNames: string;
  FieldType: TFieldType;
  strFieldType: string;
begin
  ADOQuery:= TADOQuery.Create(nil);
  FieldTypes:= '';
  try
    ADOQuery.ConnectionString:= connString;
    ADOQuery.Close;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Text:= 'SELECT * FROM '+TableName;
    ADOQuery.Open;
    FieldNames:= self.ExtractFieldNames(ADOQuery);
    idx:=0;
    while idx< ADOQuery.FieldCount do begin
      FieldType:= ADOQuery.Fields[idx].DataType;
      if FieldType = ftAutoInc then
        strFieldType:= 'ftAutoInc'
      else if FieldType = ftInteger then
        strFieldType:= 'ftInteger'
      else if FieldType = ftWideString then
        strFieldType:= 'ftWideString'
      else if FieldType = ftString then
        strFieldType:= 'ftString'
      else if FieldType = ftMemo then
        strFieldType:= 'ftMemo'
      else if FieldType = ftDate then
        strFieldType:= 'ftDate'
      else if FieldType = ftTime then
        strFieldType:= 'ftTime'
      else if FieldType = ftDateTime then
        strFieldType:= 'ftDateTime'
      else if FieldType = ftBoolean then
        strFieldType:= 'ftBoolean'
      else if FieldType = ftFloat then
        strFieldType:= 'ftFloat'
      else if FieldType = ftLargeint then
        strFieldType:= 'ftLargeint'
      else if FieldType = ftUnknown then
        strFieldType:= 'UNKNOWN'
      else if FieldType =  ftBlob then
        strFieldType:= 'ftBlob'
      else
        strFieldType:= 'UNKNOWN';
      if idx=0 then
        FieldTypes:= strFieldType
      else
        FieldTypes:= FieldTypes+','+strFieldType;
      idx:= idx+1;
    end;
  finally
    FreeAndNil(ADOQuery);
  end;
  Result:= FieldTypes;
end;

{ftUnknown	   //  Unknown or undetermined
ftString	        //  Character or string field
ftSmallint	      //  16-bit integer field
ftInteger	       //  32-bit integer field
ftWord	               //  16-bit unsigned integer field
ftBoolean	    //  Boolean field
ftFloat	                 // Floating-point numeric field
ftCurrency	    // Money field
ftBCD	               // Binary-Coded Decimal field
ftDate	                // Date field
ftTime	                // Time field
ftDateTime	   // Date and time field
ftBytes	                // Fixed number of bytes (binary storage)
ftVarBytes	     // Variable number of bytes (binary storage)
ftAutoInc	       // Auto-incrementing 32-bit integer counter field
ftBlob	                 // Binary Large OBject field
ftMemo	              // Text memo field
ftGraphic	      // Bitmap field
ftFmtMemo	  // Formatted text memo field
ftParadoxOle	  // Paradox OLE field
ftDBaseOle	  // dBASE OLE field
ftTypedBinary	  // Typed binary field
ftCursor	      // Output cursor from an Oracle stored procedure (TParam only)
ftFixedChar	   // Fixed character field
ftWideString	  // Wide string field
ftLargeint	      // Large integer field
ftADT	                // Abstract Data Type field
ftArray	                 // Array field
ftReference	   // REF field
ftDataSet	     // DataSet field
ftOraBlob	     // BLOB fields in Oracle 8 tables
ftOraClob	    // CLOB fields in Oracle 8 tables
ftVariant	      // Data of unknown or undetermined type
ftInterface	     // References to interfaces (IUnknown)
ftIDispatch	   // References to IDispatch interfaces
ftGuid	              //  globally unique identifier (GUID) values }

function TDBOperations.GetfValuesArray: TstrArray;
begin
  Result:= fValuesArray;
end;

function TDBOperations.ShowBasicVariantType(varVar: Variant):string;
var
  typeString : string;
  basicType  : Integer;

begin
  // Get the Variant basic type :
  // this means excluding array or indirection modifiers
  basicType := VarType(varVar) and VarTypeMask;

  // Set a string to match the type
  case basicType of
    varEmpty     : typeString := 'varEmpty';
    varNull      : typeString := 'varNull';
    varSmallInt  : typeString := 'varSmallInt';
    varInteger   : typeString := 'varInteger';
    varSingle    : typeString := 'varSingle';
    varDouble    : typeString := 'varDouble';
    varCurrency  : typeString := 'varCurrency';
    varDate      : typeString := 'varDate';
    varOleStr    : typeString := 'varOleStr';
    varDispatch  : typeString := 'varDispatch';
    varError     : typeString := 'varError';
    varBoolean   : typeString := 'varBoolean';
    varVariant   : typeString := 'varVariant';
    varUnknown   : typeString := 'varUnknown';
    varByte      : typeString := 'varByte';
    varWord      : typeString := 'varWord';
    varLongWord  : typeString := 'varLongWord';
    varInt64     : typeString := 'varInt64';
    varStrArg    : typeString := 'varStrArg';
    varString    : typeString := 'varString';
    varAny       : typeString := 'varAny';
    varTypeMask  : typeString := 'varTypeMask';
  end;
  Result:= typeString;
end;

function TDBOperations.GetNewFieldValue(FieldName,FieldValue,TableName,ConnString:string):string;
var
  FieldType: string;
  NewValue: variant;
  tempDateTime: TDateTime;
begin
  //Error produced if DATE is in the FORMAT yyyy-mm-dd should be yyyy/mm/dd
  NewValue:= '';
  FieldType:= self.GetFieldType(FieldName,TableName,ConnString);
  if UpperCase(FieldType) = 'FTWIDESTRING' then begin
    NewValue:= chr(34)+FieldValue+chr(34);
  end
  else if UpperCase(FieldType) = 'FTAUTOINC' then begin
    NewValue:= 'NULL';
  end
  else if UpperCase(FieldType) = 'FTINTEGER' then begin
    if Length(FieldValue)>0 then
      NewValue:= StrToInt(FieldValue) //ValArray contains strings - this does not work
    else
      NewValue:= 0;
  end
  else if UpperCase(FieldType) = 'FTDATETIME' then begin
    //NewValue:= StrToDateTime(ValArray[idx]);
    //Replace - with / if found:
    //must also be in the format: dd/mm/yyyy
    FieldValue:= StringReplace(FieldValue, '-', '/',
                          [rfReplaceAll, rfIgnoreCase]);

    if tryStrToDateTime(FieldValue,tempDateTime) then
      NewValue:= chr(34)+self.DateTimeForSQL(tempDateTime)+chr(34)
    else begin
      //tryStrToDateTime('31-12-1899',tempDateTime);
      //NewValue:= chr(34)+self.DateTimeForSQL(tempDateTime)+chr(34);
      tempDateTime:= now();
      NewValue:= chr(34)+self.DateTimeForSQL(tempDateTime)+chr(34);
    end;
    //switch around datetime value to yyyy-mm-dd
    //tempDateTime:= NewValue;
  end
  else if UpperCase(FieldType) = 'FTFLOAT' then begin
    if Length(FieldValue)>0 then
      NewValue:= StrToFloat(FieldValue)
    else
      NewValue:= 0.00;
  end
  else if UpperCase(FieldType) = 'FTWIDEMEMO' then begin
    ReplaceStr(FieldValue,char(187),'');
    NewValue:= chr(34)+FieldValue+chr(34);

  end
  else begin
    NewValue:= chr(34)+FieldValue+chr(34);
    self.errorMessage:= self.errorMessage+', '+'UNKNOWN TYPE';
  end;
  Result:= VarToStr(NewValue);
end;

function TDBOperations.GetNumberOfTables: integer;
var
  TableList: TStringList;
  TableName: string;
  idx: integer;
begin
  //only works if fTAbleNames has been populated
  //maybe with MYSQL command: Show Tables
  //or could set up a temp DBGrid to point to query containing connection to DB.

  TableList:= TStringList.Create;
  try
    idx:=0;
    while idx< Length(self.fTableNames) do begin
      TableName:= fTableNames[idx];
      TableList.Add(TableName);
      idx:= idx+1;
    end;
  finally
    FreeAndNil(TableList);
  end;
  Result:= idx;
end;

function TDBOperations.GetQueryString: string;
begin
  Result:= self.fQueryString;
end;

function TDBOperations.PrepareUpdate(TableName, FieldNames, FieldValues,
  Filter: string; StartIndex:integer=1): string;
var
  SQLcmd: string;
  SETstring: string;
  MyFieldsArray: TstrArray;
  MyValuesArray: TstrArray;
  IDX: integer;
  strValue: string;
  conStr: widestring;
begin
  //FieldNames and FieldValues contains delimited string by comma
  //
  constr:= self.connString;
  SQLcmd:= '';
  if Length(self.connString)=0 then begin
    self.errorMessage:= 'No Connection String specified';
    SQLcmd:= 'error';
  end
  else begin

    setLength(MyFieldsArray,Length(MyFieldsArray)+1);
    setLength(MyValuesArray,Length(MyValuesArray)+1);
    if Length(FieldNames) = 0 then
      FieldNames:= ExtractFieldNames(connString,TableName);
    //somehow remove the excluded fields from the list - use stringlist
    MyFieldsArray:= self.StrToStringArray(FieldNames,','); //may contain the id field - needs removing
    MyValuesArray:= self.StrToStringArray(FieldValues,',');
    IDX:=StartIndex;
    While IDX< Length(MyFieldsArray) do begin
      strValue:= self.GetNewFieldValue(MyFieldsArray[idx],MyValuesArray[idx],TableName,connString);
      if IDX=1 then SETstring:= MyFieldsArray[IDX]+ ' = '+ strValue
      else SETstring:= SETstring+','+MyFieldsArray[IDX] + ' = '+ strValue;
      IDX:= IDX+1;
    end; {while}
    SQLcmd:= 'UPDATE '+TableName+' SET '+SETstring;
    if Length(Filter)>0 then SQLcmd:= SQLcmd+' WHERE '+Filter;
  end;
  Result:= SQLcmd;
end;

function TDBOperations.PrepareUpdate(TableName, FieldNames, FieldValues, Filter,ExcludeList: string; StartIndex:integer=1): string;
var
  SQLcmd: string;
  SETstring: string;
  MyFieldsArray: TstrArray;
  MyValuesArray: TstrArray;
  IDX: integer;
  strValue: string;
  FieldList: TStringList;
  constr: widestring;
begin
  //FieldNames and FieldValues contains delimited string by comma
  //Need to build a list of excluded fields from the passed string.
  //Each field will have a corresponding element in the excluded array,
  // This array is of boolean type, so excluded array will have same
  // amount of elements as the fields array.
  //constr:= self.connString; - WILL BE BLANK !
  constr:= self.connString;
  //.dbOperations.ConnString is never assigned a value:
  //SO how do we assign the parent value to the child object value ???
  FieldList:= TStringList.Create;
  SQLcmd:= '';
  try
    if Length(self.GetConnectionString)=0 then begin
      self.errorMessage:= 'No Connection String specified';
      SQLcmd:= 'error';
    end
    else begin

      if Length(FieldNames) = 0 then
        FieldNames:= ExtractFieldNames(constr,TableName);
      fExcludedFields:= self.SetupExcludeList(FieldNames,ExcludeList); //returns number of excluded fields.
      setLength(MyFieldsArray,Length(MyFieldsArray)+1);
      setLength(MyValuesArray,Length(MyValuesArray)+1);

      //somehow remove the excluded fields from the list - use stringlist?
      MyFieldsArray:= self.StrToStringArray(FieldNames,','); //may contain the id field - needs removing
      MyValuesArray:= self.StrToStringArray(FieldValues,',');
      IDX:= StartIndex; //was value:0 but id ends up being saved as 0, causes problems.
      While IDX< Length(MyFieldsArray) do begin
        //getting range error here - simply more fields than values elements.
        strValue:= self.GetNewFieldValue(MyFieldsArray[idx],MyValuesArray[idx],TableName,constr);
        if ExcludeArray[IDX] = FALSE then begin

          if Length(SETstring)=0 then
            SETstring:= MyFieldsArray[IDX]+ ' = '+ strValue
          else SETstring:= SETstring+','+MyFieldsArray[IDX] + ' = '+ strValue;

        end; //end if
        IDX:= IDX+1;
      end; {while}
      if Length(SETstring)>0 then begin
        SQLcmd:= 'UPDATE '+TableName+' SET '+SETstring;
        if Length(Filter)>0 then SQLcmd:= SQLcmd+' WHERE '+Filter;
      end
      else
        SQLcmd:= 'ERROR';
    end; //if
  finally
    FreeAndNil(FieldList);
  end;

  Result:= SQLcmd;
end;

procedure TDBOperations.RemoveDuplicates(const theStringList: TStringList);
var
  buffer: TStringList;
  countStrings: integer;
begin
  theStringList.Sort;
  buffer:= TStringList.Create;
  try
    buffer.Sorted:= True;
    buffer.Duplicates:= dupIgnore;
    buffer.BeginUpdate;
    for countStrings := 0 to theStringList.Count-1 do
        buffer.Add(theStringList[countStrings]);
    buffer.EndUpdate;
    theStringList.Assign(buffer);
  finally
    FreeAndNil(buffer);
  end;
end;

function TDBOperations.CreateListFromStringArray(theStringArray: TstrArray; SortList:boolean = TRUE):TStringList;
var
  buffer: TStringList;
  countStrings: integer;
begin
  buffer:= TStringList.Create;
  try
    buffer.BeginUpdate;
    for countStrings := 0 to High(theStringArray) do
        buffer.Add(theStringArray[countStrings]);
    buffer.EndUpdate;
    buffer.Duplicates:= dupIgnore;
    if SortList then
      buffer.Sorted:= True;
    Result:= buffer;
  finally
    FreeAndNil(buffer);
  end;
end;

procedure TDBOperations.SetfFieldsArray(const FieldArray: TstrArray);
begin
  SetLength(fFieldsArray,0);
  SetLength(fFieldsArray,Length(fFieldsArray)+1);
  self.fFieldsArray:= FieldArray;

end;

procedure TDBOperations.SetFields(Fieldlist: string);
begin
  //SetFields
end;

procedure TDBOperations.SetFValuesArray(const ValueArray: TstrArray);
begin
  SetLength(fValuesArray,0);
  SetLength(fValuesArray,Length(fValuesArray)+1);
  self.fValuesArray:= ValueArray;
end;

procedure TDBOperations.SetQueryString(qryString: string);
begin
  self.fQueryString:= qryString;
end;

procedure TDBOperations.SetTableCount(TheTableCount: integer);
begin
  self.fTableCount:= TheTableCount;
end;

procedure TDBOperations.SetTablenames(StringArray: TstrArray);
begin
  SetLength(fTableNames,Length(StringArray)+1);
  fTableNames:= StringArray;
end;

function TDBOperations.SetupExcludeList(FieldList, ExcludedList: string): integer;
var
  IDX,IDX2: integer;
  FieldArray: TstrArray;
  strExcludeArray: TstrArray;
begin
  //Maybe quicker with a stringlist.
  FieldArray:= strToStringArray(FieldList,','); //eg id,firstname,lastname,username,password
  SetLength(ExcludeArray,0); //clears out array
  SetLength(ExcludeArray,Length(FieldArray)+1); //False,False,False,False,False
  strExcludeArray:= strToStringArray(ExcludedList,','); //eg id,username only thus ExcludeArray = True,false,false,true,false
  IDX:=0;
  IDX2:=0;
  if Length(ExcludedList)>0 then begin
    while IDX<Length(FieldArray) do begin
      IDX2:=0;
      while IDX2<Length(strExcludeArray) do begin
        if Uppercase(FieldArray[IDX]) = Uppercase(strExcludeArray[IDX2]) then begin
          ExcludeArray[IDX]:= TRUE;
          //saved to self.ExcludeArray[]
        end; //if
        IDX2:= IDX2+1;
      end;  //while IDX2
      IDX:= IDX+1;
    end; //while IDX
  end; //if
  Result:= IDX2; //will return 0 if no excluded fields passed or to number of excluded fields.
end;

procedure TDBOperations.SetValues(Valuelist: string);
begin
  //
end;

function TDBOperations.StringArrayToString(TheArray:TstrArray; SubString: string): string;
var
  IDX: integer;
  Elements: integer;
  CommaPos: integer;
  Extract:string;
  FinalString: string;
begin
  IDX:=0;
  Elements:=0;
  Extract:= '';
  FinalString:= '';
  while idx<Length(TheArray) do begin
    Extract:= '';
    Extract:= TheArray[IDX];
    if IDX=0 then
      FinalString:= Extract
    else
      FinalString:= FinalString+SubString+Extract;
    idx:= idx+1;
  end;
  Result:= FinalString;
end;

function TDBOperations.StrToStringArray(TheString, SubString: string): TstrArray;
var
  IDX: integer;
  Elements: integer;
  CommaPos: integer;
  Extract:string;
begin
  IDX:=0;
  Elements:=0;
  SetLength(FStringArray,0); //should clear the array ?
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
end;

function TDBOperations.StrToStringArray(TheString, SubString:string; StartIndex:integer): TstrArray;
var
  IDX: integer;
  CommaPos: integer;
  Extract:string;
  SaveIdx: integer;
begin
  IDX:= 0;
  SetLength(FStringArray,0);
  SaveIdx:= StartIndex; //index result array at startIndex i.e. allows index to start at 1 not 0
  //this will automatically create a dummy - uninitialised element of zero.
  //while (PosEx(SubString,TheString,IDX+1)>0) do begin
  if StartIndex>0 then SetLength(FStringArray,Length(FStringArray)+StartIndex);
  Repeat
    Extract:= '';
    CommaPos:= PosEx(SubString,TheString,IDX+1);
    if CommaPos>0 then
      Extract:= Copy(TheString,IDX+1,(CommaPos-(IDX+1)))
    else
      Extract:= Copy(TheString,IDX+1,Length(TheString));
    SetLength(FStringArray,Length(FStringArray)+1);
    FStringArray[SaveIdx]:= Extract;
    SaveIdx:= SaveIdx+1;
    IDX:=CommaPos;
  Until CommaPos = 0;
  //end; {while}

  Result:= FStringArray;
end;

function TDBOperations.UpdateData(TableName: string;
  connString: widestring; FieldList,dataValues,Filter:String; FieldExcludeList:String = ''; StartIndex:integer=1):integer;
var
  Errors: integer;
  ADOQuery: TADOQuery;
  cmdSQL: string;
  FieldsArray: TstrArray;
  ValuesArray: TstrArray;
begin
  //update Data
  //will get a RANGE error if the elements dont match up - missmatch.

  FieldsArray:= self.StrToStringArray(FieldList,',');
  ValuesArray:= self.StrToStringArray(dataValues,',');
  Errors:= 0;
  ADOQuery:= TADOQuery.Create(nil);
  cmdSQL:= self.PrepareUpdate(TableName,FieldList,dataValues,Filter,FieldExcludeList,StartIndex);
  try
    ADOQuery.ConnectionString:= connString;
    ADOQuery.Close;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add(cmdSQL);
    ADOQuery.ExecSQL;
  finally
    FreeAndNil(ADOQuery);
  end;
  Result:= Errors;
end;

function TDBOperations.UpdateData(TableName: string;
  connString: widestring; dataValues,Filter:string; FieldExcludeList: string = ''; StartIndex:integer=1):integer;
var
  Errors: integer;
  ADOQuery: TADOQuery;
  cmdSQL,FieldList: string;
begin
  //update Data- checking at 18:03 on 23-05-2016.
  Errors:= 0;
  ADOQuery:= TADOQuery.Create(nil);
  FieldList:= self.ExtractFieldNames(connString,TableName);
  cmdSQL:= self.PrepareUpdate(TableName,FieldList,dataValues,Filter,FieldExcludeList,StartIndex);
  try
    ADOQuery.ConnectionString:= connString;
    ADOQuery.Close;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add(cmdSQL);
    Errors:= ADOQuery.ExecSQL;
  finally
    FreeAndNil(ADOQuery);
  end;
  Result:= Errors;
end;

function TDBOperations.GetConnectionString: widestring;
begin
  Result:= self.fConnectionString;
end;

function TDBOperations.GetfFieldsArray: TstrArray;
begin
  Result:= self.fFieldsArray;
end;

procedure TDBOperations.SetConnectionString(connString: widestring);
begin
  self.fConnectionString:= connString;
end;

procedure TDBOperations.AddTablename(tablename: string);
var
  LastIndex: integer;
begin
  LastIndex:= Length(self.fTableNames);
  SetLength(self.fTableNames,LastIndex+1);
  self.fTableNames[LastIndex-1]:= tablename;
end;

function TDBOperations.GetTableCount: integer;
begin
  Result:= self.fTableCount;
end;

function TDBOperations.GetTablenames: TstrArray;
begin
  Result:= self.fTableNames;
end;

function TDBOperations.GetID(index: integer): integer;
begin
  if Index<=High(fIDArray) then
    Result:= self.fIDArray[index]
  else Result:= 0;
end;

function TDBOperations.InsertData(TableName: string;
  connString: widestring; dataValues: string): integer;
var
  ADOQuery: TADOQuery;
  SQLQuery: TSQLQuery;
  cmdSQL: string;
  FieldList: string;
  Errors:integer;
  idx: integer;
  paramIdx: integer;
  valueIdx: integer;
  ParamName: string;
  VariantVal: oleVariant;
  tempDateTime: TDateTime;
  NewYear,NewMonth,NewDay: word;
  NewHour,NewMin,NewSec,MSec: word;
begin
  //Insert Data - No FieldNAmes given
  //Element 0= id, 1= Customerid, 2= AccountNo, 3= EnergyType, 4= DateOfReading,
  //Element 5= TimeOfReading, 6= ReadingTakenBy, 7= Reading1, 8= MeterNumber, 9= Tariff
  Errors:=0;
  ADOQuery:= TADOQuery.Create(nil);
  FieldList:= self.ExtractFieldNames(connString,TableName); //starting at 0 with id
  self.fFieldsArray:= self.StrToStringArray(FieldList,','); //starting at 0 with id
  self.fValuesArray:= self.StrToStringArray(dataValues,','); //Element 0 will be empty , 1= customer id
  cmdSQL:= self.PrepareInsert(TableName,FieldList,dataValues); //should end up as :
  //INSERT INTO energy_gasmeterreadings
  //(id,Customerid,AccountNo,EnergyType,DateOfReading,TimeOfReading,
  //ReadingTakenBy,Reading1,MeterNumber,Tariff) VALUES (null,1,'ac123','gas',
  //20-04-2014 22:22,20-04-2014 22:22,'Customer',456.1,0045634524,'Blue Plus Promise')
  //The following actually works !!!! record was successfully inserted upon last test.
  //cmdSQL:= 'INSERT INTO energy_gasmeterreadings (id,Customerid,DateOfReading,TimeOfReading) VALUES (null,1,"2014-04-21 03:31:00","2014-04-21 03:31:00")';
  try
    ADOQuery.ConnectionString:= connString;
    ADOQuery.Close;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add(cmdSQL);
    idx:=0;
    paramIdx:= 1;
    valueIdx:= 0;
    {
    while idx< Length(self.fTypesArray) do begin
      ParamName:= 'dataval'+IntToStr(paramIdx);
      VariantVal:= VariantArray[valueIdx];
      if self.fTypesArray[idx] = 'FTWIDESTRING' then begin
        //something wrong with fValuesArray[idx] - maybe not defined -
        //on testing worked BUT inserted :dataval1 and :dataval2 into the two fields specified !!!
        ADOQuery.Parameters.CreateParameter(ParamName,ftString,pdInputOutput,200,VariantVal);
        //ADOQuery.Parameters.AddParameter.Name:= ParamName;
        //ADOQuery.Parameters.AddParameter.DataType:= ftString;
        //ADOQuery.Parameters.AddParameter.Direction:= pdInputOutput;
        ADOQuery.Parameters.ParamByName(ParamName).Value:= VariantVal;
        //ADOQuery.Parameters.ParamByName(ParamName).ToString:= self.fValuesArray[idx];
      end;
      if self.fTypesArray[idx] = 'FTINTEGER' then begin
        ADOQuery.Parameters.CreateParameter(ParamName,ftInteger,pdInputOutput,10,VariantVal);
        //ADOQuery.Parameters.AddParameter.Name:= ParamName;
        //ADOQuery.Parameters.AddParameter.DataType:= ftInteger;
        ADOQuery.Parameters.ParamByName(ParamName).Value:= VariantVal;
      end;
      if self.fTypesArray[idx] = 'FTAUTOINC' then begin
        ADOQuery.Parameters.CreateParameter(ParamName,ftAutoInc,pdInputOutput,10,VariantVal);
        //ADOQuery.Parameters.AddParameter.Name:= 'AutoInc';
        //ADOQuery.Parameters.AddParameter.DataType:= ftInteger;
        ADOQuery.Parameters.ParamByName(ParamName).Value:= NULL;
      end;
      if self.fTypesArray[idx] = 'FTDATETIME' then begin
        ADOQuery.Parameters.CreateParameter(ParamName,ftDateTime,pdInputOutput,10,VariantVal);
        //NewDate:= cnovert from string to DateTime
        //ADOQuery.Parameters.AddParameter.Name:= ParamName;
        //ADOQuery.Parameters.AddParameter.DataType:= ftDateTime;
        VariantVal:= VariantArray[valueIdx];
        DecodeDateTime(VariantVal,NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,MSec);
        tempDateTime:= EncodeDateTime(NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,MSec);
        ADOQuery.Parameters.ParamByName(ParamName).Value:= tempDateTime;

      end;
      if self.fTypesArray[idx] = 'FTFLOAT' then begin
        ADOQuery.Parameters.CreateParameter(ParamName,ftFloat,pdInputOutput,10,VariantVal);
        //ADOQuery.Parameters.AddParameter.Name:= ParamName;
        //ADOQuery.Parameters.AddParameter.DataType:= ftFloat;
        ADOQuery.Parameters.ParamByName(ParamName).Value:= VariantVal;
      end;
      idx:= idx+1;
      paramIdx:= paramIdx+1;
      valueIdx:= valueIdx+1;
    end;
    }
    ADOQuery.ExecSQL;
  finally
    FreeAndNil(ADOQuery);
  end;
  Result:= Errors;
end;

function TDBOperations.WriteChanges(TableName: string; DateTimeOfChange:TDateTime):integer;
var
  ChangeADOQuery: TADOQuery;
  cmdSQL: string;
  tempDateTime: TDateTime;
  NewYear,NewMonth,NewDay: word;
  NewHour,NewMin,NewSec,MSec: word;
begin
  //write to table to record changes - can be for web app also - to indicate changes made to DB in general.

end;

function TDBOperations.InsertData(TableName: string;
  connString: widestring; FieldList, dataValues: string): integer;
var
  ADOQuery: TADOQuery;
  cmdSQL: string;
  Errors: integer;
  idx: integer;
  NewDate: TDateTime;
  ParamName: string;
  VariantVal: oleVariant;
  tempDateTime: TDateTime;
  NewYear,NewMonth,NewDay: word;
  NewHour,NewMin,NewSec,MSec: word;
begin
  //Insert Data - FieldNames given
  //any string data needs to be enclosed in quotes.
  //maybe also write to changes table to signify a change to a db table has occured ?
  Errors:=0;
  ADOQuery:= TADOQuery.Create(nil);
  //following line will produce an error if any blank fields passed:
  cmdSQL:= self.PrepareInsert(TableName,FieldList,dataValues);
  //cmdSQL used to contain INSERT INTO table (fields) VALUES (:dataval1, :dataval2 ...)
  //now contains string with values of different types separated by comma ready for SQL EXEC
  //Not use parameters for now. - 22/04/2014
  try
    ADOQuery.ConnectionString:= connString;
    ADOQuery.Close;
    ADOQuery.ParamCheck:= True;
    ADOQuery.SQL.Clear;
    ADOQuery.SQL.Add(cmdSQL);
    //add parameters here
    idx:=0;
    ADOQuery.ExecSQL;

  finally
    FreeAndNil(ADOQuery);
  end;
  //Connection string required !!
  Result:= Errors;
end;

function TDBOperations.GetTotalRecords(TableName:string; connString:widestring):integer;
var
  idx: integer;
  TotalRecords: integer;
  SQLQuery: string;
  ADOQuery: TADOQuery;
begin
  SQLQuery:= 'SELECT * FROM '+TableName;
  idx:=0;
  ADOQuery:= TADOQuery.Create(nil);
  try
    try
      ADOQuery.Close;
      ADOQuery.ConnectionString:= connString;
      ADOQuery.ParamCheck:= True;
      ADOQuery.SQL.Clear;
      ADOQuery.SQL.Add(SQLQuery);
      //add parameters here
      ADOQuery.Open;
      ADOQuery.First;
      while NOT ADOQuery.Eof do begin
        idx:= idx+1;
        ADOQuery.Next;
      end;
    except on E: Exception
      do begin
        TotalRecords:= 0;
        self.errorMessage:= e.Message;
        exit;
      end;

    end;

  finally
    FreeAndNil(ADOQuery);
  end;
  TotalRecords:= idx;
  Result:= TotalRecords;
end;

function TDBOperations.InsertDBXData(TableName: string;
  connString: widestring; FieldList, dataValues: string): integer;
var
  SQLQuery: TSQLQuery;
  cmdSQL: string;
  Errors: integer;
  idx: integer;
  ParamName: string;
begin
  //Insert Data - FieldNames given
  //any string data needs to be enclosed in quotes.
  Errors:=0;
  SQLQuery:= TSQLQuery.Create(nil);
  //ADOQuery:= TADOQuery.Create(nil);
  cmdSQL:= self.PrepareInsert(TableName,FieldList,dataValues);
  //cmdSQL will contain INSERT INTO table (fields) VALUES (:datavalue1,:datavalue2 ...)
  //need an array containing the types. convert the list of parameters into array.
  //self.fTypesArray now holds 'FTWIDESTRING' etc.
  try
    //ADOQuery.ConnectionString:= connString;
    //ADOQuery.Close;
    //ADOQuery.SQL.Clear;
    //ADOQuery.SQL.Add(cmdSQL);
    //SQLQuery.SQLConnection - somehow must specify connection string - could be through connectionName
    //SQLQuery.SQLConnection:= SQLConnectionString;
    SQLQuery.Close;
    SQLQuery.SQL.Clear;
    SQLQuery.SQL.Add(cmdSQL);
    //add parameters here
    idx:=0;
    while idx< Length(self.fTypesArray) do begin
      ParamName:= 'dataval'+IntToStr(idx+1);
      if self.fTypesArray[idx] = 'FTWIDESTRING' then begin
        //SQLQuery.Params.AddParam(ParamName);
        SQLQuery.Params.CreateParam(ftString,ParamName,ptInputOutput);
        //something wrong with fValuesArray[idx] - maybe not defined -
        //on testing was blank !
        SQLQuery.Params.ParamByName(ParamName).AsString:= self.fValuesArray[idx];
        //ADOQuery.Parameters.AddParameter.Name:= ParamName;
        //ADOQuery.Parameters.AddParameter.DataType:= ftString;
        //ADOQuery.Parameters.ParamByName(ParamName).Value:= self.fValuesArray[idx];
      end;
      if self.fTypesArray[idx] = 'FTINTEGER' then begin
        //SQLQuery.Params.AddParam(ParamName);
        SQLQuery.Params.CreateParam(ftString,ParamName,ptInputOutput);
        SQLQuery.Params.ParamByName(ParamName).AsInteger:= StrToInt(self.fValuesArray[idx]);
        //ADOQuery.Parameters.AddParameter.Name:= ParamName;
        //ADOQuery.Parameters.AddParameter.DataType:= ftString;
        //ADOQuery.Parameters.ParamByName(ParamName).Value:= StrToInt(self.fValuesArray[idx]);
      end;
      idx:= idx+1;
    end;
    //ADOQuery.ExecSQL;
  finally
    //FreeAndNil(ADOQuery);
  end;
  //Connection string required !!
  SQLQuery.ExecSQL(False);
  Result:= Errors;
end;

function TDBOperations.CreateVariantArray(const MaxElements:integer):Variant;
begin
  VariantArray:= VarArrayCreate([0,MaxElements],VarVariant);
  Result:= VariantArray;
end;

function TDBOperations.AddVariant(FieldPlaceIndex:integer; Value:Variant): integer;
begin
  //Add new value into variant array to be included into INSERT query.
  //may need VarArrayDimCount(Variant) returns integer
  //may need VarArrayLowBound(ArrayName,dimension) to VarArrayHighBound(Arrayname,dimension) - usually 1
  //use VarArrayPut(VarArray,idx,[idx]) and VarArrayRedim(vararrayname,newvalue) special variant commands
end;

procedure TDBOperations.ClearErrors;
begin
  self.errorMessage:= '';
end;

procedure TDBOperations.ClearMessages;
begin
  self.queryMessage:= '';
end;

{ TLinkOperations }

constructor TLinkOperations.Create(id1,id2:integer; comboName: string);
begin
  //Create link object to manipulate database entry

end;

destructor TLinkOperations.Destroy;
begin
  //destroy link object

  inherited;
end;

function TLinkOperations.InsertIDs: boolean;
begin
  //Insert comboID, LinkID, ComboName into table energy_linktable

end;

{ UsefulRoutines }

function TUsefulRoutines.GetGridColumnWidths(DBGrid: TDBGrid): TintArray;
var
  colwidths: TintArray;
  idx: integer;
begin
  idx:= 0;
  setlength(colwidths,1);
  if DBGrid.Columns.Count>0 then begin

    while idx< DBGrid.Columns.Count do begin
      colwidths[idx]:= DBGrid.Columns[idx].Width;
      idx:= idx+1;

    end;
  end
  else
    colwidths[0]:= 100;
  result:= colWidths;
end;

function TUsefulRoutines.GetItems: TintArray;
begin
  //get individual items from serial number
end;

function TUsefulRoutines.GetSerialNumber: uint;
begin
  //get serial number
end;

function TUsefulRoutines.GetStringArray: TstrArray;
var
  TempArray: TstrArray;
begin
  SetLength(TempArray,Length(self.fStringArray));
  TempArray:= fStringArray;
  Result:= TempArray;
end;

function TUsefulRoutines.SetGridColumns(DBGrid: TDBGrid; MaxRows:integer; offset:integer = 0): TintArray;
var
  ColIDX: integer;
  RowIDX: integer;
  ColWidth: integer;
  ColWidthIndex: integer;
  NewColWidths: TintArray;
  CellContent: string;
begin
  //This function actually returns the MAX column width:
  RowIDX:= 0;
  CellContent:= '';
  ColIDX:= 0;
  while ColIDX< DBGrid.Columns.Count do begin
    SetLength(NewColWidths,Length(NewColWidths)+1);
    CellContent:= DBGrid.Columns[ColIDX].Title.Caption;
    ColWidth:= DBGrid.Canvas.TextWidth(CellContent)+offset;
    NewColWidths[ColIDX]:= ColWidth;
    DBGrid.Columns[ColIDX].Title.Alignment:= taCenter;  //taLeftJustify,taRightJustify
    ColIDX:= ColIDX+1;
  end;

  while RowIDX<= MaxRows do begin
    ColIDX:= 0;
    while ColIDX< DBGrid.Columns.Count do begin
       CellContent:= '';
       //if (Canvas.TextHeight(Pages[i].Caption) * 2) > TabHeight then
       //ColWidth:= DBGrid.Columns[ColIDX].Width;
       //NEed to get the content of each cell - as a string:
       CellContent:= DBGrid.Fields[ColIDX].AsString; //string content in cell.
       //need to convert length in chars of content to equivalent width in pixels
       ColWidth:= DBGrid.Canvas.TextWidth(CellContent)+10;
       if ColWidth> NewColWidths[ColIDX] then begin
         NewColWidths[ColIDX]:= ColWidth;
         DBGrid.Columns[ColIDX].Width:= ColWidth;
       end;

      ColIDX:= ColIDX+1;
    end;

    RowIDX:= RowIDX+1;
  end;
  result:= NewColWidths;
end;

procedure TUsefulRoutines.SetSerialNumber(SerialItems:TintArray);
var
  idx: integer;
  FinalNumber: uint;
  ItemNumber: integer;
begin
  idx:= 0;
  while idx<Length(SerialItems) do begin
    ItemNumber:= SerialItems[idx];
    FinalNumber:= FinalNumber+ ItemNumber;
  end;
  self.fSerialNumber:= FinalNumber;
end;

function TUsefulRoutines.StringArrayToString(TheArray: TstrArray;
  SubString: string): string;
var
  IDX: integer;
  Elements: integer;
  CommaPos: integer;
  Extract:string;
  FinalString: string;
begin
  IDX:=0;
  Elements:=0;
  Extract:= '';
  FinalString:= '';
  while idx<Length(TheArray) do begin
    Extract:= '';
    Extract:= TheArray[IDX];
    if IDX=0 then
      FinalString:= Extract
    else
      FinalString:= FinalString+SubString+Extract;
    idx:= idx+1;
  end;
  Result:= FinalString;
end;

function TUsefulRoutines.StrToStringArray(TheString, SubString: string): TstrArray;
var
  IDX: integer;
  Elements: integer;
  CommaPos: integer;
  Extract:string;
begin
  IDX:=0;
  Elements:=0;
  SetLength(FStringArray,0); //should clear the array ?
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
end;

function TUsefulRoutines.StrToStringArray(TheString, SubString: string;
  StartIndex: integer): TstrArray;
var
  IDX: integer;
  CommaPos: integer;
  Extract:string;
  SaveIdx: integer;
begin
  IDX:= 0;
  SetLength(FStringArray,0);
  SaveIdx:= StartIndex; //index result array at startIndex i.e. allows index to start at 1 not 0
  //this will automatically create a dummy - uninitialised element of zero.
  //while (PosEx(SubString,TheString,IDX+1)>0) do begin
  if StartIndex>0 then SetLength(FStringArray,Length(FStringArray)+StartIndex);
  Repeat
    Extract:= '';
    CommaPos:= PosEx(SubString,TheString,IDX+1);
    if CommaPos>0 then
      Extract:= Copy(TheString,IDX+1,(CommaPos-(IDX+1)))
    else
      Extract:= Copy(TheString,IDX+1,Length(TheString));
    SetLength(FStringArray,Length(FStringArray)+1);
    FStringArray[SaveIdx]:= Extract;
    SaveIdx:= SaveIdx+1;
    IDX:=CommaPos;
  Until CommaPos = 0;
  //end; {while}

  Result:= FStringArray;
end;

procedure TUsefulRoutines.InsertValueIntoForm(ParentForm:TFORM; Formname,ControlName,Value: string;ControlType:string = 'TEdit');
var
  idx: integer;
  controlIDX: integer;
  winControl: TWinControl;
  TheControl: TControl;
  ComponentName: string;
  ctrlName: string;
  TheComponent: TComponent;
begin
  idx:= 0;
  //does not need inner / outer loop - just 2 loops one after the other.
  //the first one will get the correct index of the formname being passed from
  // the list of windows open ???
  //must detect if window is open before values can be passed INTO it !!
  while idx< ParentForm.MDIChildCount do begin
    if (Uppercase(Formname) = Uppercase(ParentForm.MDIChildren[idx].Name)) then begin
      controlIDX:= 0;
      while controlIDX< ParentForm.MDIChildren[idx].ComponentCount do begin
        //Currently it shows all of the controls !!!!!!!!!!!!!!!!!!!!!
        //winControl:= MDIChildren[controlIDX].Parent;
        ComponentNAme:= ParentForm.MDIChildren[idx].Components[controlIDX].Name;
        //ShowMessage('Name= '+ComponentName);
        if (Uppercase(ControlName) = Uppercase(ComponentName)) then begin
          //test the type of the component:
          //TheControl:= MDIChildren[idx].Controls[controlIDX];
          //if TheControl is TEdit then begin
            TheComponent:= ParentForm.MDIChildren[idx].Components[controlIDX].FindComponent(ControlName); //returns nil
            if Assigned(TheComponent) then
              ctrlName:= TheComponent.Name;
            if ParentForm.MDIChildren[idx].Components[controlIDX] is TControl then begin
              TheControl:= TControl(ParentForm.MDIChildren[idx].Components[controlIDX]);
              if Uppercase(ControlType) = 'TEDIT' then begin
                TEdit(TheControl).Text:= Value;
                exit;
              end;
              if Uppercase(ControlType) = 'TMEMO' then begin
                TMemo(TheControl).Lines.Add(Value);
                exit;
              end;
              if Uppercase(ControlType) = 'TLABEL' then begin
                TLabel(TheControl).Caption:= Value;
                exit;
              end;
            end;
          //end
          //else begin
          //  TLabel(TheControl).Caption:= Value;

          //end;

        end; //if controlName = ComponentName
        controlIDX:= controlIDX+1;
      end;
    end;
    idx:= idx+1;
  end;
end;

function TUsefulRoutines.GetValueFromForm(ParentForm:TForm; Formname,ControlName: string):string;
var
  idx: integer;
  controlIDX: integer;
  winControl: TWinControl;
  TheControl: TControl;
  ComponentName: string;
  ctrlName: string;
  TheComponent: TComponent;
begin
  idx:= 0;
  while idx< ParentForm.MDIChildCount do begin
    if (Uppercase(Formname) = Uppercase(ParentForm.MDIChildren[idx].Name)) then begin
      controlIDX:= 0;
      while controlIDX< ParentForm.MDIChildren[idx].ComponentCount do begin
        //Currently it shows all of the controls !!!!!!!!!!!!!!!!!!!!!
        //winControl:= MDIChildren[controlIDX].Parent;
        ComponentNAme:= ParentForm.MDIChildren[idx].Components[controlIDX].Name;
        //ShowMessage('Name= '+ComponentName);
        if (Uppercase(ControlName) = Uppercase(ComponentName)) then begin
            if ParentForm.MDIChildren[idx].Components[controlIDX] is TControl then begin
              TheControl:= TControl(ParentForm.MDIChildren[idx].Components[controlIDX]);
              Result:= TEdit(TheControl).Text;
              exit;
            end;
        end; //if controlName = ComponentName
        controlIDX:= controlIDX+1;
      end;
    end;
    idx:= idx+1;
  end;
  Result:= '';
end;


end.
