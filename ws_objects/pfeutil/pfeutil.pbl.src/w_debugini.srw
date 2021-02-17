$PBExportHeader$w_debugini.srw
$PBExportComments$Extension display debug INI utility window used by the debug service
forward
global type w_debugini from pfc_w_debugini
end type
end forward

global type w_debugini from pfc_w_debugini
end type
global w_debugini w_debugini

on w_debugini.create
call super::create
end on

on w_debugini.destroy
call super::destroy
end on

type st_debuginfoclass from pfc_w_debugini`st_debuginfoclass within w_debugini
end type

type dw_debugini from pfc_w_debugini`dw_debugini within w_debugini
end type

type cb_print from pfc_w_debugini`cb_print within w_debugini
end type

type cb_close from pfc_w_debugini`cb_close within w_debugini
end type

type cb_dlghelp from pfc_w_debugini`cb_dlghelp within w_debugini
end type

