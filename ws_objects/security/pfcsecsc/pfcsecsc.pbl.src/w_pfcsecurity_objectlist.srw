$PBExportHeader$w_pfcsecurity_objectlist.srw
$PBExportComments$List the windows in the application and scans the ones selected
forward
global type w_pfcsecurity_objectlist from window
end type
type cb_2 from commandbutton within w_pfcsecurity_objectlist
end type
type cb_cancel from commandbutton within w_pfcsecurity_objectlist
end type
type cb_1 from commandbutton within w_pfcsecurity_objectlist
end type
type dw_1 from pfcscanner_u_dw within w_pfcsecurity_objectlist
end type
end forward

global type w_pfcsecurity_objectlist from window
integer width = 3168
integer height = 1876
boolean titlebar = true
string title = "Select Objects to be Scanned"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
windowstate windowstate = maximized!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event ue_scanlist ( )
event ue_postopen ( )
cb_2 cb_2
cb_cancel cb_cancel
cb_1 cb_1
dw_1 dw_1
end type
global w_pfcsecurity_objectlist w_pfcsecurity_objectlist

type variables
boolean	ib_canceled
integer	il_gutter
string	is_liblist, is_libs[]
string	is_app
pfcscanner_n_cst_sourcelibrary	inv_source
end variables

event ue_scanlist;long ll_r, ll_rows, ll_rc, ll_objects, ll_controls, ll_failed
string ls_title, ls_object, ls_type, ls_library, ls_failed, ls_summary
boolean lb_error
pfcscanner_n_cst_securityscanner lnv_security

SetPointer ( HourGlass! )

If Not IsValid ( inv_source ) Then Return
If dw_1.GetSelectedRow ( 0 ) = 0 Then
	MessageBox ( this.Title, "Select the objects to scan." )
	Return
End If

ls_title = this.Title
ib_canceled = False
cb_cancel.enabled = True

lnv_security = Create pfcscanner_n_cst_securityscanner
If lnv_security.of_InitScanProcess ( inv_trans, is_app, inv_source ) < 0 Then
	Destroy lnv_security
	cb_cancel.Enabled = False
	MessageBox ( this.Title, "Unable to scan: the scanner isn't connected to the security database.", StopSign! )
	Return
End If

dw_1.SetFilter ( "IsSelected()" )
dw_1.Filter ( )

ll_rows = dw_1.RowCount ( )
dw_1.SelectRow ( 0, False )
For ll_r = 1 to ll_rows
	Yield()
	If ib_canceled Then Exit
	this.Title = ls_title + " (" + String ( ll_r ) + " of " + String ( ll_rows ) + ")"
	dw_1.ScrollToRow ( ll_r )
	dw_1.SelectRow ( ll_r, True )
	ls_object = dw_1.GetItemString ( ll_r, "name" )
	ls_type = Lower ( dw_1.GetItemString ( ll_r, "otype" ) )
	ls_library = dw_1.object.pbl[ll_r]

	// windows, menus and user objects, with what they inherit; DataWindow objects' columns
	ll_rc = lnv_security.of_ScanObject ( ls_object, ls_library )
	Yield ( )
	If ll_rc = -2 Then
		MessageBox ( this.Title, "Error reading the security template for " + ls_type + " - " + ls_object, StopSign! )
		lb_error = True
		Exit
	ElseIf ll_rc < 0 Then
		ll_failed++
		If ll_failed <= 10 Then ls_failed += "~r~n   " + ls_type + " " + ls_object
	Else
		ll_objects++
		ll_controls += ll_rc
	End If

	If lnv_security.of_Update() <> 1 Then
		MessageBox ( this.Title, "Error updating " + ls_type + " - " + ls_object, StopSign! )
		lb_error = True
		Exit
	End If
Next

this.Title = ls_title
dw_1.SelectRow ( 0, true )

dw_1.SetFilter ( "" )
dw_1.Filter ( )
dw_1.Sort ( )

