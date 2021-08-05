unit EnterSchedules;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ComCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, myDatabaseClass_II,dateUtils, strUtils;

type
  TfrmEnterSchedules = class(TForm)
    pnlTop: TPanel;
    lblTitle: TLabel;
    btnClose: TBitBtn;
    pnlButtons: TPanel;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    pnlPersonalDetails: TPanel;
    lblFirstname: TLabel;
    lblLastname: TLabel;
    lblComputerName: TLabel;
    lblSessionName: TLabel;
    txtFirstname: TEdit;
    txtLastname: TEdit;
    txtComputerName: TEdit;
    txtScheduleName: TEdit;
    comNicknames: TComboBox;
    lblComments: TLabel;
    memComments: TMemo;
    txtNameID: TEdit;
    lblGameStartDate: TLabel;
    txtStartDay: TEdit;
    txtStartHour: TEdit;
    dtStartPicker: TDateTimePicker;
    btnLastSchedule: TBitBtn;
    txtStartMinute: TEdit;
    lblGameStartColon: TLabel;
    txtStartMonth: TEdit;
    lblGameStartDateSeparator1: TLabel;
    txtStartYear: TEdit;
    lblGameStartDateSeparator2: TLabel;
    lblGameEndDate: TLabel;
    txtEndDay: TEdit;
    txtEndMonth: TEdit;
    lblGameEndDateSeparator2: TLabel;
    txtEndYear: TEdit;
    txtEndHour: TEdit;
    lblGameEndColon: TLabel;
    txtEndMinute: TEdit;
    dtEndPicker: TDateTimePicker;
    lblGameEndDateSeparator1: TLabel;
    Label1: TLabel;
    cbAlarm: TCheckBox;
    rbHourly: TRadioButton;
    rbDaily: TRadioButton;
    rbWeekly: TRadioButton;
    rbMonthly: TRadioButton;
    rbYearly: TRadioButton;
    procedure comNicknamesClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure txtFirstnameClick(Sender: TObject);
    procedure txtNameIDClick(Sender: TObject);
    procedure txtLastnameClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure dtStartPickerChange(Sender: TObject);
    procedure dtEndPickerChange(Sender: TObject);
    procedure comNicknamesEnter(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    computerName: string;
    DBTable: string;
    sortField: string;
    scheduleRecArray: TRecArray;
    UserNameID: string;
    UserFirstname: string;
    UserLastname: string;
    scheduleName: string;
    scheduleID: integer;
    UserNickname: string;
    StartDay: string;
    StartMonth: string;
    StartYear: string;
    StartHour: string;
    StartMinute: string;
    StartSecond: string;
    EndDay: string;
    EndMonth: string;
    EndYear: string;
    EndHour: string;
    EndMinute: string;
    EndSecond: string;

    strStartDate: string;
    strEndDate: string;
    strStartTime: string;
    strEndTime: string;
    dtScheduleStartDate: TDateTime;
    dtScheduleEndDate: TDateTime;
    EntryScheduleStartDate: TDateTime;
    EntryScheduleStartTime: TDateTime;
    EntryScheduleEndDate: TDateTime;
    EntryScheduleEndTime: TDateTime;
    comments: string;

    function FillCombo(TheDBTable: string; comboName: TCombobox; Fieldname,Filter:string):TRecArray;
    function GetTotalTime:string;
    function GetTimePlayed(EndDate,StartDate:TDateTime): string;overload;
    function GetTimePlayed(EndDate,StartDate:TDateTime; ReturnTimeUnit:integer): integer;overload;
  end;

var
  frmEnterSchedules: TfrmEnterSchedules;

implementation

uses Main;

{$R *.dfm}

procedure TfrmEnterSchedules.btnCloseClick(Sender: TObject);
begin
  MainForm.CloseMDIChild(-1);
end;

procedure TfrmEnterSchedules.btnSaveClick(Sender: TObject);
var
  mySqlConnection: TDBConnections;

  NewDate: TDateTime;
  EntryError: boolean;
  NewYear,NewMonth,NewDay:word;
  NewHour,NewMin,NewSec,msec:word;
  TotalEntries: integer;
  strCon: string;
  sqlcmd: string;
  FieldList,ValueList,Filter: string;
  FieldsExcluded: string;
  ValueArray: TstrArray;
  FieldArray: TstrArray;
  MaxEntries: integer;
  msgReturn: integer;
  NumDays: Integer;
  CorrectDays: integer;
  NumHours: integer;
  CorrectHours: integer;
  NumMinutes: integer;
  CorrectMinutes: integer;
  SchedID: integer;
begin
  //save session data:
  self.computerName:= MainForm.ComputerName;
  EntryError:= FALSE;

  self.StartDay:= self.txtStartDay.Text;
  self.StartMonth:= self.txtStartMonth.Text;
  self.StartYear:= self.txtStartYear.Text;
  self.StartHour:= self.txtStartHour.Text;
  self.StartMinute:= self.txtStartMinute.Text;
  self.StartSecond:= '0';

  self.EndDay:= self.txtEndDay.Text;
  self.EndMonth:= self.txtEndMonth.Text;
  self.EndYear:= self.txtEndYear.Text;
  self.EndHour:= self.txtEndHour.Text;
  self.EndMinute:= self.txtEndMinute.Text;
  self.EndSecond:= '0';

  self.strstartDate:= self.StartDay+'/'+self.StartMonth+'/'+self.StartYear;
  self.strStartTime:= self.StartHour+':'+self.StartMinute+':'+self.StartSecond;
  self.strEndDate:= self.EndDay+'/'+self.EndMonth+'/'+self.EndYear;
  self.strEndTime:= self.EndHour+':'+self.EndMinute+':'+self.EndSecond;

  //
  if NOT trystrToDate(self.strStartDate,EntryScheduleStartDate) then begin
      ShowMessage('Schedule Start Date Error');
      EntryError:= True;
  end;
  if NOT trystrToTime(self.strStartTime,EntryScheduleStartTime) then begin
      ShowMessage('Schedule Start Time Error');
      EntryError:= True;
  end;

  NewYear:= YearOf(EntryScheduleStartDate);
  NewMonth:= MonthOf(EntryScheduleStartDate);
  NewDay:= DayOf(EntryScheduleStartDate);
  NewHour:= HourOf(EntryScheduleStartTime);
  NewMin:= MinuteOf(EntryScheduleStartTime);
  NewSec:= SecondOf(EntryScheduleStartTime);
  msec:= 0;
  //DateUtils.MilliSecondOf()
  self.dtScheduleStartDate:= EncodeDateTime(NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,msec);

  if NOT trystrToDate(self.strEndDate,EntryScheduleEndDate) then begin
    ShowMessage('Schedule End Date Error');
    EntryError:= True;
  end;
  if NOT trystrToTime(self.strEndTime,EntryScheduleEndTime) then begin
    ShowMessage('Schedule End Time Error');
    EntryError:= True;
  end;
  NewYear:= YearOf(EntryScheduleEndDate);
  NewMonth:= MonthOf(EntryScheduleEndDate);
  NewDay:= DayOf(EntryScheduleEndDate);
  NewHour:= HourOf(EntryScheduleEndTime);
  NewMin:= MinuteOf(EntryScheduleEndTime);
  NewSec:= SecondOf(EntryScheduleEndTime);
  msec:= 0;
  self.dtScheduleEndDate:= EncodeDateTime(NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,msec);

  self.UserNameID:= txtNameID.Text;
  self.UserFirstname:= txtFirstname.Text;
  self.UserLastname:= txtLastname.Text;
  self.scheduleName:= txtScheduleName.Text;
  self.userNickname:= self.comNicknames.Text;

  self.comments:= self.memComments.Text;

  TotalEntries:= 0;
  MaxEntries:= 0;
  FieldsExcluded:= '';
  if NOT EntryError then begin
    if MainForm.CheckLogin then begin
      //maybe values should be entered into an array ?
      //to make it easier to code the entry ?
      //just pair the value with the fieldname - in any order?
      //code afterwards will sort the fieldname and values into the
      //correct order for the table fields.
      //so get the index of the position of the field in the table first.
      //This will be used as the elememnt index to both Field and Value arrays?

      mySqlConnection:= TDBConnections.Create;
      mySqlConnection.Password:= MainForm.MainConnection.Password;
      mySqlConnection.Server:= MainForm.MainConnection.Server;
      mySqlConnection.DBName:= MainForm.MainConnection.DBName;
      mySqlConnection.UID:= MainForm.MainConnection.UID;
      mySqlConnection.Port:= MainForm.MainConnection.Port;
      strCon:= MainForm.MainConnection.ConnString;
      mySqlConnection.DBOperations.connString:= strCon; //very important as cannot call parent class internally
      strStartDate:= DateTimeToStr(self.dtScheduleStartDate);
      strEndDate:= DateTimeToStr(self.dtScheduleEndDate);
      strStartDate:= ReplaceText(strStartDate,'/','-');
      strEndDate:= ReplaceText(strEndDate,'/','-');

      //ValueList should get values in field order from table - Created_at and updated_at missed out at moment.

      ValueList:= 'NULL'; //is this needed for update ? will it make the id field blank if update occurs ?
      valueList:= ValueList+','+self.scheduleName;
      ValueList:= ValueList+','+self.computerName;
      ValueList:= ValueList+','+strStartDate;
      ValueList:= ValueList+','+strEndDate;
      ValueList:= ValueList+','+self.UserNameID;
      ValueList:= ValueList+','+self.UserFirstname;
      ValueList:= ValueList+','+self.UserLastname;
      ValueList:= ValueList+','+self.comments;

      //need SessionName , TimePlayed , TotalTimePlayed , comments
      //WHAT MAKES AN UPDATE OR INSERT ?
      //First = PlayerID,
      //Second = nickname,
      //Third = SessionName,
      //Fourth =
      //if searchdate already exists - ie if date and time match whats in table then already entered.
      SchedID:= mySqlConnection.DBOperations.SearchDateField('schedules',strcon,'startdate',self.dtScheduleStartDate,TRUE);
      if SchedID=0 then begin //new start date has been entered.
        //Insert New schedule message:
        mySqlConnection.DBOperations.InsertData(DBTable,strCon,ValueList);
        mySqlConnection.OpenConnection('',False);
        ShowMessage('OK Record Inserted!');
      end
      else begin
        //Update existing schedule
        //call dialog box here for user to choose to save or not.
        MainForm.CreateMDIChild(6,'Already Exists - OVERWRITE?',1,1,310,200);
        if MainForm.ButtonClicked=3 then begin
          Filter:= 'id = '+IntToStr(SchedID);
          FieldsExcluded:= '';
          mySqlConnection.DBOperations.UpdateData(DBTable,strCon,ValueList,Filter,FieldsExcluded,1);
          mySqlConnection.OpenConnection('',False);
          ShowMessage('OK Record# '+IntToStr(SchedID)+' Updated!');
        end
        else if MainForm.ButtonClicked=2 then begin
          mySqlConnection.DBOperations.InsertData(DBTable,strCon,ValueList);
          mySqlConnection.OpenConnection('',False);
          ShowMessage('OK Record Inserted!');
        end;
      end;

      if Length(mySqlConnection.DBOperations.errorMessage)>0 then
        ShowMessage(mySqlConnection.DBOperations.errorMessage);
      if Length(mySqlConnection.DBOperations.queryMessage)>0 then
        ShowMessage('query message= '+mySqlConnection.DBOperations.queryMessage);

      //Dt:=FAccessADOQuery.Fields.FieldByName(FIELD_NAME).AsDateTime;
      //Ds:=FormatDateTime('dd-mmm-yyyy',dt);
      //strToDateTime(mySqlConnection.DBOperations.ADOQuery.Fields.FieldByName('DateOfReading').AsString); RETURNS ERROR IF NULL

      //DateOfReading:= mySqlConnection.DBOperations.ADOQuery.Fields.FieldByName('DateOfReading').AsDateTime;
      //strDateOfReading:= mySqlConnection.DBOperations.ADOQuery.Fields.FieldByName('DateOfReading').AsString;
      //if Length(strDateOfReading)>0 then


    end
    else
      ShowMessage('User Not Logged in');

  end
  else
    ShowMessage('ERROR during entry');
end;

procedure TfrmEnterSchedules.comNicknamesClick(Sender: TObject);
var
  Choice: integer;
  conStr: widestring;
  TableName: string;
  RecID: integer;
  Nickname: string;
  Firstname: string;
  Lastname: string;
  Filter: string;
begin
  //load / populate firstname,lastname,nickname
  //This event will only fire if there ARE items in the dropdown already !!
  //For the ENTER Event for combo controls:
  //Filter:= 'chargetype != ""';

    Choice:= MAINForm.GetComboIndex(comNicknames);
    Nickname:= comNicknames.Text;

    conStr:= MainForm.MainConnection.ConnString;
    TableName:= 'diaryusers';
    RecID:= MainForm.MainConnection.DBOperations.SearchField(TableName,conStr,'nickname',Nickname,
      True,False);
    self.txtNameID.Text:= IntToStr(RecID);
    Firstname:= MainForm.MainConnection.DBOperations.GetSingleRecArray(TableName,conStr,'Firstname');
    Lastname:= MainForm.MainConnection.DBOperations.GetSingleRecArray(TableName,conStr,'Lastname');
    txtFirstname.Text:= Firstname;
    txtLastname.Text:= Lastname;
end;

procedure TfrmEnterSchedules.comNicknamesEnter(Sender: TObject);
var
  Filter: string;
begin
  Filter:= 'Nickname != ""';
  MainForm.myRecArray:= FillCombo('diaryusers',self.comNicknames,'nickname',Filter);
end;

procedure TfrmEnterSchedules.dtEndPickerChange(Sender: TObject);
var
  NewDate: TDateTime;
  EntryError: boolean;
  NowTime: TDateTime;
  NewYear,NewMonth,NewDay:word;
  NewHour,NewMin,NewSec,NewMSec:word;
  strDay,strMonth,strYear: string;
  strHour,strMinute,strSecond: string;

  strTime: string;
begin
  self.dtScheduleEndDate:= dtEndPicker.Date;
  strTime:= TimeToStr(Now());
  NowTime:= Now();
  //decode = split datetime into the word variables.
  //encode = combine the word variables into one date.

  decodetime(NowTime,NewHour,NewMin,NewSec,NewMSec);
  decodedate(self.dtScheduleEndDate,NewYear,NewMonth,NewDay);
  strDay:= IntToStr(NewDay);
  strMonth:= IntToStr(NewMonth);
  strYear:= IntToStr(NewYear);
  strHour:= IntToStr(NewHour);
  strMinute:= IntToStr(NewMin);
  strSecond:= IntToStr(NewSec);
  self.txtStartDay.Text:= strDay;
  self.txtStartMonth.Text:= strMonth;
  self.txtStartYear.Text:= strYear;
  self.txtStartHour.Text:= strHour;
  self.txtStartMinute.Text:= strMinute;


end;

procedure TfrmEnterSchedules.dtStartPickerChange(Sender: TObject);
var
  NewDate: TDateTime;
  EntryError: boolean;
  NowTime: TDateTime;
  NewYear,NewMonth,NewDay:word;
  NewHour,NewMin,NewSec,NewMSec:word;
  strDay,strMonth,strYear: string;
  strHour,strMinute,strSecond: string;
  strTime: string;
begin

  self.dtScheduleStartDate:= self.dtStartPicker.Date;
  strTime:= TimeToStr(Now());
  NowTime:= Now();

  decodetime(NowTime,NewHour,NewMin,NewSec,NewMSec);
  decodedate(self.dtScheduleEndDate,NewYear,NewMonth,NewDay);
  strDay:= IntToStr(NewDay);
  strMonth:= IntToStr(NewMonth);
  strYear:= IntToStr(NewYear);
  strHour:= IntToStr(NewHour);
  strMinute:= IntToStr(NewMin);
  strSecond:= IntToStr(NewSec);
  self.txtEndDay.Text:= strDay;
  self.txtEndMonth.Text:= strMonth;
  self.txtEndYear.Text:= strYear;
  self.txtEndHour.Text:= strHour;
  self.txtEndMinute.Text:= strMinute;

end;

procedure TfrmEnterSchedules.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

function TfrmEnterSchedules.FillCombo(TheDBTable: string; comboName: TCombobox; Fieldname,Filter:string):TRecArray;
var
  RecArray: TRecArray;
begin
  //PopulateRecArray is a bit slow as it loads all the records. hmmmmm
  //select the nickname only from the database. use a filter ??
  //Array will be blank if no records were found ????
  RecArray:= nil;
  if comboName.Items.Count = 0 then begin
    RecArray:= MainForm.PopulateRecArray(TheDBTable,Filter,Fieldname,'',False);
    MainForm.PopulateCombo(comboName,TheDBTable,Fieldname,RecArray,Filter,Fieldname);

  end;
  Result:= RecArray;
end;

function TfrmEnterSchedules.GetTimePlayed(EndDate,StartDate:TDateTime): string;
var
  NumDays: integer;
  NumMinutes: integer;
  NumHours: integer;
  CorrectDays: integer;
  CorrectHours: integer;
  CorrectMinutes: integer;
  FinalString: string;
begin
  //deduct one date from the other to get the time and days played:
  // for this session:
  FinalString:= 'Days:0, Hours:0, Minutes:0';
  NumDays:= DaysBetween(EndDate,StartDate);
  CorrectDays:= NumDays; //take off the years if applicable
  //subtract NumDays*24 off NumHours for true value
  NumHours:= HoursBetween(EndDate,StartDate);
  CorrectHours:= NumHours - (NumDays*24);
  //subtract NumDays*1440 (24*60) off NumMinutes for true value
  NumMinutes:= MinutesBetween(EndDate,StartDate);
  CorrectMinutes:= NumMinutes - (NumDays*1440) - (CorrectHours*60);
  FinalString:= IntToStr(CorrectDays)+' days '+IntToStr(CorrectHours)+' hours and '+IntToStr(CorrectMinutes)+' minutes';
  Result:= FinalString;
end;

function TfrmEnterSchedules.GetTimePlayed(EndDate,StartDate:TDateTime; ReturnTimeUnit:integer): integer;
var
  NumDays: integer;
  NumMinutes: integer;
  NumHours: integer;
  CorrectDays: integer;
  CorrectHours: integer;
  CorrectMinutes: integer;
  FinalString: string;
begin
  //deduct one date from the other to get the time and days played:
  // for this session:
  FinalString:= 'Days:0, Hours:0, Minutes:0';

  NumDays:= DaysBetween(EndDate,StartDate);
  NumHours:= HoursBetween(EndDate,StartDate);
  CorrectHours:= NumHours - (NumDays*24);
  NumMinutes:= MinutesBetween(EndDate,StartDate);
  CorrectMinutes:= NumMinutes - (NumDays*1440) - (CorrectHours*60);
  if ReturnTimeUnit = 1 then begin
    Result:= NumDays; //take off the years if applicable
    exit;
  end
  else if ReturnTimeUnit = 2 then begin
    Result:= CorrectHours;
    exit;
  end
  else begin
    Result:= CorrectMinutes;
    exit;
  end;
end;

function TfrmEnterSchedules.GetTotalTime:string;
begin

end;

procedure TfrmEnterSchedules.txtFirstnameClick(Sender: TObject);
var
  Filter: string;
begin
  //Users ID entry: load Users combo
  Filter:= 'nickname != ""';
  MainForm.myRecArray:= FillCombo('diaryusers',self.comNicknames,'nickname',Filter);
end;

procedure TfrmEnterSchedules.txtLastnameClick(Sender: TObject);
var
  Filter: string;
begin
  Filter:= 'nickname != ""';
  MainForm.myRecArray:= FillCombo('diaryusers',self.comNicknames,'nickname',Filter);
end;

procedure TfrmEnterSchedules.txtNameIDClick(Sender: TObject);
var
  Filter: string;
begin
  Filter:= 'nickname != ""';
  MainForm.myRecArray:= FillCombo('diaryusers',self.comNicknames,'nickname',Filter);
end;

end.
