
# lecture04で学んだこと


<img width="683" alt="image" src="https://user-images.githubusercontent.com/103508472/183030203-00ec5830-1110-4ec6-b827-213d01f516b4.png">


## VPC
- x.x.x.x/xx のIPv4の設定でネットワークとホストの数を決めて（/xxの subnet mask で）、VPCを作れる
- 中にsubnetを設定できる、外とつなげるinternet gateway、subnetとつなげるroute table などを設定できる

## Available Zone
- AZはVPCの中に複数あるが、subnetは一つAZの中に作るもの
- **DBを作るときに必ず2つ以上のAZをカバーしないといけない**（片方のAZがダウンしたときにもう一つが通常通り動けるために）

## subnet(public & private)
- アプリを処理するパソコン（EC2 instance）とDBエンジンを処理するRDSに分けるpublic & private の subnet を作るのが基本的な設計

## security group & Network-ACL
 - SG: Instanceごとに設定する、statefulのため、インバウンドでinstanceに入れるリクエストはアウトバウンドでも許可させる
 - N-ACL: Subnetごとに設定する、statelessのため、インバウンドリクエストは許可されてもアウトバウンドで許可されない場合もある（ユーザー設定によって）

## EC2を作って (public)、RDSに接続

>  PS C:\WINDOWS\system32> ssh -i "C:\Users\roche\OneDrive\桌面\kurisu\RaiseTech_Projects\RaiseTechKP.pem" ec2-user@ec2-18-183-164-179.ap-northeast-1.compute.amazonaws.com <br>
>  The authenticity of host 'ec2-18-183-164-179.ap-northeast-1.compute.amazonaws.com (18.183.164.179)' can't be established.<br>
>  ECDSA key fingerprint is SHA256:IpQAYNsNB/gq2HGVQU6VZ2IxxgpSoKwgEOac1HWSDSU. <br>
>  Are you sure you want to continue connecting (yes/no/[fingerprint])? yes <br>
>  Warning: Permanently added 'ec2-18-183-164-179.ap-northeast-1.compute.amazonaws.com,18.183.164.179' (ECDSA) to the list of known hosts.
>
>         __|  __|_  )
>         _|  (     /   Amazon Linux 2 AMI
>        ___|\___|___|

>> EC2へsshでログイン

## EC2 から MySQL への接続
![image](https://user-images.githubusercontent.com/103508472/182993086-7ca42b62-1595-4c8f-9338-4ed821be235b.png)

画像の中に：

> 1. MySQLにログインするための必要の`.pem`ファイル（AWS EC2 が必要のkey pair ファイルと同じextension）をダウンロード
> 2. `ls`でダウンロードしたファイルを確認
> 3. sslでmysqlへ接続
> 4. MySQLを`quit;`して
> 5. 最後は`exit`でEC2のssh接続からlogoutした



## VPC Diagram を描いてみた

<img width="703" alt="image" src="https://user-images.githubusercontent.com/103508472/183028196-774d4024-a447-41d0-9d60-010a570f20b9.png">

### Diagramについて
>　感想：手書きで少し**要注意**な感じなところをハイライトで書いてみました <br>
>　疑問：現場のところでこんな感じの手書きの解説は実際に使われるでしょうか
