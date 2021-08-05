program my_Delphi_Diary;

uses
  Vcl.Forms,
  EntrySelection in 'EntrySelection.pas' {frmGridSelection},
  about in 'about.pas' {AboutBox},
  CalendarPicker in 'CalendarPicker.pas' {frmCalendarPicker},
  CreateAForm in 'CreateAForm.pas',
  DatabaseConnections in 'DatabaseConnections.pas',
  DBOptions in 'DBOptions.pas' {frmDBOptions},
  DiaryEntry in 'DiaryEntry.pas' {frmDiaryEntry},
  DiaryView in 'DiaryView.pas' {frmDiaryView},
  EnterSchedules in 'EnterSchedules.pas' {frmEnterSchedules},
  EnterUserDetails in 'EnterUserDetails.pas' {frmUserDetails},
  LoginForm in 'LoginForm.pas' {frmLogin},
  MAIN in 'MAIN.PAS' {MainForm},
  myDatabaseClass_II in 'myDatabaseClass_II.pas',
  Output in 'Output.pas' {frmOutput},
  SaveDialog in 'SaveDialog.pas' {frmSaveDialog},
  Settings in 'Settings.pas' {frmDatabaseOptions},
  ViewGrid in 'ViewGrid.pas' {frmDBView},
  xmlToDatabase in 'xmlToDatabase.pas' {frmXmlToDatabase},
  SelectDiaryEntry in 'SelectDiaryEntry.pas' {frmSelectDiaryEntry},
  SendMessage in 'SendMessage.pas' {frmSendMessage},
  ReceiveMessage in 'ReceiveMessage.pas' {frmReceiveMessage};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.CreateForm(TfrmReceiveMessage, frmReceiveMessage);
  Application.Run;
end.
