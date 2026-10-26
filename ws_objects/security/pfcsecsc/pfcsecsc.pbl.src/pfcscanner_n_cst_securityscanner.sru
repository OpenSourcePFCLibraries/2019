$PBExportHeader$pfcscanner_n_cst_securityscanner.sru
$PBExportComments$PFC Security Scanner service
forward
global type pfcscanner_n_cst_securityscanner from nonvisualobject
end type
end forward

global type pfcscanner_n_cst_securityscanner from nonvisualobject
end type
global pfcscanner_n_cst_securityscanner pfcscanner_n_cst_securityscanner

type variables
pfcscanner_n_ds 				ids_info
pfcscanner_n_ds 				ids_apps
pfcscanner_n_ds 				ids_updates
pfcscanner_n_ds 				ids_scan
pfcscanner_n_cst_string 	inv_string
pfcscanner_n_cst_sourcelibrary	inv_source
boolean							ib_ownsource
string 							is_app
string 							is_keyword = 'microhelp'
string 							is_separator = ';'
boolean 							ib_initscanning = false
transaction						itr_trans

// security_scan, the controls found by the last scan of each object, is available
boolean							ib_scantable

// The controls found by the scan of the current object
long								il_found
string							is_foundcontrol[]
string							is_foundtype[]
string							is_founddesc[]

// What the scans changed in security_template (of_GetSummary)
long								il_added
long								il_changed
long								il_deleted
long								il_removed
string							is_removed[]
end variables

forward prototypes
public function integer of_scandatawindow (string as_dataobjectname, string as_library)
public function integer of_initscanprocess (transaction a_trans, string as_app, string as_lib_list[])
public function integer of_initscanprocess (transaction a_trans, string as_app, pfcscanner_n_cst_sourcelibrary anv_source)
protected function string of_getdesc (string as_text, string as_tag)
protected function string of_getmenudesc (string as_text)
protected function string of_gettag (string as_tag)
protected function integer of_scandataobject (string as_dataobject, string as_dwname, string as_object)
protected function integer of_setsyntax (string as_dataobject, datastore ads_datastore)
public function integer of_update ()
protected function integer of_addobject (string as_app, string as_winname, string as_object, string as_objecttype, string as_desc)
protected function long of_scancontrols (string as_object, pfcscanner_n_cst_classinfo anv_class, string as_within, string as_prefix, boolean ab_menu)
public function integer of_scanobject (string as_object, string as_library)
protected function boolean of_checkscantable (transaction a_trans)
protected function long of_merge (string as_object)
protected subroutine of_resetfound ()
public function integer of_getsummary (ref long al_added, ref long al_changed, ref long al_deleted, ref long al_removed, ref string as_removed[])
public function boolean of_isscantableavailable ()
public function string of_getsummarytext (string as_app, long al_scanned, long al_selected, long al_controls)
end prototypes

public function integer of_scandatawindow (string as_dataobjectname, string as_library);//////////////////////////////////////////////////////////////////////////////
//	Function: 		of_ScanDatawindow
//	Description:  	Scans the datawindow object and captures the information about each column
//						called from the scan window for an individual dw selection
//	Returns:			The number of columns found, -1 if the object can't be read,
//						-2 if the security database can't be read
//////////////////////////////////////////////////////////////////////////////
as_dataobjectname = Lower ( Trim ( as_dataobjectname ) )
of_ResetFound ( )
If of_ScanDataObject ( as_dataobjectname, as_dataobjectname, "" ) < 0 Then Return -1

Return of_Merge ( as_dataobjectname )
end function

public function integer of_initscanprocess (transaction a_trans, string as_app, string as_lib_list[]);//////////////////////////////////////////////////////////////////////////////
//	Function:  		of_InitScanProcess
//	Description:  	Initialize the database connection, application and library
//               		search path. Used when scanning applications
//						as_lib_list: folders of object source or .pbl files (see
//						pfcscanner_n_cst_sourcelibrary.of_SetLibraries)
//////////////////////////////////////////////////////////////////////////////
pfcscanner_n_cst_sourcelibrary	lnv_source

