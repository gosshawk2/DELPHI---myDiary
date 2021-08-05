unit ViewGrid;

interface

uses Windows, Classes, Graphics, Forms, Controls, StdCtrls, Buttons,
  ExtCtrls, Grids, DBGrids, DB, ADODB, Provider, DBClient,
  SqlExpr, dialogs, inifiles, sysUtils, myDatabaseClass_II, Data.DBXMySQL,
  Data.FMTBcd ;

type
  TfrmDBView = class(TForm)
    pnlTop: TPanel;
    btnClose: TBitBtn;
    pnlGrid: TPanel;
    DBGrid1: TDBGrid;
    ADOConnection1: TADOConnection;
    qryData: TADOQuery;
    dsGrid: TDataSource;
    ClientDataSet1: TClientDataSet;
    DataSetProvider1: TDataSetProvider;
    ADOTable1: TADOTable;
    SQLConnection1: TSQLConnection;
    SQLQuery1: TSQLQuery;
    comTables: TComboBox;
    btnConnect: TBitBtn;
    btnGetTables: TBitBtn;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCloseClick(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure btnConnectClick(Sender: TObject);
    procedure comTablesClick(Sender: TObject);
    procedure btnGetTablesClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    myConnection: TDBConnections;
    TableSelected: string;
    ViewQuery: string;
    function GetTableNames:TStrings;
    //myOperations: TDBOperations;
  end;

implementation

uses Main;

{$R *.dfm}

procedure TfrmDBView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if Assigned(myConnection) then begin
    //myOperations.CloseQuery;
    //MainForm.CloseMDIChild(-1);
    ShowMessage('Query Closed');
    //myOperations.Destroy;
    myConnection.Destroy;
  end;
  Action := caFree;
end;

procedure TfrmDBView.btnCloseClick(Sender: TObject);
begin
  if Assigned(myConnection) then begin
    //myOperations.CloseQuery;
    //myOperations.Destroy;
    FreeAndNil(myConnection);
  end;
  MainForm.CloseMDIChild(-1);
end;

procedure TfrmDBView.FormResize(Sender: TObject);
begin
  DBGrid1.Width:= width-20;
  DBGrid1.Height:= Height-20;
end;

procedure TfrmDBView.btnConnectClick(Sender: TObject);
var
  strCon:widestring;
  queryString: string;
  TableList: TStrings;
begin
  TableList:= TStringList.Create;
  try
    if MainForm.CheckLogin then begin
      myConnection:= TDBConnections.Create;
      //strCon:= myConnection.ADOConnection.ConnectionString;

      //for production - encrypt password and put into registry,
      //then will need a change password option
      strCon:= MainForm.MainConnection.ConnString;
      myConnection.Password:= MainForm.MainConnection.Password;
      myConnection.Server:= MainForm.MainConnection.Server;
      myConnection.DBName:= MainForm.MainConnection.DBName;
      myConnection.UID:= MainForm.MainConnection.UID;
      myConnection.Port:= MainForm.MainConnection.Port;
      myConnection.ConnString:= strCon;
      //ShowMessage('Connection STring= '+strCon);

      //myOperations.OpenQuery(strCon,'','SELECT * FROM Energy_Users');
      //MainForm.StatusBar.Panels[0].Text:= 'hey2';
      //ShowMessage('Connection STring2= '+myOperations.ADOQuery.ConnectionString);
      //myConnection.ADOConnection.GetTableNames(TableList);
      //TableList.AddStrings(self.GetTableNames);
      //comTables.Items.Assign(TableList);
      TableList:= self.GetTableNames;
      if Length(TableSelected)>0 then
        queryString:= 'SELECT * FROM '+TableSelected
      else if Length(ViewQuery)>0 then begin
        queryString:= ViewQuery;
      end
      else
        queryString:= 'SELECT * FROM '+TableList[0];


      myConnection.DBOperations.CreateQuery(strCon,'SELECT',queryString);
      //ShowMessage('query message= '+myConnection.DBOperations.queryMessage);
      myConnection.OpenConnection('',False);
      dsGrid.DataSet:= myConnection.DBOperations.ADOQuery;
      myConnection.DBOperations.ADOQuery.Open;
      //myConnection.ADOConnection.GetTableNames(comTables.Items,false);
      //qryData.Connection:= myConnection.ADOConnection;
      //qryData.Close;
      //qryData.SQL.Clear;
      //qryData.SQL.Add('SELECT * FROM Energy_ElectricMeterReadings');
      //qryData.Open;
    end
    else
      ShowMessage('Please Login');
  finally
    FreeAndNil(TableList);

  end;
end;

procedure TfrmDBView.btnGetTablesClick(Sender: TObject);
var
  myTableList: TStrings;
begin
  myTableList:= TStringList.Create;
  try
    MainForm.MainConnection.ADOConnection.GetTableNames(myTableList,false);
    comTables.Items:= myTableList;
  finally
    freeAndNil(myTableList);
  end;
end;

procedure TfrmDBView.comTablesClick(Sender: TObject);
var
  Chosen: string;
begin
  //Table has been selected
  Chosen:= comTables.Text;
  self.ViewQuery:= 'SELECT * FROM '+Chosen;
end;

function TfrmDBView.GetTableNames:TStrings;
var
  mysqlConn: TDBConnections;
  strConn: WideString;
  TableList: TStrings;
begin
  TableList:= TStringList.Create;
  mysqlConn:= TDBConnections.Create;
  try
    if MainForm.CheckLogin then begin
      strConn:= MainForm.MainConnection.ConnString;
      mysqlConn.Password:= MainForm.MainConnection.Password;
      mysqlConn.Server:= MainForm.MainConnection.Server;
      mysqlConn.DBName:= MainForm.MainConnection.DBName;
      mysqlConn.UID:= MainForm.MainConnection.UID;
      mysqlConn.Port:= MainForm.MainConnection.Port;
      mysqlConn.ConnString:= strConn;
      mysqlConn.OpenConnection(strConn,false);
      mysqlConn.ADOConnection.GetTableNames(TableList,false);
      //mysqlConn.ADOConnection.GetTableNames(comTables.Items,false);
    end;
  finally
    Result:= TableList;
    freeAndNil(TableList);
    freeAndNil(mysqlConn);

  end;

end;

end.
