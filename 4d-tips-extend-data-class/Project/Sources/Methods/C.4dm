//%attributes = {}
CREATE EMPTY SET:C140([Customer:1]; "customers")
ALL RECORDS:C47([Customer:1])  //すべての顧客につき
For ($i; 1; Records in selection:C76([Customer:1]))
	RELATE MANY:C262([Customer:1])  //売上を抽出
	ORDER BY:C49([Purchase:2]; [Purchase:2]date:3; <)  //直近購入日を求める
	$date:=[Purchase:2]date:3  //直近購入日に複数の購入があるかもしれないので
	QUERY SELECTION:C341([Purchase:2]; [Purchase:2]date:3=$date; *)  //この日付で絞り込む
	QUERY SELECTION:C341([Purchase:2]; [Purchase:2]status:4="foo")  //条件を満たしていれば
	If (Records in selection:C76([Purchase:2])#0)
		ADD TO SET:C119([Customer:1]; "customers")  //セットに追加する
	End if 
	NEXT RECORD:C51([Customer:1])
End for 
USE SET:C118("customers")
CLEAR SET:C117("customers")
