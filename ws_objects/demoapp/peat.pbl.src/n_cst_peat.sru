$PBExportHeader$n_cst_peat.sru
$PBExportComments$PEAT Application Manager class
forward
global type n_cst_peat from n_cst_appmanager
end type
type refresh_token from timing within n_cst_peat
end type
end forward

global type n_cst_peat from n_cst_appmanager
event openid_response ( )
event pfc_postlogondlg ( )
refresh_token refresh_token
end type
global n_cst_peat n_cst_peat

type variables
Long il_Expiresin = 0
Long il_ClockSkew = 3
String is_password
String is_authentication

constant String STATIC_CACHE = "STATIC_CACHE"
constant String DYNAMIC_CACHE = "DYNAMIC_CACHE"
constant String DYNAMIC_CONNECTION = "DYNAMIC_CONNECTION"
constant String JWT = "JWT"
constant String OAUTH = "OAUTH"
constant String COGNITO = "COGNITO"
constant String AZURE = "AZURE"
constant String OPENID = "OPENID"

n_openid		inv_openid
end variables

forward prototypes
public function integer of_refreshprojects ()
public function integer of_oauth_authentication ()
public function integer of_jwt_authentication ()
public function integer of_start_session ()
public function integer of_cognito_authentication ()
public function integer of_azure_authentication ()
public function integer of_azure2_authentication ()
public function integer of_database_static_cache ()
public function integer of_database_dynamic_cache ()
public function integer of_database_dynamic_connection ()
public function integer of_openid2_authentication ()
public function integer of_logondlg ()
public function integer of_openid_authentication ()
end prototypes

event openid_response();of_openid2_authentication()
end event

event pfc_postlogondlg();w_f_peat		lw_frame

lw_frame = this.of_getframe()
lw_frame.event post pfc_open()

Return
end event

public function integer of_refreshprojects ();// This function will find the active sheet and refresh the projects listed there.
// This function is called whenever a change has been made to the current project,
// a new project added, or the current project deleted.

w_s_projectlist	w_active

w_active = this.of_getframe().GetActiveSheet()
IF IsValid(w_active) THEN
	Return w_s_projectlist.of_refresh()
END IF

Return 0
end function

public function integer of_oauth_authentication ();OAuthClient    loac_Client
TokenRequest   ltr_Request
TokenResponse  ltr_Response
String ls_url
String ls_TokenType, ls_AccessToken
String ls_type, ls_description, ls_uri, ls_state, ls_inifile
Integer li_Return, li_rtn

ls_inifile = gnv_app.of_GetAppIniFile()

li_rtn = -1
ls_url = ProfileString(ls_inifile,"OAUTHAuthentication","TokenURL","")

//TokenRequest
ltr_Request.tokenlocation = ls_url
ltr_Request.Method = "POST"
ltr_Request.clientid = "ro.client"
ltr_Request.clientsecret = "08692CED-944D-4DA9-BFEF-0FE503C203AC"
ltr_Request.scope = "serverapi"
ltr_Request.granttype = "password"
ltr_Request.UserName = is_UserID
ltr_Request.Password = is_Password

loac_Client = Create OAuthClient
li_Return = loac_Client.AccessToken( ltr_Request, ltr_Response )
IF li_Return = 1 AND ltr_Response.GetStatusCode () = 200 Then
	ls_TokenType = ltr_Response.gettokentype( )
	ls_AccessToken = ltr_Response.GetAccessToken()
	//Application Set Authorization Header
	iapp_object.SetHttpRequestHeader("Authorization", ls_TokenType + " " +ls_AccessToken, true)
	//Set Global Variables
	il_Expiresin = ltr_Response.getexpiresin( )
	li_rtn = 1
ELSE
	li_Return = ltr_Response.GetTokenError(ls_type, ls_description, ls_uri, ls_state)
	MessageBox( "AccessToken Falied", "Return :" + String ( li_Return ) + "~r~n" + ls_description )
END IF

If IsValid ( loac_Client ) Then DesTroy ( loac_Client )

Return li_rtn
end function

public function integer of_jwt_authentication ();//UserName & Password are passed from the login window
RestClient lrc_Client
String  ls_url, ls_PostData, ls_Response
String  ls_TokenType, ls_AccessToken
String  ls_uri, ls_inifile
Integer li_Return, li_rtn
JsonParser ljson_Parser

