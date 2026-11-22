$PBExportHeader$pfc_u_st.sru
$PBExportComments$PFC StaticText class
forward
global type pfc_u_st from statictext
end type
end forward

global type pfc_u_st from statictext
integer width = 343
integer height = 64
integer textsize = -8
integer weight = 400
fontpitch fontpitch = variable!
fontfamily fontfamily = swiss!
string facename = "MS Sans Serif"
long textcolor = 33554432
long backcolor = 80263581
boolean enabled = true
string text = "none"
boolean focusrectangle = false
event lbuttondown pbm_lbuttondown
end type
global pfc_u_st pfc_u_st

type variables
Protected:
boolean		ib_IsObsolete
end variables

forward prototypes
public function integer of_getparentwindow (ref window aw_parent)
protected function integer of_messagebox (string as_id, string as_title, string as_text, icon ae_icon, button ae_button, integer ai_default)
public function string of_getmnemonic ()
public function integer of_focusmnemonictarget ()
protected function integer of_gettaborder (windowobject awo_control, ref integer ai_accelerator)
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

Return MessageBox(as_title, as_text, ae_icon, ae_button, ai_default)
end function

public function string of_getmnemonic ();//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_GetMnemonic
//
//	Access:  public
//
//	Arguments:
//	None
//
//	Returns:  string
//	The label's mnemonic character, in lowercase, or "" if it has none
//
//	Description:
//	Find the mnemonic (access key) character in the label's text: the character
//	after the first single &.  && is a literal &, not a mnemonic.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	2025	Initial version (#116)
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

string	ls_text
long		ll_pos

ls_text = this.Text
If IsNull(ls_text) Then Return ""

ll_pos = Pos(ls_text, "&")
Do While ll_pos > 0 And ll_pos < Len(ls_text)
	If Mid(ls_text, ll_pos + 1, 1) <> "&" Then Return Lower(Mid(ls_text, ll_pos + 1, 1))
	// && is a literal &: look after it
	ll_pos = Pos(ls_text, "&", ll_pos + 2)
Loop

Return ""
end function

