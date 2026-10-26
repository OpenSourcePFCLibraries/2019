$PBExportHeader$pfcscanner_n_cst_target.sru
$PBExportComments$Reads the application and library list of a target
forward
global type pfcscanner_n_cst_target from nonvisualobject
end type
end forward

global type pfcscanner_n_cst_target from nonvisualobject
end type
global pfcscanner_n_cst_target pfcscanner_n_cst_target

forward prototypes
public function integer of_open (string as_file, ref string as_app, ref string as_libs[])
public function string of_readfile (string as_file)
public function string of_folder (string as_path)
public function string of_fullpath (string as_folder, string as_path)
protected function integer of_opentarget (string as_file, ref string as_app, ref string as_libs[])
protected function string of_targetvalue (string as_line)
end prototypes

public function integer of_open (string as_file, ref string as_app, ref string as_libs[]);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_Open
//
//	Access:  public
//
//	Arguments:
//	as_file		A PowerBuilder target (.pbt)
//	as_app		The application's name (passed by reference)
//	as_libs[]	The application's libraries (passed by reference): its .pbl files,
//					or their source folders in the workspace's ws_objects folder when
//					the workspace has one
//
//	Returns:  Integer
//	The number of libraries, -1 if the file can't be read
//
//////////////////////////////////////////////////////////////////////////////

string	ls_empty[]

as_app = ""
as_libs = ls_empty
If Not FileExists(as_file) Then Return -1

If Lower(Mid(as_file, LastPos(as_file, ".") + 1)) = "pbt" Then Return of_OpenTarget(as_file, as_app, as_libs)
Return -1
end function

public function string of_readfile (string as_file);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_ReadFile
//
//	Access:  public
//
//	Arguments:
//	as_file	A text file
//
//	Returns:  String
//	The file's text, or "" if it can't be read
//
//////////////////////////////////////////////////////////////////////////////

integer	li_file
string	ls_text

// UTF-8 (source files have a BOM); otherwise, such as a target, ANSI
li_file = FileOpen(as_file, TextMode!, Read!, Shared!, Replace!, EncodingUTF8!)
If li_file < 0 Then li_file = FileOpen(as_file, TextMode!, Read!, Shared!)
If li_file < 0 Then Return ""
If FileReadEx(li_file, ls_text) < 0 Then ls_text = ""
FileClose(li_file)
Return ls_text
end function

public function string of_folder (string as_path);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_Folder
//
//	Access:  public
//
//	Arguments:
//	as_path	A file's path
//
//	Returns:  String
//	The file's folder, without a trailing backslash
//
//////////////////////////////////////////////////////////////////////////////

long	ll_pos

