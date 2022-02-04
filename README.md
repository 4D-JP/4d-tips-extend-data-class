# 4d-tips-extend-data-class
セット演算やループ処理よりもスマートなクエリの書き方

### やりたいこと

1対Nリレーションで結ばれたテーブルがあります。`Customer`は顧客，`Purchase`は売上伝票です。「直近購入日の売上データが特定の条件を満たしている顧客」を抽出したいと考えています。

<img width="358" alt="スクリーンショット 2022-02-04 10 53 41" src="https://user-images.githubusercontent.com/1725068/152459539-55453a1a-4a26-4a81-9381-b7498df9005e.png">

