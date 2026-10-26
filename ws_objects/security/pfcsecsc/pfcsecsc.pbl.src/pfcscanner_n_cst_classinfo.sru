$PBExportHeader$pfcscanner_n_cst_classinfo.sru
$PBExportComments$The controls of a window, menu or user object, read from its source
forward
global type pfcscanner_n_cst_classinfo from nonvisualobject
end type
end forward

global type pfcscanner_n_cst_classinfo from nonvisualobject
end type
global pfcscanner_n_cst_classinfo pfcscanner_n_cst_classinfo

type variables
// The class: its name, its ancestor (lower case), and the properties the
// scanner uses
string	is_name
string	is_ancestor
string	is_text
string	is_tag
string	is_dataobject
string	is_menuname

// Its nested classes (controls, tab pages, menu items): name, the class it is
// declared from (a class, or ancestor`name for one inherited from an ancestor),
// the nested class it is within ("" for the class itself), and its properties.
// A menu item's text is set in its create event.
long		il_count
string	is_nname[]
string	is_nfrom[]
string	is_nwithin[]
string	is_ntext[]
string	is_ntag[]
string	is_ndataobject[]
end variables

forward prototypes
public function integer of_parse (string as_source)
public function long of_find (string as_name)
public function long of_add (string as_name, string as_from, string as_within)
public function integer of_inherit (pfcscanner_n_cst_classinfo anv_ancestor)
public function integer of_override (pfcscanner_n_cst_classinfo anv_class)
protected function string of_value (string as_line)
protected function integer of_setproperty (long al_index, string as_line)
end prototypes

public function integer of_parse (string as_source);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_Parse
//	Arguments:		as_source	The source of a window, menu or user object, as
//									exported (a .srw, .srm or .sru)
//	Returns:			1 if it's a class, -1 if it isn't
//	Description:	Reads the class and its nested classes:
//							global type <name> from <ancestor>
//							type <name> from <class> within <parent>
//						and in their blocks the text, tag, dataobject and menuname
//						properties, and the text a menu item's create event sets
//						(this.text = ...)
//////////////////////////////////////////////////////////////////////////////
string	ls_line, ls_lower, ls_name, ls_from, ls_within
long		ll_pos, ll_end, ll_len, ll_block, ll_event, ll_from, ll_within
boolean	lb_inblock, lb_inevent

ll_len = Len(as_source)
ll_pos = 1
Do While ll_pos <= ll_len
	ll_end = Pos(as_source, "~n", ll_pos)
	If ll_end = 0 Then ll_end = ll_len + 1
	ls_line = Mid(as_source, ll_pos, ll_end - ll_pos)
	ll_pos = ll_end + 1
	If Right(ls_line, 1) = "~r" Then ls_line = Left(ls_line, Len(ls_line) - 1)
	ls_lower = Lower(ls_line)

	If Left(ls_lower, 12) = "global type " Then
		// global type <name> from <ancestor> [autoinstantiate]
		ll_from = Pos(ls_lower, " from ", 13)
		If ll_from > 0 Then
			If is_name = "" Then
				is_name = Trim(Mid(ls_lower, 13, ll_from - 13))
				ls_from = Trim(Mid(ls_lower, ll_from + 6))
				If Pos(ls_from, " ") > 0 Then ls_from = Left(ls_from, Pos(ls_from, " ") - 1)
				is_ancestor = ls_from
			End If
			lb_inblock = True
			ll_block = 0
		End If
		Continue
	End If

	If Left(ls_lower, 5) = "type " Then
		// type <name> from <class> within <parent>
		lb_inblock = False
		ll_from = Pos(ls_lower, " from ", 6)
		ll_within = Pos(ls_lower, " within ", 6)
		If ll_from > 0 And ll_within > ll_from Then
			ls_name = Trim(Mid(ls_lower, 6, ll_from - 6))
			ls_from = Trim(Mid(ls_lower, ll_from + 6, ll_within - ll_from - 6))
			ls_within = Trim(Mid(ls_lower, ll_within + 8))
			If ls_from <> "structure" Then
				If ls_within = is_name Then ls_within = ""
				ll_block = of_Find(ls_name)
				If ll_block = 0 Then ll_block = of_Add(ls_name, ls_from, ls_within)
				lb_inblock = True
			End If
		End If
		Continue
	End If

	If Left(ls_lower, 8) = "end type" Then
		lb_inblock = False
		Continue
	End If

	If Left(ls_lower, 3) = "on " And Right(ls_lower, 7) = ".create" Then
		ls_name = Trim(Mid(ls_lower, 4, Len(ls_lower) - 10))
		ll_event = of_Find(ls_name)
		lb_inevent = (ll_event > 0)
		Continue
	End If

	If Left(ls_lower, 6) = "end on" Then
		lb_inevent = False
		Continue
	End If

	If lb_inblock Then
		of_SetProperty(ll_block, ls_line)
	ElseIf lb_inevent Then
		ls_lower = Trim(ls_lower)
		If Left(ls_lower, 9) = "this.text" Then
			ll_end = Pos(ls_lower, "=")
			If ll_end > 0 And Trim(Mid(ls_lower, 10, ll_end - 10)) = "" Then
				is_ntext[ll_event] = of_Value(Mid(Trim(ls_line), ll_end + 1))
			End If
		End If
	End If
