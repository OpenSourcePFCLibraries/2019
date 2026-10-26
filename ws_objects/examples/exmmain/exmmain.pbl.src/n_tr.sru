$PBExportHeader$n_tr.sru
forward
global type n_tr from pfc_n_tr
end type
end forward

global type n_tr from pfc_n_tr
end type
global n_tr n_tr

forward prototypes
public function long of_begin ()
end prototypes

public function long of_begin ();//////////////////////////////////////////////////////////////////////////////
//
//	Function:  of_Begin
//
//	Access:  public
//
//	Arguments:  none
//
//	Returns:  long
//
//	Description:  Begin a transaction.  With AutoCommit off, the database interface
//		already has one open (it starts the next one at each COMMIT or ROLLBACK), so
//		there is nothing to do: a Begin Transaction would start a nested transaction,
//		and the COMMIT that ends the logical unit of work would not commit it.
//		With AutoCommit on, Begin Transaction starts one.
//
//////////////////////////////////////////////////////////////////////////////

long ll_rc

If Not this.AutoCommit Then Return 1

ll_rc = of_Execute("Begin Transaction")
If ll_rc = 0 Then
	Return 1
End If

Return ll_rc
end function

on n_tr.create
call transaction::create
TriggerEvent( this, "constructor" )
end on

on n_tr.destroy
call transaction::destroy
TriggerEvent( this, "destructor" )
end on

