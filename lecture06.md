# lecture06課題

## ClouTrailで最後に発生したEventを見つける
- CloudTrail サービスで新しい Trail を作って、log を記録してみました
- 作られたlogはすべてs3に保存されます
- 保存されたファイルはjsonです、その中を見ると、key:valueのような形で情報が保存されています
- <code>userIdentity</code> というkeyの中にIDやユーザーネームなどの情報が入っています
- <code>eventTime</code> や <code>awsRegion</code> などのkeyはイベントが発生した時間など、どのRegionに発生したのかという情報を確認できます
- メインで見る情報としては<code>eventName</code>ですね
> <img width="487" alt="Screenshot 2022-08-26 163434" src="https://user-images.githubusercontent.com/103508472/186850995-e76d8140-0819-4592-b88d-39b9c861e030.png">
> <br> 今回のlogは CloudWatch で alarm を作ったlogでした <code>requestParameters</code> でalarm作成する際の詳細も照会できます

## CloudWatch Alarm
- Alarmを作って、SNSサービスでメールへ通知を送るようにしました
- ここでsshでEC2のNginxサーバーをstopして、target group の　health check をわざと通らせないようにしてみると：
 > <img width="435" alt="Screenshot 2022-08-26 163921" src="https://user-images.githubusercontent.com/103508472/186851028-3b074bf6-307c-4023-af69-2a64f7cd3311.png">
 > <br> ELB の healthy host (EC2) が1個より少ない（すべてのhealthy host も unhealthy になったら）場合はSNSサービスで通知が来るように設定しています
- サーバーを再起動して、health check を合格ように設定しなおしたら：
 > <img width="448" alt="Screenshot 2022-08-26 163936" src="https://user-images.githubusercontent.com/103508472/186851236-b420763a-9b0d-42e8-bf63-729d16a04578.png">
 > <br> ELB の unhealthy host (EC2) が 1個より少ない（unhealthy host がなくなったら）場合は　OK　の状態になって、SNSサービスで通知が来るように設定しています

## AWS利用料金見積
- 5回目講座の課題で設定したアプリの環境を見積もった結果：
- https://calculator.aws/#/estimate?id=3f2e4146393716a116b1e796c84fde9473980a51
- アプリのデプロイは思ったよりお金がかかるのをなんとなくわかりました。
- RDSは意外とそんなに高くはなかったのです、用量が少なかったのもあるかもしれないですが。

## Consoleで利用料金の照会
- 下記の画像は今月使った料金の画面です。EC2の使用時間＆EBSの使用容量は<code>free tier</code>の中に納まっています
> <img width="772" alt="Screenshot 2022-08-26 161206" src="https://user-images.githubusercontent.com/103508472/186853250-5916afc3-9d54-497f-8b6e-bf4745a4ca5c.png">
> <br> elastic ip は EC2 を停止にするとお金かかるの知らなかったです、でもbudgetが設定してあったおかけで、メールが来た後にすぐ調整できました。
- 下記は<code>free tier</code>の使用量の照会画面です
> <img width="701" alt="Screenshot 2022-08-26 161048" src="https://user-images.githubusercontent.com/103508472/186853707-dea36438-eb63-4661-af7e-78dc03d2d640.png">
- 料金を気づかずにとられるとやばいですので、budgetを設定して管理しています
> <img width="687" alt="Screenshot 2022-08-26 170533" src="https://user-images.githubusercontent.com/103508472/186854186-8a07c8a9-293a-41df-af05-eb9cb8571f48.png">
- 設定された Simple Budget は前にtutorialで設定したもので、budget-for-learningはRaiseTechの講座を始まった後に設定したものです、どちらもglobal用量のbudgetですが、もっと多くのサービスを使うようになったらサービス別でbudgetを設定するようにします（今は合計金額を簡単に照会できるようにしたいのでglobalで設定しています）