ll_pos = LastPos(as_path, "\")
If ll_pos = 0 Then Return GetCurrentDirectory()
Return Left(as_path, ll_pos - 1)
end function

public function string of_fullpath (string as_folder, string as_path);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_FullPath
//
//	Access:  public
//
//	Arguments:
//	as_folder	The folder that as_path is relative to
//	as_path		A path, absolute or relative (..\ and .\ are allowed)
//
//	Returns:  String
//	The full path
//
//////////////////////////////////////////////////////////////////////////////

long	ll_pos

as_path = Trim(as_path)
If Mid(as_path, 2, 1) = ":" Or Left(as_path, 2) = "\\" Then Return as_path
If Left(as_path, 1) = "\" Then Return Left(as_folder, 2) + as_path

If Right(as_folder, 1) = "\" Then as_folder = Left(as_folder, Len(as_folder) - 1)
Do While True
	If Left(as_path, 2) = ".\" Then
		as_path = Mid(as_path, 3)
	ElseIf Left(as_path, 3) = "..\" Then
		as_path = Mid(as_path, 4)
		ll_pos = LastPos(as_folder, "\")
		If ll_pos > 0 Then as_folder = Left(as_folder, ll_pos - 1)
	Else
		Exit
	End If
Loop
Return as_folder + "\" + as_path
end function

protected function integer of_opentarget (string as_file, ref string as_app, ref string as_libs[]);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_OpenTarget
//
//	Access:  protected
//
//	Arguments:
//	as_file		A PowerBuilder target (.pbt)
//	as_app		The application's name (passed by reference)
//	as_libs[]	The target's libraries (passed by reference)
//
//	Returns:  Integer
//	The number of libraries, -1 if the target can't be read
//
//	Description:  A target has appname "..."; and LibList "...;...";, with the
//		libraries relative to the target's folder.  A workspace whose objects are
//		kept as source (with source control) has them in its ws_objects folder, as
//		<library path relative to the workspace>.src: that folder is used when it
//		exists, otherwise the .pbl.  The workspace's folder is the nearest folder,
//		from the target's up, that has a ws_objects folder.
//
//////////////////////////////////////////////////////////////////////////////

string	ls_text, ls_line, ls_liblist, ls_folder, ls_lib, ls_source, ls_root
long		ll_pos, ll_end, ll_len
integer	li_count
pfcscanner_n_cst_string	lnv_string

ls_text = of_ReadFile(as_file)
If Len(ls_text) = 0 Then Return -1
ls_folder = of_Folder(as_file)

ll_len = Len(ls_text)
ll_pos = 1
Do While ll_pos <= ll_len
	ll_end = Pos(ls_text, "~n", ll_pos)
	If ll_end = 0 Then ll_end = ll_len + 1
	ls_line = Trim(lnv_string.of_GlobalReplace(Mid(ls_text, ll_pos, ll_end - ll_pos), "~r", ""))
	ll_pos = ll_end + 1
	If Lower(Left(ls_line, 8)) = "appname " Then
		as_app = of_TargetValue(ls_line)
	ElseIf Lower(Left(ls_line, 8)) = "liblist " Then
		ls_liblist = of_TargetValue(ls_line)
	End If
Loop

// the workspace's folder, with ws_objects
ls_root = ls_folder
Do While ls_root <> ""
	If DirectoryExists(ls_root + "\ws_objects") Then Exit
	ll_pos = LastPos(ls_root, "\")
	If ll_pos = 0 Then
		ls_root = ""
	Else
		ls_root = Left(ls_root, ll_pos - 1)
	End If
Loop

Do While Len(ls_liblist) > 0
	ll_pos = Pos(ls_liblist, ";")
	If ll_pos = 0 Then ll_pos = Len(ls_liblist) + 1
	ls_lib = Trim(Left(ls_liblist, ll_pos - 1))
	ls_liblist = Mid(ls_liblist, ll_pos + 1)
	If ls_lib = "" Then Continue

	li_count++
	as_libs[li_count] = of_FullPath(ls_folder, ls_lib)
	If ls_root <> "" And Lower(Left(as_libs[li_count], Len(ls_root) + 1)) = Lower(ls_root + "\") Then
		ls_source = ls_root + "\ws_objects\" + Mid(as_libs[li_count], Len(ls_root) + 2) + ".src"
		If DirectoryExists(ls_source) Then as_libs[li_count] = ls_source
	End If
Loop
Return li_count
end function

protected function string of_targetvalue (string as_line);//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_TargetValue
//
//	Access:  protected
//
//	Arguments:
//	as_line	A line of a target, such as LibList "a.pbl;b\\c.pbl";
//
//	Returns:  String
//	The quoted value, with \\ read as \
//
//////////////////////////////////////////////////////////////////////////////

long	ll_pos, ll_end
pfcscanner_n_cst_string	lnv_string

ll_pos = Pos(as_line, "~"")
If ll_pos = 0 Then Return ""
ll_end = LastPos(as_line, "~"")
If ll_end <= ll_pos Then Return ""
Return lnv_string.of_GlobalReplace(Mid(as_line, ll_pos + 1, ll_end - ll_pos - 1), "\\", "\")
end function

on pfcscanner_n_cst_target.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pfcscanner_n_cst_target.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on
