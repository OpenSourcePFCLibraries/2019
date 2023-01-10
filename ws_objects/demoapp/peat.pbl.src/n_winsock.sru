$PBExportHeader$n_winsock.sru
$PBExportComments$Winsock object
forward
global type n_winsock from nonvisualobject
end type
type wsadata from structure within n_winsock
end type
type in_addr from structure within n_winsock
end type
type sockaddr_in from structure within n_winsock
end type
type sockaddr_in6 from structure within n_winsock
end type
type in6_addr from structure within n_winsock
end type
type addrinfo from structure within n_winsock
end type
type fd_set from structure within n_winsock
end type
type timeval from structure within n_winsock
end type
end forward

type wsadata from structure
	unsignedinteger		wversion
	unsignedinteger		whighversion
	character		szdescription[257]
	character		szsystemstatus[129]
	unsignedinteger		imaxsockets
	unsignedinteger		imaxudpdg
	unsignedlong		lpvendorinfo
end type

type in_addr from structure
	unsignedlong		s_addr
end type

type sockaddr_in from structure
	unsignedinteger		sin_family
	unsignedinteger		sin_port
	in_addr		sin_addr
	byte		sin_zero[8]
end type

type sockaddr_in6 from structure
	unsignedinteger		sin6_family
	unsignedinteger		sin6_port
	unsignedlong		sin6_flowinfo
	in6_addr		sin6_addr
	unsignedlong		sin6_scope_id
end type

type in6_addr from structure
	unsignedinteger		u[8]
end type

type addrinfo from structure
	long		ai_flags
	long		ai_family
	long		ai_socktype
	long		ai_protocol
	longptr		ai_addrlen
	longptr		ai_canonname
	longptr		ai_addr
	longptr		ai_next
end type

type fd_set from structure
	unsignedlong		fd_count
	longptr		fd_array[64]
end type

type timeval from structure
	long		tv_sec
	long		tv_usec
end type

global type n_winsock from nonvisualobject
end type
global n_winsock n_winsock

type prototypes
// Windows functions

Subroutine DebugMsg( &
	String lpOutputString &
	) Library "kernel32.dll" Alias For "OutputDebugStringW"

Function ulong FormatMessage( &
	ulong dwFlags, &
	ulong lpSource, &
	ulong dwMessageId, &
	ulong dwLanguageId, &
	Ref string lpBuffer, &
	ulong nSize, &
	ulong Arguments &
	) Library "kernel32.dll" Alias For "FormatMessageW"

Subroutine CopyMemory ( &
	Ref structure Destination, &
	longptr Source, &
	long Length &
	) Library  "kernel32.dll" Alias For "RtlMoveMemory"

Function ulong WNetGetUser ( &
	string lpname, &
	Ref string lpusername, &
	Ref ulong buflen &
	) Library "mpr.dll" Alias For "WNetGetUserW"

// Winsock functions

Function longptr accept ( &
	longptr s, &
	Ref sockaddr_in addr, &
	Ref long addrlen &
	) Library "ws2_32.dll"

Function longptr accept ( &
	longptr s, &
	Ref sockaddr_in6 addr, &
	Ref long addrlen &
	) Library "ws2_32.dll"

Function long bind ( &
	longptr socket, &
	sockaddr_in name, &
	long namelen &
	)  Library "ws2_32.dll"

Function long bind ( &
	longptr socket, &
	sockaddr_in6 name, &
	long namelen &
	)  Library "ws2_32.dll"

Function long bind ( &
	longptr socket, &
	longptr name, &
	long namelen &
	)  Library "ws2_32.dll"

Function long closesocket ( &
	longptr socket &
	) Library "ws2_32.dll"

Function long connect_ws ( &
	longptr socket, &
	longptr name, &
	long namelen &
	) Library "ws2_32.dll" Alias For "connect"

Subroutine freeaddrinfo ( &
	longptr ai &
	) Library "ws2_32.dll"

Function long getaddrinfo ( &
	string pNodeName, &
	string pServiceName, &
	Ref addrinfo pHints, &
	Ref longptr ppResult &
	) Library "ws2_32.dll" Alias For "getaddrinfo;Ansi"

Function long getaddrinfo ( &
	string pNodeName, &
	longptr pServiceName, &
	Ref addrinfo pHints, &
	Ref longptr ppResult &
	) Library "ws2_32.dll" Alias For "getaddrinfo;Ansi"

Function long getaddrinfo ( &
	longptr pNodeName, &
	string pServiceName, &
	Ref addrinfo pHints, &
	Ref longptr ppResult &
	) Library "ws2_32.dll" Alias For "getaddrinfo;Ansi"

Function long gethostname ( &
	Ref string name, &
	long namelen &
	) Library "ws2_32.dll" Alias For "gethostname;Ansi"

Function long getpeername ( &
	longptr socket, &
	Ref sockaddr_in name, &
	Ref ulong namelen &
	) Library "ws2_32.dll"

Function long getpeername ( &
	longptr socket, &
	Ref sockaddr_in6 name, &
	Ref ulong namelen &
	) Library "ws2_32.dll"

Function long getsockname ( &
	longptr s, &
	Ref sockaddr_in name, &
	Ref ulong namelen &
	) Library "ws2_32.dll"

Function long getsockname ( &
	longptr s, &
	Ref sockaddr_in6 name, &
	Ref ulong namelen &
	) Library "ws2_32.dll"

Function long getsockopt ( &
	longptr socket, &
	long level, &
	long optname, &
	ref long optval, &
	ref long optlen &
	) Library "ws2_32.dll"  

Function uint htons ( &
	uint hostshort &
	) Library "ws2_32.dll"  

Function string inet_ntoa ( &
	ulong sin_addr &
	) Library "ws2_32.dll"

Function long ioctlsocket ( &
	longptr socket, &
	ulong cmd, &
	ref ulong argp &
	) Library "ws2_32.dll"

Function long listen ( &
	longptr socket, &
	long backlog &
	) Library "ws2_32.dll"  

Function uint ntohs ( &
	ulong netshort &
	) Library "ws2_32.dll"

Function long recv ( &
	longptr socket, &
	Ref blob buf, &
	long len, &
	long flags &
	) Library "ws2_32.dll"  

Function long recvfrom ( &
	longptr socket, &
	Ref blob buf, &
	long len, &
	long flags, &
	Ref sockaddr_in fromaddr, &
	Ref ulong fromlen &
	)  Library "ws2_32.dll"

Function long recvfrom ( &
	longptr socket, &
	Ref blob buf, &
	long len, &
	long flags, &
	Ref sockaddr_in6 fromaddr, &
	Ref ulong fromlen &
	)  Library "ws2_32.dll"

Function long select_ws ( &
	long nfds, &
	Ref fd_set readfds, &
	Ref fd_set writefds, &
	Ref fd_set exceptfds, &
	timeval timeout &
	) Library "ws2_32.dll" Alias For "select"

Function long send ( &
	longptr socket, &
	Ref blob buf, &
	long len, &
	long flags &
	) Library "ws2_32.dll"  

Function long sendto ( &
	longptr socket, &
	blob buf, &
	long len, &
	long flags, &
	ulong toaddr, &
	ulong tolen &
	)  Library "ws2_32.dll"

