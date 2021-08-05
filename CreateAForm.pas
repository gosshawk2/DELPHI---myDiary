unit CreateAForm;

//Unit CreateAForm for DelphiRichardProject to test and experiment with database handling.
//Written by Daniel Goss - copyright May - July 2012
//version 1.1.0.145 Tuesday July 24th 2012
//Amended: Added MDB functionality and changed name of property from ShowLogin to LoginForm
//Last Amendment: 17 Sep 2012 - added funtion to get Method code and data.
//Last Addition: 27 Jul 2014 - added comment to allow formstyle to be chosen eg fsMDIChild / fsNormal

interface

uses Dialogs, Classes, sysUtils, strUtils, Forms, Variants, Controls,
  StdCtrls, Buttons, ExtCtrls, Contnrs, Graphics, Windows;

type TstrArray = Array of String;
type TObjectArray = Array of TObject;

type TControlOptions = class
  private
    FControlType: TControl; //TLabel, TEdit
    FControlTypeName: string; //TLabel, TEdit as a string
    FControlName: string;   //txtLastname
    FCurrentIDX: integer;
    FMaxControls: integer;
    FControlList: TStrings; //could have procedure EditControlAttributes - reAssign values
    FControlFields: TstrArray;
    FControlValues: TstrArray;
    FParent: TWinControl;
    FEntries: string; //used to store user entry in TEdit boxes etc.
    FObjects: TObjectArray;
    FItems: TStrings;
    FItemIndex: integer;
    FClass: Pointer;
    FData: Pointer;
    procedure SetControlAttributes(ControlType: string; SetupOptions: TStrings);
    procedure ExtractAttributes(Attributes:TStrings);
    procedure Setup_TLabel(Owner: TWinControl);
    procedure Setup_TEdit(Owner: TWinControl);
    procedure Setup_TBitBtn(Owner: TWinControl);
    procedure Setup_TGroupBox(Owner: TWinControl);
    procedure Setup_TRadioButton(Owner: TWinControl);
    procedure Setup_TPanel(Owner: TWinControl);
    procedure Setup_TComboBox(Owner: TWinControl);
    procedure Setup_TMemo(Owner: TWinControl);
  protected
    procedure ComboClickHandler(Sender: TObject);virtual;abstract;
  public
    //public members
    constructor Create(Owner: TWinControl; ControlType: string; SetupOptions: TStrings );
    destructor Destroy; override;
    procedure AddControls(Owner: TWinControl; ControlType: string; SetupOptions: TStrings);
    procedure ClickHandlerAddServer(Sender: TObject);
    procedure SetClassPointer(ptrClass:Pointer);
    procedure SetDataPointer(ptrData:Pointer);
    function GetColor(theColour:string):TColor;
    function GetControl:TControl;
    function GetControlName:string;
    function GetControlTypeName:string;
    function GetControlFields:TstrArray;
    function GetControlValues:TstrArray;
    function GetEntries: string;
    function GetTWinControl(ParentControlType: TWinControl; WinControl: string; VAR ParentControl:TWinControl):Boolean;
    function GetClassPointer: Pointer;
    function GetDataPointer: Pointer;
  published
    //RTTI members
    function GetNotifyEventName(const EventName:string; Sender:Pointer):TNotifyEvent;
    property ControlFields:TstrArray read GetControlFields;
    property ControlValues:TstrArray read GetControlValues;
  end; {class TControlOptions}

type TNewControlOptions = class(TControlOptions)
  private
    FData:integer;
  protected
    procedure ComboClickHandler(Sender: TObject);override;
  public
    function GetNotifyEventName(const EventName:string; Sender:Pointer):TNotifyEvent;
    procedure ClickHandlerAddServer(Sender: TObject);
  end;

type TControlList = class(TObjectList)
  private
    FTotalItems: integer;
  protected
    procedure SetControl(I: integer; AControl: TControlOptions);
    function GetControl(I: integer): TControlOptions;
    function GetTotalItems:integer;
  public
    constructor Create;
    function Add(objControl: TControlOptions):integer;
    function IndexOf(objControl:TControlOptions):integer;
    procedure Insert(Index:integer; objControl:TControlOptions);
    function Remove(objControl:TcontrolOptions):integer;
    property Items[I: integer]: TControlOptions
      read GetControl write SetControl;
    procedure IncrementItems;
  end; {TControlList}

type TCreateForm = class
  private
    //Private declarations
    FMaxObjects: integer;
    FObjectList: TList;
    FAttributes: TStrings;
    FVariantArray: Variant;
    FForm: TForm;
    FFormID: integer;
    FVisualControl: TControl;
    FControlList: TControlList;
    FOnClick: TNotifyEvent;
  protected
    function SetOnClickEvent(EventName:string):TNotifyEvent;virtual;
  public
    //publish declarations
    function GetVariantArray: Variant;
    function GetForm: TForm;
    function GetColor(theColour:string):TColor;
    procedure SetForm(TheForm: TForm);
    procedure ClickHandlerAddServer(Sender: TObject);
    //procedure SetControlList(ListControl:
    constructor Create(FormName,FormCaption:string); overload;
    constructor Create(FormName,FormCaption:string; FormID:integer); overload;
    function GetTextEntry(Tag:Integer):string; //pass 0 as Tag to get list of entries for DB entry.
    function GetEntryByName(ControlName:string):string;
    function GetRadiobuttonTag:integer;
    function GetRadiobuttonName:string;
    function GetComboSelection(Tag:integer):string;
    function GetOnClickName(Sender:Pointer;ControlName,EventName:string):TNotifyEvent;
  published
    //published declarations
    //read FOnClick but write SetOnClickEvent(sender: TObject);virtual;abstract;
    constructor Create(FormName,FormCaption:string; FormID:integer; XPos,YPos,FormWidth,FormHeight:integer); overload;
    destructor Destroy; override;
    property Form: TForm read GetForm write SetForm;
    property ControlList: TControlList read FControlList write FControlList;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    function GetNotifyEventName(const EventName:string):TNotifyEvent;
  end;

  type TCreateScrollBox = class
  private
    //Private declarations
    FMaxObjects: integer;
    FObjectList: TList;
    FAttributes: TStrings;
    FVariantArray: Variant;
    fbox: TScrollbox;
    fboxID: integer;
    FVisualControl: TControl;
    FControlList: TControlList;
    FOnClick: TNotifyEvent;
  protected
    function SetOnClickEvent(EventName:string):TNotifyEvent;virtual;
  public
    //publish declarations
    function GetVariantArray: Variant;
    function GetBox: TScrollbox;
    function GetColor(theColour:string):TColor;
    procedure SetBox(TheScrollbox: TScrollbox);
    procedure ClickHandlerAddServer(Sender: TObject);
    //procedure SetControlList(ListControl:
    function GetTextEntry(Tag:Integer):string;overload; //pass 0 as Tag to get list of entries for DB entry.
    function GetTextEntry(ControlName: string): string;overload;
    function GetEntryByName(ControlName:string):string;
    function GetRadiobuttonTag:integer;
    function GetRadiobuttonName:string;
    function GetComboSelection(Tag:integer):string;
    function GetOnClickName(Sender:Pointer;ControlName,EventName:string):TNotifyEvent;
  published
    //published declarations
    //read FOnClick but write SetOnClickEvent(sender: TObject);virtual;abstract;
    constructor Create(sbName,sbCaption:string; sbID:integer; XPos,YPos,sboxWidth,sboxHeight:integer); overload;
    destructor Destroy; override;
    property sbox: TScrollbox read GetBox write SetBox;
    property ControlList: TControlList read FControlList write FControlList;
    property OnClick: TNotifyEvent read FOnClick write FOnClick;
    function GetNotifyEventName(const EventName:string):TNotifyEvent;
  end;

