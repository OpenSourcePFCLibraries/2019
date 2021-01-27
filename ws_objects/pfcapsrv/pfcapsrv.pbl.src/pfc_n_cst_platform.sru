$PBExportHeader$pfc_n_cst_platform.sru
$PBExportComments$PFC Cross Platform service
forward
global type pfc_n_cst_platform from n_base
end type
type rect from structure within pfc_n_cst_platform
end type
end forward

type rect from structure
	long		left
	long		top
	long		right
	long		bottom
end type

global type pfc_n_cst_platform from n_base
end type
global pfc_n_cst_platform pfc_n_cst_platform

type prototypes
Public:

	//	GDI32 - Device Context
	FUNCTION unsignedLong GetDeviceCaps(unsignedLong hDC,unsignedLong nIndex) LIBRARY "gdi32.dll"

	//	User32 - Menu
	FUNCTION Boolean DeleteMenu(unsignedLong hMenu, unsignedInteger uPosition, unsignedInteger uFlags) LIBRARY "user32.dll"
	FUNCTION Boolean DrawMenuBar(unsignedLong hWnd) LIBRARY "user32.dll"
	FUNCTION unsignedLong GetMenu(unsignedLong hWnd) LIBRARY "user32.dll"
	FUNCTION Integer GetMenuItemCount(unsignedLong hMenu) LIBRARY "user32.dll"
	FUNCTION unsignedInteger GetMenuItemID(unsignedLong hMenu, Integer nPos) LIBRARY "user32.dll"
	FUNCTION Integer GetMenuString(unsignedLong hMenu, unsignedInteger uIDItem, REF String lpString, integer nMaxCount, unsignedInteger uFlag) LIBRARY "user32.dll" ALIAS FOR "GetMenuStringA;Ansi" 
	FUNCTION unsignedLong GetSubMenu(unsignedLong hMenu, Integer nPos) LIBRARY "user32.dll"
	FUNCTION unsignedLong GetSystemMenu(unsignedLong hWnd, Boolean bRevert) LIBRARY "user32.dll"
	FUNCTION Boolean InsertMenu(unsignedLong hMenu, unsignedInteger uPosition, unsignedInteger uFlags, unsignedInteger uIDNewItem, REF String lpNewItem) LIBRARY "user32.dll" ALIAS FOR "InsertMenuA;Ansi" 
	FUNCTION Boolean InsertMenu(unsignedLong hMenu, unsignedInteger uPosition, unsignedInteger uFlags, unsignedInteger uIDNewItem) LIBRARY "user32.dll" ALIAS FOR "InsertMenuA;Ansi" 
	FUNCTION Boolean ModifyMenu(unsignedLong hMenu, unsignedInteger uPosition, unsignedInteger uFlags, unsignedInteger uIDNewItem, REF String lpNewItem) LIBRARY "user32.dll" ALIAS FOR "ModifyMenuA;Ansi"
	FUNCTION Boolean ModifyMenu(unsignedLong hMenu, unsignedInteger uPosition, unsignedInteger uFlags, unsignedInteger uIDNewItem) LIBRARY "user32.dll" ALIAS FOR "ModifyMenuA;Ansi"
	FUNCTION Boolean RemoveMenu(unsignedLong hMenu, unsignedInteger uPosition, unsignedInteger uFlags) LIBRARY "user32.dll"
	
	//	User32 - Configuration
	FUNCTION unsignedInteger GetSystemMetrics(Integer nIndex) LIBRARY "user32.dll"
	
	//	User32 - Window
	FUNCTION unsignedLong GetSysColor(Integer nIndex) LIBRARY "user32.dll"
	FUNCTION unsignedLong SetParent(unsignedLong hWndChild, unsignedLong hWndNewParent) LIBRARY "user32.dll"
	FUNCTION Boolean SetWindowPos(unsignedLong hWnd, Integer X, Integer Y, Integer cx, Integer cy, unsignedInteger uFlags) LIBRARY "user32.dll"
	FUNCTION Boolean SetWindowPos(unsignedLong hWnd, unsignedLong hWndInsertAfter, Integer X, Integer Y, Integer cx, Integer cy, unsignedInteger uFlags) LIBRARY "user32.dll"

	//	User32 - Window Class
	FUNCTION Long GetWindowLong(unsignedLong hWnd, Integer nIndex) LIBRARY "user32.dll" ALIAS FOR "GetWindowLongA;Ansi"
	FUNCTION Long SetWindowLong(unsignedLong hWnd, Integer nIndex, unsignedLong dwNewLong) LIBRARY "user32.dll" ALIAS FOR "SetWindowLongA;Ansi"
	
	//	User32 - Device Context
	Function unsignedLong GetDC(unsignedLong hWnd) Library "USER32.DLL"
	Function Integer ReleaseDC(unsignedLong hWnd, unsignedLong hDC) Library "USER32.DLL"
	
