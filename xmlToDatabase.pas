unit xmlToDatabase;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, strUtils, myDatabaseClass_II;

type
  TfrmXmlToDatabase = class(TForm)
    pnlTop: TPanel;
    btnClose: TBitBtn;
    btnInsert: TBitBtn;
    btnSave: TBitBtn;
    btnCancel: TBitBtn;
    btnEdit: TBitBtn;
    TreeView1: TTreeView;
    dlgOpenXML: TOpenDialog;
    btnOpen: TBitBtn;
    memOriginal: TMemo;
    memOutput: TMemo;
    procedure btnInsertClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure btnOpenClick(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }
  public
    { Public declarations }
    TV: TTreeView;

    function GetContent(WholeString:string; Var StartTagPos:integer; var EndTagPos:integer; EndTagLength:integer):string;
    function GetFieldTag_Open(WholeEntry:string; var CloseBracketPos:integer; StartPos:integer=1):string;
    function GetFieldTag_Closed(WholeEntry:string; var CloseBracketPos:integer; StartPos:integer=1):string;
    function FindRootNode(ACaption: String; ATreeView: TTreeView): TTreeNode;
    function AddNode(ATREEVIEW: TTreeView; RootNodeName:string; ChildNodeName:string):TTreeView;
  end;

var
  frmXmlToDatabase: TfrmXmlToDatabase;

implementation

uses MAIN;

{$R *.dfm}

procedure TfrmXmlToDatabase.btnCloseClick(Sender: TObject);
begin
  MainForm.CloseMDIChild(-1);
end;

function TfrmXmlToDatabase.FindRootNode(ACaption: String; ATreeView: TTreeView): TTreeNode;
var LCount: Integer;
begin
  result := nil;
  LCount := 0;
  while (LCount < ATreeView.Items.Count) and (result = nil) do
  begin
    //if (Uppercase(ATreeView.Items.Item[LCount].Text) = Uppercase(ACaption)) and (ATreeView.Items.Item[LCount].Parent = nil) then
    if (Uppercase(ATreeView.Items.Item[LCount].Text) = Uppercase(ACaption)) then
      result := ATreeView.Items.Item[LCount];
    inc(LCount);
  end;
end;

function TfrmXmlToDatabase.AddNode(ATREEVIEW: TTreeView; RootNodeName:string; ChildNodeName:string):TTreeView;
var
  LDestNode: TTreeNode;
  Node: TTreeNode;
begin
  LDestNode := FindRootNode(RootNodeName, ATREEVIEW);
  if LDestNode <> nil then
  begin
    Node:= ATREEVIEW.Items.AddChild(LDestNode, ChildNodeName);
    Node.ImageIndex:= 0;
  end;
  Result:= ATREEVIEW;
end;

procedure TfrmXmlToDatabase.btnInsertClick(Sender: TObject);
var
  LineIDX: integer;
  TheFileName: string;
  FieldTagOpen: string;
  FieldTagClosed: string;
  CloseBracketPos1: integer;
  CloseBracketPos2: integer;
  LenOfClosedTag: integer;
  nextFieldTagOpen: string;
  nextFieldTagClosed: string;
  nextCloseBracketPos1: integer;
  nextCloseBracketPos2: integer;
  nextLenOfClosedTag: integer;
  LineOutput: string;
  LineEntry: string;
  nextLineEntry: string;
  Content: string;
  nextContent: string;
  ChildNodeName: string;
  RecIndex: integer;
  searchParentNodeName: string;
  RootNodeName: string;
  Node: TTreeNode;
