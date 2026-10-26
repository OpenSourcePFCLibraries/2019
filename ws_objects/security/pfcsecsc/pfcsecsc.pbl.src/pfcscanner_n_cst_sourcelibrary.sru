$PBExportHeader$pfcscanner_n_cst_sourcelibrary.sru
$PBExportComments$The objects of an application's libraries, read from their source
forward
global type pfcscanner_n_cst_sourcelibrary from nonvisualobject
end type
type os_filetime from structure within pfcscanner_n_cst_sourcelibrary
end type
type os_finddata from structure within pfcscanner_n_cst_sourcelibrary
end type
end forward

type os_filetime from structure
	unsignedlong		ul_lowdatetime
	unsignedlong		ul_highdatetime
end type

type os_finddata from structure
	unsignedlong		ul_fileattributes
	os_filetime		str_creationtime
	os_filetime		str_lastaccesstime
	os_filetime		str_lastwritetime
	unsignedlong		ul_filesizehigh
	unsignedlong		ul_filesizelow
	unsignedlong		ul_reserved0
	unsignedlong		ul_reserved1
	character		ch_filename[260]
	character		ch_alternatefilename[14]
end type

global type pfcscanner_n_cst_sourcelibrary from nonvisualobject
end type
global pfcscanner_n_cst_sourcelibrary pfcscanner_n_cst_sourcelibrary

type prototypes
Function longptr FindFirstFileW (string filename, ref os_finddata findfiledata) Library "kernel32.dll"
Function boolean FindNextFileW (longptr handle, ref os_finddata findfiledata) Library "kernel32.dll"
Function boolean FindClose (longptr handle) Library "kernel32.dll"
end prototypes

type variables
// The objects (d_pfcsecurity_objectlist: name, date, cmt, otype, pbl), in the
// order of the library list.  pbl is the library: a folder of source, or a .pbl.
// Window, menu, user object and DataWindow objects only.
pfcscanner_n_ds	ids_index

// By row of ids_index: the source file ("" in a .pbl), the ancestor, and the
// parsed classes, the class's own and with what it inherits
string	is_file[]
string	is_ancestor[]
pfcscanner_n_cst_classinfo	inv_class[]
pfcscanner_n_cst_classinfo	inv_effective[]

// Libraries of the list that don't exist
string	is_missing[]

pfcscanner_n_cst_target	inv_target
end variables

forward prototypes
public function long of_setlibraries (string as_libs[])
public function long of_getmissing (ref string as_missing[])
public function long of_find (string as_name)
public function string of_getobjecttype (string as_name)
public function string of_getsource (string as_name)
public function string of_getsyntax (string as_dataobject)
public function pfcscanner_n_cst_classinfo of_getclass (string as_name)
public function string of_getsystemtype (string as_class)
public function boolean of_isvisual (string as_class)
public function string of_getobjects ()
public function boolean of_isdefaultselected (string as_name)
protected function long of_addfolder (string as_folder)
protected function long of_addlibrary (string as_library)
protected function string of_getancestor (long al_row)
protected function string of_getcomment (string as_file)
end prototypes

public function long of_setlibraries (string as_libs[]);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_SetLibraries
//	Arguments:		as_libs[]	The application's libraries, in the order of its
//									library list: folders of object source (a
//									workspace's ws_objects\*.pbl.src), or .pbl files
//	Returns:			The number of objects, -1 if no library could be read
//	Description:	Lists the window, menu, user object and DataWindow objects of
//						the libraries.  A library that doesn't exist is skipped
//						(of_GetMissing).
//////////////////////////////////////////////////////////////////////////////
long		ll_l, ll_libs, ll_read, ll_rows
string	ls_lib, ls_empty[]
pfcscanner_n_cst_classinfo	lnv_empty[], lnv_none

ids_index.Reset()
is_file = ls_empty
is_ancestor = ls_empty
is_missing = ls_empty
inv_class = lnv_empty
inv_effective = lnv_empty