Private:

	//	User32 - Window
	FUNCTION Boolean GetClientRect(unsignedLong hWnd, REF Rect lpRect) LIBRARY "user32.dll"

end prototypes

type variables
Protected:
string		is_separator
string		is_ClassName[] = {"FNWND3190", "FNWNS3190"}
end variables

forward prototypes
public function unsignedinteger of_findwindow (string as_window_name)
public function integer of_getactivewindowborder ()
public function string of_getcomputername ()
public function integer of_getfreeresources (integer ai_type)
public function string of_getsystemdirectory ()
public function integer of_gettextsize (ref window aw_obj, string as_text, string as_fontface, integer ai_fontsize, boolean ab_bold, boolean ab_italic, boolean ab_underline, ref integer ai_height, ref integer ai_width)
public function string of_getuserid ()
public function string of_getwindowsdirectory ()
public function string of_getwindowtext (unsignedinteger ai_handle)
public function boolean of_isapprunning (string as_app_name)
public function long of_PageSetupDlg (ref s_pagesetupattrib astr_pagesetup)
public function integer of_playsound (string as_file)
public function integer of_PlaySound (string as_file, boolean ab_beeponfailure)
public function integer of_setfindwindowclasses (string as_classname[])
public function integer of_getknownfolderpath (integer ai_foldercode, ref string as_folderpath)
public function integer of_getknownfolderpath (integer ai_foldercode, boolean ab_currentpath, ref string as_folderpath)
public function unsignedlong of_getsyscolor (integer ai_index)
public function unsignedlong of_getdpix ()
public function unsignedlong of_getdpiy ()
public function integer of_maxpath ()
public function unsignedinteger of_getsystemmetrics (integer ai_index)
public function boolean of_getclientrect (unsignedlong vul_hwnd, ref long rl_left, ref long rl_top, ref long rl_right, ref long rl_bottom)
public function longlong of_getfreememory ()
public function longlong of_getphysicalmemory ()
public function string of_getpbvmname ()
end prototypes

public function unsignedinteger of_findwindow (string as_window_name);//////////////////////////////////////////////////////////////////////////////
//	In case this function is not found in descendant
//////////////////////////////////////////////////////////////////////////////
return 0
end function

public function integer of_getactivewindowborder ();//////////////////////////////////////////////////////////////////////////////
//	In case this function is not found in descendant
//////////////////////////////////////////////////////////////////////////////
return -1
end function

public function string of_getcomputername ();//////////////////////////////////////////////////////////////////////////////
//	In case this function is not found in descendant
//////////////////////////////////////////////////////////////////////////////
return ""
end function

public function integer of_getfreeresources (integer ai_type);//////////////////////////////////////////////////////////////////////////////
//	In case this function is not found in descendant
//////////////////////////////////////////////////////////////////////////////
return -1
end function

public function string of_getsystemdirectory ();//////////////////////////////////////////////////////////////////////////////
//	Public Function:	of_GetSystemDirectory
//	Arguments: 			none
//	Returns:  			string 
//							system directory
//							"" if error			
//	Description:  		Return the window's system directory
//////////////////////////////////////////////////////////////////////////////
//	Rev. History		Version
//							5.0		Initial version
//							5.0.03	Changed Uint variables to Ulong for NT4.0 compatibility
//							12.5		Logic has been moved to fileSrv object.  This is 
//										is here for backward compatibility.
//////////////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////////////////////

n_cst_fileSrv				lnvo_fileSrv

f_setFileSrv(lnvo_fileSrv, TRUE)

String						ls_systemDirectory
ls_systemDirectory		= lnvo_fileSrv.of_getSystemDirectory()

f_setFileSrv(lnvo_fileSrv, FALSE)

Return(ls_systemDirectory)
end function