ls_inifile = gnv_app.of_GetAppIniFile()

li_rtn = -1
ls_url = ProfileString(ls_inifile,"JWTAuthentication","TokenURL","")

ls_PostData = '{"Username":"' + is_UserID + '", "Password":"' + is_Password + '"}'
lrc_Client = Create RestClient
lrc_Client.SetRequestHeader("Content-Type","application/json")

li_Return = lrc_Client.GetJWTToken( ls_Url, ls_PostData, ls_Response )
IF li_Return = 1 THEN
	IF Pos ( ls_Response, "access_token" ) > 0 THEN
		ljson_Parser = Create JsonParser
		ljson_Parser.LoadString(ls_Response)
		ls_TokenType = ljson_Parser.GetItemString("/token_type")
		ls_AccessToken = ljson_Parser.GetItemString("/access_token")
		//Application Set Authorization Header
		iapp_object.SetHttpRequestHeader("Authorization", ls_TokenType + " " +ls_AccessToken, true)
		//Set Global Variables
		il_Expiresin = Long (ljson_Parser.GetItemNumber("/expires_in"))
		li_rtn = 1
	ELSE
		MessageBox ( "Access Token Missing", ls_Response )
	END IF
Else
	MessageBox( "AccessToken Falied", "Return :" + String ( li_Return ) )
End If

If IsValid ( ljson_Parser ) Then DesTroy ( ljson_Parser )
If IsValid ( lrc_Client ) Then DesTroy ( lrc_Client )

Return li_rtn
end function

public function integer of_start_session ();long	ll_return

Try
	ll_return = iapp_object.BeginSession()
	If ll_return <> 0 Then
		Messagebox("Beginsession Failed:" + String(ll_return), iapp_object.GetHttpResponseStatusText())
		Return -1
	End if
Catch ( Throwable ex)
	MessageBox( "Throwable", ex.GetMessage())
	Return -1
End Try
 
//Refreshes the token for timing
If il_Expiresin > 0 And (il_Expiresin - il_ClockSkew) > 0 Then
	refresh_token.Start(il_Expiresin - il_ClockSkew)
End If

Return 1
end function

public function integer of_cognito_authentication ();RestClient lrc_Client
String  ls_url, ls_PostData, ls_Response
String  ls_TokenType, ls_AccessToken
String  ls_uri, ls_inifile
Integer li_Return, li_rtn
JsonParser ljson_Parser

ls_inifile = gnv_app.of_GetAppIniFile()

li_rtn = -1
ls_url = ProfileString(ls_inifile,"CognitoAuthentication","TokenURL","")

ls_PostData = '{"username":"' + is_UserID + '", "password":"' + is_Password + '"}';
lrc_Client = Create RestClient
lrc_Client.SetRequestHeader("Content-Type","application/json")
li_Return = lrc_Client.GetJWTToken( ls_Url, ls_PostData, ls_Response )
If li_Return = 1 and Pos ( ls_Response, "access_token" ) > 0 Then
	ljson_Parser = Create JsonParser
	ljson_Parser.LoadString(ls_Response)
	ls_TokenType = ljson_Parser.GetItemString("/token_type")
	ls_AccessToken = ljson_Parser.GetItemString("/access_token")
	//Application Set Authorization Header
	iapp_object.SetHttpRequestHeader("Authorization", ls_TokenType + " " +ls_AccessToken, true)
	//Set Global Variables
	il_Expiresin = Long (ljson_Parser.GetItemNumber("/expires_in"))
 	li_rtn = 1
ELSE
	MessageBox( "AccessToken Falied", "Return :" + String ( li_Return ) )
END IF

If IsValid ( ljson_Parser ) Then DesTroy ( ljson_Parser )
If IsValid ( lrc_Client ) Then DesTroy ( lrc_Client )

Return li_rtn
end function

public function integer of_azure_authentication ();OAuthClient    loac_Client
TokenRequest   ltr_Request
TokenResponse  ltr_Response
String  ls_url
String  ls_TokenType, ls_AccessToken
String  ls_type, ls_description, ls_uri, ls_state, ls_inifile
Integer li_Return, li_rtn

ls_inifile = gnv_app.of_GetAppIniFile()

li_rtn = -1
ls_url = ProfileString(ls_inifile,"AzureAuthentication","TokenURL","")

