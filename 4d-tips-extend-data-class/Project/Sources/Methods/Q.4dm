//%attributes = {}
$customers:=ds:C1482.Customer.getCustomersWithLastPurchaseStatus("foo")

$purchases:=ds:C1482.Purchase.getLastPurchasesWithStatus("foo")
$customers:=$purchases.customer