public function integer of_gettextsize (ref window aw_obj, string as_text, string as_fontface, integer ai_fontsize, boolean ab_bold, boolean ab_italic, boolean ab_underline, ref integer ai_height, ref integer ai_width);//////////////////////////////////////////////////////////////////////////////
//	In case this function is not found in descendant
//////////////////////////////////////////////////////////////////////////////
Return -1
end function

public function string of_getuserid ();//////////////////////////////////////////////////////////////////////////////
//	In case this function is not found in descendant
//////////////////////////////////////////////////////////////////////////////
return ""
end function

public function string of_getwindowsdirectory ();//////////////////////////////////////////////////////////////////////////////
//	Public Function:	of_GetWindowsDirectory
//	Arguments: 			none
//	Returns:  			string 
//							windows directoy
//							"" if error
//	Description:  		Return the window's directory
//////////////////////////////////////////////////////////////////////////////
//	Rev. History		Version
//							5.0   	Initial version
//							5.0.03	Changed int variables to Ulong for NT4.0 compatibility
//							12.5		Logic has been moved to fileSrv object.  This is 
//										is here for backward compatibility.
//////////////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////////////////////

n_cst_fileSrv				lnvo_fileSrv

f_setFileSrv(lnvo_fileSrv, TRUE)

String						ls_windowsDirectory
ls_windowsDirectory		= lnvo_fileSrv.of_getWindowsDirectory()

f_setFileSrv(lnvo_fileSrv, FALSE)

Return(ls_windowsDirectory)

end function

public function string of_getwindowtext (unsignedinteger ai_handle);//////////////////////////////////////////////////////////////////////////////
//	In case this function is not found in descendant
//////////////////////////////////////////////////////////////////////////////
return ""
end function

public function boolean of_isapprunning (string as_app_name);//////////////////////////////////////////////////////////////////////////////
//	In case this function is not found in descendant
//////////////////////////////////////////////////////////////////////////////
boolean lb_temp
setnull (lb_temp)
return lb_temp
end function

public function long of_PageSetupDlg (ref s_pagesetupattrib astr_pagesetup);//////////////////////////////////////////////////////////////////////////////
// Public Function:		of_PageSetupDlg
//	Arguments:			astr_pagesetup -  page setup structure by ref
//	Returns: 				1 = success
//	 						0 = User cancelled from page setup dialog
//							-1 = error
//	Description:  		Opens the page setup dialog
//////////////////////////////////////////////////////////////////////////////
//	Rev. History			Version
//							5.0		Initial version
//////////////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////////////////////
long	ll_rc

ll_rc = OpenWithParm (w_pagesetup, astr_pagesetup)
if ll_rc > 0 then
	astr_pagesetup = message.PowerObjectParm
	if not astr_pagesetup.b_actiontaken then
		ll_rc = 0
	end if
end if

return ll_rc
end function

public function integer of_playsound (string as_file);//////////////////////////////////////////////////////////////////////////////
//	In case this function is not found in descendant
//////////////////////////////////////////////////////////////////////////////
return -1
end function

public function integer of_PlaySound (string as_file, boolean ab_beeponfailure);//////////////////////////////////////////////////////////////////////////////
//	Public Function:		of_PlaySound
//	Arguments: 			as_file - sound file to play
//							ab_beeponfailure - Play a beep if the requested sound fails.
//	Returns:  			integer
//	Description:  		Play a sound file
//////////////////////////////////////////////////////////////////////////////
//	Rev. History			Version
//							6.0		Initial version
//////////////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////////////////////
Integer	li_rc

// Play the sound.
li_rc = of_playsound(as_file)

// Confirm that the sound was played succesfully.
If li_rc <= 0 Then
	// Play a default beep.
	beep(1)
End If

Return li_rc
end function

public function integer of_setfindwindowclasses (string as_classname[]);//////////////////////////////////////////////////////////////////////////////
//	Public Function: 	of_SetFindWindowClasses
//	Arguments: 			as_className[] - An array of window class names to be used by the service. 
//	Returns:  			Integer. Returns 1 if the function succeeds -1 if an error occurs.
//	Description: 		The function sets the class window class names to be used by the service.  of_FindWindow
//							will use all of the class names specified in the as_className array.
//							The defaults are PowerBuilder window class names - "FNWND390" and "FNWNS390".   
//////////////////////////////////////////////////////////////////////////////
//	Rev. History			Version
//							7.0		Initial version
//							8.0		Change PB window class names
//							12.5		Change PB window class names
//////////////////////////////////////////////////////////////////////////////
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
//////////////////////////////////////////////////////////////////////////////
long ll_idx, ll_upper

