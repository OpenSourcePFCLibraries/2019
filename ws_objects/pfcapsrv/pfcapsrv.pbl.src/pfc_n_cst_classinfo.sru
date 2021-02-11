$PBExportHeader$pfc_n_cst_classinfo.sru
$PBExportComments$Class Information
forward
global type pfc_n_cst_classinfo from n_base
end type
end forward

global type pfc_n_cst_classinfo from n_base
end type
global pfc_n_cst_classinfo pfc_n_cst_classinfo

type variables
Protected:
classdefinition				iclassdef
n_cst_classInfo_attrib		inv_attrib
n_ds							ids_repository


end variables

forward prototypes
protected function long of_add_entry (integer ai_level, string as_label, integer ai_link, string as_classname)
protected function integer of_check_link_value (integer ai_value)
public function integer of_parse (powerobject apo_classref)
protected subroutine of_set_class_base_info ()
public function n_ds of_get_repository ()
protected subroutine of_set_class_properties ()
public subroutine of_parse_typedefinition (typedefinition atypdef_ref, ref boolean ab_issimpletype, ref boolean ab_isstructure, ref boolean ab_isenumerated, ref boolean ab_isclass, ref boolean ab_isvariablelength, ref boolean ab_issystemtype, ref string as_datatypeof, ref string as_name)
protected subroutine of_sort_repository ()
protected subroutine of_clear_repository ()
protected subroutine of_parse_variabledef (variabledefinition avardef_ref, ref string as_buffer[], boolean ab_onlyuserdefined)
public function integer of_sharedata (datawindow adw_control)
public function integer of_parse (string as_classname, boolean ab_show_properties, boolean ab_show_methods, boolean ab_show_events, boolean ab_show_controls)
protected subroutine of_set_class_methods ()
protected subroutine of_parse_scriptdef_method (scriptdefinition ascriptdef_ref, ref string as_buffer[])
public subroutine of_parse_cardinality (variablecardinalitydefinition avarcardef_ref, ref string as_cardinality)
protected subroutine of_populate_from_buffer (integer ai_level, string as_label, string as_buffer[])
protected subroutine of_set_class_events ()
protected subroutine of_set_class_controls ()
end prototypes

protected function long of_add_entry (integer ai_level, string as_label, integer ai_link, string as_classname);long ll_row

if isnull( ai_level ) or ai_level < 0 then return -1
if isnull( as_label ) or len(trim( as_label )) = 0 then return -1		

if of_check_link_value( ai_link ) = -1 then return -1

ll_row = ids_repository.insertrow(0)
if ll_row < 1 then return -1

ids_repository.object.entry_level[ll_row] = ai_level
ids_repository.object.entry_text[ll_row] = as_label
ids_repository.object.entry_link[ll_row] = ai_link
ids_repository.object.entry_classname[ll_row] = as_classname

return ll_row
end function

protected function integer of_check_link_value (integer ai_value);choose case ai_value
	case inv_attrib.cst_link_none, inv_attrib.cst_link_inheritance, inv_attrib.cst_link_usage
		return 1
	case else
		return -1
end choose

end function

public function integer of_parse (powerobject apo_classref);string ls_classname

if isnull( apo_classref ) or not isvalid( apo_classref ) then return -1

ls_classname = apo_classref.classname()

return of_parse( ls_classname, false, false, false, false )
end function

protected subroutine of_set_class_base_info ();classdefinition lcdef_ancestor

this.of_add_entry( 0, iclassdef.name , inv_attrib.cst_link_none, iclassdef.name)
this.of_add_entry( 1, 'Library: ' + iclassdef.libraryname , inv_attrib.cst_link_none, iclassdef.name)

if iclassdef.name = "powerobject" then return

lcdef_ancestor = iclassdef.ancestor

this.of_add_entry( 1, 'Inherited from: ' + lcdef_ancestor.name , inv_attrib.cst_link_inheritance, lcdef_ancestor.name)

end subroutine

public function n_ds of_get_repository ();return ids_repository
end function

protected subroutine of_set_class_properties ();boolean	lb_flag
long ll_i
long ll_limit
string	ls_shared[]
string ls_instance_private[]
string ls_instance_public[]
string ls_instance_protected[]