//TokenRequest
ltr_Request.tokenlocation = ls_url
ltr_Request.Method = "POST"
ltr_Request.clientid = "b7f701a0-45ee-4b23-b53c-53d974f3ff4d"
ltr_Request.clientsecret = 'rNH7Q' + '~~' + 'MkxHabCa78apiACNIR9ZgbYCxmHaewC'
ltr_Request.Scope = "api://b7f701a0-45ee-4b23-b53c-53d974f3ff4d/Use.App"
ltr_Request.granttype = "password"
ltr_Request.username = is_userID + "%40brucearmstrongoutlook.onmicrosoft.com"
ltr_Request.password = is_password

loac_Client = Create OAuthClient
li_Return = loac_Client.AccessToken( ltr_Request, ltr_Response )
IF li_Return = 1 and ltr_Response.GetStatusCode () = 200 Then
	ls_TokenType = ltr_Response.gettokentype( )
	ls_AccessToken = ltr_Response.GetAccessToken()
	//Application Set Authorization Header
	iapp_object.SetHttpRequestHeader("Authorization", ls_TokenType + " " + ls_AccessToken, true)
	//Set Global Variables
	il_Expiresin = ltr_Response.getexpiresin( )
	li_rtn = 1
ELSE
	li_Return = ltr_Response.GetTokenError(ls_type, ls_description, ls_uri, ls_state)
	MessageBox( "AccessToken Falied", "Return :" + String ( li_Return ) + "~r~n" + ls_description )
END IF

If IsValid ( loac_Client ) Then DesTroy ( loac_Client )

Return li_rtn
end function

public function integer of_azure2_authentication ();RestClient lrc_Client
String  ls_url, ls_PostData, ls_Response
String  ls_TokenType, ls_AccessToken
String	 ls_inifile
Integer li_Return, li_rtn
JsonParser ljson_Parser

ls_inifile = gnv_app.of_GetAppIniFile()

li_rtn = -1
ls_url = ProfileString(ls_inifile,"AzureAuthentication","TokenURL","")

ls_PostData = 'client_id=' + 'b7f701a0-45ee-4b23-b53c-53d974f3ff4d' + '&'
ls_PostData += 'client_secret=' + 'rNH7Q' + '~~' + 'MkxHabCa78apiACNIR9ZgbYCxmHaewC' + '&'  // The embedded ~ in the code requires special handling
ls_PostData += 'scope=' + 'api%3A%2F%2Fb7f701a0-45ee-4b23-b53c-53d974f3ff4d%2FUse.App' + '&'
ls_PostData += 'grant_type=password' + '&'
ls_PostData += 'username=' + is_userID + '%40brucearmstrongoutlook.onmicrosoft.com' + '&'
ls_PostData += 'password=' + is_Password 

lrc_Client = Create RestClient
lrc_Client.SetRequestHeader("Content-Type","application/x-www-form-urlencoded")

li_Return = lrc_Client.GetJWTToken( ls_Url, ls_PostData, ls_Response )
IF li_Return = 1 THEN
	IF Pos ( ls_Response, "access_token" ) > 0 THEN
		ljson_Parser = Create JsonParser
		ljson_Parser.LoadString(ls_Response)
		ls_TokenType = ljson_Parser.GetItemString("/token_type")
		ls_AccessToken = ljson_Parser.GetItemString("/access_token")
		//Application Set Authorization Header
		iapp_object.SetHttpRequestHeader("Authorization", ls_TokenType + " " +ls_AccessToken, true)
		//Set Global Variables
		il_Expiresin = Long (ljson_Parser.GetItemNumber("/expires_in"))
		li_rtn = 1
	ELSE
		MessageBox ( "Access Token Missing", ls_Response )
	END IF
Else
	MessageBox( "AccessToken Falied", "Return :" + String ( li_Return ) )
End If

If IsValid ( ljson_Parser ) Then DesTroy ( ljson_Parser )
If IsValid ( lrc_Client ) Then DesTroy ( lrc_Client )

Return li_rtn
end function

public function integer of_database_static_cache ();Return 1

end function

public function integer of_database_dynamic_cache ();
CHOOSE CASE Lower ( is_userid )
	CASE 'peat'
		SQLCA.DBParm += ",CacheGroup='Default',CacheName='peat_user'"
	CASE 'peat_pm'
		SQLCA.DBParm += ",CacheGroup='Default',CacheName='peat_pm'"
	CASE ELSE
		Return -1