Function long sendto ( &
	longptr socket, &
	blob buf, &
	long len, &
	long flags, &
	Ref sockaddr_in toaddr, &
	ulong tolen &
	)  Library "ws2_32.dll"

Function long sendto ( &
	longptr socket, &
	blob buf, &
	long len, &
	long flags, &
	Ref sockaddr_in6 toaddr, &
	ulong tolen &
	)  Library "ws2_32.dll"

Function long setsockopt ( &
	longptr socket, &
	long level, &
	long optname, &
	Ref long optval, &
	Ref long optlen &
	) Library "ws2_32.dll"

Function longptr socket ( &
	long af, &
	long ttype, &
	long protocol &
	) Library "ws2_32.dll"

Function long shutdown ( &
	longptr s, &
	long how &
	) Library "ws2_32.dll"

Function long WSAAddressToString ( &
	sockaddr_in lpsaAddress, &
	ulong dwAddressLength, &
	longptr lpProtocolInfo, &
	Ref string lpszAddressString, &
	Ref ulong lpdwAddressStringLength &
	) Library "ws2_32.dll"  Alias For "WSAAddressToStringW"

Function long WSAAddressToString ( &
	sockaddr_in6 lpsaAddress, &
	ulong dwAddressLength, &
	longptr lpProtocolInfo, &
	Ref string lpszAddressString, &
	Ref ulong lpdwAddressStringLength &
	) Library "ws2_32.dll"  Alias For "WSAAddressToStringW"

Function long WSACleanup ( &
	) Library "ws2_32.dll"

Function long WSAGetLastError ( &
	) Library "ws2_32.dll"  

Function long WSAStartup ( &
	uint wVersionRequested, &
	Ref WSADATA lpWSAData &
	) Library "ws2_32.dll" Alias For "WSAStartup;Ansi"

Function long WSAAsyncSelect ( &
	longptr socket, &
	long hWnd, &
	ulong wMsg, &
	long lEvent &
	) Library "ws2_32.dll"  

end prototypes

type variables
Private:

WSADATA istr_wsadata

Long il_ConnTimeout
Long il_RecvTimeout
Long il_SendTimeout
Long il_LastErrorNum

Protected:

Constant UInt AF_INET		= 2
Constant UInt AF_INET6		= 23
Constant Long SOCK_STREAM	= 1
Constant Long SOCK_DGRAM	= 2
Constant Long SOCK_RAW		= 3
Constant Long IPPROTO_TCP	= 6
Constant Long IPPROTO_UDP	= 17
Constant Long AI_PASSIVE	= 1
Constant Long SOL_SOCKET	= 65535
Constant Long SO_RCVTIMEO	= 4102
Constant Long SO_SNDTIMEO	= 4101
Constant Long SO_RCVBUF		= 4098
Constant Long SO_SNDBUF		= 4097
Constant Long SO_MAX_MSG_SIZE = 8195
Constant Long SD_RECEIVE	= 0
Constant Long SD_SEND		= 1
Constant Long SD_BOTH		= 2
Constant Long SOMAXCONN		= 2147483647	// 0x7fffffff
Constant Long INET_ADDRSTRLEN  = 22
Constant Long INET6_ADDRSTRLEN = 65

Boolean ib_initialized
Long il_StructSize	// size of the addrinfo structure
UInt il_Family = AF_INET

Public:

Encoding StringEncoding = EncodingUTF16LE!

Constant Integer iINFO  = 0
Constant Integer iDEBUG = 1
Constant Integer iERROR = 2

Constant Long FD_READ		= 1
Constant Long FD_WRITE		= 2
Constant Long FD_OOB			= 4
Constant Long FD_ACCEPT		= 8
Constant Long FD_CONNECT	= 10
Constant Long FD_CLOSE		= 32

Constant Long WSAETIMEDOUT = 10060
Constant Long WSAECONNREFUSED = 10061
Constant LongPtr INVALID_SOCKET = -1
Constant Long SOCKET_ERROR = -1

end variables

forward prototypes
public function boolean of_startup ()
public function boolean of_cleanup ()
public function string of_getlasterror ()
public function long of_getlasterrornum ()
public function string of_geterrortext (long al_errornum)
public subroutine of_setipversion (integer ai_version)
public subroutine of_setunicode (boolean ab_unicode)
public function long of_recvfrom (unsignedinteger aui_port, ref blob ablb_data, ref string as_ipaddress)
public function long of_recvfrom (unsignedinteger aui_port, ref string as_data, ref string as_ipaddress)
public function boolean of_getipaddress (string as_hostname, ref string as_ipaddress[])
public function string of_gethostname ()
public function boolean of_getpublicipaddress (ref string as_ipaddress)
public function long of_getmaxmsgsize ()
public function long of_getrecvtimeout ()
public function long of_getsendtimeout ()
public function string of_getlasterrormsg ()
public function long of_getrecvbufsize ()
public function long of_getsendbufsize ()
public function unsignedlong of_listen (unsignedinteger aui_port, long al_handle, integer ai_custevent)
public function string of_getuserid ()
public function boolean of_sendto (string as_hostname, unsignedinteger aui_port, blob ablb_data)
public function boolean of_sendto (string as_hostname, unsignedinteger aui_port, string as_data)
public function string of_getdescription ()
public subroutine of_setlasterror (long al_errornum)
public subroutine of_setconntimeout (long al_seconds)
public subroutine of_setrecvtimeout (long al_milliseconds)
public subroutine of_setsendtimeout (long al_milliseconds)
public function longptr of_accept (longptr al_socket)
public function boolean of_closesocket (ref longptr al_socket)
public function longptr of_connect (string as_hostname, unsignedinteger aui_port)
public function boolean of_getpeername (longptr al_socket, ref string as_ipaddress, ref unsignedinteger aui_port)
public function long of_getconntimeout ()
public function long of_getsockopt (longptr al_socket, string as_optname)
public function boolean of_ioctlsocket (longptr al_socket, string as_cmdname, ref unsignedlong aul_argp)
public function longptr of_listen (unsignedinteger aui_port)
public function long of_recv (longptr al_socket, ref blob ablob_data)
public function long of_recv (longptr al_socket, ref string as_data)
public function boolean of_send (longptr al_socket, blob ablob_data)
public function boolean of_send (longptr al_socket, string as_data)
public function boolean of_setblockingmode (longptr al_socket, boolean ab_blocking)
public function boolean of_shutdown (longptr al_socket, long al_how)
end prototypes

public function boolean of_startup ();// -----------------------------------------------------------------------------
// FUNCTION:	of_Startup
//
// PURPOSE:		This function initializes the Winsock library.
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

Environment le_env

GetEnvironment(le_env)

// set size of the addrinfow structure
il_StructSize = 32
If le_env.ProcessBitness = 64 Then
	il_StructSize = 48
End If

If Not ib_initialized Then
	PopulateError(0, "WSAStartup")
	If WSAStartup(257, istr_wsadata) = 0 Then
		ib_initialized = True
	Else
		Return False
	End If
End If

Return True

end function