VariableDefinition lvardef[]

lvardef = iclassdef.variablelist
ll_limit = Upperbound( lvardef )

if iclassdef.issystemtype = true then
	lb_flag = false
else
	lb_flag = true
end if

this.of_add_entry( 1, 'Properties:', inv_attrib.cst_link_none, iclassdef.name)
if ll_limit = 0 then
	this.of_add_entry( 2, '(None)', inv_attrib.cst_link_none, "")
end if

for ll_i = 1 to ll_limit
	choose case lvardef[ll_i].kind
		case VariableShared!
			of_parse_variabledef( lvardef[ll_i] , ls_shared, lb_flag )
		case VariableInstance!
			choose case lvardef[ll_i].Readaccess
				case Private!
					of_parse_variabledef( lvardef[ll_i] , ls_instance_private, lb_flag )
				case Public!
					of_parse_variabledef( lvardef[ll_i] , ls_instance_public, lb_flag )
				case Protected!
					of_parse_variabledef( lvardef[ll_i] , ls_instance_protected, lb_flag )
			end choose
	end choose
next

this.of_populate_from_buffer( 2, "Shared:", ls_shared)
this.of_populate_from_buffer( 2, "Private:", ls_instance_private )
this.of_populate_from_buffer( 2, "Public:", ls_instance_public )
this.of_populate_from_buffer( 2, "Protected:", ls_instance_protected)

end subroutine

public subroutine of_parse_typedefinition (typedefinition atypdef_ref, ref boolean ab_issimpletype, ref boolean ab_isstructure, ref boolean ab_isenumerated, ref boolean ab_isclass, ref boolean ab_isvariablelength, ref boolean ab_issystemtype, ref string as_datatypeof, ref string as_name);ab_issimpletype = (atypdef_ref.category = SimpleType!)
ab_isstructure = atypdef_ref.IsStructure
ab_isenumerated =  ( atypdef_ref.category = EnumeratedType!)
ab_isclass = (ab_issimpletype = false and ab_issimpletype = false and ab_isenumerated = false )
ab_isvariablelength = atypdef_ref.IsvariableLength
ab_issystemtype = atypdef_ref.isSystemType
as_datatypeof = atypdef_ref.datatypeof
as_name = atypdef_ref.name

end subroutine

protected subroutine of_sort_repository ();ids_repository.sort()
ids_repository.groupcalc( )

end subroutine

protected subroutine of_clear_repository ();ids_repository.reset()

end subroutine

protected subroutine of_parse_variabledef (variabledefinition avardef_ref, ref string as_buffer[], boolean ab_onlyuserdefined);boolean 	lb_isSimpleType
boolean 	lb_IsEnumerated
boolean 	lb_Isclass
boolean 	lb_isStructure
boolean 	lb_IsVariableLength
boolean 	lb_isSystemtype
long		ll_index
long		ll_i
long		ll_limit
string		ls_datatypeof
string		ls_name
string		ls_varinfo
string		ls_tmp
string 	ls_cardinality

if ab_onlyuserdefined then
	if avardef_ref.isUserDefined = false then return
end if

ll_index = upperbound( as_buffer ) + 1

of_parse_typedefinition( avardef_ref.TypeInfo , lb_isSimpleType, lb_isStructure, lb_IsEnumerated, lb_Isclass, lb_IsVariableLength, lb_isSystemtype, ls_datatypeof, ls_name)

ls_varinfo = ls_datatypeof + " " + avardef_ref.name

if avardef_ref.isConstant then
	ls_varinfo = "constant " + ls_varinfo
end if

of_parse_cardinality( avardef_ref.cardinality , ls_cardinality )

if not isnull( ls_cardinality ) then
	ls_varinfo += ls_cardinality
end if

if not isnull( avardef_ref.InitialValue) then
	ls_tmp = trim( string( avardef_ref.InitialValue ) )
	if len( ls_tmp ) > 0 then
		ls_varinfo += " = " + ls_tmp
	end if
end if

as_buffer[ll_index] = ls_varinfo

end subroutine

public function integer of_sharedata (datawindow adw_control);return ids_repository.sharedata( adw_control )
end function

