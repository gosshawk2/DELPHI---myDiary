unit SelectDiaryEntry;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, myDatabaseClass_II, Data.DB, ADODB, strUtils;

type
  TfrmSelectDiaryEntry = class(TForm)
    dbSelectGrid: TDBGrid;
    pnlTop: TPanel;
    btnClose: TBitBtn;
    pnlDetails: TPanel;
    btnSelect: TBitBtn;
    txtBrief: TEdit;
    lblBrief: TLabel;
    lblDate: TLabel;
    txtDate: TEdit;
    lblPrivateEntry: TLabel;
    txtTime: TEdit;
    txtPrivateEntry: TEdit;
    dsGridSource: TDataSource;
    txtTotalRecords: TEdit;
    procedure lblPrivateEntryClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dbSelectGridCellClick(Column: TColumn);
    procedure FormResize(Sender: TObject);
    procedure dbSelectGridTitleClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
    myConnection: TDBConnections;
    AddColumn: boolean;
    CreateQuery: boolean;
    Titles: string;
    DBTable: string;
    TotalRecords: integer;
    GridFilter: string;
    ReverseDirection: boolean;
    SortField: string;
    DiaryID: string;
    DiaryBrief: string;
    DiaryDate: TDateTime;
    DiaryDetail: string;
    DiaryPrivate: string;
    DiaryPrivateint: integer;

    procedure SetTitles;
    procedure Display(SQLQuery:string = '');
    function GetGridIDValue: string;
  end;

var
  frmSelectDiaryEntry: TfrmSelectDiaryEntry;

implementation

uses MAIN;

{$R *.dfm}

procedure TfrmSelectDiaryEntry.btnCloseClick(Sender: TObject);
begin
  if Assigned(myConnection) then begin
    FreeAndNil(myConnection);
  end;
  MainForm.CloseMDIChild(-1);
end;

procedure TfrmSelectDiaryEntry.btnSelectClick(Sender: TObject);
begin
  //User has chosen a row from the grid -
  //Now copy the record selected - to the corresponding entry fields on the
  //  diary entry form.

end;

procedure TfrmSelectDiaryEntry.dbSelectGridCellClick(Column: TColumn);
var
  strDiaryDate: string;
  strDiaryPrivate: string;
  IDFieldname: string;
  constr: widestring;
  Useful: TUsefulRoutines;
begin
  //CELL CLICKED - get ID and load details to edit boxes:
  //Need to change the MainForm.CurrentDate to match the one selected.
  Useful:= TUsefulRoutines.Create;
  try
  constr:= MainForm.MainConnection.ConnString;
  DiaryID:= self.GetGridIDValue;
  IDFieldname:= MainForm.MainConnection.DBOperations.GetFieldnamesOfTypesPassed(self.DBTable,'ftAutoInc',constr);
  self.GridFilter:= IDFieldname+' = '+DiaryID+' AND '+'userid = '+IntToStr(MainForm.userID);
  self.ReverseDirection:= FALSE;
  self.SortField:= IDFieldname;
  MainForm.MainConnection.DBOperations.CreateQuery(constr,'SELECT','SELECT * FROM '+self.DBTable,self.SortField,self.ReverseDirection,self.GridFilter);
  MainForm.MainConnection.DBOperations.CreateSingleRecArray(MainForm.MainConnection.DBOperations.ADOQuery,True);
  strDiaryDate:= MainForm.MainConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'dailydate');
  self.DiaryBrief:= MainForm.MainConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'dailybrief');
  self.DiaryDetail:= MainForm.MainConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'dailyentry');
  self.DiaryPrivate:= MainForm.MainConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'dailyprivateentry');
  strDiaryPrivate:= MainForm.MainConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'private');
  if Length(strDiaryDate)>0 then
    self.DiaryDate:= StrToDateTime(strDiaryDate);
  self.txtDate.Text:= FormatDateTime('dd-mmm-yyyy',self.DiaryDate);
  self.txtTime.Text:= FormatDateTime('hh:mm:ss',self.DiaryDate);
  self.txtBrief.Text:= self.DiaryBrief;
  if strDiaryPrivate = '1' then begin
    self.txtPrivateEntry.Text:= 'YES';
    Useful.InsertValueIntoForm(MainForm,'frmDiaryView','memPrivate',self.DiaryPrivate);
  end
  else
    self.txtPrivateEntry.Text:= 'NO';
  Useful.InsertValueIntoForm(MainForm,'frmDiaryView','txtRecNumber',DiaryID);
  Useful.InsertValueIntoForm(MainForm,'frmDiaryView','txtBrief',self.DiaryBrief);
  Useful.InsertValueIntoForm(MainForm,'frmDiaryView','memDetail',self.DiaryDetail);
  Useful.InsertValueIntoForm(MainForm,'frmDiaryView','txtDate',FormatDateTime('dd-mmmm-yyyy',self.DiaryDate));
  Useful.InsertValueIntoForm(MainForm,'frmDiaryView','txtTime',FormatDateTime('hh:mm:ss',self.DiaryDate));
  MainForm.CurrentEditDate:= self.DiaryDate;
  finally
    FreeAndNil(Useful);
  end;
