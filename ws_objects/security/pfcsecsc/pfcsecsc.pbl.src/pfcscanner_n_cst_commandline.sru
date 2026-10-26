$PBExportHeader$pfcscanner_n_cst_commandline.sru
$PBExportComments$The scanner's command line, and its unattended scan
forward
global type pfcscanner_n_cst_commandline from nonvisualobject
end type
end forward

global type pfcscanner_n_cst_commandline from nonvisualobject
end type
global pfcscanner_n_cst_commandline pfcscanner_n_cst_commandline

type variables
// The command line:
//	pfcsecurity_scanner [/ini <file>] [/target <file>] [/scan [/log <file>]]
//	/ini		the security administrator's INI file, with the security database
//	/target	the target (.pbt) to scan
//	/scan		scan the target without a window: the objects the object list
//				selects by default, with the summary written to the log
//	/log		the log of an unattended scan (otherwise pfcsecurity_scanner.log in
//				the current folder)
string	is_ini
string	is_target
string	is_log
boolean	ib_scan

// The command line's error, if of_Parse fails
string	is_error

constant string USAGE = "pfcsecurity_scanner [/ini <file>] [/target <file>] [/scan [/log <file>]]"
end variables

forward prototypes
public function integer of_parse (string as_commandline)
public function integer of_log (string as_text)
public function integer of_scan (transaction atr_trans)
end prototypes

public function integer of_parse (string as_commandline);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_Parse
//	Arguments:		as_commandline	The command line (CommandParm)
//	Returns:			1, -1 if the command line has an error (is_error)
//	Description:	Reads the options.  A value can be quoted; unquoted, it runs to
//						the next option, so a path with spaces needn't be.
//////////////////////////////////////////////////////////////////////////////
string	ls_option, ls_value
long		ll_pos, ll_end

as_commandline = Trim(as_commandline)
// the whole command line quoted as one argument
If Left(as_commandline, 2) = "~"/" And Right(as_commandline, 1) = "~"" Then
	as_commandline = Trim(Mid(as_commandline, 2, Len(as_commandline) - 2))
End If