implementation

constructor TCreateForm.Create(FormName,FormCaption:string);
begin
  //Setup variables and initialisation
  FVariantArray:= VarArrayCreate([0, Length(FVariantArray)+1], varVariant);
  FForm:= TForm.Create(nil);
  try
    FForm.Caption:= FormCaption;
    FForm.Name:= FormName;
    FFormID:=-1;
    FControlList:= TControlList.Create;
  finally
    //VarClear(FVariantArray);
  end; {try .. finally}

end; {constructor1}

constructor TCreateForm.Create(FormName,FormCaption:string; FormID:integer);
begin
  //Setup variables and initialisation
  FVariantArray:= VarArrayCreate([0, Length(FVariantArray)+1], varVariant);
  FForm:= TForm.Create(nil);
  try
    if Length(FormName)>0 then begin
      FForm.Name:= FormName;
    end;
    FForm.Caption:= FormCaption;
    FFormID:= FormID;
    FControlList:= TControlList.Create;
  finally
    //VarClear(FVariantArray);
  end; {try .. finally}

end; {constructor2}

constructor TCreateForm.Create(FormName,FormCaption:string; FormID:integer; XPos,YPos,FormWidth,FormHeight:integer);
begin
  FVariantArray:= VarArrayCreate([0, Length(FVariantArray)+1], varVariant);
  FForm:= TForm.Create(nil);
  try
    if Length(FormName)>0 then begin
      FForm.Name:= FormName;
    end;
    FForm.Caption:= FormCaption;
    FFormID:= FormID;
    FForm.Left:= XPos;
    FForm.Top:= YPos;
    FForm.Width:= FormWidth;
    FForm.Height:= FormHeight;
    FControlList:= TControlList.Create;
    //FForm.FormStyle:= fsNormal / fsMDIChild  / fsMDIForm
  finally
    //VarClear(FVariantArray);
  end; {try .. finally}
end; {constructor3}


destructor TCreateForm.Destroy;
var
  IDX: integer;
begin
  //free up space occupied by variant array - holds all objects
  //FList holds the contents of the object variant array
  IDX:=self.ControlList.GetTotalItems-1; //Items start at index 0 [0] not [1]
  While IDX>0 do begin
    self.ControlList.Items[idx].Destroy;
    dec(IDX);
  end;
  //incompatible types = if FVariantArray<>nil then FreeAndNil(FVariantArray);
  if FControlList <> nil then FreeAndNil(FControlList);
  if FForm <> nil then FreeAndNil(FForm);
end;

function TCreateForm.GetVariantArray: Variant;
begin
//
end;

procedure TCreateForm.ClickHandlerAddServer(Sender: TObject);
begin
  ShowMessage('TCreateForm Click Handler for Add Server');
end;

function TCreateForm.GetTextEntry(Tag:Integer):string;
var
  IDX:integer;
  TotalItems:integer;
  TheControl:TControl;
  Entry:string;
begin
  IDX:=0;
  Entry:='';
  TotalItems:= self.ControlList.GetTotalItems;
  //ControlCount-1 also works
  while IDX <= TotalItems-1 do begin
    TheControl:= self.ControlList.Items[IDX].GetControl;
    if (TheControl is TEdit) then begin
      if (Tag>0) then begin
        if (TheControl.Tag = Tag) then begin
          Result:= TEdit(TheControl).Text;
          exit;
        end;
      end
      else begin
        if Length(Entry)=0 then Entry:= TEdit(TheControl).Text
        else Entry:= Entry+','+TEdit(TheControl).Text;
      end; {if Tag>0}
    end; {if TheControl is TEdit}
    inc(IDX);
  end; {while}
  Result:= Entry;
end; {GetTextEntry(Tag):string}

function TCreateForm.GetEntryByName(ControlName:string):string;
var
  IDX:integer;
  TotalItems:integer;
  TheControl:TControl;
  Entry:string;
begin
  IDX:=0;
  Entry:='';
  TotalItems:= self.ControlList.GetTotalItems;
  //ControlCount-1 also works
  while IDX <= TotalItems-1 do begin
    TheControl:= self.ControlList.Items[IDX].GetControl;
    if (TheControl.Name = ControlName) then
      if TheControl is TLabel then
        Entry:= TLabel(TheControl).Caption;
      if TheControl is TEdit then
        Entry:= TEdit(TheControl).Text;
      if TheControl is TBitBtn then
        Entry:= TBitBtn(TheControl).Caption;
    inc(IDX);
  end; {while}
  Result:= Entry;
end; {GetTextEntry(Tag):string}

function TCreateForm.GetRadiobuttonTag:integer;
var
  IDX:integer;
  TotalItems:integer;
  TheControl:TControl;
  Tag:Integer;
begin
  IDX:=0;
  TotalItems:= self.ControlList.GetTotalItems;
  //ControlCount-1 also works
  while IDX <= TotalItems-1 do begin
    TheControl:= self.ControlList.Items[IDX].GetControl;
    if (TheControl is TRadiobutton) then begin
      if TRadioButton(TheControl).Checked then begin
        Result:= TheControl.Tag;
        exit;
      end;
    end; {if TheControl is TRadiobutton}
    inc(IDX);
  end; {while}
  Result:= 0;
end; {GetRadiobuttonTag:integer}

function TCreateForm.GetRadiobuttonName:String;
var
  IDX:integer;
  TotalItems:integer;
  TheControl:TControl;
  Tag:Integer;
begin
  IDX:=0;
  TotalItems:= self.ControlList.GetTotalItems;
  //ControlCount-1 also works
  while IDX <= TotalItems-1 do begin
    TheControl:= self.ControlList.Items[IDX].GetControl;
    if (TheControl is TRadiobutton) then begin
      if TRadioButton(TheControl).Checked then begin
        Result:= TheControl.Name;
        exit;
      end;
    end; {if TheControl is TRadiobutton}
    inc(IDX);
  end; {while}
  Result:= '';
end; {GetRadiobuttonTag:integer}

function TCreateForm.GetOnClickName(Sender:Pointer;ControlName,EventName:string):TNotifyEvent;
var
  idx:integer;
  TotalItems:integer;
  TheControl:TControl;
  Event:TNotifyEvent;
begin
  idx:=0;
  TotalItems:= self.ControlList.GetTotalItems;
  Event:=nil;
  while idx<= TotalItems-1 do begin
    TheControl:= self.ControlList.Items[idx].GetControl;
    if TheControl.Name = ControlName then begin
      TMethod(Event).Code:= MethodAddress(EventName);
      TMethod(Event).Data:= Sender;
      //Event:= self.GetNotifyEventName(EventName);

      if TheControl is TBitBtn then
        TBitBtn(TheControl).OnClick:= Event;
      if TheControl is TCombobox then
        TCombobox(TheControl).OnClick:= Event;

    end; {if}
  end; {while}
  Result:= Event;
end; {TCreateForm.GetOnClickName}

function TCreateForm.SetOnClickEvent(EventName:string):TNotifyEvent;
var
  TempEvent: TNotifyEvent;
  myProc: TControlOptions;
begin
  TempEvent:= Self.GetNotifyEventName(EventName);
  ShowMessage('virtual world!');
  Result:= TempEvent;