ll_libs = UpperBound(as_libs)
For ll_l = 1 To ll_libs
	ls_lib = Trim(as_libs[ll_l])
	If ls_lib = "" Then Continue
	If Right(ls_lib, 1) = "\" Then ls_lib = Left(ls_lib, Len(ls_lib) - 1)
	If DirectoryExists(ls_lib) Then
		of_AddFolder(ls_lib)
		ll_read++
	ElseIf FileExists(ls_lib) Then
		of_AddLibrary(ls_lib)
		ll_read++
	Else
		is_missing[UpperBound(is_missing) + 1] = ls_lib
	End If
Next
If ll_read = 0 Then Return -1

// a parsed class for each object, when it's needed
ll_rows = ids_index.RowCount()
If ll_rows > 0 Then
	inv_class[ll_rows] = lnv_none
	inv_effective[ll_rows] = lnv_none
End If
Return ll_rows
end function

public function long of_getmissing (ref string as_missing[]);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_GetMissing
//	Arguments:		as_missing[]	The libraries of the list that don't exist
//										(passed by reference)
//	Returns:			Their number
//////////////////////////////////////////////////////////////////////////////
as_missing = is_missing
Return UpperBound(as_missing)
end function

public function long of_find (string as_name);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_Find
//	Arguments:		as_name	An object's name
//	Returns:			Its row in the index, 0 if the libraries don't have it.  When
//						two libraries have it, the first in the library list.
//////////////////////////////////////////////////////////////////////////////
as_name = Lower(Trim(as_name))
If as_name = "" Or Pos(as_name, "'") > 0 Or Pos(as_name, "`") > 0 Then Return 0
Return ids_index.Find("name = '" + as_name + "'", 1, ids_index.RowCount())
end function

public function string of_getobjecttype (string as_name);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_GetObjectType
//	Arguments:		as_name	An object's name
//	Returns:			window, menu, userobject or datawindow; "" if there is none
//////////////////////////////////////////////////////////////////////////////
long	ll_row

ll_row = of_Find(as_name)
If ll_row < 1 Then Return ""
Return ids_index.GetItemString(ll_row, "otype")
end function

public function string of_getsource (string as_name);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_GetSource
//	Arguments:		as_name	An object's name
//	Returns:			Its source, "" if there is none: the source file, or the object
//						exported from its .pbl
//////////////////////////////////////////////////////////////////////////////
long		ll_row
string	ls_lib, ls_name

ll_row = of_Find(as_name)
If ll_row < 1 Then Return ""
If is_file[ll_row] <> "" Then Return inv_target.of_ReadFile(is_file[ll_row])

ls_lib = ids_index.GetItemString(ll_row, "pbl")
ls_name = ids_index.GetItemString(ll_row, "name")
Choose Case ids_index.GetItemString(ll_row, "otype")
	Case "window"
		Return LibraryExport(ls_lib, ls_name, ExportWindow!)
	Case "menu"
		Return LibraryExport(ls_lib, ls_name, ExportMenu!)
	Case "userobject"
		Return LibraryExport(ls_lib, ls_name, ExportUserObject!)
	Case "datawindow"
		Return LibraryExport(ls_lib, ls_name, ExportDataWindow!)
End Choose
Return ""
end function

public function string of_getsyntax (string as_dataobject);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_GetSyntax
//	Arguments:		as_dataobject	A DataWindow object's name
//	Returns:			Its syntax, for DataStore.Create; "" if there is none
//	Description:	The source without the lines before the syntax: comments
//						(//objectcomments) and export headers ($PBExportHeader$)
//////////////////////////////////////////////////////////////////////////////
string	ls_source, ls_line
long		ll_end

If of_GetObjectType(as_dataobject) <> "datawindow" Then Return ""
ls_source = of_GetSource(as_dataobject)
Do While Len(ls_source) > 0
	ll_end = Pos(ls_source, "~n")
	If ll_end = 0 Then ll_end = Len(ls_source)
	ls_line = Trim(Left(ls_source, ll_end))
	If Left(ls_line, 2) = "//" Or Left(ls_line, 1) = "$" Or ls_line = "" Then
		ls_source = Mid(ls_source, ll_end + 1)
	Else
		Exit
	End If
