$PBExportHeader$w_test_ancestor.srw
forward
global type w_test_ancestor from w_main
end type
type sle_1 from singlelineedit within w_test_ancestor
end type
type cb_1 from commandbutton within w_test_ancestor
end type
end forward

global type w_test_ancestor from w_main
string title = "Test Ancestor"
sle_1 sle_1
cb_1 cb_1
end type
global w_test_ancestor w_test_ancestor

on w_test_ancestor.create
int iCurrent
call super::create
this.sle_1=create sle_1
this.cb_1=create cb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.sle_1
this.Control[iCurrent+2]=this.cb_1
end on

on w_test_ancestor.destroy
call super::destroy
destroy(this.sle_1)
destroy(this.cb_1)
end on

event close;call super::close;if isvalid( gnv_app.inv_debug ) then
	gnv_app.of_setdebug( false )
end if

end event

type st_debuginfoclass from w_main`st_debuginfoclass within w_test_ancestor
end type

type sle_1 from singlelineedit within w_test_ancestor
integer x = 146
integer y = 196
integer width = 402
integer height = 112
integer taborder = 10
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
string text = "none"
borderstyle borderstyle = stylelowered!
end type

type cb_1 from commandbutton within w_test_ancestor
integer x = 201
integer y = 520
integer width = 402
integer height = 112
integer taborder = 20
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
string text = "Debug Ini"
end type

event clicked;if isvalid( gnv_app.inv_debug ) then
	gnv_app.inv_debug.of_openini( true)
end if

end event

