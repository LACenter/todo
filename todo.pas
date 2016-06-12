////////////////////////////////////////////////////////////////////////////////
// Unit Description  : todo Description
// Unit Author       : LA.Center Corporation
// Date Created      : March, Sunday 13, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals';

//constructor of todo
function todoCreate(Owner: TComponent): TFrame;
begin
    result := TFrame.CreateWithConstructorFromResource(Owner, @todo_OnCreate, 'todo');
end;

//OnCreate Event of todo
procedure todo_OnCreate(Sender: TFrame);
begin
    //Frame Constructor

    //todo: some additional constructing code
    TBGRAPanel(Sender.Find('back')).Gradient.StartColor := HexToColor('#f9f9f9');
    TBGRAPanel(Sender.Find('back')).Gradient.EndColor := HexToColor('#f0f0f0');
    TBGRALabel(Sender.Find('itemText')).BorderSpacing.Left := 10;

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TCheckBox(Sender.find('check')).OnChange := @todo_check_OnChange;
    //</events-bind>
end;

procedure todo_check_OnChange(Sender: TCheckBox);
begin
    _doChecked;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//todo initialization constructor
constructor
begin 
end.
