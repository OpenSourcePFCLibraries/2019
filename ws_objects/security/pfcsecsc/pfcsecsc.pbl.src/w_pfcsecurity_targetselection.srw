$PBExportHeader$w_pfcsecurity_targetselection.srw
forward
global type w_pfcsecurity_targetselection from window
end type
type st_liblist from statictext within w_pfcsecurity_targetselection
end type
type st_target from statictext within w_pfcsecurity_targetselection
end type
type cb_ok from commandbutton within w_pfcsecurity_targetselection
end type
type cb_1 from commandbutton within w_pfcsecurity_targetselection
end type
type mle_1 from base_librarylist within w_pfcsecurity_targetselection
end type
type cb_browse from commandbutton within w_pfcsecurity_targetselection
end type
type sle_targetfile from singlelineedit within w_pfcsecurity_targetselection
end type
type cb_select from commandbutton within w_pfcsecurity_targetselection
end type
type cb_exit from commandbutton within w_pfcsecurity_targetselection
end type
end forward

global type w_pfcsecurity_targetselection from window
integer x = 1074
integer y = 484
integer width = 1961
integer height = 2064
boolean titlebar = true
string title = "Select Application"
boolean controlmenu = true
boolean minbox = true
boolean maxbox = true
boolean resizable = true
long backcolor = 80921269
boolean center = true
st_liblist st_liblist
st_target st_target
cb_ok cb_ok
cb_1 cb_1
mle_1 mle_1
cb_browse cb_browse
sle_targetfile sle_targetfile
cb_select cb_select
cb_exit cb_exit
end type
global w_pfcsecurity_targetselection w_pfcsecurity_targetselection

type variables
pfcscanner_n_cst_target inv_target

string is_appname, is_libs[]
end variables

forward prototypes
public function integer wf_opentarget (string as_file)
end prototypes

public function integer wf_opentarget (string as_file);//*-------------------------------------------------------------------
//*  Function:			wf_OpenTarget
//*  Purpose:			Read the application and its libraries from a target (.pbt)
//*-------------------------------------------------------------------
integer li_count

li_count = inv_target.of_Open ( Trim ( as_file ), is_appname, is_libs )
If li_count <= 0 Or is_appname = "" Then
	mle_1.f_ClearAll ( )
	cb_ok.Enabled = False
	MessageBox ( this.Title, "Unable to read the application and its libraries from " + as_file + "." )
	Return -1
End If

mle_1.f_Populate ( is_libs )
cb_ok.Enabled = True

Return 1
end function

on w_pfcsecurity_targetselection.create
this.st_liblist=create st_liblist
this.st_target=create st_target
this.cb_ok=create cb_ok
this.cb_1=create cb_1
this.mle_1=create mle_1
this.cb_browse=create cb_browse
this.sle_targetfile=create sle_targetfile
this.cb_select=create cb_select
this.cb_exit=create cb_exit
this.Control[]={this.st_liblist,&
this.st_target,&
this.cb_ok,&
this.cb_1,&
this.mle_1,&
this.cb_browse,&
this.sle_targetfile,&
this.cb_select,&
this.cb_exit}
end on

on w_pfcsecurity_targetselection.destroy
destroy(this.st_liblist)
destroy(this.st_target)
destroy(this.cb_ok)
destroy(this.cb_1)
destroy(this.mle_1)
destroy(this.cb_browse)
destroy(this.sle_targetfile)
destroy(this.cb_select)
destroy(this.cb_exit)
end on

event open;string ls_target

inv_target = Create pfcscanner_n_cst_target

// the target given on the command line
ls_target = Message.StringParm
If Trim(ls_target) = "" Then Return

sle_targetfile.Text = inv_target.of_FullPath(GetCurrentDirectory(), ls_target)
wf_OpenTarget(sle_targetfile.Text)
end event

event close;If IsValid ( inv_target ) Then Destroy inv_target
end event

