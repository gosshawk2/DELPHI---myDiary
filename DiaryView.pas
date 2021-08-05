unit DiaryView;

//Updated: v1.0 - Search method updated to return the dailydate of the record
//  found so the record can be passed to display and details shown.
// Update 1) 19/09/2016  - Now added time to the brief entry when user clicks
//                         Insert Date and Time button
//

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.ComCtrls, system.DateUtils, myDatabaseClass_II, CreateAForm, Data.DB,
  Vcl.Grids, Vcl.DBGrids;

type ButtonClickRange = (bcInsert,bcEdit,bcSave,bcCancel,bcFirst,bcPrevious,bcNext,bcLast);

type
  TfrmDiaryView = class(TForm)
    pnlTop: TPanel;
    btnClose: TBitBtn;
    btnInsert: TBitBtn;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    btnEdit: TBitBtn;
    pnlMain: TPanel;
    pnlControls: TPanel;
    btnSearch: TBitBtn;
    txtSearch: TEdit;
    btnLast: TBitBtn;
    btnPrevious: TBitBtn;
    btnNext: TBitBtn;
    btnFirst: TBitBtn;
    txtRecNumber: TEdit;
    lblBrief: TLabel;
    txtBrief: TEdit;
    memDetail: TMemo;
    Label1: TLabel;
    lblIncludePrivate: TLabel;
    cbPrivateEntry: TCheckBox;
    memPrivate: TMemo;
    DateTimePicker1: TDateTimePicker;
    rgSkip: TRadioGroup;
    lblDate: TLabel;
    txtDate: TEdit;
    txtDayOfWeek: TEdit;
    btnShowDiaryEntries: TBitBtn;
    comSearchFields: TComboBox;
    txtTime: TEdit;
    pnlNavigation: TPanel;
    btnInsertDateAndTime: TBitBtn;
    Timer1: TTimer;
    txtCurrentTime: TEdit;
    txtCurrentDate: TEdit;
    btnClearSearch: TBitBtn;
    btnShowDiaryEntriesEmbedded: TBitBtn;
    btnTODAY: TBitBtn;
    btnSetTime: TBitBtn;
    DBDailyGrid: TDBGrid;
    dsDBGrid: TDataSource;
    txtPrivateEntry: TEdit;
    txtTotalRecords: TEdit;
    lblTotalRecords: TLabel;
    procedure btnEditClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cbPrivateEntryClick(Sender: TObject);
    procedure btnSearchClick(Sender: TObject);
    procedure btnShowDiaryEntriesClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure comSearchFieldsChange(Sender: TObject);
    procedure btnPreviousClick(Sender: TObject);
    procedure DateTimePicker1Change(Sender: TObject);
    procedure UpDown1Changing(Sender: TObject; var AllowChange: Boolean);
    procedure btnLastClick(Sender: TObject);
    procedure btnFirstClick(Sender: TObject);
    procedure btnInsertDateAndTimeClick(Sender: TObject);
    procedure Timer1Timer(Sender: TObject);
    procedure btnInsertClick(Sender: TObject);
    procedure btnNextClick(Sender: TObject);
    procedure btnClearSearchClick(Sender: TObject);
    procedure btnShowDiaryEntriesEmbeddedClick(Sender: TObject);
    procedure btnTODAYClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure btnSetTimeClick(Sender: TObject);
    procedure DBDailyGridCellClick(Column: TColumn);
  private
    { Private declarations }
  public
    { Public declarations }
    DBTable: string;
    Titles: string;
    SearchField: string;
    SearchDateField: string;
    dtSearchDate: TDateTime;
    strSearchDate: string;
    queryString: string;
    ButtonClicked: ButtonClickRange;
    sbCreateScrollbox: TCreateScrollbox;
    sbScrollboxControls: TControlOptions;
    sbScrollboxControlAttributes: TStrings;
    strDay: string;
    strDate: string;
    strTime: string;
    strBrief: string;
    strDetail: string;
    strPrivate: string;
    strRecID: string;
    myConnections: TDBConnections;
    myConnection: TDBConnections;

    AddColumn: boolean;
    CreateQuery: boolean;
    GridTitles: string;
    GridDBTable: string;
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

    procedure Display(Reversed,ShowFields:boolean);
    procedure Display2;
    procedure PopulateGrid();
    procedure PopulateSearchCombo;
    procedure DecreaseDateByInterval;
    procedure IncreaseDateByInterval;
    procedure GetFormPositions(var FormLeft:integer; var FormTop:integer; var FormWidth:integer; var FormHeight: integer);
    procedure SaveEntry;
    procedure CreateTheScrollbox(sbID,sbLeft,sbTop,sbWidth,SbHeight:integer);
    procedure DisplayDiaryEntry(Title,TimeEntry,Brief,Detail,PrivateEntry:string);
    procedure InsertEntry;
    procedure EditEntry;
    procedure SetTime;
    procedure GetNextEntry;
    procedure SetTitles;
    procedure SelectGridCell;

    function isAltDown:boolean;
    function isCtrlDown : Boolean;
    function isShiftDown : Boolean;
    function GetGridIDValue: string;
  end;

var
  frmDiaryView: TfrmDiaryView;

implementation

uses MAIN;

{$R *.dfm}

procedure TfrmDiaryView.btnCancelClick(Sender: TObject);
begin
    //Cancel Entry:
    ButtonClicked:= bcCancel;
    txtSearch.SetFocus;
    btnSave.Enabled:= False;
    btnInsert.Enabled:= True;
    btnEdit.Enabled:= True;
    btnCancel.Enabled:= False;
    txtBrief.Text:= '';
    memDetail.Text:= '';
    memPrivate.Text:= '';
end;

procedure TfrmDiaryView.btnClearSearchClick(Sender: TObject);
begin
  txtSearch.Text:= '';
  MainForm.DailyFilter:= '';
  MainForm.SortField:= '';
end;

procedure TfrmDiaryView.btnCloseClick(Sender: TObject);
begin
  MainForm.CloseMDIChild(-1);
end;

procedure TfrmDiaryView.btnEditClick(Sender: TObject);
begin
  EditEntry;
end;

procedure TfrmDiaryView.btnFirstClick(Sender: TObject);
begin
  ButtonClicked:= bcFirst;
  self.IncreaseDateByInterval;

end;

procedure TfrmDiaryView.InsertEntry;
var
  DefaultValues:string;