// summary
ls_summary = lnv_security.of_GetSummaryText ( is_app, ll_objects, ll_rows, ll_controls )
Destroy lnv_security
cb_cancel.Enabled = False
If ib_canceled Then ls_summary += "~r~n~r~nThe scan was canceled."
If lb_error Then ls_summary += "~r~n~r~nThe scan stopped at an error saving " + ls_object + "."
If ll_failed > 0 Then
	ls_summary += "~r~n~r~n" + String ( ll_failed ) + " objects couldn't be read:" + ls_failed
	If ll_failed > 10 Then ls_summary += "~r~n   ..."
End If
MessageBox ( this.Title, ls_summary )
end event

event ue_postopen;long ll_row, ll_rows, ll_m, ll_missing
string ls_missing[], ls_message

SetPointer ( HourGlass! )

// the libraries' objects, read from their source (or exported from .pbl files)
inv_source = Create pfcscanner_n_cst_sourcelibrary
If inv_source.of_SetLibraries ( is_libs ) < 0 Then
	MessageBox ( this.Title, "None of the libraries of " + is_app + " could be read.", StopSign! )
	Return
End If

ll_missing = inv_source.of_GetMissing ( ls_missing )
If ll_missing > 0 Then
	ls_message = "These libraries don't exist, and their objects aren't listed:"
	For ll_m = 1 To ll_missing
		ls_message += "~r~n   " + ls_missing[ll_m]
	Next
	MessageBox ( this.Title, ls_message, Exclamation! )
End If

dw_1.SetRedraw ( False )
dw_1.ImportString ( inv_source.of_GetObjects ( ) )
dw_1.Filter ( )
dw_1.Sort ( )

// Select the objects a scan includes by default: all but the PFC ancestor layer
ll_rows = dw_1.RowCount ( )
For ll_row = 1 To ll_rows
	If inv_source.of_IsDefaultSelected ( dw_1.GetItemString ( ll_row, "name" ) ) Then
		dw_1.SelectRow ( ll_row, True )
	End If
Next
dw_1.ScrollToRow ( 1 )
dw_1.SetRedraw ( True )

this.Title = this.Title + " - " + is_app
end event

on w_pfcsecurity_objectlist.create
this.cb_2=create cb_2
this.cb_cancel=create cb_cancel
this.cb_1=create cb_1
this.dw_1=create dw_1
this.Control[]={this.cb_2,&
this.cb_cancel,&
this.cb_1,&
this.dw_1}
end on

on w_pfcsecurity_objectlist.destroy
destroy(this.cb_2)
destroy(this.cb_cancel)
destroy(this.cb_1)
destroy(this.dw_1)
end on

event close;If IsValid ( inv_source ) Then Destroy inv_source
end event

event open;pfcscanner_n_cst_string lnv_string

is_liblist = message.stringparm
is_app = left(is_liblist,pos(is_liblist,'~t') - 1)
is_liblist = mid(is_liblist,pos(is_liblist,'~t') + 1)
lnv_string.of_ParseToArray ( is_liblist, ";", is_libs ) 

cb_cancel.enabled = false

this.event post ue_postopen()
end event

event resize;dw_1.Resize ( this.WorkSpaceWidth ( ) - dw_1.X - 24, this.WorkSpaceHeight ( ) - dw_1.Y - 24) 
end event

type cb_2 from commandbutton within w_pfcsecurity_objectlist
integer x = 745
integer y = 12
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Close"
boolean cancel = true
end type

event clicked;Close ( parent )
end event

type cb_cancel from commandbutton within w_pfcsecurity_objectlist
integer x = 384
integer y = 12
integer width = 343
integer height = 92
integer taborder = 20
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean enabled = false
string text = "Cancel"
boolean cancel = true
end type

event clicked;ib_canceled = True
end event

type cb_1 from commandbutton within w_pfcsecurity_objectlist
integer x = 23
integer y = 12
integer width = 343
integer height = 92
integer taborder = 10
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Scan"
end type

event clicked;parent.Post Event ue_scanlist ( )

end event

type dw_1 from pfcscanner_u_dw within w_pfcsecurity_objectlist
integer x = 27
integer y = 120
integer width = 3095
integer height = 1640
integer taborder = 10
string title = "none"
string dataobject = "d_pfcsecurity_objectlist"
boolean hscrollbar = true
boolean vscrollbar = true
end type

event constructor;call super::constructor;ib_extended = true
end event