begin
  //Insert xml file:
  //load xml file into a list then put into TTreeView component on the form:
  //From this - will be a lot easier to add it to the database - after reading
  //each tag / node within each record.
  if self.dlgOpenXML.Execute then begin
    //
    TheFileName:= self.dlgOpenXML.FileName;
    MainForm.EntryList:= TStringList.Create;
    try
      LineIDX:= 0;
      RecIndex:= 1;

      MainForm.EntryList.LoadFromFile(TheFileName);
      self.TreeView1.Items.BeginUpdate;
      //self.TV:= TTreeView.Create(self);
      try


        while LineIDX< MainForm.EntryList.Count do begin
          FieldTagOpen:= '';
          FieldTagClosed:= '';
          LenOfClosedTag:= 0;
          Content:= '';
          nextFieldTagOpen:= '';
          nextFieldTagClosed:= '';
          nextLenOfClosedTag:= 0;
          nextContent:= '';
          LineEntry:= MainForm.EntryList[LineIDX];
          memOriginal.Lines.Add(LineEntry);

          //OK can be taken one stage further:
          //Read all the tags into appropriate arrays.
          //need to store the postion of open and close bracket positions in
          // an array too - so index / element matches the corresponding tag
          // in its array.
          //content will also have its own array.
          //go through the stringlist - all lines first and create the arrays.

          //Example:
          //OpenTags[0] = <dates>
          //CloseTags[0] = ''
          //Content[0] = '' or everything between the <dates> and </dates> ?

          //OpenTags[1] = <dateentry>
          //CloseTags[1] = ''
          //Content[1] = '' or everything between <dateentry> and </dateentry> ?



          FieldTagOpen:= self.GetFieldTag_Open(LineEntry,CloseBracketPos1);
          FieldTagClosed:= self.GetFieldTag_Closed(LineEntry,CloseBracketPos2);
          LenOfClosedTag:= Length(FieldTagClosed);
          //FieldTagOpen and FieldTagClosed now return comma delim list of open
          //or closed tags. need to turn into an array.
          //This will also apply to EACH content between EACH of the multiple tags.
          Content:= self.GetContent(LineEntry,CloseBracketPos1,CloseBracketPos2,LenOfClosedTag);
          if LineIDX< MainForm.EntryList.Count-1 then begin
            //there was a delay here when line index was about 3 and a closed tag.
            nextLineEntry:= MainForm.EntryList[LineIDX+1];
            nextFieldTagOpen:= self.GetFieldTag_Open(nextLineEntry,nextCloseBracketPos1);
            nextFieldTagClosed:= self.GetFieldTag_Closed(nextLineEntry,nextCloseBracketPos2);
            nextLenOfClosedTag:= Length(nextFieldTagClosed);
            nextContent:= self.GetContent(nextLineEntry,nextCloseBracketPos1,nextCloseBracketPos2,nextLenOfClosedTag);

          end;
          if Uppercase(nextFieldTagOpen) = Uppercase('<DATES>') then begin
            ChildNodeName:= '<dates>';
            searchParentNodeName:= nextFieldTagOpen; //usually <dates>
            RootNodeName:= nextFieldTagOpen;
            Node:= self.TreeView1.Items.Add(nil,RootNodeName);
            Node.ImageIndex:= 0;
            //self.AddNode(self.TV,searchParentNodeName,ChildNodeName);
          end
          else begin

            if Uppercase(nextFieldTagOpen) = Uppercase('<DATEENTRY>') then begin
              //if the NEXT line is <dateentry>:
              ChildNodeName:= '<dateentry '+IntToStr(RecIndex)+'>';
              searchParentNodeName:= RootNodeName;
              //searchParentNodeName:= '<DATEENTRY'+IntToStr(RecIndex)+'>';
              self.TreeView1:= self.AddNode(self.TreeView1,searchParentNodeName,ChildNodeName);
              inc(RecIndex);
            end;
            if Uppercase(FieldTagClosed) = Uppercase('</DATEENTRY>') then begin
              //if the current line contains </dateentry>:

            end;
            if Uppercase(nextFieldTagOpen) = Uppercase('<DATE>') then begin
              searchParentNodeName:= '<dateentry '+IntToStr(RecIndex-1)+'>';
              ChildNodeName:= nextFieldTagOpen;
              self.TreeView1:= self.AddNode(self.TreeView1,searchParentNodeName,ChildNodeName);
            end;
            if Uppercase(FieldTagOpen) = Uppercase('<DATE>') then begin
              searchParentNodeName:= FieldTagOpen;
              if Length(Content)>0 then
                ChildNodeName:= Content
              else
                ChildNodeName:= 'No Date';
              self.TreeView1:= self.AddNode(self.TreeView1,searchParentNodeName,ChildNodeName);
            end;

            if Uppercase(nextFieldTagOpen) = Uppercase('<TIME>') then begin
              searchParentNodeName:= '<dateentry '+IntToStr(RecIndex-1)+'>';
              ChildNodeName:= nextFieldTagOpen;
              self.TreeView1:= self.AddNode(self.TreeView1,searchParentNodeName,ChildNodeName);
            end;
            if Uppercase(FieldTagOpen) = Uppercase('<TIME>') then begin
              searchParentNodeName:= FieldTagOpen;
              if Length(Content)>0 then
                ChildNodeName:= Content
              else
                ChildNodeName:= 'No Time';
              self.TreeView1:= self.AddNode(self.TreeView1,searchParentNodeName,ChildNodeName);
            end;

            if Uppercase(nextFieldTagOpen) = Uppercase('<ENTRY>') then begin
              searchParentNodeName:= '<dateentry '+IntToStr(RecIndex-1)+'>';
              ChildNodeName:= nextFieldTagOpen;
              self.TreeView1:= self.AddNode(self.TreeView1,searchParentNodeName,ChildNodeName);
            end;
            if Uppercase(FieldTagOpen) = Uppercase('<ENTRY>') then begin
              searchParentNodeName:= FieldTagOpen;
              if Length(Content)>0 then
                ChildNodeName:= Content
              else
                ChildNodeName:= 'No Entry';
              self.TreeView1:= self.AddNode(self.TreeView1,searchParentNodeName,ChildNodeName);
            end;

            LineOutput:= FieldTagOpen+Content+FieldTagClosed;
            memOutput.Lines.Add(LineOutput);
          end;
          inc(LineIDX);
        end; //while
      finally


      end;
    finally
      //end of StringList creation.
      self.TreeView1.Items.EndUpdate;
    end;
  end;