END CHOOSE

Return 1

end function

public function integer of_database_dynamic_connection ();Integer	li_rc

SQLCA.DBParm += ",CacheGroup='Default',CacheName='pass_through'"
SQLCA.logid = is_userid
SQLCA.logpass = is_password
li_rc = SQLCA.of_Connect()
IF li_rc <> 0 THEN
	Return -1
END IF

Return 1

end function

public function integer of_openid2_authentication ();integer				li_rc
String	 				ls_inifile, ls_response, ls_url, ls_TokenType, ls_AccessToken, ls_redirect_url
JsonParser			ljson_Parser
n_openid_code		lnv_code

ls_inifile = gnv_app.of_GetAppIniFile()
ls_url = ProfileString(ls_inifile,"OpenIDAuthentication","TokenURL","")
ls_redirect_url = ProfileString(ls_inifile,"OpenIDAuthentication","ResponseURL","")

inv_openid.of_stop_listening( )
lnv_code = inv_openid.of_get_code()

ls_response = inv_openid.of_send_token_request(ls_url, &
																'powerbuilder', &
																lnv_code.code, &
																ls_redirect_url )
																
IF Pos ( ls_Response, "access_token" ) > 0 THEN
	ljson_Parser = Create JsonParser
	ljson_Parser.LoadString(ls_Response)
	ls_TokenType = ljson_Parser.GetItemString("/token_type")
	ls_AccessToken = ljson_Parser.GetItemString("/access_token")
	//Application Set Authorization Header
	iapp_object.SetHttpRequestHeader("Authorization", ls_TokenType + " " +ls_AccessToken, true)
	//Set Global Variables
	il_Expiresin = Long (ljson_Parser.GetItemNumber("/expires_in"))
ELSE
	MessageBox ( "Access Token Missing", ls_Response )
	Return -1
END IF

li_rc = of_start_session()
IF li_rc = -1 THEN Return -1	

li_rc = SQLCA.of_Connect()
IF li_rc <> 0 THEN
	Return -1
END IF

this.event post pfc_postlogondlg()

Return 1
end function

public function integer of_logondlg ();integer	li_rc

li_rc = super::of_logondlg( )

If li_rc = 1 THEN
	this.event post pfc_postlogondlg()
END IF

Return li_rc
end function

public function integer of_openid_authentication ();String  		ls_url, ls_response_url
String	 		ls_inifile
string  		ls_response

ls_inifile = gnv_app.of_GetAppIniFile()

ls_url = ProfileString(ls_inifile,"OpenIDAuthentication","AuthorizeURL","")
ls_response_url = ProfileString(ls_inifile,"OpenIDAuthentication","ResponseURL","")

// Send the authentication request
ls_response = inv_openid.of_send_auth_code_request ( ls_url, &
																 'powerbuilder', &
																 ls_response_url )
																 
// Listen for the response
inv_openid.of_start_listening()

Return 1
end function

on n_cst_peat.create
call super::create
this.refresh_token=create refresh_token
end on

on n_cst_peat.destroy
call super::destroy
destroy(this.refresh_token)
end on

event pfc_open;call super::pfc_open;integer	li_return

n_openid lnv_openid

If lnv_openid.of_running() Then
	lnv_openid.of_send_message(as_commandline)
	HALT CLOSE	
END IF

// Display the Splash window
this.of_Splash(1)

// Initialize the various functionality of this service
this.of_SetTrRegistration(TRUE)
this.of_SetError(TRUE)

Open(w_f_peat)



end event

event constructor;call super::constructor;
ContextInformation lcx_key
int li_major, li_minor
date ld_now

ld_now = Today ( )

/*  Get PB Version.    */
GetContextService ( "ContextInformation", lcx_key)
lcx_key.GetMajorVersion ( li_major )
lcx_key.GetMinorVersion ( li_minor )

// Set the default information needed for this application
iapp_object.DisplayName = "PEAT - Project Estimation and Actuals Tracker"
this.of_SetCopyright("Copyright (c) 2004-" + String ( Year ( ld_now ), "0000" ) + " Open Source PowerBuilder Foundation Class Libraries, All rights reserved.")
this.of_SetLogo("peat.bmp")
this.of_SetVersion("Version " + String ( li_major ) + "." + String ( li_minor ) + ".00")
this.of_SetAppIniFile("peat.ini")



