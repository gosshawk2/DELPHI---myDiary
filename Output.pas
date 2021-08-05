unit Output;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TfrmOutput = class(TForm)
    pnlTop: TPanel;
    btnClose: TButton;
    pnlOutput: TPanel;
    memOutput: TMemo;
    procedure btnCloseClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmOutput: TfrmOutput;

implementation

uses Main;

{$R *.dfm}

procedure TfrmOutput.btnCloseClick(Sender: TObject);
begin
  MainForm.CloseMDIChild(-1);
end;

end.
