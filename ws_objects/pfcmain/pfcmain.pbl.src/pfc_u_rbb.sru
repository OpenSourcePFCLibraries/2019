$PBExportHeader$pfc_u_rbb.sru
$PBExportComments$PFC RibbonBar class
forward
global type pfc_u_rbb from ribbonbar
end type
end forward

global type pfc_u_rbb from ribbonbar
integer width = 411
integer height = 460
long backcolor = 15132390
integer textsize = -8
integer weight = 400
fontcharset fontcharset = ansi!
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "Arial"
end type
global pfc_u_rbb pfc_u_rbb

type variables
Protected:
boolean		ib_IsObsolete
end variables
forward prototypes
public function integer of_getparentwindow (ref window aw_parent)
protected function integer of_messagebox (string as_id, string as_title, string as_text, icon ae_icon, button ae_button, integer ai_default)
public function integer of_sethidepaneltext (boolean ab_hide)
public function integer of_sethidetabheader (boolean ab_hide)
protected function integer of_layoutframe ()
end prototypes

public function integer of_getparentwindow (ref window aw_parent);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_GetParentWindow
//
//	Access:  public
//
//	Arguments:
//	aw_parent   The Parent window for this object (passed by reference).
//	   If a parent window is not found, aw_parent is NULL
//
//	Returns:  integer
//	 1 = success
//	-1 = error
//
//	Description:	 Calculates the parent window of a window object
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	2019 R2   Initial version
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

powerobject	lpo_parent

lpo_parent = this.GetParent()

// Loop getting the parent of the object until it is of type window!
do while IsValid (lpo_parent) 
	if lpo_parent.TypeOf() <> window! then
		lpo_parent = lpo_parent.GetParent()
	else
		exit
	end if
loop

if IsNull(lpo_parent) Or not IsValid (lpo_parent) then
	setnull(aw_parent)	
	return -1
end If

aw_parent = lpo_parent
return 1

end function

protected function integer of_messagebox (string as_id, string as_title, string as_text, icon ae_icon, button ae_button, integer ai_default);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  			of_MessageBox
//
//	Access:  			protected
//
//	Arguments:
//	as_id			An ID for the Message.
//	as_title  	Text for title bar
//	as_text		Text for the actual message.
//	ae_icon 		The icon you want to display on the MessageBox.
//	ae_button	Set of CommandButtons you want to display on the MessageBox.
//	ai_default  The default button.
//
//	Returns:  integer
//	Return value of the MessageBox.
//
//	Description:
//	Display a PowerScript MessageBox.  
//	Allow PFC MessageBoxes to be manipulated prior to their actual display.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	2019 R2   Initial version
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

Return MessageBox(as_title, as_text, ae_icon, ae_button, ai_default)
end function

public function integer of_sethidepaneltext (boolean ab_hide);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_SetHidePanelText
//
//	Access:  public
//
//	Arguments:
//	ab_hide   True to hide the panel text, False to show it
//
//	Returns:  integer
//	 1 = success
//	-1 = error
//
//	Description:	Sets HidePanelText and, when the ribbon bar is on a PFC frame,
//		lays out the frame's client area again.  With AutoSizeHeight on, the
//		ribbon bar's height follows its content, so the client area grows or
//		shrinks with it.  Setting the property directly does not lay out the frame.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	2019	Initial version
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

If IsNull (ab_hide) Then Return -1

this.HidePanelText = ab_hide
of_LayoutFrame()

Return 1
end function

public function integer of_sethidetabheader (boolean ab_hide);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_SetHideTabHeader
//
//	Access:  public
//
//	Arguments:
//	ab_hide   True to hide the tab header, False to show it
//
//	Returns:  integer
//	 1 = success
//	-1 = error
//
//	Description:	Sets HideTabHeader and, when the ribbon bar is on a PFC frame,
//		lays out the frame's client area again.  With AutoSizeHeight on, the
//		ribbon bar's height follows its content, so the client area grows or
//		shrinks with it.  Setting the property directly does not lay out the frame.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	2019	Initial version
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

If IsNull (ab_hide) Then Return -1

this.HideTabHeader = ab_hide
of_LayoutFrame()

Return 1
end function

protected function integer of_layoutframe ();//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_LayoutFrame
//
//	Access:  protected
//
//	Arguments:  none
//
//	Returns:  integer
//	 1 = the parent frame was asked to lay out its client area
//	 0 = the parent window is not a PFC frame
//
//	Description:	Asks the parent frame (a w_frame descendant) to lay out its
//		client area around this ribbon bar.  Called after a change that may alter
//		the ribbon bar's height.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	2019	Initial version
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

window				lw_parent
w_frame				lw_frame
classdefinition	lcd_class

If of_GetParentWindow (lw_parent) <> 1 Then Return 0

// Only a PFC frame knows how to lay out its client area
lcd_class = lw_parent.ClassDefinition
Do While IsValid (lcd_class)
	If Lower (lcd_class.Name) = "w_frame" Then Exit
	lcd_class = lcd_class.Ancestor
Loop
If Not IsValid (lcd_class) Then Return 0

lw_frame = lw_parent
lw_frame.of_LayoutClient()

// Again once the ribbon bar has processed the change, in case its height follows later
lw_frame.Post of_LayoutClient()

Return 1
end function

on pfc_u_rbb.create
end on

on pfc_u_rbb.destroy
end on

