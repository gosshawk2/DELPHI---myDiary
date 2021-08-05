unit MAIN;

//***************************************************************************
//Added Child12 - TfrmCustomerDetails to CreateMDIChild
// - needs completing.
//
//Date Added: 29/08/2014 by Daniel Goss
//
//Date Added: 18/03/2015 by Daniel Goss
//
//
//Added Child14 - Child18 to GetChildNumber - 18/07/2015 by Daniel Goss
//
//***************************************************************************

interface

uses Windows, SysUtils, Classes, Graphics, Forms, Controls, Menus,
  StdCtrls, strUtils, Dialogs, Buttons, Messages, ExtCtrls, ComCtrls, StdActns,
  ActnList, ToolWin, ImgList, myDatabaseClass_II, inifiles, DateUtils, MaskUtils,
  Vcl.Imaging.jpeg, System.ImageList, System.Actions;

const NumberOfTables = 18;

type
  TMainForm = class(TForm)
    MainMenu1: TMainMenu;
    File1: TMenuItem;
    FileNewItem: TMenuItem;
    FileOpenItem: TMenuItem;
    FileCloseItem: TMenuItem;
    Window1: TMenuItem;
    Help1: TMenuItem;
    N1: TMenuItem;
    FileExitItem: TMenuItem;
    WindowCascadeItem: TMenuItem;
    WindowTileItem: TMenuItem;
    WindowArrangeItem: TMenuItem;
    HelpAboutItem: TMenuItem;
    OpenDialog: TOpenDialog;
    FileSaveItem: TMenuItem;
    FileSaveAsItem: TMenuItem;
    Edit1: TMenuItem;
    CutItem: TMenuItem;
    CopyItem: TMenuItem;
    PasteItem: TMenuItem;
    WindowMinimizeItem: TMenuItem;
    ActionList1: TActionList;
    EditCut1: TEditCut;
    EditCopy1: TEditCopy;
    EditPaste1: TEditPaste;
    FileNew1: TAction;
    FileSave1: TAction;
    FileExit1: TAction;
    FileOpen1: TAction;
    FileSaveAs1: TAction;
    WindowCascade1: TWindowCascade;
    WindowTileHorizontal1: TWindowTileHorizontal;
    WindowArrangeAll1: TWindowArrange;
    WindowMinimizeAll1: TWindowMinimizeAll;
    HelpAbout1: TAction;
    FileClose1: TWindowClose;
    WindowTileVertical1: TWindowTileVertical;
    WindowTileItem2: TMenuItem;
    ToolBar2: TToolBar;
    ToolButton1: TToolButton;
    ToolButton2: TToolButton;
    ToolButton3: TToolButton;
    ToolButton4: TToolButton;
    ToolButton5: TToolButton;
    ToolButton6: TToolButton;
    ToolButton9: TToolButton;
    ToolButton7: TToolButton;
    ToolButton8: TToolButton;
    ToolButton10: TToolButton;
    ToolButton11: TToolButton;
    ImageList1: TImageList;
    Options1: TMenuItem;
    Database1: TMenuItem;
    N2: TMenuItem;
    Close1: TMenuItem;
    CloseAll1: TMenuItem;
    View1: TMenuItem;
    break1: TMenuItem;
    DiaryDetails1: TMenuItem;
    ViewSessionLog1: TMenuItem;
    break2: TMenuItem;
    imgLogo: TImage;
    imgTitle: TImage;
    N3: TMenuItem;
    SaveWindowPositions1: TMenuItem;
    LoadWindowPositions1: TMenuItem;
    saveINI: TSaveDialog;
    loadINI: TOpenDialog;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ViewAllWindowsStored1: TMenuItem;
    txtStatusBar: TEdit;
    MainTimer: TTimer;
    messageTimer: TTimer;
    ToolButton14: TToolButton;
    imgDefaultLayout: TImage;
    ToolButton15: TToolButton;
    comDefaultLayouts: TComboBox;
    txtStatusBar2: TEdit;
    CreateDatabase1: TMenuItem;
    Reports1: TMenuItem;
    Charts1: TMenuItem;
    ChangeGridColours1: TMenuItem;
    DetailEntry1: TMenuItem;
    PersonalDetails1: TMenuItem;
    DiaryEntry1: TMenuItem;
    ViewPlayerDetails1: TMenuItem;
    ViewSessions1: TMenuItem;
    SessionLogEntry1: TMenuItem;
    N5: TMenuItem;
    Schedules1: TMenuItem;
    ScheduleEntry1: TMenuItem;
    N4: TMenuItem;
    XMLToDatabase1: TMenuItem;
    ViewGrid1: TMenuItem;
    DatabaseToXMLfile1: TMenuItem;
    pnlMain: TPanel;
    CreateUser1: TMenuItem;
    N6: TMenuItem;

    procedure FileNew1Execute(Sender: TObject);
    procedure FileOpen1Execute(Sender: TObject);
    procedure HelpAbout1Execute(Sender: TObject);
    procedure FileExit1Execute(Sender: TObject);
    procedure Database1Click(Sender: TObject);
    procedure Close1Click(Sender: TObject);
    procedure CloseAll1Click(Sender: TObject);
    procedure EnterSessions1Click(Sender: TObject);
    procedure DiaryDetails1Click(Sender: TObject);
    procedure ViewSessionLog1Click(Sender: TObject);
    procedure ViewTotalCredits1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SaveWindowPositions1Click(Sender: TObject);
    procedure LoadWindowPositions1Click(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure FormResize(Sender: TObject);
    procedure ToolButton12Click(Sender: TObject);
    procedure ToolButton13Click(Sender: TObject);
    procedure ViewAllWindowsStored1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure MainTimerTimer(Sender: TObject);
    procedure messageTimerTimer(Sender: TObject);
    procedure CreateDatabase1Click(Sender: TObject);
    procedure Charts1Click(Sender: TObject);
    procedure ChangeGridColours1Click(Sender: TObject);
    procedure PersonalDetails1Click(Sender: TObject);
    procedure ViewFactoryDetails2Click(Sender: TObject);
    procedure ViewSessions1Click(Sender: TObject);
    procedure ViewObjects1Click(Sender: TObject);
    procedure ViewGoodsDetails1Click(Sender: TObject);
    procedure DiaryEntry1Click(Sender: TObject);
    procedure SessionLogEntry1Click(Sender: TObject);
    procedure ViewImages1Click(Sender: TObject);
    procedure XMLToDatabase1Click(Sender: TObject);
    procedure ViewGrid1Click(Sender: TObject);
    procedure DatabaseToXMLfile1Click(Sender: TObject);
    procedure CreateUser1Click(Sender: TObject);
  private
    { Private declarations }
    fLockClientWindowUpdateCount: Integer;

  public
    { Public declarations }
    CurrentEditDate: TDateTime;

    Hostname,Database,Username,Password, Permission: string;
    MainConnection: TDBConnections;
    LoggedIn: boolean;
    openWinList: TList;
    Initialised: boolean;
    ButtonClicked: integer;
    InitialisedCount: integer;
    //NewRecArray: TRecArray;
    myRecArray: TRecArray;
    GridLayoutRecArray: TRecArray;
    DefaultValues: TstrArray;
    IsLoginOK: boolean;
    MyMessage: string;
    dlgMessage: string;
    MessageExpired: boolean;
    ExpiredTime: TDateTime;
    Expired: boolean;
    DEBUG_MODE: BOOLEAN;
    Messages: TstrArray;
    MessageSecs: TintArray;
    MessageCount: integer;
    MessageIndex: integer;
    MessagesExpired: TBoolArray;
    MessageQueueList: TList;
    EntryList: TStringList;
    DiaryEntryList: TList;
    conStr: widestring;
    UserID: integer;
    DBErrorMessage: string;
    SelectQuery: string;
    DailyFilter: string;
    SortField: string;
    IDField: string;

    procedure CreateMDIChild(const Child:integer; const Name: string; xpos,ypos,width,height:integer; Defaults:string='');
    procedure Initialise;
    procedure RecordWindowPositions;
    procedure CloseMDIChild(const Child:integer =0);
    procedure CloseAllChild();
    procedure SaveWinPositions;
    procedure LoadWinPositions;
    procedure CenterWindow(TheForm: TForm; AdjX,AdjY: integer);
    procedure CenterCurrentWindow;
    procedure SendAMessage(AMessage: string; Seconds:integer; TextBarNumber:integer=1);
    procedure CreateTheDatabase;
    procedure MaxFormSize(MyForm:TForm);
    procedure LockClientWindowUpdate;
    procedure UnlockClientWindowUpdate;
    procedure GetPermission;

    function GetChildNumber(FormName: string): integer;
    function ComputerName():String;
    function PopulateCombo(ComboName: TComboBox; DBTable: string; FieldPosition: integer; RecArray:TRecArray=nil; Filter:string=''; SortField:string=''; IsSingleField: boolean = false): TRecArray;overload;
    function PopulateCombo(ComboName: TComboBox; DBTable: string; FieldName: string; RecArray:TRecArray=nil; Filter:string=''; SortField:string=''; IsSingleField: boolean = false): TRecArray;overload;
    function CheckLogin:boolean;
    //function StrToStringArray(TheString, SubString: string): TstrArray;
    //function StringArrayToString(TheArray:TstrArray; SubString: string): string;
    function PopulateRecArray(DBTable:string; Filter:string; SortField:string; SQLcmd:string=''; SingleField :boolean = False): TRecArray;overload;
    function PopulateRecArray(DBTable:string; FieldName:string; Filter:string;   SortField:string; VAR FieldPos:integer; SQLcmd:string=''; SingleField:boolean = False): TRecArray;overload;
    function PopulateRecArrays(DBTables:string):integer;
    function TestMessageQueue:boolean;
    function PopulateMultiCombo(ComboName: TComboBox; DBTable,FieldNames,EditMasks: string; RecArray:TRecArray=nil; Filter:string=''; SortField:string=''): TRecArray;
    function TestEntry(var FormField:string; var GlobalVar:string; var Value:double):double;overload;
    function TestEntry(var FormField:string; var GlobalVar:string; var Value:integer):integer;overload;
    function PopulateList(ListName: TListbox; DBTable: string; FieldName: string; RecArray:TRecArray=nil; Filter:string=''; SortField:string=''): TRecArray;
    function GetComboIndex(comboName: TComboBox):integer;

  end;

type
  TopenWinRecord = record
    WinName: string;
    FormName: string;
    FormCaption: string;
    Form: TForm;
    ID: integer;
    xpos,ypos,width,height: integer;
    Centered: integer;
end;

type
  TMessageQueue = record
    MessageText: string;
    MessageSec: integer;
    MessageCount: integer;
    Index: integer;
    Expired: boolean;
    ExpiredTime: TDateTime;
    TextBarNumber: integer;
end;

type
  TDecodedDateDiff =  record
    Years: Word;
    Weeks: Byte;
    Days: Word;
    Hours: Byte;
    Minutes: Byte;
    Seconds: Byte;
    Milliseconds: Word;
end;

type
  TDiaryEntry = record
    EntryNumber: integer;
    TheDateTime: TDateTime;
    BriefEntry: String;
    DetailEntry: string;
    PrivateEntry: string;
  end;

var
  MainForm: TMainForm;
  MainDBName: string;

implementation

{$R *.dfm}

uses ViewGrid, DBOptions, about, LoginForm, Output,
  SaveDialog, EnterUserDetails,  EnterSchedules, DiaryView, DiaryEntry,
  CalendarPicker, xmlToDatabase, SelectDiaryEntry;

{
function TMainForm.StrToStringArray(TheString, SubString: string): TstrArray;
var
  IDX: integer;
  Elements: integer;
  CommaPos: integer;
  Extract:string;
  FStringArray: TstrArray;
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
  //end; while

  Result:= FStringArray;
end;

function TMainForm.StringArrayToString(TheArray:TstrArray; SubString: string): string;
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

}

function TMainForm.ComputerName():String;
var
  ComputerName: Array [0 .. 256] of char;
  Size: DWORD;
begin
  Size := 256;
  GetComputerName(ComputerName, Size);
  Result := ComputerName;
end;


function DateTimeToMilliseconds(aDateTime: TDateTime): Int64;
var
  TimeStamp: TTimeStamp;
begin

   {Call DateTimeToTimeStamp to convert DateTime to TimeStamp:}
  TimeStamp:= DateTimeToTimeStamp (aDateTime);
   {Multiply and add to complete the conversion:}
  Result:= Int64 (TimeStamp.Date) * MSecsPerDay + TimeStamp.Time;
end;

{Uses DateTimeToTimeStamp, TimeStampToMilliseconds, and DateTimeToMilliseconds. }
function MillisecondsBetween (const anow, athen: TDateTime): Int64;
begin
   if anow >  athen then
    Result:= DateTimeToMilliseconds(anow) - DateTimeToMilliseconds(athen)
   else
    Result:= DateTimeToMilliseconds(athen) - DateTimeToMilliseconds(anow);
end;

function DecodeDateDiff (aStartDateTime, aFinishDateTime: TDateTime): TDecodedDateDiff;
var
  Milliseconds: Int64;
  WholeStartDate, WholeEndDate: TDateTime;
  Days: Cardinal;
  Years: Word;
begin
   {Validating dates, which must be passed to function correctly, ie
  the end date must be greater than or equal to end date. Any other case is
  invalid and throws an exception}
   if aStartDateTime > aFinishDateTime  then
    Raise Exception.Create('The end date is less than the starting date');

   {Zeroing variables that will be used throughout the function}
  ZeroMemory (@ Result, SizeOf (TDecodedDateDiff));
  Years:= 0;

   {Getting the right amount of milliseconds between dates. The function
  MilliSecondsBetween that should be changed to return the exact amount
  of milliseconds and not those existing in DateUtils}
  Milliseconds:= MilliSecondsBetween (aStartDateTime, aFinishDateTime);

   {From the exact amount of milliseconds, we can get the amount
  exact day, since we know exactly how many milliseconds in a will
  days}
  Days:= MSecsPerDay  div milliseconds;

   {Here we are normalizing the dates, so that the initial start date
  exactly at the beginning of the year following her, and the final end date
  exactly at the end of last year it}
  WholeStartDate:= IncMilliSecond(EndOfTheYear(aStartDateTime));
  WholeEndDate:= IncMilliSecond(StartOfTheYear(aFinishDateTime), -1);

   {The following loop will perform two actions: Decrease the amount of days
  previously obtained the number of days in the year being verified at the time
  Years and increment the variable in order to obtain the number of years. }
   while WholeStartDate <WholeEndDate do
   begin
    Dec (Days, DaysInYear (WholeStartDate));

    Inc (Years);

    WholeStartDate:= IncDay (WholeStartDate, DaysInYear (WholeStartDate));
   end;

   {If the number of days is greater than or equal to the number of days in year
  Finally, we need to make an adjustment last year and to increase
  decrease days according to the number of days in the year end date}
   if DaysInYear(aFinishDateTime) >= Days  then begin
    Inc (Years);
    Dec (Days, DaysInYear(aFinishDateTime));
   end;

   {At this point, the variable Years contains the amount of full years between
  original end date ... }

  Result.Years:= Years;

   {... And the Days variable contains the number of days left over. We obtain
  therefore the amount of weeks, which is an exact value}

  Result.Weeks := Days  div 7;
  Result.Days := Days  mod 7;

   {From here the verification is simple math, drawing hours, minutes
  of milliseconds, seconds}
  Milliseconds := milliseconds  mod MSecsPerDay;

  Result.Hours := Milliseconds  div (SecsPerHour * MSecsPerSec);
  Milliseconds := milliseconds  mod (SecsPerHour * MSecsPerSec);

  Result.Minutes := Milliseconds  div (SecsPerMin * MSecsPerSec);
  Milliseconds := milliseconds  mod (SecsPerMin * MSecsPerSec);

  Result.Seconds := MSecsPerSec  div milliseconds;
  Milliseconds := milliseconds  mod MSecsPerSec;

   {What is left at the end, you just milliseconds! }
  Result.Milliseconds := milliseconds;
end;

procedure TMainForm.RecordWindowPositions;
var
  rec: ^TopenWinRecord;
  idx: integer;
begin
  //Record all OPEN CHILD Windows.
  idx:=0;
  self.openWinList.Clear; //re-build whole list
  while idx< MDIChildCount do begin
    new(rec);
    rec^.WinName:= MDIChildren[idx].Name;
    rec^.FormName:= MDIChildren[idx].Name;
    rec^.FormCaption:= MDIChildren[idx].Caption;
    rec^.Form:= MDIChildren[idx];
    rec^.ID:= idx;
    rec^.xpos:= MDIChildren[idx].Left;
    rec^.ypos:= MDIChildren[idx].Top;
    rec^.width:= MDIChildren[idx].Width;
    rec^.height:= MDIChildren[idx].Height;
    rec^.Centered:= MDIChildren[idx].Tag; //0= not centered, 1= centered
    self.openWinList.Add(rec);
    idx:= idx+1;
  end;
end;

function TMainForm.GetChildNumber(FormName: string): integer;
var
  ChildNumber: integer;
begin
  ChildNumber:= 0;

  Result:= ChildNumber;
end;

procedure TMainForm.CreateTheDatabase;
var
  mySqlConnection: TDBconnections;
  strCon: widestring;
begin
  SendAMessage('Creating Database',2);
  mySqlConnection:= TDBConnections.Create;
    try
      strCon:= MainForm.MainConnection.ConnString; //very important!
      mySqlConnection.Password:= MainForm.MainConnection.Password;
      mySqlConnection.Server:= MainForm.MainConnection.Server;
      mySqlConnection.DBName:= 'mysql';
      MainDBName:= MainForm.MainConnection.DBName;
      mySqlConnection.UID:= MainForm.MainConnection.UID;
      mySqlConnection.Port:= MainForm.MainConnection.Port;
      mySqlConnection.ConnString:= strCon;
      mySqlConnection.DBOperations.connString:= strCon; //very important as cannot call parent class internally
      mySqlConnection.DBOperations.MySQL_CreateDatabase(strCon,MainDBName,true);
      //self.CreateTables;
      ShowMessage('sql command= '+mySqlConnection.DBOperations.queryMessage);
      if Length(mySQlConnection.DBMessage)>0 then
        ShowMessage('DB Message: '+mySQLConnection.DBMessage);
      if Length(mySQLConnection.DBErrors)>0 then
        ShowMessage('DB Error: '+mySQLConnection.DBErrors+', '+mySQLConnection.DBOperations.errorMessage);
    finally
      //mySqlConnection.Destroy;
      FreeAndNil(mySqlConnection);
    end;
end;

procedure TMainForm.CreateUser1Click(Sender: TObject);
begin
  //Create New user - Enter profile details and assign permissions.
  //CREATE USER 'newuser'@'localhost' IDENTIFIED BY 'password';
  //GRANT ALL PRIVILEGES ON * . * TO 'newuser'@'localhost';
  //The asterisks in this command refer to the database and table (respectively) that they can access—this specific command allows to the user to read, edit, execute and perform all tasks across all the databases and tables.
  //Once you have finalized the permissions that you want to set up for your new users, always be sure to reload all the privileges.
  //FLUSH PRIVILEGES;
  //Your changes will now be in effect.
  if IsLoginOK then
    CreateMDIChild(9,'Personal Detail Entry',1,1,900,700);
end;

procedure TMainForm.CreateDatabase1Click(Sender: TObject);
var
  mySqlConnection: TDBConnections;
  strCon: widestring;
begin
  //if MainForm.CheckLogin then begin
  CreateTheDatabase;
  //end;
end;

procedure TMainForm.MaxFormSize(MyForm:TForm);
var
  FormName: string;
begin
  FormName:= MyForm.Name;
  if MyForm.Width > screen.DesktopWidth then
    MyForm.Width := screen.DesktopWidth;

  if MyForm.Height > screen.DesktopHeight then
    MyForm.Height := screen.DesktopHeight;

  if (MyForm.Left + MyForm.Width) > screen.DesktopWidth then
    MyForm.Left := screen.DesktopWidth - MyForm.Width;
  if MyForm.Left < 0 then MyForm.Left := 0;

  if (MyForm.Top + MyForm.Height) > screen.DesktopHeight then
    MyForm.Top := screen.DesktopHeight - MyForm.Height;
  if MyForm.Top < 0 then MyForm.Top := 0;
end;

procedure TMainForm.CreateMDIChild(const Child:integer; const Name: string;
  xpos,ypos,width,height:integer; Defaults:string='');
var
  Child1: TfrmDBView;
  Child2: TfrmDBOptions;
  Child3: TfrmOutput;
  Child4: TfrmLogin;
  //Child5: TfrmDrawGridViewer;
  Child6: TfrmSaveDialog;
  //Child7: TfrmCharts;
  //Child8: TfrmGridColorPicker;
  Child9: TfrmUserDetails;
  Child10: TfrmEnterSchedules;
  //Child11: TfrmViewScreenShots;
  //Child12: TfrmDBGridView;
  Child13: TfrmDiaryEntry;
  Child14: TfrmCalendarPicker;
  Child15: TfrmXmlToDatabase;
  Child16: TfrmSelectDiaryEntry;
  Child17: TfrmDiaryView;

  AControl: TControl;
  idx:integer;
  ChildControlIDX: integer;
  FieldIdx: integer;
  ControlName: string;
  AdjustY: integer;
  AdjustX: integer;
  EnergyType: string;
  CurDay,CurMonth,CurYear:word;
  NewDate: TDateTime;
  //DefaultValues: TstrArray;
  MaxValues: integer;
  dtTodaysDate: TDateTime;
  txtTodaysDate: string;
  Title: string;
  Tables: TStrings;
  MyStrings: TUsefulRoutines;
  dateFieldname: string;
  recArray: TRecArray;
  //rec: ^TopenWinRecord;
begin
  { create a new MDI child window }
  //new(rec); not done here as special procedure takes care of all open windows.
  SetLength(DefaultValues,0);
  if Length(Defaults)>0 then
    DefaultValues:= MainForm.MainConnection.DBOperations.StrToStringArray(Defaults,',');
  MaxValues:= High(DefaultValues);
  AdjustY:= -50;
  AdjustX:= -10;
  Title:= Name+IntToStr(MainForm.MDIChildCount+1);
  MyStrings:= TUsefulRoutines.Create;
  try
    if Child=1 then begin
      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try
      Child1 := TfrmDBView.Create(Application);
      Child1.FormStyle:= fsMDIChild;
      Child1.Caption := Title;
      Child1.Tag:= 0;
      Child1.Width:= width;
      Child1.Height:= height;
      if (xpos = 1) AND (ypos=1) then begin
        CenterWindow(Child1,AdjustX,AdjustY);
        Child1.Tag:= 1;
      end
      else begin
        Child1.Top:= ypos;
        Child1.Left:= xpos;
      end;
      Tables:= TStringList.Create;
      try
        MainForm.MainConnection.ADOConnection.GetTableNames(Tables,False);
        idx:= StrToInt(Defaults);
        Child1.ViewQuery:= 'SELECT * FROM '+Tables[idx];
      finally
        FreeAndNil(Tables);
      end;
      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;
    end;
    if Child=2 then begin
      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try
      Child2 := TfrmDBOptions.Create(Application);
      Child2.FormStyle:= fsMDIChild;
      Child2.Caption := Title;
      Child2.Tag:= 0;
      Child2.Width:= width;
      Child2.Height:= height;
      if (xpos = 1) AND (ypos=1) then begin
        CenterWindow(Child2,AdjustX,AdjustY);
        Child2.Tag:= 1;
      end
      else begin
        Child2.Top:= ypos;
        Child2.Left:= xpos;
      end;
      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;

    end;
    if Child=3 then begin
      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try
      SendAMessage(Name,5);
      Child3:= TfrmOutput.Create(Application);
      Child3.FormStyle:= fsMDIChild;
      Child3.Caption:= Title;
      Child3.Tag:= 0;
      Child3.Width:= width;
      Child3.Height:= height;
      if (xpos = 1) AND (ypos=1) then begin
        CenterWindow(Child3,AdjustX,AdjustY);
        Child3.Tag:= 1;
      end
      else begin
        Child3.Top:= ypos;
        Child3.Left:= xpos;
      end;
      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;
    end;
    if Child=4 then begin
      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try
      Child4 := TfrmLogin.Create(Application);
      Child4.FormStyle:= fsMDIChild;
      Child4.Caption := Title;
      Child4.Tag:= 0;
      Child4.Width:= width;
      Child4.Height:= height;
      if (xpos = 1) AND (ypos=1) then begin
        CenterWindow(Child4,AdjustX,AdjustY);
        //ShowMessage('Child4 Xpos='+IntToStr(Child4.Left)+', Ypos='+IntToStr(Child4.Top)+', width='+IntToStr(Child4.Width)+', height='+IntToStr(Child4.Height));
        Child4.Tag:= 1;
      end
      else begin
        Child4.Top:= ypos;
        Child4.Left:= xpos;
      end;

      Child4.txtPassword.SetFocus;
      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;
    end;

    if Child=5 then begin
      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try
      self.SendAMessage(Title,5);
      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;
    end;

    if Child=6 then begin
      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try
      Child6:= TfrmSaveDialog.Create(Application);
      Child6.FormStyle:= fsNormal;
      Child6.Hide;
      Child6.Caption:= Title;
      Child6.Tag:= 0;
      Child6.Width:= width;
      Child6.Height:= height;
      ButtonClicked:= 0;
      if (xpos = 1) AND (ypos=1) then begin
        CenterWindow(Child6,AdjustX,AdjustY);
        Child6.Tag:= 1;
      end
      else begin
        Child6.Top:= ypos;
        Child6.Left:= xpos;
      end;
      //if Child11.ShowModal = mrYes then begin
      //  MainForm.ButtonClicked:= mrYes;
      //end
      //else
        if Length(self.dlgMessage)>0 then
          Child6.txtMessage1.Text:= self.dlgMessage
        else
          Child6.txtMessage1.Text:= 'Record Already Exists';
        Child6.ShowModal;
      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;

    end; //if Child=6
    if Child=7 then begin
      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try
        //Child7 := TfrmCharts.Create(Application);
        //Child7.FormStyle:= fsMDIChild;
        //Child7.WindowState:= wsMaximized;
        //Child7.Caption := Title;
        //Child7.Tag:= 0;
        //Child7.Width:= width;
        //Child7.Height:= height;
      if (xpos = 1) AND (ypos=1) then begin
        //CenterWindow(Child7,AdjustX,AdjustY);
        //Child7.Tag:= 1;
      end
      else begin
        //Child7.Top:= ypos;
        //Child7.Left:= xpos;
      end;

      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;

    end; //if Child=13
    if Child=8 then begin
      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try

      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;
    end; //if Child=8

    if Child=9 then begin
      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try
        Child9 := TfrmUserDetails.Create(Application);
        Child9.FormStyle:= fsMDIChild;
        //Child9.WindowState:= wsMaximized;
        Child9.Caption := Title;
        Child9.Tag:= 0;
        Child9.Width:= width;
        Child9.Height:= height;
        if (xpos = 1) AND (ypos=1) then begin
          CenterWindow(Child9,AdjustX,AdjustY);
          Child9.Tag:= 1;
        end
        else begin
          Child9.Top:= ypos;
          Child9.Left:= xpos;
        end;
        Child9.DBTable:= 'diaryusers';
        Child9.txtUserID.SetFocus;
      //SessionsRecArray:= MainForm.PopulateRecArray('x2_GameSessions','SessionName != ""','SessionName');
      //PopulateCombo(Child9.comPlayers,'x2_PlayerDetails','PlayerNickname',PlayersRecArray,'PlayerNickname != ""','PlayerNickname');
      //getting an E_FAIL error here: - because of blank entries for required fields
      Child9.LoadPermissions;
      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;
    end; //if Child=9
    if Child=10 then begin
      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try
      Child10 := TfrmEnterSchedules.Create(Application);
      Child10.FormStyle:= fsMDIChild;
      //Child14.WindowState:= wsMaximized;
      Child10.Caption := Title;
      Child10.Tag:= 0;
      Child10.Width:= width;
      Child10.Height:= height;
      if (xpos = 1) AND (ypos=1) then begin
        CenterWindow(Child10,AdjustX,AdjustY);
        Child10.Tag:= 1;
      end
      else begin
        Child10.Top:= ypos;
        Child10.Left:= xpos;
      end;
      Child10.DBTable:= 'diaryusers';
      dtTodaysDate:= now();
      txtTodaysDate:= DateTimeToStr(dtTodaysDate);
      //Child10.txtDateAdded.Text:= txtTodaysDate;

      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;
    end; //if Child=10
    //TfrmEnterSessions
    if Child=11 then begin
      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try

      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;
    end; //if Child=11
    if Child=12 then begin
      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try
      //Child12.DrawStars;
      //Child12.txtGateID.SetFocus;

      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;
    end; //if Child=12
    if Child=13 then begin
      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try
      Child13 := TfrmDiaryEntry.Create(Application);
      Child13.EntrySaved:= FALSE;
      Child13.FormStyle:= fsMDIChild;
      Child13.Caption := Title;
      Child13.Tag:= 0;
      Child13.Width:= width;
      Child13.Height:= height;
      if (xpos = 1) AND (ypos=1) then begin
        CenterWindow(Child13,AdjustX,AdjustY);
        Child13.Tag:= 1;
      end
      else begin
        Child13.Top:= ypos;
        Child13.Left:= xpos;
      end;
      Child13.DBTable:= 'dailydiary';

      Child13.strDateInserted:= ''; //Get the inserted date. - read from table.
      Child13.txtBrief.SetFocus;
      if MaxValues>0 then begin
        Child13.txtRecNumber.Text:= DefaultValues[0];
        //Child13.txtDayOfWeek.Text:= FormatDateTime('ddd',MainForm.CurrentEditDate);
        //Child13.txtDate.Text:= FormatDateTime('dd mmmm yyyy',MainForm.CurrentEditDate);
        Child13.txtDayOfWeek.Text:= DefaultValues[1];
        Child13.txtDate.Text:= DefaultValues[2];
        Child13.txtTime.Text:= DefaultValues[3];
        Child13.txtBrief.Text:= DefaultValues[4];
        Child13.memDetail.Text:= DefaultValues[5];
        Child13.memPrivate.Text:= DefaultValues[6];
      end
      else begin
        Child13.txtDayOfWeek.Text:= FormatDateTime('ddd',MainForm.CurrentEditDate);
        Child13.txtDate.Text:= FormatDateTime('dd mmmm yyyy',MainForm.CurrentEditDate);
        Child13.txtTime.Text:= FormatDateTime('hh:mm:ss',MainForm.CurrentEditDate);
      end;
      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;
    end; //if Child=13
    if Child=14 then begin
      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try
      Child14 := TfrmCalendarPicker.Create(Application);
      Child14.FormStyle:= fsMDIChild;
      Child14.Caption := Title;
      Child14.Tag:= 0;
      Child14.Width:= width;
      Child14.Height:= height;
      if (xpos = 1) AND (ypos=1) then begin
        CenterWindow(Child14,AdjustX,AdjustY);
        Child14.Tag:= 1;
      end
      else begin
        Child14.Top:= ypos;
        Child14.Left:= xpos;
      end;
      //Child14.DBTable:= 'x2_Gates';
      //Child14.IsInitialised:= False;
      //Child14.Initialise;
      //Child14.PlotTiles2;

      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;
    end; //if Child=14
    if Child=15 then begin
      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try
      Child15 := TfrmXmlToDatabase.Create(Application);
      Child15.FormStyle:= fsMDIChild;
      Child15.Caption := Title;
      Child15.Tag:= 0;
      Child15.Width:= width;
      Child15.Height:= height;
      if (xpos = 1) AND (ypos=1) then begin
        CenterWindow(Child15,AdjustX,AdjustY);
        Child15.Tag:= 1;
      end
      else begin
        Child15.Top:= ypos;
        Child15.Left:= xpos;
      end;
      //Child15.DBTable:= 'x2_PlayerDetails';
      //Child15.LoadPlayersIntoCombo;

      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;
    end; //if Child=15
    //TfrmSessionLog
    if Child=16 then begin
      //Could generate a unique GUID here and attach to the tag property ?
      //This would make a known unique reference for this form.
      //Thus allowing multiple instances of this form open -
      //having ability to have more than once instance of this application
      //open at the same time under the same operating system ???
      //A call to the Destroy method from the close event should be included.
      //Currently the Application.ChildMDI() collection only holds the NAME of the form
      //that is open - it cannot specify WHICH INSTANCE of that form is
      //open if multiple forms of this type are already open.

      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try
        constr:= self.MainConnection.ConnString;
        Child16 := TfrmSelectDiaryEntry.Create(Application);
        Child16.FormStyle:= fsMDIChild;
        //Child16.FormStyle:= fsNormal;
        Child16.Caption := Title;
        Child16.Tag:= 0;
        Child16.Width:= width;
        Child16.Height:= height;
        if (xpos = 1) AND (ypos=1) then begin
          CenterWindow(Child16,AdjustX,AdjustY);
          Child16.Tag:= 1;
        end
        else begin
          Child16.Top:= ypos;
          Child16.Left:= xpos;
        end;
        Child16.DBTable:= 'dailydiary';
        Child16.Titles:= '#,Date+Time,brief,private';
        Child16.CreateQuery:= TRUE;
        child16.BorderStyle:= bsDialog;
        dateFieldname:= 'dailydate';
        IDField:= self.MainConnection.DBOperations.GetFieldnamesOfTypesPassed(Child16.DBTable,'ftAutoInc',constr);
        if Length(dailyfilter) = 0 then begin
          dailyfilter:= 'userID = '+IntToStr(self.UserID)+' AND DATE('+dateFieldname+') = '+chr(39)+self.MainConnection.DBOperations.DateForSQL(self.CurrentEditDate)+chr(39);
          Child16.Display('SELECT * FROM '+Child16.DBTable+' WHERE '+dailyfilter+' ORDER BY dailydate DESC');
        end
        else begin
          dailyfilter:= dailyfilter+' AND userID = '+IntToStr(self.UserID);
          if Length(self.SortField)>0 then
            SelectQuery:= 'SELECT * FROM '+Child16.DBTable+' WHERE '+dailyfilter+' ORDER BY '+SortField
          else
            SelectQuery:= 'SELECT * FROM '+Child16.DBTable+' WHERE '+dailyfilter+' ORDER BY '+IDField;
          Child16.Display(SelectQuery);
        end;
      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;
    end; //if Child=16
    if Child=17 then begin
      Screen.Cursor := crHourGlass;
      LockClientWindowUpdate;
      try
        constr:= self.MainConnection.ConnString;
        Child17:= TfrmDiaryView.Create(Application);
        Child17.FormStyle:= fsMDIChild;
        Child17.Caption := Title;
        Child17.Tag:= 0;
        Child17.Width:= width;
        Child17.Height:= height;
        if (xpos = 1) AND (ypos=1) then begin
          CenterWindow(Child17,AdjustX,AdjustY);
          Child17.Tag:= 1;
        end
        else begin
          Child17.Top:= ypos;
          Child17.Left:= xpos;
        end;
        Child17.DBTable:= 'dailydiary';
        Child17.Titles:= '#,Date+Time,brief,private';
        Child17.CreateQuery:= TRUE;
        Child17.BorderStyle:= bsDialog;
        dateFieldname:= 'dailydate';
        IDField:= self.MainConnection.DBOperations.GetFieldnamesOfTypesPassed(Child17.DBTable,'ftAutoInc',constr);

        Child17.SearchField:= 'dailyentry';
        self.CurrentEditDate:= now();
        Child17.PopulateSearchCombo;
        Child17.PopulateGrid();
        //Child17.Display2;
        Child17.txtSearch.SetFocus;
        Child17.Timer1.Enabled:= True;
        //Call procedure to create the scrollbox ?
      finally
        Screen.Cursor := crDefault;
        UnlockClientWindowUpdate;
      end;
    end;
  finally
    FreeAndNil(MyStrings);
  end;
end;

function TMainForm.GetComboIndex(comboName: TComboBox):integer;
var
  idx: integer;
begin
  idx:=0;
  while idx< comboName.Items.Count do begin
    if AnsiPos(Uppercase(comboName.Text),uppercase(comboName.Items[idx]))>0 then begin
      if Length(comboName.Text) = Length(comboName.Items[idx]) then begin
        Result:= idx;
        exit;
      end;
    end;

    idx:= idx+1;
  end;
end;

procedure TMainForm.GetPermission;
var
  mySqlConnection: TDBConnections;
  strCon: widestring;
  Permissions: string;
  qryPermission: string;
  userTable: string;
  Reversed: boolean;
  ThisSortField: string;
  qryFilter: string;
begin
  userTable:= 'diaryusers';
  if MainForm.CheckLogin then begin
    try
      mySqlConnection:= TDBConnections.Create;
      ThisSortField:= 'Permission';
      Reversed:= FALSE;
      SendAMessage('Getting Permission...',2);
      mySqlConnection:= TDBConnections.Create;
      mySqlConnection.Password:= MainForm.MainConnection.Password;
      mySqlConnection.Server:= MainForm.MainConnection.Server;
      mySqlConnection.DBName:= MainForm.MainConnection.DBName;
      mySqlConnection.UID:= MainForm.MainConnection.UID;
      mySqlConnection.Port:= MainForm.MainConnection.Port;
      strCon:= MainForm.MainConnection.ConnString;
      mySqlConnection.DBOperations.connString:= strCon;
      qryPermission:= 'SELECT * FROM '+userTable;
      qryFilter:= ' userid = '+InttoStr(UserID);
      mySqlConnection.DBOperations.CreateQuery(strCon,'SELECT',qryPermission,sortfield,Reversed,qryFilter);
      mySqlConnection.DBOperations.CreateSingleRecArray(mySqlConnection.DBOperations.ADOQuery,True);
      Permission:= mySqlconnection.DBOperations.GetSingleRecArray(userTable,strCon,'Permission');
      //ShowMessage('Permissions='+Permission);

    finally
      //mySqlConnection.Destroy;
      FreeAndNil(mySqlConnection);
    end;
  end;
end;

procedure TMainForm.ViewGoodsDetails1Click(Sender: TObject);
begin
  //View and Edit Goods Details:

end;

procedure TMainForm.ViewGrid1Click(Sender: TObject);
begin
  CreateMDIChild(12,'VIEW Database Table Details',1,1,640,480);
end;

procedure TMainForm.ViewImages1Click(Sender: TObject);
begin
  CreateMDIChild(11,'VIEW IMAGES',1,1,640,480);
end;

procedure TMainForm.FileNew1Execute(Sender: TObject);
begin
  CreateMDIChild(1,'View Grid ',1,1,640,480,'1');
end;

procedure TMainForm.FileOpen1Execute(Sender: TObject);
begin
  if OpenDialog.Execute then
    CreateMDIChild(1,OpenDialog.FileName,1,1,640,480);
end;

procedure TMainForm.HelpAbout1Execute(Sender: TObject);
begin
  AboutBox.ShowModal;
end;

procedure TMainForm.Initialise;
var
  idx: integer;
  //rec: ^TopenWinRecord;
begin
  //OK after debugging - frmLogin.FormShow seems to be called many times as there are actual forms being created by
  //the project / program procedure.
  //- under Project options - ALL the forms were Auto-created ! - now we change this to just two -
  //The main form and the about box - But there seems to be duplicates of all the forms ???
  InitialisedCount:= 1;
  SendAMessage('INITIALISED COUNT ='+IntToStr(InitialisedCount),5,2);
  DEBUG_MODE:= False;
  pnlMain.Width:= self.Width;
  self.WindowState:= wsMaximized;
  IsLoginOK:= FALSE;
  MessageExpired:= False;
  if NOT Initialised then begin
    self.CurrentEditDate:= Now();
    MessageTimer.Interval:= 900;
    //SetLength(MessagesExpired,Length(MessagesExpired)+1);
    //SetLength(Messages,Length(Messages)+1);
    //SetLength(MessageSecs,Length(MessageSecs)+1);
    MessageCount:= 0;
    MessageIndex:= 0;
    //MainForm.WindowState:= wsMaximized;
    if DEBUG_MODE then
      MessageTimer.Enabled:= False
    else
      MessageTimer.Enabled:= True;
    SendAMessage('INITIALISING ... PLEASE WAIT',5);
    self.CloseAllChild;



    //if MainForm.CheckLogin then begin //This is executed EVERY time user clicks on MAIN form !
    //  MainForm.UsersRecArray:= PopulateRecArray('diaryusers');
    //end;

    //FINISHED. Between these is experimental and may not be a good idea on multi-user access apps.
    self.WindowState:= wsMaximized;
    MainForm.Initialised:= TRUE;
    SendAMessage('OK INITIALISED',5);
  end;
  if MainForm.CheckLogin then begin //This is executed EVERY time user clicks on MAIN form !
    //LOAD ALL DROPDOWN DATA INTO MEMORY:
    //setup all the dropdown lists - put into memory now
    //PopulateRecArray(DBTable) - if this format used - Field Position defaults to 1 - to get second field in table !
    IsLoginOK:= TRUE;
    MainDBName:= MainConnection.DBName;
    self.GetPermission;
    if Uppercase(self.Permission) = 'SUPERUSER' then begin
      self.DetailEntry1.Enabled:= TRUE;
      self.Schedules1.Enabled:= TRUE;
      self.Reports1.Enabled:= TRUE;

    end;
    PopulateRecArrays('ALL');
    if IsLoginOK then
      CreateMDIChild(17,'VIEW DIARY AND EDIT ENTRIES',1,20,1024,640);
  end
  else begin
    //ShowMessage('Not logged in');
    IsLoginOK:= FALSE;
    if Assigned(MainForm.MainConnection) then begin
      MainForm.MainConnection.Destroy;
      MainForm.MainConnection:= nil;
    end;
  end;


end;

function TMainForm.PopulateRecArrays(DBTables:string):integer;
var
  TablesArray: TstrArray;
  idx: integer;
begin
  idx:=1;
  SetLength(TablesArray,0); //clear array
  TablesArray:= MainForm.MainConnection.DBOperations.StrToStringArray(DBTables,',');
  if Uppercase(DBTables) = 'ALL' then begin
    if NOT Assigned(myRecArray) then
      myRecArray:= MainForm.PopulateRecArray('diaryusers','Nickname != ""','Nickname');
  end
  else begin
    idx:=0;
    while idx< Length(TablesArray) do begin
      if Uppercase(TablesArray[idx]) = 'diaryusers' then
        myRecArray:= MainForm.PopulateRecArray('diaryusers','Nickname != ""','Nickname');
      idx:= idx+1;
    end; //while

  end; //else
  Result:= idx;
end;

procedure TMainForm.DiaryEntry1Click(Sender: TObject);
begin
  //Enter Diary Details:
  if IsLoginOK then
    CreateMDIChild(3,'Create Diary Entry',1,1,700,500);
end;

procedure TMainForm.PersonalDetails1Click(Sender: TObject);
begin
  if IsLoginOK then
    CreateMDIChild(9,'Personal Detail Entry',1,1,900,700);
end;

procedure TMainForm.ViewFactoryDetails2Click(Sender: TObject);
begin
  if IsLoginOK then
    CreateMDIChild(5,'VIEW AND EDIT FACTORY DETAILS',1,1,900,700);
end;

procedure TMainForm.FileExit1Execute(Sender: TObject);
begin
  //close application
  Close;
end;

procedure TMainForm.Database1Click(Sender: TObject);
begin
  CreateMDIChild(2,'Database Config ',1,1,900,700);
end;

procedure TMainForm.DatabaseToXMLfile1Click(Sender: TObject);
begin
  //Database output to XML file - maybe one whole month at a time ?

end;

procedure TMainForm.Close1Click(Sender: TObject);
begin
  //close current child window.
  CloseMDIChild(0);
  self.RecordWindowPositions;
end;

procedure TMainForm.CloseMDIChild(const Child: integer=0);
begin
    MDIChildren[Child].Close;
    self.RecordWindowPositions;
end;

procedure TMainForm.CloseAllChild;
var
  idx: integer;
begin
  for idx:= 0 to MDIChildCount-1 do
    MDIChildren[idx].Close;
end;

procedure TMainForm.CloseAll1Click(Sender: TObject);
begin
  MainForm.CloseAllChild;
end;

procedure TMainForm.EnterSessions1Click(Sender: TObject);
begin
  //enter session details
  //MainForm.Initialise;
  if IsLoginOK then
    CreateMDIChild(11,'Enter Session Details',1,1,700,600);
end;

procedure TMainForm.DiaryDetails1Click(Sender: TObject);
begin
  //View and Edit Sector Details:
  MainForm.Initialise;
  if IsLoginOK then
    CreateMDIChild(17,'VIEW DIARY AND EDIT ENTRIES',1,20,1024,640);
end;

procedure TMainForm.ViewSessionLog1Click(Sender: TObject);
begin
  //View Edit Session Log
  MainForm.Initialise;
  if IsLoginOK then
    CreateMDIChild(5,'VIEW AND EDIT SESSION LOG',1,1,800,640);
end;

procedure TMainForm.ToolButton12Click(Sender: TObject);
begin
  //Center Current Window:
  //Need to cycle through OpenWindowList and get index of current window.
  ActiveMDIChild.Tag:= 1;
  self.RecordWindowPositions;
end;

procedure TMainForm.ToolButton13Click(Sender: TObject);
begin
  //Un-Center Window, cycle through open windows and set center attribute to false.
  ActiveMDIChild.Tag:= 0;
  self.RecordWindowPositions;
end;

procedure TMainForm.ViewTotalCredits1Click(Sender: TObject);
begin
  //View Total Credits Earnt

  MainForm.Initialise;
  if IsLoginOK then
    self.CreateMDIChild(5,'View and Edit SESSION LOG',1,1,840,480);
end;

procedure TMainForm.XMLToDatabase1Click(Sender: TObject);
begin
  //if IsLoginOK then
    self.CreateMDIChild(15,'XML FILE to Database',1,1,840,680);
end;

procedure TMainForm.ViewAllWindowsStored1Click(Sender: TObject);
var
  idx: integer;
  rec: ^TopenWinRecord;
  centered: integer;
  FormName: string;
  WinName: string;
  FormCaption: string;
  WinID: integer;
  xpos,ypos,winWidth,winHeight: integer;
  AMessage: string;
begin
  //Output all views stored in Window Open List:
  //This causes a violation error as the form cannot be referred to like this,
  //needs to be done in CreateMDIChild
  self.RecordWindowPositions;
  AMessage:= '';
  for idx := self.openWinList.Count-1 downto 0 do begin
      rec:= self.openWinList[idx];
      centered:= rec^.Centered;
      FormName:= rec^.FormName;
      WinName:= rec^.WinName;
      FormCaption:= rec^.FormCaption;
      WinID:= rec^.ID;
      xpos:= rec^.xpos;
      ypos:= rec^.ypos;
      winWidth:= rec^.width;
      winHeight:= rec^.height;
      AMessage:= AMessage+' ,FormName:'+FormName;
      AMessage:= AMEssage+' ,Win ID:'+IntToStr(WinID);
      AMessage:= AMessage+' ,XPOS:'+IntToStr(XPos)+', YPos:'+IntToStr(ypos);
      AMessage:= AMessage+' ,Width:'+IntToStr(winWidth)+', Height:'+IntToStr(winHeight);
      AMessage:= AMessage+' ,Centered:'+IntToStr(Centered);

  end;
  self.CreateMDIChild(5,'Window Stats in Open Window List',1,1,540,480);
end;

procedure TMainForm.FormActivate(Sender: TObject);
begin
  MainForm.Initialise; //hmmmmm does this need to be called here ?
  //initialise actually detects if Superuser has logged in -
  //if they have - all menus should be available -
  // Only runs when selecting an item from the menu .
  // This event does get called everytime user clicks main form...
  //;
  //beep;
  //self.SendAMessage('INITIALISE ....',2);
end;

procedure TMainForm.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  //MainForm.CloseMDIChild(0);
  Application.Terminate;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  //Initialise global stuff
  LoggedIn:= FALSE;
  IsLoginOK:= FALSE;
  openWinList:= TList.Create;
  MessageQueueList:= TList.Create;
  InitialisedCount:= 0;
  WindowState:= wsMaximized;
  //MainForm.Initialise; //gets error - no MDI forms created
end;

procedure TMainForm.CenterCurrentWindow;
begin
  //Center current window:

end;

procedure TMainForm.CenterWindow(TheForm: TForm; AdjX,AdjY: integer);
var
  TopValue: integer;
  LeftValue: integer;
  CenterX: integer;
  CenterY: integer;
  AMessage: string;
begin
  //Center window:
  CenterX:= (MainForm.ClientWidth-TheForm.Width) div 2;
  CenterY:= (MainForm.ClientHeight-TheForm.Height) div 2;
  if CenterX+AdjX>0 then
    LeftValue:= CenterX+AdjX
  else
    LeftValue:= CenterX;
  if CenterY+AdjY>0 then
    TopValue:= CenterY+AdjY
  else
    TopValue:= CenterY;
  TheForm.Top:= TopValue;
  TheForm.Left:= LeftValue;
  AMessage:= 'Left VAlue:'+IntToStr(LeftVAlue)+' ,'+'Top VAlue:'+IntToStr(TopVAlue);
  //txtStatusBar.Text:= AMessage
end;

procedure TMainForm.ChangeGridColours1Click(Sender: TObject);
begin
  //Call form to allow user to change grid colours:
  if IsLoginOK then
    CreateMDIChild(8,'Edit Grid Colours',1,1,800,640);
end;

procedure TMainForm.Charts1Click(Sender: TObject);
begin
  //Show charts form:
  if IsLoginOK then
    CreateMDIChild(7,'VIEW CHARTS',1,1,800,640);

end;

function TMainForm.CheckLogin:boolean;
begin
  //record which event was activated before this function was called ???
  //Then fire that event after login ???
  //MainForm.txtStatusBar.Text:= 'Establish Connection to Database ...';
  self.SendAMessage('Establish Connection to Database ...',5);
  if Not Assigned(MainForm.MainConnection) then
    self.CreateMDIChild(4,'Please LOGIN to myDiary Database',1,1,540,480)
  else
    if MainForm.MainConnection.TestConnection(MainForm.MainConnection.ConnString,FALSE) then begin
      LoggedIN:= True;
    end
    else begin
      ShowMessage('Login Problem');
      //Application.Terminate;
      self.CreateMDIChild(4,'Please LOGIN to myDiary Database',1,1,540,480);
    end;
  Result:= LoggedIn;
end;

procedure TMainForm.SaveWindowPositions1Click(Sender: TObject);
begin
  self.RecordWindowPositions;
  self.SaveWinPositions;
end;

procedure TMainForm.LoadWindowPositions1Click(Sender: TObject);
begin
  self.LoadWinPositions;
end;

procedure TMainForm.LoadWinPositions;
var
  rec: ^TopenWinRecord;
  idx: integer;
  WinName: string;
  caption: string;
  WinID: integer;
  xpos,ypos,winWidth,winHeight: integer;
  iniFilename: string;
  WinPosINI: TiniFile;
  Section: string;
  sectionVal: integer;
  centered: integer;
begin
  //Load Window Positions:
  //Load Child window postions and restore windows are open:
  //Need to establish first Window Name in the list.
  sectionVal:=1;
  Section:= Trim('ChildWin'+IntToStr(sectionVal));
  if self.loadINI.Execute then begin
    iniFilename:= self.loadINI.FileName;
  end;
  if Length(iniFilename) = 0 then exit;

  WinPosINI:= TiniFile.Create(iniFilename);
  try
    Section:= Trim('ChildWin'+IntToStr(sectionVal));
    idx:= 0;
    while WinPosINI.SectionExists(Section) do begin
      WinName:= WinPosINI.ReadString(Section,'winname',WinName);
      caption:= WinPosINI.ReadString(Section,'caption',WinName);
      WinID:= WinPosINI.ReadInteger(Section,'winID',WinID);
      xpos:= WinPosINI.ReadInteger(Section,'xpos',xpos);
      ypos:= WinPosINI.ReadInteger(Section,'ypos',ypos);
      winWidth:= WinPosINI.ReadInteger(Section,'winWidth',winWidth);
      winHeight:= WinPosINI.ReadInteger(Section,'winHeigth',winHeight);
      centered:= WinPosINI.ReadInteger(Section,'centered',centered);
      if centered = 1 then
        self.CreateMDIChild(WinID,caption,1,1,winWidth,winHeight)
      else
        self.CreateMDIChild(WinID,caption,xpos,ypos,winWidth,winHeight);
      sectionVal:= sectionVal+1;
      Section:= Trim('ChildWin'+IntToStr(sectionVal));
    end; //while loop
    //load values from ini file specified by user:
    //add values read from INI file into the TList.
    //Need to search the list to see if the window is ALREADY open and
    //should ALREADY be in the list.
    self.RecordWindowPositions;
  finally
    WinPosINI.Free;
  end;
end;

procedure TMainForm.MainTimerTimer(Sender: TObject);
begin
  //check for any activity to Database.
  //But first Load up dropdowns for the first time.
  //Then re-populate rec arrays if relevant table has changed
  if MainForm.LoggedIn then begin
    SendAMessage('Now Logged In ... ',5,2);
  end;

end;

procedure TMainForm.messageTimerTimer(Sender: TObject);
var
  CurrentTime: TDateTime;
  ExpireTime: TDateTime;
  Expired: boolean;
  MessageRec: ^TMessageQueue;
begin
  //display message for about 5 secs then clear.

  {CurrentTime:= Now();

  if CurrentTime > MainForm.ExpiredTime then begin
    MainForm.txtStatusBar.Text:= '';
    MainForm.MyMessage:= '';
    MainForm.Expired:= TRUE;
  end;
  if (Not MainForm.Expired) AND (Length(MainForm.MyMessage)>0) then begin
    MainForm.txtStatusBar.Text:= MainForm.MyMessage;
  end;}
  self.TestMessageQueue; //returns true if there are still messages in the queue.
end;

procedure TMainForm.ViewObjects1Click(Sender: TObject);
begin
  //View and Edit Objects table:

end;

function TMainForm.TestMessageQueue:boolean;
var
  MessageRec: ^TMessageQueue;
  idx: integer;
  MessageText: string;
  MessageSec: integer;
  Expired: boolean;
  CurrentTime: TDateTime;
  ExpireTime: TDateTime;
  StatusBarNumber: integer;
  msgCount: integer;
  msgIndex: integer;
begin
  //This is not quite correct as any new message is displayed immediately anyway.
  //needs to start at beginning of list and work towards the end.
  //maybe test if expired but then set expire to true
  //within main timer - garbage collection to go through list in reverse
  // and delete the redundant items that have the expired to true.
  Result:= False;
  if MessageCount>0 then begin
    Result:= True;
    for idx := MessageQueueList.Count-1 downto 0 do begin
      CurrentTime:= now();
      MessageRec:= self.MessageQueueList[idx];
      Expired:= MessageRec^.Expired;
      ExpireTime:= MessageRec^.ExpiredTime;
      StatusBarNumber:= MessageRec^.TextBarNumber;
      MessageText:= MessageRec^.MessageText;
      MessageSec:= MessageRec^.MessageSec;
      msgCount:= MessageRec^.MessageCount;
      msgIndex:= MessageRec^.Index;
      if CurrentTime > ExpireTime then begin
        //if Expired then begin  //has the message already been displayed ???
          self.MessageQueueList.Delete(idx);
          if StatusBarNumber = 1 then
            self.txtStatusBar.Text:= '';
          if StatusBarNumber = 2 then
            self.txtStatusBar2.Text:= '';
        //end; // if expired
      end //if
      else begin
        //delete the list item, then add the same item again with its field changed expired=false to expired=true
        new(MessageRec);  //create a new message record
        MessageRec^.MessageText:= MessageText;
        MessageRec^.MessageSec:= MessageSec;
        MessageRec^.MessageCount:= msgCount;
        MessageRec^.Index:= msgIndex;
        MessageRec^.TextBarNumber:= StatusBarNumber;
        MessageRec^.Expired:= True; //Message has now been displayed for 1 sec.
        MessageRec^.ExpiredTime:= ExpireTime;
        self.MessageQueueList.Delete(idx);
        self.MessageQueueList.Add(MessageRec);
        if StatusBarNumber = 1 then
          self.txtStatusBar.Text:= MessageText;
        if StatusBarNumber = 2 then
          self.txtStatusBar2.Text := MessageText;
      end;

    end; //for loop


  end; //if MessageCount>0
end;

function TMainForm.PopulateCombo(ComboName: TComboBox; DBTable: string; FieldPosition: integer; RecArray:TRecArray=nil; Filter:string=''; SortField:string=''; IsSingleField: boolean = false): TRecArray;
var
  idx: integer;
  strCon: string;
  mySQLConnection:TDBConnections;
  NewRecArray: TRecArray;
  strItem: string;
begin
  //This function is here simply because it MAY be quicker executing than the fieldname counterpart.
  SendAMessage('Populating Dropdown Items...',2);
  if MainForm.CheckLogin then begin
    if Assigned(RecArray) then
      NewRecArray:= RecArray
    else
      NewRecArray:= PopulateRecArray(DBTable,Filter,SortField,'',IsSingleField);
    idx:= 1;
    ComboName.Items.Clear;
    while idx < Length(NewRecArray) do begin
      strItem:= NewRecArray[idx,FieldPosition];
      ComboName.Items.Add(strItem);
      idx:= idx+1;
    end;

  end;
  SendAMessage('Populating Dropdown Items...completed.',2);
  if Assigned(NewRecArray) then
    Result:= NewRecArray;

end;

function TMainForm.PopulateList(ListName: TListbox; DBTable: string; FieldName: string; RecArray:TRecArray=nil; Filter:string=''; SortField:string=''): TRecArray;
var
  Recordidx: integer;
  strCon: string;
  mySQLConnection:TDBConnections;
  NewRecArray: TRecArray;
  strItem: string;
  FieldPosition: integer;
begin
  //MainForm.txtStatusBar.Text:= 'Populating Dropdown Items...';
  self.SendAMessage('Populating Dropdown Items...',2);
  if MainForm.CheckLogin then begin
    //THIS FUNCTION SHOULD NOW BE A PROCEDURE AND SHOULD DECIDE WHETHER TO CALL POPULATERECARRAY() OR COPY FROM
    //RecArray ALREADY LOADED INTO MEMORY FROM Initialise PROCEDURE ????????????
    //What if the DB Table containing the dropdown items get modified by another user during the running of this app ?
    SendAMessage('Populating Dropdown Items ...',2,2);
    if Assigned(RecArray) then begin
      NewRecArray:= RecArray;
    end
    else begin
      NewRecArray:= PopulateRecArray(DBTable,FieldName,Filter,SortField,FieldPosition);
    end;
    //FieldPosition:= StrToInt(NewRecArray[0][0]);
    Recordidx:= 1; //will form the combo index
    ListName.Items.Clear;
    while Recordidx < High(NewRecArray) do begin
      strItem:= NewRecArray[Recordidx,FieldPosition];
      if Length(strItem)>0 then
        ListName.Items.Add(strItem);
      Recordidx:= Recordidx+1;
    end;
  end;
  SendAMessage('Populating Dropdown Items ... Completed',2,2);
  if Assigned(NewRecArray) then
    Result:= NewRecArray;
end;


function TMainForm.PopulateCombo(ComboName: TCombobox; DBTable: string; FieldName: string; RecArray:TRecArray=nil; Filter:string=''; SortField:string=''; IsSingleField:boolean = false): TRecArray;
var
  Recordidx: integer;
  strCon: string;
  mySQLConnection:TDBConnections;
  NewRecArray: TRecArray;
  strItem: string;
  FieldPosition: integer;
  DropList: TStringList;
  qryString: string;
begin
  //MainForm.txtStatusBar.Text:= 'Populating Dropdown Items...';
  self.SendAMessage('Populating Dropdown Items...',2);
  strCon:= MainForm.MainConnection.ConnString;
  DropList:= TStringList.Create;
  try
    if MainForm.CheckLogin then begin
      //THIS FUNCTION SHOULD NOW BE A PROCEDURE AND SHOULD DECIDE WHETHER TO CALL POPULATERECARRAY() OR COPY FROM
      //RecArray ALREADY LOADED INTO MEMORY FROM Initialise PROCEDURE ????????????
      //What if the DB Table containing the dropdown items get modified by another user during the running of this app ?
      SendAMessage('Populating Dropdown Items ...',2,2);
      if Assigned(RecArray) then begin
        NewRecArray:= RecArray;

        //The following line gives an E_FAIL error:
        FieldPosition:= MainForm.MainConnection.DBOperations.GetFieldPosition(DBTable,FieldName,strCon);
      end
      else begin
        NewRecArray:= PopulateRecArray(DBTable,FieldName,Filter,SortField,FieldPosition,'',IsSingleField);
      end;

      Recordidx:= 1; //will form the combo index
      ComboName.Items.Clear;
      while Recordidx < Length(NewRecArray) do begin
        strItem:= NewRecArray[Recordidx,FieldPosition];
        if Length(strItem)>0 then
          //ComboName.Items.Add(strItem);
          DRopList.Add(strItem);

        Recordidx:= Recordidx+1;
      end;
      MainForm.MainConnection.DBOperations.RemoveDuplicates(DropList);
      ComboName.Items:= DropList;
    end;

  finally
    FreeAndNil(DropList);
  end;
  SendAMessage('Populating Dropdown Items ... Completed',2,2);
  if Assigned(NewRecArray) then
    Result:= NewRecArray;
end;

function TMainForm.PopulateMultiCombo(ComboName: TComboBox; DBTable,FieldNames,EditMasks: string; RecArray:TRecArray=nil; Filter:string=''; SortField:string=''): TRecArray;
var
  Recordidx: integer;
  strCon: string;
  mySQLConnection:TDBConnections;
  NewRecArray: TRecArray; //2-Dim array
  strItem: string;
  FieldPosition: integer;
  FieldArray: TstrArray;
  EditMaskArray: TstrArray;
  TextArray: TstrArray;
  fldIDX: integer;
  maskIDX: integer;
  maskValue: string;
  FullString: string;
  MaskLength: integer;
  MaskItem: string;
  OpenBracketPos: integer;
  CloseBracketPos: integer;
begin
  //MainForm.txtStatusBar.Text:= 'Populating Dropdown Items...';
  SetLength(FieldArray,1);
  SetLength(EditMaskArray,1);
  SetLength(TextArray,1);
  //SetLength(EditMaskArray,1); //just to be sure it has initialised properly.
  if Length(FieldNames)>0 then begin
    FieldArray:= MainForm.MainConnection.DBOperations.StrToStringArray(FieldNames,',');

  end;
  if Length(EditMasks)>0 then begin
    EditMaskArray:= MainForm.MainConnection.DBOperations.StrToStringArray(EditMasks,','); //at the moment may contain TEXT

  end;
  if Length(FieldArray) <> Length(EditMaskArray) then begin
    MainConnection.DBErrors:= 'Number of Fieldnames differ from Number of Edit Masks';
  end;

  self.SendAMessage('Populating Dropdown Items...',2);
  Recordidx:= 1; //will form the combo index

  ComboName.Items.Clear;
  if Assigned(RecArray) then begin
    NewRecArray:= RecArray;
  end
  else begin
    NewRecArray:= PopulateRecArray(DBTable,Filter,SortField);
  end;
  //strCon is blank ????

  if MainForm.CheckLogin then begin
    //What if the DB Table containing the dropdown items get modified by another user during the running of this app ?
    strCon:= MainConnection.ConnString;
    Recordidx:= 1;
    if Length(FieldArray)>1 then begin

      while Recordidx < High(NewRecArray) do begin
        FullString:= '';
        fldIDX:= 0;
        maskIDX:= 0;
        strItem:= '';
        MaskItem:= '';
        while fldIDX<Length(FieldArray) do begin
          //strItem:= NewRecArray[Recordidx,FieldPosition1]+','+NewRecArray[Recordidx,FieldPosition2];
          //FieldPosition[fldIDX] for each record.
          //FieldPosition:= StrToInt(NewRecArray[0][0]);
          strItem:= '';
          FieldPosition:= MainConnection.DBOperations.GetFieldPosition(DBTable,FieldArray[fldIDX],strCon);
          //if Assigned(EditMaskArray) then begin
           //watch out - can have random high number if element does not exist.
          if Length(FieldArray) = Length(EditMaskArray) then begin
            if Length(EditMaskArray[maskIDX])>0 then begin
              MaskLength:= Length(EditMaskArray[maskIDX]);
              maskValue:= NewRecArray[Recordidx,FieldPosition];
              MaskItem:= FormatMaskText(EditMaskArray[maskIDX],maskValue);
              OpenBracketPos:= AnsiPos('[',MaskItem);
              CloseBracketPos:= AnsiPos(']',MaskItem);
              if OpenBracketPos>0 then begin
                if CloseBracketPos=0 then
                  CloseBracketPos:= OpenBracketPos+1;
                strItem:= Copy(MaskItem,OpenBracketPos+1,CloseBracketPos-1);
                if OpenBracketPos>1 then
                  strItem:= MaskItem+' '+StrItem
                else
                  strItem:= StrItem+' '+MaskItem;
              end
              else
                strItem:= MaskItem;

            end
            else
              strItem:= NewRecArray[Recordidx,FieldPosition];

          end
          else
            strItem:= NewRecArray[Recordidx,FieldPosition];
          if  fldIDX = 0 then
            FullString:= strItem
          else
            FullString:= FullString+','+strItem;

          fldIDX:= fldIDX+1;
          maskIDX:= maskIDX+1;
        end; //while  fldIDX
        if Length(FullString)>0 then
          //Only items that are NOT blank will appear in the dropdown list, this means that the actual
          //combo index may not be the same as the
          ComboName.Items.Add(FullString);
        Recordidx:= Recordidx+1;

      end; //while Recordidx
    end;
  end; //if Length(FieldArray)>1
  SendAMessage('Populating Multiple Dropdown Items ... Completed',2,2);
  if Assigned(NewRecArray) then
    Result:= NewRecArray;
end;

function TMainForm.PopulateRecArray(DBTable: string; Filter:string; SortField:string; sqlCmd:string=''; SingleField:boolean = False): TRecArray;
var
  idx: integer;
  strCon: string;
  mySQLConnection:TDBConnections;
  NewRecArray: TRecArray;
  strItem: string;
  sqlCommand: string;
begin
//Has this DBTable already been called before ??? - if YES then NewRecArray will already be populated
  SetLength(NewRecArray,2,2);

  if Length(sqlCmd)>0 then
    sqlCommand:= sqlCmd
  else begin
    if Length(DBTable) = 0 then begin
      ShowMessage('PopulateRecArray - Please supply Table Name');
      exit;
    end;
    if (SingleField) AND (Length(SortField)>0) then
      sqlCommand:= 'SELECT '+SortField+' FROM '+DBTable
    else
      sqlCommand:= 'SELECT * FROM '+DBTable;
  end;
  if Length(Filter)>0 then
    sqlCommand:= sqlCommand+' WHERE '+Filter;
  if Length(SortField)>0 then
    sqlCommand:= sqlCommand+' ORDER BY '+SortField;
  if MainForm.CheckLogin then begin
    SendAMessage('Establish Connection to Database to populate list...',2);
    mySqlConnection:= TDBConnections.Create;
    mySqlConnection.Password:= MainForm.MainConnection.Password;
    mySqlConnection.Server:= MainForm.MainConnection.Server;
    mySqlConnection.DBName:= MainForm.MainConnection.DBName;
    mySqlConnection.UID:= MainForm.MainConnection.UID;
    mySqlConnection.Port:= MainForm.MainConnection.Port;
    strCon:= MainForm.MainConnection.ConnString;
    mySqlConnection.DBOperations.connString:= strCon; //very important as cannot call parent class internally
    if mySqlConnection.DBOperations.GetTotalRecords(DBTable,strCon)>0 then begin
      //is the query erased first from the previous use ???
      mySQLConnection.DBOperations.CreateQuery(strCon,'SELECT',sqlCommand,SortField);
      mySQLConnection.DBOperations.ADOQuery.First;
      MainForm.MainConnection.DBOperations.SetQueryString(mySQLConnection.DBOperations.GetQueryString);
      NewRecArray:= mySQLConnection.DBOperations.CreateRecArray(mySQLConnection.DBOperations.ADOQuery);
      mySQLConnection.Destroy;
      SendAMessage('Establish Connection to Database ...completed.',2);
    end
    else
      ShowMessage('No records exist for '+DBTable);
  end;
  Result:= NewRecArray;
end;

function TMainForm.PopulateRecArray(DBTable:string; FieldName:string; Filter:string; SortField:string; VAR FieldPos:integer; SQLcmd:string=''; SingleField:boolean = False): TRecArray;
var
  idx: integer;
  strCon: string;
  mySQLConnection:TDBConnections;
  NewRecArray: TRecArray;
  strItem: string;
  sqlCommand: string;
begin
  SetLength(NewRecArray,2,2);
  FieldPos:= 0;
  if Length(DBTable) = 0 then begin
    ShowMessage('PopulateRecArray - Please supply Table Name');
    exit;
  end;
  if Length(sqlCmd)>0 then
    sqlCommand:= sqlCmd
  else begin
    if Length(DBTable) = 0 then begin
      ShowMessage('PopulateRecArray - Please supply Table Name');
      exit;
    end;
    if (SingleField) AND (Length(SortField)>0) then
      //corrupts the function PopulateCombo
      sqlCommand:= 'SELECT '+SortField+' FROM '+DBTable
    else
      sqlCommand:= 'SELECT * FROM '+DBTable;
  end;

  if Length(Filter)>0 then
    sqlCommand:= sqlCommand+' WHERE '+Filter;
  if Length(SortField)>0 then
    sqlCommand:= sqlCommand+' ORDER BY '+SortField;
  if MainForm.CheckLogin then begin
    SendAMessage('Establish Connection to Database to populate list...',2);
    mySqlConnection:= TDBConnections.Create;
    mySqlConnection.Password:= MainForm.MainConnection.Password;
    mySqlConnection.Server:= MainForm.MainConnection.Server;
    mySqlConnection.DBName:= MainForm.MainConnection.DBName;
    mySqlConnection.UID:= MainForm.MainConnection.UID;
    mySqlConnection.Port:= MainForm.MainConnection.Port;
    strCon:= mySqlConnection.ConnString;
    mySqlConnection.DBOperations.connString:= strCon; //very important as cannot call parent class internally
    mySQLConnection.DBOperations.CreateQuery(strCon,'SELECT',sqlCommand);
    mySQLConnection.DBOperations.ADOQuery.First;
    //Do we use the boolean variable - IsSingleField here:
    if Length(FieldName)>0 then
      FieldPos:= mySqlConnection.DBOperations.GetFieldPosition(DBTable,FieldName,strCon)
    else
      FieldPos:= 1;
    //CreateRecArray also populates the energy_linktable to make corresponding entries from combo index to mapped table,
    //simply to eliminate blank spaces in the combo list.
    NewRecArray:= mySQLConnection.DBOperations.CreateRecArray(mySQLConnection.DBOperations.ADOQuery);
    mySQLConnection.Destroy;
    SendAMessage('Establish Connection to Database ...completed.',2);
  end;
  Result:= NewRecArray;
end;

procedure TMainForm.SaveWinPositions;
var
  rec: ^TopenWinRecord;
  centered: integer;
  idx: integer;
  WinName: string;
  FormCaption: string;
  FormName: string;
  WinID: integer;
  xpos,ypos,winWidth,winHeight: integer;
  iniFilename: string;
  WinPosINI: TiniFile;
  Section: string;
  sectionVal: integer;
begin
  //Save Child window postions from LIST:
  sectionVal:=1;
  if self.saveINI.Execute then begin
    iniFilename:= self.saveINI.FileName;
  end;
  if Length(iniFilename) = 0 then exit;
  sectionVal:=1;
  Section:= 'ChildWin1';
  WinPosINI:= TiniFile.Create(iniFilename);
  try
    for idx := self.openWinList.Count-1 downto 0 do begin
      rec:= self.openWinList[idx];
      centered:= rec^.Centered;
      FormName:= rec^.FormName;
      WinName:= rec^.WinName;
      FormCaption:= rec^.FormCaption;
      WinID:= rec^.ID;
      xpos:= rec^.xpos;
      ypos:= rec^.ypos;
      winWidth:= rec^.width;
      winHeight:= rec^.height;
      WinPosINI.WriteString(Section,'winname',WinName);
      WinPosINI.WriteString(Section,'caption',FormCaption);
      WinPosINI.WriteString(Section,'FormName',FormName);
      WinPosINI.WriteInteger(Section,'winID',WinID);
      WinPosINI.WriteInteger(Section,'xpos',xpos);
      WinPosINI.WriteInteger(Section,'ypos',ypos);
      WinPosINI.WriteInteger(Section,'winWidth',winWidth);
      WinPosINI.WriteInteger(Section,'winHeight',winHeight);
      WinPosINI.WriteInteger(Section,'centered',centered);
      sectionVal:= sectionVal+1;
      Section:= 'ChildWin'+IntToStr(sectionVal);
    end; //for loop
    //save to ini file specified by user:
  finally
    WinPosINI.Free;
  end;

end;

procedure TMainForm.SendAMessage(AMessage: string; Seconds:integer; TextBarNumber:integer=1);
var
  MessageRec: ^TMessageQueue;
begin
  //SetLength(Messages,Length(Messages)+1);
  //SetLength(MessageSecs,Length(MessageSecs)+1);
  //SetLength(MessagesExpired,Length(MessagesExpired)+1);
  //AnsiPos('substring','mainstring');
  MessageCount:= MessageCount+1;
  //MainForm.Messages[MessageCount]:= AMessage;
  //MainForm.MessageSecs[MessageCount]:= Seconds;
  //MainForm.MyMessage:= AMessage; //current Message
  //MainForm.ExpiredTime:= Incsecond(Now(),Seconds);
  //MainForm.Expired:= FALSE;
  new(MessageRec);  //create a new message record
  MessageRec^.MessageText:= AMessage;
  MessageRec^.MessageSec:= Seconds;
  MessageRec^.MessageCount:= MessageCount;
  MessageRec^.TextBarNumber:= TextBarNumber;
  MessageRec^.Expired:= False;
  MessageRec^.ExpiredTime:= IncSecond(now(),Seconds);
  self.MessageQueueList.Add(MessageRec); //stores pointer to record type
  //now oldest messages are at the BEGINNING of the list.
  //these need to be displayed first. and then deleted.
end;

procedure TMainForm.SessionLogEntry1Click(Sender: TObject);
begin
  //Session Log Entry:
  if IsLoginOK then
    CreateMDIChild(10,'ENTER SESSION LOG',1,1,900,700);
end;

procedure TMainForm.ViewSessions1Click(Sender: TObject);
begin
  if IsLoginOK then
    //CreateMDIChild(5,'VIEW AND EDIT SESSIONS',1,1,900,700);
    CreateMDIChild(10,'VIEW AND EDIT SESSIONS',1,1,900,700);
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  FreeAndNil(OpenWinList);
  FreeAndNil(MessageQueueList);
end;

procedure TMainForm.FormResize(Sender: TObject);
begin
  //keep any active form centered if required.
  self.pnlMain.Width:= self.Width;
end;

function TMainForm.TestEntry(var FormField:string; var GlobalVar:string; var Value:double):double;
begin
  if Length(FormField)>0 then
    GlobalVar:= FormField
  else
    GlobalVar:= '0';
  if NOT TryStrToFloat(GlobalVar,Value) then begin
    Value:= 0.0;
    FormField:= '0';
  end;
  Result:= Value;
end;

function TMainForm.TestEntry(var FormField:string; var GlobalVar:string; var Value:integer):integer;
begin
  if Length(FormField)>0 then
    GlobalVar:= FormField
  else
    GlobalVar:= '0';
  if NOT TryStrToInt(GlobalVar,Value) then begin
    Value:= 0;
    FormField:= '0';
  end;
  Result:= Value;
end;

procedure TMainForm.LockClientWindowUpdate;
begin
  if fLockClientWindowUpdateCount = 0 then
    SendMessage(ClientHandle, WM_SETREDRAW, 0, 0) ;
  Inc(fLockClientWindowUpdateCount) ;
end;

procedure TMainForm.UnlockClientWindowUpdate;
begin
  Dec(fLockClientWindowUpdateCount) ;
  if fLockClientWindowUpdateCount = 0 then begin
    SendMessage(ClientHandle, WM_SETREDRAW, 1, 0) ;
    RedrawWindow(ClientHandle, nil, 0, RDW_FRAME or RDW_INVALIDATE or RDW_ALLCHILDREN or RDW_NOINTERNALPAINT)
  end;
end;

end.
