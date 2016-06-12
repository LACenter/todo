////////////////////////////////////////////////////////////////////////////////
// Unit Description  : mainform Description
// Unit Author       : LA.Center Corporation
// Date Created      : March, Saturday 12, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////

uses 'globals', 'todo';

//constructor of mainform
function mainformCreate(Owner: TComponent): TForm;
begin
    result := TForm.CreateWithConstructorFromResource(Owner, @mainform_OnCreate, 'mainform');
end;

//OnCreate Event of mainform
procedure mainform_OnCreate(Sender: TForm);
begin
    //Form Constructor

    //todo: some additional constructing code
    Sender.Caption := Application.Title;
    Sender.Position := poDesigned;
    Sender.Left := Screen.Width - 400;
    Sender.Top := 50;
    Sender.Constraints.MinWidth := 350;
    Sender.Constraints.MinHeight := 450;

    TTrayIcon(Sender.Find('TrayIcon1')).Visible := true;
    TTrayIcon(Sender.Find('TrayIcon1')).Hint := Application.Title;

    TScrollBox(Sender.Find('scroller')).ChildSizing.LeftRightSpacing := 0;
    TScrollBox(Sender.Find('scroller')).ChildSizing.TopBottomSpacing := 5;
    TScrollBox(Sender.Find('scroller')).ChildSizing.HorizontalSpacing := 0;
    TScrollBox(Sender.Find('scroller')).ChildSizing.VerticalSpacing := 10;
    TScrollBox(Sender.Find('scroller')).ChildSizing.Layout := cclLeftToRightThenTopToBottom;
    TScrollBox(Sender.Find('scroller')).ChildSizing.ControlsPerLine := 1;
    TScrollBox(Sender.Find('scroller')).HorzScrollBar.Tracking := true;
    TScrollBox(Sender.Find('scroller')).HorzScrollBar.Smooth := true;
    TScrollBox(Sender.Find('scroller')).HorzScrollBar.Visible := false;
    TScrollBox(Sender.Find('scroller')).VertScrollBar.Tracking := true;
    TScrollBox(Sender.Find('scroller')).VertScrollBar.Smooth := true;
    scroller := TScrollBox(Sender.Find('scroller'));

    TBGRAPanel(Sender.Find('addPanel')).Gradient.StartColor := HexToColor('#ffffff');
    TBGRAPanel(Sender.Find('addPanel')).Gradient.EndColor := HexToColor('#f0f0f0');
    TBGRAPanel(Sender.Find('addPanel')).Top := -120;

    _setButton(TBGRAButton(Sender.Find('bAdd')));
    _setButton(TBGRAButton(Sender.Find('bDone')));
    _setButton(TBGRAButton(Sender.Find('bDel')));
    _setButton(TBGRAButton(Sender.Find('bHide')));
    _setButton(TBGRAButton(Sender.Find('itemAdd')));
    _setButton(TBGRAButton(Sender.Find('itemCancel')));

    //note: DESIGNER TAG => DO NOT REMOVE!
    //<events-bind>
    TBGRAButton(Sender.find('bDone')).OnButtonClick := @mainform_bDone_OnButtonClick;
    TBGRAButton(Sender.find('bDone')).OnClick := @mainform_bDone_OnClick;
    TTimer(Sender.find('dueTimer')).OnTimer := @mainform_dueTimer_OnTimer;
    TAction(Sender.find('actAbout')).OnExecute := @mainform_actAbout_OnExecute;
    TAction(Sender.find('actNormal')).OnExecute := @mainform_actNormal_OnExecute;
    TAction(Sender.find('actBusy')).OnExecute := @mainform_actBusy_OnExecute;
    TAction(Sender.find('actDone')).OnExecute := @mainform_actDone_OnExecute;
    TAction(Sender.find('actDelete')).OnExecute := @mainform_actDelete_OnExecute;
    TAction(Sender.find('actAdd')).OnExecute := @mainform_actAdd_OnExecute;
    TEdit(Sender.find('eText')).OnKeyDown := @mainform_eText_OnKeyDown;
    TEdit(Sender.find('eText')).OnChange := @mainform_eText_OnChange;
    TBGRAButton(Sender.find('itemAdd')).OnClick := @mainform_itemAdd_OnClick;
    TTimer(Sender.find('closeTimer')).OnTimer := @mainform_closeTimer_OnTimer;
    TBGRAButton(Sender.find('itemCancel')).OnClick := @mainform_itemCancel_OnClick;
    TTimer(Sender.find('openTimer')).OnTimer := @mainform_openTimer_OnTimer;
    TSimpleAction(Sender.find('actPopulate')).OnExecute := @mainform_actPopulate_OnExecute;
    TTimer(Sender.find('startTimer')).OnTimer := @mainform_startTimer_OnTimer;
    TBGRAButton(Sender.find('bHide')).OnClick := @mainform_bHide_OnClick;
    TTrayIcon(Sender.find('TrayIcon1')).OnDblClick := @mainform_TrayIcon1_OnDblClick;
    TAction(Sender.find('actShow')).OnExecute := @mainform_actShow_OnExecute;
    TAction(Sender.find('actExit')).OnExecute := @mainform_actExit_OnExecute;
    Sender.OnCloseQuery := @mainform_OnCloseQuery;
    Sender.OnResize := @mainform_OnResize;
    Sender.OnShow := @mainform_OnShow;
    //</events-bind>

    //Set as Application.MainForm
    Sender.setAsMainForm;