end;

function TCreateForm.GetNotifyEventName(const EventName:string):TNotifyEvent;
var
  TempEvent: TNotifyEvent;
begin
  //return TNotifyEvent procedure from name given ?
  TMethod(TempEvent).Code:= MethodAddress(EventName);
  TMethod(TempEvent).Data:= self; //the data in TCreateForm
  Result:= TempEvent;
end;

function TCreateForm.GetForm:TForm;
begin
  Result:= FForm;
end;

procedure TCreateForm.SetForm(TheForm: TForm);
begin
  FForm:= TheForm;
end;

function TCreateForm.GetColor(theColour:string):TColor;
 var
    r,g,b : Byte;
    color : TColor;
    ledRed,ledGreen,ledBlue: string;
    commaPos1,commaPos2: integer;
 begin
    //201,77,5
    commaPos1:= PosEx(',',theColour,1);
    ledRed:= copy(theColour,1,commaPos1-1);
    commaPos2:= PosEx(',',theColour,commaPos1+1);
    ledGreen:= copy(theColour,commaPos1+1,(commaPos2-(commaPos1+1)));
    ledBlue:= copy(theColour,commaPos2+1,length(theColour));
    r := StrToInt(ledRed) ;
    g := StrToInt(ledGreen) ;
    b := StrToInt(ledBlue) ;

    color := RGB(r, g, b) ;
    Result:= color;
    //Shape1.Brush.Color := color;
 end;

function TCreateForm.GetComboSelection(Tag:integer):string;
var
  IDX:integer;
  TotalItems:integer;
  TheControl:TControl;
  Entry:string;
  Choice:integer;
begin
  IDX:=0;
  Entry:='';
  TotalItems:= self.ControlList.GetTotalItems;
  //ControlCount-1 also works
  while IDX <= TotalItems-1 do begin
    TheControl:= self.ControlList.Items[IDX].GetControl;
    if (TheControl is TComboBox) then begin
      if (Tag>0) then begin
        if (TheControl.Tag = Tag) then begin

          Choice:= TComboBox(TheControl).ItemIndex;
          Entry:= TComboBox(TheControl).Items[Choice];
          Result:= Entry;
          exit;
        end;
      end; {if Tag>0}
    end; {if TheControl is TEdit}
    inc(IDX);
  end; {while}
  Result:= Entry;
end; {GetComboSelection(Tag):string}

{ TCreateScrollBox }

procedure TCreateScrollBox.ClickHandlerAddServer(Sender: TObject);
begin
  //
end;

constructor TCreateScrollBox.Create(sbName, sbCaption: string; sbID, XPos, YPos,
  sboxWidth, sboxHeight: integer);
begin
  //Create the SCROLLBOX:
  FVariantArray:= VarArrayCreate([0, Length(FVariantArray)+1], varVariant);
  fbox:= TScrollBox.Create(nil);
  try
    if Length(sbName)>0 then begin
      fbox.Name:= sbName;
    end;
    fboxID:= sbID;
    fbox.Left:= XPos;
    fbox.Top:= YPos;
    fbox.Width:= sboxWidth;
    fbox.Height:= sboxHeight;
    FControlList:= TControlList.Create;
    //FForm.FormStyle:= fsNormal / fsMDIChild  / fsMDIForm
  finally
    //VarClear(FVariantArray);
  end; {try .. finally}
end;

destructor TCreateScrollBox.Destroy;
var
  IDX: integer;
begin
  //free up space occupied by variant array - holds all objects
  //FList holds the contents of the object variant array
  IDX:=self.ControlList.GetTotalItems-1; //Items start at index 0 [0] not [1]
  While IDX>0 do begin
    self.ControlList.Items[idx].Destroy;
    dec(IDX);
  end;
  //incompatible types = if FVariantArray<>nil then FreeAndNil(FVariantArray);
  if FControlList <> nil then FreeAndNil(FControlList);
  if fbox <> nil then FreeAndNil(fbox);
  inherited;
end;

function TCreateScrollBox.GetBox: TScrollbox;
begin
  //
  Result:= fbox;
end;

function TCreateScrollBox.GetColor(theColour: string): TColor;
var
    r,g,b : Byte;
    color : TColor;
    ledRed,ledGreen,ledBlue: string;
    commaPos1,commaPos2: integer;
 begin
    //201,77,5
    commaPos1:= PosEx(',',theColour,1);
    ledRed:= copy(theColour,1,commaPos1-1);
    commaPos2:= PosEx(',',theColour,commaPos1+1);
    ledGreen:= copy(theColour,commaPos1+1,(commaPos2-(commaPos1+1)));
    ledBlue:= copy(theColour,commaPos2+1,length(theColour));
    r := StrToInt(ledRed) ;
    g := StrToInt(ledGreen) ;
    b := StrToInt(ledBlue) ;

    color := RGB(r, g, b) ;
    Result:= color;
    //Shape1.Brush.Color := color;
end;

function TCreateScrollBox.GetComboSelection(Tag: integer): string;
var
  IDX:integer;
  TotalItems:integer;
  TheControl:TControl;
  Entry:string;
  Choice:integer;
begin
  //
  IDX:=0;
  Entry:='';
  TotalItems:= self.ControlList.GetTotalItems;
  //ControlCount-1 also works
  while IDX <= TotalItems-1 do begin
    TheControl:= self.ControlList.Items[IDX].GetControl;
    if (TheControl is TComboBox) then begin
      if (Tag>0) then begin
        if (TheControl.Tag = Tag) then begin

          Choice:= TComboBox(TheControl).ItemIndex;
          Entry:= TComboBox(TheControl).Items[Choice];
          Result:= Entry;
          exit;
        end;
      end; {if Tag>0}
    end; {if TheControl is TEdit}
    inc(IDX);
  end; {while}
  Result:= Entry;
end;

function TCreateScrollBox.GetEntryByName(ControlName: string): string;
begin
  //
end;

function TCreateScrollBox.GetNotifyEventName(
  const EventName: string): TNotifyEvent;
begin
  //
end;

function TCreateScrollBox.GetOnClickName(Sender: Pointer; ControlName,
  EventName: string): TNotifyEvent;
begin
  //
end;

function TCreateScrollBox.GetRadiobuttonName: string;
var
  IDX:integer;
  TotalItems:integer;
  TheControl:TControl;
  Tag:Integer;
begin
  IDX:=0;
  TotalItems:= self.ControlList.GetTotalItems;
  //ControlCount-1 also works
  while IDX <= TotalItems-1 do begin
    TheControl:= self.ControlList.Items[IDX].GetControl;
    if (TheControl is TRadiobutton) then begin
      if TRadioButton(TheControl).Checked then begin
        Result:= TheControl.Name;
        exit;
      end;
    end; {if TheControl is TRadiobutton}
    inc(IDX);
  end; {while}
  Result:= '';
end;

function TCreateScrollBox.GetRadiobuttonTag: integer;
var
  IDX:integer;
  TotalItems:integer;
  TheControl:TControl;
  Tag:Integer;
begin
  IDX:=0;
  TotalItems:= self.ControlList.GetTotalItems;
  //ControlCount-1 also works
  while IDX <= TotalItems-1 do begin
    TheControl:= self.ControlList.Items[IDX].GetControl;
    if (TheControl is TRadiobutton) then begin
      if TRadioButton(TheControl).Checked then begin
        Result:= TheControl.Tag;
        exit;
      end;
    end; {if TheControl is TRadiobutton}
    inc(IDX);
  end; {while}
  Result:= 0;
