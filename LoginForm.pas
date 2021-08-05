unit LoginForm;

//*****************************************************************************
//Changed SearchCombo to include option to ignore case of passed variables
//
//Date Changed: 28/8/2014 by Daniel Goss
//
//11/2/2015 - need a way of saving new entries such as new server connection,
//eg desktop-pc instead of localhost, along with its port number.
//
//*****************************************************************************

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, inifiles, myDatabaseClass_II;

type
  TfrmLogin = class(TForm)
    pnlTop: TPanel;
    pnlMain: TPanel;
    lblTitle: TLabel;
    pnlBottom: TPanel;
    btnLogin: TBitBtn;
    btnCancel: TBitBtn;
    lblHostname: TLabel;
    txtHostname: TEdit;
    lblDatabase: TLabel;
    txtDatabase: TEdit;
    lblUsername: TLabel;
    txtUsername: TEdit;
    lblPassword: TLabel;
    txtPassword: TEdit;
    lblPort: TLabel;
    txtPort: TEdit;
    comHostname: TComboBox;
    comDatabase: TComboBox;
    comPort: TComboBox;
    comUsername: TComboBox;
    btnSave: TBitBtn;
    procedure btnLoginClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure comHostnameClick(Sender: TObject);
    procedure comDatabaseClick(Sender: TObject);
    procedure comPortClick(Sender: TObject);
    procedure comUsernameClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnSaveClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    Hostname,Database,Username,Password,Port: string;
    NumDBSettings:integer;
    NumberOfTries: integer;
    procedure SaveDetails(Login:boolean = false);
    function SearchCombo(returnIndex:integer; comboBox:TComboBox; search:string; IgnoreCase:Boolean):integer;
  end;

var
  frmLogin: TfrmLogin;

implementation

uses MAIN;

{$R *.dfm}

procedure TfrmLogin.SaveDetails(Login:boolean = false);
var
  DBINI: TIniFile;
  Setting:integer;
  com1,com2,com3,com4: integer;
  conString: widestring;
  Chosen: integer;
  strErrorNumber: string;
  actualError: string;
  //This version is for the DIARY Application : EXTRACT USER ID
