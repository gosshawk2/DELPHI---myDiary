unit SaveDialog;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfrmSaveDialog = class(TForm)
    pnlMain: TPanel;
    txtMessage2: TEdit;
    txtMessage1: TEdit;
    btnInsert: TButton;
    btnUpdate: TButton;
    btnCancel: TButton;
    pnlForm: TPanel;
    procedure btnInsertClick(Sender: TObject);
    procedure btnUpdateClick(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    ButtonClicked: integer;

    function Execute: integer;
  end;

var
  frmSaveDialog: TfrmSaveDialog;

implementation

uses Main;

{$R *.dfm}

procedure TfrmSaveDialog.btnCancelClick(Sender: TObject);
begin
  //cancel pressed
  ButtonClicked:= 1;
  MainForm.ButtonClicked:= 1;
end;

procedure TfrmSaveDialog.btnInsertClick(Sender: TObject);
begin
  //Insert Pressed - but program never executes me
  ButtonClicked:= 2;
  MainForm.ButtonClicked:= 2;
end;

procedure TfrmSaveDialog.btnUpdateClick(Sender: TObject);
begin
  //Update Pressed - but program never executes me
  ButtonClicked:= 3;
  MainForm.ButtonClicked:= 3;
end;

function TfrmSaveDialog.Execute: integer;
var
  Answer: integer;
begin
  //Getting ACCESS VIOLATION HERE
  Result:= ButtonClicked;
  MainForm.CloseMDIChild(-1);
end;

end.