lnv_source = Create pfcscanner_n_cst_sourcelibrary
If lnv_source.of_SetLibraries ( as_lib_list ) < 0 Then
	Destroy lnv_source
	Return -1
End If

If of_InitScanProcess ( a_trans, as_app, lnv_source ) < 0 Then
	Destroy lnv_source
	Return -1
End If
ib_ownsource = True

Return 1
end function

public function integer of_initscanprocess (transaction a_trans, string as_app, pfcscanner_n_cst_sourcelibrary anv_source);//////////////////////////////////////////////////////////////////////////////
//	Function:  		of_InitScanProcess
//	Description:  	Initialize the database connection, application and the
//						libraries' objects (anv_source, which the caller keeps).
//						Used when scanning applications
//////////////////////////////////////////////////////////////////////////////
SetPointer ( HourGlass! )

If Not IsValid ( anv_source ) Then Return -1
If a_trans.dbHandle ( ) = 0 Then Return -1

ids_updates.DataObject = "d_pfcsecurity_templateupdate"
ids_apps.DataObject = "d_pfcsecurity_applookup"
ids_scan.DataObject = "d_pfcsecurity_scan"

ids_updates.SetTransObject ( a_trans )
ids_apps.SetTransObject ( a_trans )
ids_scan.SetTransObject ( a_trans )
ib_scantable = of_CheckScanTable ( a_trans )

is_app = Lower ( as_app )
If ib_ownsource And IsValid ( inv_source ) Then Destroy inv_source
inv_source = anv_source
ib_ownsource = False
If ids_apps.Retrieve ( is_app )  = 0 Then // if the application does not exist in the database, add it
	ids_apps.ImportString ( is_app + "~t" + is_app )
End If

ib_initscanning = True
itr_trans = a_trans

Return 1
end function

protected function string of_getdesc (string as_text, string as_tag);//////////////////////////////////////////////////////////////////////////////
//	Function:	of_GetDesc
//	Description:  Return additional information about an object.
//				     Look for attributes in the following order
//				     1. Text, if there is no text attribute or it is empty then look for
//				     2. Tag
//////////////////////////////////////////////////////////////////////////////
If Trim ( as_text ) <> "" Then Return as_text
If as_tag <> "" Then Return of_GetTag ( as_tag )
Return ""
end function

protected function string of_getmenudesc (string as_text);//////////////////////////////////////////////////////////////////////////////
//	Function:				of_GetMenuDesc
//	Description:  		Return a menu item's text without its accelerator (&) and
//							its shortcut (after a tab): &Open~tCtrl+O is Open.
//							&& is an ampersand.
//////////////////////////////////////////////////////////////////////////////
long ll_pos

ll_pos = Pos ( as_text, "~t" )
If ll_pos > 0 Then as_text = Left ( as_text, ll_pos - 1 )

as_text = inv_string.of_GlobalReplace ( as_text, "&&", "~~a" )
as_text = inv_string.of_GlobalReplace ( as_text, "&", "" )
as_text = inv_string.of_GlobalReplace ( as_text, "~~a", "&" )

Return Trim ( as_text )
end function

protected function string of_gettag (string as_tag);//////////////////////////////////////////////////////////////////////////////
//	Function:				of_GetTag
//	Description: 		Parses the passed string. If the string is empty it returns an empty string
//							if the string contains a keyword that matches what is in ics_keyword 
//							(default is 'microhelp', default separator is ';') then the value for the keyword is returned
//							if none of the aboove is true then the original string is returned
//////////////////////////////////////////////////////////////////////////////
string ls_value

SetPointer ( HourGlass! )

// check arguments
If as_tag = "" Then Return ""