Loop
Return ls_source
end function

public function pfcscanner_n_cst_classinfo of_getclass (string as_name);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_GetClass
//	Arguments:		as_name	A window, menu or user object's name
//	Returns:			Its controls, its own and those it inherits from its ancestors
//						in the libraries; an invalid object if the libraries don't
//						have it
//////////////////////////////////////////////////////////////////////////////
long		ll_row
string	ls_ancestor
pfcscanner_n_cst_classinfo	lnv_none, lnv_ancestor, lnv_class, lnv_effective

ll_row = of_Find(as_name)
If ll_row < 1 Then Return lnv_none
If ids_index.GetItemString(ll_row, "otype") = "datawindow" Then Return lnv_none
If IsValid(inv_effective[ll_row]) Then Return inv_effective[ll_row]

lnv_class = inv_class[ll_row]
If Not IsValid(lnv_class) Then
	lnv_class = Create pfcscanner_n_cst_classinfo
	lnv_class.of_Parse(of_GetSource(as_name))
	inv_class[ll_row] = lnv_class
	is_ancestor[ll_row] = lnv_class.is_ancestor
End If

lnv_effective = Create pfcscanner_n_cst_classinfo
inv_effective[ll_row] = lnv_effective
ls_ancestor = lnv_class.is_ancestor
If of_Find(ls_ancestor) > 0 And ls_ancestor <> Lower(as_name) Then
	// the placeholder above breaks a loop of ancestors in broken source
	lnv_effective.is_name = Lower(as_name)
	lnv_ancestor = of_GetClass(ls_ancestor)
	lnv_effective.of_Inherit(lnv_ancestor)
End If
lnv_effective.of_Override(lnv_class)
Return lnv_effective
end function

public function string of_getsystemtype (string as_class);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_GetSystemType
//	Arguments:		as_class	A class: one of the libraries' objects, a system class,
//								or ancestor`name for a control inherited from an ancestor
//	Returns:			The system class it is (commandbutton, datawindow, userobject,
//						menu, ...)
//////////////////////////////////////////////////////////////////////////////
long		ll_row, ll_depth, ll_pos, ll_index
string	ls_name
pfcscanner_n_cst_classinfo	lnv_class

as_class = Lower(Trim(as_class))
Do While ll_depth < 50
	ll_depth++
	ll_pos = Pos(as_class, "`")
	If ll_pos > 0 Then
		// a control inherited from an ancestor: the class the ancestor declares it from
		ls_name = Mid(as_class, ll_pos + 1)
		lnv_class = of_GetClass(Left(as_class, ll_pos - 1))
		If Not IsValid(lnv_class) Then Return ""
		ll_index = lnv_class.of_Find(ls_name)
		If ll_index = 0 Then Return ""
		as_class = lnv_class.is_nfrom[ll_index]
		Continue
	End If
	ll_row = of_Find(as_class)
	If ll_row < 1 Then Return as_class
	as_class = of_GetAncestor(ll_row)
	If as_class = "" Then Return ""
Loop
Return ""
end function

public function boolean of_isvisual (string as_class);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_IsVisual
//	Arguments:		as_class	A class
//	Returns:			True if it is a window, menu or control, which the security
//						service can secure; False for a nonvisual object
//////////////////////////////////////////////////////////////////////////////
Choose Case of_GetSystemType(as_class)
	Case "window", "menu", "userobject", "tab", "datawindow", "commandbutton", "checkbox", &
			"radiobutton", "listbox", "dropdownlistbox", "dropdownpicturelistbox", "picturelistbox", &
			"singlelineedit", "multilineedit", "editmask", "richtextedit", "statictext", &
			"statichyperlink", "picturehyperlink", "groupbox", "treeview", "listview", &
			"olecustomcontrol", "olecontrol", "picturebutton", "picture", "graph", "vscrollbar", &
			"hscrollbar", "vprogressbar", "hprogressbar", "vtrackbar", "htrackbar", "animation", &
			"datepicker", "monthcalendar", "inkedit", "inkpicture", "webbrowser", "ribbonbar", &
			"line", "rectangle", "roundrectangle", "oval"
		Return True
