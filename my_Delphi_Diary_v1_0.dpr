program my_Delphi_Diary_v1_0;

uses
  Vcl.Forms,
  about in 'about.pas' {AboutBox},
  CalendarPicker in 'CalendarPicker.pas' {frmCalendarPicker},
  ChangeGridColors in 'ChangeGridColors.pas' {frmGridColorPicker},
  Charts in 'Charts.pas' {frmCharts},
  CreateAForm in 'CreateAForm.pas',
  DatabaseConnections in 'DatabaseConnections.pas',
  DBOptions in 'DBOptions.pas' {frmDBOptions},
  DBViewGrid in 'DBViewGrid.pas' {frmDBGridView},
  DiaryEntry in 'DiaryEntry.pas' {frmDiaryEntry},
  DiaryView in 'DiaryView.pas' {frmDiaryView},
  DrawGridViewer in 'DrawGridViewer.pas' {frmDrawGridViewer},
  EnterSchedules in 'EnterSchedules.pas' {frmEnterSchedules},
  EnterUserDetails in 'EnterUserDetails.pas' {frmUserDetails},
  LoginForm in 'LoginForm.pas' {frmLogin},
  MAIN in 'MAIN.PAS' {MainForm},
  myDatabaseClass_II in 'myDatabaseClass_II.pas',
  Output in 'Output.pas' {frmOutput},
  SaveDialog in 'SaveDialog.pas' {frmSaveDialog},
  Settings in 'Settings.pas' {frmDatabaseOptions},
  ViewGrid in 'ViewGrid.pas' {frmDBView},
  ViewImages in 'ViewImages.pas' {frmViewScreenShots},
  xmlToDatabase in 'xmlToDatabase.pas' {frmXmlToDatabase},
  SelectDiaryEntry in 'SelectDiaryEntry.pas' {frmSelectDiaryEntry};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TAboutBox, AboutBox);
  Application.Run;
end.