end;

function TCreateScrollBox.GetTextEntry(Tag: Integer): string;
var
  IDX:integer;
  TotalItems:integer;
  TheControl:TControl;
  Entry:string;
begin
  IDX:=0;
  Entry:='';
  TotalItems:= self.ControlList.GetTotalItems;
  //ControlCount-1 also works
  while IDX <= TotalItems-1 do begin
    TheControl:= self.ControlList.Items[IDX].GetControl;
    if (TheControl is TEdit) then begin
      if (Tag>0) then begin
        if (TheControl.Tag = Tag) then begin
          Result:= TEdit(TheControl).Text;
          exit;
        end;
      end
      else begin
        if Length(Entry)=0 then Entry:= TEdit(TheControl).Text
        else Entry:= Entry+','+TEdit(TheControl).Text;
      end; {if Tag>0}
    end; {if TheControl is TEdit}
    inc(IDX);
  end; {while}
  Result:= Entry;
end;

function TCreateScrollBox.GetTextEntry(ControlName: string): string;
var
  IDX:integer;
  TotalItems:integer;
  TheControl:TControl;
  Entry:string;
begin
  IDX:=0;
  Entry:='';
  TotalItems:= self.ControlList.GetTotalItems;
  //ControlCount-1 also works
  while IDX <= TotalItems-1 do begin
    TheControl:= self.ControlList.Items[IDX].GetControl;
    if (TheControl is TEdit) then begin
      if Length(ControlName)>0 then begin
        if (TheControl.Name = ControlName) then begin
          Result:= TEdit(TheControl).Text;
          exit;
        end;
      end
      else begin
        //if passing an empty string into this function then
        //return ALL the text from every TEdit control in the scrollbox !!
        if Length(Entry)=0 then Entry:= TEdit(TheControl).Text
        else Entry:= Entry+','+TEdit(TheControl).Text;
      end; {if Tag>0}
    end; {if TheControl is TEdit}
    inc(IDX);
  end; {while}
  Result:= Entry;
end;

function TCreateScrollBox.GetVariantArray: Variant;
begin
  //
end;

procedure TCreateScrollBox.SetBox(TheScrollbox: TScrollbox);
begin
  //
  fbox:= TheScrollbox;
end;

function TCreateScrollBox.SetOnClickEvent(EventName: string): TNotifyEvent;
var
  TempEvent: TNotifyEvent;
  myProc: TControlOptions;
begin
  TempEvent:= Self.GetNotifyEventName(EventName);
  ShowMessage('virtual Scrollbox world!');
  Result:= TempEvent;
end;


function TControlOptions.GetTWinControl(ParentControlType: TWinControl; WinControl: string; VAR ParentControl:TWinControl):Boolean;
var
  TheWinControl: TWinControl;
  AComponent: TComponent;
begin
  Result:= false;
  AComponent:= ParentControlType.FindComponent(WinControl);
  if (Assigned(AComponent)) AND (AComponent is TWinControl) then begin
    ParentControl:= TWinControl(AComponent);

    Result:= True;
  end;
end;

procedure TControlOptions.SetControlAttributes(ControlType: string; SetupOptions: TStrings);
var
  ListIDX: integer;
  ListItem: string;
  ctrlField: string;
  ctrlValue: string;
  EqualPos: integer;
begin
//Private procedure to set the control attributes passed for FControlType

end; {TControlOptions.SetControlAttributes}

function TControlOptions.GetEntries: string;
begin
  Result:= FEntries;
end; {GetEntries}

procedure TControlOptions.ClickHandlerAddServer(Sender: TObject);
begin
  ShowMessage('TControlOptions = Click Handler for Add Server');
end;

procedure TControlOptions.SetClassPointer(ptrClass:Pointer);
begin
  FClass:= ptrClass;
end;

procedure TControlOptions.SetDataPointer(ptrData:Pointer);
begin
  FData:= ptrData;
end;

function TControlOptions.GetClassPointer: Pointer;
begin
  Result:= FClass;
end;

function TControlOptions.GetDataPointer: Pointer;
begin
  Result:= FData;
end;

procedure TNewControlOptions.ClickHandlerAddServer(Sender: TObject);
begin
  ShowMessage('Click Handler for TNewControlOptions.Add Server');
end;

procedure TNewControlOptions.ComboClickHandler(Sender: TObject);
var
  ResultString:string;
begin
  //Need to derive a class from TControlOptions and rename this protected procedure.
  //THIS GETS CALLED !!! Sender.ClassName returns TBitBtn as a string !!!
  //TBitBtn(Sender).Name returns the name of the button - btnSubmit or btnCancel for example
  ShowMessage('comboClickHandler');
  if Sender is TBitBtn then begin
    ShowMessage('NewControlOptions:Its a bit Button:'+Sender.ClassName+', '+TBitBtn(Sender).Name);
    //get entry and put into string array belonging to TControlOptions.
    //GetFEntries contains delimited string of text entries - TESTED 04.50 20-JUL-2012
    //21-July-2012 - may not be required within TControlOptions as chicken before egg situation.
    ResultString:= self.GetEntries;
    ShowMessage('Entries='+ResultString);
  end {if}
  else if Sender is TCombobox then
    ShowMessage('combo box');
end;

function TNewControlOptions.GetNotifyEventName(const EventName:string; Sender:Pointer):TNotifyEvent;
var
  TempEvent: TNotifyEvent;
begin
  //return TNotifyEvent procedure from name given ?
  //Technical
  TMethod(TempEvent).Code:= MethodAddress(EventName);
  if Sender=nil then
    TMethod(TempEvent).Data:= self
  else
    TMethod(TempEvent).Data:= Sender;
  Result:= TempEvent;
end;

function TControlOptions.GetControl:TControl;
begin
  Result:= FControlType;
end; {function GetControl:TControl}

function TControlOptions.GetControlName:string;
begin
  Result:= FControlName;
end; {TControlOptions.GetControlName}

function TControlOptions.GetControlTypeName:string;
begin
  Result:= FControlTypeName;
end; {TControlOptions.GetControlTypeName}

function TControlOptions.GetColor(theColour:string):TColor;
 var
    r,g,b : Byte;
    color : TColor;
    ledRed,ledGreen,ledBlue: string;
    commaPos1,commaPos2: integer;
 begin
    //201,77,5
    commaPos1:= PosEx(',',theColour,1);
    ledRed:= copy(theColour,1,commaPos1-1);
    commaPos2:= PosEx(',',theColour,commaPos1+1);
    ledGreen:= copy(theColour,commaPos1+1,(commaPos2-(commaPos1+1)));
    ledBlue:= copy(theColour,commaPos2+1,length(theColour));
    r := StrToInt(ledRed) ;
    g := StrToInt(ledGreen) ;
    b := StrToInt(ledBlue) ;

    color := RGB(r, g, b) ;
    Result:= color;
    //Shape1.Brush.Color := color;
 end;

function TControlOptions.GetNotifyEventName(const EventName:string; Sender:Pointer):TNotifyEvent;
var
  TempEvent: TNotifyEvent;
begin
  //return TNotifyEvent procedure from name given ?
  //Technical
  TMethod(TempEvent).Code:= self.MethodAddress(EventName);
  if Sender=nil then
    TMethod(TempEvent).Data:= self
  else
    TMethod(TempEvent).Data:= Sender;
  self.SetClassPointer(TMethod(TempEvent).Code);
  self.SetDataPointer(TMethod(TempEvent).Data);
  //Result:= TMethod(TempEvent) - no this is TMethod not TNotifyEvent;
  Result:= TempEvent;