ls_value = inv_string.of_GetKeyValue ( as_tag, is_keyword, is_separator ) 
If ls_value = "" Then ls_value = as_tag

Return ls_value
end function

protected function integer of_scandataobject (string as_dataobject, string as_dwname, string as_object);//////////////////////////////////////////////////////////////////////////////
//	Function:				of_ScanDataObject
//	Description:  		Scans the datawindow object and captures the information about each column
//////////////////////////////////////////////////////////////////////////////
string ls_dwname, ls_query, ls_token, ls_ans, ls_name
int li_colcnt=0, li_posi

SetPointer ( HourGlass! )

ls_dwname = as_object 
If Len ( as_object )  > 0 Then ls_dwname += "."

If of_SetSyntax ( as_dwname, ids_info )  < 0 Then Return -1

ls_query = ids_info.Describe ( "Datawindow.Objects" ) 
ls_query = Lower ( ls_query ) 

// strip apart the tab seperated string
Do While Len ( ls_query )  > 0  
	li_posi = Pos ( ls_query, "~t" ) 
	If li_posi = 0 Then 
		// no more tabs so take what's left of the string
		li_posi = Len ( ls_query ) 
	Else
		li_posi = li_posi - 1
	End If
	
	ls_token = Left ( ls_query, li_posi )  // grab off the token
	ls_query = Mid ( ls_query, li_posi + 2 )  // skip past the tab 
	If Len ( ls_token )  > 0 Then 
		ls_ans = ids_info.Describe ( ls_token + ".Type " ) 
		ls_ans = Lower ( ls_ans ) 
		If Pos ( ls_ans, "column" )  > 0 Then // is it a column?
			ls_name = ls_dwname + ls_token
			If Not IsNull ( ls_name )  And Len ( Trim ( ls_name ) )  > 0 Then 
				// get the descriptive info
				ls_ans =ids_info.Describe ( ls_token + ".dbName " )  + " : " + &
					ids_info.Describe ( ls_token + ".ColType" )  
					of_addobject ( is_app, as_dataobject, ls_name, "Column", ls_ans )   
				li_colcnt++
			End If
		End If
	End If
Loop

Return li_colcnt
end function

protected function integer of_setsyntax (string as_dataobject, datastore ads_datastore);//////////////////////////////////////////////////////////////////////////////
//	Function:  		of_setsyntax
//	Description:  	Create the syntax in as_dataobject and place it in ads_datastore.
//						The syntax is the DataWindow object's source, from its
//						source file or exported from its library
//////////////////////////////////////////////////////////////////////////////
string ls_syntax, ls_errors

SetPointer ( HourGlass! )

If IsNull ( as_dataobject ) Then Return -1
If Len ( trim ( as_dataobject ) ) = 0 Then Return -1
If IsNull ( ads_datastore )  Then Return -1
If Not IsValid ( ads_datastore )  Then Return -1
If Not IsValid ( inv_source ) Then Return -1

ls_syntax = inv_source.of_GetSyntax ( as_dataobject )
If Len ( ls_syntax )  = 0 Then Return -1

ads_datastore.Create ( ls_syntax, ls_errors )
If Len ( ls_errors )  > 0 Then Return -1

Return 1
end function

public function integer of_update ();//////////////////////////////////////////////////////////////////////////////
//	Function:	of_update
//	Description:  Save the changes: the template's rows, and the controls the
//					  scan found (security_scan)
//	Returns:		 1 if it succeeds, -1 if an update fails (rolled back), -2 if the
//					  commit or rollback fails
//////////////////////////////////////////////////////////////////////////////
integer 	li_rc

SetPointer ( HourGlass! )

li_rc = ids_apps.Update ( True, False )
If li_rc >= 0 Then
	li_rc = ids_updates.Update ( True, False )
End If
If li_rc >= 0 And ib_scantable Then
	li_rc = ids_scan.Update ( True, False )
End If