end;

procedure TfrmXmlToDatabase.btnOpenClick(Sender: TObject);
var
  Filename: string;
begin
  if self.dlgOpenXML.Execute then begin
    //Depends on actual file itself to ascertain levels.
    Filename:= self.dlgOpenXML.FileName;
    TreeView1.LoadFromFile(Filename);
    TreeView1.Show;
  end;

end;

procedure TfrmXmlToDatabase.btnSaveClick(Sender: TObject);
begin
  //save clicked: save to database.

end;

procedure TfrmXmlToDatabase.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action:= caFree;
end;

function TfrmXmlToDatabase.GetContent(WholeString: string;
  var StartTagPos: integer; var EndTagPos: integer; EndTagLength: integer): string;
var
  TheContent: string;
  LengthOfContent: integer;
  EndPos: integer;
begin
  //Get Content between the open and closed tags:
  //1) Between Open and Closed tags - if they exist on same line:
  TheContent:= '';
  if Length(WholeString)>0 then begin

    if (StartTagPos>0) AND (EndTagPos>0) then begin
      LengthOfContent:= EndTagPos-EndTagLength-StartTagPos;
      if LengthOfContent>0 then
        TheContent:= Copy(WholeString,StartTagPos+1,LengthOfContent);
    end;

    if (StartTagPos=0) AND (EndTagPos=0) then //NO TAGS in line
      TheContent:= WholeString;

    if (StartTagPos>0) AND (EndTagPos=0) then //just Open Tag on one line:
      TheContent:= Copy(WholeString,StartTagPos+1,Length(WholeString));

    if (StartTagPos=0) AND (EndTagPos>0) then begin //just Close Tag on one line:
      EndPos:= EndTagPos-EndTagLength;
      LengthOfContent:= EndPos;

      if LengthOfContent>0 then
        TheContent:= Copy(WholeString,1,LengthOfContent);
    end;
  end;
  Result:= TheContent;
end;

