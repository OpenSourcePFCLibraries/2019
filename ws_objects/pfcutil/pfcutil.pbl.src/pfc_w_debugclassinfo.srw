$PBExportHeader$pfc_w_debugclassinfo.srw
$PBExportComments$PFC Display Class Information window
forward
global type pfc_w_debugclassinfo from w_main
end type
type dw_debugclassinfo from u_dw within pfc_w_debugclassinfo
end type
type cb_print from u_cb within pfc_w_debugclassinfo
end type
type cb_clear from u_cb within pfc_w_debugclassinfo
end type
type cb_close from u_cb within pfc_w_debugclassinfo
end type
type cb_dlghelp from u_cb within pfc_w_debugclassinfo
end type
type cb_previous_history from u_cb within pfc_w_debugclassinfo
end type
type cb_next_history from u_cb within pfc_w_debugclassinfo
end type
type cbx_show_properties from checkbox within pfc_w_debugclassinfo
end type
type cbx_show_methods from checkbox within pfc_w_debugclassinfo
end type
type cbx_show_events from checkbox within pfc_w_debugclassinfo
end type
type cbx_show_controls from checkbox within pfc_w_debugclassinfo
end type
type st_show from statictext within pfc_w_debugclassinfo
end type
end forward

global type pfc_w_debugclassinfo from w_main
integer x = 23
integer y = 400
integer width = 3063
integer height = 872
string title = "Debugging Class Info"
long backcolor = 80263328
boolean ib_isupdateable = false
dw_debugclassinfo dw_debugclassinfo
cb_print cb_print
cb_clear cb_clear
cb_close cb_close
cb_dlghelp cb_dlghelp
cb_previous_history cb_previous_history
cb_next_history cb_next_history
cbx_show_properties cbx_show_properties
cbx_show_methods cbx_show_methods
cbx_show_events cbx_show_events
cbx_show_controls cbx_show_controls
st_show st_show
end type
global pfc_w_debugclassinfo pfc_w_debugclassinfo

type variables
Protected:
boolean	ib_ShowProperties
boolean	ib_ShowMethods
boolean	ib_ShowEvents
boolean	ib_ShowControls

integer	ii_initcolwidth	//Initial column width
integer	ii_initdwwidth	//Initial datawindow widht
long		il_HistoryIndex
string 	is_History[]
string		is_CurrentClassName

n_cst_classinfo_attrib inv_attrib
n_cst_history_attrib	inv_history


end variables

forward prototypes
public function integer of_dwscrolltorow (long al_row)
public function integer of_dwsetredraw (boolean ab_switch)
public function integer of_setalwaysontop (boolean ab_switch)
protected subroutine of_show_link (string as_classname)
protected subroutine of_add_history (string as_classname)
public subroutine of_enable_history_buttons ()
public subroutine of_show_history (integer ai_direction)
protected subroutine of_show_contents ()
end prototypes

public function integer of_dwscrolltorow (long al_row);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_DwScrollToRow
//
//	Access:  		public
//
//	Arguments:		
//	al_row			Row to scroll to.
//
//	Returns:  		Integer
//						Returns 1 if it succeeds and -1 if an error occurs.
//						If any argument's value is NULL, function returns NULL.
//
//	Description:  	Scroll dw_debugjson to the requested row.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2017, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the MIT License

 *
 * https://opensource.org/licenses/MIT
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see https://github.com/OpenSourcePFCLibraries
*/
//
//////////////////////////////////////////////////////////////////////////////

Return dw_debugclassinfo.ScrollToRow(al_row)
end function

public function integer of_dwsetredraw (boolean ab_switch);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_DwSetRedraw
//
//	Access:  		public
//
//	Arguments:		
//	ab_switch		Switch to turn Redraw True or False.
//
//	Returns:  		Integer
//						Returns 1 if it succeeds and -1 if an error occurs.
//						If argument is NULL, function returns NULL.
//
//	Description:  	Set Redraw on dw_debugjson as requested.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2017, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the MIT License

 *
 * https://opensource.org/licenses/MIT
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see https://github.com/OpenSourcePFCLibraries
*/
//
//////////////////////////////////////////////////////////////////////////////

Return dw_debugclassinfo.SetRedraw(ab_switch)
end function

