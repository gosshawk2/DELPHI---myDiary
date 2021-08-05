unit DiaryEntry;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls, myDatabaseClass_II,
  dateutils;

type
  TfrmDiaryEntry = class(TForm)
    pnlTop: TPanel;
    btnClose: TBitBtn;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    pnlMain: TPanel;
    txtRecNumber: TEdit;
    lblRecNumber: TLabel;
    lblDay: TLabel;
    txtDayOfWeek: TEdit;
    lblDate: TLabel;
    txtDate: TEdit;
    lblBrief: TLabel;
    txtBrief: TEdit;
    memDetail: TMemo;
    Label1: TLabel;
    lblIncludePrivate: TLabel;
    cbPrivateEntry: TCheckBox;
    memPrivate: TMemo;
    txtTime: TEdit;
    btnInsertDateAndTime: TBitBtn;
    btnNOW: TBitBtn;
    txtMessage: TEdit;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure cbPrivateEntryClick(Sender: TObject);
    procedure SaveEntry;
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnInsertDateAndTimeClick(Sender: TObject);
    procedure btnNOWClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormKeyUp(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
  private
    { Private declarations }
  public
    { Public declarations }
    DBTable: string;
    strDateInserted: string;
    EntrySaved: boolean;

    procedure InsertDateAndTime;
  end;

var
  frmDiaryEntry: TfrmDiaryEntry;

implementation

uses MAIN;

{$R *.dfm}

procedure TfrmDiaryEntry.btnCancelClick(Sender: TObject);
begin
    //Cancel Entry:

end;

procedure TfrmDiaryEntry.btnCloseClick(Sender: TObject);
var
  Answer: integer;
begin
  //CLOSE BUTTON
  if EntrySaved then
    MainForm.CloseMDIChild(-1)
  else begin
    Answer:= MessageDlg('Entry not Saved - are you sure you wish to close ?',mtWarning, mbOKCancel, 0);
    if Answer = mrOK then
      MainForm.CloseMDIChild(-1)
  end;

end;

procedure TfrmDiaryEntry.InsertDateAndTime;
var
  BriefEntry: string;
  TimeEntry: string;
  DateEntry: string;
  NewYear,NewMonth,NewDay:word;
  NewHour,NewMin,NewSec,msec:word;
  strDate,strTime: string;
  NewDateTime: TDateTime;
  ErrMsg: string;
begin
  TimeEntry:= txtTime.Text;
  DateEntry:= DateToStr(MainForm.CurrentEditDate);
  NewDateTime:= MainForm.MainConnection.StringToDateTime(DateEntry,TimeEntry,ErrMsg);
  if Length(ErrMsg)>0 then begin
    ShowMessage(ErrMsg);
    exit;
  end;
  MainForm.CurrentEditDate:= NewDateTime;
  BriefEntry:= self.txtBrief.Text;
  if Length(BriefEntry)>0 then
    BriefEntry:= BriefEntry+' '+FormatDateTime('ddd dd mmm yyyy hh:mm:ss',MainForm.CurrentEditDate)+' '
  else
    BriefEntry:= FormatDateTime('ddd dd mmm yyyy hh:mm:ss',MainForm.CurrentEditDate)+' ';
  self.txtBrief.Text:= BriefEntry;
end;

procedure TfrmDiaryEntry.btnInsertDateAndTimeClick(Sender: TObject);
begin
  self.InsertDateAndTime;
end;

procedure TfrmDiaryEntry.btnNOWClick(Sender: TObject);
begin
  MainForm.CurrentEditDate:= Now();
  txtDate.Text:= FormatDateTime('ddd dd mmm yyyy',MainForm.CurrentEditDate);
  txtTime.Text:= FormatDateTime('hh:mm:ss',MainForm.CurrentEditDate);

end;

procedure TfrmDiaryEntry.btnSaveClick(Sender: TObject);
begin
  //Save Entry:
  self.SaveEntry;
end;

procedure TfrmDiaryEntry.cbPrivateEntryClick(Sender: TObject);
begin
  if cbPrivateEntry.Checked then begin
    //hide memo control for private entry:
    self.memPrivate.Visible:= True;

  end
  else begin
    self.memPrivate.Visible:= False;
  end;
end;

procedure TfrmDiaryEntry.FormClose(Sender: TObject; var Action: TCloseAction);
begin
      Action:= caFree
end;

procedure TfrmDiaryEntry.FormCreate(Sender: TObject);
begin
  keyPreview := TRUE;
end;

procedure TfrmDiaryEntry.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    Answer: Integer;
begin
  //does not seem to work.
  if (key=83) and (shift = [ssCTRL]) then begin
    //CTRL+S
    SaveEntry;
  end;
  if (key=67) and (shift = [ssCTRL]) then begin
    //CTRL+C
    if EntrySaved then
      MainForm.CloseMDIChild(-1)
    else begin
      Answer:= MessageDlg('Entry not Saved - are you sure you wish to close ?',mtWarning, mbOKCancel, 0);
      if Answer = mrOK then
        MainForm.CloseMDIChild(-1)
    end;
  end;
  if (key=67) and (shift = [ssCTRL,ssSHIFT]) then begin
    ShowMessage('CTRL+SHIFT+C');
  end;
end;

procedure TfrmDiaryEntry.FormKeyUp(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
    Answer: Integer;
begin
  if (key=67) and (shift = [ssCTRL]) then begin
    //CTRL+C
    if EntrySaved then
      MainForm.CloseMDIChild(-1)
    else begin
      Answer:= MessageDlg('Entry not Saved - are you sure you wish to close ?',mtWarning, mbOKCancel, 0);
      if Answer = mrOK then
        MainForm.CloseMDIChild(-1)
    end;
  end;
  if (key=73) and (shift = [ssCTRL]) then begin
    //CTRL+I
    self.InsertDateAndTime;
  end;
  if (key=83) and (shift = [ssCTRL]) then begin
    //CTRL+S
    SaveEntry;
  end;

end;

procedure TfrmDiaryEntry.SaveEntry;
var
  mySqlConnection: TDBConnections;
  EntryError: boolean;
  strEntryDate: string;
  strEntryTime: string;
  strBrief: string;
  strDetail: string;
  strUserID: string;
  strPrivateEntry: string;
  strDateInserted: string;
  strDateUpdated: string;
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
  CurrentTime: string;
begin
  //Save the entry to the database - checking if date and time already exist.
  //Currently NOT EDITING - only INSERTING.
  EntryError:= FALSE;
  datefield:= 'dailydate';

  //strEntryDate:= self.txtDate.Text;
  strEntryDate:= DateToStr(MainForm.CurrentEditDate);
  strEntryTime:= self.txtTime.Text;
  if TryStrToDate(strEntryDate,dtEntryDate) then
    if TryStrToTime(strEntryTime,dtEntryTime) then
      //Great ok pass
    else begin
      ShowMessage('Time is invalid');
      self.txtMessage.Text:= 'Time is invalid - well we would all live forever - if it wasnt ?';
      exit;
    end
  else begin
    ShowMessage('Date is invalid');
    self.txtMessage.Text:= 'Date is invalid - something wrong with our universe?';
    exit;
  end;
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
    self.txtMessage.Text:= 'Problem with DATE - something weird is happening';
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

    strDateUpdated:= DateTimeToStr(now());

    TotalEntries:= TotalEntries+1;
  end;
  //DateUtils.MilliSecondOf()

  if NOT EntryError then begin
    if TotalEntries > 0 then begin
      if MainForm.CheckLogin then begin
        mySqlConnection:= TDBConnections.Create;
        constr:= MainForm.MainConnection.ConnString;
        mySqlConnection.Password:= MainForm.MainConnection.Password;
        mySqlConnection.Server:= MainForm.MainConnection.Server;
        mySqlConnection.DBName:= MainForm.MainConnection.DBName;
        mySqlConnection.UID:= MainForm.MainConnection.UID;
        mySqlConnection.Port:= MainForm.MainConnection.Port;
        mySqlConnection.ConnString:= constr;
        mySqlConnection.DBOperations.connString:= constr; //very important as cannot call parent class internally

        {
        ValueList:= 'NULL';
        ValueList:= ValueList+','+strNewEntryDateTime;
        ValueList:= ValueList+','+strBrief;
        ValueList:= ValueList+','+strDetail;
        ValueList:= ValueList+','+strUserID;
        ValueList:= ValueList+','+strPrivateEntry;
        ValueList:= ValueList+','+APrivateEntry;
        ValueList:= ValueList+','+strDateInserted;
        valueList:= ValueList+','+strDateUpdated;
        }
        idField:= mySqlconnection.DBOperations.GetFieldnamesOfTypesPassed(Tablename,'ftAutoInc',constr);
        strNewEntryDate:= mySqlconnection.DBOperations.DateForSQL(dtNewEntryDate,FALSE);
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
          strDateInserted:= DateTimeToStr(Now());
          //mySqlConnection.DBOperations.InsertData(DBTable,strCon,FieldList,ValueList);
          ValueList:= 'NULL';
        ValueList:= ValueList+','+strNewEntryDateTime;
        ValueList:= ValueList+','+strBrief;
        ValueList:= ValueList+','+strDetail;
        ValueList:= ValueList+','+strUserID;
        ValueList:= ValueList+','+strPrivateEntry;
        ValueList:= ValueList+','+APrivateEntry;
        ValueList:= ValueList+','+strDateInserted;
        valueList:= ValueList+','+strDateUpdated;
          mySqlConnection.DBOperations.InsertData(DBTable,constr,ValueList);
          mySqlConnection.OpenConnection('',False);
          //Find the form that called this one

          //ShowMessage('OK Record Inserted!');
          CurrentTime:= FormatDateTime('HH:MM:SS',now());
          MainForm.txtStatusBar.Text:= 'OK Entry has been Inserted!' + CurrentTime;
          self.txtMessage.Text:= 'OK Entry has been Inserted!' + CurrentTime;
        end
        else if RecordID = '-1' then begin
          ShowMessage(mySqlConnection.DBOperations.errorMessage);
          exit;
        end
        else begin
          //ShowMessage('Already Entered');
          MainForm.CreateMDIChild(6,'Date and Time already exists (1 minute per entry)',1,1,300,250);
          if MainForm.ButtonClicked = 3 then begin
            //UPDATE

            IDFilter:= idField+' = '+RecordID;
            //RecordID:= mySqlConnection.DBOperations.SearchField(DBTable,strCon,'TariffName','id',IntToStr(RecordID),true);
            SQLQuery:= mySqlConnection.DBOperations.QueryString;
            //ShowMessage('Query = '+SQLQuery);
            ValueList:= 'NULL';
        ValueList:= ValueList+','+strNewEntryDateTime;
        ValueList:= ValueList+','+strBrief;
        ValueList:= ValueList+','+strDetail;
        ValueList:= ValueList+','+strUserID;
        ValueList:= ValueList+','+strPrivateEntry;
        ValueList:= ValueList+','+APrivateEntry;
        ValueList:= ValueList+','+strDateInserted;
        valueList:= ValueList+','+strDateUpdated;

            FieldExcludeList:= 'DateInserted';

            mySqlConnection.DBOperations.UpdateData(DBTable,constr,ValueList,IDFilter,FieldExcludeList,1);
            mySqlConnection.OpenConnection('',False);
            CurrentTime:= FormatDateTime('HH:MM:SS',now());
            MainForm.txtStatusBar.Text:= 'OK Entry has been Updated! '+CurrentTime;
            self.txtMessage.Text:= 'OK Entry has been Updated! '+CurrentTime;
          end;
          if MainForm.ButtonClicked = 2 then begin
            //INSERT
            strDateInserted:= DateTimeToStr(Now());
            ValueList:= 'NULL';
        ValueList:= ValueList+','+strNewEntryDateTime;
        ValueList:= ValueList+','+strBrief;
        ValueList:= ValueList+','+strDetail;
        ValueList:= ValueList+','+strUserID;
        ValueList:= ValueList+','+strPrivateEntry;
        ValueList:= ValueList+','+APrivateEntry;
        ValueList:= ValueList+','+strDateInserted;
        valueList:= ValueList+','+strDateUpdated;
            mySqlConnection.DBOperations.InsertData(DBTable,constr,ValueList);
            mySqlConnection.OpenConnection('',False);
            CurrentTime:= FormatDateTime('HH:MM:SS',now());
            MainForm.txtStatusBar.Text:= 'OK Entry has been Inserted! '+CurrentTime;
            self.txtMessage.Text:= 'OK Entry has been Inserted! '+CurrentTime;
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


      end;
    end
    else begin
      ShowMessage('All entries must be entered - no blanks');
      EntryError:= True;
    end;
    EntrySaved:= TRUE;
  end
  else begin
    ShowMessage('ERROR during date entry');
    EntryError:= True;
  end;
end;

end.