end;

procedure TfrmSelectDiaryEntry.dbSelectGridTitleClick(Column: TColumn);
{$J+}
 const PreviousColumnIndex : integer = -1;
        mySort: Widestring = '';
{$J-}
begin
  //user clicked on titles - sort by field:
  if dbSelectGrid.DataSource.DataSet is TCustomADODataSet then
    with TCustomADODataSet(dbSelectGrid.DataSource.DataSet) do begin
        mySort:= sort;
        try
          dbSelectGrid.Columns[PreviousColumnIndex].title.Font.Style :=
          dbSelectGrid.Columns[PreviousColumnIndex].title.Font.Style - [fsBold];
        except
        end; //try

      Column.title.Font.Style :=
      Column.title.Font.Style + [fsBold];
      PreviousColumnIndex := Column.Index;

      if (PosEx(Column.Field.FieldName, mySort) = 1) and (PosEx(' DESC', mySort)= 0) then
        Sort := Column.Field.FieldName + ' DESC'
      else
        Sort := Column.Field.FieldName + ' ASC';
    end; //with
end;

procedure TfrmSelectDiaryEntry.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfrmSelectDiaryEntry.FormResize(Sender: TObject);
var
  briefwidth: integer;
  gapfromedge: integer;

begin
  gapfromedge:= 30;
  briefWidth:= self.Width-gapfromedge-self.txtBrief.Left;
  self.txtBrief.Width:= briefwidth;
end;

procedure TfrmSelectDiaryEntry.lblPrivateEntryClick(Sender: TObject);
begin
  self.txtPrivateEntry.SetFocus;
end;

procedure TfrmSelectDiaryEntry.SetTitles;
var
  TitlesArray: myDatabaseClass_II.TstrArray;
  ElementIDX: integer;
  ColIDX: integer;
  strTitle: string;
  GridCols: integer;
  MaxIndex: integer;
begin
  //Set titles from the VARIABLE titles from that of the table
  //fields to the indiviual titles in the array.
 TitlesArray:= MAINFORM.MainConnection.DBOperations.StrToStringArray(Titles,',');
 //check :no. of cols in grid against no. of titles
 Gridcols:= self.dbSelectGrid.Columns.Count;
 SetLength(TitlesArray,GridCols+1);
 ElementIDX:= 0;
 ColIDX:= 0;
 //Access Violation is produced if array not large enough
 while ColIDX< Gridcols do begin
  strTitle:= TitlesArray[ElementIDX];
  if AddColumn then
    self.dbSelectGrid.Columns.Add; //this adds extra columns i think - to the ones
  // already on the grid - so this will affect the display of records in the
  // grid.
  self.dbSelectGrid.Columns.Items[ColIDX].Title.Caption:= strTitle;
  ElementIDX:= ElementIDX+1;
  ColIDX:= ColIDX+1;
 end;


end;

function TfrmSelectDiaryEntry.GetGridIDValue: string;
var
  Fieldname: string;
  ConStr: widestring;
  idx: integer;
  idValue: string;
