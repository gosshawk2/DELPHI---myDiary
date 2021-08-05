unit ReceiveMessage;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls;

type
  TfrmReceiveMessage = class(TForm)
    pnlTop: TPanel;
    lblTitle: TLabel;
    btnClose: TBitBtn;
    btnCancel: TBitBtn;
    btnReply: TBitBtn;
    pnlButtons: TPanel;
    Label1: TLabel;
    txtFirstname: TEdit;
    txtLastname: TEdit;
    pnlMessage: TPanel;
    lblSubject: TLabel;
    lblMessage: TLabel;
    txtSubject: TEdit;
    memMessage: TMemo;
    procedure btnReplyClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmReceiveMessage: TfrmReceiveMessage;

implementation

{$R *.dfm}

procedure TfrmReceiveMessage.btnReplyClick(Sender: TObject);
begin
  //Reply:

end;

end.
