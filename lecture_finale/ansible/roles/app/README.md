# JP
## RaiseTech Rails Sample App プロビジョニング
- git clone
- オーナーをec2ユーザーにチェンジ
- mysql client インストール
- dbの環境変数を設定
- bundle インストール
- コンフィグを"nginx/conf.d/"にコピー
> サーバーIPはplaybookに定義した"ec2_ip"を代入
- rails db create & migrate
- yarn, webpacker をインストールしてコンパイル
- unicorn起動 & nginx再起動（handlerより）


# EN
## Config RaiseTech Rails Sample App in EC2
- clone app from git repo
- change owner
- install mysql client version 8.0 
- set environment for database and RDS endpoint
- install bundle (including rails)
- add unicorn config file to nginx conf.d folder
> server in the conf file will be inserted will variable defined in playbook which is "ec2_ip"
- create rails db and migrate
- install yarn, webpacker and compile
- start unicorn and notify handler to restart nginx