begin
Hostname:= '';
Database:= '';
Username:= '';
Password:= '';
if Length(txtHostname.Text)>0 then
    Hostname:= txtHostname.Text;
  if Length(txtDatabase.Text)>0 then
    Database:= txtDatabase.Text;
  if Length(txtUsername.Text)>0 then
    Username:= txtUsername.Text;
  if Length(txtPassword.Text)>0 then
    Password:= txtPassword.Text;
  if Length(txtPort.Text)>0 then
    Port:= txtPort.Text;

  if NOT Assigned(MainForm.MainConnection) then
    MainForm.MainConnection:= TDBConnections.Create;
  MainForm.MainConnection.Server:= Hostname;
  MainForm.MainConnection.DBName:= Database;
  MainForm.MainConnection.UID:= Username; //mysql user - could be root or guest
  //Will have to extract the id from table diaryusers - match the username entered.
  //so a way of creating new users will be needed - and created to mysql database also.
  // - with GRANT PERMISSIONS and password etc.

  MainForm.MainConnection.Password:= password;
  MainForm.MainConnection.Port:= Port;
    //Test connection to MySQL database:
  conString:= MainForm.MainConnection.ConnString;
  //end;
  if self.NumberOfTries>2 then begin
    ShowMessage('Number of Tries Exceeded - Application will now close');
    MainForm.SendAMessage('Application Closing ...',5,2);
    Application.Terminate;
  end;
  try
    MainForm.MainConnection.TestConnection(conString,False);
    //ShowMessage('OK');
  except On E:Exception do
    begin
      strErrorNumber:= IntToStr(MainForm.MainConnection.DBOperations.errorNumber);
      MainForm.MainConnection.DBOperations.errorMessage:= MainForm.MainConnection.DBOperations.errorMessage+', Database Test Failed: '+e.Message+' ,Error Number:'+strErrorNumber;
    end;
  end;
  if length(MainForm.MainConnection.DBOperations.errorMessage)=0 then begin
    MainForm.MainConnection.OpenConnection(conString);
    if Login then ShowMessage('OK LOGIN SUCCESSFUL');
    MainForm.UserID:= MainForm.MainConnection.DBOperations.SearchField('diaryusers',constring,'username',Username,True,False);
    com1:= searchCombo(1,comHostname,Hostname,TRUE);
    com2:= searchCombo(2,comDatabase,Database,TRUE);
    com3:= searchCombo(4,comUsername,Username,FALSE);
    com4:= searchCombo(8,comPort,Port,TRUE);
    if com1+com2+com3+com4 = 15 then
      //ShowMessage('Already Exists')
    else begin
    //if not FileExists(ChangeFileExt(Application.ExeName,'.ini')) then begin
      Setting:= NumDBSettings;
      DBINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
      try
       DBINI.WriteString(Trim('DatabaseSettings'+IntToStr(Setting)),'Hostname',Hostname) ;
       DBINI.WriteString(Trim('DatabaseSettings'+IntToStr(Setting)),'Database',Database) ;
       DBINI.WriteString(Trim('DatabaseSettings'+IntToStr(Setting)),'Username',Username) ;
       DBINI.WriteString(Trim('DatabaseSettings'+IntToStr(Setting)),'Port',Port) ;
      finally
       DBINI.Free;
      end; {try ... finally}
    end; {if}
    MainForm.LoggedIn:= TRUE;
    MainForm.IsLoginOK:= TRUE;
    MainForm.CloseMDIChild(-1);
  end
  else begin
    //This is where we test whether the database exists or not.
    //Then we test if the CORRECT tables exist or not.
    //if all OK so far then it means that the user just has not
    //entered the username or password correctly then
    //otherwise we create the database that the user has specified in
    //the sign-in. Ask first of course!
    //ShowMessage('LOGIN NOT SUCCESSFUL');
    //ShowMessage('DBError: '+MainForm.MainConnection.DBOperations.errorMessage);
    //ShowMessage('DBError Number: '+IntToStr(MainForm.MainConnection.DBOperations.errorNumber));
    MainForm.MainConnection.OpenConnection(conString);
    strErrorNumber:= IntToStr(MainForm.MainConnection.DBOperations.errorNumber);
    actualError:= MainForm.MainConnection.DBOperations.exceptionMessage;
    SHowMessage('Error #'+strErrorNumber+': '+MainForm.MainConnection.DBOperations.errorMessage+' Exception:'+actualError);
    //if AnsiPos('ACCESS DENIED',Uppercase(MainForm.MainConnection.DBOperations.errorMessage))>0 then begin
      //self.NumberOfTries:= self.NumberOfTries+1;
      //ShowMessage('ACCESS DENIED, Attempts: '+IntToStr(self.NumberOfTries));
    //end else
    //if AnsiPos('UNKNOWN DATABASE',Uppercase(MainForm.MainConnection.DBOperations.errorMessage))>0 then begin
      //ShowMessage('UNKNOWN DATABASE');
      //Chosen:= messageDlg('Create Database:'+MainForm.MainConnection.DBName,
        //mtConfirmation,[mbYes,mbNo],0,mbYes);
      //if Chosen = mrYes then begin
        //ShowMessage('YES PRESSED');
        //MainForm.MainConnection.DBOperations.MySQL_Use('mysql',MainForm.MainConnection.ConnString);
        //MainForm.MainConnection.DBOperations.MySQL_CreateDatabase(conString,MainForm.MainConnection.DBName,true);
        //MainForm.CreateTables;
        //MainForm.CreateTheDatabase;
        //ShowMessage('sql command= '+MainForm.MainConnection.DBOperations.queryMessage);

        //ShowMessage('OK Database Created');
      //end;
    //end
    //else begin
      //ShowMessage(MainForm.MainConnection.DBOperations.errorMessage);
    //end;
    //if Length(MainForm.MainConnection.DBMessage)>0 then
      //ShowMessage('DB Message: '+MainForm.MainConnection.DBMessage);
    //if Length(MainForm.MainConnection.DBErrors)>0 then
      //ShowMessage('DB Error: '+MainForm.MainConnection.DBErrors);
    //if Length(MainForm.MainConnection.DBOperations.errorMessage2)>0 then
      //ShowMessage('Open Error: '+MainForm.MainConnection.DBOperations.errorMessage2);
    MainForm.LoggedIn:= FALSE;
    MainForm.IsLoginOK:= FALSE;
  end