public function boolean of_cleanup ();// -----------------------------------------------------------------------------
// FUNCTION:	of_Cleanup
//
// PURPOSE:		This function terminates use of the Winsock library.
//
// RETURN:     True = Success, False = Error
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

If Not ib_initialized Then
	PopulateError(0, "WSACleanup")
	If WSACleanup() = 0 Then
		ib_initialized = False
	Else
		Return False
	End If
End If

Return True

end function

public function string of_getlasterror ();// -----------------------------------------------------------------------------
// FUNCTION:	of_GetLastError
//
// PURPOSE:		This function gets the last error message.
//
// RETURN:     The error message associated with the most recent function call.
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return of_GetErrorText(il_LastErrorNum)

end function

public function long of_getlasterrornum ();// -----------------------------------------------------------------------------
// FUNCTION:	of_GetLastErrorNum
//
// PURPOSE:		This function gets the last error numer.
//
// RETURN:     The error number associated with the most recent function call.
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return il_LastErrorNum

end function

public function string of_geterrortext (long al_errornum);// -----------------------------------------------------------------------------
// FUNCTION:	of_GetErrorText
//
// PURPOSE:		This function gets the message associated with the error number.
//
// ARGUMENTS:  al_errornum	- The error number
//
// RETURN:     The associated error message
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

Constant ULong FORMAT_MESSAGE_FROM_SYSTEM = 4096
Constant ULong LANG_NEUTRAL = 0
String ls_errmsg

ls_errmsg = Space(256)
FormatMessage(FORMAT_MESSAGE_FROM_SYSTEM, 0, &
			al_errornum, LANG_NEUTRAL, ls_errmsg, Len(ls_errmsg), 0)

Return Trim(ls_errmsg)

end function

public subroutine of_setipversion (integer ai_version);// -----------------------------------------------------------------------------
// FUNCTION:	of_SetIPVersion
//
// PURPOSE:		This function sets the IP version to either 4 or 6.
//
// ARGUMENTS:  ai_version	- The IP version to use
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

If ai_version = 6 Then
	il_Family = AF_INET6
Else
	il_Family = AF_INET
End If

end subroutine

public subroutine of_setunicode (boolean ab_unicode);// -----------------------------------------------------------------------------
// FUNCTION:	of_SetUnicode
//
// PURPOSE:		This function sets whether strings are sent and received
//					in Ansi or Unicode encoding.
//
// ARGUMENTS:  ab_unicode	- True=Unicode, False=Ansi
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// 10/01/2019	RolandS		Added StringEncoding instance variable
// -----------------------------------------------------------------------------

If ab_unicode Then
	StringEncoding = EncodingUTF16LE!
Else
	StringEncoding = EncodingAnsi!
End If

end subroutine

public function long of_recvfrom (unsignedinteger aui_port, ref blob ablb_data, ref string as_ipaddress);// -----------------------------------------------------------------------------
// FUNCTION:	of_RecvFrom
//
// PURPOSE:		This function receives a blob using UDP.
//
// ARGUMENTS:  aui_port			- The Port to receive from
//					ablb_data		- Data received
//					as_ipaddress	- The IP address of the sender
//
// RETURN:     The number of bytes received
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

sockaddr_in RecvAddr4
sockaddr_in6 RecvAddr6
Blob recvbuf
Long iResult, optlen
Long bufsize, bytesrecvd
String IPAddress
ULong StructSize, AddressLen
LongPtr RecvSocket

// create the socket
PopulateError(0, "socket")
RecvSocket = socket(il_Family, SOCK_DGRAM, IPPROTO_UDP)
If RecvSocket = INVALID_SOCKET Then
	il_LastErrorNum = WSAGetLastError()
	Return SOCKET_ERROR
End If

// initialize the structure
choose case il_Family
	case AF_INET
		StructSize = 16
		RecvAddr4.sin_family = AF_INET
		RecvAddr4.sin_port = htons(aui_port)
	case AF_INET6
		StructSize = 28
		RecvAddr6.sin6_family = AF_INET6
		RecvAddr6.sin6_port = htons(aui_port)
end choose

// bind the socket
choose case il_Family
	case AF_INET
		PopulateError(0, "bind")
		iResult = bind(RecvSocket, RecvAddr4, StructSize)
	case AF_INET6
		PopulateError(0, "bind")
		iResult = bind(RecvSocket, RecvAddr6, StructSize)
end choose
If iResult = SOCKET_ERROR Then
	il_LastErrorNum = WSAGetLastError()
	closesocket(RecvSocket)
	Return SOCKET_ERROR
End If

// set the receive timeout
optlen = 4
setsockopt(RecvSocket, SOL_SOCKET, SO_RCVTIMEO, il_RecvTimeout, optlen)

// get size of the receive buffer
optlen = 4
getsockopt(RecvSocket, SOL_SOCKET, SO_MAX_MSG_SIZE, bufsize, optlen)

// allocate receive buffer
recvbuf = Blob(Space(bufsize), EncodingAnsi!)

// receive the data
choose case il_Family
	case AF_INET
		PopulateError(0, "recvfrom")
		bytesrecvd = recvfrom(RecvSocket, recvbuf, &
								bufsize, 0, RecvAddr4, StructSize)
	case AF_INET6
		PopulateError(0, "recvfrom")
		bytesrecvd = recvfrom(RecvSocket, recvbuf, &
								bufsize, 0, RecvAddr6, StructSize)
end choose
If bytesrecvd = SOCKET_ERROR Then
	il_LastErrorNum = WSAGetLastError()
	closesocket(RecvSocket)
	Return SOCKET_ERROR
End If

// determine the sender IP Address
choose case il_Family
	case AF_INET
		StructSize = 16
		AddressLen = INET_ADDRSTRLEN
		IPAddress = Space(AddressLen)
		WSAAddressToString(RecvAddr4, &
				StructSize, 0, IPAddress, AddressLen)
		as_ipaddress = Left(IPAddress, LastPos(IPAddress, ":") - 1)
	case AF_INET6
		StructSize = 28
		AddressLen = INET6_ADDRSTRLEN
		IPAddress = Space(AddressLen)
		WSAAddressToString(RecvAddr6, &
				StructSize, 0, IPAddress, AddressLen)
		as_ipaddress = Left(IPAddress, LastPos(IPAddress, ":") - 1)
		as_ipaddress = Mid(as_ipaddress, 2, Len(as_ipaddress) - 2)
end choose

// set data to by ref argument
ablb_data = BlobMid(recvbuf, 1, bytesrecvd)

// close the socket
closesocket(RecvSocket)

Return bytesrecvd

end function

public function long of_recvfrom (unsignedinteger aui_port, ref string as_data, ref string as_ipaddress);// -----------------------------------------------------------------------------
// FUNCTION:	of_RecvFrom
//
// PURPOSE:		This function receives a string using UDP.
//
// ARGUMENTS:  aui_port			- The Port to receive from
//					as_data			- Data received
//					as_ipaddress	- The IP address of the sender
//
// RETURN:     The number of bytes received
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// 10/01/2019	RolandS		Added StringEncoding instance variable
// -----------------------------------------------------------------------------

Blob lblb_data
Long bytesrecvd

// receive data as a blob
bytesrecvd = of_recvfrom(aui_port, lblb_data, as_ipaddress)