public function integer of_parse (string as_classname, boolean ab_show_properties, boolean ab_show_methods, boolean ab_show_events, boolean ab_show_controls);if isnull( as_classname ) or len(trim(as_classname)) = 0 then return -1

iclassdef = FindClassDefinition( as_classname )

this.of_clear_repository( )

this.of_set_class_base_info( )

if ab_show_properties then this.of_set_class_properties( )
if ab_show_methods then this.of_set_class_methods( )
if ab_show_events then this.of_set_class_events( )
if ab_show_controls then this.of_set_class_controls( )

this.of_sort_repository( )

return 1
end function

protected subroutine of_set_class_methods ();boolean	lb_flag
long ll_i
long ll_limit
string ls_private[]
string ls_public[]
string ls_protected[]

scriptdefinition lscriptdef[]

lscriptdef = iclassdef.scriptlist
ll_limit = Upperbound( lscriptdef )

if iclassdef.issystemtype = true then
	lb_flag = false
else
	lb_flag = true
end if

this.of_add_entry( 1, 'Methods:', inv_attrib.cst_link_none, iclassdef.name)
if ll_limit = 0 then
	this.of_add_entry( 2, '(None)', inv_attrib.cst_link_none, "")
end if

for ll_i = 1 to ll_limit
	if lscriptdef[ll_i].kind <> ScriptFunction! then continue
	choose case lscriptdef[ll_i].access
		case Private!
			of_parse_scriptdef_method( lscriptdef[ll_i] , ls_private )
		case Public!
			of_parse_scriptdef_method( lscriptdef[ll_i] , ls_public )
		case Protected!
			of_parse_scriptdef_method( lscriptdef[ll_i] , ls_protected)
	end choose
next

this.of_populate_from_buffer( 2, "Private:", ls_private )
this.of_populate_from_buffer( 2, "Public:", ls_public )
this.of_populate_from_buffer( 2, "Protected:", ls_protected )

end subroutine

protected subroutine of_parse_scriptdef_method (scriptdefinition ascriptdef_ref, ref string as_buffer[]);boolean 	lb_isSimpleType
boolean 	lb_IsEnumerated
boolean 	lb_Isclass
boolean 	lb_isStructure
boolean 	lb_IsVariableLength
boolean 	lb_isSystemtype
long		ll_index
long		ll_i
long		ll_limit
string		ls_datatypeof
string		ls_method_info
string		ls_arg
string		ls_returntype
string		ls_tmp
string		ls_cardinality

variabledefinition	lvardef[]

ll_index = upperbound( as_buffer ) + 1

ls_method_info = ascriptdef_ref.name+"( "

lvardef = ascriptdef_ref.ArgumentList
ll_limit = Upperbound( lvardef )
for ll_i = 1 to ll_limit
	of_parse_typedefinition( lvardef[ll_i].typeinfo , lb_isSimpleType, lb_isStructure, lb_IsEnumerated, lb_Isclass, lb_IsVariableLength, lb_isSystemtype, ls_datatypeof, ls_tmp)
	choose case lvardef[ll_i].callingconvention
		case ByReferenceArgument!
			ls_arg += "ref "
		case ReadonlyArgument!
			ls_arg += "readonly "
	end choose
	
	ls_arg += ls_datatypeof + ' ' + lvardef[ll_i].name
	
	of_parse_cardinality( lvardef[ll_i].cardinality , ls_cardinality )
	if not isnull( ls_cardinality ) then
		ls_arg+= ls_cardinality
	end if
	if ll_i < ll_limit then ls_arg += ", "
next

if isvalid( ascriptdef_ref.returntype  ) then
	of_parse_typedefinition( ascriptdef_ref.returntype , lb_isSimpleType, lb_isStructure, lb_IsEnumerated, lb_Isclass, lb_IsVariableLength, lb_isSystemtype, ls_datatypeof, ls_returntype)
else
	ls_returntype = '(none)'
end if

ls_method_info += ls_arg + " ) return " + ls_returntype

as_buffer[ll_index] = ls_method_info

end subroutine

public subroutine of_parse_cardinality (variablecardinalitydefinition avarcardef_ref, ref string as_cardinality);long ll_i
long ll_limit
string ls_cardinality

