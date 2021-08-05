unit SendMessage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfrmSendMessage = class(TForm)
    pnlTop: TPanel;
    lblTitle: TLabel;
    btnClose: TBitBtn;
    pnlButtons: TPanel;
    btnSend: TBitBtn;
    btnCancel: TBitBtn;
    Label1: TLabel;
    txtFirstname: TEdit;
    txtLastname: TEdit;
    comNames: TComboBox;
    pnlMessage: TPanel;
    lblSubject: TLabel;
    txtSubject: TEdit;
    memMessage: TMemo;
    lblMessage: TLabel;
    procedure comNamesChange(Sender: TObject);
    procedure btnSendClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmSendMessage: TfrmSendMessage;

implementation

uses Main;

{$R *.dfm}

procedure TfrmSendMessage.btnCloseClick(Sender: TObject);
begin
  //Close
  MainForm.CloseMDIChild(-1);
end;

procedure TfrmSendMessage.btnSendClick(Sender: TObject);
begin
  //Send Message:

end;

procedure TfrmSendMessage.comNamesChange(Sender: TObject);
begin
  //Selected name - find its corresponding Name id from the nickname in the combo:

end;

end.
