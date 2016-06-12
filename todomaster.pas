////////////////////////////////////////////////////////////////////////////////
// Unit Description  : todomaster Description
// Unit Author       : LA.Center Corporation
// Date Created      : March, Sunday 13, 2016
// -----------------------------------------------------------------------------
//
// History
//
//
////////////////////////////////////////////////////////////////////////////////


uses 'mainform';

//<events-code> - note: DESIGNER TAG => DO NOT REMOVE!

procedure AppException(Sender: TObject; E: Exception);
begin
    //Uncaught Exceptions
    MsgError('Error', E.Message);
end;

//todomaster initialization constructor
constructor
begin
    Application.Initialize;
    Application.Icon.LoadFromResource('appicon');
    Application.Title := 'LA.Todo';
    mainformCreate(nil);
    Application.Run;
end.

//Project Resources
//$res:appicon=[project-home]resources/app.ico
//$res:mainform=[project-home]mainform.pas.frm
//$res:todo=[project-home]todo.pas.frm
//$res:todoitem=[project-home]resources/todo.png_48x48.png
//$res:unknown=[project-home]resources/unknown.png
//$res:done=[project-home]resources/done.png
//$res:normal=[project-home]resources/check.png
//$res:busy=[project-home]resources/busy.png
//$res:angry=[project-home]resources/warn.png
