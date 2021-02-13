$PBExportHeader$w_sort.srw
$PBExportComments$Example usings Sort DW Service
forward
global type w_sort from w_main
end type
type dw_1 from u_dw within w_sort
end type
type cb_sort from u_cb within w_sort
end type
type cb_close from u_cb within w_sort
end type
type rb_1 from u_rb within w_sort
end type
type rb_3 from u_rb within w_sort
end type
type rb_2 from u_rb within w_sort
end type
type rb_4 from u_rb within w_sort
end type
type gb_1 from u_gb within w_sort
end type
end forward

global type w_sort from w_main
integer x = 421
integer y = 68
integer width = 2117
integer height = 1636
string title = "PFC Example - Sort Service Dialogs"
boolean resizable = false
long backcolor = 134217857
dw_1 dw_1
cb_sort cb_sort
cb_close cb_close
rb_1 rb_1
rb_3 rb_3
rb_2 rb_2
rb_4 rb_4
gb_1 gb_1
end type
global w_sort w_sort

forward prototypes
public function integer of_modifydw ()
end prototypes

public function integer of_modifydw ();//////////////////////////////////////////////////////////////////////////////
//
//	Function:
//	of_ModifyDW
//
//	Access:
//	public
//
//	Arguments:
//	None
//
//	Returns:
//	None
//
//	Description:
// Modify the DataWindow Object Properties to disallow editing of data.
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

//Modify the DataWindow Object Properties to disallow editing of data.
dw_1.Modify("first_name.Background.Color='78682240'")
dw_1.Modify("last_name.Background.Color='78682240'")
dw_1.Modify("company_name.Background.Color='78682240'")

dw_1.SetTabOrder("first_name", 0)
dw_1.SetTabOrder("last_name", 0)
dw_1.SetTabOrder("company_name", 0)

return 1
end function

on w_sort.create
int iCurrent
call super::create
this.dw_1=create dw_1
this.cb_sort=create cb_sort
this.cb_close=create cb_close
this.rb_1=create rb_1
this.rb_3=create rb_3
this.rb_2=create rb_2
this.rb_4=create rb_4
this.gb_1=create gb_1
iCurrent=UpperBound(this.Control)
this.Control[iCurrent+1]=this.dw_1
this.Control[iCurrent+2]=this.cb_sort
this.Control[iCurrent+3]=this.cb_close
this.Control[iCurrent+4]=this.rb_1
this.Control[iCurrent+5]=this.rb_3
this.Control[iCurrent+6]=this.rb_2
this.Control[iCurrent+7]=this.rb_4
this.Control[iCurrent+8]=this.gb_1
end on

on w_sort.destroy
call super::destroy
destroy(this.dw_1)
destroy(this.cb_sort)
destroy(this.cb_close)
destroy(this.rb_1)
destroy(this.rb_3)
destroy(this.rb_2)
destroy(this.rb_4)
destroy(this.gb_1)
end on

type dw_1 from u_dw within w_sort
integer x = 27
integer y = 372
integer width = 2030
integer height = 1008
integer taborder = 0
string dataobject = "d_customerlist"
boolean hscrollbar = true
end type

event constructor;//////////////////////////////////////////////////////////////////////////////
//
//	Event:
//	constructor
//
//	Description:
//	Initializes the DataWindow.
//
//////////////////////////////////////////////////////////////////////////////

of_SetTransObject(sqlca) 

parent.of_ModifyDW()
of_SetSort(true) 

inv_sort.of_SetStyle(inv_sort.DRAGDROP)
inv_sort.of_SetColumnNameSource(inv_sort.HEADER)
inv_sort.of_SetVisibleOnly(true)

inv_sort.of_SetUseDisplay(true)
of_SetUpdateable(false)

of_Retrieve()
end event

event pfc_prermbmenu;//////////////////////////////////////////////////////////////////////////////
//
//	Event:
//	pfc_prermbmenu
//
//	Arguments:
//	am_dw   	the menu that will be displayed when the DataWindow
//				is right clicked.
//
//	Returns:
//	None
//
//	Description:
// Initialize the Right Mouse Menu for the DataWindow.
//
//////////////////////////////////////////////////////////////////////////////

