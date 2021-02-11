$PBExportHeader$pfc_n_cst_classinfo_attrib.sru
$PBExportComments$Class Information Attributes Helper class
forward
global type pfc_n_cst_classinfo_attrib from n_cst_baseattrib
end type
end forward

global type pfc_n_cst_classinfo_attrib from n_cst_baseattrib
end type
global pfc_n_cst_classinfo_attrib pfc_n_cst_classinfo_attrib

type variables
constant integer cst_Link_None			= 0
constant integer cst_Link_Inheritance = 1
constant integer cst_Link_Usage		= 2
constant integer cst_Link_Sript			= 3

end variables
on pfc_n_cst_classinfo_attrib.create
call super::create
end on

on pfc_n_cst_classinfo_attrib.destroy
call super::destroy
end on

