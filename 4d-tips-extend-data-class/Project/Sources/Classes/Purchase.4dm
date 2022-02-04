Class extends DataClass

Function getLastPurchasesWithStatus($status : Text; $options : Object)->$purchases : cs:C1710.purchaseSelection
	
	$purchases:=This:C1470.query("status == :1 and :2"; $status; Formula:C1597(This:C1470.date=This:C1470.customer.purchases.date.max()); $options)