// convert data to Unicode string
If bytesrecvd > 0 Then
	as_data = String(lblb_data, StringEncoding)
End If

Return bytesrecvd

end function

public function boolean of_getipaddress (string as_hostname, ref string as_ipaddress[]);// -----------------------------------------------------------------------------
// FUNCTION:	of_GetIPAddress
//
// PURPOSE:		This function gets the IP addresses associated with the host.
//
// ARGUMENTS:  as_hostname		- The host name to query
//					as_ipaddress	- An array of IP addresses (by ref)
//
// RETURN:     True = Success, False = Error
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

sockaddr_in IPaddr4
sockaddr_in6 IPaddr6
addrinfo hints, ptr
Long iNext
String IPAddress
ULong StructSize, AddressLen
LongPtr pResult

// initialize the hints structure
hints.ai_family   = il_Family
hints.ai_socktype = SOCK_STREAM
hints.ai_protocol = IPPROTO_TCP

// convert host address to addrinfo structure
PopulateError(0, "getaddrinfo")
il_LastErrorNum = getaddrinfo(as_hostname, 0, hints, pResult)
If il_LastErrorNum > 0 Then
	Return False
End If

ptr.ai_next = pResult
do 
	CopyMemory(ptr, ptr.ai_next, il_StructSize)
	// convert IP Address to readable string
	choose case ptr.ai_family
		case AF_INET
			StructSize = 16
			CopyMemory(IPaddr4, ptr.ai_addr, StructSize)
			AddressLen = INET_ADDRSTRLEN
			IPAddress = Space(AddressLen)
			WSAAddressToString(IPaddr4, &
					StructSize, 0, IPAddress, AddressLen)
		case AF_INET6
			StructSize = 28
			CopyMemory(IPaddr6, ptr.ai_addr, StructSize)
			AddressLen = INET6_ADDRSTRLEN
			IPAddress = Space(AddressLen)
			WSAAddressToString(IPaddr6, &
					StructSize, 0, IPAddress, AddressLen)
	end choose
	iNext = UpperBound(as_ipaddress) + 1
	as_ipaddress[iNext] = IPAddress
loop while ptr.ai_next > 0

// free allocated memory
freeaddrinfo(pResult)

Return True

end function

public function string of_gethostname ();// -----------------------------------------------------------------------------
// FUNCTION:	of_GetHostName
//
// PURPOSE:		This function retrieves the standard host name
//					for the local computer.
//
// RETURN:		Host name
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_hostname
Long ll_namelen

ll_namelen = 256
ls_hostname = Space(ll_namelen)

PopulateError(0, "gethostname")
If gethostname(ls_hostname, ll_namelen) = SOCKET_ERROR Then
	il_LastErrorNum = WSAGetLastError()
	SetNull(ls_hostname)
End If

Return ls_hostname

end function

public function boolean of_getpublicipaddress (ref string as_ipaddress);// -----------------------------------------------------------------------------
// FUNCTION:	of_GetPublicIPAddress
//
// PURPOSE:		This function gets the public IP address associated
//					with the host.
//
// ARGUMENTS:  IPAddress	- IP address (by ref)
//
// RETURN:     True = Success, False = Error
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

sockaddr_in ConnAddr4
sockaddr_in6 ConnAddr6
addrinfo hints, ptr
Long iResult
String HostName, ServiceName, IPAddress
ULong StructSize, AddressLen
LongPtr pResult, ConnSocket

// hard coded to Google's DNS server
choose case il_Family
	case AF_INET
		HostName = "8.8.8.8"
	case AF_INET6
		HostName = "2001:4860:4860::8888"
end choose
ServiceName = "53"

// initialize the hints structure
hints.ai_family   = il_Family
hints.ai_socktype = SOCK_STREAM
hints.ai_protocol = IPPROTO_TCP

// convert host address to addrinfo structure
PopulateError(0, "getaddrinfo")
il_LastErrorNum = getaddrinfo(HostName, ServiceName, hints, pResult)
If il_LastErrorNum > 0 Then
	Return False
End If
CopyMemory(ptr, pResult, il_StructSize)

// create the socket
PopulateError(0, "socket")
ConnSocket = socket(ptr.ai_family, ptr.ai_socktype, ptr.ai_protocol)
If ConnSocket = INVALID_SOCKET Then
	il_LastErrorNum = WSAGetLastError()
	Return False
End If

// connect to the server
PopulateError(0, "connect_ws")
iResult = connect_ws(ConnSocket, ptr.ai_addr, ptr.ai_addrlen)
If iResult = SOCKET_ERROR Then
	il_LastErrorNum = WSAGetLastError()
	closesocket(ConnSocket)
	Return False
End If

// get local socket info
PopulateError(0, "getsockname")
choose case il_Family
	case AF_INET
		StructSize = 16
		iResult = getsockname(ConnSocket, ConnAddr4, StructSize)
	case AF_INET6
		StructSize = 28
		iResult = getsockname(ConnSocket, ConnAddr6, StructSize)
end choose
If iResult = SOCKET_ERROR Then
	il_LastErrorNum = WSAGetLastError()
	closesocket(ConnSocket)
	Return False
End If

// convert IP Address to readable string
choose case ptr.ai_family
	case AF_INET
		StructSize = 16
		AddressLen = INET_ADDRSTRLEN
		IPAddress = Space(AddressLen)
		WSAAddressToString(ConnAddr4, &
				StructSize, 0, IPAddress, AddressLen)
		as_ipaddress = Left(IPAddress, LastPos(IPAddress, ":") - 1)
	case AF_INET6
		StructSize = 28
		AddressLen = INET6_ADDRSTRLEN
		IPAddress = Space(AddressLen)
		WSAAddressToString(ConnAddr6, &
				StructSize, 0, IPAddress, AddressLen)
		as_ipaddress = Left(IPAddress, LastPos(IPAddress, ":") - 1)
		as_ipaddress = Mid(as_ipaddress, 2, Len(as_ipaddress) - 2)
end choose

// free allocated memory
freeaddrinfo(pResult)

// close the socket
closesocket(ConnSocket)

Return True

end function

public function long of_getmaxmsgsize ();// -----------------------------------------------------------------------------
// FUNCTION:	of_GetMaxMsgSize
//
// PURPOSE:		This function retrieves the maximum UDP message size.
//
// RETURN:		Message size
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long optlen, bufsize
LongPtr SizeSocket

// create the socket
PopulateError(0, "socket")
SizeSocket = socket(il_Family, SOCK_DGRAM, IPPROTO_UDP)
If SizeSocket = INVALID_SOCKET Then
	il_LastErrorNum = WSAGetLastError()
	Return SOCKET_ERROR
End If

// get size of the receive buffer
optlen = 4
getsockopt(SizeSocket, SOL_SOCKET, SO_MAX_MSG_SIZE, bufsize, optlen)

// close the socket
closesocket(SizeSocket)

Return bufsize

end function

public function long of_getrecvtimeout ();// -----------------------------------------------------------------------------
// FUNCTION:	of_GetRecvTimeout
//
// PURPOSE:		This function returns the receive timeout. 
//
// RETURN:		Timeout value
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return il_RecvTimeout

end function