end;

procedure mainform_OnCloseQuery(Sender: TForm; var CanClose: bool);
begin
    CanClose := _EXIT;
    if not CanClose then
    begin
        TAction(Sender.Find('actShow')).Caption := 'Show';
        Sender.Hide;
    end;
end;

procedure mainform_actExit_OnExecute(Sender: TAction);
begin
    _EXIT := true;
    TForm(Sender.Owner).Close;
end;

procedure mainform_actShow_OnExecute(Sender: TAction);
begin
    if Sender.Caption = 'Show' then
    begin
        Sender.Caption := 'Hide';
        TForm(Sender.Owner).Show;
    end
        else
    begin
        Sender.Caption := 'Show';
        TForm(Sender.Owner).Hide;
    end;
end;

procedure mainform_TrayIcon1_OnDblClick(Sender: TTrayIcon);
begin
    if not Windows then
    begin
        TAction(Sender.Owner.Find('actShow')).Caption := 'Hide';
        TForm(Sender.Owner).Show;
    end;
end;

procedure mainform_bHide_OnClick(Sender: TBGRAButton);
begin
    TAction(Sender.Owner.Find('actShow')).Caption := 'Show';
    TForm(Sender.Owner).Hide;
end;

procedure mainform_OnResize(Sender: TForm);
var
    i: int;
begin
    for i := 0 to scroller.ComponentCount -1 do
    begin
        TFrame(scroller.Components[i]).Constraints.MaxWidth := scroller.Width -20;
        TFrame(scroller.Components[i]).Constraints.MinWidth := scroller.Width -20;
    end;
end;

procedure mainform_startTimer_OnTimer(Sender: TTimer);
begin
    Sender.Enabled := false;

    if _appSettings.Values['firsttime'] = '1' then
    begin
        //note: do nothing yet, after SDK 110 prombt here for sync and voice options
    end;

    mainform_actPopulate_OnExecute(nil);
end;

procedure mainform_actPopulate_OnExecute(Sender: TSimpleAction);
var
    card: TFrame;
    i: int;
begin
    for i := scroller.ComponentCount -1 downto 0 do
        try scroller.Components[i].free; except end;

    _xml.Close;
    _xml.LoadFromXMLFile(_xml.FileName);
    _xml.Open;
    while not _xml.Eof do
    begin
        card := todoCreate(scroller);
        card.Parent := scroller;
        card.Constraints.MinWidth := scroller.Width -20;
        card.Constraints.MaxWidth := scroller.Width -20;
        card.Constraints.MinHeight := 60;
        card.Constraints.MaxHeight := 60;
        TBGRALabel(card.Find('itemText')).Caption := _xml.Field(1).AsString;
        TCheckBox(card.Find('check')).Hint := _xml.Field(0).AsString;

        case _xml.Field(2).AsString of
            'unknown':  resToFile('unknown', TempDir+'tmp.png');
            'done':  resToFile('done', TempDir+'tmp.png');
            'normal':  resToFile('normal', TempDir+'tmp.png');
            'busy':  resToFile('busy', TempDir+'tmp.png');
            'angry':  resToFile('angry', TempDir+'tmp.png');
        end;

        TImage(card.Find('itemImage')).Picture.LoadFromFile(TempDir+'tmp.png');
        DeleteFile(TempDir+'tmp.png');

        _xml.Next;
    end;
end;

procedure mainform_openTimer_OnTimer(Sender: TTimer);
begin
    TForm(Sender.Owner).ActiveControl := TEdit(Sender.Owner.Find('eText'));

    if TControl(Sender.Owner.Find('addPanel')).Top <> 0 then
        TControl(Sender.Owner.Find('addPanel')).Top :=
            TControl(Sender.Owner.Find('addPanel')).Top + 10
    else
        Sender.Enabled := false;

    //Application.ProcessMessages;
end;

procedure mainform_itemCancel_OnClick(Sender: TComponent);
begin
    TTimer(Sender.Owner.Find('closeTimer')).Enabled := true;
end;

procedure mainform_closeTimer_OnTimer(Sender: TTimer);
begin
    if TControl(Sender.Owner.Find('addPanel')).Top <> -120 then
        TControl(Sender.Owner.Find('addPanel')).Top :=
            TControl(Sender.Owner.Find('addPanel')).Top - 10
    else
        Sender.Enabled := false;

    //Application.ProcessMessages;
end;

procedure mainform_itemAdd_OnClick(Sender: TComponent);
var
    dt: double;
    pick: TDateTimePicker;
