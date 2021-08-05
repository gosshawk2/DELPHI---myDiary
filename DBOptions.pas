unit DBOptions;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, inifiles;

type
  TfrmDBOptions = class(TForm)
    pnlTop: TPanel;
    pnlMain: TPanel;
    lblTitle: TLabel;
    pnlBottom: TPanel;
    btnSave: TBitBtn;
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
    pnlMessage: TPanel;
    procedure btnSaveClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure comHostnameClick(Sender: TObject);
    procedure comDatabaseClick(Sender: TObject);
    procedure comPortClick(Sender: TObject);
    procedure comUsernameClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    Hostname,Database,Username,Password,Port: string;
    NumDBSettings:integer;
    function SearchCombo(returnIndex:integer; comboBox:TComboBox; search:string):integer;
  end;

var
  frmDBOptions: TfrmDBOptions;

implementation

uses Main;

{$R *.dfm}

procedure TfrmDBOptions.btnSaveClick(Sender: TObject);
var
  DBINI: TIniFile;
  Setting:integer;
  com1,com2,com3,com4: integer;
begin

  if Length(txtHostname.Text)>0 then
    Hostname:= txtHostname.Text;
  if Length(txtDatabase.Text)>0 then
    Database:= txtDatabase.Text;
  if Length(txtUsername.Text)>0 then
    Username:= txtUsername.Text;
  if Length(txtPort.Text)>0 then
    Port:= txtPort.Text;
  com1:= searchCombo(1,comHostname,Hostname);
  com2:= searchCombo(2,comDatabase,Database);
  com3:= searchCombo(4,comUsername,Username);
  com4:= searchCombo(8,comPort,Port);
  if com1+com2+com3+com4 = 15 then
    ShowMessage('Already Exists')
  else begin
  //if not FileExists(ChangeFileExt(Application.ExeName,'.ini')) then begin
    Setting:= NumDBSettings+1;
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
end;

procedure TfrmDBOptions.btnCancelClick(Sender: TObject);
begin
  Hostname:= '';
  Database:= '';
  Username:= '';
  Password:= '';
  MainForm.CloseMDIChild(-1);
end;

procedure TfrmDBOptions.FormShow(Sender: TObject);
var
  DBINI: TIniFile;
  NumSettings:integer;
  Section: string;
begin
  //Load each list box with options available
  NumSettings:=1;
  if FileExists(ChangeFileExt(Application.ExeName,'.ini')) then begin
    DBINI := TIniFile.Create(ChangeFileExt(Application.ExeName,'.ini')) ;
    //loop needed to read each section until no more sections.
    try
      Section:= Trim('DatabaseSettings'+IntToStr(NumSettings));
      while DBINI.SectionExists(Section) do begin
        //readSections
        pnlMessage.Caption:= 'Reading Section:'+IntToStr(NumSettings);
        Hostname := DBINI.ReadString(Section,'Hostname', Hostname) ;
        Database := DBINI.ReadString(Section,'Database', Database) ;
        Username := DBINI.ReadString(Section,'Username', Username) ;
        Port := DBINI.ReadString(Section,'Port', Port) ;
        comHostname.Items.Add(Hostname);
        comDatabase.Items.Add(Database);
        comUsername.Items.Add(Username);
        comPort.Items.Add(Port);
        NumSettings:= NumSettings+1;
        Section:= Trim('DatabaseSettings'+IntToStr(NumSettings));
      end; //while
    finally
      DBINI.Free;
    end;
  end; {if}
end;

procedure TfrmDBOptions.comHostnameClick(Sender: TObject);
begin
  txtHostname.Text:= comHostname.Items[comHostname.ItemIndex];
end;

procedure TfrmDBOptions.comDatabaseClick(Sender: TObject);
begin
  txtDatabase.Text:= comDatabase.Items[comDatabase.itemIndex];
end;

procedure TfrmDBOptions.comPortClick(Sender: TObject);
begin
  txtPort.Text:= comPort.Items[comPort.itemIndex];
end;

procedure TfrmDBOptions.comUsernameClick(Sender: TObject);
begin
  txtUsername.Text:= comUsername.Items[comUsername.itemIndex];
end;

function TfrmDBOptions.SearchCombo(returnIndex:integer; comboBox:TComboBox; search:string):integer;
var
  idx:integer;
  HasFound:boolean;
begin
  HasFound:= False;
  idx:= 0;
  While idx<comboBox.Items.Count do begin
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

procedure TfrmDBOptions.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

end.
