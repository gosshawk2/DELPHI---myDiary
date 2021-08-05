unit CalendarPicker;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfrmCalendarPicker = class(TForm)
    pnlTop: TPanel;
    txtDayName: TEdit;
    txtDayNumber: TEdit;
    txtMonthName: TEdit;
    txtYear: TEdit;
    btnOK: TBitBtn;
    btnCancel: TBitBtn;
    procedure btnCancelClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCalendarPicker: TfrmCalendarPicker;

implementation

uses Main;

{$R *.dfm}

procedure TfrmCalendarPicker.btnCancelClick(Sender: TObject);
begin
  //Cancel clicked: close form:
  MainForm.CloseMDIChild(-1);
end;

procedure TfrmCalendarPicker.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

end.