end;

procedure TControlOptions.AddControls(Owner: TWinControl; ControlType: string; SetupOptions: TStrings);
var
  ListIDX: integer;
  ListItem: string;
  ctrlField: string;
  ctrlValue: string;
  EqualPos:integer;
  SpacePos:integer;
begin
  //Extract each field = value pair from list and create the new component:
  //eg Left = 30
  FControlTypeName:= ControlType;
  FControlList:= SetupOptions;
  self.ExtractAttributes(SetupOptions);
  if Uppercase(ControlType) = 'TLABEL' then begin
    self.Setup_TLabel(Owner);
  end; {if TLabel}
  if Uppercase(ControlType) = 'TEDIT' then begin
    self.Setup_TEdit(Owner);
  end; {if TEdit}
  if Uppercase(ControlType) = 'TBITBTN' then begin
    self.Setup_TBitBtn(Owner);
  end;
  if Uppercase(ControlType) = 'TGROUPBOX' then begin
    self.Setup_TGroupbox(Owner);
  end;
  if Uppercase(ControlType) = 'TRADIOBUTTON' then begin
    self.Setup_TRadiobutton(Owner);
  end; {if TBitbtn}
  if Uppercase(ControlType) = 'TPANEL' then begin
    self.Setup_TPanel(Owner);
  end; {if TBitbtn}
  if Uppercase(ControlType) = 'TCOMBOBOX' then begin
    self.Setup_TComboBox(Owner);
  end; {if TBitbtn}
  //FControlType.Free;
end; {TControlOptions.AddControls}

constructor TControlOptions.Create(Owner: TWinControl; ControlType: string; SetupOptions: TStrings);
begin
//
  self.AddControls(Owner,ControlType,SetupOptions);
end; {TControlOptions.AddControl}

destructor TControlOptions.Destroy;
begin
  if FControlType<>nil then FreeandNil(FControlType);
end;

procedure TControlOptions.ExtractAttributes(Attributes:TStrings);
var
  ListIDX : integer;
  ListItem: string;
  EqualPos: integer;
begin
  ListIDX:=0;
  While ListIDX<= Attributes.Count-1 do begin
    ListItem:= Attributes[ListIDX];
    EqualPos:= PosEx('=',ListItem,1);
    SetLength(FControlFields,Length(FControlFields)+1);
    SetLength(FControlValues,Length(FControlValues)+1);
    FControlFields[ListIDX]:= Uppercase(copy(ListItem,1,EqualPos-1));
    FControlValues[ListIDX]:= copy(ListItem,EqualPos+1,Length(ListItem));
    inc(ListIDX);
  end; {while}
end; {ExtractAttributes}

function TControlOptions.GetControlFields:TstrArray;
begin
  Result:= FControlFields;
end; {GetControlFields}

function TControlOptions.GetControlValues:TstrArray;
begin
  Result:= FControlValues;
end; {GetControlFields}

procedure TControlOptions.Setup_TLabel(Owner: TWinControl);
var
  idx:integer;
  ParentWinControl: TWinControl;
begin
  FControlType:= TLabel.Create(Owner);
  self.FControlTypeName:= 'TLabel';
  TLabel(FControlType).Caption:='';
  try
    TLabel(FControlType).Parent:= Owner;
    idx:=0;
    while idx<= high(FControlFields) do begin
      if FControlFields[idx] = 'TAG' then
        TLabel(FControlType).Tag:= StrToInt(FControlValues[idx]);
      if FControlFields[idx] = 'NAME' then begin
        if (PosEx(chr(32),FControlValues[idx],1)=0) AND (Length(FControlValues[idx])>0) then
          TLabel(FControlType).Name:= FControlValues[idx]
        else
          TLabel(FControlType).Name:= 'Label'+IntToStr(idx);
        //TLabel(FControlType).Caption:= '';
      end; {if FControlFields[idx] = 'NAME'}
      if FControlFields[idx] = 'LEFT' then
        TLabel(FControlType).Left:= StrToInt(FControlValues[idx]);
      if FControlFields[idx] = 'TOP' then
        TLabel(FControlType).Top:= StrToInt(FControlValues[idx]);
      if FControlFields[idx] = 'WIDTH' then
        TLabel(FControlType).Width:= StrToInt(FControlValues[idx]);
      if FControlFields[idx] = 'HEIGHT' then
        TLabel(FControlType).Height:= StrToInt(FControlValues[idx]);
      if (FControlFields[idx] = 'COLOR') OR (FControlFields[idx] = 'COLOUR') then
        TLabel(FControlType).Color:= self.GetColor(FControlValues[idx]);
      if (FControlFields[idx] = 'FONT.COLOR') OR (FControlFields[idx] = 'FONT.COLOUR') then
        TLabel(FControlType).Font.Color:= self.GetColor(FControlValues[idx]);
      if (FControlFields[idx] = 'FONT.NAME') OR (FControlFields[idx] = 'FONTNAME') then
        TLabel(FControlType).Font.Name:= FControlValues[idx];
      if FControlFields[idx] = 'CAPTION' then
        TLabel(FControlType).Caption:= FControlValues[idx];
      if FControlFields[idx] = 'PARENT' then
        if GetTWinControl(Owner,FControlValues[idx],ParentWinControl) then
          TLabel(FControlType).parent := ParentWinControl;

      inc(idx);
    end; {while}
    self.FControlName:= TLabel(FControlType).Name;
    TLabel(FControlType).Show;
  finally
    //if FControlType<>nil then FreeAndNil(FControlType);
  end; {finally}
end;

procedure TControlOptions.Setup_TMemo(Owner: TWinControl);
var
  idx:integer;
  ParentWinControl: TWinControl;
begin
  FControlType:= TMemo.Create(Owner);
  self.FControlTypeName:= 'TMemo';
  TMemo(FControlType).Clear;
  TMemo(FControlType).Lines.Clear;
  try
    TMemo(FControlType).Parent:= Owner;
    idx:=0;
    while idx<= high(FControlFields) do begin
      if FControlFields[idx] = 'TAG' then
        TMemo(FControlType).Tag:= StrToInt(FControlValues[idx]);
      if FControlFields[idx] = 'NAME' then begin
        if (PosEx(chr(32),FControlValues[idx],1)=0) AND (Length(FControlValues[idx])>0) then
          TMemo(FControlType).Name:= FControlValues[idx]
        else
          TMemo(FControlType).Name:= 'Memo'+IntToStr(idx);
        //TLabel(FControlType).Caption:= '';
      end; {if FControlFields[idx] = 'NAME'}
      if FControlFields[idx] = 'LEFT' then
        TMemo(FControlType).Left:= StrToInt(FControlValues[idx]);
      if FControlFields[idx] = 'TOP' then
        TMemo(FControlType).Top:= StrToInt(FControlValues[idx]);
      if FControlFields[idx] = 'WIDTH' then
        TMemo(FControlType).Width:= StrToInt(FControlValues[idx]);
      if FControlFields[idx] = 'HEIGHT' then
        TMemo(FControlType).Height:= StrToInt(FControlValues[idx]);
      if (FControlFields[idx] = 'COLOR') OR (FControlFields[idx] = 'COLOUR') then
        TMemo(FControlType).Color:= self.GetColor(FControlValues[idx]);
      if (FControlFields[idx] = 'FONT.COLOR') OR (FControlFields[idx] = 'FONT.COLOUR') then
        TMemo(FControlType).Font.Color:= self.GetColor(FControlValues[idx]);
      if (FControlFields[idx] = 'FONT.NAME') OR (FControlFields[idx] = 'FONTNAME') then
        TMemo(FControlType).Font.Name:= FControlValues[idx];
      if FControlFields[idx] = 'Line' then
        TMemo(FControlType).Lines.Add(FControlValues[idx]);
      if FControlFields[idx] = 'PARENT' then
        if GetTWinControl(Owner,FControlValues[idx],ParentWinControl) then
          TMemo(FControlType).parent := ParentWinControl;
      if FControlFields[idx] = 'SCROLLBARS' then begin
        if FControlValues[idx] = 'Horizontal' then
          TMemo(FControlType).ScrollBars:= ssHorizontal;
        if FControlValues[idx] = 'Vertical' then
          TMemo(FControlType).ScrollBars:= ssVertical;
        if FControlValues[idx] = 'Both' then
          TMemo(FControlType).ScrollBars:= ssBoth;
        if FControlValues[idx] = 'None' then
          TMemo(FControlType).ScrollBars:= ssNone;
      end;

      inc(idx);
    end; {while}
    self.FControlName:= TMemo(FControlType).Name;
    TMemo(FControlType).Show;
  finally
    //if FControlType<>nil then FreeAndNil(FControlType);
  end; {finally}
