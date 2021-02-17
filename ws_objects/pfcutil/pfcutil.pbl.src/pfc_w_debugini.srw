$PBExportHeader$pfc_w_debugini.srw
$PBExportComments$PFC Display Ini utility window
forward
global type pfc_w_debugini from w_main
end type
type dw_debugini from u_dw within pfc_w_debugini
end type
type cb_print from u_cb within pfc_w_debugini
end type
type cb_close from u_cb within pfc_w_debugini
end type
type cb_dlghelp from u_cb within pfc_w_debugini
end type
end forward

global type pfc_w_debugini from w_main
integer x = 23
integer y = 400
integer width = 2894
integer height = 728
string title = "Debugging INI - "
long backcolor = 80263328
dw_debugini dw_debugini
cb_print cb_print
cb_close cb_close
cb_dlghelp cb_dlghelp
end type
global pfc_w_debugini pfc_w_debugini

type variables

end variables

forward prototypes
public function integer of_dwscrolltorow (long al_row)
public function integer of_dwsetredraw (boolean ab_switch)
public function integer of_setalwaysontop (boolean ab_switch)
public subroutine of_refresh ()
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
//	Description:  	Scroll dw_debuglog to the requested row.
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

Return dw_debugini.ScrollToRow(al_row)
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
//	Description:  	Set Redraw on dw_debuglog as requested.
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

Return dw_debugini.SetRedraw(ab_switch)
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

public subroutine of_refresh ();long	ll_i
long	ll_j
long	ll_limit_sections
long	ll_limit_keys
long	ll_row
string ls_sections[]
string ls_keys[]
string	ls_inifile
string ls_value

n_cst_inifile	lnv_ini

ls_inifile = gnv_app.of_getappinifile( )
this.title += ls_inifile

if isnull( ls_inifile )  or len(trim( ls_inifile)) = 0 then return

ll_limit_sections = lnv_ini.of_getsections( ls_inifile, ls_sections)
if ll_limit_sections < 1 then return 

dw_debugini.reset()
for ll_i = 1 to ll_limit_sections
	ll_limit_keys = lnv_ini.of_getkeys( ls_inifile, ls_sections[ll_i], ls_keys)
	for ll_j = 1 to ll_limit_keys
		ll_row = dw_debugini.insertrow(0)
		if ll_row < 1 then return
		dw_debugini.setitem( ll_row, 'section', ls_sections[ll_i] )
		dw_debugini.setitem( ll_row, 'entry',  ls_keys[ll_j] )
		ls_value = Profilestring( ls_inifile, ls_sections[ll_i], ls_keys[ll_j], "" )
		dw_debugini.setitem( ll_row, 'value', ls_value )		
	next
next

dw_debugini.resetupdate()
dw_debugini.groupcalc( )
end subroutine

on pfc_w_debugini.create
int iCurrent
call super::create
this.dw_debugini=create dw_debugini
this.cb_print=create cb_print
this.cb_close=create cb_close
this.cb_dlghelp=create cb_dlghelp
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_debugini
this.Control[iCurrent+2]=this.cb_print
this.Control[iCurrent+3]=this.cb_close
this.Control[iCurrent+4]=this.cb_dlghelp
end on

on pfc_w_debugini.destroy
call super::destroy
destroy(this.dw_debugini)
destroy(this.cb_print)
destroy(this.cb_close)
destroy(this.cb_dlghelp)
end on

event pfc_preopen;//////////////////////////////////////////////////////////////////////////////
//
//	Object Name:	pfc_w_debugini
//
//	Description:	A utility object used to display Application's Ini files contents.
//						Use the n_cst_debug service to call this object.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	2019	Initial Version
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
inv_resize.of_SetMinSize( 1500, (cb_print.Height + 30) * 3)
	
//Register each control that needs to move or resize after the window resizes
inv_resize.of_Register (cb_print, inv_resize.FIXEDRIGHT)
inv_resize.of_Register (cb_close, inv_resize.FIXEDRIGHT)
inv_resize.of_Register (dw_debugini, inv_resize.SCALERIGHTBOTTOM)
inv_resize.of_register (cb_dlghelp, inv_resize.FIXEDRIGHT)

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

// If appropriate force this window to be on top.
of_SetAlwaysOnTop(gnv_app.inv_debug.of_GetAlwaysOnTop())

// Make sure that PFC does not report updates pending for this window.
dw_debugini.of_SetUpdateable(true)
ib_disableclosequery = true

// Refresh content
of_refresh( )

end event

event pfc_close;call super::pfc_close;dw_debugini.accepttext( )
end event

type st_debuginfoclass from w_main`st_debuginfoclass within pfc_w_debugini
end type

type dw_debugini from u_dw within pfc_w_debugini
integer x = 18
integer y = 20
integer width = 2400
integer height = 564
integer taborder = 10
string dataobject = "d_debugini"
boolean hscrollbar = true
end type

event constructor;call super::constructor;ib_rmbmenu = false
end event

event itemchanged;call super::itemchanged;string ls_inifile
string	ls_section
string	ls_entry

if row < 1 then return

choose case dwo.name
	case 'value'
		ls_inifile		= gnv_app.of_getappinifile( )
		ls_section 	= dw_debugini.Getitemstring( row, "section" )
		ls_entry		= dw_debugini.Getitemstring( row, "entry" )
		
		SetProfileString( ls_inifile, ls_section, ls_entry, string(data) )
end choose


end event

type cb_print from u_cb within pfc_w_debugini
integer x = 2464
integer y = 24
integer taborder = 20
string text = "&Print"
end type

event clicked;call super::clicked;//////////////////////////////////////////////////////////////////////////////
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

dw_debugini.print( )

end event

type cb_close from u_cb within pfc_w_debugini
integer x = 2464
integer y = 132
integer taborder = 40
string text = "Close"
boolean cancel = true
end type

event clicked;call super::clicked;//////////////////////////////////////////////////////////////////////////////
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

dw_debugini.accepttext( )

close(parent)
end event

type cb_dlghelp from u_cb within pfc_w_debugini
integer x = 2464
integer y = 244
integer taborder = 50
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

