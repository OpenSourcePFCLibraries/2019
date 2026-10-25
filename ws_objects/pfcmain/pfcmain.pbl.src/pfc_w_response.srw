$PBExportHeader$pfc_w_response.srw
$PBExportComments$PFC Response Window class
forward
global type pfc_w_response from w_master
end type
end forward

global type pfc_w_response from w_master
integer x = 215
integer y = 220
integer width = 2514
integer height = 1508
boolean controlmenu = false
boolean minbox = false
boolean maxbox = false
boolean resizable = false
windowtype windowtype = response!
boolean clientedge = true
event pfc_default ( )
event pfc_cancel ( )
event pfc_apply ( )
event ue_syscommand pbm_syscommand
end type
global pfc_w_response pfc_w_response

type variables
Protected:

	Boolean		#ControlMenu					= TRUE
	Boolean		#MinBox							= FALSE
	Boolean		#MaxBox							= FALSE
	Boolean		#CloseBox						= TRUE
	Boolean		#Resizable						= FALSE

	// TRUE to make the window larger at open, if its work area is too small for
	// its controls (see of_FitWorkSpace)
	Boolean		ib_FitWorkSpace					= TRUE

Private:

	n_cst_platForm				invo_platForm
	n_cst_platFormAttrib		invo_constants
end variables

forward prototypes
protected function integer of_fitworkspace ()
end prototypes

protected function integer of_fitworkspace ();//////////////////////////////////////////////////////////////////////////////
//
//	Function:		of_FitWorkSpace
//
//	Access:			Protected
//
//	Arguments:		None
//
//	Returns:			Integer
//						 1 = the window was made larger
//						 0 = the controls fit, or ib_FitWorkSpace is FALSE
//
//	Description:	Makes the window larger, if necessary, so that its work area holds its
//						visible controls (not the drawing objects), with as much room on the
//						right and at the bottom as on the left and at the top (up to 64 units,
//						at least 18).  The window is never made smaller.
//
//						PowerBuilder gives a window the work area of its design (WorkSpaceWidth
//						and WorkSpaceHeight before it is resized), with today's larger frame
//						around it, but a size set with Resize includes the frame.  A window
//						that is resized at open has to allow for that (see pfc_w_restorerow).
//
//						Called from pfc_preopen, before the descendant's open script, so a
//						dialog that sizes itself still does.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	2025	Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
// Open Source PowerBuilder Foundation Class Libraries
//
// Copyright (c) 2004-2017, All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted in accordance with the MIT License
//
// https://opensource.org/licenses/MIT
//
// This software consists of voluntary contributions made by many
// individuals and was originally based on software copyright (c)
// 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
// information on the Open Source PowerBuilder Foundation Class
// Libraries see https://github.com/OpenSourcePFCLibraries
//
//////////////////////////////////////////////////////////////////////////////

integer	li_i, li_count
long		ll_left = 32767, ll_top = 32767, ll_right, ll_bottom, ll_controlbottom
long		ll_needwidth, ll_needheight
dragobject	ldo_control

If Not ib_FitWorkSpace Then Return 0

// The extent of the visible controls
li_count = UpperBound(this.Control)
For li_i = 1 To li_count
	If IsNull(this.Control[li_i]) Or Not IsValid(this.Control[li_i]) Then Continue
	Choose Case this.Control[li_i].TypeOf()
		Case Line!, Oval!, Rectangle!, RoundRectangle!
			// Drawing objects (a line has no position or size of its own)
			Continue
	End Choose
	ldo_control = this.Control[li_i]
	If Not ldo_control.Visible Then Continue
	Choose Case ldo_control.TypeOf()
		Case DropDownListBox!, DropDownPictureListBox!
			// The height includes the list that drops down
			ll_controlbottom = ldo_control.Y + 100
		Case Else
			ll_controlbottom = ldo_control.Y + ldo_control.Height
	End Choose
	ll_left = Min(ll_left, ldo_control.X)
	ll_top = Min(ll_top, ldo_control.Y)
	ll_right = Max(ll_right, ldo_control.X + ldo_control.Width)
	ll_bottom = Max(ll_bottom, ll_controlbottom)
Next
If ll_right = 0 Then Return 0

// The work area the window needs, and the one it has
ll_needwidth = ll_right + Max(18, Min(64, ll_left))
ll_needheight = ll_bottom + Max(18, Min(64, ll_top))
If ll_needwidth <= this.WorkSpaceWidth() And ll_needheight <= this.WorkSpaceHeight() Then Return 0
ll_needwidth = Max(ll_needwidth, this.WorkSpaceWidth())
ll_needheight = Max(ll_needheight, this.WorkSpaceHeight())