public function long of_getsendtimeout ();// -----------------------------------------------------------------------------
// FUNCTION:	of_GetSendTimeout
//
// PURPOSE:		This function returns the send timeout. 
//
// RETURN:		Timeout value
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return il_SendTimeout

end function

public function string of_getlasterrormsg ();// -----------------------------------------------------------------------------
// FUNCTION:	of_GetLastErrorMsg
//
// PURPOSE:		This function gets the last error message including detailed
//					information about the function and the error number.
//
// RETURN:     Detailed error message.
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_LastError, ls_LastFunc, ls_msgtext

ls_LastError = of_GetErrorText(il_LastErrorNum)
ls_LastFunc  = Error.Text + " in " + Error.ObjectEvent
ls_msgtext   = "Winsock Error " + String(il_LastErrorNum) + &
					" calling " + ls_LastFunc + ": " + ls_LastError

Return ls_msgtext

end function

public function long of_getrecvbufsize ();// -----------------------------------------------------------------------------
// FUNCTION:	of_GetRecvBufSize
//
// PURPOSE:		This function gets the maximum Recv buffer size.
//
// RETURN:     The size fo the buffer.
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

LongPtr SizeSocket
Long optlen, bufsize

// open TCP socket
PopulateError(0, "socket")
SizeSocket = socket(il_Family, SOCK_STREAM, IPPROTO_TCP)
If SizeSocket = INVALID_SOCKET Then
	il_LastErrorNum = WSAGetLastError()
	Return SOCKET_ERROR
End If

// get size of the receive buffer
optlen = 4
getsockopt(SizeSocket, SOL_SOCKET, SO_RCVBUF, bufsize, optlen)

// close the socket
closesocket(SizeSocket)

Return bufsize

end function

public function long of_getsendbufsize ();// -----------------------------------------------------------------------------
// FUNCTION:	of_GetSendBufSize
//
// PURPOSE:		This function gets the maximum Send buffer size.
//
// RETURN:     The size fo the buffer.
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

LongPtr SizeSocket
Long optlen, bufsize

// open TCP socket
PopulateError(0, "socket")
SizeSocket = socket(il_Family, SOCK_STREAM, IPPROTO_TCP)
If SizeSocket = INVALID_SOCKET Then
	il_LastErrorNum = WSAGetLastError()
	Return SOCKET_ERROR
End If

// get size of the send buffer
optlen = 4
getsockopt(SizeSocket, SOL_SOCKET, SO_SNDBUF, bufsize, optlen)

// close the socket
closesocket(SizeSocket)

Return bufsize

end function

public function unsignedlong of_listen (unsignedinteger aui_port, long al_handle, integer ai_custevent);// -----------------------------------------------------------------------------
// SCRIPT:     of_Listen
//
// PURPOSE:    This function opens a socket and Listens. An event will be
//					triggered when a connection request is detected.
//
// ARGUMENTS:  aui_port	 - Port number
//					al_handle - Handle of object to receive messages
//					ai_event  - pbm_customxx event to receive messages
//
// RETURN:      0 = Error
//					>0 = Success ( a valid socket )
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

Constant Integer WM_USER = 1024
addrinfo hints, ptr
Long iResult, eventid
String ServiceName
LongPtr pResult, ListenSocket

// get arguments
ServiceName = String(aui_port)

// initialize the hints structure
hints.ai_family   = il_Family
hints.ai_socktype = SOCK_STREAM
hints.ai_protocol = IPPROTO_TCP
hints.ai_flags    = AI_PASSIVE

// convert host address to addrinfo structure
PopulateError(0, "getaddrinfo")
il_LastErrorNum = getaddrinfo(0, ServiceName, hints, pResult)
If il_LastErrorNum > 0 Then
	Return 0
End If
CopyMemory(ptr, pResult, il_StructSize)

// Create a socket for connecting to server
PopulateError(0, "socket")
ListenSocket = socket(il_Family, SOCK_STREAM, IPPROTO_TCP)
If ListenSocket = INVALID_SOCKET Then
	il_LastErrorNum = WSAGetLastError()
	Return 0
End If

// Setup the TCP listening socket
PopulateError(0, "bind")
iResult = bind(ListenSocket, ptr.ai_addr, ptr.ai_addrlen)
If iResult = SOCKET_ERROR Then
	il_LastErrorNum = WSAGetLastError()
	Return 0
End If

// free allocated memory
freeaddrinfo(pResult)

// request event notifications
eventid = WM_USER + (ai_custevent - 1)
PopulateError(0, "WSAASyncSelect")
If WSAASyncSelect(ListenSocket, al_handle, &
			eventid, FD_ACCEPT + FD_READ) = SOCKET_ERROR Then
	Return 0
Else
	// Put socket in Listen mode
	PopulateError(0, "listen")
	iResult = listen(ListenSocket, SOMAXCONN)
	If iResult = SOCKET_ERROR Then
		il_LastErrorNum = WSAGetLastError()
		Return 0
	End If
End If

Return ListenSocket

end function

public function string of_getuserid ();// -----------------------------------------------------------------------------
// FUNCTION:	of_GetUserid
//
// PURPOSE:		This function retrieves the userid used to establish
//					the current network connection.
//
// RETURN:		The userid or null string if error occurred.
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

String ls_userid
ULong lul_result, lul_buflen

lul_buflen = 256
ls_userid = Space(lul_buflen)

lul_result = WNetGetUser("", ls_userid, lul_buflen)
If lul_result <> 0 Then
	SetNull(ls_userid)
End If

Return ls_userid

end function

public function boolean of_sendto (string as_hostname, unsignedinteger aui_port, blob ablb_data);// -----------------------------------------------------------------------------
// FUNCTION:	of_SendTo
//
// PURPOSE:		This function sends a blob using UDP.
//
// ARGUMENTS:  as_hostname - Hostname or IP Address to send to
//					aui_port		- The Port to send to
//					ablb_data	- Data to be sent
//
// RETURN:     True = Success, False = Error
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

addrinfo hints, ptr
sockaddr_in SendAddr4
sockaddr_in6 SendAddr6
Blob sendbuf
Long iResult, optlen, nBytes, nLeft, idx
String ServiceName
ULong StructSize
LongPtr pResult, SendSocket

ServiceName = String(aui_port)
nBytes = Len(ablb_data)

// initialize the hints structure
hints.ai_family   = il_Family
hints.ai_socktype = SOCK_DGRAM
hints.ai_protocol = IPPROTO_UDP

// convert host address to addrinfo structure
PopulateError(0, "getaddrinfo")
il_LastErrorNum = getaddrinfo(as_hostname, ServiceName, hints, pResult)
If il_LastErrorNum > 0 Then
	Return False
End If
CopyMemory(ptr, pResult, il_StructSize)

// create the socket
PopulateError(0, "socket")
SendSocket = socket(il_Family, SOCK_DGRAM, IPPROTO_UDP)
If SendSocket = INVALID_SOCKET Then
	il_LastErrorNum = WSAGetLastError()
	Return False
End If

// initialize the structure
choose case il_Family
	case AF_INET
		StructSize = 16
		SendAddr4.sin_family = AF_INET
		SendAddr4.sin_port = htons(0)
	case AF_INET6
		StructSize = 28
		SendAddr6.sin6_family = AF_INET6
		SendAddr6.sin6_port = htons(0)
