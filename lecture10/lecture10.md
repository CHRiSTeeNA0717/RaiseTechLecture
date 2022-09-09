# Cloud Formation
> AWSコンソールで構築するものをコード化する機能
- 構築するものはtemplateにコードを書いて(.ymlか.json)、AWSコンソールにstackを作る

## フォーマット
- メインのフォーマットは5種類ある
- 1. AWSTemplateFormatVersion：最新のバージョンは”2010-09-09”
- 2. Description：templateの説明
- 3. Parameters：Stackを作るときに、その場合に必要なものをvariableみたいな感じで入力できる
- 4. Resources：構築したいAWSのなかのresource(もしくはサービス)を書く
- 5. Output：構築終わった後に表示させたいもの、eg: IP address, instanceの名前, etc

## Templateを作る
-今回作ったtemplateはVPC、Subnet、IGW、Route Table、Security Groupを含めた環境です（今まで作ったもの）、とApacheを実装したEC2のinstance一つです、"Hello World from HOSTNAME" のページを表示されるものです

## 難所
- コンソールと一番の違いは、実際に構築するもののparameterや設定などを覚えないと書けないことです。
- コンソールではGUIで操作して、必要な設定もすべて目の前にformを入力するだけですので、聞かれたものを回答するのみでした。
- Cloud Formation は空白の紙に必要な設定を知らないと全く設定できないことです