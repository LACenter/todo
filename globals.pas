////////////////////////////////////////////////////////////////////////////////
// Unit Description  : globals Description
// Unit Author       : LA.Center Corporation
// Date Created      : March, Sunday 13, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

var
    _EXIT: bool = false;
    scroller: TScrollBox = nil;
    _root: string = '';
    _xml: TXMLDataSet;
    _appSettings: TStringList;
    _player: int = 10;


//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

procedure _setButton(bu: TBGRAButton);
begin
    bu.TextShadowOffSetX := 1;
    bu.TextShadowOffSetY := 1;
    bu.TextShadowRadius := 1;
    // Normal
    bu.BodyNormal.BorderColor := HexToColor('#ff6600');
    bu.BodyNormal.Font.Color := clWhite;
    if Windows then
    bu.BodyNormal.Font.Size := 10
    else if OSX then
    bu.BodyNormal.Font.Size := 12
    else
    bu.BodyNormal.Font.Size := 8;
    bu.BodyNormal.Gradient1.StartColor := HexToColor('#ff6600');
    bu.BodyNormal.Gradient1.EndColor := HexToColor('#ff4400');
    bu.BodyNormal.Gradient2.StartColor := HexToColor('#ff4400');
    bu.BodyNormal.Gradient2.EndColor := HexToColor('#ff6600');
    // Hover
    bu.BodyHover.BorderColor := HexToColor('#ff6600');
    bu.BodyHover.Font.Color := clWhite;
    if Windows then
    bu.BodyHover.Font.Size := 10
    else if OSX then
    bu.BodyHover.Font.Size := 12
    else
    bu.BodyHover.Font.Size := 8;
    bu.BodyHover.Gradient1.StartColor := HexToColor('#ff7700');
    bu.BodyHover.Gradient1.EndColor := HexToColor('#ff5500');
    bu.BodyHover.Gradient2.StartColor := HexToColor('#ff5500');
    bu.BodyHover.Gradient2.EndColor := HexToColor('#ff7700');
    // Clicked
    bu.BodyClicked.BorderColor := HexToColor('#ff4400');
    bu.BodyClicked.Font.Color := clWhite;
    if Windows then
    bu.BodyClicked.Font.Size := 10
    else if OSX then
    bu.BodyClicked.Font.Size := 12
    else
    bu.BodyClicked.Font.Size := 8;
    bu.BodyClicked.Gradient1.StartColor := HexToColor('#ff6600');
    bu.BodyClicked.Gradient1.EndColor := HexToColor('#ff4400');
    bu.BodyClicked.Gradient2.StartColor := HexToColor('#ff4400');
    bu.BodyClicked.Gradient2.EndColor := HexToColor('#ff6600');
end;

procedure _doChecked();
var
    i: int;
    chk: TCheckBox;
    hasChecked: bool = false;
begin
    for i := 0 to scroller.ComponentCount -1 do
    begin
        chk := TCheckBox(scroller.Components[i].Find('check'));
        if chk.Checked then
            hasChecked := true;
    end;

    TBGRAButton(Application.MainForm.Find('bDone')).Enabled := hasChecked;
    TAction(Application.MainForm.Find('actDelete')).Enabled := hasChecked;
end;

procedure _doUpdateStatus(status: string);
var
    i: int;
    chk: TCheckBox;
    List: string = '';
begin
    for i := 0 to scroller.ComponentCount -1 do
    begin
        chk := TCheckBox(scroller.Components[i].Find('check'));
        if chk.Checked then
        begin
            List := List+'{'+chk.Hint+'}';

            case status of
                'unknown':  resToFile('unknown', TempDir+'tmp.png');
                'done':  resToFile('done', TempDir+'tmp.png');
                'normal':  resToFile('normal', TempDir+'tmp.png');
                'busy':  resToFile('busy', TempDir+'tmp.png');
                'angry':  resToFile('angry', TempDir+'tmp.png');
            end;

            TImage(scroller.Components[i].Find('itemImage')).Picture.LoadFromFile(TempDir+'tmp.png');
            DeleteFile(TempDir+'tmp.png');
            chk.Checked := false;
        end;
    end;

    _xml.Close;
    _xml.LoadFromXMLFile(_xml.FileName);
    _xml.Open;
    while not _xml.Eof do
    begin
        if Pos('{'+_xml.Field(0).AsString+'}', List) > 0 then
        begin
            _xml.Edit;
            _xml.Field(2).AsString := status;
            _xml.Post;
        end;
        _xml.Next;
    end;

    _xml.SaveToXMLFile(_xml.FileName);

    _doChecked;
end;

procedure _doDelete();
var
    i: int;
    chk: TCheckBox;
    List: string = '';
begin
    for i := 0 to scroller.ComponentCount -1 do
    begin
        chk := TCheckBox(scroller.Components[i].Find('check'));
        if chk.Checked then
            List := List+'{'+chk.Hint+'}';
    end;

    _xml.Close;
    _xml.LoadFromXMLFile(_xml.FileName);
    _xml.Open;
    while not _xml.Eof do
    begin
        if Pos('{'+_xml.Field(0).AsString+'}', List) > 0 then
        _xml.Delete
        else
        _xml.Next;
    end;

    _xml.SaveToXMLFile(_xml.FileName);
    TAction(Application.MainForm.Find('actPopulate')).Execute;

    _doChecked;
end;

//globals initialization constructor
constructor
begin
    _root := UserDir+'LA.Store'+DirSep+'LA.Todo'+DirSep;
    _xml := TXMLDataSet.Create(nil);
    _xml.FileName := _root+'todo.xml';

    if not DirExists(_root) then
        ForceDir(_root);

    if not FileExists(_root+'todo.xml') then
    begin
        _xml.FieldDefs.Add('id', ftString, 50);
        _xml.FieldDefs.Add('text', ftString, 255);
        _xml.FieldDefs.Add('status', ftString, 50);
        _xml.FieldDefs.Add('timestamp', ftFloat);
        _xml.Active := true;
        _xml.SaveToXMLFile(_xml.FileName);
    end;

    _appSettings := TStringList.Create;
    if not FileExists(_root+'app.settings') then
    begin
        _appSettings.Values['firsttime'] := '1';
        _appSettings.Values['theme'] := 'LA.Center';
        _appSettings.Values['voice'] := 'Lauren';
        _appSettings.Values['online'] := '0';
        _appSettings.Values['online-email'] := '';
        _appSettings.Values['online-key'] := '';
        _appSettings.SaveToFile(_root+'app.settings');
    end
        else
        _appSettings.LoadFromFile(_root+'app.settings');

    //todo: add voice after SDK 110 update
    //todo: add sync after SDK 110 update
end.