public function integer of_setalwaysontop (boolean ab_switch);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_SetAlwaysOnTop
//
//	Access:  		public
//
//	ab_switch	True to have DebugLog window always be on top.
//					False not to have DebugLog window always be on top.
//
//	Returns:  	integer
//					1 if it succeeds and -1 if an error occurs.
//
//	Description:	Allow the DebugLog window to always be on top when TRUE.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	5.0.02   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2017, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the MIT License

 *
 * https://opensource.org/licenses/MIT
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see https://github.com/OpenSourcePFCLibraries
*/
//
//////////////////////////////////////////////////////////////////////////////

//Check arguments
If IsNull(ab_switch) Then
	Return -1
End If

If ab_switch Then
	this.SetPosition (TopMost!)
Else
	this.SetPosition (NoTopMost!)		
End If

Return 1

end function

protected subroutine of_show_link (string as_classname);inv_info.of_parse( as_classname, ib_showproperties,  ib_showmethods, ib_showevents, ib_showcontrols)
inv_info.of_sharedata( dw_debugclassinfo )

end subroutine

protected subroutine of_add_history (string as_classname);il_historyindex = UpperBound( is_history ) + 1

is_history[il_historyindex] = as_classname

is_currentclassname = as_classname

end subroutine

public subroutine of_enable_history_buttons ();boolean lb_HistoryIsnotEmpty
long	   ll_limit

ll_limit = Upperbound( is_history )

lb_HistoryIsnotEmpty = (ll_limit > 0)

cb_previous_history.enabled = ( lb_HistoryIsnotEmpty and il_historyindex > 1)
cb_next_history.enabled = ( lb_HistoryIsnotEmpty and il_historyindex < ll_limit)


end subroutine

public subroutine of_show_history (integer ai_direction);choose case ai_direction
	case inv_history.cst_previous
		il_historyindex --
		if il_historyindex < 1 then il_historyindex = 1
	case inv_history.cst_next
		il_historyindex++
		if il_historyindex > Upperbound( is_history ) then il_historyindex = Upperbound( is_history )
end choose

of_show_link( is_history[il_historyindex] )
of_enable_history_buttons( )

end subroutine

protected subroutine of_show_contents ();ib_showcontrols = cbx_show_controls.checked
ib_showevents = cbx_show_events.checked
ib_showmethods = cbx_show_methods.checked
ib_showproperties = cbx_show_properties.checked

inv_info = create n_cst_classinfo
inv_info.of_parse(is_currentclassname, ib_showproperties,  ib_showmethods, ib_showevents, ib_showcontrols)
inv_info.of_sharedata( dw_debugclassinfo )

end subroutine

on pfc_w_debugclassinfo.create
int iCurrent
call super::create
this.dw_debugclassinfo=create dw_debugclassinfo
this.cb_print=create cb_print
this.cb_clear=create cb_clear
this.cb_close=create cb_close
this.cb_dlghelp=create cb_dlghelp
this.cb_previous_history=create cb_previous_history
this.cb_next_history=create cb_next_history
this.cbx_show_properties=create cbx_show_properties
this.cbx_show_methods=create cbx_show_methods
this.cbx_show_events=create cbx_show_events
this.cbx_show_controls=create cbx_show_controls
this.st_show=create st_show
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_debugclassinfo
this.Control[iCurrent+2]=this.cb_print
this.Control[iCurrent+3]=this.cb_clear
this.Control[iCurrent+4]=this.cb_close
this.Control[iCurrent+5]=this.cb_dlghelp
this.Control[iCurrent+6]=this.cb_previous_history
this.Control[iCurrent+7]=this.cb_next_history
this.Control[iCurrent+8]=this.cbx_show_properties
this.Control[iCurrent+9]=this.cbx_show_methods
this.Control[iCurrent+10]=this.cbx_show_events
this.Control[iCurrent+11]=this.cbx_show_controls
this.Control[iCurrent+12]=this.st_show
end on

on pfc_w_debugclassinfo.destroy
call super::destroy
destroy(this.dw_debugclassinfo)
destroy(this.cb_print)
destroy(this.cb_clear)
destroy(this.cb_close)
destroy(this.cb_dlghelp)
destroy(this.cb_previous_history)
destroy(this.cb_next_history)
destroy(this.cbx_show_properties)
destroy(this.cbx_show_methods)
destroy(this.cbx_show_events)
destroy(this.cbx_show_controls)
destroy(this.st_show)
end on