begin
  //Insert mode: just clear the fields and set the brief field to focus.
  ButtonClicked:= bcInsert;
  //MainForm.CurrentEditDate:= Now();
  //the date and time on the VIEW Diary form is changed to currentEditDate.
  txtDayOfWeek.Text:= FormatDateTime('dddd',MainForm.CurrentEditDate);
  txtDate.Text:= FormatDateTime('dd-mmm-yyyy',MainForm.CurrentEditDate);
  txtTime.Text:= FormatDateTime('hh:mm:ss',MainForm.CurrentEditDate);
  txtBrief.Text:= '';
  memDetail.Text:= '';
  memPrivate.Text:= '';
  txtBrief.SetFocus;

  btnInsert.Enabled:= False;
  btnEdit.Enabled:= False;
  btnSave.Enabled:= True;
  btnCancel.Enabled:= True;
  //self.strRecID:= self.txtRecNumber.Text; //could get last id used ?
  self.strRecID:= '';
  self.strDay:= self.txtDayOfWeek.Text;
  self.strDate:= self.txtDate.Text;
  self.strTime:= self.txtTime.Text;
  self.strBrief:= '';
  self.strDetail:= '';
  self.strPrivate:= '';
  DefaultValues:= self.strRecID+','+self.strDay+','+self.strDate+','+self.strTime;  //[0],[1],[2],[3]
  DefaultValues:= DefaultValues+','+strBrief+','+self.strDetail+','+strPrivate;     //[4],[5],[6]
  MainForm.CreateMDIChild(13,'INSERT Diary Entry ',1,1,640,640,DefaultValues);
  btnInsert.Enabled:= True;
  btnEdit.Enabled:= True;
  btnSave.Enabled:= False;
  btnCancel.Enabled:= False;
end;

procedure TfrmDiaryView.btnInsertClick(Sender: TObject);
begin
  InsertEntry;
end;


procedure TfrmDiaryView.btnInsertDateAndTimeClick(Sender: TObject);
begin
  self.txtBrief.Text:= FormatDateTime('dddd dd mmmm yyyy hh:mm',now());
end;

procedure TfrmDiaryView.btnLastClick(Sender: TObject);
begin
  //Last Button.
  ButtonClicked:= bcLast;
  self.DecreaseDateByInterval;
end;

procedure TfrmDiaryView.btnNextClick(Sender: TObject);
begin
  //Next Button:
  ButtonClicked:= bcNext;

end;

procedure TfrmDiaryView.btnPreviousClick(Sender: TObject);
begin
  //Previous Time within the same DAY !! - a little tricky perhaps.
  //Take MAinForm.CurrentEditDay. order by date and time.
  //Need to record the current record position - ie current time before going
  // back another record.
  ButtonClicked:= bcPrevious;

end;

procedure TfrmDiaryView.btnSaveClick(Sender: TObject);
begin
  //Save Entry:
  ButtonClicked:= bcSave;
  self.SaveEntry;
end;

procedure TfrmDiaryView.btnSearchClick(Sender: TObject);
var
  SearchFilter: string;
  SortField: string;
  Reversed: boolean;
  TableName: string;
  constr: widestring;
  SearchValue: string;
  ReturnID: integer;
  GetDate: TDatetime;
  strDailyDate: string;
  ReturnField: string;
  FormLeft,FormTop,FormWidth,FormHeight: integer;
begin
  //search:
  if Length(self.comSearchFields.Text)>0 then begin
    if Uppercase(self.comSearchFields.Text) = 'BRIEF' then
      SearchField:= 'dailybrief'
    else if Uppercase(self.comSearchFields.Text) = 'DETAIL' then
      SearchField:= 'dailyentry'
    else if Uppercase(self.comSearchFields.Text) = 'PRIVATE' then
      SearchField:= 'dailyprivateentry'
    else
      SearchField:= 'dailyentry';
  end
  else begin
    SearchField:= 'dailyentry';
  end;
  constr:= MainForm.MainConnection.ConnString;
  TableName:= 'dailydiary';
  SearchValue:= self.txtSearch.Text;
  MainForm.DailyFilter:= SearchField+' like '+chr(39)+'%'+SearchValue+'%'+chr(39);
  MainForm.SortField:= 'dailydate DESC';
  if MainForm.IsLoginOK then begin
    self.GetFormPositions(FormLeft,FormTop,FormWidth,FormHeight);
    MainForm.CreateMDIChild(16,'Show Diary Entries ',FormLeft,FormTop,FormWidth,FormHeight,'1');
  end;
  {
  ReturnField:= 'dailydate';
  ReturnID:= MainForm.MainConnection.DBOperations.SearchField(TableName,constr,SearchField,SearchValue,FALSE);
  strDailyDate:= MainForm.MainConnection.DBOperations.SearchField(Tablename,constr,ReturnField,SearchField,SearchValue,True);
  ShowMessage('Returned ID= '+IntToStr(ReturnID)+' Date= '+strDailyDate);
  //now find the dailydate and call display - to show correct date and time and the record.
  GetDate:= strToDateTime(strDailyDate);
  }

  //self.Display(TRUE);
end;

procedure TfrmDiaryView.SetTime;
var
  strDate: string;
  strTime: string;
  NewYear,NewMonth,NewDay:word;
  NewHour,NewMin,NewSec,msec: word;
  errormsg: string;
begin
  //set MAinForm.CurrentEditDate to the date and time on the form.
  strDate:= DateToStr(MainForm.CurrentEditDate);
  strTime:= self.txtTime.Text;
  MainForm.CurrentEditDate:= MainForm.MainConnection.StringToDateTime(strDate,strTime,errormsg);
  MainForm.txtStatusBar.Text:= 'Edit Time has been set '+FormatDateTime('hh:mm:ss',now());
  if Length(errormsg)>0 then
    ShowMessage(errormsg);
end;

procedure TfrmDiaryView.btnSetTimeClick(Sender: TObject);
begin
  self.setTime;
end;

procedure TfrmDiaryView.btnShowDiaryEntriesClick(Sender: TObject);
var
  GapWidth: integer;
  FormLeft: integer;
  FormWidth: integer;
  FormTop: integer;
  FormHeight: integer;
  WindowHeight: integer;
  WindowWidth: integer;
begin
  if MainForm.IsLoginOK then begin
    self.GetFormPositions(FormLeft,FormTop,FormWidth,FormHeight);
    MainForm.DailyFilter:= '';
    MainForm.CreateMDIChild(16,'Show Diary Entries ',FormLeft,FormTop,FormWidth,FormHeight,'1');
  end;
