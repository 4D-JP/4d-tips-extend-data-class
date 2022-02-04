//%attributes = {}
$options:=New object:C1471("queryPlan"; True:C214; "queryPath"; True:C214)
$purchases:=ds:C1482.Purchase.getLastPurchasesWithStatus("foo"; $options)

SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217($purchases.queryPlan; *))
TRACE:C157

SET TEXT TO PASTEBOARD:C523(JSON Stringify:C1217($purchases.queryPath; *))
TRACE:C157