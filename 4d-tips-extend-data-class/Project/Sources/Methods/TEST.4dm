//%attributes = {}
TRUNCATE TABLE:C1051([Customer:1])
TRUNCATE TABLE:C1051([Purchase:2])

For ($i; 1; 4000)
	
	$c:=ds:C1482.Customer.new()
	$c.name:="customer#"+String:C10($i)
	$c.save()
	
	For ($ii; 1; 100)
		
		$p:=ds:C1482.Purchase.new()
		$p.date:=Add to date:C393(!2022-01-01!; 0; 0; Random:C100%365)
		$p.customer_id:=$c.id
		$p.status:=Choose:C955(Random:C100%4; "foo"; "boo"; "moo"; "woo")
		$p.save()
		
	End for 
	
End for 