end;

{TControlOptions.Setup_TLabel}

procedure TControlOptions.Setup_TEdit(Owner: TWinControl);
var
  idx:integer;
  ParentWinControl: TWinControl;
begin
  //for .Parent to work - is of type TWinControl, array is of string
  //This is a case for an array of variants ... and associated types ...
  FControlType:= TEdit.Create(Owner);
  self.FControlTypeName:= 'TEdit';
  TEdit(FControlType).Parent:= Owner;
  TEdit(FControlType).Text:='';
  idx:=0;
  while idx<= high(FControlFields) do begin
    if FControlFields[idx] = 'TAG' then
      TEdit(FControlType).Tag:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'NAME' then
      if (PosEx(chr(32),FControlValues[idx],1)=0) AND (Length(FControlValues[idx])>0) then
        TEdit(FControlType).Name:= FControlValues[idx]
      else
        TEdit(FControlType).Name:= 'Edit'+IntToStr(idx);
    if FControlFields[idx] = 'LEFT' then
      TEdit(FControlType).Left:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'TOP' then
      TEdit(FControlType).Top:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'WIDTH' then
      TEdit(FControlType).Width:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'HEIGHT' then
      TEdit(FControlType).Height:= StrToInt(FControlValues[idx]);
    if (FControlFields[idx] = 'COLOR') OR (FControlFields[idx] = 'COLOUR') then
      TEdit(FControlType).Color:= self.GetColor(FControlValues[idx]);
    if (FControlFields[idx] = 'FONT.COLOR') OR (FControlFields[idx] = 'FONT.COLOUR') then
      TEdit(FControlType).Font.Color:= self.GetColor(FControlValues[idx]);
    if (FControlFields[idx] = 'FONT.NAME') OR (FControlFields[idx] = 'FONTNAME') then
        TEdit(FControlType).Font.Name:= FControlValues[idx];
    if FControlFields[idx] = 'TEXT' then begin
      if Length(FControlValues[IDX])>0 then
        TEdit(FControlType).Text:= FControlValues[idx]
      else
        TEdit(FControlType).Text:= '';
    end;
    if FControlFields[idx] = 'PASSWORD' then
      if Length(FControlValues[IDX])>0 then begin
        if Uppercase(FControlValues[idx]) = 'FALSE' then
          TEdit(FControlType).PasswordChar:= chr(32);
        if Uppercase(FControlValues[idx]) = 'TRUE' then
          TEdit(FControlType).PasswordChar:= chr(42);
      end {Length(FControlValues[IDX])>0}
      else TEdit(FControlType).PasswordChar:= chr(32);
    if FControlFields[idx] = 'TABORDER' then
      TEdit(FControlType).TabOrder:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'TABSTOP' then begin
      if Uppercase(FControlValues[idx]) = 'FALSE' then
        TEdit(FControlType).TabStop:= False;
      if Uppercase(FControlValues[idx]) = 'TRUE' then
        TEdit(FControlType).TabStop:= True;
    end; {TABSTOP}
    if FControlFields[idx] = 'PARENT' then
        if GetTWinControl(Owner,FControlValues[idx],ParentWinControl) then
          TEdit(FControlType).parent := ParentWinControl;

    inc(idx);
  end; {while}
  self.FControlName:= TEdit(FControlType).Name;
  TEdit(FControlType).Show;
end; {TControlOptions.Setup_TEdit}

procedure TControlOptions.Setup_TBitBtn(Owner: TWinControl);
var
  idx:integer;
  ParentWinControl: TWinControl;
begin
  FControlType:= TBitBtn.Create(Owner);
  self.FControlTypeName:= 'TBitBtn';
  TBitBtn(FControlType).Parent:= Owner;
  idx:=0;
  while idx<= high(FControlFields) do begin
    if FControlFields[idx] = 'TAG' then
      TBitBtn(FControlType).Tag:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'NAME' then
      if (PosEx(chr(32),FControlValues[idx],1)=0) AND (Length(FControlValues[idx])>0) then
        TBitBtn(FControlType).Name:= FControlValues[idx]
      else
        TBitBtn(FControlType).Name:= 'BitBtn'+IntToStr(idx);
    if FControlFields[idx] = 'LEFT' then
      TBitBtn(FControlType).Left:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'TOP' then
      TBitBtn(FControlType).Top:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'WIDTH' then
      TBitBtn(FControlType).Width:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'HEIGHT' then
      TBitBtn(FControlType).Height:= StrToInt(FControlValues[idx]);
    if (FControlFields[idx] = 'FONT.COLOR') OR (FControlFields[idx] = 'FONT.COLOUR') then
      TBitBtn(FControlType).Font.Color:= self.GetColor(FControlValues[idx]);
    if (FControlFields[idx] = 'FONT.NAME') OR (FControlFields[idx] = 'FONTNAME') then
        TBitBtn(FControlType).Font.Name:= FControlValues[idx];
    if FControlFields[idx] = 'CAPTION' then
      TBitBtn(FControlType).Caption:= FControlValues[idx];
    if FControlFields[idx] = 'ONCLICK' then begin
      TBitBtn(FControlType).OnClick:= self.GetNotifyEventName(FControlValues[idx],nil);
      //TBitBtn(FControlType).OnClick:= TNewControlOptions.GetNotifyEventName(FControlValues[idx],nil);
    end; {if OnClick=procedure name of TNotifyEvent}
    if FControlFields[idx] = 'MODALRESULT' then begin
      if Uppercase(FControlValues[idx]) = 'MROK' then
        TBitBtn(FControlType).ModalResult:= mrOK //value=1
      else if Uppercase(FControlValues[idx]) = 'MRCANCEL' then
        TBitBtn(FControlType).ModalResult:= mrCANCEL //value=2
      else if Uppercase(FControlValues[idx]) = 'MRNONE' then
        TBitBtn(FControlType).ModalResult:= mrNONE
      else
        ShowMessage('Developer Error: Modal Result not recognised');
    end; {if ModalResult= mrOK / mrCancel}
    if FControlFields[idx] = 'CANCEL' then begin
      if Uppercase(FControlValues[idx]) = 'TRUE' then
        TBitBtn(FControlType).Cancel:= True
      else
        TBitBtn(FControlType).Cancel:= False;
    end; {if Cancel= True/False}
    if FControlFields[idx] = 'DEFAULT' then begin
      if Uppercase(FControlValues[idx]) = 'TRUE' then
        TBitBtn(FControlType).Default:= True
      else
        TBitBtn(FControlType).Default:= False;
    end; {if Default= True/False - sets default button}
    if FControlFields[idx] = 'TABORDER' then
      TBitBtn(FControlType).TabOrder:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'TABSTOP' then begin
      if Uppercase(FControlValues[idx]) = 'FALSE' then
        TBitBtn(FControlType).TabStop:= False;
      if Uppercase(FControlValues[idx]) = 'TRUE' then
        TBitBtn(FControlType).TabStop:= True;
    end;
    if FControlFields[idx] = 'PARENT' then
        if GetTWinControl(Owner,FControlValues[idx],ParentWinControl) then
          TBitBtn(FControlType).parent := ParentWinControl;

    inc(idx);
  end; {while}
  self.FControlName:= TBitBtn(FControlType).Name;
  TBitBtn(FControlType).Show;