end choose

// bind the socket
choose case il_Family
	case AF_INET
		PopulateError(0, "bind")
		iResult = bind(SendSocket, SendAddr4, StructSize)
	case AF_INET6
		PopulateError(0, "bind")
		iResult = bind(SendSocket, SendAddr6, StructSize)
end choose
If iResult = SOCKET_ERROR Then
	il_LastErrorNum = WSAGetLastError()
	closesocket(SendSocket)
	Return False
End If

// set the send timeout
optlen = 4
setsockopt(SendSocket, SOL_SOCKET, SO_SNDTIMEO, il_SendTimeout, optlen)

idx = 1
nLeft = nBytes
do while nLeft > 0
	sendbuf = BlobMid(ablb_data, idx)
	// send the message
	PopulateError(0, "sendto")
	iResult = sendto(SendSocket, sendbuf, nLeft, 0, &
									ptr.ai_addr, StructSize)
	If iResult = SOCKET_ERROR Then
		il_LastErrorNum = WSAGetLastError()
		closesocket(SendSocket)
		Return False
	End If
	nLeft -= iResult
	idx += iResult
loop

// free allocated memory
freeaddrinfo(pResult)

// close the socket
closesocket(SendSocket)

Return True

end function

public function boolean of_sendto (string as_hostname, unsignedinteger aui_port, string as_data);// -----------------------------------------------------------------------------
// FUNCTION:	of_SendTo
//
// PURPOSE:		This function sends a string using UDP.
//
// ARGUMENTS:  as_hostname - Hostname or IP Address to send to
//					aui_port		- The Port to send to
//					as_data		- Data to be sent
//
// RETURN:     True = Success, False = Error
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// 10/01/2019	RolandS		Added StringEncoding instance variable
// -----------------------------------------------------------------------------

Blob lblb_data

lblb_data = Blob(as_data, StringEncoding)

Return of_SendTo(as_hostname, aui_port, lblb_data)

end function

public function string of_getdescription ();// -----------------------------------------------------------------------------
// SCRIPT:     of_GetDescription
//
// PURPOSE:    This function returns the winsock description.
//
// RETURN:     String containing a description of the
//					winsock library.
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 11/10/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return String(istr_wsadata.szDescription)

end function

public subroutine of_setlasterror (long al_errornum);// -----------------------------------------------------------------------------
// FUNCTION:	of_SetLastError
//
// PURPOSE:		This function sets the last error number.
//
// ARGUMENTS:  al_errornum	- The error number to set
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

il_LastErrorNum = al_errornum

end subroutine

public subroutine of_setconntimeout (long al_seconds);// -----------------------------------------------------------------------------
// FUNCTION:	of_SetConnTimeout
//
// PURPOSE:		This function sets the connection timeout period.
//
// ARGUMENTS:  al_seconds	- The timeout period in seconds
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 09/10/2021	RolandS		Initial coding
// -----------------------------------------------------------------------------

il_ConnTimeout = al_seconds

end subroutine

public subroutine of_setrecvtimeout (long al_milliseconds);// -----------------------------------------------------------------------------
// FUNCTION:	of_SetRecvTimeout
//
// PURPOSE:		This function sets the receive timeout period.
//
// ARGUMENTS:  al_milliseconds	- The timeout period in milliseconds
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

il_RecvTimeout = al_milliseconds

end subroutine

public subroutine of_setsendtimeout (long al_milliseconds);// -----------------------------------------------------------------------------
// FUNCTION:	of_SetSendTimeout
//
// PURPOSE:		This function sets the send timeout period.
//
// ARGUMENTS:  al_milliseconds	- The timeout period in milliseconds
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

il_SendTimeout = al_milliseconds

end subroutine

public function longptr of_accept (longptr al_socket);// -----------------------------------------------------------------------------
// SCRIPT:     of_Accept
//
// PURPOSE:    This function permits an incoming connection	attempt on a socket.
//
// ARGUMENTS:  al_socket	- Open socket that is in a listening state.
//
// RETURN:      0 = Error
//					>0 = Success ( a valid connected socket )
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

sockaddr_in AcceptAddr4
sockaddr_in6 AcceptAddr6
Long StructSize
LongPtr AcceptSocket

// accept the socket
choose case il_Family
	case AF_INET
		StructSize = 16
		PopulateError(0, "accept")
		AcceptSocket = accept(al_socket, AcceptAddr4, StructSize)
	case AF_INET6
		StructSize = 28
		PopulateError(0, "accept")
		AcceptSocket = accept(al_socket, AcceptAddr6, StructSize)
end choose

If AcceptSocket = INVALID_SOCKET Then
	il_LastErrorNum = WSAGetLastError()
	Return 0
End If

Return AcceptSocket

end function

public function boolean of_closesocket (ref longptr al_socket);// -----------------------------------------------------------------------------
// SCRIPT:     of_CloseSocket
//
// PURPOSE:    This function closes an existing socket.
//
// ARGUMENTS:  al_socket - Open socket
//
// RETURN:     True = Success, False = Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

If al_socket <> 0 Then
	PopulateError(0, "closesocket")
	If closesocket(al_socket) = 0 Then
		al_socket = 0
	Else
		Return False
	End If
End If

Return True

end function

public function longptr of_connect (string as_hostname, unsignedinteger aui_port);// -----------------------------------------------------------------------------
// SCRIPT:     of_Connect
//
// PURPOSE:    This function establishes a connection to a specified server.
//
// ARGUMENTS:  as_hostname - Hostname or IP Address of the server.
//					aui_port		- Port that the server is listening on.
//
// RETURN:      0 = Error
//					>0 = Success ( a valid socket )
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// 09/09/2021	RolandS		Added timeout argument
// -----------------------------------------------------------------------------

ADDRINFO Hints, ptr
TIMEVAL lstr_timeval
FD_SET lstr_read, lstr_write, lstr_except
Long iResult
String ServiceName
LongPtr pResult, ConnSocket

ServiceName = String(aui_port)

// initialize the Hints structure
Hints.ai_family   = il_Family
Hints.ai_socktype = SOCK_STREAM
Hints.ai_protocol = IPPROTO_TCP

// convert host address to addrinfo structure
PopulateError(0, "getaddrinfo")
il_LastErrorNum = getaddrinfo(as_hostname, ServiceName, Hints, pResult)
If il_LastErrorNum > 0 Then
	Return 0
End If