If li_rc < 1 Then
	RollBack Using itr_trans;
	If itr_trans.sqlcode <> 0 Then Return -2
	Return -1
Else
	Commit Using itr_trans;
	If itr_trans.SQLCode <> 0 Then Return -2
	ids_apps.ResetUpdate ( )
	ids_updates.ResetUpdate ( )
	ids_scan.ResetUpdate ( )
	Return 1
End If
end function

protected function integer of_addobject (string as_app, string as_winname, string as_object, string as_objecttype, string as_desc);//////////////////////////////////////////////////////////////////////////////
//	Function:	of_addobject
//	Description:	Record a control the scan found.  The template is updated
//					when the object's scan is done (of_Merge).
//////////////////////////////////////////////////////////////////////////////
long ll_i

// remove potential CRLF pairs
as_desc = Left ( inv_string.of_RemoveNonPrint ( as_desc ), 254 )
If IsNull ( as_desc ) Then as_desc = ""

For ll_i = 1 To il_found
	If is_foundcontrol[ll_i] = as_object Then Exit
Next
If ll_i > il_found Then
	il_found++
	ll_i = il_found
	is_foundcontrol[ll_i] = as_object
End If
is_foundtype[ll_i] = as_objecttype
is_founddesc[ll_i] = as_desc

Return 1
end function

protected function long of_scancontrols (string as_object, pfcscanner_n_cst_classinfo anv_class, string as_within, string as_prefix, boolean ab_menu);//////////////////////////////////////////////////////////////////////////////
//	Function:			of_ScanControls
//	Description:  	Recursively scan the controls of a class that are within
//						as_within ("" for those on the class itself), with the
//						names the security service gives them at run time:
//						 - controls on tab pages and user objects are named
//						   with their parents, such as tab_1.tabpage_1.cb_ok;
//						 - menu items have their own names, such as m_open.
//						A control of a user object class (u_tab_x, u_cst_x) also has
//						the controls of that class.  A DataWindow control's columns are
//						named dw_1.column.
//	Returns:			The number of controls recorded
//////////////////////////////////////////////////////////////////////////////
long		ll_i, ll_count
string	ls_name, ls_type, ls_from, ls_dataobject
pfcscanner_n_cst_classinfo	lnv_class

SetPointer ( HourGlass! )

If Not IsValid ( anv_class ) Then Return 0

For ll_i = 1 To anv_class.il_count
	If anv_class.is_nwithin[ll_i] <> as_within Then Continue

	ls_from = anv_class.is_nfrom[ll_i]
	If ab_menu Then
		ls_name = anv_class.is_nname[ll_i]
		of_AddObject ( is_app, as_object, ls_name, "menuitem", of_GetMenuDesc ( anv_class.is_ntext[ll_i] ) )
		ll_count++
		ll_count += of_ScanControls ( as_object, anv_class, anv_class.is_nname[ll_i], "", True )
		Continue
	End If

	ls_type = inv_source.of_GetSystemType ( ls_from )
	// the security service doesn't secure the MDI client
	If ls_type = "mdiclient" Then Continue
	If ls_type = "" Then ls_type = ls_from

	ls_name = as_prefix + anv_class.is_nname[ll_i]
	of_AddObject ( is_app, as_object, ls_name, ls_type, of_GetDesc ( anv_class.is_ntext[ll_i], anv_class.is_ntag[ll_i] ) )
	ll_count++

	// the controls on it, declared by this class (such as a tab's pages) ...
	ll_count += of_ScanControls ( as_object, anv_class, anv_class.is_nname[ll_i], ls_name + ".", False )

	// ... and by its own class, with what that class inherits
	ls_dataobject = anv_class.is_ndataobject[ll_i]
	If Pos ( ls_from, "`" ) = 0 Then
		lnv_class = inv_source.of_GetClass ( ls_from )
		If IsValid ( lnv_class ) Then
			ll_count += of_ScanControls ( as_object, lnv_class, "", ls_name + ".", False )
			If ls_dataobject = "" Then ls_dataobject = lnv_class.is_dataobject
		End If
	End If

	If ls_type = "datawindow" And ls_dataobject <> "" Then
		ll_count += Max ( of_ScanDataObject ( as_object, ls_dataobject, ls_name ), 0 )
	End If