end; {TControlOptions.Setup_TBitBtn}

procedure TControlOptions.Setup_TGroupBox(Owner: TWinControl);
var
  idx:integer;
  ParentWinControl: TWinControl;
begin
  FControlType:= TGroupBox.Create(Owner);
  self.FControlTypeName:= 'TGroupBox';
  TGroupBox(FControlType).Parent:= Owner;
  idx:=0;
  while idx<= high(FControlFields) do begin
    if FControlFields[idx] = 'TAG' then
      TGroupBox(FControlType).Tag:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'NAME' then
      if (PosEx(chr(32),FControlValues[idx],1)=0) AND (Length(FControlValues[idx])>0) then
        TGroupBox(FControlType).Name:= FControlValues[idx]
      else
        TGroupBox(FControlType).Name:= 'GBox'+IntToStr(idx);
    if FControlFields[idx] = 'LEFT' then
      TGroupBox(FControlType).Left:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'TOP' then
      TGroupBox(FControlType).Top:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'WIDTH' then
      TGroupBox(FControlType).Width:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'HEIGHT' then
      TGroupBox(FControlType).Height:= StrToInt(FControlValues[idx]);
    if (FControlFields[idx] = 'COLOR') OR (FControlFields[idx] = 'COLOUR') then
      TGroupBox(FControlType).Color:= self.GetColor(FControlValues[idx]);
    if (FControlFields[idx] = 'FONT.COLOR') OR (FControlFields[idx] = 'FONT.COLOUR') then
      TGroupBox(FControlType).Font.Color:= self.GetColor(FControlValues[idx]);
    if (FControlFields[idx] = 'FONT.NAME') OR (FControlFields[idx] = 'FONTNAME') then
        TGroupBox(FControlType).Font.Name:= FControlValues[idx];
    if FControlFields[idx] = 'CAPTION' then begin
      if Length(FControlValues[idx])>0 then
        TGroupBox(FControlType).Caption:= FControlValues[idx]
      else
        TGroupBox(FControlType).Caption:= '';
    end;
    if FControlFields[idx] = 'ONCLICK' then begin
      TGroupBox(FControlType).OnClick:= self.GetNotifyEventName(FControlValues[idx],nil);
    end; {if OnClick=procedure name of TNotifyEvent}
    if FControlFields[idx] = 'TABORDER' then
      TGroupBox(FControlType).TabOrder:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'TABSTOP' then
      if Uppercase(FControlValues[idx]) = 'FALSE' then
        TGroupBox(FControlType).TabStop:= False;
      if Uppercase(FControlValues[idx]) = 'TRUE' then
        TGroupBox(FControlType).TabStop:= True;
    if FControlFields[idx] = 'PARENT' then
        if GetTWinControl(Owner,FControlValues[idx],ParentWinControl) then
          TGroupBox(FControlType).parent := ParentWinControl;

    inc(idx);
  end; {while}
  self.FControlName:= TGroupBox(FControlType).Name;
  TGroupBox(FControlType).Show;
end; {TControlOptions.Setup_TGroupBox}

procedure TControlOptions.Setup_TRadioButton(Owner: TWinControl);
var
  idx:integer;
  ParentWinControl: TWinControl;
begin
  //for .Parent to work - is of type TWinControl, array is of string
  //This is a case for an array of variants ... and associated types ...
  FControlType:= TRadioButton.Create(Owner);
  self.FControlTypeName:= 'TRadioButton';
  TRadioButton(FControlType).Parent:= Owner;
  idx:=0;
  while idx<= high(FControlFields) do begin
    if FControlFields[idx] = 'TAG' then
      TRadioButton(FControlType).Tag:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'NAME' then
      if (PosEx(chr(32),FControlValues[idx],1)=0) AND (Length(FControlValues[idx])>0) then
        TRadioButton(FControlType).Name:= FControlValues[idx]
      else
        TRadioButton(FControlType).Name:= 'rb'+IntToStr(idx);
    if FControlFields[idx] = 'LEFT' then
      TRadioButton(FControlType).Left:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'TOP' then
      TRadioButton(FControlType).Top:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'WIDTH' then
      TRadioButton(FControlType).Width:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'HEIGHT' then
      TRadioButton(FControlType).Height:= StrToInt(FControlValues[idx]);
    if (FControlFields[idx] = 'COLOR') OR (FControlFields[idx] = 'COLOUR') then
      TRadioButton(FControlType).Color:= self.GetColor(FControlValues[idx]);
    if (FControlFields[idx] = 'FONT.COLOR') OR (FControlFields[idx] = 'FONT.COLOUR') then
      TRadioButton(FControlType).Font.Color:= self.GetColor(FControlValues[idx]);
    if (FControlFields[idx] = 'FONT.NAME') OR (FControlFields[idx] = 'FONTNAME') then
        TRadioButton(FControlType).Font.Name:= FControlValues[idx];
    if FControlFields[idx] = 'PARENT' then
      if GetTWinControl(Owner,FControlValues[idx],ParentWinControl) then
        TRadioButton(FControlType).parent := ParentWinControl;
    if FControlFields[idx] = 'CAPTION' then begin
      if Length(FControlValues[idx])>0 then
        TRadioButton(FControlType).Caption:= FControlValues[idx]
      else
        TRadioButton(FControlType).Caption:= 'Selection '+IntToStr(TRadioButton(FControlType).Tag);
    end;
    if FControlFields[idx] = 'CHECKED' then
      if Uppercase(FControlValues[idx]) = 'TRUE' then
        TRadioButton(FControlType).Checked:= True;
      if Uppercase(FControlValues[idx]) = 'FALSE' then
        TRadioButton(FControlType).Checked:= False;
    if FControlFields[idx] = 'TABORDER' then
      TRadioButton(FControlType).TabOrder:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'TABSTOP' then begin
      if Uppercase(FControlValues[idx]) = 'FALSE' then
        TRadioButton(FControlType).TabStop:= False;
      if Uppercase(FControlValues[idx]) = 'TRUE' then
        TRadioButton(FControlType).TabStop:= True;
    end;

    inc(idx);
  end; {while}
  self.FControlName:= TRadioButton(FControlType).Name;
  TRadioButton(FControlType).Show;
end; {TControlOptions.Setup_TEdit}