End Choose
Return False
end function

public function string of_getobjects ();//////////////////////////////////////////////////////////////////////////////
//	Function:		of_GetObjects
//	Returns:			The objects that can be scanned, for ImportString into
//						d_pfcsecurity_objectlist (name, date, cmt, otype, pbl; a line
//						for each object): windows, menus, visual user objects and
//						DataWindow objects.  Nonvisual objects aren't listed.
//////////////////////////////////////////////////////////////////////////////
long		ll_row, ll_rows, ll_col
string	ls_objects, ls_value
string	ls_columns[] = {"name", "date", "cmt", "otype", "pbl"}

ll_rows = ids_index.RowCount()
For ll_row = 1 To ll_rows
	If ids_index.GetItemString(ll_row, "otype") = "userobject" Then
		If Not of_IsVisual(ids_index.GetItemString(ll_row, "name")) Then Continue
	End If
	For ll_col = 1 To 5
		ls_value = ids_index.GetItemString(ll_row, ls_columns[ll_col])
		If IsNull(ls_value) Then ls_value = ""
		If ll_col > 1 Then ls_objects += "~t"
		ls_objects += ls_value
	Next
	ls_objects += "~r~n"
Next
Return ls_objects
end function

protected function long of_addfolder (string as_folder);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_AddFolder
//	Arguments:		as_folder	A library's folder of source
//	Returns:			The number of objects added
//////////////////////////////////////////////////////////////////////////////
longptr		ll_handle
long			ll_row, ll_count
string		ls_file, ls_otype
os_finddata	lstr_find