ll_upper = UpperBound(as_className)

IF ll_upper < 1 THEN return -1

FOR ll_idx = 1 TO ll_upper
	IF IsNull(as_className[ll_idx]) THEN 
		// Nulls are allowed as wildcards
		Continue
	END IF
	
	IF Len(as_className[ll_idx]) < 1 THEN 
		return -1
	END IF
NEXT

is_className = as_className
return 1
end function

public function integer of_getknownfolderpath (integer ai_foldercode, ref string as_folderpath);//////////////////////////////////////////////////////////////////////////////
//	In case this function is not found in descendant
//////////////////////////////////////////////////////////////////////////////
return -1
end function

public function integer of_getknownfolderpath (integer ai_foldercode, boolean ab_currentpath, ref string as_folderpath);//////////////////////////////////////////////////////////////////////////////
//	In case this function is not found in descendant
//////////////////////////////////////////////////////////////////////////////
return -1
end function

public function unsignedlong of_getsyscolor (integer ai_index);/////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_getSysColor
//
//	Access:  		public
//
//	Arguments:		Integer			index indicating the system color to
//											return
//
//	Returns:  		unsignedLong	color requested
//
//	Description: 	Returns a system color for the color requested by the
//						index parameter
//
/////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version			12.5				Initial version
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

Return(getSysColor(ai_index))
end function

public function unsignedlong of_getdpix ();/////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_getDPIX
//
//	Access:  		public
//
//	Arguments:		None
//
//	Returns:  		UnsignedLong	Dots per inch
//
//	Description: 	Returns the number of pixels per logical inch along the
//						screen width
//
/////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version			12.5				Initial version
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

n_cst_platFormAttrib			lnvo_constants

UnsignedLong					lul_DPI,	lul_hDC

lul_hDC							= GetDC(0)
lul_DPI							= GetDeviceCaps(lul_hDC, lnvo_constants.LOGPIXELSX)

ReleaseDC(0, lul_hDC)

Return(lul_DPI)
end function

public function unsignedlong of_getdpiy ();/////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_getDPIY
//
//	Access:  		public
//
//	Arguments:		None
//
//	Returns:  		UnsignedLong	Dots per inch
//
//	Description: 	Returns the number of pixels per logical inch along the
//						screen height
//
/////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version			12.5				Initial version
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

n_cst_platFormAttrib			lnvo_constants

UnsignedLong					lul_DPI,	lul_hDC

lul_hDC							= GetDC(0)
lul_DPI							= GetDeviceCaps(lul_hDC, lnvo_constants.LOGPIXELSY)

ReleaseDC(0, lul_hDC)

Return(lul_DPI)
end function

public function integer of_maxpath ();Return(260)
end function

public function unsignedinteger of_getsystemmetrics (integer ai_index);/////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_getSystemMetrics
//
//	Access:  		public
//
//	Arguments:		Integer			index indicating the system metric to
//											return
//
//	Returns:  		unsignedLong	metric requested
//
//	Description: 	Returns a system metric for the metric requested by the
//						index parameter
//
/////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version			12.5				Initial version
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

Return(getSystemMetrics(ai_index))
end function

public function boolean of_getclientrect (unsignedlong vul_hwnd, ref long rl_left, ref long rl_top, ref long rl_right, ref long rl_bottom);/////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_getClientRect
//
//	Access:  		public
//
//	Arguments:		unsignedLong	A handle to the window whose client
//											coordinates are to be retrieved
//						Long by Ref		Will hold the left pixel position
//						Long by Ref		Will hold the top pixel position
//						Long by Ref		Will hold the right pixel position
//						Long by Reg		Will hold the bottom pixel position
//
//	Returns:  		Boolean			TRUE if call succeeds
//
//	Description: 	Returns the value representing the client rectangle for
//						the handle indicated
//
/////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version			12.5				Initial version
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

Rect								lstr_rectangle

Boolean							lb_RC
lb_RC								= getClientRect(vul_hWnd, lstr_rectangle)

rl_left							= lstr_rectangle.Left
rl_top							= lstr_rectangle.Top
rl_right							= lstr_rectangle.Right
rl_bottom						= lstr_rectangle.Bottom

