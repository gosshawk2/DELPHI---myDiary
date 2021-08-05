unit EnterUserDetails;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, myDatabaseClass_II, dateUtils, strUtils;

type
  TfrmUserDetails = class(TForm)
    pnlTop: TPanel;
    lblTitle: TLabel;
    btnClose: TBitBtn;
    pnlButtons: TPanel;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    PageControl_Users: TPageControl;
    tabPersonalDetails: TTabSheet;
    pnlPersonalDetails: TPanel;
    lblFirstname: TLabel;
    lblLastname: TLabel;
    lblDateAdded: TLabel;
    lblGender: TLabel;
    lblDOB: TLabel;
    txtFirstname: TEdit;
    txtLastname: TEdit;
    txtDateAdded: TEdit;
    dtDateAddedPicker: TDateTimePicker;
    txtGender: TEdit;
    rbMale: TRadioButton;
    rbFemale: TRadioButton;
    txtDOB: TEdit;
    dtDOBPicker: TDateTimePicker;
    lblNickname: TLabel;
    txtNickname: TEdit;
    lblUsername: TLabel;
    txtUsername: TEdit;
    lblPassword: TLabel;
    txtPassword: TEdit;
    lblConfirmPassword: TLabel;
    txtConfirmPassword: TEdit;
    lblemailaddress: TLabel;
    txtEmailAddress: TEdit;
    lblContactNumber: TLabel;
    txtContactNumber: TEdit;
    txtUserID: TEdit;
    tabPermissions: TTabSheet;
    Panel1: TPanel;
    Label3: TLabel;
    txtPermission: TEdit;
    comPermissions: TComboBox;
    procedure rbMaleClick(Sender: TObject);
    procedure rbFemaleClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnCancelClick(Sender: TObject);
    procedure dtDateAddedPickerChange(Sender: TObject);
    procedure dtDOBPickerChange(Sender: TObject);
    procedure dtDateAddedPickerClick(Sender: TObject);
    procedure dtDOBPickerClick(Sender: TObject);
    procedure comPermissionsChange(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    DBTable: string;
    UserID: integer;
    UserCreated: string;
    UserFirstname: string;
    UserLastname: string;
    UserGender: string;
    UserDOB: string;
    UserNickname: string;
    Username: string;
    Password: string;
    ConfirmPassword: string;
    emailAddress: string;
    ContactNumber: string;

    procedure LoadPermissions;
  end;

var
  frmUserDetails: TfrmUserDetails;

implementation

uses Main;

{$R *.dfm}

procedure TfrmUserDetails.btnCancelClick(Sender: TObject);
begin
  MainForm.CloseMDIChild(-1);
end;

procedure TfrmUserDetails.btnCloseClick(Sender: TObject);
begin
  MainForm.CloseMDIChild(-1);
end;

procedure TfrmUserDetails.btnSaveClick(Sender: TObject);
var
  mySqlConnection: TDBConnections;
  EntryDate: TDateTime;
  EntryTime: TDateTime;
  NewDate,UPDate: TDateTime;
  EntryError: boolean;
  NewYear,NewMonth,NewDay:word;
  NewHour,NewMin,NewSec:word;
  TotalEntries: integer;
  strCon: string;
  sqlcmd: string;
  CustomerID,ID2,ID3: integer;
  FieldList,ValueList,Filter: string;
  FieldsExcluded: string;
  MaxEntries: integer;
  msgReturn: integer;
  RecordID: integer;
  Permission: string;
begin
  //Save User Details - also create the new user in the database using
  //Using GRANT ALL PERMISSIONS On database.table  Using password
  TryStrToInt(txtUserId.Text,self.UserID);
  self.UserCreated:= txtDateAdded.Text;
  self.UserFirstname:= txtFirstname.Text;
  self.UserLastname:= txtLastname.Text;
  self.UserGender:= txtGender.Text;
  //self.UserDOB:= txtDOB.Text;
  self.UserNickname:= txtNickname.Text;
  self.Username:= txtUsername.Text;
  self.Password:= txtPassword.Text;
  self.ConfirmPassword:= txtConfirmPassword.Text;
  self.emailAddress:= txtEmailAddress.Text;
  self.ContactNumber:= txtContactNumber.Text;
  Permission:= txtPermission.Text;

  EntryError:= FALSE;
  TotalEntries:= 0;
  MaxEntries:= 0;
  FieldsExcluded:= '';
  EntryDate:= strToDateTime(self.UserCreated);
  NewYear:= YearOf(EntryDate);
  NewMonth:= MonthOf(EntryDate);
  NewDay:= DayOf(EntryDate);
  NewHour:= HourOf(EntryDate);
  NewMin:= MinuteOf(EntryDate);
  NewSec:= SecondOf(EntryDate);
  //DateUtils.MilliSecondOf()
  NewDate:= EncodeDateTime(NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,0);
  UPDate:= EncodeDateTime(NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,0);
  //DOBDate:= EncodeDateTime(NewYear,NewMonth,NewDay,NewHour,NewMin,NewSec,0);
  if NOT (self.Password =  self.ConfirmPassword) then begin
    ShowMessage('Passwords Do Not Match');
    EntryError:= True;
  end;
  if NOT EntryError then begin
    if MainForm.CheckLogin then begin
      mySqlConnection:= TDBConnections.Create;
      strCon:= MainForm.MainConnection.ConnString;
      RecordID:= mySqlConnection.DBOperations.SearchField(DBTable,strCon,'username',self.Username,
        True,False);

      mySqlConnection.Password:= MainForm.MainConnection.Password; //NEEDS ENCODING
      mySqlConnection.Server:= MainForm.MainConnection.Server;
      mySqlConnection.DBName:= MainForm.MainConnection.DBName;
      mySqlConnection.UID:= MainForm.MainConnection.UID;
      mySqlConnection.Port:= MainForm.MainConnection.Port;
      strCon:= mySqlConnection.ConnString;
      mySqlConnection.DBOperations.connString:= strCon; //very important as cannot call parent class internally
      FieldList:= 'userid'; // Currently not included in list.

      FieldList:= 'nickname';
      FieldList:= FieldList+','+'username';
      FieldList:= FieldList+','+'firstname'+','+'lastname';
      FieldList:= FieldList+','+'emailAddress';
      FieldList:= FieldList+','+'password';
      FieldList:= FieldList+','+'contactnumber';
      FieldList:= FieldList+','+'created';
      FieldList:= FieldList+','+'updated';
      FieldList:= FieldList+','+'Permission';
      FieldList:= FieldList+','+'Gender';
      //ValueList should get values in field order from table - Created_at and updated_at missed out at moment.
      ValueList:= 'NULL'; //is this needed for update ? will it make the id field blank if update occurs ?
      ValueList:= ValueList+','+self.UserNickname;
      ValueList:= ValueList+','+self.Username;
      ValueList:= ValueList+','+self.UserFirstname;
      ValueList:= ValueList+','+self.UserLastname;
      ValueList:= ValueList+','+self.emailAddress;
      ValueList:= ValueList+','+self.Password;
      ValueList:= ValueList+','+self.ContactNumber;
      ValueList:= ValueList+','+DateTimeToStr(NewDate);
      ValueList:= ValueList+','+DateTimeToStr(UPDate);
      ValueList:= ValueList+','+Permission;
      ValueList:= ValueList+','+self.UserGender;

      if RecordID=0 then begin
        //Insert New meter reading
        mySqlConnection.DBOperations.InsertData(DBTable,strCon,FieldList,ValueList);
        //mySqlConnection.DBOperations.InsertData(DBTable,strCon,ValueList);
        mySqlConnection.OpenConnection('',False);
        ShowMessage('OK Record '+IntToStr(RecordID)+' Inserted!');
      end
      else begin
        //Update existing meter reading entry with RecordID - any excluded fields ???
        ShowMessage('Already Entered');
        //call dialog box here for user to choose to save or not.
        Filter:= 'id = '+IntToStr(RecordID);
        FieldsExcluded:= 'created';
        mySqlConnection.DBOperations.UpdateData(DBTable,strCon,FieldList,ValueList,Filter,FieldsExcluded);
        mySqlConnection.OpenConnection('',False);
        ShowMessage('OK Record '+IntToStr(RecordID)+' Updated!');
      end;
      if Length(mySqlConnection.DBOperations.errorMessage)>0 then
        ShowMessage(mySqlConnection.DBOperations.errorMessage);
      if Length(mySqlConnection.DBOperations.queryMessage)>0 then
        //ShowMessage('query message= '+mySqlConnection.DBOperations.queryMessage);

      //Dt:=FAccessADOQuery.Fields.FieldByName(FIELD_NAME).AsDateTime;
      //Ds:=FormatDateTime('dd-mmm-yyyy',dt);
      //strToDateTime(mySqlConnection.DBOperations.ADOQuery.Fields.FieldByName('DateOfReading').AsString); RETURNS ERROR IF NULL

      //DateOfReading:= mySqlConnection.DBOperations.ADOQuery.Fields.FieldByName('DateOfReading').AsDateTime;
      //strDateOfReading:= mySqlConnection.DBOperations.ADOQuery.Fields.FieldByName('DateOfReading').AsString;
      //if Length(strDateOfReading)>0 then


    end
    else
      ShowMessage('Player Not Logged in');

  end
  else
    ShowMessage('ERROR during entry');

end;

procedure TfrmUserDetails.comPermissionsChange(Sender: TObject);
var
  Permission: string;
begin
  Permission:= UPPERCASE(comPermissions.Text);
  if (Length(self.comPermissions.Text)>0) AND (PosEx('SELECT',Permission,1)=0) then
    self.txtPermission.Text:= Permission;

end;

procedure TfrmUserDetails.dtDOBPickerChange(Sender: TObject);
var
  dtDateChosen: TDateTime;
begin
  dtDateChosen:= dtDOBPicker.DateTime;
  self.txtDOB.Text:= DateTimeToStr(dtDateChosen);
end;

procedure TfrmUserDetails.dtDOBPickerClick(Sender: TObject);
var
  dtDateChosen: TDateTime;
begin
  dtDateChosen:= dtDOBPicker.DateTime;
  self.txtDOB.Text:= DateTimeToStr(dtDateChosen);
end;

procedure TfrmUserDetails.dtDateAddedPickerChange(Sender: TObject);
var
  DatePicked: TDateTime;
  TimePicked: TDateTime;
  DatePart: string;
  TimePart: string;
begin
  DatePicked:= dtDateAddedPicker.Date;
  TimePicked:= Time();
  DatePart:= DateToStr(DatePicked);
  TimePart:= TimeToStr(TimePicked);
  txtDateAdded.Text:= DatePart+' '+TimePart;
end;

procedure TfrmUserDetails.dtDateAddedPickerClick(Sender: TObject);
var
  DatePicked: TDateTime;
  TimePicked: TDateTime;
  DatePart: string;
  TimePart: string;
begin
  DatePicked:= dtDateAddedPicker.Date;
  TimePicked:= Time();
  DatePart:= DateToStr(DatePicked);
  TimePart:= TimeToStr(TimePicked);
  txtDateAdded.Text:= DatePart+' '+TimePart;
end;

procedure TfrmUserDetails.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfrmUserDetails.LoadPermissions;
begin
  self.comPermissions.Items.Add('SUPERUSER');
  self.comPermissions.Items.Add('USER');
  self.comPermissions.Items.Add('ADMIN'); //maybe  not allow to view the data ?

end;

procedure TfrmUserDetails.rbFemaleClick(Sender: TObject);
begin
  txtGender.Text:= 'Female';
end;

procedure TfrmUserDetails.rbMaleClick(Sender: TObject);
begin
  txtGender.Text:= 'Male';
end;

end.
