kickstart_kensyou
=================

## これは何?
centos 6/redhat 6 用の kickstart file を自動生成します
また、フロッピーイメージを作成するスクリプトも付いています

## 主な特徴
- ruby erb テンプレートを用いた自動生成
- テンプレートを編集することで用意に内容を変更可能
- フロッピーイメージを作成するスクリプトを同梱

## インストール
1. 事前確認
  - 動作は ruby 1.9.3 で確認しています。(2.0.0 系でも動くと思います)

1. git clone
  ```bash
  git clone https://github.com/soel/kickstart_kensyou.git
  ```

1. bundle install
  ```bash
  bundle install
  ```

## 使い方
1. kickstart ファイルの作成
  ```bash
  ruby kensyo_ks.rb <hostname> <ip address> <root password>
  ```
1. /mnt/vfd の作成
  /mnt/vfd でフロッピーイメージを作成するので必要となります
  ```bash
  mkdir /mnt/vfd
  ```
1. フロッピーイメージの作成
  ```bash
  sudo ruby floppy_image_maker.rb <source_file> <out_put_image>
  ```
  mount 処理等で sudo の権限が必要になります

## その他情報
- <ip address> 部にはバリデーションがかかっていて IP アドレス形式以外は入力できません
- インストールされるバッケージは Basic server 相当です。詳しくは ks.cfg.erb の %packages 以下を参照してください

## ライセンス
- LICENSE.txt を御覧ください
- MIT ライセンスです
