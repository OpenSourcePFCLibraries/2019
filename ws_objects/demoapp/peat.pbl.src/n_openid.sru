$PBExportHeader$n_openid.sru
forward
global type n_openid from nonvisualobject
end type
end forward

global type n_openid from nonvisualobject autoinstantiate
end type

type prototypes
Function Long GetLastError () Library 'kernel32.dll'
Function ULong CreateMutex (ULong lpsa, Boolean fInitialOwner, String lpszMutexName) Library 'kernel32.dll' Alias for CreateMutexW
FUNCTION long ShellExecute ( longptr ihwnd, string lpszOp, string lpszFile, string lpszParams, string lpszDir, int wShowCmd ) LIBRARY "Shell32.dll" ALIAS FOR "ShellExecuteW"
end prototypes

type variables
integer		ii_port = 8000
LongPtr 		il_socket
LongPtr 		il_listen
string			is_message = ''
n_winsock	inv_winsock

string			is_response =	'HTTP/1.1 200 OK~r~n' + &
									'Content-Type: text/html~r~n' + &
									'Content-Length: 153~r~n' + &
									'~r~n' +&
									'<!DOCTYPE html>~n' + &
									'<html lang="en">~n' + &
									'<head>~n' + &
									'    <title>OpenID Authentication</title>~n' + &
									'</head>~n' + &
									'<body>~n' + &
									'    <p>You can close the browser now</p>~n' + &
									'</body>~n' + &
									'</html>~n' + &
									'~r~n' 

									//'Connection: close~r~n' + &
									
string			is_response_event = "openid_response"

w_openid_response	iw_openid_response

String			is_state
String			is_nonce
String			is_code_verifier
String			is_code_challenge
end variables
forward prototypes
public function boolean of_running ()
public function string of_random_string (integer a_length)
public function integer of_stop_listening ()
public function integer of_send_message (string as_message)
public function integer of_get_message (longptr lparam)
public function long of_open_browser (string as_url)
public function integer of_start_listening ()
public function n_openid_code of_get_code ()
public function string of_send_token_request (string as_url, string as_client_id, string as_code, string as_redirect_uri)
public function string of_pkce_string (string as_code_verifier)
public function string of_send_auth_code_request (string as_url, string as_client_id, string as_redirect_uri)
end prototypes

public function boolean of_running ();String ls_name

IF Handle(GetApplication()) > 0 THEN
	ls_name = GetApplication().AppName + Char(0)
	CreateMutex(0, True, ls_name)
	IF GetLastError() = 183 THEN
		Return TRUE
	END IF
END IF

Return FALSE
end function

public function string of_random_string (integer a_length);String ls_code = ''
String c_passval[70] = {'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z', &
	'A','B','C','D','E','F','G','H','I','J','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z','1','2','3','4','5','6','7','8','9','0'}

Randomize (CPU ())

DO WHILE (Len(ls_code) < a_length)
	ls_code = ls_code + c_passval[rand(65)+1]
LOOP

Return ls_code
end function

public function integer of_stop_listening ();// close the listening socket
inv_winsock.of_CloseSocket(il_socket)

//Close the window that was listening
Close ( iw_openid_response )

Return 1

end function

public function integer of_send_message (string as_message);Long ll_BytesRecvd
String ls_hostname, ls_message, ls_reply
LongPtr ll_socket

SetPointer(HourGlass!)

ls_hostname = inv_winsock.of_GetHostName()

// set the connect timeout in seconds
inv_winsock.of_SetConnTimeout(3)

// connect to the host
ll_socket = inv_winsock.of_Connect(ls_hostname, ii_port)
If ll_socket = 0 Then
	ls_message = inv_winsock.of_GetLastErrorMsg()
	MessageBox("Connect to Host Failed", &
		ls_message, StopSign!)
	Return -1
End If

// send the message
inv_winsock.of_SetUnicode(FALSE)
If Not inv_winsock.of_Send(ll_socket, as_message) Then
	ls_message = inv_winsock.of_GetLastError()
	inv_winsock.of_CloseSocket(ll_socket)
	MessageBox("Send Message Failed", &
		ls_message, StopSign!)
	Return -1
End If

// receive a reply
ll_BytesRecvd = inv_winsock.of_Recv(ll_socket, ls_reply)
If ll_BytesRecvd = 0 Then
	ls_message = inv_winsock.of_GetLastError()
	inv_winsock.of_CloseSocket(ll_socket)
	MessageBox("Receive Reply Failed", &
		ls_message, StopSign!)
	Return -1
End If

// disconnect from the host
inv_winsock.of_CloseSocket(ll_socket)

end function

public function integer of_get_message (longptr lparam);Long ll_BytesRecvd
String ls_ipaddress, ls_message
UInt lui_peerport