// Resize sets the size of the whole window, and the size of its frame is only known
// once the window has been resized
this.Resize(this.Width + 1, this.Height + 1)
this.Resize(ll_needwidth + (this.Width - this.WorkSpaceWidth()), ll_needheight + (this.Height - this.WorkSpaceHeight()))
Return 1
end function

event pfc_cancel;call w_master::pfc_cancel;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  			pfc_Cancel
//
//	(Arguments:		None)
//
//	(Returns:  		None)
//
//	Description:	This process disables the CloseQuery processing so that no
//						checks are done during the close process.
//
//		*Note:	The developer (on the descendant script) should code 
//					any specific actions prior to closing the window and then 
//					Close the window.
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

/* Allow window to close without the CloseQuery checks being performed */
ib_disableclosequery = True

end event

event ue_syscommand;/////////////////////////////////////////////////////////////////////////
//
//	Event:	  		ue_sysCommand
//
// Arguments:		unsignedLong	System command
// Arguments:		integer			X position of cursor
// Arguments:		integer			Y position of cursor
//
//	Returns:			Long
//
//	Description: 	Mapped to pbm_sysCommand.  The purpose here is to prevent
//						the window from being closed using Alt-F4 when the close
//						sysMenu option has been disabled.
//
/////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version			12.5				Initial version, prevent Alt-F4 is the
//											close button has been disabled.
//						12.5				11-Dec-2014, modified logic to check if
//											the developer has changed the default PFC
//											controlMenu setting.
//
/////////////////////////////////////////////////////////////////////////
//
// Open Source PowerBuilder Foundation Class Libraries
//
// Copyright (c) 2004-2017, All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted in accordance with the MIT License
// 
// 
// https://opensource.org/licenses/MIT
// 
// This software consists of voluntary contributions made by many
// individuals and was originally based on software copyright (c) 
// 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
// information on the Open Source PowerBuilder Foundation Class
// Libraries see https://github.com/OpenSourcePFCLibraries
//
/////////////////////////////////////////////////////////////////////////

//	The default for the controlMenu property on pfc response windows is
//	FALSE.  Only do resize logic if developer has not changed the
//	controlMenu property.
IF NOT controlMenu THEN
	IF NOT #closeBox THEN
		IF commandType = invo_constants.SC_CLOSE THEN
			
			message.Processed		= TRUE
			message.ReturnValue	= 1
			
		END IF
	END IF
END IF
end event

on pfc_w_response.create
call super::create
end on

on pfc_w_response.destroy
call super::destroy
end on

event pfc_preopen;call super::pfc_preopen;/////////////////////////////////////////////////////////////////////////
//
//	Event:	  		pfc_preOpen
//
// Arguments:		None
//
//	Returns:			None
//
//	Description: 	Triggered from the top of the open event.
//
/////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version			12.5				Initial version, provide ability to
//											make a response window resizable.
//						12.5				Adjust size of window when resizable is
//											set to true.  Border is thicker for
//											resizable windows.
//						2025				Make the work area big enough for the
//											controls (of_FitWorkSpace).
/////////////////////////////////////////////////////////////////////////
//
// Open Source PowerBuilder Foundation Class Libraries
//
// Copyright (c) 2004-2017, All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted in accordance with the MIT License
// 
// 
// https://opensource.org/licenses/MIT
// 
// This software consists of voluntary contributions made by many
// individuals and was originally based on software copyright (c) 
// 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
// information on the Open Source PowerBuilder Foundation Class
// Libraries see https://github.com/OpenSourcePFCLibraries
//
/////////////////////////////////////////////////////////////////////////

