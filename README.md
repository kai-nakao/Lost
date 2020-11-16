# Lost

![color:ff69b4](https://img.shields.io/badge/swift-5.0-00FF00.svg?longCache=true)
![color:ff69b4](https://img.shields.io/badge/license-MIT-C0C0C0.svg?longCache=true)
![color:ff69b4](https://img.shields.io/badge/Twitter-@kai20000803-FFFF00.svg?longCache=true)
![color:ff69b4](https://img.shields.io/badge/GoogleMapsSDK-4.0-FF6600.svg?longCache=true)
![color:ff69b4](https://img.shields.io/badge/Firebase-5.0.0-FF0000.svg?longCache=true)

# アプリの概要
ーーー
このアプリは落とし物を誰かの投稿の位置情報に基づいて落とし物を見つけることや落とし物を投稿することによって誰かを助けることができるアプリです。

# 作った目的
---
- 落とし物もTwitterのように即時生があれば便利だなと思ったから。
- 落とし物を位置情報の基づいて検索できたら便利だと思ったから。
- 落とし物の預け先を固定することによって落とし物の受け取りに振り回されないようにしたかったから。

# 機能一覧
---
- ログイン,アカウント作成
- 位置情報に基づいた投稿
- 位置情報に基づいた検索
- 受け取り完了ボタンによりデータ削除
- アカウント情報の編集
- 位置情報取得

# 使ったスキル一覧
---
- corelocation
- Firestore
- Firestorage
- GoogleMapsSDK

# こだわったポイント
---
- FloatingPanelを採用した
- FloatingPanelにとピンに相互性を持たせてピンの大きさを変える。
![demo](https://gyazo.com/fe7318b98609bdb8bc0093e7cda52e3a/raw)
特に大変だったソースコード

- 投稿する時にカメラで撮るのかライブラリから選ぶのかの選択肢をalertActionで表示させた
- FloatingPanelの表示具合
　

![demo](https://gyazo.com/bb3a8684d647fb9714fe0505f04ae7ae/raw)
# 苦労したポイン
---
- FloatingPanelを実装したこと
　FloatingPanelは全然記事がなく、公式の英語の記事を頑張って読んで試行錯誤しながら実装していきました。
 < https://github.com/SCENEE/FloatingPanel
- 