Do While as_commandline <> ""
	If Left(as_commandline, 1) <> "/" Then
		is_error = "Unexpected ~"" + as_commandline + "~"."
		Return -1
	End If
	ll_pos = Pos(as_commandline, " ")
	If ll_pos = 0 Then ll_pos = Len(as_commandline) + 1
	ls_option = Lower(Mid(as_commandline, 2, ll_pos - 2))
	as_commandline = Trim(Mid(as_commandline, ll_pos + 1))

	ls_value = ""
	If ls_option <> "scan" Then
		If Left(as_commandline, 1) = "~"" Then
			ll_end = Pos(as_commandline, "~"", 2)
			If ll_end = 0 Then ll_end = Len(as_commandline) + 1
			ls_value = Mid(as_commandline, 2, ll_end - 2)
			as_commandline = Trim(Mid(as_commandline, ll_end + 1))
		Else
			ll_end = Pos(as_commandline, " /")
			If ll_end = 0 Then ll_end = Len(as_commandline) + 1
			ls_value = Trim(Left(as_commandline, ll_end - 1))
			as_commandline = Trim(Mid(as_commandline, ll_end + 1))
		End If
		If ls_value = "" Then
			is_error = "/" + ls_option + " needs a value."
			Return -1
		End If
	End If

	Choose Case ls_option
		Case "ini"
			is_ini = ls_value
		Case "target"
			is_target = ls_value
		Case "log"
			is_log = ls_value
		Case "scan"
			ib_scan = True
		Case Else
			is_error = "Unknown option /" + ls_option + "."
			Return -1
	End Choose
Loop

If ib_scan And is_target = "" Then
	is_error = "/scan needs /target."
	Return -1
End If
Return 1
end function

public function integer of_log (string as_text);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_Log
//	Arguments:		as_text	A message of the unattended scan
//	Returns:			1, -1 if the log can't be written
//	Description:	Appends the message, with the date and time, to the log
//////////////////////////////////////////////////////////////////////////////
integer	li_file

If is_log = "" Then is_log = GetCurrentDirectory() + "\pfcsecurity_scanner.log"
li_file = FileOpen(is_log, TextMode!, Write!, LockWrite!, Append!, EncodingUTF8!)
If li_file < 0 Then Return -1
FileWriteEx(li_file, String(Today(), "yyyy-mm-dd") + " " + String(Now(), "hh:mm:ss") + "  " + &
				as_text + "~r~n")
FileClose(li_file)
Return 1
end function

public function integer of_scan (transaction atr_trans);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_Scan
//	Arguments:		atr_trans	The security database, connected
//	Returns:			1 if the scan succeeds, -1 if it fails (the log says why)
//	Description:	Scans the target without a window: the objects the object list
//						selects by default (pfcscanner_n_cst_sourcelibrary
//						of_IsDefaultSelected), and writes the summary to the log.
//////////////////////////////////////////////////////////////////////////////
string	ls_target, ls_app, ls_libs[], ls_missing[], ls_name, ls_type, ls_failed[]
long		ll_i, ll_rows, ll_rc, ll_scanned, ll_selected, ll_controls, ll_failed
integer	li_rc = 1
pfcscanner_n_cst_target				lnv_target
pfcscanner_n_cst_sourcelibrary	lnv_source
pfcscanner_n_cst_securityscanner	lnv_scan
pfcscanner_n_ds						lds_objects

lnv_target = Create pfcscanner_n_cst_target
ls_target = lnv_target.of_FullPath(GetCurrentDirectory(), is_target)
of_Log("Scanning " + ls_target)

If lnv_target.of_Open(ls_target, ls_app, ls_libs) <= 0 Or ls_app = "" Then
	of_Log("Error: unable to read the application and its libraries from " + ls_target + ".")
	Destroy lnv_target
	Return -1
End If
Destroy lnv_target

lnv_source = Create pfcscanner_n_cst_sourcelibrary
If lnv_source.of_SetLibraries(ls_libs) < 0 Then
	of_Log("Error: none of the libraries of " + ls_app + " could be read.")
	Destroy lnv_source
	Return -1
End If
For ll_i = 1 To lnv_source.of_GetMissing(ls_missing)
	of_Log("Warning: the library " + ls_missing[ll_i] + " doesn't exist; its objects aren't scanned.")
Next

lnv_scan = Create pfcscanner_n_cst_securityscanner
If lnv_scan.of_InitScanProcess(atr_trans, ls_app, lnv_source) < 0 Then
	of_Log("Error: the scanner isn't connected to the security database.")
	Destroy lnv_scan
	Destroy lnv_source
	Return -1
End If

lds_objects = Create pfcscanner_n_ds
lds_objects.DataObject = "d_pfcsecurity_objectlist"
lds_objects.ImportString(lnv_source.of_GetObjects())
ll_rows = lds_objects.RowCount()
For ll_i = 1 To ll_rows
	ls_name = lds_objects.GetItemString(ll_i, "name")
	If Not lnv_source.of_IsDefaultSelected(ls_name) Then Continue
	ls_type = lds_objects.GetItemString(ll_i, "otype")
	ll_selected++

	ll_rc = lnv_scan.of_ScanObject(ls_name, lds_objects.GetItemString(ll_i, "pbl"))
	If ll_rc = -2 Then
		of_Log("Error reading the security template for " + ls_type + " " + ls_name + ": " + atr_trans.SQLErrText)
		li_rc = -1
		Exit
	ElseIf ll_rc < 0 Then
		ll_failed++
		ls_failed[ll_failed] = ls_type + " " + ls_name
	Else
		ll_scanned++
		ll_controls += ll_rc
	End If

	If lnv_scan.of_Update() <> 1 Then
		of_Log("Error saving " + ls_type + " " + ls_name + ": " + atr_trans.SQLErrText)
		li_rc = -1
		Exit
	End If
Next

of_Log(lnv_scan.of_GetSummaryText(ls_app, ll_scanned, ll_selected, ll_controls))
If ll_failed > 0 Then
	of_Log(String(ll_failed) + " objects couldn't be read:")
	For ll_i = 1 To ll_failed
		of_Log("   " + ls_failed[ll_i])
	Next
End If

Destroy lds_objects
Destroy lnv_scan
Destroy lnv_source
Return li_rc
end function

on pfcscanner_n_cst_commandline.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pfcscanner_n_cst_commandline.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on