end;

procedure TfrmLogin.btnLoginClick(Sender: TObject);
begin
  self.SaveDetails(true);
end;

procedure TfrmLogin.btnSaveClick(Sender: TObject);
begin
  self.SaveDetails(false);
end;

procedure TfrmLogin.btnCancelClick(Sender: TObject);
begin
  MainForm.CloseMDIChild(-1);

end;

procedure TfrmLogin.FormShow(Sender: TObject);
var
  DBINI: TIniFile;
  NumSettings:integer;
  Section: string;
begin
  //Load each list box with options available
  //18/7/2015 - but it does not - because the loop does not exist to load
  //each section ?
  NumSettings:=1;
  if FileExists(ChangeFileExt(Application.ExeName,'.ini')) then begin
    DBINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
    try
      //NumSettings:= NumSettings+1;
      Section:= Trim('DatabaseSettings'+IntToStr(NumSettings));
      Hostname := DBINI.ReadString(Section,'Hostname', Hostname) ;
      Database := DBINI.ReadString(Section,'Database', Database) ;
      Username := DBINI.ReadString(Section,'Username', Username) ;
      Port := DBINI.ReadString(Section,'Port', Port) ;
      comHostname.Items.Add(Hostname);
      comDatabase.Items.Add(Database);
      comUsername.Items.Add(Username);
      comPort.Items.Add(Port);
    finally
       DBINI.Free;
   end; {try ... finally}
  end; {if}
  comHostname.ItemIndex:= 0;
  comDatabase.ItemIndex:= 0;
  comUsername.ItemIndex:= 0;
  comPort.ItemIndex:= 0;
  self.txtHostname.Text:= comHostname.Text;
  self.txtDatabase.Text:= comDatabase.Text;
  self.txtUsername.Text:= comUsername.Text;
  self.txtPort.Text:= comPort.Text;
  NumDBSettings:= NumSettings;
end;

procedure TfrmLogin.comHostnameClick(Sender: TObject);
begin
  txtHostname.Text:= comHostname.Items[comHostname.ItemIndex];
end;

procedure TfrmLogin.comDatabaseClick(Sender: TObject);
begin
  txtDatabase.Text:= comDatabase.Items[comDatabase.itemIndex];
end;

procedure TfrmLogin.comPortClick(Sender: TObject);
begin
  txtPort.Text:= comPort.Items[comPort.itemIndex];
end;

procedure TfrmLogin.comUsernameClick(Sender: TObject);
begin
  txtUsername.Text:= comUsername.Items[comUsername.itemIndex];
end;

function TfrmLogin.SearchCombo(returnIndex:integer; comboBox:TComboBox; search:string; IgnoreCase:Boolean):integer;
var
  idx:integer;
  HasFound:boolean;
begin
  HasFound:= False;
  idx:= 0;
  While idx<comboBox.Items.Count do begin
    if IgnoreCase then
      if (Uppercase(search)= Uppercase(comboBox.Items[idx])) then begin
        HasFound:= TRUE;
        break;
      end
    else
      if (search= comboBox.Items[idx]) then begin
        HasFound:= TRUE;
        break;
      end;
    idx:= idx+1;
  end; //while
  if HasFound then
    result:= returnIndex
  else
    result:= 0;
end;

procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action:= caFree;
end;

end.
