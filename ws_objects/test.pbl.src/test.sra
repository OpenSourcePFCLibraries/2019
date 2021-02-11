$PBExportHeader$test.sra
$PBExportComments$Generated Application Object
forward
global type test from application
end type
global n_tr sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global n_err error
global n_msg message
end forward

global variables
n_cst_appman_test	gnv_app

end variables

global type test from application
string appname = "test"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 19.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 2
long richtexteditx64type = 3
long richtexteditversion = 1
string richtexteditkey = ""
string appicon = ""
string appruntimeversion = "19.2.0.2670"
end type
global test test

on test.create
appname="test"
message=create n_msg
sqlca=create n_tr
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create n_err
end on

on test.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;gnv_app = create n_cst_appman_test

gnv_app.static trigger event pfc_open(commandline)

end event

event close;gnv_app.Event Static Trigger pfc_close()

DESTROY gnv_app
end event

event idle;gnv_app.Event Static Trigger pfc_idle()

end event

event systemerror;gnv_app.static trigger event pfc_systemerror()
end event