//	The default for the controlMenu property on pfc response windows is
//	FALSE.  Only do resize logic if developer has not changed the
//	controlMenu property.
IF NOT controlMenu THEN
	
	unsignedLong				lul_hWnd
	lul_hWnd						= Handle(this)
	
	n_cst_winSrv_style		lnvo_style
	lnvo_style					= CREATE n_cst_winSrv_style
	
	f_setPlatForm(invo_platForm, TRUE)

	//	Window is resizable
	IF #Resizable THEN
		
		lnvo_style.of_style(lul_hWnd, invo_constants.WS_THICKFRAME, TRUE)
		lnvo_style.of_style_extended(lul_hWnd, invo_constants.WS_EX_DLGMODALFRAME, FALSE)
		
		//	Adjust window size to include new thicker border style
		Long						ll_xExpand
		ll_xExpand				= invo_platForm.of_getSystemMetrics(invo_constants.SM_CXSIZEFRAME)	&
									- invo_platForm.of_getSystemMetrics(invo_constants.SM_CXDLGFRAME) + 2

		Long						ll_yExpand
		ll_yExpand				= invo_platForm.of_getSystemMetrics(invo_constants.SM_CYSIZEFRAME)	&
									- invo_platForm.of_getSystemMetrics(invo_constants.SM_CYDLGFRAME)
									
		Width						= Width	+ PixelsToUnits(ll_xExpand * 2, XPixelsToUnits!)
		Height					= Height	+ PixelsToUnits(ll_yExpand * 2, YPixelsToUnits!)
		
	END IF
	
	//	Developer requested a controlMenu
	IF #controlMenu THEN
		
		//	Add the default system menu
		lnvo_style.of_style(lul_hWnd, invo_constants.WS_SYSMENU, TRUE)
	
		UnsignedLong			lul_Menu
		lul_menu					= invo_platForm.GetSystemMenu(lul_hWnd, FALSE)
	
		//	Minimize Box
		IF #minBox THEN
			lnvo_style.of_style(lul_hWnd, invo_constants.WS_MINIMIZEBOX, TRUE)
		ELSE
			invo_platForm.DeleteMenu(lul_Menu, invo_constants.SC_MINIMIZE, invo_constants.MF_BYCOMMAND)
		END IF
	
		//	Maximize Box
		IF #maxBox THEN
			lnvo_style.of_style(lul_hWnd, invo_constants.WS_MAXIMIZEBOX, TRUE)
		ELSE
			invo_platForm.DeleteMenu(lul_Menu, invo_constants.SC_MAXIMIZE, invo_constants.MF_BYCOMMAND)
		END IF
	
		//	Restore is not needed if there is no minimize nor maximize
		IF NOT (#maxBox OR #minBox) THEN
			invo_platForm.DeleteMenu(lul_Menu, invo_constants.SC_RESTORE, invo_constants.MF_BYCOMMAND)
		END IF

		//	Size is not needed if the window is not resizable
		IF NOT (#resizable) THEN
			invo_platForm.DeleteMenu(lul_Menu, invo_constants.SC_SIZE, invo_constants.MF_BYCOMMAND)
		END IF

		//	Turn off/disable the system menu's close.  There is also
		//	code in ue_sysCommand to prevent Alt-F4 from closing the
		//	window when the closeBox is not requested.
		IF NOT #closeBox THEN
			
			invo_platForm.DeleteMenu(lul_Menu, invo_constants.SC_CLOSE, invo_constants.MF_BYCOMMAND)
			invo_platForm.DeleteMenu(lul_menu, invo_platForm.GetMenuItemCount(lul_menu) - 1, invo_constants.MF_BYPOSITION)
		
		END IF
	
	END IF
	
	//	Force Redraw
	invo_platForm.SetWindowPos(lul_hWnd, 0, 0, 0, 0, 0, invo_constants.SWP_NOSIZE + invo_constants.SWP_NOMOVE + invo_constants.SWP_NOZORDER + invo_constants.SWP_FRAMECHANGED)
	invo_platForm.DrawMenuBar(lul_hWnd)
	
	DESTROY lnvo_style

END IF

// Make the work area big enough for the controls, before the descendant's open script
of_FitWorkSpace()
end event

event close;call super::close;/////////////////////////////////////////////////////////////////////////
//
//	Event:	  		Close
//
// Arguments:		None
//
//	Returns:			Long
//
//	Description: 	Standard PowerBuilder close event.
//
/////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version			12.5				Initial version, cleanup of PFC objects.
//
/////////////////////////////////////////////////////////////////////////
//
// Open Source PowerBuilder Foundation Class Libraries
//
// Copyright (c) 2004-2017, All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted in accordance with the MIT License
// 
// 
// https://opensource.org/licenses/MIT
// 
// This software consists of voluntary contributions made by many
// individuals and was originally based on software copyright (c) 
// 1996-2004 Sybase, Inc. http://www.sybase.com.  For more
// information on the Open Source PowerBuilder Foundation Class
// Libraries see https://github.com/OpenSourcePFCLibraries
//
/////////////////////////////////////////////////////////////////////////

f_setPlatForm(invo_platForm, FALSE)
end event