end;



procedure TfrmDiaryView.btnShowDiaryEntriesEmbeddedClick(Sender: TObject);
var
  sbLeft,sbTop,sbWidth,sbHeight: integer;
  sbID: integer;
begin
  sbID:= 1;
  sbLeft:= 592;
  sbTop:= 16;
  sbWidth:= 416;
  sbHeight:= 408;
  self.CreateTheScrollbox(sbID,sbLeft,sbTop,sbWidth,sbHeight);
end;

procedure TfrmDiaryView.btnTODAYClick(Sender: TObject);
begin
  MainForm.CurrentEditDate:= Now();
  self.PopulateGrid();
  //self.Display2;
end;

procedure TfrmDiaryView.cbPrivateEntryClick(Sender: TObject);
begin
  if cbPrivateEntry.Checked then begin
    //hide memo control for private entry:
    self.memPrivate.Visible:= True;
    //I think  this crashes !
  end
  else begin
    self.memPrivate.Visible:= False;
  end;
end;

procedure TfrmDiaryView.comSearchFieldsChange(Sender: TObject);
begin
  //User has clicked / selected on a search field in the list.

end;

procedure TfrmDiaryView.CreateTheScrollbox(sbID,sbLeft,sbTop,sbWidth,SbHeight:integer);
begin
  //MAY NEED to create a text box to receive the focus.
  //May also need to setup the scroll box with the form  - keep it hidden until needed.
  sbCreateScrollbox:= TCreateScrollbox.Create('sbDiaryEntries','Diary Entries',sbID,sbLeft,sbTop,sbWidth,sbHeight);
  self.sbScrollboxControlAttributes:= TStringList.Create;
  self.sbScrollboxControlAttributes.Clear;
  self.sbScrollboxControlAttributes.Add('TAG=1');
  self.sbScrollboxControlAttributes.Add('NAME=pnlENTRY1');
  self.sbScrollboxControlAttributes.Add('LEFT=4');
  self.sbScrollboxControlAttributes.Add('TOP=4');
  self.sbScrollboxControlAttributes.Add('WIDTH=390');
  self.sbScrollboxControlAttributes.Add('HEIGHT=390');
  self.sbScrollboxControlAttributes.Add('PARENT=sbDiaryEntries');
  self.sbScrollboxControlAttributes.Add('CAPTION=HELLO!');
  self.sbScrollboxControlAttributes.Add('COLOR=26,26,255');
  self.sbScrollboxControls:= TControlOptions.Create(self.sbCreateScrollbox.GetBox,'TPANEL',self.sbScrollboxControlAttributes);
  self.sbCreateScrollbox.ControlList.Add(self.sbScrollboxControls);
  self.sbScrollboxControlAttributes.Clear;
  self.sbScrollboxControlAttributes.Add('TAG=2');
  self.sbScrollboxControlAttributes.Add('NAME=txtMessage');
  self.sbScrollboxControlAttributes.Add('LEFT=8');
  self.sbScrollboxControlAttributes.Add('TOP=8');
  self.sbScrollboxControlAttributes.Add('WIDTH=100');
  self.sbScrollboxControlAttributes.Add('HEIGHT=30');
  self.sbScrollboxControlAttributes.Add('PARENT=pnlENTRY1');
  self.sbScrollboxControlAttributes.Add('TEXT=HELLO AGAIN!');
  self.sbScrollboxControls:= TControlOptions.Create(self.sbCreateScrollbox.GetBox,'TEDIT',self.sbScrollboxControlAttributes);
  self.sbCreateScrollbox.ControlList.Add(self.sbScrollboxControls);
  self.sbScrollboxControlAttributes.Clear;
  self.sbScrollboxControlAttributes.Add('TAG=3');
  self.sbScrollboxControlAttributes.Add('NAME=txtScrollMessage');
  self.sbScrollboxControlAttributes.Add('LEFT=10');
  self.sbScrollboxControlAttributes.Add('TOP=400');
  self.sbScrollboxControlAttributes.Add('WIDTH=100');
  self.sbScrollboxControlAttributes.Add('HEIGHT=40');
  self.sbScrollboxControlAttributes.Add('PARENT=sbDiaryEntries');
  self.sbScrollboxControlAttributes.Add('CAPTION=HELLO IN SCROLLBOX!');
  self.sbScrollboxControls:= TControlOptions.Create(self.sbCreateScrollbox.GetBox,'TEDIT',self.sbScrollboxControlAttributes);
  self.sbCreateScrollbox.ControlList.Add(self.sbScrollboxControls);
end;

procedure TfrmDiaryView.DateTimePicker1Change(Sender: TObject);
var
  strDate: string;
  strTime: string;
  NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,msec: word;
  NewDate: TDateTime;
  NewTime: TDateTime;
begin
  strDate:= DateTimeToStr(self.DateTimePicker1.Date);
  strTime:= self.txtTime.Text;
  decodedate(self.DateTimePicker1.Date,NewYear,NewMonth,NewDay);
  NewTime:= StrToDateTime(strTime);
  NewHour:= HourOf(NewTime);
  NewMin:= MinuteOf(NewTime);
  NewSec:= SecondOf(NewTime);
  msec:= 0;
  NewDate:= encodeDateTime(NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,msec);
  MainForm.CurrentEditDate:= NewDate;
  PopulateGrid();
  //self.Display2;
end;

procedure TfrmDiaryView.DBDailyGridCellClick(Column: TColumn);
begin
   //CELL CLICKED - get ID and load details to edit boxes:
  //Need to change the MainForm.CurrentDate to match the one selected.
  SelectGridCell;
end;