type st_liblist from statictext within w_pfcsecurity_targetselection
integer x = 32
integer y = 332
integer width = 1472
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "&Libraries, from the target:"
boolean focusrectangle = false
end type

type st_target from statictext within w_pfcsecurity_targetselection
integer x = 32
integer y = 56
integer width = 1472
integer height = 76
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 67108864
string text = "Browse for the &target to scan:"
boolean focusrectangle = false
end type

type cb_ok from commandbutton within w_pfcsecurity_targetselection
integer x = 1111
integer y = 1836
integer width = 343
integer height = 92
integer taborder = 50
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
boolean enabled = false
string text = "OK"
boolean default = true
end type

event clicked;long ll_l, ll_libs
string ls_liblist, ls_return, ls_libs[]

ll_libs = mle_1.f_GetLibraries ( ls_libs )
For ll_l = 1 to ll_libs
	ls_liblist = ls_liblist + ls_libs[ll_l] + ";" 
Next

ls_return = is_appname + "~t" + ls_liblist
openwithparm ( w_pfcsecurity_objectlist, ls_return)

Close ( parent )
end event

type cb_1 from commandbutton within w_pfcsecurity_targetselection
integer x = 1815
integer y = 408
integer width = 73
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&..."
end type

event clicked;//*-----------------------------------------------------------------*/
//*    clicked:  Browse for library
//*-----------------------------------------------------------------*/
long ll_rc, ll_f, ll_files
string ls_type, ls_filenames[], ls_path

/*  Get the platform-specific extension of PowerBuilder library  */
ls_type = mle_1.inv_file.is_FileType

// Note: GetFileSaveName - passing a string array for filename arg
//      allows multi-select (new for 7.0)
ll_rc = GetFileOpenName ( "Select Library", &
					ls_path, ls_filenames, ls_type, &
					"PB Libraries (*." + ls_type + "),*." + ls_type )
			
If ll_rc = 1 Then
	If UpperBound ( ls_filenames ) = 1 Then
		mle_1.f_AddToList ( ls_path ) 
	Else
		mle_1.f_AddToList ( ls_path, ls_filenames ) 
	End If
End If
end event

type mle_1 from base_librarylist within w_pfcsecurity_targetselection
integer x = 32
integer y = 408
integer width = 1783
integer height = 1400
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
boolean hscrollbar = true
boolean vscrollbar = true
borderstyle borderstyle = stylelowered!
end type

type cb_browse from commandbutton within w_pfcsecurity_targetselection
integer x = 1815
integer y = 132
integer width = 73
integer height = 84
integer taborder = 40
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "&..."
end type

event clicked;//*-----------------------------------------------------------------*/
//*    clicked:  Browse for target file name
//*-----------------------------------------------------------------*/
string ls_filename, ls_file
int li_rc

ls_filename = sle_targetfile.Text
li_rc = GetFileOpenName ( "Select Target", &
			ls_filename, ls_file, "pbt", &
			"PowerBuilder Targets (*.pbt),*.pbt" )

If li_rc = 1 Then
	sle_targetfile.Text = ls_filename
	sle_targetfile.TriggerEvent ( Modified! ) 
End If
end event

type sle_targetfile from singlelineedit within w_pfcsecurity_targetselection
integer x = 32
integer y = 132
integer width = 1783
integer height = 84
integer taborder = 30
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
borderstyle borderstyle = stylelowered!
end type

event modified;If Trim( this.Text ) = "" Then
	mle_1.f_clearAll()
	cb_ok.Enabled = False
Else
	wf_OpenTarget ( this.Text )
End If
end event

type cb_select from commandbutton within w_pfcsecurity_targetselection
end type

type cb_exit from commandbutton within w_pfcsecurity_targetselection
integer x = 1472
integer y = 1836
integer width = 343
integer height = 92
integer taborder = 30
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
string text = "Cancel"
boolean cancel = true
end type

event clicked;close(parent)
end event