Next

Return ll_count
end function

public function integer of_scanobject (string as_object, string as_library);//////////////////////////////////////////////////////////////////////////////
//	Function:			of_scanobject
//	Description:  	Capture information about the controls and other classes on the object.
//						The object is read from its source, with the controls it
//						inherits from its ancestors.  A window also has its menu's items.
//	Returns:			The number of controls found, 0 for a nonvisual object,
//						-1 if the object can't be read, -2 if the security database
//						can't be read
//////////////////////////////////////////////////////////////////////////////
string	ls_type, ls_menu
pfcscanner_n_cst_classinfo	lnv_class, lnv_menu

SetPointer ( HourGlass! )

// check arguments
If IsNull ( as_object ) Or Len ( trim ( as_object ) ) = 0 Then Return -1
If Not IsValid ( inv_source ) Then Return -1
as_object = Lower ( Trim ( as_object ) )

ls_type = inv_source.of_GetObjectType ( as_object )
If ls_type = "" Then Return -1
If ls_type = "datawindow" Then Return of_ScanDataWindow ( as_object, as_library )
If Not inv_source.of_IsVisual ( as_object ) Then Return 0

// load the object being scanned from its source
lnv_class = inv_source.of_GetClass ( as_object )
If Not IsValid ( lnv_class ) Then Return -1

// collect the controls the object has now
of_ResetFound ( )

// scan the object for controls to be secured - recursively
of_ScanControls ( as_object, lnv_class, "", "", ls_type = "menu" )

If ls_type = "window" Then
	//  the window's menu, and its items
	ls_menu = lnv_class.is_menuname
	If Len ( ls_menu ) > 0 Then
		of_AddObject ( is_app, as_object, ls_menu, "menuitem", "Top Level Menu Object" )
		lnv_menu = inv_source.of_GetClass ( ls_menu )
		If IsValid ( lnv_menu ) Then of_ScanControls ( as_object, lnv_menu, "", "", True )
	End If
ElseIf il_found = 0 Then
	// does not have any controls so record the object itself
	of_AddObject ( is_app, as_object, as_object, inv_source.of_GetSystemType ( as_object ), &
						of_GetDesc ( lnv_class.is_text, lnv_class.is_tag ) )
End If

// add them to the template
Return of_Merge ( as_object )
end function

protected function boolean of_checkscantable (transaction a_trans);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_CheckScanTable
//	Description:	Check that the security database has security_scan, the
//						controls found by the last scan of each object, and create it
//						if it doesn't.  Without it, a re-scan can't tell a control
//						deleted in Template Management from a new one.
//	Returns:			True if security_scan is available
//////////////////////////////////////////////////////////////////////////////
long		ll_count
string	ls_sql

SELECT count(*) INTO :ll_count FROM security_scan WHERE 1 = 0 USING a_trans;
If a_trans.SQLCode = 0 Then Return True
RollBack Using a_trans;

ls_sql = "create table security_scan (" + &
			"application varchar(40) not null, " + &
			"window varchar(64) not null, " + &
			"control varchar(128) not null, " + &
			"constraint pk_sec_scan primary key (application, window, control))"
EXECUTE IMMEDIATE :ls_sql USING a_trans;
If a_trans.SQLCode <> 0 Then
	RollBack Using a_trans;
	Return False
End If
Commit Using a_trans;
Return a_trans.SQLCode = 0
end function