// attempt to connect to an address until one succeeds
ptr.ai_next = pResult
do
	CopyMemory(ptr, ptr.ai_next, il_StructSize)

	// create a socket for connecting to server
	PopulateError(0, "socket")
	ConnSocket = socket(ptr.ai_family, ptr.ai_socktype, ptr.ai_protocol)
	If ConnSocket = INVALID_SOCKET Then
		il_LastErrorNum = WSAGetLastError()
		Return 0
	End If

	If il_ConnTimeout = 0 Then
		// connect on the socket
		PopulateError(0, "connect_ws")
		iResult = connect_ws(ConnSocket, ptr.ai_addr, ptr.ai_addrlen)
		If iResult = SOCKET_ERROR Then
			il_LastErrorNum = WSAGetLastError()
			// close the socket
			closesocket(ConnSocket)
			ConnSocket = 0
			// try the next one
			Continue
		End If
	Else
		// make the socket non blocking
		of_SetBlockingMode(ConnSocket, False)

		// attempt to connect on the socket
		PopulateError(0, "connect_ws")
		iResult = connect_ws(ConnSocket, ptr.ai_addr, ptr.ai_addrlen)
		If iResult = SOCKET_ERROR Then
			// initialize the structures
			lstr_timeval.tv_sec = il_ConnTimeout
			lstr_write.fd_count = 1
			lstr_write.fd_array[1] = ConnSocket

			// wait for the timeout
			PopulateError(0, "select_ws")
			iResult = select_ws(0, lstr_read, lstr_write, lstr_except, lstr_timeval)
			choose case iResult
				case 0
					// the timeout expired
					il_LastErrorNum = WSAETIMEDOUT

					// close the socket
					closesocket(ConnSocket)
					ConnSocket = 0

					// break out of the loop
					Exit
				case SOCKET_ERROR
					// some error occurred
					il_LastErrorNum = WSAGetLastError()

					// close the socket
					closesocket(ConnSocket)
					ConnSocket = 0

					// try the next one
					Continue
				case else
					// the connection was made so make the socket blocking
					of_SetBlockingMode(ConnSocket, True)
			end choose
		End If
	End If

	// break out of the loop
	Exit
loop while ptr.ai_next > 0

// free allocated memory
freeaddrinfo(pResult)

Return ConnSocket

end function

public function boolean of_getpeername (longptr al_socket, ref string as_ipaddress, ref unsignedinteger aui_port);// -----------------------------------------------------------------------------
// SCRIPT:     of_GetPeerName
//
// PURPOSE:    This function gets the IP Address & Port of the peer on the
//					other end of the socket.
//
// ARGUMENTS:  al_socket		- Open socket
//					as_ipaddress	- Peer IP Address ( by ref )
//					ai_port			- Peer Port ( by ref )
//
// RETURN:     True = Success, False = Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

sockaddr_in PeerAddr4
sockaddr_in6 PeerAddr6
Long iResult
ULong StructSize, AddressLen

try 
	choose case il_Family
		case AF_INET
			StructSize = 16
			PopulateError(0, "getpeername")
			iResult = getpeername(al_socket, PeerAddr4, StructSize)
			If iResult = 0 Then
				// convert IP Address to string
				AddressLen = INET_ADDRSTRLEN
				as_ipaddress = Space(AddressLen)
				WSAAddressToString(PeerAddr4, &
						StructSize, 0, as_ipaddress, AddressLen)
				aui_port = Long(Mid(as_ipaddress, LastPos(as_ipaddress, ":") + 1))
				as_ipaddress = Left(as_ipaddress, LastPos(as_ipaddress, ":") - 1)
			End If
		case AF_INET6
			StructSize = 28
			PopulateError(0, "getpeername")
			iResult = getpeername(al_socket, PeerAddr6, StructSize)
			If iResult = 0 Then
				// convert IP Address to string
				AddressLen = INET6_ADDRSTRLEN
				as_ipaddress = Space(AddressLen)
				WSAAddressToString(PeerAddr6, &
						StructSize, 0, as_ipaddress, AddressLen)
				aui_port = Long(Mid(as_ipaddress, LastPos(as_ipaddress, ":") + 1))
				as_ipaddress = Left(as_ipaddress, LastPos(as_ipaddress, ":") - 1)
				as_ipaddress = Mid(as_ipaddress, 2, Len(as_ipaddress) - 2)
			End If
	end choose
	
	If iResult = SOCKET_ERROR Then
		il_LastErrorNum = WSAGetLastError()
		SetNull(as_ipaddress)
		Return False
	End If
catch ( RunTimeError rte )
	SetNull(as_ipaddress)
	Return False
end try

Return True

end function

public function long of_getconntimeout ();// -----------------------------------------------------------------------------
// FUNCTION:	of_GetConnTimeout
//
// PURPOSE:		This function returns the connection timeout. 
//
// RETURN:		Timeout value
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 09/11/2021	RolandS		Initial coding
// -----------------------------------------------------------------------------

Return il_ConnTimeout

end function

public function long of_getsockopt (longptr al_socket, string as_optname);// -----------------------------------------------------------------------------
// SCRIPT:     of_GetSockOpt
//
// PURPOSE:    This function returns options that use long datatype.
//
// ARGUMENTS:  al_socket	- Open socket
//					as_optname	- Option name
//
// RETURN:		Option value
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long ll_optname, ll_optvalue, ll_buflen

ll_buflen = 4

PopulateError(0, "as_optname")
choose case Upper(as_optname)
	case "SO_ERROR"
		ll_optname = 4103
	case "SO_RCVBUF"
		ll_optname = 4098
	case "SO_SNDBUF"
		ll_optname = 4097
	case "SO_TYPE"
		ll_optname = 4104
	case else
		Return SOCKET_ERROR
end choose

// get option value
PopulateError(0, "getsockopt")
If getsockopt(al_socket, SOL_SOCKET, &
				ll_optname, ll_optvalue, ll_buflen) = 0 Then
	Return ll_optvalue
Else
	il_LastErrorNum = WSAGetLastError()
	Return SOCKET_ERROR
End If

end function

public function boolean of_ioctlsocket (longptr al_socket, string as_cmdname, ref unsignedlong aul_argp);// -----------------------------------------------------------------------------
// SCRIPT:     of_IoctlSocket
//
// PURPOSE:    This function controls the I/O mode of a socket.
//
// ARGUMENTS:  al_socket	- Open socket
//					as_cmdname	- Which command to execute
//					aul_argp		- Input/Output parm
//
//					For FIONBIO:
//							aul_argp  = 0 - Set Blocking mode
//							aul_argp <> 0 - Set Nonblocking mode
//
//					For FIONREAD:
//							aul_argp - returns the amount of data avail to recv
//
// RETURN:     True = Success, False = Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

// #define FIONREAD _IOR('f', 127, u_long) /* get # bytes to read */
// #define FIONBIO  _IOW('f', 126, u_long) /* set/clear non-blocking i/o */
// #define FIOASYNC _IOW('f', 125, u_long) /* set/clear async i/o */

Constant ulong FIONBIO    = 2147772030   // &H8004667E
Constant ulong FIONREAD   = 1074030207   // &H4004667F
Constant ulong SIOCATMARK = 1074033415   // &H40047307

Long ll_result
ULong lul_cmd

PopulateError(0, "as_cmdname")
choose case Upper(as_cmdname)
	case "FIONBIO"
		lul_cmd = FIONBIO
	case "FIONREAD"
		lul_cmd = FIONREAD
	case "SIOCATMARK"
		lul_cmd = SIOCATMARK
	case else
		Return False
end choose

PopulateError(0, "ioctlsocket")
ll_result = ioctlsocket(al_socket, lul_cmd, aul_argp)
If ll_result = SOCKET_ERROR Then
	il_LastErrorNum = WSAGetLastError()
	Return False
End If

Return True

end function

