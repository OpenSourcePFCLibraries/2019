$PBExportHeader$pfcsecurity_scanner.sra
$PBExportComments$PFC Security Scanner Application
forward
global type pfcsecurity_scanner from application
end type
global transaction sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global error error
global message message
end forward

global variables
transaction inv_trans
constant string gs_displayname = 'PFC Security Scanner Utility'
end variables

global type pfcsecurity_scanner from application
string appname = "pfcsecurity_scanner"
end type
global pfcsecurity_scanner pfcsecurity_scanner

on pfcsecurity_scanner.create
appname="pfcsecurity_scanner"
message=create message
sqlca=create transaction
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create error
end on

on pfcsecurity_scanner.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;string	ls_ini_file, ls_values[], ls_path, ls_file
ContextKeyword	lcx_key
pfcscanner_n_cst_commandline	lnv_command

// The command line (pfcscanner_n_cst_commandline): /scan scans without a
// window, and writes to a log instead of showing messages
lnv_command = Create pfcscanner_n_cst_commandline
If lnv_command.of_Parse(CommandParm()) < 0 Then
	If lnv_command.ib_scan Then
		lnv_command.of_Log("Error: " + lnv_command.is_error + " Usage: " + lnv_command.USAGE)
	Else
		MessageBox(gs_displayname, lnv_command.is_error + "~r~n~r~nUsage: " + lnv_command.USAGE, StopSign!)
	End If
	Halt Close
	Return
End If

// The security administrator's INI file, with the security database's
// connection: given on the command line (/ini <file>), or in the
// PFC_SECURITY_INI environment variable, or pfcsecad.ini in the current
// folder; otherwise the user chooses it.
ls_ini_file = lnv_command.is_ini
If ls_ini_file = "" Then
	If GetContextService("Keyword", lcx_key) = 1 Then
		lcx_key.GetContextKeywords("PFC_SECURITY_INI", ls_values)
		If UpperBound(ls_values) > 0 Then ls_ini_file = Trim(ls_values[1])
	End If
End If
If ls_ini_file = "" And FileExists("pfcsecad.ini") Then ls_ini_file = GetCurrentDirectory() + "\pfcsecad.ini"

inv_trans = create transaction
Do While True
	If ls_ini_file <> "" And Not FileExists(ls_ini_file) Then
		If lnv_command.ib_scan Then
			lnv_command.of_Log("Error: the INI file " + ls_ini_file + " doesn't exist.")
			Halt Close
			Return
		End If
		MessageBox(gs_displayname, "The INI file " + ls_ini_file + " doesn't exist.", Exclamation!)
		ls_ini_file = ""
	End If
	If ls_ini_file = "" Then
		If lnv_command.ib_scan Then
			lnv_command.of_Log("Error: no INI file: give /ini <file>, set PFC_SECURITY_INI, or put pfcsecad.ini in the current folder.")
			Halt Close
			Return
		End If
		ls_path = ""
		If GetFileOpenName("Select the Security Administrator's INI File", ls_path, ls_file, "ini", "INI Files (*.ini),*.ini") <> 1 Then
			Halt Close
			Return
		End If
		ls_ini_file = ls_path
	End If

	// This script will read all the database values from the ini file
	//   and store them in inv_trans.
	inv_trans.DBMS = ProfileString(ls_ini_file,"Database","DBMS", "")
	If Trim(inv_trans.DBMS) = "" Then
		If lnv_command.ib_scan Then
			lnv_command.of_Log("Error: " + ls_ini_file + " has no DBMS in its [Database] section.")
			Halt Close
			Return
		End If
		MessageBox(gs_displayname, ls_ini_file + " has no DBMS in its [Database] section.", Exclamation!)
		ls_ini_file = ""
		Continue
	End If
	inv_trans.Database		= ProfileString(ls_ini_file,"Database","DataBase",         " ")
	inv_trans.LogID			= ProfileString(ls_ini_file,"Database","LogID",            " ")
	inv_trans.LogPass			= ProfileString(ls_ini_file,"Database","LogPassword",      " ")
	inv_trans.ServerName		= ProfileString(ls_ini_file,"Database","ServerName",       " ")
	inv_trans.UserID			= ProfileString(ls_ini_file,"Database","UserID",           " ")
	inv_trans.DBPass			= ProfileString(ls_ini_file,"Database","DatabasePassword", " ")
	inv_trans.Lock				= ProfileString(ls_ini_file,"Database","Lock",             " ")
	inv_trans.DbParm			= ProfileString(ls_ini_file,"Database","DbParm",           " ")

	connect using inv_trans;
	If inv_trans.SQLCode = 0 Then Exit

	If lnv_command.ib_scan Then
		lnv_command.of_Log("Error: unable to connect to the security database with " + ls_ini_file + ": " + inv_trans.SQLErrText)
		Halt Close
		Return
	End If
	If MessageBox(gs_displayname, "Unable to connect to the security database with " + ls_ini_file + ":" + &
			"~r~n~r~n" + inv_trans.SQLErrText + "~r~n~r~nChoose another INI file?", StopSign!, YesNo!) = 2 Then
		Halt Close
		Return
	End If
	ls_ini_file = ""
Loop

If lnv_command.ib_scan Then
	lnv_command.of_Scan(inv_trans)
	Halt Close
	Return
End If

OpenWithParm(w_pfcsecurity_targetselection, lnv_command.is_target)
end event

event systemerror;string 	ls_message

ls_message = 'Error Number '+string(error.number) & 
	+'.~r~nError text = '+Error.text &
	+'.~r~nWindow/Menu/Object = '+error.windowmenu &
	+'.~r~nError Object/Control = '+Error.object &
	+'.~r~nScript = '+Error.objectevent &
	+'.~r~nLine in Script = '+string(Error.line) + '.'
	
messagebox('System Error',ls_message, StopSign!, Ok!)

halt close
end event

event close;If IsValid(inv_trans) Then
	disconnect using inv_trans;
	destroy inv_trans
End If
end event