protected function long of_merge (string as_object);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_Merge
//	Description:	Merge the controls the object's scan found (of_AddObject)
//						into the template:
//						 - a control the template has keeps its description, unless
//						   it has none, and gets its current type;
//						 - a control the template doesn't have is added, unless the
//						   last scan found it too: then it was deleted in Template
//						   Management, and stays deleted;
//						 - a control the template has but the object no longer has
//						   is reported (of_GetSummary), and kept: it may have
//						   security settings.
//						security_scan then has the controls found.
//	Returns:			The number of controls found, -2 if the security database
//						can't be read
//////////////////////////////////////////////////////////////////////////////
long		ll_f, ll_row, ll_rows, ll_scanrows, ll_new
string	ls_control, ls_desc
boolean	lb_templatefound[], lb_scanfound[]

SetPointer ( HourGlass! )

ll_rows = ids_updates.Retrieve ( is_app, as_object )
If ll_rows < 0 Then Return -2
If ll_rows > 0 Then lb_templatefound[ll_rows] = False

If ib_scantable Then
	ll_scanrows = ids_scan.Retrieve ( is_app, as_object )
	If ll_scanrows < 0 Then Return -2
	If ll_scanrows > 0 Then lb_scanfound[ll_scanrows] = False
End If

For ll_f = 1 To il_found
	ls_control = is_foundcontrol[ll_f]
	ll_row = ids_updates.Find ( "control = '" + ls_control + "'", 1, ll_rows )
	If ll_row > 0 Then
		lb_templatefound[ll_row] = True
		If ids_updates.GetItemString ( ll_row, "object_type" ) <> is_foundtype[ll_f] Then
			ids_updates.SetItem ( ll_row, "object_type", is_foundtype[ll_f] )
			il_changed++
		End If
		ls_desc = ids_updates.GetItemString ( ll_row, "description" )
		If ( IsNull ( ls_desc ) Or Trim ( ls_desc ) = "" ) And Trim ( is_founddesc[ll_f] ) <> "" Then
			ids_updates.SetItem ( ll_row, "description", is_founddesc[ll_f] )
		End If
	ElseIf ib_scantable And ids_scan.Find ( "control = '" + ls_control + "'", 1, ll_scanrows ) > 0 Then
		// deleted in Template Management after the last scan
		il_deleted++
	Else
		ll_new = ids_updates.InsertRow ( 0 )
		ids_updates.SetItem ( ll_new, "application", is_app )
		ids_updates.SetItem ( ll_new, "window", as_object )
		ids_updates.SetItem ( ll_new, "control", ls_control )
		ids_updates.SetItem ( ll_new, "object_type", is_foundtype[ll_f] )
		If Trim ( is_founddesc[ll_f] ) = "" Then
			ids_updates.SetItem ( ll_new, "description", " " )
		Else
			ids_updates.SetItem ( ll_new, "description", is_founddesc[ll_f] )
		End If
		il_added++
	End If

	If ib_scantable Then
		ll_row = ids_scan.Find ( "control = '" + ls_control + "'", 1, ll_scanrows )
		If ll_row > 0 Then
			lb_scanfound[ll_row] = True
		Else
			ll_new = ids_scan.InsertRow ( 0 )
			ids_scan.SetItem ( ll_new, "application", is_app )
			ids_scan.SetItem ( ll_new, "window", as_object )
			ids_scan.SetItem ( ll_new, "control", ls_control )
		End If
	End If
Next

// controls the object no longer has
For ll_row = 1 To ll_rows
	If Not lb_templatefound[ll_row] Then
		il_removed++
		is_removed[il_removed] = as_object + "." + ids_updates.GetItemString ( ll_row, "control" )
	End If
Next
For ll_row = ll_scanrows To 1 Step -1
	If Not lb_scanfound[ll_row] Then ids_scan.DeleteRow ( ll_row )
Next

Return il_found
end function

protected subroutine of_resetfound ();//////////////////////////////////////////////////////////////////////////////
//	Function:		of_ResetFound
//	Description:	Start the scan of an object: no controls found yet
//////////////////////////////////////////////////////////////////////////////
string	ls_empty[]