public function longptr of_listen (unsignedinteger aui_port);// -----------------------------------------------------------------------------
// SCRIPT:     of_Listen
//
// PURPOSE:    This function opens a socket and Listens.
//
// ARGUMENTS:  aui_port	 - Port number
//
// RETURN:      0 = Error
//					>0 = Success ( a valid socket )
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

addrinfo hints, ptr
Long iResult
String ServiceName
LongPtr pResult, ListenSocket

// get arguments
ServiceName = String(aui_port)

// initialize the hints structure
hints.ai_family   = il_Family
hints.ai_socktype = SOCK_STREAM
hints.ai_protocol = IPPROTO_TCP
hints.ai_flags    = AI_PASSIVE

// convert host address to addrinfo structure
PopulateError(0, "getaddrinfo")
il_LastErrorNum = getaddrinfo(0, ServiceName, hints, pResult)
If il_LastErrorNum > 0 Then
	Return 0
End If
CopyMemory(ptr, pResult, il_StructSize)

// Create a socket for connecting to server
PopulateError(0, "socket")
ListenSocket = socket(il_Family, SOCK_STREAM, IPPROTO_TCP)
If ListenSocket = INVALID_SOCKET Then
	il_LastErrorNum = WSAGetLastError()
	Return 0
End If

// Setup the TCP listening socket
PopulateError(0, "bind")
iResult = bind(ListenSocket, ptr.ai_addr, ptr.ai_addrlen)
If iResult = SOCKET_ERROR Then
	il_LastErrorNum = WSAGetLastError()
	Return 0
End If

// free allocated memory
freeaddrinfo(pResult)

// Put socket in Listen mode
iResult = listen(ListenSocket, SOMAXCONN)
If iResult = SOCKET_ERROR Then
	il_LastErrorNum = WSAGetLastError()
	Return 0
End If

Return ListenSocket

end function

public function long of_recv (longptr al_socket, ref blob ablob_data);// -----------------------------------------------------------------------------
// SCRIPT:     of_Recv
//
// PURPOSE:    This function receives data from a connected socket.
//
// ARGUMENTS:  al_socket	- Open socket
//					ablob_data	- By ref blob
//
// RETURN:     Number of bytes received
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

Blob recvbuf
Long optlen, bufsize, bytesrecvd

// set the receive timeout
optlen = 4
PopulateError(0, "setsockopt")
setsockopt(al_socket, SOL_SOCKET, &
					SO_RCVTIMEO, il_RecvTimeout, optlen)

// get size of the receive buffer
optlen = 4
PopulateError(0, "getsockopt")
getsockopt(al_socket, SOL_SOCKET, SO_RCVBUF, bufsize, optlen)

// allocate receive buffer
recvbuf = Blob(Space(bufsize), EncodingAnsi!)

// receive data
PopulateError(0, "recv")
bytesrecvd = recv(al_socket, recvbuf, bufsize, 0)
If bytesrecvd = SOCKET_ERROR Then
	il_LastErrorNum = WSAGetLastError()
	Return SOCKET_ERROR
End If

// set the by-ref argument
ablob_data = BlobMid(recvbuf, 1, bytesrecvd)

Return bytesrecvd

end function

public function long of_recv (longptr al_socket, ref string as_data);// -----------------------------------------------------------------------------
// SCRIPT:     of_Recv
//
// PURPOSE:    This function receives data from a connected socket.
//
// ARGUMENTS:  al_socket	- Open socket
//					as_data		- By ref string
//
// RETURN:     Number of bytes received
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// 10/01/2019	RolandS		Added StringEncoding instance variable
// -----------------------------------------------------------------------------

Blob lblob_data
Long iResult

iResult = of_Recv(al_socket, lblob_data)
If iResult = SOCKET_ERROR Then
	il_LastErrorNum = WSAGetLastError()
	SetNull(as_data)
Else
	as_data = String(lblob_data, StringEncoding)
End If

Return iResult

end function

public function boolean of_send (longptr al_socket, blob ablob_data);// -----------------------------------------------------------------------------
// SCRIPT:     of_Send
//
// PURPOSE:    This function sends data on a connected socket.
//
// ARGUMENTS:  al_socket	- Open socket
//					ablob_data	- Data to send
//
// RETURN:     True = Success, False = Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

Blob sendbuf
Long iResult, optlen
Long nBytes, nLeft, idx

nBytes = Len(ablob_data)

// set the send timeout
optlen = 4
setsockopt(al_socket, SOL_SOCKET, SO_SNDTIMEO, il_SendTimeout, optlen)

nLeft = nBytes
do while nLeft > 0
	// send the message
	sendbuf = BlobMid(ablob_data, idx + 1, nLeft)
	iResult = send(al_socket, sendbuf, nLeft, 0)
	If iResult = SOCKET_ERROR Then
		il_LastErrorNum = WSAGetLastError()
		Return False
	End If
	nLeft -= iResult;
	idx += iResult;
loop

Return True

end function

public function boolean of_send (longptr al_socket, string as_data);// -----------------------------------------------------------------------------
// SCRIPT:     of_Send
//
// PURPOSE:    This function sends data on a connected socket.
//
// ARGUMENTS:  al_socket	- Open socket
//					as_data		- Data to send
//
// RETURN:     True = Success, False = Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// 10/01/2019	RolandS		Added StringEncoding instance variable
// -----------------------------------------------------------------------------

Blob lblb_data

lblb_data = Blob(as_data, StringEncoding)

Return of_Send(al_socket, lblb_data)

end function

public function boolean of_setblockingmode (longptr al_socket, boolean ab_blocking);// -----------------------------------------------------------------------------
// SCRIPT:     of_SetBlockingMode
//
// PURPOSE:    This function changes the blocking mode of a socket.
//
// ARGUMENTS:  al_socket	- Open socket
//					ab_blocking	- True=Blocking, False=NonBlocking
//
// RETURN:     True = Success, False = Error
//
// DATE        PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------  --------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

ULong lul_ioctl

If ab_blocking Then
	lul_ioctl = 0	// make the socket blocking
Else
	lul_ioctl = 1	// make the socket non-blocking
End If

Return of_IoctlSocket(al_socket, "FIONBIO", lul_ioctl)

end function

public function boolean of_shutdown (longptr al_socket, long al_how);// -----------------------------------------------------------------------------
// FUNCTION:	of_Shutdown
//
// PURPOSE:		This function disables sends or receives on a socket.
//
// ARGUMENTS:  al_socket	- Open socket
//					al_how		- Type of action to disable:
//										SD_RECEIVE, SD_READ, SD_BOTH
//
// DATE			PROG/ID		DESCRIPTION OF CHANGE / REASON
// ----------	--------		-----------------------------------------------------
// 01/01/2018	RolandS		Initial coding
// -----------------------------------------------------------------------------

Long iResult

PopulateError(0, "shutdown")
iResult = shutdown(al_socket, al_how)
If iResult = 0 Then
	Return True
Else
	il_LastErrorNum = WSAGetLastError()
	Return False
End If

end function

on n_winsock.create
call super::create
TriggerEvent( this, "constructor" )
end on

on n_winsock.destroy
TriggerEvent( this, "destructor" )
call super::destroy
end on

