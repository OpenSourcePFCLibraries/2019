$PBExportHeader$w_f_peat.srw
$PBExportComments$PEAT Frame window
forward
global type w_f_peat from w_frame
end type
end forward

global type w_f_peat from w_frame
integer x = 5
integer y = 4
integer width = 2935
integer height = 1928
string title = "Project Estimation and Actual Tracking System"
string menuname = "m_peat_frame"
windowstate windowstate = maximized!
string icon = "peat.ico"
boolean toolbarvisible = false
end type
global w_f_peat w_f_peat

on w_f_peat.create
call super::create
if IsValid(this.MenuID) then destroy(this.MenuID)
if this.MenuName = "m_peat_frame" then this.MenuID = create m_peat_frame
end on

on w_f_peat.destroy
call super::destroy
if IsValid(MenuID) then destroy(MenuID)
end on

event pfc_new;call super::pfc_new;w_s_projectlist	w_active
string				ls_name

SetPointer(HourGlass!)
OpenWithParm(w_r_projectwizard, 0)
ls_name = message.stringparm
IF ls_name <> "" THEN
	w_active = this.GetActiveSheet()
	IF IsValid(w_active) THEN
		w_active.of_addnewproject(ls_name)
	END IF
END IF


end event

event pfc_postopen;call super::pfc_postopen;integer 	li_return
String		ls_inifile
String		ls_authentication

// Connect to database
ls_inifile = gnv_app.of_GetAppIniFile()
IF SQLCA.of_Init(ls_inifile, "Database") = -1 THEN
	gnv_app.inv_error.of_message(gnv_app.iapp_object.DisplayName, + &
			"Error initializing connection information, .INI file not found.")
	Halt Close		
	Return
ELSE
	IF IsPowerServerApp() THEN
		gnv_app.is_authentication = ProfileString(ls_inifile,"Application","Authentication","Database")
		IF gnv_app.is_authentication = gnv_app.OPENID THEN
			// No need for login dialog, call open id auth directory
			li_return = gnv_app.of_openid_authentication()
			IF li_return = -1 THEN 
				Halt Close
				Return
			END IF
		ELSE
			//Call the function to open the login dialog
			li_return = gnv_app.of_LogonDlg()
			If li_return <> 1 Then
				Halt Close
				Return
			END IF
		END IF
	ELSE
		//Call the function to open the login dialog
		li_return = gnv_app.of_LogonDlg()
		IF li_return <> 1 THEN
			Halt Close
			Return
		END IF
	END IF
END IF

end event

event pfc_open;call super::pfc_open;long		ll_project_id
string		ls_project_name

gnv_app.inv_error.of_SetPredefinedSource(SQLCA)

SELECT project_id,
		   name
INTO :ll_project_id,
		:ls_project_name
FROM project
WHERE project_id  = 1 ;

OpenSheet(w_s_projectlist, this, 0, layered!)

end event

