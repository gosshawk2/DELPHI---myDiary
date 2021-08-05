unit Settings;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ExtCtrls;

type
  TfrmDatabaseOptions = class(TForm)
    Panel1: TPanel;
    Label1: TLabel;
    memOutput: TMemo;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDatabaseOptions: TfrmDatabaseOptions;

implementation

{$R *.dfm}

end.
