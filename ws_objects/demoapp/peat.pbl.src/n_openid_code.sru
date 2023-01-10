$PBExportHeader$n_openid_code.sru
forward
global type n_openid_code from nonvisualobject
end type
end forward

global type n_openid_code from nonvisualobject autoinstantiate
end type

type variables
string code
string state
string session_state
end variables

on n_openid_code.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_openid_code.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