am_dw.m_table.m_insert.enabled = false
am_dw.m_table.m_addrow.enabled = false
am_dw.m_table.m_delete.enabled = false

end event

event pfc_retrieve;call super::pfc_retrieve;//////////////////////////////////////////////////////////////////////////////
//
//	Event:
//	pfc_retrieve
//
//	Arguments:
//	None
//
//	Returns:
//	long
//	The number of rows retrieved from the database
// -1 if it fails
// If any argument's value is NULL, pfc_retrieve returns NULL
//
//	Description:
//	Retrieves data into the DataWindow.
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

return this.Retrieve()

end event

type cb_sort from u_cb within w_sort
integer x = 1321
integer y = 1424
integer taborder = 20
string text = "&Set Sort"
end type

event clicked;//////////////////////////////////////////////////////////////////////////////
//
//	Event:
//	clicked
//
//	Description:
//	Calls the pfc_sortdlg event on the DataWindow to invoke the selected
// sort dialog box.
//
//////////////////////////////////////////////////////////////////////////////

dw_1.event pfc_sortdlg()
end event

type cb_close from u_cb within w_sort
integer x = 1696
integer y = 1424
integer taborder = 30
string text = "Close"
boolean cancel = true
end type

event clicked;//////////////////////////////////////////////////////////////////////////////
//
//	Event:
//	clicked
//
//	Description:
//	Calls the pfc_close event on the window.
//
//////////////////////////////////////////////////////////////////////////////

parent.event pfc_close()
end event

type rb_1 from u_rb within w_sort
integer x = 59
integer y = 112
integer width = 731
string text = "Drag/Drop &Columns Style"
boolean checked = true
end type

event clicked;//////////////////////////////////////////////////////////////////////////////
//
//	Event:
//	clicked
//
//	Description:
//	Sets the sort dialog style for the Sort Service.
//
//////////////////////////////////////////////////////////////////////////////

dw_1.inv_sort.of_SetStyle(dw_1.inv_sort.DRAGDROP)
end event

type rb_3 from u_rb within w_sort
integer x = 59
integer y = 200
integer width = 731
boolean bringtotop = true
string text = "&Drop-down List Box Style"
end type

event clicked;//////////////////////////////////////////////////////////////////////////////
//
//	Event:
//	clicked
//
//	Description:
//	Sets the sort dialog style for the Sort Service.
//
//////////////////////////////////////////////////////////////////////////////

dw_1.inv_sort.of_SetStyle(dw_1.inv_sort.DROPDOWNLISTBOX)
end event

type rb_2 from u_rb within w_sort
integer x = 832
integer y = 112
integer width = 731
boolean bringtotop = true
string text = "Si&mple Single Column Style"
end type

event clicked;//////////////////////////////////////////////////////////////////////////////
//
//	Event:
//	clicked
//
//	Description:
//	Sets the sort dialog style for the Sort Service.
//
//////////////////////////////////////////////////////////////////////////////

dw_1.inv_sort.of_SetStyle(dw_1.inv_sort.SIMPLE)
end event

type rb_4 from u_rb within w_sort
integer x = 832
integer y = 200
integer width = 731
boolean bringtotop = true
string text = "&PowerBuilder Default Style"
end type

event clicked;//////////////////////////////////////////////////////////////////////////////
//
//	Event:
//	clicked
//
//	Description:
//	Sets the sort dialog style for the Sort Service.
//
//////////////////////////////////////////////////////////////////////////////

dw_1.inv_sort.of_SetStyle(dw_1.inv_sort.DEFAULT)
end event

type gb_1 from u_gb within w_sort
integer x = 27
integer y = 32
integer width = 2030
integer height = 284
integer taborder = 10
long textcolor = 33554687
long backcolor = 82889382
string text = "Select a Sort Dialog Style"
end type