procedure TfrmDiaryView.SelectGridCell;
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
    //IDFieldname:= MainForm.MainConnection.DBOperations.GetFieldnamesOfTypesPassed(self.DBTable,'ftAutoInc',constr);
    IDFieldname:= myConnection.DBOperations.GetFieldnamesOfTypesPassed(self.DBTable,'ftAutoInc',constr);
    self.GridFilter:= IDFieldname+' = '+DiaryID+' AND '+'userid = '+IntToStr(MainForm.userID);
    self.ReverseDirection:= FALSE;
    self.SortField:= IDFieldname;
    //MainForm.MainConnection.DBOperations.CreateQuery(constr,'SELECT','SELECT * FROM '+self.DBTable,self.SortField,self.ReverseDirection,self.GridFilter);
    //MainForm.MainConnection.DBOperations.CreateSingleRecArray(MainForm.MainConnection.DBOperations.ADOQuery,True);
    //strDiaryDate:= MainForm.MainConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'dailydate');
    //self.DiaryBrief:= MainForm.MainConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'dailybrief');
    //self.DiaryDetail:= MainForm.MainConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'dailyentry');
    //self.DiaryPrivate:= MainForm.MainConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'dailyprivateentry');
    //strDiaryPrivate:= MainForm.MainConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'private');
    myConnection.DBOperations.CreateQuery(constr,'SELECT','SELECT * FROM '+self.DBTable,self.SortField,self.ReverseDirection,self.GridFilter);
    myConnection.DBOperations.CreateSingleRecArray(myConnection.DBOperations.ADOQuery,True);
    strDiaryDate:= myConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'dailydate');
    self.DiaryBrief:= myConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'dailybrief');
    self.DiaryDetail:= myConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'dailyentry');
    self.DiaryPrivate:= myConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'dailyprivateentry');
    strDiaryPrivate:= myConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'private');

    if Length(strDiaryDate)>0 then begin
      self.DiaryDate:= StrToDateTime(strDiaryDate);
      MainForm.CurrentEditDate:= self.DiaryDate;
    end;
    Display2;
    //self.txtDate.Text:= FormatDateTime('dd-mmm-yyyy',self.DiaryDate);
    //self.txtTime.Text:= FormatDateTime('hh:mm:ss',self.DiaryDate);
    //self.txtBrief.Text:= self.DiaryBrief;
    //if strDiaryPrivate = '1' then begin
      //self.txtPrivateEntry.Text:= 'YES';
      //Useful.InsertValueIntoForm(MainForm,'frmDiaryView','memPrivate',self.DiaryPrivate);
    //end
    //else
      //self.txtPrivateEntry.Text:= 'NO';
    //If more than one instance of same form open - Modify method to pass the GUID value in .TAG property ...
    //Useful.InsertValueIntoForm(MainForm,'frmDiaryView','txtRecNumber',DiaryID);
    //Useful.InsertValueIntoForm(MainForm,'frmDiaryView','txtBrief',self.DiaryBrief);
    //Useful.InsertValueIntoForm(MainForm,'frmDiaryView','memDetail',self.DiaryDetail);
    //Useful.InsertValueIntoForm(MainForm,'frmDiaryView','txtDate',FormatDateTime('dd-mmmm-yyyy',self.DiaryDate));
    //Useful.InsertValueIntoForm(MainForm,'frmDiaryView','txtTime',FormatDateTime('hh:mm:ss',self.DiaryDate));
    //MainForm.CurrentEditDate:= self.DiaryDate;
  finally
    FreeAndNil(Useful);
  end;
end;

function TfrmDiaryView.GetGridIDValue: string;
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
  //Fieldname:= MainForm.MainConnection.DBOperations.GetFieldnamesOfTypesPassed(self.DBTable,'ftAutoInc',ConStr);
  Fieldname:= myConnection.DBOperations.GetFieldnamesOfTypesPassed(self.DBTable,'ftAutoInc',ConStr);
  idx:= 0;
  while idx < self.dbDailyGrid.Columns.Count do begin
    if Uppercase(self.dbDailyGrid.Columns[idx].FieldName) = Uppercase(Fieldname) then begin
      idValue:= self.dbDailyGrid.Fields[idx].AsString;
      //ShowMessage('EDIT Field: '+Fieldname+' VALUE= '+idValue);
      Result:= idValue;
      exit;
    end;
    idx:= idx+1;
  end;
  Result:= idValue;
end;

procedure TfrmDiaryView.DecreaseDateByInterval;
var
  NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,msec: word;
  dtNewDate: TDateTime;
begin
  decodedatetime(MainForm.CurrentEditDate,NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,msec);
  dtNewDate:= EncodeDateTime(NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,msec);
  if self.rgSkip.ItemIndex = 0 then begin
    //decrease by 1 day:
    dtNewDate:= IncDay(dtNewDate, -1);
  end;
  if self.rgSkip.ItemIndex = 1 then begin
    //decrease by 1 week - 7 days:
    dtNewDate:= IncDay(dtNewDate, -7);
  end;
  if self.rgSkip.ItemIndex = 2 then begin
    //decrease by 1 month:
    dtNewDate:= IncMonth(dtNewDate, -1);
  end;
  if self.rgSkip.ItemIndex = 3 then begin
    //decrease by 1 Year:
    dtNewDate:= IncYear(dtNewDate, -1);
  end;
  MainForm.CurrentEditDate:= dtNewDate;
  self.PopulateGrid();
  //self.Display2;
end;

procedure TfrmDiaryView.IncreaseDateByInterval;
var
  NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,msec: word;
  dtNewDate: TDateTime;
begin
  //Increase Date by interval selected with radio buttons:
  decodedatetime(MainForm.CurrentEditDate,NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,msec);
  //in each case - check that the Month or the Year might need to be decremented ?
  NewHour:=0;
  NewMin:=0;
  NewSec:=0;
  msec:=0;
  dtNewDate:= EncodeDateTime(NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,msec);
  if self.rgSkip.ItemIndex = 0 then begin
    //increase by 1 day:
    dtNewDate:= IncDay(dtNewDate, 1);
  end;
  if self.rgSkip.ItemIndex = 1 then begin
    //increase by 1 week - 7 days:
    //NewDay:= NewDay-7;
    dtNewDate:= IncDay(dtNewDate, 7);
  end;
  if self.rgSkip.ItemIndex = 2 then begin
    //increase by 1 month: but what if its January of any year ??
    if NewMonth = 12 then
      NewYear:= NewYear+1;
    NewMonth:= NewMonth+1;
    dtNewDate:= IncMonth(dtNewDate, 1);
  end;
  if self.rgSkip.ItemIndex = 3 then begin
    //increase by 1 Year:
    NewYear:= NewYear+1;
    dtNewDate:= IncYear(dtNewDate, 1);
  end;
  //dtNewDate:= EncodeDateTime(NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,msec);
  //Also need to change the current VIEWED record on the form:
  // - should be taken care of from CurrentEditDate and .Display ???
  MainForm.CurrentEditDate:= dtNewDate;
  //self.Display(TRUE);
  self.PopulateGrid();
  //self.Display2;