ArrayBounds	larrbounds[]
larrbounds = avarcardef_ref.arraydefinition
ll_limit = upperbound( larrbounds)
for ll_i = 1 to ll_limit
	ls_cardinality += " ["
	if larrbounds[ll_i].lowerbound > 0 then
		ls_cardinality += string( larrbounds[ll_i].lowerbound ) + ", "
	end if
	if larrbounds[ll_i].upperbound > 0 then
		ls_cardinality += string( larrbounds[ll_i].upperbound )
	end if
	ls_cardinality += "]"
next

as_cardinality = ls_cardinality
end subroutine

protected subroutine of_populate_from_buffer (integer ai_level, string as_label, string as_buffer[]);long ll_i
long ll_limit

ll_limit = upperbound(as_buffer)

if ll_limit > 0 then
	of_add_entry( ai_level, as_label, inv_attrib.cst_link_none , "")
end if

for ll_i = 1 to ll_limit
	of_add_entry( ai_level + 1, as_buffer[ll_i], inv_attrib.cst_link_none, "")
next

end subroutine

protected subroutine of_set_class_events ();boolean	lb_flag
long ll_i
long ll_limit
string ls_buffer[]

scriptdefinition lscriptdef[]

lscriptdef = iclassdef.scriptlist
ll_limit = Upperbound( lscriptdef )

if iclassdef.issystemtype = true then
	lb_flag = false
else
	lb_flag = true
end if

this.of_add_entry( 1, 'Events:', inv_attrib.cst_link_none, iclassdef.name)
if ll_limit = 0 then
	this.of_add_entry( 2, '(None)', inv_attrib.cst_link_none, "")
end if

for ll_i = 1 to ll_limit
	if lscriptdef[ll_i].kind <> ScriptEvent! then continue
	of_parse_scriptdef_method( lscriptdef[ll_i], ls_buffer)
next

ll_limit = upperbound( ls_buffer )
for ll_i = 1 to ll_limit
	of_add_entry( 2, ls_buffer[ll_i], inv_attrib.cst_link_none, "")
next

end subroutine

protected subroutine of_set_class_controls ();long ll_i
long 	ll_limit
long 	ll_pos
string ls_tmp
string ls_classname

classdefinition	 lclassdef[]
userobject		lu_object
windowobject	lwo_controls[]
window			lw_object
	
if iclassdef.datatypeof = 'window' then
	lw_object = CREATE USING iclassdef.name
	lwo_controls = lw_object.control
elseif iclassdef.datatypeof = 'userobject' then
	lw_object = create w_master
	lw_object.openuserobject( lu_object, iclassdef.name)
	lwo_controls = lu_object.control
else
	lclassdef = iclassdef.nestedclasslist
	ll_limit = Upperbound( lclassdef )
end if

if ll_limit = 0 then
	ll_limit = upperbound(lwo_controls)
	for ll_i = 1 to ll_limit
		lclassdef[ll_i] = lwo_controls[ll_i].classdefinition
	next
end if

this.of_add_entry( 1, 'Controls:', inv_attrib.cst_link_none, iclassdef.name)
if ll_limit = 0 then
	this.of_add_entry( 2, '(None)', inv_attrib.cst_link_none, "")
end if

for ll_i = 1 to ll_limit
	ll_pos = pos( lclassdef[ll_i].name, "`")
	if ll_pos > 0 then
		ls_classname = mid( lclassdef[ll_i].name, ll_pos + 1)
	else
		ls_classname = lclassdef[ll_i].name
	end if
	ls_tmp = lclassdef[ll_i].datatypeof + ' ' + ls_classname
	of_add_entry( 2, ls_tmp, inv_attrib.cst_link_usage, lclassdef[ll_i].name )
next

if isvalid( lu_object ) then lw_object.closeuserobject( lu_object)
if isvalid( lw_object ) then destroy lw_object

end subroutine

on pfc_n_cst_classinfo.create
call super::create
end on

on pfc_n_cst_classinfo.destroy
call super::destroy
end on

event constructor;call super::constructor;ids_repository = create n_ds
ids_repository.dataobject = 'd_classinfo_repository'
end event

event destructor;call super::destructor;if isvalid( ids_repository ) then
	ids_repository.reset()
	destroy(ids_repository)
end  if

end event