Loop

If is_name = "" Then Return -1
Return 1
end function

public function long of_find (string as_name);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_Find
//	Arguments:		as_name	A nested class's name
//	Returns:			Its index, 0 if there is none
//////////////////////////////////////////////////////////////////////////////
long	ll_i

as_name = Lower(as_name)
For ll_i = 1 To il_count
	If is_nname[ll_i] = as_name Then Return ll_i
Next
Return 0
end function

public function long of_add (string as_name, string as_from, string as_within);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_Add
//	Arguments:		as_name		A nested class's name
//						as_from		The class it is declared from
//						as_within	The nested class it is within, "" for the class
//	Returns:			Its index
//////////////////////////////////////////////////////////////////////////////
il_count++
is_nname[il_count] = Lower(as_name)
is_nfrom[il_count] = Lower(as_from)
is_nwithin[il_count] = Lower(as_within)
is_ntext[il_count] = ""
is_ntag[il_count] = ""
is_ndataobject[il_count] = ""
Return il_count
end function

public function integer of_inherit (pfcscanner_n_cst_classinfo anv_ancestor);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_Inherit
//	Arguments:		anv_ancestor	The ancestor's controls, its own and those it
//										inherits
//	Returns:			1
//	Description:	Starts this class's controls with its ancestor's: the class has
//						them all, with the properties the ancestor gives them, unless
//						it overrides them (of_Override)
//////////////////////////////////////////////////////////////////////////////
long	ll_i, ll_index

If Not IsValid(anv_ancestor) Then Return 1
is_text = anv_ancestor.is_text
is_tag = anv_ancestor.is_tag
is_dataobject = anv_ancestor.is_dataobject
is_menuname = anv_ancestor.is_menuname
For ll_i = 1 To anv_ancestor.il_count
	ll_index = of_Add(anv_ancestor.is_nname[ll_i], anv_ancestor.is_nfrom[ll_i], anv_ancestor.is_nwithin[ll_i])
	is_ntext[ll_index] = anv_ancestor.is_ntext[ll_i]
	is_ntag[ll_index] = anv_ancestor.is_ntag[ll_i]
	is_ndataobject[ll_index] = anv_ancestor.is_ndataobject[ll_i]
Next
Return 1
end function

public function integer of_override (pfcscanner_n_cst_classinfo anv_class);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_Override
//	Arguments:		anv_class	The class's own source (of_Parse)
//	Returns:			1
//	Description:	Adds the class's own controls to those it inherits (of_Inherit).
//						A control inherited from an ancestor (from ancestor`name) keeps
//						its class, and takes the properties the class sets.
//////////////////////////////////////////////////////////////////////////////
long	ll_i, ll_index