end;

procedure TfrmDiaryView.Display(Reversed,ShowFields:boolean);
var
  strDate: string;
  strDay: string;
  strTime: string;
  strIDValue: string;

  SearchValue: string;
  SearchDateTo: string;
  SearchDateFrom: string;
  SearchTimeTo: string;
  SearchTimeFrom: string;
  sortfield: string;
  DateFilter: string;
  IDField: string;
  userIDField: string;
  userID: string;
  constr: widestring;
  Brief: string;
  Detail: string;
  PrivateDetail: string;
  NewDateTo: TDateTime;
  NewDateFrom: TDateTime;
  NewDay,NewMonth,NewYear: word;
  NewHour,NewMin,NewSec,msec: word;
  Amount: integer;
  TableName: string;
  IDValue: integer;
  QueryFilter: string;
begin
  strDay:= FormatDateTime('ddd',MainForm.CurrentEditDate);
  strDate:= FormatDateTime('dd-mmmm-yyyy',MainForm.CurrentEditDate);
  strTime:= FormatDateTime('hh:mm:ss',MainForm.CurrentEditDate);
  self.txtDayOfWeek.Text:= strDay;
  self.txtDate.Text:= strDate;
  self.txtTime.Text:= strTime;
  txtSearch.SetFocus;
  txtBrief.Text:= '';
  memDetail.Text:= '';
  memPrivate.Text:= '';
  if ShowFields then begin
    //Find REcord matching date and then populate the boxes on the form:
    //Added complication - we have to search within a period time of either hours or minutes
    //  either side of the time in the edit box
    //  SearchTime1 = 1 hour before - for example
    //  SearchTime2 = 1 hour after - for example
    constr:= MainForm.MainConnection.ConnString;
    IDField:= MainForm.MainConnection.DBOperations.GetFieldnamesOfTypesPassed(self.DBTable,'ftAutoInc',constr);
    DecodeDate(MainForm.CurrentEditDate,NewYear,NewMonth,NewDay);
    DecodeTime(MainForm.CurrentEditDate,NewHour,NewMin,NewSec,msec);
    msec:= 0; //reset the milliseconds.
    NewDateFrom:= EncodeDateTime(NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,msec);
    NewDateTo:= EncodeDateTime(NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,msec);

    //SearchValue:= MainForm.MainConnection.DBOperations.DateForSQL(MainForm.CurrentEditDate);
    sortfield:= 'dailydate';
    Reversed:= True; //Pick out lastest date in query.
    userIDField:= 'userid';
    userID:= IntToStr(MainForm.UserID);
    TableName:= 'dailydiary';
    SearchValue:= MainForm.MainConnection.DBOperations.DateForSQL(MainForm.CurrentEditDate);
    SearchDateField:= 'dailydate';
    //DateFilter:= userIDField+' = '+userID+' AND DATE('+SearchDateField+') = '+chr(39)+SearchValue+chr(39);
    DateFilter:= userIDField+' = '+userID;
    IDValue:= MainForm.MainConnection.DBOperations.SelectDates(TableName,constr,SearchDateField,sortfield,reversed,NewDateFrom,NewDateTo,DateFilter,True,False);
    self.txtRecNumber.Text:= IntToStr(IDValue);

    if IDValue>0 then begin
      QueryFilter:= IDField+' = '+IntToStr(IDValue); //got record ID now - no need for further filters.
      //MainForm.MainConnection.DBOperations.CreateQuery(constr,'SELECT','SELECT * FROM '+self.DBTable,sortfield,reversed,QueryFilter);
      MainForm.MainConnection.DBOperations.CreateSingleRecArray(MainForm.MainConnection.DBOperations.ADOQuery,True);
      strIDValue:= MainForm.MainConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,IDField);
      Brief:= MainForm.MainConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'dailybrief');
      Detail:= MainForm.MainConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'dailyentry');
      PrivateDetail:= MainForm.MainConnection.DBOperations.GetSingleRecArray(self.DBTable,constr,'dailyprivateentry');
    end
    else
      //Not found.

    if Length(Brief)>0 then
      self.txtBrief.Text:= Brief
    else
      self.txtBrief.Text:= 'No Entry';
    if Length(Detail)>0 then
      self.memDetail.Text:= Detail
    else
      self.memDetail.Text:= 'No Entry';
    if Length(PrivateDetail)>0 then
      self.memPrivate.Text:= PrivateDetail
    else
      self.memPrivate.Text:= 'No Privates Entered';
    self.txtRecNumber.Text:= strIDValue;
  end;
end;

procedure TfrmDiaryView.Display2;
var
  DBTable: string;
  constr: Widestring;
  strIDValue: string;
  Brief: string;
  Detail: string;
  PrivateDetail: string;
begin
    //MainForm.MainConnection.DBOperations.CreateQuery(constr,'SELECT','SELECT * FROM '+self.DBTable,sortfield,reversed,QueryFilter);
    constr:= MainForm.MainConnection.ConnString;
    DBTable:= 'dailydiary';
    strDay:= FormatDateTime('ddd',MainForm.CurrentEditDate);
    strDate:= FormatDateTime('dd-mmmm-yyyy',MainForm.CurrentEditDate);
    strTime:= FormatDateTime('hh:mm:ss',MainForm.CurrentEditDate);
    self.txtDayOfWeek.Text:= strDay;
    self.txtDate.Text:= strDate;
    self.txtTime.Text:= strTime;
    txtSearch.SetFocus;
    txtBrief.Text:= '';
    memDetail.Text:= '';
    memPrivate.Text:= '';
    myConnection.DBOperations.CreateSingleRecArray(myConnection.DBOperations.ADOQuery,True);
    strIDValue:= myConnection.DBOperations.GetSingleRecArray(DBTable,constr,'UniqueID');
    Brief:= myConnection.DBOperations.GetSingleRecArray(DBTable,constr,'dailybrief');
    Detail:= myConnection.DBOperations.GetSingleRecArray(DBTable,constr,'dailyentry');
    PrivateDetail:= myConnection.DBOperations.GetSingleRecArray(DBTable,constr,'dailyprivateentry');

    if Length(Brief)>0 then
      self.txtBrief.Text:= Brief
    else
      self.txtBrief.Text:= 'No Entry';
    if Length(Detail)>0 then
      self.memDetail.Text:= Detail
    else
      self.memDetail.Text:= 'No Entry';
    if Length(PrivateDetail)>0 then
      self.memPrivate.Text:= PrivateDetail
    else
      self.memPrivate.Text:= 'No Privates Entered';
    self.txtRecNumber.Text:= strIDValue;
