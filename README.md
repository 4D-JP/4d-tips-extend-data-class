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
	ORDER BY([Purchase]; [Purchase]date; <)  //直近購入日の売上データ
	If ([Purchase]status="foo")  //条件を満たしていれば
		ADD TO SET([Customer]; "customers")  //セットに追加する
	End if 
	NEXT RECORD([Customer])
End for 
USE SET("customers")
CLEAR SET("customers")
```

仮に顧客が`4000`あれば`4000`回のループ処理の中でセット演算を実行します。ロジックはシンプルですが，`NEXT RECORD` `ADD TO SET`のようにネットワークリクエストを発生させるコマンドを多用することになり，`RELATE MANY` `ORDER BY`のようなデータベース処理も多発します。もっとスマートな書き方はないのでしょうか。