is_name = anv_class.is_name
is_ancestor = anv_class.is_ancestor
If anv_class.is_text <> "" Then is_text = anv_class.is_text
If anv_class.is_tag <> "" Then is_tag = anv_class.is_tag
If anv_class.is_dataobject <> "" Then is_dataobject = anv_class.is_dataobject
If anv_class.is_menuname <> "" Then is_menuname = anv_class.is_menuname

For ll_i = 1 To anv_class.il_count
	ll_index = of_Find(anv_class.is_nname[ll_i])
	If ll_index = 0 Then
		ll_index = of_Add(anv_class.is_nname[ll_i], anv_class.is_nfrom[ll_i], anv_class.is_nwithin[ll_i])
	ElseIf Pos(anv_class.is_nfrom[ll_i], "`") = 0 Then
		// declared again from another class
		is_nfrom[ll_index] = anv_class.is_nfrom[ll_i]
		is_nwithin[ll_index] = anv_class.is_nwithin[ll_i]
	End If
	If anv_class.is_ntext[ll_i] <> "" Then is_ntext[ll_index] = anv_class.is_ntext[ll_i]
	If anv_class.is_ntag[ll_i] <> "" Then is_ntag[ll_index] = anv_class.is_ntag[ll_i]
	If anv_class.is_ndataobject[ll_i] <> "" Then is_ndataobject[ll_index] = anv_class.is_ndataobject[ll_i]
Next
Return 1
end function

protected function string of_value (string as_line);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_Value
//	Arguments:		as_line	What follows the = of a property, such as "&Open~tCtrl+O"
//	Returns:			The value: a string literal's text, with its ~ escapes read
//////////////////////////////////////////////////////////////////////////////
string	ls_char, ls_value
long		ll_i, ll_len

as_line = Trim(as_line)
If Left(as_line, 1) <> "~"" Then Return as_line

ll_len = Len(as_line)
ll_i = 2
Do While ll_i <= ll_len
	ls_char = Mid(as_line, ll_i, 1)
	If ls_char = "~"" Then Exit
	If ls_char = "~~" And ll_i < ll_len Then
		ll_i++
		ls_char = Mid(as_line, ll_i, 1)
		Choose Case Lower(ls_char)
			Case "t"
				ls_char = "~t"
			Case "r"
				ls_char = "~r"
			Case "n"
				ls_char = "~n"
		End Choose
	End If
	ls_value += ls_char
	ll_i++
Loop
Return ls_value
end function

protected function integer of_setproperty (long al_index, string as_line);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_SetProperty
//	Arguments:		al_index	The nested class the line is in, 0 for the class
//						as_line	A line of the class's or nested class's type block,
//									such as string text = "OK"
//	Returns:			1 if it set a property, 0 if it didn't
//////////////////////////////////////////////////////////////////////////////
string	ls_lower, ls_name, ls_value
long		ll_pos

ls_lower = Lower(Trim(as_line))
If Left(ls_lower, 7) <> "string " Then Return 0
ll_pos = Pos(ls_lower, "=")
If ll_pos = 0 Then Return 0
ls_name = Trim(Mid(ls_lower, 8, ll_pos - 8))
ls_value = of_Value(Mid(Trim(as_line), ll_pos + 1))

Choose Case ls_name
	Case "text"
		If al_index = 0 Then is_text = ls_value Else is_ntext[al_index] = ls_value
	Case "tag"
		If al_index = 0 Then is_tag = ls_value Else is_ntag[al_index] = ls_value
	Case "dataobject"
		If al_index = 0 Then is_dataobject = Lower(ls_value) Else is_ndataobject[al_index] = Lower(ls_value)
	Case "menuname"
		If al_index = 0 Then is_menuname = Lower(ls_value)
	Case Else
		Return 0
End Choose
Return 1
end function

on pfcscanner_n_cst_classinfo.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pfcscanner_n_cst_classinfo.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on
