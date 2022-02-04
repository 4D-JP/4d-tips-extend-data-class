Class extends DataClass

Function getCustomersWithLastPurchaseStatus($status : Text)->$customers : cs:C1710.customerSelection
	
	$customers:=ds:C1482.Purchase.getLastPurchasesWithStatus($status).customer