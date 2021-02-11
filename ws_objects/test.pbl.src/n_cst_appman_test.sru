$PBExportHeader$n_cst_appman_test.sru
forward
global type n_cst_appman_test from n_cst_appmanager
end type
end forward

global type n_cst_appman_test from n_cst_appmanager
end type
global n_cst_appman_test n_cst_appman_test

on n_cst_appman_test.create
call super::create
end on

on n_cst_appman_test.destroy
call super::destroy
end on

event pfc_open;call super::pfc_open;this.of_setdebug(true)
open(w_test_ancestor)
end event