Return(lb_RC)
end function

public function longlong of_getfreememory ();//////////////////////////////////////////////////////////////////////////////
//	In case this function is not found in descendant
//////////////////////////////////////////////////////////////////////////////
return -1
end function

public function longlong of_getphysicalmemory ();//////////////////////////////////////////////////////////////////////////////
//	In case this function is not found in descendant
//////////////////////////////////////////////////////////////////////////////
return -1
end function

public function string of_getpbvmname ();/////////////////////////////////////////////////////////////////////////
//
//	Function:  		of_getPBVMName
//
//	Access:  			public
//
//	Arguments:		None
//
//	Returns:  		string
//
//	Description: 	Returns the value of the PBVMxxx.DLL's name
//
/////////////////////////////////////////////////////////////////////////
//
//	Revision History
//
//	Version			2019 R3				Initial version
//
/////////////////////////////////////////////////////////////////////////
//
// Open Source PowerBuilder Foundation Class Libraries
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
/////////////////////////////////////////////////////////////////////////

Environment le_env
String ls_vmname
Integer li_major

GetEnvironment(le_env)
li_major = le_env.PBMajorRevision
choose case li_major
		
	case 19
		if le_env.PBMinorRevision > 1 then
			// pb2019 R3 or higher, R3 has a minorRevision of 2 (no more numbers in the DLL names from that revision on)
			ls_vmname = "pbvm.dll" 
		else 
			// pb2019 R1 or R2, R1. R1 has a minorRevision of 0 and R2 has a minorRevision of 1
			ls_vmname = "pbvm190.dll" 
		end if
	
	// Supporting some previous powerbuilder versions, though these should really use their 'own' version of pfc:
	case 12, 17
		choose case le_env.PBMinorRevision
			case 5
				ls_vmname = "pbvm" + String(li_major) + "5.dll"
			case 6
				ls_vmname = "pbvm" + String(li_major) + "6.dll"
			case else
				ls_vmname = "pbvm" + String(li_major) + "0.dll"
		end choose
	
	case IS > 19 // 20, 21, 22, etc. No more numbering in the dll names, not even in revisions:
		ls_vmname = "pbvm.dll"
		
	case else
		ls_vmname = "" // you should not be using this version of pfc
		
end choose

Return ls_vmname

end function

on pfc_n_cst_platform.create
call super::create
end on

on pfc_n_cst_platform.destroy
call super::destroy
end on

event constructor;call super::constructor;//////////////////////////////////////////////////////////////////////////////
//
//	Event: 			constructor
//
//	Arguments:		(none)
//
//	Returns:  		Long - The value zero (0) is always returned by this event.
//
//	Description:	assigns the correct values for is_classes[] depending on powerbuilder version
//
//////////////////////////////////////////////////////////////////////////////
//	
//	Revision History
//
//	Version
//	2019 R3  Initial version
//
//////////////////////////////////////////////////////////////////////////////
//
/*
 * Open Source PowerBuilder Foundation Class Libraries
 *
 * Copyright (c) 2004-2013, All rights reserved.
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
string ls_PBVMName

ls_PBVMName = this.of_getPBVMName()
choose case ls_PBVMName
	case "pbvm.dll"  // pb2019 R3 (and most probably later versions too)
		is_ClassName[1] = "FNWND3" // mdi window
		is_ClassName[2] = "FNWNS3" // response window
	case "pbvm170.dll" // pb2017
		is_ClassName[1] = "FNWND3170" // mdi window
		is_ClassName[2] = "FNWNS3170" // response window
		is_ClassName[3] = "AfxMDIFrame100su" // pb2017 for "dockable MDI" 
	case "pbvm190.dll"  // pb2019 R1 / R2
		is_ClassName[1] = "FNWND3190" // mdi window
		is_ClassName[2] = "FNWNS3190" // response window
		// dockable MDI is now obsolete in pb2019 R2, commented:
		//	is_ClassName[3] = "AfxMDIFrame100su" // pb2019 for "dockable MDI", same as PB2017
	case "pbvm126" // pb 12.6
		is_ClassName[1] = "FNWND3126" // mdi window
		is_ClassName[2] = "FNWNS3126" // response window
	case "pbvm125" // pb 12.5
		is_ClassName[1] = "FNWND3125" // mdi window
		is_ClassName[2] = "FNWNS3125" // response window	
end choose

end event

