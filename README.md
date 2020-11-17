# Lost

![color:ff69b4](https://img.shields.io/badge/swift-5.0-00FF00.svg?longCache=true)
![color:ff69b4](https://img.shields.io/badge/license-MIT-C0C0C0.svg?longCache=true)
![color:ff69b4](https://img.shields.io/badge/Twitter-@kai20000803-FFFF00.svg?longCache=true)
![color:ff69b4](https://img.shields.io/badge/GoogleMapsSDK-4.0-FF6600.svg?longCache=true)
![color:ff69b4](https://img.shields.io/badge/Firebase-5.0.0-FF0000.svg?longCache=true)


# アプリの概要
---
このアプリは落とし物を位置情報に基づいて投稿や検索ができます。


# このアプリを作った目的
---

- 位置情報に基づいた検索
- 預け先を指定することによって受け取る場所の明確化
  
  この二点を実現するためです。

# 機能一覧
---
- ログイン、アカウント作成
- 位置情報に基づいた投稿
- 位置情報に基づいた検索
- 受け取り完了ボタンによりデータ削除
- アカウント情報の編集
- 位置情報取得

# 使ったライブラリ/フレームワーク一覧
---
- Core Location(https://developer.apple.com/documentation/corelocation)
- Firestore
- Firestorage
- GoogleMapsSDK
- FloatingPanel
# 投稿の仕方
---
トップ画面でカメラボタンを押します。
次の画面で落とし物を見つけた場所を長押しします。
そうするとalertActionが出るのでどちらか（カメラで撮る or ライブラリ）を選び投稿画面に細かい詳細を入力して投稿ボタンを押すと投稿完了です。

![demo](https://gyazo.com/78efd74ea5358f06d6434e1e00a6d2fb/raw)
# こだわったポイント
---
- FloatingPanelの採用
- FloatingPanelの表示具合

  落とし物を探す上で、写真と落とし物の特徴でまず見つけてから落とし物の詳細を見たいと思うので、初めはtipで写真と特徴だけを表示させてfullで落とし物の情報詳細まで見れるようにしました。
- FloatingPanelにピンとの相互性を持たせてピンの大きさの変化

![demo](https://gyazo.com/fe7318b98609bdb8bc0093e7cda52e3a/raw)

- 投稿する時にカメラで撮るのかライブラリから選ぶのかの選択肢をalertActionで表示


 ![demo](https://gyazo.com/bb3a8684d647fb9714fe0505f04ae7ae/raw)
 
 # 投稿の仕方
---
トップ画面でカメラボタンを押します。
次の画面で落とし物を見つけた場所を長押しします。
そうするとalertActionが出るのでどちらか（カメラで撮る or ライブラリ）を選び投稿画面に細かい詳細を入力して投稿ボタンを押すと投稿完了です。

![demo](https://gyazo.com/78efd74ea5358f06d6434e1e00a6d2fb/raw)
 
# 苦労したポイント
---
- FloatingPanelを実装したこと
　FloatingPanelは全然記事がなく、公式の英語の記事を頑張って読んで試行錯誤しながら実装していきました。
  参考にしたものを共有します。
  > https://github.com/SCENEE/FloatingPanel
 
- FloatingPanelとピンの大きさに相互性を持たせること
 特にその中でも苦労したのはFloatingPanelをスワイプして消した時に選択中だったピンの大きさを元に戻すことです。
そのソースコードを共有します。


```swift:SearchViewController.swift
func floatingPanelWillRemove(_ fpc: FloatingPanelController) {
        selected_marker.icon = self.imageWithImage(image: UIImage(named: "pin")!, scaledToSize: CGSize(width: 32.0, height: 37.0))
}
```

初めはfloatingPanelDidRemoveメソッドを使っていたのですが、これではそのメソッドが呼ばれるスピードが遅くなってしまいました。その問題の解決のために英語の公式の記事を読んでその中で近いものを試し、やっとの思いでこのメソッドにたどり着きました。
これが一番苦労したポイントです。

# ユーザ目線で少し意識したこと
---
位置情報系アプリは上部にボタンがあるものもあるのですが、ユーザビリティを考えてボタンを下部に配置しました。