event resize;call super::resize;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  resize
//
//	(Arguments: Standard
//	sizetype
//	newwidth
//	newheight)
//
//	(Returns:  None)
//
//	Description:	When the window is resized, the datawindow is rezized by the
//						resize service.  Properly resize the objects that are 
//						contained by the datawindow.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2017, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the MIT License

 *
 * https://opensource.org/licenses/MIT
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see https://github.com/OpenSourcePFCLibraries
*/
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//integer	li_sizedelta
//
//li_sizedelta = dw_debugclassinfo.Width - ii_initdwwidth
//dw_debugclassinfo.Object.object.Width = ii_initcolwidth + li_sizedelta
//dw_debugclassinfo.Object.object_t.Width = ii_initcolwidth + li_sizedelta
//
end event

event pfc_preopen;//////////////////////////////////////////////////////////////////////////////
//
//	Object Name:	pfc_w_debuglog
//
//	Description:	A utility object used to display messages that are embedded
//						into an applicaiotn by the developer.
//						Use the n_cst_debug service to call this object.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
// 5.0.02 Added code to appropriately force or not force this window to always
//		be on top.
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2017, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the MIT License

 *
 * https://opensource.org/licenses/MIT
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see https://github.com/OpenSourcePFCLibraries
*/
//
//////////////////////////////////////////////////////////////////////////////

integer	li_rc

//Start the resize service
of_SetResize(True)

//Set the minimum size of the window on the resize service
inv_resize.of_SetMinSize( 1500, (cb_clear.Height + 30) * 3)
	
//Register each control that needs to move or resize after the window resizes
inv_resize.of_Register (cb_print, inv_resize.FIXEDRIGHT)
inv_resize.of_Register (cb_clear, inv_resize.FIXEDRIGHT)
inv_resize.of_Register (cb_close, inv_resize.FIXEDRIGHT)
inv_resize.of_Register (dw_debugclassinfo, inv_resize.SCALERIGHTBOTTOM)
inv_resize.of_register (cb_dlghelp, inv_resize.FIXEDRIGHT)
inv_resize.of_register (cb_previous_history, inv_resize.FIXEDRIGHT)
inv_resize.of_register (cb_next_history, inv_resize.FIXEDRIGHT)

inv_resize.of_register (st_show, inv_resize.fixedbottom )
inv_resize.of_register (cbx_show_controls, inv_resize.fixedbottom)
inv_resize.of_register (cbx_show_events, inv_resize.fixedbottom)
inv_resize.of_register (cbx_show_methods, inv_resize.fixedbottom)
inv_resize.of_register (cbx_show_properties, inv_resize.fixedbottom)

//If information is available, start the Preference service.
If gnv_app.of_IsRegistryAvailable() Then
	If Len(gnv_app.of_GetUserKey())> 0 Then 
		of_SetPreference(True)
	End If
Else
	If Len(gnv_app.of_GetUserIniFile()) > 0 Then
		of_SetPreference(True)
	End If
End If

// Allow window to close without the CloseQuery checks being performed.
ib_disableclosequery = True

// If appropriate force this window to be on top.
of_SetAlwaysOnTop(gnv_app.inv_debug.of_GetAlwaysOnTop())

// Make sure that PFC does not report updates pending for this window.
dw_debugclassinfo.of_SetUpdateable(false)
ib_disableclosequery = True

// The information displayed is kept on the Debug service.
li_rc = gnv_app.inv_debug.ids_debugclassinfo.ShareData (dw_debugclassinfo)
If li_rc <> 1 Then
	of_MessageBox ("pfc_debugClassInfo_failedsharedata", "PowerBuilder Class Library", &
		"Open on pfc_w_debugClassInfo event has received a ShareData() fail code.  "+ &
		"The ShareData() functionality is unable to be processed.", &
		Information!, OK!, 1)
End If

end event

event pfc_postopen;// override
is_currentclassname = dw_debugclassinfo.getitemstring( 1, 'entry_classname' )


end event

