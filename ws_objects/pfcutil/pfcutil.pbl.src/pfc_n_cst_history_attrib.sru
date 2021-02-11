$PBExportHeader$pfc_n_cst_history_attrib.sru
forward
global type pfc_n_cst_history_attrib from n_cst_baseattrib
end type
end forward

global type pfc_n_cst_history_attrib from n_cst_baseattrib
end type
global pfc_n_cst_history_attrib pfc_n_cst_history_attrib

type variables
constant integer cst_Next = 1
constant integer cst_Previous = -1

end variables
on pfc_n_cst_history_attrib.create
call super::create
end on

on pfc_n_cst_history_attrib.destroy
call super::destroy
end on

