# 4d-tips-extend-data-class
セット演算やループ処理よりもスマートなクエリの書き方

### やりたいこと

1対Nリレーションで結ばれたテーブルがあります。`[Customer]`は顧客，`[Purchase]`は売上伝票です。「直近購入日の売上データが特定の条件を満たしている顧客」を抽出したいと考えています。

<img width="358" alt="スクリーンショット 2022-02-04 10 53 41" src="https://user-images.githubusercontent.com/1725068/152459539-55453a1a-4a26-4a81-9381-b7498df9005e.png">

クラシックなクエリの書き方だと下記のようになるかもしれません。

```4d
CREATE EMPTY SET([Customer]; "customers")
ALL RECORDS([Customer])  //すべての顧客につき
For ($i; 1; Records in selection([Customer]))
	RELATE MANY([Customer])  //売上を抽出
	ORDER BY([Purchase]; [Purchase]date; <)  //直近購入日を求める
	$date:=[Purchase]date  //直近購入日に複数の購入があるかもしれないので
	QUERY SELECTION([Purchase]; [Purchase]date=$date; *)  //この日付で絞り込む
	QUERY SELECTION([Purchase]; [Purchase]status="foo")  //条件を満たしていれば
	If (Records in selection([Purchase])#0)
		ADD TO SET([Customer]; "customers")  //セットに追加する
	End if 
	NEXT RECORD([Customer])
End for 
USE SET("customers")
CLEAR SET("customers")
```

仮に顧客が`4000`あれば`4000`回のループ処理の中でセット演算を実行します。ロジックはシンプルですが，`NEXT RECORD` `ADD TO SET`のようにネットワークリクエストを発生させるコマンドを多用することになり，`RELATE MANY` `ORDER BY` `QUERY SELECTION`のようなデータベース処理も多発します。もっとスマートな書き方はないのでしょうか。

### どうするか

`[Purchase]`テーブルのデータクラスを拡張します。

```4d
Class extends DataClass

Function getLastPurchasesWithStatus($status : Text; $options : Object)->$purchases : cs.purchaseSelection
	
	$purchases:=This.query("status == :1 and :2"; $status; Formula(This.date=This.customer.purchases.date.max()); $options)
```

ORDAでクエリができるようになります。

```4d
$purchases:=ds.Purchase.getLastPurchasesWithStatus("foo") //売上
$customers:=$purchases.customer //顧客
```

売上が必要なければ`[Customer]`テーブルのデータクラスを拡張することもできます。

```4d
Class extends DataClass

Function getCustomersWithLastPurchaseStatus($status : Text)->$customers : cs.customerSelection
	
	$customers:=ds.Purchase.getLastPurchasesWithStatus($status).customer
```

前述したクエリはこのようになります。

```4d
$customers:=ds.Customer.getCustomersWithLastPurchaseStatus("foo")
```

### ORDAのメリット

まず，セット演算やループなどのプログラミングが省略され，コードがシンプルかつ直感的です。

舞台裏を覗きたければ，クエリプランとクエリパスを出力させることができます。

```4d
$options:=New object("queryPlan"; True; "queryPath"; True)
$purchases:=ds.Purchase.getLastPurchasesWithStatus("foo"; $options)
```

* クエリプラン

```js
{
	"And": [
		{
			"item": "[index : Purchase.status ] == foo"
		},
		{
			"item": "$(This.date=This.customer.purchases.date.max())"
		}
	]
}
```

* クエリパス

```js
{
	"steps": [
		{
			"description": "AND",
			"time": 9960,
			"recordsfounds": 1137,
			"steps": [
				{
					"description": "[index : Purchase.status ] == foo",
					"time": 0,
					"recordsfounds": 99726
				},
				{
					"description": "$(This.date=This.customer.purchases.date.max())",
					"time": 9960,
					"recordsfounds": 1137
				}
			]
		}
	]
}
```

インデックスクエリ・リレーション・フォーミュラによるクエリと`AND`演算をデータベースエンジン内で組み合わせて実行していることがわかります。

クライアント側でループ処理をしているわけではなく，リクエストを投げてレスポンスを受け取っているだけなので，ネットワーク通信も最小限に抑えることができます。

そのままREST APIとして公開し，[外部システムからHTTPでこのクエリを呼び出す](https://developer.4d.com/docs/ja/REST/classFunctions.html)こともできます。
