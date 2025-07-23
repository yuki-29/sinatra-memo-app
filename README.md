# README


## アプリ名称
・メモアプリ

## 機能の概要
・Webブラウザを使用したメモアプリケーション

## 使い方
- メモの新規作成ボタンで、メモを新規に作成します。
- 保存ボタンで、メモ内容を保存します。
- メモは、`DB:memos_app`に保存されます。
- 作成したメモは、トップページのメモリストにメモのタイトルが一覧で表示されます。
- メモリストのタイトルをクリックすると、メモの内容が確認できます。
- 変更ボタンを押すと、メモ内容を変更できます。変更するボタンで、上書き保存します。
- 削除ボタンを押すと、メモの内容が削除されます。

## 使用環境
- Ruby (3.2.8)
- Sinatra (4.1.1)
- postgresql@17

## インストール方法、セットアップ
- 本アプリケーションのリポジトリでフォークを実行

- フォークしたリポジトリをリモートリポジトリにクローンする。
```
git clone git@github.com:yuki-29/sinatra-memo-app.git
```
- クローンされたディレクトリに移動
```
$ cd sinatra-memo-app
```
- Bundle installしたときのインストール先を設定
```
$ bundle config set path ‘vendor/bundle’
```
- bundlerをインストール（未インストールの場合）
```
$ gem install bundler
```
- インストールしたbundlerを使用可能な状態にする
```
$ rbenv rehash
```
- Gemfileの内容に従って、gemをインストール
```
$ bundle install
```
- `memos_app`というデータベースを作成
※postgreSQLを予めインストールし、ログインしていること。
```
CREATE DATABASE memos_app;
```
- データベースに接続
```
\connect memos_app;
```
- データベースに`memos`テーブルを作成
```
memos_app=# CREATE TABLE memos (
id serial,
title text,
content text,
primary key (id));
```

- Ruby上でWEBサーバーを起動
```
$ bundle exec ruby memo.rb
```
- Webブラウザで下記URLにアクセス
```
http://localhost:4567
```

## ライセンス
このリポジトリは学習目的で作成したものです。
一部コードは教材やインターネット上の情報を参考にしています。
商用利用・再配布はご遠慮ください。