end;

procedure TfrmDiaryView.SetTitles;
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
 Gridcols:= self.dbDailyGrid.Columns.Count;
 SetLength(TitlesArray,GridCols+1);
 ElementIDX:= 0;
 ColIDX:= 0;
 //Access Violation is produced if array not large enough
 while ColIDX< Gridcols do begin
  strTitle:= TitlesArray[ElementIDX];
  if AddColumn then
    self.dbDailyGrid.Columns.Add; //this adds extra columns i think - to the ones
  // already on the grid - so this will affect the display of records in the
  // grid.
  self.dbDailyGrid.Columns.Items[ColIDX].Title.Caption:= strTitle;
  ElementIDX:= ElementIDX+1;
  ColIDX:= ColIDX+1;
 end;
end;

procedure TfrmDiaryView.PopulateGrid();
var
  constr: widestring;
  DBTable: string;
  sortfield: string;
  reversed: boolean;
  QueryFilter: string;
  userid: integer;
  strUserid: string;
  SearchDateField: string;
  SearchValue: string;
  qryString: string;
  TotalRows: integer;
  RecID: string;
  Brief: string;
  Detail: string;
  Private: string;
  strIsPrivate: integer;
begin
  //ShowMessage('In PopulateGrid');
  if MainForm.CheckLogin then begin
    constr:= MainForm.MainConnection.ConnString;
    if Assigned(myConnection) then
        FreeAndNil(myConnection);
    myConnection:= TDBConnections.Create;
    myConnection.Password:= MainForm.MainConnection.Password;
    myConnection.Server:= MainForm.MainConnection.Server;
    myConnection.DBName:= MainForm.MainConnection.DBName;
    myConnection.UID:= MainForm.MainConnection.UID;
    myConnection.Port:= MainForm.MainConnection.Port;
    myConnection.ConnString:= constr;
    myConnection.DBOperations.connString:= constr;
    DBTable:= 'dailydiary';
    sortfield:= 'dailydate';
    reversed:= True;
    userid:= MainForm.UserID;
    SearchDateField:= 'dailydate';
    SearchValue:= myConnection.DBOperations.DateForSQL(MainForm.CurrentEditDate);
    //SearchValue:= MainForm.MainConnection.DBOperations.DateForSQL(MainForm.CurrentEditDate);
    qryString:= 'SELECT * FROM '+DBTable;
    QueryFilter:= 'userid = '+IntToStr(userid)+' AND DATE('+SearchDateField+') = '+chr(39)+SearchValue+chr(39);
    //DBDailyGrid.Columns.ClearAndResetID;
    TotalRows:= 0;
    //myConnection.ConnString:= constr;
    //myConnection.DBOperations.connString:= constr;
    if (myConnection.DBOperations.CreateQuery(constr,'SELECT',qryString,sortField,ReverseDirection,QueryFilter) = FALSE) then begin
      ShowMessage('Error during Create Query');
      exit;
    end;
    MainForm.MainConnection.DBOperations.ADOQuery:= myConnection.DBOperations.ADOQuery;
    if Assigned(myConnection.DBOperations.ADOQuery) then begin
        myConnection.OpenConnection('',False);
        self.dsDBGrid.DataSet:= myConnection.DBOperations.ADOQuery;
        myConnection.DBOperations.ADOQuery.Open;
        self.dsDBGrid.DataSet.Open;
        self.SetTitles;
        Display2;
    end
    else begin
        ShowMessage('Query Not Assigned');
        exit;
    end;
    //Check Total Records in Grid and display:
    self.TotalRecords:= myConnection.DBOperations.ADOQuery.RecordCount;
    TotalRows:= self.DBDailyGrid.DataSource.DataSet.RecordCount;
    self.txtTotalRecords.Text:= InttoStr(TotalRows);


  end
  else begin
      ShowMessage('Please Login');
  end;

end;

procedure TfrmDiaryView.DisplayDiaryEntry(Title, TimeEntry, Brief, Detail,
  PrivateEntry: string);
begin
    //display single entry onto new panel:

end;

procedure TfrmDiaryView.EditEntry;
var
  FormLeft,FormTop,FormWidth,FormHeight: integer;
  DefaultValues:string;
begin
  //EDIT Diary Entry:
  //Bring up current Date and Time and load / display the relevant record
  //set the focus to the brief field
  ButtonClicked:= bcEdit;
  txtBrief.SetFocus;
  FormLeft:= 1;
  FormTop:= 1;
  FormWidth:= 640;
  FormHeight:= 640;
  self.strRecID:= self.txtRecNumber.Text;
  self.strDay:= self.txtDayOfWeek.Text;
  self.strDate:= self.txtDate.Text;
  self.strTime:= self.txtTime.Text;
  self.strBrief:= self.txtBrief.Text;
  self.strDetail:= self.memDetail.Text;
  self.strPrivate:= self.memPrivate.Text;
  DefaultValues:= self.strRecID+','+self.strDay+','+self.strDate+','+self.strTime;  //[0],[1],[2],[3]
  DefaultValues:= DefaultValues+','+strBrief+','+self.strDetail+','+strPrivate;     //[4],[5],[6]
  MainForm.CreateMDIChild(13,'EDIT Diary Entry ',FormLeft,FormTop,FormWidth,FormHeight,DefaultValues);
  btnEdit.Enabled:= TRUE;
  btnInsert.Enabled:= True;
  btnSave.Enabled:= False;
  btnCancel.Enabled:= False;
end;

procedure TfrmDiaryView.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfrmDiaryView.FormCreate(Sender: TObject);
begin
  KeyPreview:= TRUE;
end;

procedure TfrmDiaryView.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key=69) and (shift = [ssCtrl]) then begin
    //CTRL+E pressed.
    EditEntry;

  end;
  if (key=73) and (shift = [ssCtrl]) then begin
    //CTRL+I pressed.
    InsertEntry;
  end;
  if (key=84) and (shift = [ssCtrl]) then begin
    //CTRL+T (20th letter) pressed.
    self.SetTime;
  end;
  if (key=73) and (shift = [ssCtrl,ssShift]) then begin
    //CTRL+SHIFT+I pressed.
    MainForm.CurrentEditDate:= Now();
    InsertEntry;
  end;

