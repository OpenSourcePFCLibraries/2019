$PBExportHeader$peat.sra
$PBExportComments$Project Estimating and Actuals Tracking
forward
global type peat from application
end type
global n_tr sqlca
global dynamicdescriptionarea sqlda
global dynamicstagingarea sqlsa
global n_err error
global n_msg message
end forward

global variables
//Application Attributes and Services
n_cst_peat	 gnv_app

n_tr	SQLCA2
end variables

global type peat from application
string appname = "peat"
string themepath = "C:\Program Files (x86)\Appeon\PowerBuilder 21.0\IDE\theme"
string themename = "Do Not Use Themes"
boolean nativepdfvalid = false
boolean nativepdfincludecustomfont = false
string nativepdfappname = ""
long richtextedittype = 5
long richtexteditx64type = 5
long richtexteditversion = 3
string richtexteditkey = ""
string appicon = ""
string appruntimeversion = "22.0.0.1845"
boolean manualsession = true
boolean unsupportedapierror = true
boolean bignoreservercertificate = true
uint ignoreservercertificate = 0
end type
global peat peat

on peat.create
appname="peat"
message=create n_msg
sqlca=create n_tr
sqlda=create dynamicdescriptionarea
sqlsa=create dynamicstagingarea
error=create n_err
end on

on peat.destroy
destroy(sqlca)
destroy(sqlda)
destroy(sqlsa)
destroy(error)
destroy(message)
end on

event open;
gnv_app = CREATE n_cst_peat
 
gnv_app.Event Static Trigger pfc_open(CommandParm())
end event

event close;/***
 *** Redirect the close message to the Application Manager
 ***/
gnv_app.Event Static Trigger pfc_close()

DESTROY gnv_app
end event

event idle;/***
 *** Redirect the idle message to the Application Manager
 ***/
gnv_app.Event Static Trigger pfc_idle()
end event

event systemerror;/***
 *** Redirect the systemerror message to the Application Manager
 ***/
//gnv_app.Event Static Trigger pfc_systemerror()
end event