choose case lparam
	case inv_winsock.FD_ACCEPT
		// accept the incoming socket
		il_listen = inv_winsock.of_Accept(il_socket)
		If il_listen = 0 Then
			ls_message = inv_winsock.of_GetLastError()
			MessageBox("Accept Failed", &
					ls_message, StopSign!)
		End If
	case inv_winsock.FD_READ
		// read data from the incoming socket
		ll_BytesRecvd = inv_winsock.of_Recv(il_listen, ls_message)
		is_message += ls_message
		If ll_BytesRecvd = 0 Then
			ls_message = inv_winsock.of_GetLastError()
			MessageBox("Receive Failed", &
					ls_message, StopSign!)
		End If
		// let the sender know we got the message
		inv_winsock.of_Send(il_listen, is_response)
		// close the incoming socket
		inv_winsock.of_CloseSocket(il_listen)
		gnv_app.PostEvent ( is_response_event )
end choose

Return 1
end function

public function long of_open_browser (string as_url);long		ll_rc
string		ls_null
constant  integer	SW_SHOW = 5

ll_rc = ShellExecute(0, "open", as_url, ls_null, ls_null , SW_SHOW )

Return ll_rc
end function

public function integer of_start_listening ();String		ls_message

Open ( iw_openid_response )

// create a listening socket (event ue_listen)
inv_winsock.of_SetUnicode(FALSE)
il_socket = inv_winsock.of_Listen(ii_port, Handle(iw_openid_response), 1)
If il_socket = 0 Then
	ls_message = inv_winsock.of_GetLastError()
	MessageBox("Winsock Error in of_Listen", ls_message)
	Close ( iw_openid_response )
	Return -1
End If

Return 1
end function

public function n_openid_code of_get_code ();integer				li_start, li_end
n_openid_code		lnv_code

li_start = Pos ( is_message, 'code=' ) + 5
li_end = Pos ( is_message, '&', li_start )
lnv_code.code = Mid ( is_message, li_start, li_end - li_start ) 	

li_start = Pos ( is_message, 'state=' ) + 6
li_end = Pos ( is_message, '&', li_start )

lnv_code.state = Mid ( is_message, li_start, li_end - li_start ) 

li_start = Pos ( is_message, 'session_state=' ) + 14
li_end = Pos ( is_message, '&', li_start )

lnv_code.session_state = Mid ( is_message, li_start, li_end - li_start ) 

Return lnv_code

end function

public function string of_send_token_request (string as_url, string as_client_id, string as_code, string as_redirect_uri);HttpClient	client
RestClient	lrc_Client
String			ls_url, ls_Data, ls_Response
Integer		li_rtn

ls_Data = 'client_id=' + as_client_id + '&'
ls_Data += 'grant_type=' + 'authorization_code' + '&'
ls_Data += 'redirect_uri=' + as_redirect_uri + '&'
ls_Data += 'code=' + as_code + '&'
ls_Data += 'code_verifier=' + is_code_verifier

lrc_Client = Create RestClient
lrc_Client.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")
li_rtn = lrc_Client.GetJWTToken( as_Url, ls_Data, ls_Response )
Destroy lrc_Client

Return ls_response
end function

public function string of_pkce_string (string as_code_verifier);Blob				lblb_sha256
string				ls_pkce, ls_null
CoderObject		coder
CrypterObject	crypter

//The starting stirng must be between 43 and 128 characters
IF Len(as_code_verifier) < 43 OR Len (as_code_verifier) > 128 THEN
	Return ls_null
END IF

coder = Create CoderObject
crypter = Create CrypterObject

// SHA256 encode the random string
lblb_sha256 = crypter.sha( SHA256!, Blob ( as_code_verifier, EncodingANSI!) )
// Base64Url encode the result
ls_pkce = coder.base64urlencode(lblb_sha256)

Destroy coder
Destroy crypter

Return ls_pkce
end function

public function string of_send_auth_code_request (string as_url, string as_client_id, string as_redirect_uri);HttpClient	client
String			ls_url, ls_Data, ls_Response, ls_allheaders
Integer		li_rtn

is_nonce = of_random_string ( 10 ) 
is_state = of_random_string ( 10 ) 
is_code_verifier = of_random_string (43 )
is_code_challenge = of_pkce_string( is_code_verifier )

ls_Data = 'client_id=' + as_client_id
ls_Data += '&grant_type=' + 'authorization_code'
ls_Data += '&response_type=' + 'code'
ls_Data += '&scope=' + 'openid profile email'
ls_Data += '&state=' + is_state
ls_Data += '&nonce=' + is_nonce
ls_Data += '&redirect_uri=' + as_redirect_uri
ls_Data += '&code_challenge_method=' + 'S256'
ls_Data += '&code_challenge=' + is_code_challenge

of_open_browser( as_url + '?' + ls_data )

Return ls_response
end function

on n_openid.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_openid.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event constructor;inv_winsock = CREATE n_winsock

// Initialize Winsock
If Not inv_winsock.of_Startup() Then
	MessageBox("of_Startup Failed", &
		inv_winsock.of_GetLastError(), StopSign!)
	Return
End If
end event

event destructor;If Not inv_winsock.of_Cleanup() Then
	MessageBox("of_Cleanup Failed", &
		inv_winsock.of_GetLastError(), StopSign!)
End If

Destroy inv_winsock
end event

