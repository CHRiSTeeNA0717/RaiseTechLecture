## AP サーバー
- Railsといえばpumaみたいなもの、コマンド Rails s で起動できるサーバー（dev環境では）、WEBサーバーをアプリと繋ぐ機能を担当している
- このサーバーを終了させれば、アプリそのものが動作できなくなって、WEBからアクセスできなくなる（404、ページが見つからないなどのエラー）

## DB　サーバー
- データベースを管理するサーバー、アプリとほぼ関係ないサーバー。アプリはSQLなどの言語でDBサーバーにアクセスする
- 今サンプルアプリで使っているDBエンジンはmysqlの8.0.29バージョン
>> CHRiSTeeNA:~/environment/raisetech-live8-sample-app (main) $ mysql --version
>> mysql  Ver 8.0.29 for Linux on x86_64 (MySQL Community Server - GPL)
- DBサーバーを終了させたら、データベースへのアクセスができなくなるので、その辺のERRが発生する（cloud9では　can't connect through mysql socket　などのエラー）
- DBユーザーネームなどが間違ってることも同じようなエラーが発生

## Railsの構成管理ツール
- RoRのアプリに必要なライブラリーはすべてgemfileに名前とバージョンが記載され、bundlerで管理やinstallすることができる
