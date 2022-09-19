# lecture11課題
## 今回学んだこと
- 今までのインフラ構築では、メインゴールを設定して、そのあとサブゴールを設定して、0から開発していくような形でした。
- 今回紹介された方法ではテストをメインにした開発、test driven development、での構築です
- 達成したいことをテスト項目として、様々なツールでテストしながら開発するというやり方
- テストをrunするともちろんすべて不合格（環境はそもそもまだ作っていないので）、そしてテスト項目を満たされるようにテストしながら構築していくというやり方になります。
- テスト項目の設定は、clientからの要求を設定すれば多分問題はありません。テストがすべて合格であればclientの要求がすべて満たされているということになります。
- 重要：テストをするのは、実際に物を作るということで、責任問題が生じるところなので、作る時点で仕様に問題があるかを発見しやすいというメリットもある

## serverspecを使ってEC2インスタンスのインフラをテストする
- 使い方はとても簡単なツールです
- 1. マシンは２個あります：開発者用<code>dev</code>のマシンと構築している<code>client</code>のマシン
- 2. <code>client</code>のほうはテストを実行したいマシンですが、何もいじらなくても実行できるので、bugなどの心配は排除できる
- 3. <code>dev</code>のほうにserverspecをinstallして、テスト項目を変更できるファイルは<code>"/spec/[host]/sample_spec.rb"</code>で自動で作られているので、中の項目を実際にテストしたい項目に変更すれば大丈夫
- 4. <code>rake spec</code>のコマンドを実行すれば、serverspecはsshで<code>client</code>のマシンへアクセスしてテストを行う
- 5. 結果はCLIで表示される

## はまりポイント
- 個人的にはsshがうまく接続できなかったんです
- EC2に接続するためのkeypairをserverspecに渡せないというところにはまりました
- <img width="738" alt="Screenshot 2022-09-10 075441" src="https://user-images.githubusercontent.com/103508472/189456219-186c0af3-0903-41b6-a92b-8eb199d0fd7f.png">
- > 画像のように、passwordが聞かれても、keypairを渡せないのでログインができないという状況
- serverspecのファイルにどこかで設定できると思って、調べても答えはなかった
- 結局、sshに関して調べてみると、実は<code>/.ssh</code>の中に、<code>config</code>のファイルを作れって、localのkeypairのpathを入れれば、対象マシンのhostnameをCLIで<code>ssh [hostname]</code>で接続すると、keypairのpathを入力せずにloginできるようになる。
- <img width="421" alt="Screenshot 2022-09-10 080236" src="https://user-images.githubusercontent.com/103508472/189456886-9a23a502-bc5a-4c05-aa25-ecba9503d491.png">
- > 画像のように、<code>IdentityFile</code>にkeypairのpathを書けば大丈夫

## テスト実行
- 実際にテストをやってみました
- <code>sample_spec.rb</code>は講座に提供されたサンプルで上書きしました、そしてport22もテスト項目に追加してみました。
```
  require 'spec_helper'

  describe package('nginx') do
    it { should be_installed }
  end

  describe port(80) do
    it { should be_listening }
  end

  # 自分で追加したもの
  describe port(22) do
    it { should be_listening}
  end

  describe command('curl http://127.0.0.1:#{listen_port}/_plugin/head/ -o /dev/null -w "%{http_code}\n" -s') do
    its(:stdout) { should match /^200$/ }
  end
```
> sample_spec.rb
- 実行して、結果は下記のように
- <img width="741" alt="Screenshot 2022-09-10 054111" src="https://user-images.githubusercontent.com/103508472/189457460-4ab94ef6-b95e-4300-9cac-dde245dafac7.png">
- テストする４つの項目とも成功
