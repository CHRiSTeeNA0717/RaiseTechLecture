# ５回目lecture課題提出

## EC2上にサンプルアプリケーションをデプロイ
- EC2でのデプロイは、自分のパソコンのeditor上 <code>rails s</code> を押せる<code>env</code>を作るのを想像すれば理解しやすいですね
- sshで入って、updateなどして行って、Rubyをinstall、Railsをinstall、アプリをgit clone、、、ここまではcloud9でやったこととほぼ同じですね、localhost:3000で<code>rails s</code>を実行できるはず
> <img width="348" alt="Screenshot 2022-08-18 031852" src="https://user-images.githubusercontent.com/103508472/185762689-5dd55b8f-074c-4fce-8dc1-b0ec6ce1176b.png">
> <br>SHELLの中に<code>bundle exec rails s -b 0.0.0.0</code>を実行すると、URLのところに[IP]:3000でアプリを見れます


- そのあとはnginxというweb server をinstallして、unicorn の AP server が必要なconfを設定して起動すれば、このEC2サーバーは正常に働いてくれるはず
> <img width="902" alt="Screenshot 2022-08-20 033859" src="https://user-images.githubusercontent.com/103508472/185762791-ae6b8aca-86b3-4425-92b2-251aafd7920c.png">
> <br>今はIPだけでアプリをアクセスできるようになってます

## ELBを追加
- ALBを作って、target group にこのEC2を追加して、target group をALBに紐付ければ、ALBはWEBトラフィックをtarget group にparseして、target group はそのトラフィックをprivate traffic にtranslateして、紐付けられたEC2にparseするようになります
><img width="726" alt="Screenshot 2022-08-20 045747" src="https://user-images.githubusercontent.com/103508472/185762930-7f320a14-26c6-47ea-b648-2a9ee902e446.png">
> <br>Load Balancer のところに、このtarget group がついているALBの名前を確認できる
- この時点で、アプリはproductionであれば、すべてのhostsも許可してるはずなので、アプリ側に特に何もしなくても、ALBのDNSでアクセスできるようになってるはず
> <img width="814" alt="Screenshot 2022-08-21 013047" src="https://user-images.githubusercontent.com/103508472/185763014-f962cbd2-6c6e-40e9-b202-f5b1989cc1af.png">

## S3を追加
- S3 bucket を作って、ファイルをuploadできるようにします
- Railsのなかのcredentials.ymlを編集して、S3のaccess keyなどを設定して、config/storage.yml にamazonを指定すれば動作するはず
- consoleの中でも簡単にuploadすることもできるので、思ったより使いやすかったです
> <img width="847" alt="Screenshot 2022-08-21 035502" src="https://user-images.githubusercontent.com/103508472/185763119-85c26442-afc1-4ebe-8f5e-3503ef1d8282.png">