end;

function TfrmDiaryView.isAltDown : Boolean;
var
  State: TKeyboardState;
begin { isAltDown }
  GetKeyboardState(State);
  Result := ((State[vk_Menu] and 128)<>0);
end; { isAltDown }

function TfrmDiaryView.isCtrlDown : Boolean;
var
  State: TKeyboardState;
begin { isCtrlDown }
  GetKeyboardState(State);
  Result := ((State[VK_CONTROL] and 128)<>0);
end; { isCtrlDown }

function TfrmDiaryView.isShiftDown : Boolean;
var
  State: TKeyboardState;
begin { isShiftDown }
  GetKeyboardState(State);
  Result := ((State[vk_Shift] and 128)<>0);
end;

procedure TfrmDiaryView.GetFormPositions(var FormLeft, FormTop, FormWidth,
  FormHeight: integer);
var
  GapWidth: integer;
  WindowHeight: integer;
  WindowWidth: integer;
begin
    GapWidth:= 10; //pixels from txtbrief control
    WindowWidth:= 10; //pixels of edge of window
    WindowHeight:= 10;
    FormLeft:= (self.txtBrief.Left+self.txtBrief.Width+GapWidth)+WindowWidth+self.Left;
    FormWidth:= (self.pnlMain.Width-self.txtBrief.Width)-self.txtBrief.Left-(GapWidth*2);
    FormTop:= self.pnlTop.Height+self.pnlControls.Height+self.txtBrief.Top+WindowHeight+self.Top;
    FormHeight:= (memPrivate.Height+memPrivate.Top)-txtBrief.Top;
end;



procedure TfrmDiaryView.PopulateSearchCombo;
begin
  self.comSearchFields.Items.Add('Brief');
  self.comSearchFields.Items.Add('Detail');
  self.comSearchFields.Items.Add('Private');

end;

procedure TfrmDiaryView.GetNextEntry;
var
  mySqlConnection: TDBConnections;
  constr: widestring;
  idField: string;
  qryFilter: string;
  Tablename: string;
  datefield: string;
  strNewEntryDate: string;
  Newhour: string;
  NewMin: string;
  sortfield: string;
  RecordID: string;

begin
  //setup initial connection.
  //need to find NEXT diary entry or PREVOIUS diary entry.
  //SET MAINform.CurrentDateTime to the new found entry.
  if MainForm.CheckLogin then begin
    try
          mySqlConnection:= TDBConnections.Create;
          constr:= MainForm.MainConnection.ConnString;
          mySqlConnection.Password:= MainForm.MainConnection.Password;
          mySqlConnection.Server:= MainForm.MainConnection.Server;
          mySqlConnection.DBName:= MainForm.MainConnection.DBName;
          mySqlConnection.UID:= MainForm.MainConnection.UID;
          mySqlConnection.Port:= MainForm.MainConnection.Port;
          mySqlConnection.ConnString:= constr;
          mySqlConnection.DBOperations.connString:= constr; //very important as cannot call parent class internally

          idField:= mySqlconnection.DBOperations.GetFieldnamesOfTypesPassed(Tablename,'ftAutoInc',constr);
          //qryFilter:= 'DATE('+datefield+') = '+chr(39)+strNewEntryDate+chr(39);
          //qryFilter:= qryFilter+' AND HOUR('+datefield+') = '+chr(39)+IntToStr(NewHour)+chr(39);
          //qryFilter:= qryFilter+' AND MINUTE('+datefield+') = '+chr(39)+IntToStr(NewMin)+chr(39);
          RecordID:= '0';
          if mySqlConnection.DBOperations.CreateQuery(constr,'SELECT','SELECT * FROM '+TableName,sortfield,FALSE,qryFilter) then begin
            mySqlConnection.DBOperations.CreateSingleRecArray(mySqlConnection.DBOperations.ADOQuery,True);
            RecordID:= mySqlConnection.DBOperations.GetSingleRecArray(Tablename,constr,idField);

          end;

    finally
      mySqlConnection.Destroy;
    end;
  end;
end;

procedure TfrmDiaryView.SaveEntry;
var
  mySqlConnection: TDBConnections;
  EntryError: boolean;
  strEntryDate: string;
  strEntryTime: string;
  strBrief: string;
  strDetail: string;
  strUserID: string;
  strPrivateEntry: string;
  TotalEntries: integer;
  NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,msec: word;
  dtNewEntryDate: TDate;
  dtNewEntryDateTime: TDateTime;
  strNewEntryDateTime: string;
  strNewEntryDate: string;
  dtEntryDate: TDateTime;
  dtEntryTime: TDateTime;
  dtEntryDateTime: TDateTime;
  APrivateEntry: string;
  constr: widestring;
  ValueList: string;
  qryFilter: string;
  sortfield: string;
  datefield: string;
  TableName: string;
  idField: string;
  RecordID: string;
  IDFilter: string;
  FieldExcludeList: string;
  SQLQuery: string;
  ErrMessage: string;
