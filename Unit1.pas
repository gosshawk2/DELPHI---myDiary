unit Unit1;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids;

type
  TForm1 = class(TForm)
    dbSelectGrid: TDBGrid;
    pnlTop: TPanel;
    btnClose: TBitBtn;
    pnlDetails: TPanel;
    btnSelect: TBitBtn;
    txtBrief: TEdit;
    lblBrief: TLabel;
    lblDate: TLabel;
    txtDate: TEdit;
    lblPrivateEntry: TLabel;
    txtTime: TEdit;
    txtPrivateEntry: TEdit;
    procedure lblPrivateEntryClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnSelectClick(Sender: TObject);
begin
  //User has chosen a row from the grid -
  //Now copy the record selected - to the corresponding entry fields on the
  //  diary entry form.

end;

procedure TForm1.lblPrivateEntryClick(Sender: TObject);
begin
  self.txtPrivateEntry.SetFocus;
end;

end.