type st_debuginfoclass from w_main`st_debuginfoclass within pfc_w_debugclassinfo
end type

type dw_debugclassinfo from u_dw within pfc_w_debugclassinfo
integer x = 18
integer y = 20
integer width = 2542
integer height = 564
integer taborder = 10
string dataobject = "d_classinfo_repository"
boolean hscrollbar = true
end type

event constructor;call super::constructor;ib_rmbmenu = false
end event

event clicked;call super::clicked;integer	li_EntryLink
string 	ls_ClassName

if row < 1 then return 

li_entryLink = dw_debugclassinfo.GetItemNumber( row, 'entry_link' )
if li_EntryLink = inv_attrib.cst_link_none then return

ls_classname =  dw_debugclassinfo.GetItemstring( 1, 'entry_classname' )
of_add_history( ls_classname )
of_enable_history_buttons( )

choose case dwo.name
	case 'entry_text'
		ls_ClassName = dw_debugclassinfo.GetItemstring( row, 'entry_classname' )
		of_show_link( ls_classname )
end choose		
end event

type cb_print from u_cb within pfc_w_debugclassinfo
integer x = 2619
integer y = 24
integer taborder = 20
string text = "&Print"
end type

event clicked;call u_cb::clicked;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  		Clicked	
//
//	(Arguments:		None)
//
//	(Returns:  		None)
//
//	Description:	Print the contents of the datawindow.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2017, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the MIT License

 *
 * https://opensource.org/licenses/MIT
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see https://github.com/OpenSourcePFCLibraries
*/
//
//////////////////////////////////////////////////////////////////////////////

gnv_app.inv_debug.of_PrintLog()

end event

type cb_clear from u_cb within pfc_w_debugclassinfo
integer x = 2619
integer y = 136
integer taborder = 30
string text = "&Clear"
end type

event clicked;call u_cb::clicked;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  		Clicked	
//
//	(Arguments:		None)
//
//	(Returns:  		None)
//
//	Description:	Clear the contents of the datawindow.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2017, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the MIT License

 *
 * https://opensource.org/licenses/MIT
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see https://github.com/OpenSourcePFCLibraries
*/
//
//////////////////////////////////////////////////////////////////////////////

gnv_app.inv_debug.of_ClearLog()

end event

type cb_close from u_cb within pfc_w_debugclassinfo
integer x = 2619
integer y = 248
integer taborder = 40
string text = "Close"
boolean cancel = true
end type

event clicked;call u_cb::clicked;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  		Clicked	
//
//	(Arguments:		None)
//
//	(Returns:  		None)
//
//	Description:	Close the window
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2017, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the MIT License

 *
 * https://opensource.org/licenses/MIT
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see https://github.com/OpenSourcePFCLibraries
*/
//
//////////////////////////////////////////////////////////////////////////////

close(parent)
end event

type cb_dlghelp from u_cb within pfc_w_debugclassinfo
boolean visible = false
integer x = 2619
integer y = 360
integer taborder = 50
boolean enabled = false
string text = "&Help"
end type

event clicked;call super::clicked;//////////////////////////////////////////////////////////////////////////////
//
//	Event:
//	clicked
//
//	Description:
//	Display PFC dialog help
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	6.0   Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2017, All rights reserved.
 *
 * Redistribution and use in source and binary forms, with or without
 * modification, are permitted in accordance with the MIT License

 *
 * https://opensource.org/licenses/MIT
 *
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals and was originally based on software copyright (c) 
 * 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
 * information on the Open Source PowerBuilder Foundation Class
 * Libraries see https://github.com/OpenSourcePFCLibraries
*/
//
//////////////////////////////////////////////////////////////////////////////

showHelp ("pfcdlg.hlp", topic!, 10000)
end event

type cb_previous_history from u_cb within pfc_w_debugclassinfo
integer x = 2619
integer y = 364
integer width = 155
integer taborder = 60
boolean bringtotop = true
boolean enabled = false
string text = "&<<"
end type

event clicked;call super::clicked;of_show_history( inv_history.cst_previous )
end event

type cb_next_history from u_cb within pfc_w_debugclassinfo
integer x = 2811
integer y = 364
integer width = 155
integer taborder = 70
boolean bringtotop = true
boolean enabled = false
string text = "&>>"
end type

event clicked;call super::clicked;of_show_history( inv_history.cst_next )
end event

type cbx_show_properties from checkbox within pfc_w_debugclassinfo
integer x = 297
integer y = 624
integer width = 416
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Properties"
end type

event clicked;parent.of_show_contents( )
end event

type cbx_show_methods from checkbox within pfc_w_debugclassinfo
integer x = 654
integer y = 624
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Methods"
end type

event clicked;parent.of_show_contents( )
end event

type cbx_show_events from checkbox within pfc_w_debugclassinfo
integer x = 974
integer y = 624
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Events"
end type

event clicked;parent.of_show_contents( )
end event

type cbx_show_controls from checkbox within pfc_w_debugclassinfo
integer x = 1248
integer y = 624
integer width = 402
integer height = 80
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Controls"
end type

event clicked;parent.of_show_contents( )
end event

type st_show from statictext within pfc_w_debugclassinfo
integer x = 50
integer y = 624
integer width = 224
integer height = 64
boolean bringtotop = true
integer textsize = -10
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Tahoma"
long textcolor = 33554432
long backcolor = 67108864
string text = "Show :"
boolean focusrectangle = false
end type

