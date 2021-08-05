unit EntrySelection;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, myDatabaseClass_II, Data.DB;

type
  THackDBGrid = class(TDBGrid);
  TfrmGridSelection = class(TForm)
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
    txtMessage1: TEdit;
    txtRecNo: TEdit;
    procedure lblPrivateEntryClick(Sender: TObject);
    procedure btnSelectClick(Sender: TObject);
    procedure dbSelectGridCellClick(Column: TColumn);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    RecordID: string;
  end;

var
  frmGridSelection: TfrmGridSelection;

implementation

uses Main;

{$R *.dfm}

procedure TfrmGridSelection.btnCloseClick(Sender: TObject);
begin
  MainForm.CloseMDIChild(-1);
end;

procedure TfrmGridSelection.btnSelectClick(Sender: TObject);
begin
  //User has chosen a row from the grid -
  //Now copy the record selected - to the corresponding entry fields on the
  //  diary entry form.

end;

procedure TfrmGridSelection.dbSelectGridCellClick(Column: TColumn);
var
  Rowidx:integer;
  Colidx: integer;
  DateOfEntry: string;
  RecID: integer;
  ConStr: widestring;
  TableName: string;
  idField: string;
begin
  TableName:= 'dailydiary';
  Rowidx:= THackDBGrid(dbSelectGrid).Row;
  Colidx:= THackDBGrid(dbSelectGrid).Col;
  ConStr:= MainForm.MainConnection.ConnString;
  self.txtRecNo.Text:= self.RecordID;
  if Length(self.RecordID)>0 then begin
    //find primary key field name:
    //function TDBOperations.GetFieldnamesOfTypesPassed(TableName:string; FieldType:string; conStr:WideString):string;
    idField:= MainForm.MainConnection.DBOperations.GetFieldnamesOfTypesPassed(TableName,'ftAutoInc',conStr);
    RecID:= MainForm.MainConnection.DBOperations.SearchField(TableName,conStr,idField,RecordID,
      True,False);
    DateOfEntry:= MainForm.MainConnection.DBOperations.GetSingleRecArray(TableName,ConStr,'DateOfEntry');
    self.txtMessage1.Text:= DateOfEntry;
    //quantitybought:= MainForm.MainConnection.DBOperations.GetSingleRecArray(TableName,conStr,'QuantityBought');
    //self.txtQuantityBought.Text:= quantitybought;

  end;
end;

procedure TfrmGridSelection.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

procedure TfrmGridSelection.lblPrivateEntryClick(Sender: TObject);
begin
  self.txtPrivateEntry.SetFocus;
end;

end.