begin
  //Get value of ID field when user clicks on grid:
  //Get the value of the AUTOinc Field:
  idValue:= '';
  ConStr:= MainForm.MainConnection.ConnString;
  Fieldname:= MainForm.MainConnection.DBOperations.GetFieldnamesOfTypesPassed(self.DBTable,'ftAutoInc',ConStr);
  idx:= 0;
  while idx < self.dbSelectGrid.Columns.Count do begin
    if Uppercase(self.dbSelectGrid.Columns[idx].FieldName) = Uppercase(Fieldname) then begin
      idValue:= self.dbSelectGrid.Fields[idx].AsString;
      //ShowMessage('EDIT Field: '+Fieldname+' VALUE= '+idValue);
      Result:= idValue;
      exit;
    end;
    idx:= idx+1;
  end;
  Result:= idValue;
end;

procedure TfrmSelectDiaryEntry.Display(SQLQuery:string = '');
var
  strCon:widestring;
  queryString: string;
  TableList: TStrings;
begin
  //GETTING AN ERROR HERE - something about a parameter error ???

  TableList:= TStringList.Create;
  if MainForm.CheckLogin then begin
    if Assigned(myConnection) then
      FreeAndNil(myConnection);
    myConnection:= TDBConnections.Create;
    //strCon:= myConnection.ADOConnection.ConnectionString;
    if Length(self.DBTable) = 0 then begin
      ShowMessage('no table specified');
      exit;
    end;
    //for production - encrypt password and put into registry,
    //then will need a change password option
    myConnection.Password:= MainForm.MainConnection.Password;
    myConnection.Server:= MainForm.MainConnection.Server;
    myConnection.DBName:= MainForm.MainConnection.DBName;
    myConnection.UID:= MainForm.MainConnection.UID;
    myConnection.Port:= MainForm.MainConnection.Port;
    strCon:= MainForm.MainConnection.ConnString;
    myConnection.ConnString:= strCon;
    myConnection.DBOperations.connString:= strCon;
    //ShowMessage('Connection STring= '+strCon);
    //OK after the first time the query is created - the MainForm...ADOQuery is
    //not assigned all the proper atrributes - the sort field is not defined.
    //so the MainForm...ADOQuery does not have the ORDEBY set when the user
    //selects a sort field.
    //Perhaps the myConnection.ADOQuery needs to be created in BOTH cases -
    //set the QueryString first and sortField etc like first time round -
    // But second time round - date filter must also be present.
    //something like queryString:= SelectDatesQuery();
    //The first time myConnection...CreateQuery is executed - SelectDates is
    //not even called
    //05:42 11-12-2015 - one solution - to write to the object variable:
    //07:29 11-12-2015 - NOW myDatabaseClass_II has a few minor changes -
    //  all methods involving a string query - is now saved in the property
    //  QueryString.
    //SelectDates needs to pass back the query used to create it - so can be used here.
    if Length(SQLQuery)>0 then
      queryString:= SQLQuery
    else begin
      //  NEEDS TO BE FILTERED FOR THE CURRENT USER AND THE CURRENT DAY(s)
      // DEFAULT IS TO SHOW ALL ENTRIES FOR ALL
      // DAYS - FOR CURRENT USER.
      queryString:= 'SELECT * FROM '+self.DBTable+' WHERE userid = '+IntToStr(MainForm.userID);
      //self.Filter:= '';
      //sortField:= '';
      //self.SortDateField:= '';
      //ReverseDirection:= FALSE;
    end;

    if CreateQuery then begin

      if (myConnection.DBOperations.CreateQuery(strCon,'SELECT',queryString,sortField,ReverseDirection,GridFilter) = FALSE) then begin
        ShowMessage('Cannot Find Sort Field Passed');
        exit;
      end;
    end
    else begin
      myConnection.DBOperations.ADOQuery:= MainForm.MainConnection.DBOperations.ADOQuery;
    end; //else
    if Assigned(myConnection.DBOperations.ADOQuery) then begin
        myConnection.OpenConnection('',False);
        self.dsGridSource.DataSet:= myConnection.DBOperations.ADOQuery;
        //myConnection.ADOConnection.GetTableNames(comTables.Items,false);
        myConnection.DBOperations.ADOQuery.Open;
        self.SetTitles;
    end
    else begin
        ShowMessage('Query Not Assigned');
        exit;
    end;
    //Check Total Records in Grid and display:
    self.TotalRecords:= self.dbSelectGrid.DataSource.DataSet.RecordCount;
    self.txtTotalRecords.Text:= InttoStr(TotalRecords);


  end
  else
    ShowMessage('Please Login');
  //self.AdjustColWidths;
end;

end.