il_found = 0
is_foundcontrol = ls_empty
is_foundtype = ls_empty
is_founddesc = ls_empty
end subroutine

public function integer of_getsummary (ref long al_added, ref long al_changed, ref long al_deleted, ref long al_removed, ref string as_removed[]);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_GetSummary
//	Description:	What the scans changed in the template:
//						al_added		controls added
//						al_changed	controls whose type changed
//						al_deleted	controls deleted in Template Management after the
//										last scan, which stay deleted
//						al_removed	controls the objects no longer have, kept in the
//										template; as_removed[] has them (object.control)
//	Returns:			1
//////////////////////////////////////////////////////////////////////////////
al_added = il_added
al_changed = il_changed
al_deleted = il_deleted
al_removed = il_removed
as_removed = is_removed
Return 1
end function

public function boolean of_isscantableavailable ();//////////////////////////////////////////////////////////////////////////////
//	Function:		of_IsScanTableAvailable
//	Description:	Whether security_scan, the controls found by the last scan of
//						each object, is available.  Without it, a re-scan adds again the
//						controls deleted in Template Management.
//////////////////////////////////////////////////////////////////////////////
Return ib_scantable
end function

public function string of_getsummarytext (string as_app, long al_scanned, long al_selected, long al_controls);//////////////////////////////////////////////////////////////////////////////
//	Function:		of_GetSummaryText
//	Arguments:		as_app			The application
//						al_scanned		The objects scanned
//						al_selected		The objects selected to scan
//						al_controls		The controls the scanned objects have
//	Description:	The summary of the scans (of_GetSummary), to show or log
//////////////////////////////////////////////////////////////////////////////
long		ll_i
string	ls_summary

ls_summary = "Scanned " + String ( al_scanned ) + " of " + String ( al_selected ) + " objects of " + as_app + &
				 ": they have " + String ( al_controls ) + " controls, menu items and columns." + &
				 "~r~n~r~nAdded to the template: " + String ( il_added ) + &
				 "~r~nType changed: " + String ( il_changed )
If il_deleted > 0 Then ls_summary += "~r~nDeleted in Template Management, not added again: " + String ( il_deleted )
If il_removed > 0 Then
	ls_summary += "~r~n~r~n" + String ( il_removed ) + " controls in the template no longer exist (they are kept; delete them in Template Management):"
	For ll_i = 1 To Min ( il_removed, 15 )
		ls_summary += "~r~n   " + is_removed[ll_i]
	Next
	If il_removed > 15 Then ls_summary += "~r~n   ..."
End If
If Not ib_scantable Then
	ls_summary += "~r~n~r~nThe security database has no security_scan table, and the scanner couldn't create it, " + &
					  "so controls deleted in Template Management are added again."
End If

Return ls_summary
end function

on pfcscanner_n_cst_securityscanner.create
call super::create
TriggerEvent( this, "constructor" )
end on

on pfcscanner_n_cst_securityscanner.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;//////////////////////////////////////////////////////////////////////////////
//	Event:  			Constructor
//	Description:  	Create all needed  datastore objects
//////////////////////////////////////////////////////////////////////////////
ids_updates = create pfcscanner_n_ds

ids_scan = create pfcscanner_n_ds

ids_apps = create pfcscanner_n_ds

ids_info = create pfcscanner_n_ds
end event

event destructor;//////////////////////////////////////////////////////////////////////////////
//	Event:  			Destructor
//	Description:  	Destroy all created datastore objects
//////////////////////////////////////////////////////////////////////////////
If IsValid ( ids_updates ) Then Destroy ids_updates
If IsValid ( ids_scan ) Then Destroy ids_scan
If IsValid ( ids_info ) Then Destroy ids_info
If IsValid ( ids_apps ) Then Destroy ids_apps
If ib_ownsource And IsValid ( inv_source ) Then Destroy inv_source
end event