public function integer of_focusmnemonictarget ();//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_FocusMnemonicTarget
//
//	Access:  public
//
//	Arguments:
//	None
//
//	Returns:  integer
//	 1 = the focus was moved
//	 0 = the label has no mnemonic, or there is no control to move the focus to
//	-1 = error
//
//	Description:
//	Move the focus from the label to the control it describes, as a Windows dialog
//	does when the user presses Alt and the label's mnemonic.  The control is one
//	in the label's parent window or user object (or tab page) that can take focus
//	(visible, enabled, and with a tab order):
//	- the control whose Accelerator is the label's mnemonic, which is how
//	  PowerBuilder associates a label with an edit control; otherwise
//	- the nearest control to the right of the label on the same line; otherwise
//	- the nearest control below the label that is in line with it.
//	The control array of a PowerBuilder window isn't in tab order, and a label has
//	no tab order, so the layout stands in for "the next control in tab order".
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	2025	Initial version (#116)
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

integer			li_i, li_count, li_accelerator
string			ls_mnemonic
powerobject		lpo_parent
window			lw_parent
userobject		luo_parent
windowobject	lwo_controls[]
dragobject		ldo_control, ldo_target, ldo_right, ldo_below

ls_mnemonic = of_GetMnemonic()
If ls_mnemonic = "" Then Return 0

// The controls next to the label
lpo_parent = this.GetParent()
If IsNull(lpo_parent) Or Not IsValid(lpo_parent) Then Return -1
Choose Case lpo_parent.TypeOf()
	Case Window!
		lw_parent = lpo_parent
		lwo_controls = lw_parent.Control
	Case UserObject!
		// Includes tab pages
		luo_parent = lpo_parent
		lwo_controls = luo_parent.Control
	Case Else
		Return 0
End Choose

li_count = UpperBound(lwo_controls)
For li_i = 1 To li_count
	// A control that can take focus (of_GetTabOrder > 0) is a drag object
	If of_GetTabOrder(lwo_controls[li_i], li_accelerator) <= 0 Then Continue
	ldo_control = lwo_controls[li_i]

	// The control whose accelerator is the mnemonic
	If li_accelerator > 0 Then
		If Lower(String(Char(li_accelerator))) = ls_mnemonic Then
			ldo_target = ldo_control
			Exit
		End If
	End If

	If ldo_control.Y < this.Y + this.Height And ldo_control.Y + ldo_control.Height > this.Y Then
		// On the same line: the nearest one to the right
		If ldo_control.X > this.X Then
			If Not IsValid(ldo_right) Then
				ldo_right = ldo_control
			ElseIf ldo_control.X < ldo_right.X Then
				ldo_right = ldo_control
			End If
		End If
	ElseIf ldo_control.Y > this.Y Then
		// Below, and in line: the nearest one
		If ldo_control.X < this.X + this.Width And ldo_control.X + ldo_control.Width > this.X Then
			If Not IsValid(ldo_below) Then
				ldo_below = ldo_control
			ElseIf ldo_control.Y < ldo_below.Y Then
				ldo_below = ldo_control
			End If
		End If
	End If
Next

If Not IsValid(ldo_target) Then ldo_target = ldo_right
If Not IsValid(ldo_target) Then ldo_target = ldo_below
If Not IsValid(ldo_target) Then Return 0

If ldo_target.SetFocus() <> 1 Then Return -1
Return 1
end function

protected function integer of_gettaborder (windowobject awo_control, ref integer ai_accelerator);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_GetTabOrder
//
//	Access:  protected
//
//	Arguments:
//	awo_control		A control
//	ai_accelerator	The control's Accelerator (an ASCII code), or 0 if it has none
//						(passed by reference)
//
//	Returns:  integer
//	The control's tab order, or 0 if it can't take the focus from a label's
//	mnemonic (not visible, disabled, or a kind of control that doesn't take focus)
//
//	Description:
//	For of_FocusMnemonicTarget: whether a control can take the focus, and its
//	accelerator.  TabOrder, Accelerator and Enabled are properties of each kind of
//	control, not of an ancestor, so each kind is cast.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	2025	Initial version (#116)
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

integer						li_taborder
boolean						lb_enabled
singlelineedit				lsle
multilineedit				lmle
editmask						lem
dropdownlistbox			lddlb
dropdownpicturelistbox	lddplb
listbox						llb
picturelistbox				lplb
listview						llv
treeview						ltv
richtextedit				lrte
datepicker					ldp
monthcalendar				lmc
checkbox						lcbx
radiobutton					lrb
commandbutton				lcb
picturebutton				lpb
datawindow					ldw
userobject					luo
tab							ltab

ai_accelerator = 0
If IsNull(awo_control) Or Not IsValid(awo_control) Then Return 0
If Not awo_control.Visible Then Return 0

Choose Case awo_control.TypeOf()
	Case SingleLineEdit!
		lsle = awo_control
		li_taborder = lsle.TabOrder
		lb_enabled = lsle.Enabled
		ai_accelerator = lsle.Accelerator
	Case MultiLineEdit!
		lmle = awo_control
		li_taborder = lmle.TabOrder
		lb_enabled = lmle.Enabled
		ai_accelerator = lmle.Accelerator
	Case EditMask!
		lem = awo_control
		li_taborder = lem.TabOrder
		lb_enabled = lem.Enabled
		ai_accelerator = lem.Accelerator
	Case DropDownListBox!
		lddlb = awo_control
		li_taborder = lddlb.TabOrder
		lb_enabled = lddlb.Enabled
		ai_accelerator = lddlb.Accelerator
	Case DropDownPictureListBox!
		lddplb = awo_control
		li_taborder = lddplb.TabOrder
		lb_enabled = lddplb.Enabled
		ai_accelerator = lddplb.Accelerator
	Case ListBox!
		llb = awo_control
		li_taborder = llb.TabOrder
		lb_enabled = llb.Enabled
		ai_accelerator = llb.Accelerator
	Case PictureListBox!
		lplb = awo_control
		li_taborder = lplb.TabOrder
		lb_enabled = lplb.Enabled
		ai_accelerator = lplb.Accelerator
	Case ListView!
		llv = awo_control
		li_taborder = llv.TabOrder
		lb_enabled = llv.Enabled
		ai_accelerator = llv.Accelerator
	Case TreeView!
		ltv = awo_control
		li_taborder = ltv.TabOrder
		lb_enabled = ltv.Enabled
		ai_accelerator = ltv.Accelerator
	Case RichTextEdit!
		lrte = awo_control
		li_taborder = lrte.TabOrder
		lb_enabled = lrte.Enabled
		ai_accelerator = lrte.Accelerator
	Case DatePicker!
		ldp = awo_control
		li_taborder = ldp.TabOrder
		lb_enabled = ldp.Enabled
		ai_accelerator = ldp.Accelerator
	Case MonthCalendar!
		lmc = awo_control
		li_taborder = lmc.TabOrder
		lb_enabled = lmc.Enabled
		ai_accelerator = lmc.Accelerator
	Case CheckBox!
		lcbx = awo_control
		li_taborder = lcbx.TabOrder
		lb_enabled = lcbx.Enabled
	Case RadioButton!
		lrb = awo_control
		li_taborder = lrb.TabOrder
		lb_enabled = lrb.Enabled
	Case CommandButton!
		lcb = awo_control
		li_taborder = lcb.TabOrder
		lb_enabled = lcb.Enabled
	Case PictureButton!
		lpb = awo_control
		li_taborder = lpb.TabOrder
		lb_enabled = lpb.Enabled
	Case DataWindow!
		ldw = awo_control
		li_taborder = ldw.TabOrder
		lb_enabled = ldw.Enabled
	Case UserObject!
		luo = awo_control
		li_taborder = luo.TabOrder
		lb_enabled = luo.Enabled
	Case Tab!
		ltab = awo_control
		li_taborder = ltab.TabOrder
		lb_enabled = ltab.Enabled
	Case Else
		// Labels, group boxes, pictures, drawing objects...
		Return 0
End Choose

If IsNull(li_taborder) Or li_taborder <= 0 Then
	ai_accelerator = 0
	Return 0
End If

If Not lb_enabled Then
	ai_accelerator = 0
	Return 0
End If

Return li_taborder
end function

event getfocus;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  			getfocus
//
//	(Arguments:		None)
//
//	(Returns:  		None)
//
//	Description:	If appropriate, notify the parent window that this
//						control got focus.  When the label got focus from Alt and its
//						mnemonic, move the focus on to the control it describes.
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	5.0   Initial version
//	2025	Move the focus on from Alt+mnemonic (#116)
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

window 	lw_parent

// Alt and the label's mnemonic give it the focus, since it is enabled (#116).  Move the
// focus on to the control the label describes, as Windows dialogs do.  A click doesn't
// give the label focus (lbuttondown ignores it), except in a descendant that takes clicks,
// which keeps the focus.
If KeyDown(KeyAlt!) And Not KeyDown(KeyLeftButton!) Then
	If of_GetMnemonic() <> "" Then this.Post of_FocusMnemonicTarget()
End If

//Check for microhelp requirements.
If gnv_app.of_GetMicrohelp() Then
	//Notify the parent.
	of_GetParentWindow(lw_parent)
	If IsValid(lw_parent) Then
		lw_parent.Dynamic Event pfc_ControlGotFocus (this)
	End If
End If

end event

event lbuttondown;//////////////////////////////////////////////////////////////////////////////
//
//	Event:  			lbuttondown
//
//	Arguments:
//	flags
//	xpos
//	ypos
//
//	Returns:  		long
//	1 = the label ignores the click
//
//	Description:	Ignore a click on the label, so that it doesn't take focus
//						from the control the user is working in, and clicked doesn't
//						occur.  Since PFC 5.0, u_st was created disabled for the same
//						effect, but themes draw disabled labels grey (#116).
//						For a label that reacts to clicks, override this event (don't
//						call the ancestor) and return 0.
//
//////////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version
//	2025	Initial version (#116)
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

Return 1
end event

on pfc_u_st.create
end on

on pfc_u_st.destroy
end on