end event

event pfc_logon;integer	li_rc
String		ls_inifile

ls_inifile = gnv_app.of_GetAppIniFile()

If IsPowerServerApp() Then
	
	is_authentication = ProfileString(ls_inifile,"Application","Authentication","Database")
	is_userid = as_userid
	is_password = as_password
	
	CHOOSE CASE Upper ( is_authentication )
		CASE STATIC_CACHE
			li_rc = of_database_static_cache()
			IF li_rc = -1 THEN Return -1			
			li_rc = of_start_session()
			IF li_rc = -1 THEN Return -1	
		CASE DYNAMIC_CACHE
			li_rc = of_database_dynamic_cache()
			IF li_rc = -1 THEN Return -1			
			li_rc = of_start_session()
			IF li_rc = -1 THEN Return -1	
		CASE DYNAMIC_CONNECTION
			li_rc = of_database_dynamic_connection()
			IF li_rc = -1 THEN Return -1			
			li_rc = of_start_session()
			IF li_rc = -1 THEN Return -1	
		CASE JWT
			li_rc = of_jwt_authentication()
			IF li_rc = -1 THEN Return -1	
			li_rc = of_start_session()
			IF li_rc = -1 THEN Return -1	
		CASE OAUTH
			li_rc = of_oauth_authentication()
			IF li_rc = -1 THEN Return -1	
			li_rc = of_start_session()
			IF li_rc = -1 THEN Return -1	
		CASE COGNITO
			li_rc = of_cognito_authentication()
			IF li_rc = -1 THEN Return -1	
			li_rc = of_start_session()
			IF li_rc = -1 THEN Return -1	
		CASE AZURE
			li_rc = of_azure_authentication()
			//li_rc = of_azure2_authentication()  // Uses REST client rather than OAUTH client
			IF li_rc = -1 THEN Return -1	
			li_rc = of_start_session()
			IF li_rc = -1 THEN Return -1	
		CASE ELSE
			Return -1	
	END CHOOSE

	li_rc = SQLCA.of_Connect()
	IF li_rc <> 0 THEN
		Return -1
	END IF
	
Else
	// Connect to database
	SQLCA.logid = as_userid
	SQLCA.logpass = as_password
	li_rc = SQLCA.of_Connect()
	IF li_rc <> 0 THEN 
		Return -1			
	END IF
End If

Return 1
end event

event pfc_prelogondlg;call super::pfc_prelogondlg;anv_logonattrib.ii_logonattempts = 3
end event

event pfc_systemerror;Integer	 li_rc

CHOOSE CASE error.Number
	CASE 220  to 229 //Session Error
		MessageBox ("Session Error", "Number:" + String(error.Number) + "~r~nText:" + error.Text )
	CASE 230  to 239 //License Error
		MessageBox ("License Error", "Number:" + String(error.Number) + "~r~nText:" + error.Text )
	CASE 240  to 249 //Token Error
		MessageBox ("Token Error", "Number:" + String(error.Number) + "~r~nText:" + error.Text )
		//Authentication
		CHOOSE CASE is_authentication
			CASE JWT
				li_rc = of_jwt_authentication()
			CASE OAUTH
				li_rc = of_oauth_authentication()
			CASE COGNITO
				li_rc = of_oauth_authentication()
			CASE AZURE
				li_rc = of_azure_authentication()
			CASE OPENID
				li_rc = of_openid_authentication()
			CASE ELSE
				//Do Nothing
		END CHOOSE		
	CASE ELSE
		SUPER::event pfc_systemerror()
END CHOOSE
end event

type refresh_token from timing within n_cst_peat descriptor "pb_nvo" = "true" 
end type

on refresh_token.create
call super::create
TriggerEvent( this, "constructor" )
end on

on refresh_token.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

event timer;Integer li_rc

CHOOSE CASE is_authentication
	CASE JWT
		li_rc = of_jwt_authentication()
	CASE OAUTH
		li_rc = of_oauth_authentication()
	CASE COGNITO
		li_rc = of_cognito_authentication()
	CASE AZURE
		li_rc = of_azure_authentication()
	CASE OPENID
		li_rc = of_openid_authentication()
	CASE ELSE
		//Do Nothing
END CHOOSE
end event