begin
  //Save the entry to the database - checking if date and time already exist.
  EntryError:= FALSE;
  datefield:= 'dailydate';

  //strEntryDate:= self.txtDate.Text;
  strEntryDate:= DateToStr(MainForm.CurrentEditDate);
  strEntryTime:= self.txtTime.Text;
  if TryStrToDate(strEntryDate,dtEntryDate) then
    if TryStrToTime(strEntryTime,dtEntryTime) then
      //Great ok pass
    else
      ShowMessage('Time is invalid')
  else
    ShowMessage('Date is invalid');
  strBrief:= self.txtBrief.Text;
  strDetail:= self.memDetail.Text;
  strPrivateEntry:= self.memPrivate.Text;
  strUserID:= IntToStr(MainForm.UserID);
  TableName:= 'dailydiary';
  sortfield:= 'dailydate';
  if Length(strPrivateEntry)>0 then
    APrivateEntry:= '1'
  else
    APrivateEntry:= '0';
  TotalEntries:= 0;
  dtEntryDateTime:= mySqlConnection.StringToDateTime(strEntryDate,strEntryTime,ErrMessage);
  if Length(ErrMessage)>0 then begin
    ShowMessage('Problem with DATE entered');
    EntryError:= TRUE;
  end
  else begin
  //if TryStrToDateTime(strEntryDate+' '+strEntryTime,dtEntryDate) then begin
  //if TryStrToDateTime(strEntryDate+' '+strEntryTime,self.dtEntryDate) then begin
    NewYear:= YearOf(dtEntryDateTime);
    NewMonth:= MonthOf(dtEntryDateTime);
    NewDay:= DayOf(dtEntryDateTime);
    NewHour:= HourOf(dtEntryDateTime);
    NewMin:= MinuteOf(dtEntryDateTime);
    NewSec:= SecondOf(dtEntryDateTime);
    MSec:= 0;
    dtNewEntryDateTime:= EncodeDateTime(NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,MSec);
    dtNewEntryDate:= EncodeDate(NewYear,NewMonth,NewDay);
    strNewEntryDateTime:= DateTimeToStr(dtNewEntryDateTime);
    strNewEntryDate:= DateToStr(dtNewEntryDate);
    TotalEntries:= TotalEntries+1;
  end;
  //DateUtils.MilliSecondOf()

  if NOT EntryError then begin
    if TotalEntries > 0 then begin
      if MainForm.CheckLogin then begin
        try
          mySqlConnection:= TDBConnections.Create;
          constr:= MainForm.MainConnection.ConnString;
          mySqlConnection.Password:= MainForm.MainConnection.Password;
          mySqlConnection.Server:= MainForm.MainConnection.Server;
          mySqlConnection.DBName:= MainForm.MainConnection.DBName;
          mySqlConnection.UID:= MainForm.MainConnection.UID;
          mySqlConnection.Port:= MainForm.MainConnection.Port;
          mySqlConnection.ConnString:= constr;
          mySqlConnection.DBOperations.connString:= constr; //very important as cannot call parent class internally

          ValueList:= 'NULL';
          ValueList:= ValueList+','+strNewEntryDateTime;
          ValueList:= ValueList+','+strBrief;
          ValueList:= ValueList+','+strDetail;
          ValueList:= ValueList+','+strUserID;
          ValueList:= ValueList+','+strPrivateEntry;
          ValueList:= ValueList+','+APrivateEntry;

          idField:= mySqlconnection.DBOperations.GetFieldnamesOfTypesPassed(Tablename,'ftAutoInc',constr);
          qryFilter:= 'DATE('+datefield+') = '+chr(39)+strNewEntryDate+chr(39);
          qryFilter:= qryFilter+' AND HOUR('+datefield+') = '+chr(39)+IntToStr(NewHour)+chr(39);
          qryFilter:= qryFilter+' AND MINUTE('+datefield+') = '+chr(39)+IntToStr(NewMin)+chr(39);
          RecordID:= '0';
          if mySqlConnection.DBOperations.CreateQuery(constr,'SELECT','SELECT * FROM '+TableName,sortfield,FALSE,qryFilter) then begin
            mySqlConnection.DBOperations.CreateSingleRecArray(mySqlConnection.DBOperations.ADOQuery,False);
            RecordID:= mySqlConnection.DBOperations.GetSingleRecArray(Tablename,constr,idField);

          end;
          if (RecordID='0') OR (Length(RecordID)=0) then begin
            //Insert New entry
            //mySqlConnection.DBOperations.InsertData(DBTable,strCon,FieldList,ValueList);
            mySqlConnection.DBOperations.InsertData(DBTable,constr,ValueList);
            mySqlConnection.OpenConnection('',False);
            ShowMessage('OK Record Inserted!');
          end
          else if RecordID = '-1' then begin
            ShowMessage(mySqlConnection.DBOperations.errorMessage);
            exit;
          end
          else begin
            //Update existing meter reading entry with RecordID
            //ShowMessage('Already Entered');
            MainForm.CreateMDIChild(6,'Date and Time already exists (1 minute per entry)',1,1,300,250);
            if MainForm.ButtonClicked = 3 then begin
              IDFilter:= idField+' = '+RecordID;
              //RecordID:= mySqlConnection.DBOperations.SearchField(DBTable,strCon,'TariffName','id',IntToStr(RecordID),true);
              SQLQuery:= mySqlConnection.DBOperations.QueryString;
              ShowMessage('Query = '+SQLQuery);
              mySqlConnection.DBOperations.UpdateData(DBTable,constr,ValueList,IDFilter,FieldExcludeList,1);
              mySqlConnection.OpenConnection('',False);
              ShowMessage('OK Record Updated!');
            end;
            if MainForm.ButtonClicked = 2 then begin
              mySqlConnection.DBOperations.InsertData(DBTable,constr,ValueList);
              mySqlConnection.OpenConnection('',False);
              ShowMessage('OK Record Inserted!');
            end;
            if MainForm.ButtonClicked = 1 then begin
              exit;
            end;
          end;

          //Dt:=FAccessADOQuery.Fields.FieldByName(FIELD_NAME).AsDateTime;
          //Ds:=FormatDateTime('dd-mmm-yyyy',dt);
          //strToDateTime(mySqlConnection.DBOperations.ADOQuery.Fields.FieldByName('DateOfReading').AsString); RETURNS ERROR IF NULL

          //DateOfReading:= mySqlConnection.DBOperations.ADOQuery.Fields.FieldByName('DateOfReading').AsDateTime;
          //strDateOfReading:= mySqlConnection.DBOperations.ADOQuery.Fields.FieldByName('DateOfReading').AsString;
          //if Length(strDateOfReading)>0 then

        finally
          mySqlConnection.Destroy;

        end;


      end;
    end
    else begin
      ShowMessage('All Readings must be entered - no blanks');
      EntryError:= True;
    end;

  end
  else begin
    ShowMessage('ERROR during date entry');
    EntryError:= True;
  end;
  if EntryError then begin
    txtBrief.SetFocus;
    btnSave.Visible:= True;
    btnCancel.Visible:= True;
  end
  else begin
    txtSearch.SetFocus;
    btnSave.Enabled:= False;
    btnCancel.Enabled:= False;
    btnInsert.Enabled:= True;
    btnEdit.Enabled:= True;
  end;
end;

procedure TfrmDiaryView.Timer1Timer(Sender: TObject);
begin
  txtCurrentDate.Text:= FormatDateTime('ddd dd mmm yyyy',NOW());
  txtCurrentTime.Text:= FormatDateTime('hh:mm:ss',now());
end;

procedure TfrmDiaryView.UpDown1Changing(Sender: TObject;
  var AllowChange: Boolean);
begin
  //User has clicked up or down:

end;

end.