procedure TControlOptions.Setup_TPanel(Owner: TWinControl);
var
  idx:integer;
  ParentWinControl: TWinControl;
begin
  //for .Parent to work - is of type TWinControl, array is of string
  //This is a case for an array of variants ... and associated types ...
  FControlType:= TPanel.Create(Owner);
  self.FControlTypeName:= 'TPanel';
  TPanel(FControlType).Parent:= Owner;
  idx:=0;
  while idx<= high(FControlFields) do begin
    if FControlFields[idx] = 'TAG' then
      TPanel(FControlType).Tag:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'NAME' then
      if (PosEx(chr(32),FControlValues[idx],1)=0) AND (Length(FControlValues[idx])>0) then
        TPanel(FControlType).Name:= FControlValues[idx]
      else
        TPanel(FControlType).Name:= 'panel'+IntToStr(idx);
    if FControlFields[idx] = 'LEFT' then
      TPanel(FControlType).Left:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'TOP' then
      TPanel(FControlType).Top:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'WIDTH' then
      TPanel(FControlType).Width:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'HEIGHT' then
      TPanel(FControlType).Height:= StrToInt(FControlValues[idx]);
    if (FControlFields[idx] = 'COLOR') OR (FControlFields[idx] = 'COLOUR') then
      TPanel(FControlType).Color:= self.GetColor(FControlValues[idx]);
    if (FControlFields[idx] = 'FONT.COLOR') OR (FControlFields[idx] = 'FONT.COLOUR') then
      TPanel(FControlType).Font.Color:= self.GetColor(FControlValues[idx]);
    if (FControlFields[idx] = 'FONT.NAME') OR (FControlFields[idx] = 'FONTNAME') then
        TPanel(FControlType).Font.Name:= FControlValues[idx];
    if FControlFields[idx] = 'PARENT' then
      if GetTWinControl(Owner,FControlValues[idx],ParentWinControl) then
        TPanel(FControlType).parent := ParentWinControl;
    if FControlFields[idx] = 'CAPTION' then begin
      if Length(FControlValues[idx])>0 then
        TPanel(FControlType).Caption:= FControlValues[idx]
      else
        TPanel(FControlType).Caption:= '';
    end;
    if FControlFields[idx] = 'TABORDER' then
      TPanel(FControlType).TabOrder:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'TABSTOP' then
      if Uppercase(FControlValues[idx]) = 'FALSE' then
        TPanel(FControlType).TabStop:= False;
      if Uppercase(FControlValues[idx]) = 'TRUE' then
        TPanel(FControlType).TabStop:= True;

    inc(idx);
  end; {while}
  self.FControlName:= TPanel(FControlType).Name;
  TPanel(FControlType).Show;
end; {TControlOptions.Setup_TPanel}

procedure TControlOptions.Setup_TComboBox(Owner: TWinControl);
var
  idx:integer;
  ParentWinControl: TWinControl;
begin
  //for .Parent to work - is of type TWinControl, array is of string
  //This is a case for an array of variants ... and associated types ...
  FControlType:= TCombobox.Create(Owner);
  self.FControlTypeName:= 'TComboBox';
  TCombobox(FControlType).parent:= Owner;
  TCombobox(FControlType).Text:='';
  idx:=0;
  while idx<= high(FControlFields) do begin
    if FControlFields[idx] = 'TAG' then
      TCombobox(FControlType).Tag:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'NAME' then
      if (PosEx(chr(32),FControlValues[idx],1)=0) AND (Length(FControlValues[idx])>0) then
        TCombobox(FControlType).Name:= FControlValues[idx]
      else
        TCombobox(FControlType).Name:= 'com'+IntToStr(idx);
    if FControlFields[idx] = 'LEFT' then
      TCombobox(FControlType).Left:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'TOP' then
      TCombobox(FControlType).Top:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'WIDTH' then
      TCombobox(FControlType).Width:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'HEIGHT' then
      TCombobox(FControlType).Height:= StrToInt(FControlValues[idx]);
    if (FControlFields[idx] = 'COLOR') OR (FControlFields[idx] = 'COLOUR') then
      TCombobox(FControlType).Color:= self.GetColor(FControlValues[idx]);
    if (FControlFields[idx] = 'FONT.COLOR') OR (FControlFields[idx] = 'FONT.COLOUR') then
      TCombobox(FControlType).Font.Color:= self.GetColor(FControlValues[idx]);
    if (FControlFields[idx] = 'FONT.NAME') OR (FControlFields[idx] = 'FONTNAME') then
        TCombobox(FControlType).Font.Name:= FControlValues[idx];
    if FControlFields[idx] = 'TEXT' then begin
      if Length(FControlValues[IDX])>0 then
        TCombobox(FControlType).Text:= FControlValues[idx]
      else
        TCombobox(FControlType).Text:= '';
    end;
    if FControlFields[idx] = 'ONCLICK' then begin
      TCombobox(FControlType).OnClick:= self.GetNotifyEventName(FControlValues[idx],nil);
    end; {if OnClick=procedure name of TNotifyEvent}
    if FControlFields[idx] = 'ADDOBJECT' then
      if Assigned(FObjects[idx]) then
        TCombobox(FControlType).Items.AddObject(FControlValues[idx],TObject(FObjects[idx]))
      else
        TCombobox(FControlType).Items.Add('obj error, idx='+IntToStr(idx));
    if FControlFields[idx] = 'ADDITEM' then
      TCombobox(FControlType).Items.Add(FControlValues[idx]);
    if FControlFields[idx] = 'TABORDER' then
      TCombobox(FControlType).TabOrder:= StrToInt(FControlValues[idx]);
    if FControlFields[idx] = 'TABSTOP' then begin
      if Uppercase(FControlValues[idx]) = 'FALSE' then
        TCombobox(FControlType).TabStop:= False;
      if Uppercase(FControlValues[idx]) = 'TRUE' then
        TCombobox(FControlType).TabStop:= True;
    end; {TABSTOP}
    if FControlFields[idx] = 'PARENT' then
        if GetTWinControl(Owner,FControlValues[idx],ParentWinControl) then
          TCombobox(FControlType).parent := ParentWinControl;

    inc(idx);
  end; {while}
  self.FControlName:= TCombobox(FControlType).Name;
  TCombobox(FControlType).Show;
end; {TControlOptions.Setup_TComboBox}

constructor TControlList.Create;
begin
  FTotalItems := 0;
  inherited Create;
  OwnsObjects:= True;
end; {constructor TControlList.Create}

function TControlList.GetTotalItems:integer;
begin
  Result:= FTotalItems;
end; {function GetTotalItems:integer}

procedure TControlList.IncrementItems;
begin
  inc(FTotalItems);
end;

procedure TControlList.SetControl(I: integer; AControl: TControlOptions);
begin
  inherited Items[I]:= AControl;
end; {SetControl}

function TControlList.GetControl(I: integer): TControlOptions;
begin
  Result:= TControlOptions(inherited Items[I]);
end;

function TControlList.Add(objControl: TControlOptions):integer;
begin
  self.IncrementItems;
  Result:= inherited Add(objControl);
end;

function TControlList.IndexOf(objControl:TControlOptions):integer;
begin
  Result:= inherited IndexOf(objControl);
end;

procedure TControlList.Insert(Index:integer; objControl:TControlOptions);
begin
  inherited Insert(Index,objControl);
end;

function TControlList.Remove(objControl:TcontrolOptions):integer;
begin
  Result:= inherited Remove(objControl);
end;




end.