function TfrmXmlToDatabase.GetFieldTag_Open(WholeEntry: string;
   var CloseBracketPos: integer; StartPos: integer): string;

var
  OpenBracketPos:integer;
  LengthOfTag:integer;
  FieldTag:string;
  ForwardSlashPos:integer;
  TagArray: TStrArray;
  Tagidx: integer;
  PosIDX: integer;
  Strings: TUsefulRoutines;
begin
  //Get Open Tag NAme:
  //need to store bracket positions in an array - else it should record
  // the first close bracket position (not the last as would do here).
  Strings:= TUsefulRoutines.Create;
  FieldTag:= '';
  try
    Tagidx:= 0;
    if StartPos>0 then
      PosIDX:=StartPos
    else
      PosIDX:= 1;
    OpenBracketPos:= PosEx('<',WholeEntry,PosIDX);
    CloseBracketPos:= PosEx('>',WholeEntry,PosIDX);
    ForwardSlashPos:= PosEx('/',WholeEntry,PosIDX+1);

    while OpenBracketPos>0 do begin
      OpenBracketPos:= PosEx('<',WholeEntry,PosIDX);
      CloseBracketPos:= PosEx('>',WholeEntry,PosIDX);
      ForwardSlashPos:= PosEx('/',WholeEntry,PosIDX+1);
      if (OpenBracketPos>0) AND (CloseBracketPos>0) then begin
        if NOT (ForwardSlashPos = OpenBracketPos+1) then begin
          LengthOfTag:= (CloseBracketPos+1)-OpenBracketPos;
          FieldTag:= Copy(WholeEntry,OpenBracketPos,LengthOfTag);
          SetLength(TagArray,Length(TagArray)+1);
          TagArray[Tagidx]:= FieldTag;
          Tagidx:= Tagidx+1;


        end;

      end;
      PosIDX:= CloseBracketPos+1;

    end;

    //what if we have two open brackets on same line ?
    //or open tag and close tag and then another open tag and close tag ?
    FieldTag:= Strings.StringArrayToString(TagArray,',');

  finally
    Strings.Destroy;
  end;
  Result:= FieldTag;
end;

function TfrmXmlToDatabase.GetFieldTag_Closed(WholeEntry: string;
   var CloseBracketPos: integer; StartPos: integer): string;
var
  OpenBracketPos:integer;
  LengthOfTag:integer;
  FieldTag:string;
  ForwardSlashPos:integer;
  TagArray: TStrArray;
  Tagidx: integer;
  PosIDX: integer;
  Strings: TUsefulRoutines;
begin
  //Get Closed Tag Names:
  FieldTag:= '';
  Strings:= TUsefulRoutines.Create;
  try
    Tagidx:= 0;
    if StartPos>0 then
      PosIDX:=StartPos
    else
      PosIDX:= 1;
    OpenBracketPos:= PosEx('<',WholeEntry,PosIDX);
    CloseBracketPos:= PosEx('>',WholeEntry,PosIDX);
    ForwardSlashPos:= PosEx('/',WholeEntry,PosIDX+1);

    while ForwardSlashPos>0 do begin
      OpenBracketPos:= PosEx('<',WholeEntry,PosIDX);
      CloseBracketPos:= PosEx('>',WholeEntry,PosIDX);
      ForwardSlashPos:= PosEx('/',WholeEntry,PosIDX+1);
      if (OpenBracketPos>0) AND (CloseBracketPos>0) then begin
        if ForwardSlashPos>0 then begin
          LengthOfTag:= (CloseBracketPos+1)-OpenBracketPos;
          FieldTag:= Copy(WholeEntry,OpenBracketPos,LengthOfTag);
          SetLength(TagArray,Length(TagArray)+1);
          TagArray[Tagidx]:= FieldTag;
          Tagidx:= Tagidx+1;


        end; //if NOT

      end; //if CloseBracketPos>0
      PosIDX:= CloseBracketPos+1;
    end; //while

    FieldTag:= Strings.StringArrayToString(TagArray,',');

  finally
    Strings.Destroy;
  end;
  Result:= FieldTag;
end;

end.
