$PBExportHeader$w_debugclassinfo.srw
$PBExportComments$Extension display debugClassInfo utility window used by the debug service
forward
global type w_debugclassinfo from pfc_w_debugclassinfo
end type
end forward

global type w_debugclassinfo from pfc_w_debugclassinfo
end type
global w_debugclassinfo w_debugclassinfo

on w_debugclassinfo.create
call super::create
end on

on w_debugclassinfo.destroy
call super::destroy
end on

type dw_debugclassinfo from pfc_w_debugclassinfo`dw_debugclassinfo within w_debugclassinfo
end type

type cb_print from pfc_w_debugclassinfo`cb_print within w_debugclassinfo
end type

type cb_clear from pfc_w_debugclassinfo`cb_clear within w_debugclassinfo
end type

type cb_close from pfc_w_debugclassinfo`cb_close within w_debugclassinfo
end type

type cb_dlghelp from pfc_w_debugclassinfo`cb_dlghelp within w_debugclassinfo
end type