begin
    dt := -1;
    pick := TDateTimePicker(Sender.Owner.Find('eDate'));
    if pick.Checked then
        dt := EncodeDateTime(YearOf(pick.Date),
                             MonthOf(pick.Date),
                             DayOf(pick.Date),
                             HourOf(pick.Time),
                             MinuteOf(pick.Time), 0, 0);
    _xml.Close;
    _xml.LoadFromXMLFile(_xml.FileName);
    _xml.Open;
    _xml.Append;
    _xml.Field(0).AsString := DateFormat('yyyymmddhhnnsszzz', now)+IntToStr(Random(9999))+IntToStr(Random(9999))+IntToStr(Random(9999));
    _xml.Field(1).AsString := TEdit(Sender.Owner.Find('eText')).Text;
    _xml.Field(2).AsString := 'normal';
    _xml.Field(3).AsFloat := dt;
    _xml.SaveToXMLFile(_xml.FileName);

    TAction(Sender.Owner.Find('actPopulate')).Execute;

    TTimer(Sender.Owner.Find('closeTimer')).Enabled := true;
end;

procedure mainform_eText_OnChange(Sender: TEdit);
begin
    TControl(Sender.Owner.Find('itemAdd')).Enabled := (Trim(Sender.Text) <> '');
end;

procedure mainform_eText_OnKeyDown(Sender: TEdit; var Key: int; keyInfo: TKeyInfo);
begin
    if Key = 27 then
        mainform_itemCancel_OnClick(Sender);

    if Key = 13 then
        if Trim(Sender.Text) <> '' then
            mainform_itemAdd_OnClick(Sender);
end;

procedure mainform_OnShow(Sender: TForm);
begin
    TTimer(Sender.Find('startTimer')).Enabled := true;
end;

procedure mainform_actAdd_OnExecute(Sender: TAction);
begin
    TEdit(Sender.Owner.Find('eText')).Text := '';
    TDateTimePicker(Sender.Owner.Find('eDate')).Checked := false;
    TDateTimePicker(Sender.Owner.Find('eDate')).Date :=
        EncodeDateTime(YearOf(tomorrow), MonthOf(tomorrow), DayOf(tomorrow), HourOf(Now), 0, 0, 0);
    TDateTimePicker(Sender.Owner.Find('eDate')).Time :=
        EncodeDateTime(YearOf(tomorrow), MonthOf(tomorrow), DayOf(tomorrow), HourOf(Now), 0, 0, 0);
    TTimer(Sender.Owner.Find('openTimer')).Enabled := true;
end;

procedure mainform_actDelete_OnExecute(Sender: TAction);
begin
    if MsgWarning('Warning', 'You are about to delete Todo items, continue?') then
    _doDelete;
end;

procedure mainform_actDone_OnExecute(Sender: TAction);
begin
    _doUpdateStatus('done');
end;

procedure mainform_actBusy_OnExecute(Sender: TAction);
begin
    _doUpdateStatus('busy');
end;

procedure mainform_actNormal_OnExecute(Sender: TAction);
begin
    _doUpdateStatus('normal');
end;

procedure mainform_actAbout_OnExecute(Sender: TAction);
begin
    MsgInfo('About', Application.Title+' Version 1.0'+#13+
        'Copyright (C) 2016 LA.Center Corporation');
end;

procedure mainform_dueTimer_OnTimer(Sender: TTimer);
var
    i: int;
    hasAngry: bool = false;
begin
    _xml.Close;
    _xml.LoadFromXMLFile(_xml.FileName);
    _xml.Open;
    while not _xml.Eof do
    begin
        if (_xml.Field(3).AsFloat < now) and
           (_xml.Field(3).AsFloat <> -1) and
           (_xml.Field(2).AsString = 'normal') then
        begin
            for i := 0 to scroller.ComponentCount -1 do
            begin
                if TCheckBox(scroller.Components[i].Find('check')).Hint = _xml.Field(0).AsString then
                begin
                    TCheckBox(scroller.Components[i].Find('check')).Checked := true;
                    hasAngry := true;
                end;
            end;
        end;
        _xml.Next;
    end;

    if hasAngry then
    begin
        _doUpdateStatus('angry');
        TTrayIcon(Sender.Owner.Find('TrayIcon1')).BalloonHint := 'You have due Todo items';
        TTrayIcon(Sender.Owner.Find('TrayIcon1')).BalloonTitle := Application.Title+' - Due Items';
        TTrayIcon(Sender.Owner.Find('TrayIcon1')).ShowBalloonHint;
    end;
end;

procedure mainform_bDone_OnClick(Sender: TBGRAButton);
begin
    TAction(Sender.Owner.Find('actDone')).Execute;
end;

procedure mainform_bDone_OnButtonClick(Sender: TBGRAButton);
begin
    TPopupMenu(Sender.Owner.Find('PopupMenu2')).PopUp;
end;

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

//mainform initialization constructor
constructor
begin 
end.