ll_handle = FindFirstFileW(as_folder + "\*.sr?", lstr_find)
If ll_handle = -1 Or ll_handle = 0 Then Return 0
Do
	ls_file = String(lstr_find.ch_filename)
	Choose Case Lower(Right(ls_file, 4))
		Case ".srw"
			ls_otype = "window"
		Case ".srm"
			ls_otype = "menu"
		Case ".sru"
			ls_otype = "userobject"
		Case ".srd"
			ls_otype = "datawindow"
		Case Else
			ls_otype = ""
	End Choose
	If ls_otype <> "" Then
		ll_row = ids_index.InsertRow(0)
		ids_index.SetItem(ll_row, "name", Lower(Left(ls_file, Len(ls_file) - 4)))
		ids_index.SetItem(ll_row, "otype", ls_otype)
		ids_index.SetItem(ll_row, "pbl", as_folder)
		ids_index.SetItem(ll_row, "cmt", of_GetComment(as_folder + "\" + ls_file))
		is_file[ll_row] = as_folder + "\" + ls_file
		is_ancestor[ll_row] = ""
		ll_count++
	End If
Loop While FindNextFileW(ll_handle, lstr_find)
FindClose(ll_handle)
Return ll_count
end function

protected function long of_addlibrary (string as_library);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_AddLibrary
//	Arguments:		as_library	A .pbl
//	Returns:			The number of objects added
//////////////////////////////////////////////////////////////////////////////
long	ll_first, ll_row, ll_rows, ll_count

ll_first = ids_index.RowCount() + 1
ids_index.ImportString(LibraryDirectoryEx(as_library, DirAll!))
ll_rows = ids_index.RowCount()
For ll_row = ll_rows To ll_first Step -1
	Choose Case Lower(ids_index.GetItemString(ll_row, "otype"))
		Case "window", "menu", "userobject", "datawindow"
			ids_index.SetItem(ll_row, "name", Lower(ids_index.GetItemString(ll_row, "name")))
			ids_index.SetItem(ll_row, "otype", Lower(ids_index.GetItemString(ll_row, "otype")))
			ids_index.SetItem(ll_row, "pbl", as_library)
		Case Else
			ids_index.RowsDiscard(ll_row, ll_row, Primary!)
	End Choose
Next
ll_rows = ids_index.RowCount()
For ll_row = ll_first To ll_rows
	is_file[ll_row] = ""
	is_ancestor[ll_row] = ""
	ll_count++
Next
Return ll_count
end function

protected function string of_getancestor (long al_row);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_GetAncestor
//	Arguments:		al_row	A row of the index
//	Returns:			The object's ancestor, from its global type line
//////////////////////////////////////////////////////////////////////////////
string	ls_source
long		ll_pos, ll_end
pfcscanner_n_cst_classinfo	lnv_class

If is_ancestor[al_row] <> "" Then Return is_ancestor[al_row]
If ids_index.GetItemString(al_row, "otype") = "datawindow" Then Return ""

// the global type line is near the top: parse only that much
ls_source = of_GetSource(ids_index.GetItemString(al_row, "name"))
ll_pos = Pos(Lower(Left(ls_source, 4000)), "global type ")
If ll_pos = 0 Then Return ""
ll_end = Pos(ls_source, "~n", ll_pos)
If ll_end = 0 Then ll_end = Len(ls_source) + 1
lnv_class = Create pfcscanner_n_cst_classinfo
lnv_class.of_Parse(Mid(ls_source, ll_pos, ll_end - ll_pos))
is_ancestor[al_row] = lnv_class.is_ancestor
Destroy lnv_class
Return is_ancestor[al_row]
end function

protected function string of_getcomment (string as_file);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_GetComment
//	Arguments:		as_file	An object's source file
//	Returns:			Its comments: //objectcomments in a solution, $PBExportComments$
//						in a workspace
//////////////////////////////////////////////////////////////////////////////
integer	li_file, li_line
string	ls_line, ls_comment

li_file = FileOpen(as_file, LineMode!, Read!, Shared!, Replace!, EncodingUTF8!)
If li_file < 0 Then li_file = FileOpen(as_file, LineMode!, Read!, Shared!)
If li_file < 0 Then Return ""
For li_line = 1 To 2
	If FileRead(li_file, ls_line) < 0 Then Exit
	If Left(ls_line, 1) = Char(65279) Then ls_line = Mid(ls_line, 2)
	If Left(ls_line, 17) = "//objectcomments " Then
		ls_comment = Mid(ls_line, 18)
		Exit
	ElseIf Left(ls_line, 18) = "$PBExportComments$" Then
		ls_comment = Mid(ls_line, 19)
		Exit
	End If
Next
FileClose(li_file)
Return Left(ls_comment, 500)
end function

public function boolean of_isdefaultselected (string as_name);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_IsDefaultSelected
//	Arguments:		as_name	An object's name
//	Returns:			True if a scan includes it by default: every object but the
//						PFC ancestor layer (pfc_*), whose objects are never opened
//						themselves
//////////////////////////////////////////////////////////////////////////////
Return Lower(Left(Trim(as_name), 4)) <> "pfc_"
end function

on pfcscanner_n_cst_sourcelibrary.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pfcscanner_n_cst_sourcelibrary.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//////////////////////////////////////////////////////////////////////////////
//	Event:			Constructor
//	Description:	Create the index of objects
//////////////////////////////////////////////////////////////////////////////
ids_index = Create pfcscanner_n_ds
ids_index.DataObject = "d_pfcsecurity_objectlist"
inv_target = Create pfcscanner_n_cst_target
end event

event destructor;//////////////////////////////////////////////////////////////////////////////
//	Event:			Destructor
//	Description:	Destroy the index and the parsed classes
//////////////////////////////////////////////////////////////////////////////
long	ll_i

For ll_i = 1 To UpperBound(inv_class)
	If IsValid(inv_class[ll_i]) Then Destroy inv_class[ll_i]
Next
For ll_i = 1 To UpperBound(inv_effective)
	If IsValid(inv_effective[ll_i]) Then Destroy inv_effective[ll_i]
Next
If IsValid(ids_index) Then Destroy ids_index
If IsValid(inv_target) Then Destroy inv_target
end event
