$PBExportHeader$w_openid_response.srw
forward
global type w_openid_response from window
end type
end forward

global type w_openid_response from window
integer width = 4727
integer height = 1808
boolean titlebar = true
string title = "Waiting for OpenID Response"
boolean controlmenu = true
boolean minbox = true
windowtype windowtype = popup!
long backcolor = 67108864
string icon = "AppIcon!"
boolean center = true
event get_message pbm_custom01
event type integer ue_postopen ( )
end type
global w_openid_response w_openid_response

type variables
n_winsock	inv_winsock
long	il_socket
integer	ii_port = 8000
end variables

event get_message;gnv_app.inv_openid.of_get_message(lparam)
end event

on w_openid_response.create
end on

on w_openid_response.destroy
end on

event open;this.event post ue_postopen()
end event

